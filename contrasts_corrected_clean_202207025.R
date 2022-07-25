library('tidyverse')
library("mvtnorm")

set.seed(2022-01-25)

## Effect and vcov estimates:
setwd("C:/Users/zxd598/Desktop/Corona/Manuskripter 2022/ba1ba2 figur")
effects <- read_csv("Model1_parms_dummy_2.csv", skip=0)
vcov <- read_csv("Model1_CovParms_dummy_2.csv", skip=0)

# Sense checking:
# bind_cols(effects$Variable, vcov$Parameter, dimnames(vcov)[[2]][-1]) %>% print(n=Inf)
# plot(effects$StdErr^2, unlist(sapply(1:nrow(vcov), function(i) vcov[i,i+1]))); abline(0,1)


bind_cols(colnames(vcov)[-1], vcov[,1]) %>% print(n=Inf)
# Function to adjust for small non-symmetries:
mat <- as.matrix(vcov[,-1])
for(i in 1:nrow(mat)){
  for(j in 1:nrow(mat)){
    mat[i,j] <- mat[j,i]
    if(mat[j,i]!=mat[i,j]) cat(i, '-', j, "\n")
  }
}


## Posteriors based on variance-covariance matrix:
iters <- 1e5 #1e4
est <- rmvnorm(iters, mean = effects$Estimate, sigma = mat)
#est <- rmvnorm(iters, mean = effects$Estimate, sigma = vcov)
posteriors <- tibble(ParameterEst = rep(effects$Variable, each=iters), ParameterVC = rep(vcov$Parameter, each=iters), Iteration = rep(1:iters, length(effects$Estimate)), Estimate = as.numeric(est)) %>%
	filter(ParameterEst %in% c("Vaccinati*variant_in", "variant_index", "Vaccination_status", "Vaccination_status_i")) %>%
	mutate(Type = case_when(
		ParameterEst == "variant_index" ~ "BA2",
		str_detect(ParameterVC, "_index") ~ "Primary",
		TRUE ~ "Secondary"
	)) %>%
	mutate(Vaccine = case_when(
		ParameterEst == "variant_index" ~ "",
		str_detect(ParameterVC, "Booster") ~ "_Booster",
		TRUE ~ "_None"
	)) %>%
	mutate(Interaction = case_when(
		ParameterEst == "Vaccinati*variant_in" ~ "_Interaction",
		TRUE ~ ""
	)) %>%
	mutate(Parameter = str_c(Type,Vaccine,Interaction)) %>%
	select(Iteration,Estimate,Parameter) %>%
	arrange(Parameter,Iteration) %>%
	pivot_wider(names_from=Parameter, values_from=Estimate) %>%
	mutate(BA1=0, Primary_Fully=0, Primary_Fully_Interaction=0, Secondary_Fully=0, Secondary_Fully_Interaction=0)

variant <- posteriors %>% select(BA1, BA2)
vaccine <- list(
	None = posteriors %>% select(contains("None")) %>% rename_with( ~ str_replace(.x, "_None", "")),
	Fully = posteriors %>% select(contains("Fully")) %>% rename_with( ~ str_replace(.x, "_Fully", "")),
	Booster = posteriors %>% select(contains("Booster")) %>% rename_with( ~ str_replace(.x, "_Booster", ""))
)

## Just use a global point estimate for prevalence:
# prev <- effects %>% filter(Variable=="Intercept") %>% pull(Estimate) %>% plogis()
# TODO: could use the correct prevalence for each contrast, but I don't think it will make much difference...

