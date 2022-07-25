

* descriptives ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\PrimaryCases_stat_3.xlsx" ;
proc freq data= data.Primary_cases_stat ;
	table variant_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.Primary_cases_stat ;
	table female_index*variant_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.Primary_cases_stat ;
	table Age_index_10*variant_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.Primary_cases_stat ;
	table house_members*variant_index / nocol norow nopercent nocum;
run;
proc freq data= data.Primary_cases_stat ;
	table Vaccination_status_index*variant_index / nocol norow nopercent nocum;
run;
proc means data = data.Primary_cases_stat mean std maxdec=2;
	class variant_index;
	var ct_value_index ;
run;
ods excel close ;

proc freq data= data.Analysis_final ;
	table Partially_vaccinated*variant_index / nocol norow nopercent nocum;
run;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\PotentialSecondaryCases_stat_3.xlsx" ;
proc freq data= data.Analysis_final ;
	table variant_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.Analysis_final ;
	table female*variant_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.Analysis_final ;
	table Age_10*variant_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.Analysis_final ;
	table house_members*variant_index / nocol norow nopercent nocum;
run;
* Vacc ;
proc freq data= data.Analysis_final ;
	table Vaccination_status*variant_index / nocol norow nopercent nocum;
run;
ods excel close ;


proc freq data= data.Analysis_final ;
	table Partially_vaccinated_index*variant_index / nocol norow nopercent nocum;
run;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\PositiveSecondaryCases_stat_3.xlsx" ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table variant_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table female*variant_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table Age_10*variant_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table house_members*variant_index / nocol norow nopercent nocum;
run;
* Vacc ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table Vaccination_status*variant_index / nocol norow nopercent nocum;
run;

proc means data = data.Analysis_final mean std maxdec=2;
	where ever_test_pos_100 = 100 ;
	class variant_index;
	var ct_value ;
run;
ods excel close ;


proc freq data= data.Analysis_final ;
	table Partially_vaccinated_index*variant_index / nocol norow nopercent nocum;
run;




ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\PotentialSecondaryCases_stat_3_PRIMARY.xlsx" ;
proc freq data= data.Analysis_final ;
	table variant_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.Analysis_final ;
	table female_index*variant_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.Analysis_final ;
	table Age_index_10*variant_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.Analysis_final ;
	table house_members*variant_index / nocol norow nopercent nocum;
run;
* Vacc ;
proc freq data= data.Analysis_final ;
	table Vaccination_status_index*variant_index / nocol norow nopercent nocum;
run;
ods excel close ;


ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\PositiveSecondaryCases_stat_3_PRIMARY.xlsx" ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table variant_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table female_index*variant_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table Age_index_10*variant_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table house_members*variant_index / nocol norow nopercent nocum;
run;
* Vacc ;
proc freq data= data.Analysis_final ;
	where ever_test_pos_100 = 100 ;
	table Vaccination_status_index*variant_index / nocol norow nopercent nocum;
run;
ods excel close ;
