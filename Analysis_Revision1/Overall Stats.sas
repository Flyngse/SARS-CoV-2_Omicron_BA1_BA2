



data data.stats_overall  ;
	set data.Positive_PCR_Tests_4 ;
		where '01dec2021'd <= PrDate <= '01MAR2022'd  
		;
run;
proc sort data=data.stats_overall  ;
	by variant ;
run;


ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\N_variant_overall.xlsx" ;
proc means data = data.stats_overall SUM maxdec=0;
	where WGS_genome = 1 ;
	by variant ;
	class prdate ;
	var WGS_genome ;
run;
ods excel close ;


proc sql;
	create table Stats_variant

	as select 
			PrDate,
			variant,
			count(*) as count

	from data.stats_overall

	where WGS_genome = 1

	group by
			PrDate,
			variant
;quit;	



* overall sample stats ;

data Samples_stats ;
	set data.miba_final_1 ;
		where '01dec2021'd <= PrDate <= '01MAR2022'd  ; 
run;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\N_tests_overall.xlsx" ;
proc means data = Samples_stats SUM maxdec=0;
	where  casedef = "SARSG";
	class prdate ;
	var test_pos ;
run;
proc means data = Samples_stats SUM maxdec=0;
	where  casedef = "SARS2";
	class prdate ;
	var test_pos ;
run;
ods excel close ;