## Get all possible contrasts of interest:
vacctypes <- c("None","Fully","Booster")
contrasts <- expand_grid(Reference1=vacctypes, Contrast1=vacctypes, Reference2= vacctypes, Contrast2= vacctypes, Type=c("Primary","Secondary","Both"), Variant=c("BA1","BA2","Interaction")) %>%
	mutate(Index = 1:n()) %>%
	split(.$Index) %>%
	pbapply::pblapply(function(x){
		
		if(x$Variant=="Interaction"){
			vnt <- 0
		}else{
			vnt <- variant[[x$Variant]]
		}
		
		ref1 <- vaccine[[x$Reference1]][["Primary"]]
		cont1 <- vaccine[[x$Contrast1]][["Primary"]]
		ref2 <- vaccine[[x$Reference2]][["Secondary"]]
		cont2 <- vaccine[[x$Contrast2]][["Secondary"]]
		ref1i <- vaccine[[x$Reference1]][["Primary_Interaction"]]
		cont1i <- vaccine[[x$Contrast1]][["Primary_Interaction"]]
		ref2i <- vaccine[[x$Reference2]][["Secondary_Interaction"]]
		cont2i <- vaccine[[x$Contrast2]][["Secondary_Interaction"]]
		
		if(x$Variant=="BA1"){
			ref1i <- 0
			cont1i <- 0
			ref2i <- 0
			cont2i <- 0
		}else if(x$Variant=="Interaction"){
			ref1 <- 0
			cont1 <- 0
			ref2 <- 0
			cont2 <- 0
		}
		
		prm <- (cont1+cont1i)-(ref1+ref1i)
		sec <- (cont2+cont2i)-(ref2+ref2i)
		
		if(x$Type == "Primary"){
			rv <- bind_cols(x, tibble(Effect = prm))
		}else if(x$Type == "Secondary"){
			rv <- bind_cols(x, tibble(Effect = sec))
		}else if(x$Type == "Both"){
			if(FALSE){
			# This leads to non-symmetry of contrasts unless I use the precisely correct prevalence for each
			prm_or <- exp(prm)
			sec_or <- exp(sec)
			prm_rr <- prm_or / ((1 - prev) + (prev * prm_or))
			sec_rr <- sec_or / ((1 - prev) + (prev * sec_or))
			bth_rr <- prm_rr * sec_rr
			bth_or <- ((prev-1)* bth_rr) / (prev * bth_rr - 1)
			rv <- bind_cols(x, tibble(Effect = log(bth_or)))
			}
			rv <- bind_cols(x, tibble(Effect = prm+sec))
		}else{
			stop()
		}
		rv		
	}) %>%
	bind_rows()


for(variant in c("BA1","BA2","Interaction")){

## Look at combined effect for potentially differing vaccination states of primary and secondary cases:
summaries <- contrasts %>%
	filter(Reference1!=Contrast1, Reference2!=Contrast2, Type=="Both", Variant==variant) %>%
	group_by(Reference1, Contrast1, Reference2, Contrast2) %>%
	summarise(Estimate = mean(Effect), LCI=quantile(Effect, 0.025), UCI=quantile(Effect, 0.975), .groups="drop") %>%
	arrange(desc(Estimate)) 

summaries %>% print(n=Inf)
write_excel_csv2(summaries, str_c(variant, "_contrasts_all.csv"))

## Look at individual and combined effect of interactions where vaccination states are consistent within household:
summaries <- contrasts %>%
	filter(Reference1==Reference2, Contrast1==Contrast2, Reference1!=Contrast1, Variant==variant) %>%
	group_by(Reference=Reference1, Contrast=Contrast1, Type) %>%
	summarise(Estimate = mean(Effect), LCI=quantile(Effect, 0.025), UCI=quantile(Effect, 0.975), .groups="drop")

summaries %>% print(n=Inf)
write_excel_csv2(summaries, str_c(variant, "_contrasts.csv"))

## Graph:
summaries$Type <- factor(summaries$Type, levels=c("Primary","Secondary","Both"), labels=c("Infectiousness", "Susceptibility", "Combined"))
summaries$ReferenceLab <- factor(summaries$Reference, levels=c("None","Fully","Booster"), labels=c("Reference: None","Reference: Fully","Reference: Booster"))
summaries$ContrastLab <- factor(summaries$Contrast, levels=c("None","Fully","Booster"), labels=c("Contrast: None","Contrast: Fully","Contrast: Booster"))
levels(summaries$Type) <- rev(levels(summaries$Type))

theme_set(theme_bw())
ggplot(summaries, aes(x=Type, y=Estimate, ymin=LCI, ymax=UCI, group=Type, label=round(Estimate,2))) +
	geom_hline(yintercept=0, lty="dashed", col="grey75") +
	geom_errorbar(width=0.2) +
	geom_point() +
	geom_text(nudge_x=0.25) +
	facet_grid(ReferenceLab ~ ContrastLab) +
	xlab("") +
	ylab(variant) +
	coord_flip()
ggsave(str_c(variant, "_contrasts.pdf"), height=10, width=10)


}

ndg <- 0.3
summaries <- contrasts %>%
	filter(Reference1==Reference2, Contrast1==Contrast2, Reference1!=Contrast1) %>%
	group_by(Reference=Reference1, Contrast=Contrast1, Type, Variant) %>%
	summarise(Estimate = mean(Effect), LCI=quantile(Effect, 0.025), UCI=quantile(Effect, 0.975), .groups="drop") %>%
	mutate(xloc = case_when(
		Type == "Primary" ~ c(BA1=11, BA2=10, Interaction=9)[Variant],
		Type == "Secondary" ~ c(BA1=7, BA2=6, Interaction=5)[Variant],
		Type == "Both" ~ c(BA1=3, BA2=2, Interaction=1)[Variant],
	)) %>%
	mutate(nudge = case_when(
		Estimate > 0.5 ~ exp(LCI)-ndg,
#		UCI < 0 ~ 1+ndg,
		TRUE ~ exp(UCI)+ndg
#		Estimate > 0.5 ~ 0.75,
#		TRUE ~ 2
	))

