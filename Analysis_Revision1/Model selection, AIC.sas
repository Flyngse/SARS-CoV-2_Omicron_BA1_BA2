
* GEM OUTPUT ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model1.xlsx" ;
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



ods output ParameterEstimates = parms ;
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
											/ CLPARM
											;
run; quit;

proc export 
	data = parms 
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model1_parms.xlsx"
	dbms = xlsx
	replace
	;
run;
	


* GEM OUTPUT ;
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model2.xlsx" ;
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
		;

	model 
		ever_test_pos_100 (event = '100') = 
											variant_index
	
											Vaccination_status
											Vaccination_status_index

											Vaccination_status*variant_index

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
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model3.xlsx" ;
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
		;

	model 
		ever_test_pos_100 (event = '100') = 
											variant_index

											Vaccination_status
											Vaccination_status_index
	
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
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model4.xlsx" ;
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
		;

	model 
		ever_test_pos_100 (event = '100') = 
											variant_index
	
											Vaccination_status
											Vaccination_status_index
											 
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
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Model5.xlsx" ;
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
																				
											;
run; quit;
ods excel close ;
