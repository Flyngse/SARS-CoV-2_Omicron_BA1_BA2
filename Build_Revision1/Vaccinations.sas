*******************************
	Vaccination - START
********************************;

proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Data_Revision1\vaccine_maalgrupper_220617.csv"
	out 		= vaccine
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
	guessingrows = 10000 ;
run; 


data DATA.vaccine ;
	set vaccine ;
		rename CPR_ENCRYPTED = pnr ;
run ;

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	Vaccination - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;

data data.vaccine_2 ;
	set DATA.vaccine ;
		keep 
			pnr
			second_VaccineName
			first_VaccineName
			first_VaccineDate
			second_VaccineDate
			revacc1_VaccineDate
			revacc1_VaccineName
			;
run;

data DATA.vaccine_2 ;
	set data.vaccine_2;

		if first_VaccineName = "AstraZeneca Covid-19 vaccine" 	then first_VaccineName_adj  = "AstraZeneca" ;
		if second_VaccineName = "AstraZeneca Covid-19 vaccine" 	then second_VaccineName_adj = "AstraZeneca" ;
		if revacc1_VaccineName = "AstraZeneca Covid-19 vaccine" then Booster_VaccineName_adj = "AstraZeneca" ;

		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" 	then first_VaccineName_adj  = "Pfizer" ;
		if second_VaccineName = "Pfizer BioNTech Covid-19 vacc" 	then second_VaccineName_adj = "Pfizer" ;
		if revacc1_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Booster_VaccineName_adj = "Pfizer" ;

		if first_VaccineName = "Comirnaty Covid-19 Vaccine" 	then first_VaccineName_adj  = "Pfizer" ;
		if second_VaccineName = "Comirnaty Covid-19 Vaccine" 	then second_VaccineName_adj = "Pfizer" ;
		if revacc1_VaccineName = "Comirnaty Covid-19 Vaccine" then Booster_VaccineName_adj = "Pfizer" ;

		if first_VaccineName = "Moderna Covid-19 Vaccine" 	then first_VaccineName_adj  = "Moderna" ;
		if second_VaccineName = "Moderna Covid-19 Vaccine" 	then second_VaccineName_adj = "Moderna" ;
		if revacc1_VaccineName = "Moderna Covid-19 Vaccine" then Booster_VaccineName_adj = "Moderna" ;

		if first_VaccineName = "Janssen COVID-19 vaccine" 	then first_VaccineName_adj  = "Janssen" ;
		if second_VaccineName = "Janssen COVID-19 vaccine" 	then second_VaccineName_adj = "Janssen" ;
		if revacc1_VaccineName = "Janssen COVID-19 vaccine" then Booster_VaccineName_adj = "Janssen" ;

		* Vacc date ;
		if first_VaccineName_adj = "Janssen" then fully_vaccinated_Date = second_VaccineDate + 14 ;
		if second_VaccineName_adj = "Pfizer" then fully_vaccinated_Date = second_VaccineDate + 7 ;
		if second_VaccineName_adj = "Moderna" then fully_vaccinated_Date = second_VaccineDate + 14 ;
		if second_VaccineName_adj = "AstraZeneca" then fully_vaccinated_Date = second_VaccineDate + 15 ;
		if first_VaccineDate ne . and second_VaccineDate = . then fully_vaccinated_Date = . ;
			format fully_vaccinated_Date DATE9. ;			

		* Booster ;
		fully_Booster_vacc_Date = revacc1_VaccineDate + 7 ;
		if revacc1_VaccineDate = . then fully_Booster_vacc_Date = . ;
			format fully_Booster_vacc_Date DATE9. ;			

		/*
		* Astra ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		
		*Pfizer ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		* Moderna ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;

		* J&J ;
		if first_VaccineName = "Janssen COVID-19 vaccine"  then Full_Vaccine_Name = "Janssen" ;

		*/

		drop 
			first_VaccineName
			second_VaccineName
			revacc1_VaccineName;
			
run;