vacclabs.ref <- c("Reference: Unvaccinated","Reference: Fully vaccinated","Reference: Booster vaccinated")
vacclabs.con <- c("Contrast: Unvaccinated","Contrast: Fully vaccinated","Contrast: Booster vaccinated")
## Graph:
summaries$Variant <- factor(summaries$Variant, levels=c("BA1","BA2","Interaction"), labels=c("BA.1", "BA.2", "Interaction"))
summaries$Type <- factor(summaries$Type, levels=c("Primary","Secondary","Both"), labels=c("Infectiousness", "Susceptibility", "Combined"))
summaries$ReferenceLab <- factor(summaries$Reference, levels=c("None","Fully","Booster"), labels=vacclabs.ref)
summaries$ContrastLab <- factor(summaries$Contrast, levels=c("None","Fully","Booster"), labels= vacclabs.con)
levels(summaries$Type) <- rev(levels(summaries$Type))

summaries$yint <- 1

bgrect <- expand_grid(Reference = unique(summaries $Reference), Contrast = unique(summaries $Contrast), Variant=NA, Estimate=0, LCI=0, UCI=0, xloc=0) %>%
	filter(Reference==Contrast) %>%
	mutate(min=-Inf, max=Inf)
bgrect $ReferenceLab <- factor(bgrect $Reference, levels=c("None","Fully","Booster"), labels= vacclabs.ref)
bgrect $ContrastLab <- factor(bgrect $Contrast, levels=c("None","Fully","Booster"), labels= vacclabs.con)


ggplot(summaries, aes(x=xloc, y=exp(Estimate), ymin=exp(LCI), ymax=exp(UCI), group= Variant, col=Variant, fill=Variant, label=format(round(exp(Estimate),2)))) +
	geom_hline(mapping=aes(yintercept=yint), lty="dashed", col="grey75") +
	geom_errorbar(width=0.3) +
	geom_point() +
	geom_text(aes(y=nudge, x=xloc), col="grey50") +
	xlab("") +
	ylab("Odds Ratio") +
	scale_x_continuous(breaks=c(2,6,10), minor_breaks=c(1:3,5:7,9:11), labels=c("Combined","Susceptibility","Infectiousness")) +
	coord_flip() +
	theme(legend.pos="bottom") +
	geom_rect(aes(xmin=min, ymin=min, xmax=max, ymax=max), bgrect, fill="grey75", show.legend=FALSE) +
# 	NB: not needed if show.legend=FALSE in geom_rect !!!!
#	guides(fill="none", col=guide_legend("", order=0)) +
	scale_colour_manual(values=c(BA.1=rgb(0,0,255,max=255), BA.2=rgb(255,0,0,max=255), Interaction=rgb(0,0,0,max=255))) +
	facet_grid(ReferenceLab ~ ContrastLab)

# Also check out:  ?annotate

ggsave("contrasts_20220708.pdf", height=8, width=8)

## Table for paper:

ba_contrasts <- expand_grid(Primary=vacctypes, Secondary=vacctypes) %>%
	mutate(Index = 1:n()) %>%
	split(.$Index) %>%
	pbapply::pblapply(function(x){
		
		ref <- posteriors$BA1 +
				posteriors[[str_c("Primary_", x$Primary)]] +
				posteriors[[str_c("Secondary_", x$Secondary)]]
		
		eff <- posteriors$BA2 +
				posteriors[[str_c("Primary_", x$Primary)]] +
				posteriors[[str_c("Primary_", x$Primary, "_Interaction")]] +
				posteriors[[str_c("Secondary_", x$Secondary)]] +
				posteriors[[str_c("Secondary_", x$Secondary, "_Interaction")]]
		
		bind_cols(x, Effect = eff-ref)		
	}) %>%
	bind_rows()

ptr <- function(x) format(round(exp(x),2))
ba_summaries <- ba_contrasts %>%
	mutate(Primary = str_c("Primary: ", Primary), Secondary = str_c("Secondary: ", Secondary)) %>%
	group_by(Primary, Secondary) %>%
	summarise(Estimate = mean(Effect), LCI=quantile(Effect, 0.025), UCI=quantile(Effect, 0.975), .groups="drop") %>%
	mutate(Text = str_c(ptr(Estimate), " (", ptr(LCI), "-", ptr(UCI), ")")) %>%
	select(-Estimate, -LCI, -UCI) %>%
	pivot_wider(names_from=Primary, values_from=Text)
names(ba_summaries)[1] <- ""
knitr::kable(ba_summaries,format="latex")
