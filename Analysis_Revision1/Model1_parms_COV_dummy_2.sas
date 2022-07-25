

* GEM OUTPUT ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output\Model1_dummy.xlsx" ;
*ods output CovB=outcov ParameterEstimates=parms;
proc surveylogistic data =  data.Analysis_final ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members
		variant_index (ref="Omicron - BA.1")
		Vaccination_status (ref="Fully vaccinated")
		Vaccination_status_index (ref="Fully vaccinated")
		PrDate_index
		/param=ref
		;

	model 
		ever_test_pos_100 (event = '100') = 
											variant_index
	
											Vaccination_status
											Vaccination_status_index

											Vaccination_status*variant_index

											Vaccination_status_index*variant_index
											 
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index	
											;	

run; quit;
ods excel close ;





* GEM OUTPUT ;
ods output CovB=CovParms ParameterEstimates=parms ;
proc surveylogistic data =  data.Analysis_final ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members
		
		Vaccination_status (ref="Fully vaccinated")
		Vaccination_status_index (ref="Fully vaccinated")
		variant_index (ref="Omicron - BA.1")
		PrDate_index
		/param=ref
		;

	model 
		ever_test_pos_100 (event = '100') = 
											
	
											Vaccination_status
											Vaccination_status_index

											variant_index

											Vaccination_status*variant_index

											Vaccination_status_index*variant_index
											 
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index	
											/ covb
											;	

run; quit;

/*
data parms ;
	set parms ;
		format estimate Stderr BestD16. ;
run;
data CovParms ;
	set CovParms ;
		format 
				Intercept 
				Vaccination_status_indexBooster
				Vaccination_status_indexBoosterv
				Vaccination_status_indexNot_vac2
				Vaccination_status_indexNot_vacc
				Vaccination_statusBooster_vacci2
				Vaccination_statusBooster_vaccin
				Vaccination_statusNot_vaccinate2
				Vaccination_statusNot_vaccinated
				variant_indexOmicron___BA_2
				BestD16. ;
run;
*/

proc export
	data = parms 
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model1_parms_dummy_2.csv"
	dbms = csv
	replace;
run;

proc export
	data = CovParms 
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model1_CovParms_dummy_2.csv"
	dbms = csv
	replace;
run;
