
****** RELATIVE EFFECT OF OMICRON ****** ;
* Unvaccinated ;
ods output 	parameterestimates = parms;
proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status = "Not vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_NoVacc")
		Vacc_omicron_group (ref="OMI_BA1_NoVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											Vacc_omicron_group
											index_Vacc_omicron_group									 
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;

proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status_index = "Not vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_NoVacc")
		Vacc_omicron_group (ref="OMI_BA1_NoVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											index_Vacc_omicron_group									 
											Vacc_omicron_group
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;

ods output 	parameterestimates = parms;
proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status = "Fully vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_FullVacc")
		Vacc_omicron_group (ref="OMI_BA1_FullVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											Vacc_omicron_group
											index_Vacc_omicron_group									 
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;

proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status_index = "Fully vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_FullVacc")
		Vacc_omicron_group (ref="OMI_BA1_FullVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											index_Vacc_omicron_group									 
											Vacc_omicron_group
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;




ods output 	parameterestimates = parms;
proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status = "Booster vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_BoostVacc")
		Vacc_omicron_group (ref="OMI_BA1_BoostVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											Vacc_omicron_group
											index_Vacc_omicron_group									 
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;

proc surveylogistic data =  data.Analysis_final ;
	where Vaccination_status_index = "Booster vaccinated" ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group (ref="OMI_BA1_BoostVacc")
		Vacc_omicron_group (ref="OMI_BA1_BoostVacc")
		PrDate_index
		;
	model 
		ever_test_pos_100 (event = '100') = 
											index_Vacc_omicron_group									 
											Vacc_omicron_group
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;

