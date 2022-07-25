



* bef by muni ;
proc sql;
	create table data.kom_bef

	as select
				C_KOM,
				count(*) as population

	from data.Cpr_adresse_raw		

	where C_KOM not in ("010", "011", "012", "019")

	group by C_KOM
;quit;


proc sql;
	create table data.PCR_cases 

	as select 
				P.pnr,
				P.prdate,
				P.test_pos,
				P.WGS_genome,
				P.variant,
				C.C_KOM

	from 		data.Positive_pcr_tests_4		P

	left join 	data.Cpr_adresse_raw			C
		on P.pnr = C.pnr

	where '20DEC2021'd < prdate < '30JAN2022'd 
;quit;

data data.PCR_cases ;
	set data.PCR_cases ;
		if WGS_genome = 1 then BA2 = 0 ;
		if WGS_genome = 1 then BA1 = 0 ;
		if variant = "Omicron - BA.2" then BA2 = 1 ;
		if variant = "Omicron - BA.1" then BA1 = 1 ;

		week = week(prdate, 'w') ;

		if week(prdate, 'w') = 0 then week = 52 ;
run;


proc sql;
	create table data.PCR_cases_by_muni

	as select
			C_KOM,
			week,
			mean(BA2) as BA2_share_municipality,
			mean(BA1) as BA1_share_municipality,
			sum(test_pos) as N_cases,
			sum(BA2) as N_BA2_cases,
			sum(BA1) as N_BA1_cases

	from data.PCR_cases

	where C_KOM not in ( "", "010", "011", "012", "019", "955", "956", "957", "959", "960")

	group by 
			C_KOM, 
			week
;quit;

proc sql;
	create table data.Incidence_muni

	as select
				*

	from		data.kom_bef				A

	inner join	data.PCR_cases_by_muni		B
		on A.C_KOM = B.C_KOM
;quit;

data data.Incidence_muni ;
	set data.Incidence_muni ;
		incidence = N_cases / population * 1000 ;
		if N_cases < 5 then delete ;
		*if N_BA2_cases < 5 then N_BA2_cases = . ;
		*if N_BA2_cases < 5 then BA2_share_municipality = . ;
run;

proc means data = data.Incidence_muni q1 median q3 mean maxdec=2;
	class week ;
	var BA2_share_municipality BA1_share_municipality;
	weight population ;
run;

proc means data = data.Incidence_muni q1 median q3 mean maxdec=0;
	var incidence ;
	weight population ;
run;

proc means data = data.Incidence_muni q1 median q3 mean maxdec=0;
	var incidence population;
run;

data Incidence_muni ;
	set Incidence_muni ;
		below_median_BA2 = 0 ;
		if BA2_share_municipality < 0.35 then below_median_BA2 = 1 ;

												Municipality_quartile = 4 ;
		if BA2_share_municipality < 0.40 then Municipality_quartile = 3 ;
		if BA2_share_municipality < 0.35 then Municipality_quartile = 2 ;
		if BA2_share_municipality < 0.28 then Municipality_quartile = 1 ;

							   incidence_quartile = 4 ;
		if incidence < 187 then incidence_quartile = 3 ;
		if incidence < 152 then incidence_quartile = 2 ;
		if incidence < 133 then incidence_quartile = 1 ;

							  	   population_quartile = 4 ;
		if population < 59031 then population_quartile = 3 ;
		if population < 42272 then population_quartile = 2 ;
		if population < 28105 then population_quartile = 1 ;
run;

* export to map plot ;
/*
proc export 
	data = Incidence_muni
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Incidence_muni.csv"
	dbms = csv
	replace
	;
run; quit;
*/


data data.Analysis_daily	;
	set data.Analysis_daily	;	
		week_index  = week(PrDate_index, 'w') ;
		if week(PrDate_index, 'w') = 0 then week_index = 52 ;		
run;

proc sql;
	create table data.Analysis_daily_Muni

	as select
				A.*,
				K.*

	from 		data.Analysis_daily		A

	left join 	data.Incidence_muni		K
		on A.C_KOM = K.C_KOM
		and A.week_index = K.week

	order by variant_index
;quit;

data data.Analysis_daily_Muni ;
	set data.Analysis_daily_Muni ;
		
		if variant_index = "Omicron - BA.2" and BA2_share_municipality <= 0.25 then variant_share_Q1 = 1 ;
		if variant_index = "Omicron - BA.1" and BA1_share_municipality <= 0.25 then variant_share_Q1 = 1 ;

		if variant_index = "Omicron - BA.2" and BA2_share_municipality <= 0.5 then variant_share_belowMedian = 1 ;
		if variant_index = "Omicron - BA.1" and BA1_share_municipality <= 0.5 then variant_share_belowMedian = 1 ;

		if variant_index = "Omicron - BA.2" and BA2_share_municipality > 0.5 then variant_share_AboveMedian = 1 ;
		if variant_index = "Omicron - BA.1" and BA1_share_municipality > 0.5 then variant_share_AboveMedian = 1 ;

		if incidence <= 28 then incidence_belowMedian = 1 ;
		if incidence > 28 then incidence_AboveMedian = 1 ;
run;


