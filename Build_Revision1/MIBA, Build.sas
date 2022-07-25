********************************
	MIBA - START
********************************;

data WORK.MIBA    ;
%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
infile "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Data_Revision1\basis_samples_&Update..csv" delimiter = ';' MISSOVER DSD lrecl=32767 firstobs=2 ;

	informat CPRNR_ENCRYPTED $32. ;
	informat Casedef $5. ;
	informat Qtnr best32. ;
	informat Avd best32. ;
	informat resultat best32. ;
	informat iSENTINEL best32. ;
	informat iTESTCENTER best32. ;
	informat Cprnr_FRO best32. ;
	informat Cprnr_GRL2 best32. ;
	informat Extid $25. ;
	informat CT_value best32. ;
	informat utdate anydtdtm. ;
	informat prdate_adjusted anydtdtm. ;

	format CPRNR_ENCRYPTED $32. ;
	format Casedef $5. ;
	format Qtnr best12. ;
	format Avd best12. ;
	format resultat best12. ;
	format iSENTINEL best12. ;
	format iTESTCENTER best12. ;
	format Cprnr_FRO best12. ;
	format Cprnr_GRL2 best12. ;
	format Extid $25. ;
	format CT_value best12. ;
	format utdate datetime22. ;
	format prdate_adjusted datetime22. ;

	input
	CPRNR_ENCRYPTED  $
	Casedef  $
	Qtnr
	Avd
	resultat
	iSENTINEL
	iTESTCENTER
	Cprnr_FRO
	Cprnr_GRL2
	Extid  $
	CT_value
	utdate
	prdate_adjusted
	;

	if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
run;


options obs = max ;


data DATA.miba_final_1 ;
	set miba ;
		if resultat = 2 then test_pos = 0 ;
		if resultat = 1 then test_pos = 1 ;
		Test = 1 ;
		if iTESTCENTER = 1 then Test_TCD = 1 ; else Test_TCD = 0 ;
		if iTESTCENTER = 1 then Test_Sund = 0 ; else Test_Sund = 1 ;
		if iTESTCENTER = 1 then TCD = 1 ; else TCD = 0 ;

		rename CPRNR_ENCRYPTED = pnr ;
		rename prdate_adjusted = PrDateTime ;
		rename utdate = UtDateTime  ;

		/*
		prdate = datepart(prdate_adjusted) ;
		utdate = datepart(utdate) ;
		*/
		/*
		if year(prdate_adjusted)=2020 then PrWeek = week(prdate_adjusted, 'w')+1 ;
		if year(prdate_adjusted)=2021 then PrWeek = week(prdate_adjusted, 'w') ;
		if '28dec2020'd <= datepart(prdate_adjusted) <= '03jan2021'd then PrWeek = 53 ;
		*/

		drop
			Qtnr
			Avd
			Cprnr_FRO
			Cprnr_GRL2
			Extid
			;
run;

data DATA.miba_final_1 ;
	set DATA.miba_final_1 ;

		prdate = datepart(PrDateTime) ;
			format prdate date9. ;
		utdate = datepart(UtDateTime) ;
			format utdate date9. ;

		if year(prdate)=2020 then PrWeek = week(prdate, 'w')+1 ;
		if year(prdate)=2021 then PrWeek = week(prdate, 'w') ;
		if '28dec2020'd <= datepart(prdate) <= '03jan2021'd then PrWeek = 53 ;
run;


proc sort data=DATA.miba_final_1 ;
	BY pnr PrDate Casedef descending test_pos ;
run;

data DATA.miba_final_1 ;
	set DATA.miba_final_1 ;
		by pnr PrDate Casedef ;
			if first.Casedef then output;
run;

proc sql;
	create table data.Positive_PCR_Tests

	as select
				pnr,
				PrDate,
				CT_value,
				TCD,
				test_pos,
				Casedef

	from data.miba_final_1

	where test_pos = 1
	and Casedef = "SARS2"

	order by 
			pnr,
			PrDate
;quit;

data data.Positive_PCR_Tests_2 ;
	set data.Positive_PCR_Tests ;
		previous_test_pos_date = lag(PrDate) ;
			format previous_test_pos_date date9. ;
			by pnr ;
				if first.pnr then previous_test_pos_date = . ;

		time_between = PrDate - previous_test_pos_date ;

		if time_between > 60 or time_between = . then new_positive = 1 ;
