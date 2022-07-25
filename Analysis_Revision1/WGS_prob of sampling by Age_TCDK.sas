
*********
	Overall Ct and WGS ;
*********;

data data.stats  ;
	set data.Positive_PCR_Tests_4 ;
		where '20dec2021'd <= PrDate <= '28jan2022'd  
		;
			WGS_Selection_100 = WGS_Selection*100 ;
			WGS_genome_100 = WGS_genome*100 ;

run;

proc sql;
	create table data.stats_2

	as select
				s.*,
				c.age,
				c.Age_5

	from 		data.stats			S
	left join	data.cpr_final		C
		on S.pnr = C.pnr
;quit;


data stats ;
	set data.stats_2 ;
		where TCD = 1 ;
run;

ods output ParameterEstimates = parms_SELECT ;
proc genmod data = stats plots=none;
	where 18 <= ct_value_1 <= 38 
	;
	class 
		CT_value_1
		/ param=glm;
	model
			WGS_Selection_100 = CT_value_1  / noint  ;
run;quit;
data parms_SELECT ;
	set parms_SELECT ;
		Group = "Selected for WGS" ;
run;
ods output ParameterEstimates = parms_GENOME ;
proc genmod data = stats plots=none;
	where 18 <= CT_value_1 <= 38 
	;
	class 
		CT_value_1
		/ param=glm;
	model
			WGS_genome_100 = CT_value_1  / noint  ;
run;quit;
data parms_GENOME ;
	set parms_GENOME ;
		Group = "Succesful genome" ;
run;
data parms ;
	set 
		parms_SELECT
		parms_GENOME 
		;
		CT = Level1+0 ;
		format estimate comma10.0 ;

		if StdErr > 15 then delete ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "Prob_of_WGS_by_CT" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
*title 'prob of wgs_selection' ;
proc sgplot data = parms ;
		styleattrs 
				datacontrastcolors = (purple green ) 
				datasymbols=(circlefilled squarefilled) 
				datalinepatterns=( solid dash ) 
				datacolors=(purple green ) 
				;
	series
			y = Estimate
			x = CT
			/ markers   group=Group name="estimates" datalabel=estimate ;

	band
			x = CT
			lower=LowerWaldCL
			upper=UpperWaldCL
			/   transparency = 0.9  group=Group name="band" ;


	xaxis
		values = (18 to 38 by 2) 
		label = "Ct Value"
		;

	yaxis 
		values = (0 to 100 by 10)
		label = "Proportion (%)"
		grid
		;

		keylegend "estimates" / Title="" location=inside position=topright across=1 exclude=("band")  noborder opaque;
run;



ods output ParameterEstimates = parms_SELECT ;
proc genmod data = stats plots=none;
	class 
		Age_5
		/ param=glm;
	model
			WGS_Selection_100 = Age_5  / noint  ;
run;quit;
data parms_SELECT ;
	set parms_SELECT ;
		Group = "Selected for WGS" ;
run;
ods output ParameterEstimates = parms_GENOME ;
proc genmod data = stats plots=none;
	class 
		Age_5
		/ param=glm;
	model
			WGS_genome_100 = Age_5  / noint  ;
run;quit;
data parms_GENOME ;
	set parms_GENOME ;
		Group = "Succesful genome" ;
run;
data parms ;
	set 
		parms_SELECT
		parms_GENOME 
		;
		Age = Level1+0 ;
		format estimate comma10.0 ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "Prob_of_WGS_by_AGE_TCDK" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
*title 'prob of wgs_selection' ;
proc sgplot data = parms ;
	where age <= 90 ;
		styleattrs 
				datacontrastcolors = (purple green ) 
				datasymbols=(circlefilled squarefilled) 
				datalinepatterns=( solid dash ) 
				datacolors=(purple green ) 
				;
	series
			y = Estimate
			x = Age
			/ markers   group=Group name="estimates" datalabel=estimate ;

	band
			x = Age
			lower=LowerWaldCL
			upper=UpperWaldCL
			/   transparency = 0.9  group=Group name="band" ;


	xaxis
		values = (0 to 90 by 10) 
		label = "Age, years"
		;

	yaxis 
		values = (0 to 100 by 10)
		label = "Proportion (%)"
		grid
		;

		keylegend "estimates" / Title="" location=inside position=topright across=1 exclude=("band")  noborder opaque;
run;






data stats ;
	set data.stats_2 ;
		where TCD = 0 ;
run;

ods output ParameterEstimates = parms_SELECT ;
proc genmod data = stats plots=none;
	class 
		Age_5
		/ param=glm;
	model
			WGS_Selection_100 = Age_5  / noint  ;
run;quit;
data parms_SELECT ;
	set parms_SELECT ;
		Group = "Selected for WGS" ;
run;
ods output ParameterEstimates = parms_GENOME ;
proc genmod data = stats plots=none;
	class 
		Age_5
		/ param=glm;
	model
			WGS_genome_100 = Age_5  / noint  ;
run;quit;
data parms_GENOME ;
	set parms_GENOME ;
		Group = "Succesful genome" ;
run;
data parms ;
	set 
		parms_SELECT
		parms_GENOME 
		;
		Age = Level1+0 ;
		format estimate comma10.0 ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "Prob_of_WGS_by_AGE_HOSPITALS" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
*title 'prob of wgs_selection' ;
proc sgplot data = parms ;
	where age <= 90 ;
		styleattrs 
				datacontrastcolors = (purple green ) 
				datasymbols=(circlefilled squarefilled) 
				datalinepatterns=( solid dash ) 
				datacolors=(purple green ) 
				;
	series
			y = Estimate
			x = Age
			/ markers   group=Group name="estimates" datalabel=estimate ;

	band
			x = Age
			lower=LowerWaldCL
			upper=UpperWaldCL
			/   transparency = 0.9  group=Group name="band" ;


	xaxis
		values = (0 to 90 by 10) 
		label = "Age, years"
		;

	yaxis 
		values = (0 to 100 by 10)
		label = "Proportion (%)"
		grid
		;

		keylegend "estimates" / Title="" location=inside position=topright across=1 exclude=("band")  noborder opaque;
run;


