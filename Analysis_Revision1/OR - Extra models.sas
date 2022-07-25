


* Full model ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
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
ods excel close ;

* Restrict on Primary cases >10 years ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_NoPrimaryKids.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where Age_index_10 > 10 ;
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
ods excel close ;

* Restrict on 2 person HH ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_2PersonHH.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where house_members =2 ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		
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
											
											female
											female_index
											PrDate_index
											;
run; quit;
ods excel close ;

* Restrict on TCDK ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_TCD_index.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where TCD_index =1 ;
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
ods excel close ;

* Restrict on 5-12Jan person HH ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_5to11JAN.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where '05JAN2022'd <= PrDate_index <= '11JAN2022'd ;
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
ods excel close ;


* Control for Ct value ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_WithCT.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where CT_value_2_index ne . ;
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
		CT_value_2_index (ref="29")
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
											CT_value_2_index
											PrDate_index
											;
run; quit;
ods excel close ;



* Sensitivity to co-primary cases ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_NoSecCasesDay2to7.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where 2 <= test_pos_day ;
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
ods excel close ;


* Sensitivity to co-primary cases ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_NoSecCasesDay3to7.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where 3 <= test_pos_day ;
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
ods excel close ;




* Sensitivity to co-primary cases ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_NoPrevInfectionInHH.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where Positive_number_HH = 1 ;
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
ods excel close ;




* Restrict on Primary cases >10 years ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_NoPrimaryKids_5to11JAN.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where Age_index_10 > 10 and '05JAN2022'd <= PrDate_index <= '11JAN2022'd ;
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
ods excel close ;


* Restrict on 5-12Jan person HH ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_BeforeJAN5.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where  PrDate_index < '05JAN2022'd ;
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
ods excel close ;


* Restrict on 5-12Jan person HH ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_AfterJAN5.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where '05JAN2022'd <= PrDate_index  ;
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
ods excel close ;

* Restrict on 5-12Jan person HH ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_BeforeJAN11.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	where PrDate_index <= '11JAN2022'd  ;
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
ods excel close ;



* Full model ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_AllTestedNegative.xlsx" ;
proc surveylogistic data =  data.Analysis_final_2 ;
	where test_neg_confirm = 1 ;
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
ods excel close ;



* Full model ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_14DaySAR.xlsx" ;
proc surveylogistic data =  data.Analysis_final_14Days ;
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
ods excel close ;






* More immunity ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_MoreImmunity.xlsx" ;
proc surveylogistic data =  data.Analysis_final ;
	cluster house_number ;
	class 
		pnr
		Age_index_10 (ref="25")
		Age_10 (ref="25")
		house_number 
		house_members (ref="4")
		index_Vacc_omicron_group_2 (ref="BA1_YesVacc_NoPrevInfect")
		Vacc_omicron_group_2 (ref="BA1_YesVacc_NoPrevInfect")
		PrDate_index
		;

	model 
		ever_test_pos_100 (event = '100') = 
											Vacc_omicron_group_2
											index_Vacc_omicron_group_2
											Age_index_10
											Age_10
											house_members
											female
											female_index
											PrDate_index
											;
run; quit;
ods excel close ;




* Only Tested ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\FullModel_OnlyTested.xlsx" ;
proc surveylogistic data =  data.Analysis_final_2 ;
	where ever_test = 1 ;
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
ods excel close ;