run;

data data.Positive_PCR_Tests_3 ;
	set data.Positive_PCR_Tests_2 ;
		where new_positive = 1 ;
			by pnr ;
				if first.pnr then Positive_number = 0 ;
				Positive_number + 1;
run;







* Merge MIBA, WGS ;
proc sql;
	create table data.Positive_PCR_Tests_4

	as select
				P.*,
				W.*

	from		data.Positive_PCR_Tests_3		P

	left join	data.WGS						W
		on P.pnr = W.pnr
		and P.PrDate = W.date_sampling
;quit;

data data.Positive_PCR_Tests_4 ;
	set data.Positive_PCR_Tests_4 ;

		if WGS_Selection = . then WGS_Selection = 0 ;
		if variant = "" then variant = "Unknown" ;

		CT_value_exist = 1 ;  
		if CT_value = . then CT_value_exist = 0 ;  
		CT_value_1 = round(CT_value,1.0);
		CT_value_2 = (int((CT_value_1 - 1) / 2) + 1 ) * 2 - 1;
run;

proc sql;
	create table data.Vaccine_and_infection

	as select
				V.*,
				P1.prdate as InfectionDate_1,
				P2.prdate as InfectionDate_2,
				P3.prdate as InfectionDate_3

	from 		data.vaccine_2				V

	left join 	data.Positive_pcr_tests_4	P1
		on V.pnr = P1.pnr
		and P1.Positive_number=1

	left join 	data.Positive_pcr_tests_4	P2
		on V.pnr = P2.pnr
		and P2.Positive_number=2

	left join 	data.Positive_pcr_tests_4	P3
		on V.pnr = P3.pnr
		and P3.Positive_number=3
;quit;


/*
proc means data = data.Positive_PCR_Tests_3 N mean;
	var new_positive ;
	class Positive_number ;
run;
*/

/*

data data.First_positive ;
	set data.Positive_PCR_Tests_3 ;
		where Positive_number = 1 ;
run;





proc sql;
	create table DATA.First_positive_2

	as select 
				F.*,
				W.*

	from 		data.First_positive		F

	left join 	data.WGS				W
		on F.pnr = W.pnr

	order by PrDate
;quit;

data DATA.First_positive_2 ;
	set DATA.First_positive_2 ;
		if WGS_selection = . then WGS_Selection = 0 ;
		if SEQUENCE_STATUS = "genome" then WGS_genome = 1 ; else WGS_genome = 0 ;

		if variant = "" then variant = "No Genome" ;

		CT_value_exist = 1 ;  
		if CT_value = . then CT_value_exist = 0 ;  

		CT_value_1 = round(CT_value,1.0);
		CT_value_2 = (int((CT_value_1 - 1) / 2) + 1 ) * 2 - 1;

		if CT_value < 25 then CT_value_Q = 1 ; 
		if 25 <= CT_value < 28 then CT_value_Q = 2 ; 
		if 28 <= CT_value < 32 then CT_value_Q = 3 ; 
		if 32 <= CT_value <= 38 then CT_value_Q = 4 ; 
		count = 1 ;

run;

*/

/*
proc sql;
	create table  data.Positive_PCR_Tests_3

	as select
				P.*,
				V.fully_vaccinated_Date

	from 		data.Positive_PCR_Tests_2		P

	left join 	data.vaccine_2					V
		on P.pnr = V.pnr
;quit;




proc sql;
	create table data.Positive_Antigen_Tests

	as select
				pnr,
				PrDate,
				TCD,
				test_pos,
				Casedef

	from data.miba_final_1


	where test_pos = 1
	and Casedef = "SARSG"

	order by 
			pnr,
			PrDate
;quit;



proc sql;
	create table data.zz

	as select distinct
				P.*,
				A.PrDate as PrDate_Antigen

	from 		data.Positive_PCR_Tests_2 		P

	left join 	data.Positive_Antigen_Tests		A
		on P.pnr = A.pnr
		and  A.PrDate <= P.PrDate <= A.PrDate +3

	where new_positive = 1
;quit;
*/



*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	MIBA - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
