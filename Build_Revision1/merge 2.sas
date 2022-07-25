
* Merge first positive on households ;
proc sql;
	create table	data.Contact_house

	as select 
				H.*,
				F.PrDate,
				F.Positive_number,
				F.WGS_Selection,
				F.WGS_genome,
				F.variant,
				F.CT_value_2,
				F.CT_value_1,
				F.Ct_value,
				F.TCD

	from		data.home_full_2			H

	inner join	data.Positive_pcr_tests_4		F
		on H.pnr = F.pnr
		and F.new_positive = 1

	where 2 <= house_members <= 6

	order by
			house_number,
			PrDate
;quit;

data data.Contact_house_2 ;
	set data.Contact_house ;
		previous_test_pos_date_HH = lag(PrDate) ;
			format previous_test_pos_date_HH date9. ;
			by house_number ;
				if first.house_number then previous_test_pos_date_HH = . ;

		time_between_HH = PrDate - previous_test_pos_date_HH ;

		if time_between_HH > 60 or time_between_HH = . then new_positive_HH = 1 ;
run;

data data.Contact_house_3 ;
	set data.Contact_house_2 ;
		where new_positive_HH = 1 ;
			by house_number ;
				if first.house_number then Positive_number_HH = 0 ;
				Positive_number_HH + 1;
run;

data data.Contact_house_4 ;
	set data.Contact_house_3 ;
		where '10dec2021'd <= prdate <= '31jan2022'd ;
run;

data data.Contact_house_4 ;
	set data.Contact_house_4 ;
		rename  pnr  = PNR_index ;
		rename  PrDate = PrDate_index ;
		rename  female = Female_index ;
		rename  age = Age_index ;
		rename  age_5 = Age_index_5 ;
		rename  age_10 =Age_index_10 ;
		rename  age_20 = Age_index_20 ;
		rename agegroup_2 = agegroup_2_index ;
		rename CT_value_1 = CT_value_1_index   ;
		rename CT_value_2 = CT_value_2_index   ;
		rename Ct_value = Ct_value_index   ;
		rename TCD = TCD_index ;
		rename WGS_Selection = WGS_Selection_index ;
		rename WGS_genome = WGS_genome_index ;
		rename variant = variant_index ;
		rename Positive_number = Positive_number_index ;

		drop 
			previous_test_pos_date_HH
			time_between_HH
			new_positive_HH
			;
run;

proc sql;
	create table data.Contact_house_5

	as select
				H.*,
				F.*

	from		data.home_full_2			H

	inner join	data.Contact_house_4		F
		on H.house_number = F.house_number
		and H.pnr <> F.pnr_index
;quit;


proc sql;
	create table	data.Contact_house_5X

	as select distinct
						C.*,

						VI.first_VaccineName_adj as first_VaccineName_adj_index,
						VI.second_VaccineName_adj as second_VaccineName_adj_index,
						VI.Booster_VaccineName_adj as Booster_VaccineName_adj_index,
						VI.fully_vaccinated_Date as fully_vaccinated_Date_index,
						VI.first_VaccineDate as first_VaccineDate_index,
						VI.fully_Booster_vacc_Date as fully_Booster_vacc_Date_index,
						VI.InfectionDate_1 as InfectionDate_1_index,
						VI.InfectionDate_2 as InfectionDate_2_index,
						VI.InfectionDate_3 as InfectionDate_3_index,
						VS.first_VaccineName_adj,
						VS.first_VaccineDate,
						VS.second_VaccineName_adj,
						VS.Booster_VaccineName_adj,
						VS.fully_vaccinated_Date,
						VS.fully_Booster_vacc_Date,
						VS.InfectionDate_1,
						VS.InfectionDate_2,
						VS.InfectionDate_3		


	from			data.Contact_house_5			C

	left join	data.Vaccine_and_infection			VI
		on C.pnr_index = VI.pnr

	left join	data.Vaccine_and_infection			VS
		on C.pnr = VS.pnr

	where c.pnr ^= ""

	order by
			house_number,
			pnr
;quit;

data data.Contact_house_5X ;
	set data.Contact_house_5X ;

		* CONTACTS ;
		if fully_vaccinated_Date > PrDate_index then fully_vaccinated_Date = . ;
		if fully_Booster_vacc_Date > PrDate_index then fully_Booster_vacc_Date = . ;
		if InfectionDate_1 > PrDate_index-14 then InfectionDate_1 = . ;
		if InfectionDate_2 > PrDate_index-14 then InfectionDate_2 = . ;
		if InfectionDate_3 > PrDate_index-14 then InfectionDate_3 = . ;

		Last_vaccination_date = max(fully_vaccinated_Date, fully_Booster_vacc_Date, InfectionDate_1, InfectionDate_2, InfectionDate_3) ;
			format Last_vaccination_date date9. ;

		length Vaccination_status $ 18 ;
		Vaccination_status = "Fully vaccinated" ;
		if Last_vaccination_date = . then Vaccination_status = "Not vaccinated" ;
		if fully_Booster_vacc_Date ne . then Vaccination_status = "Booster vaccinated" ;

		Days_since_vaccination = PrDate_index - Last_vaccination_date  ;

		length Vaccination_status_2 $ 25 ;
		if Last_vaccination_date = . then Vaccination_status_2 = "NoVacc_NoPrevInfect" ;
		if fully_vaccinated_Date = . and fully_Booster_vacc_Date = . and InfectionDate_1 NE . then Vaccination_status_2 = "NoVacc_YesPrevInfect" ;
		if fully_vaccinated_Date NE . and fully_Booster_vacc_Date = . and InfectionDate_1 = . then Vaccination_status_2 = "YesVacc_NoPrevInfect" ;
		if fully_vaccinated_Date NE . and fully_Booster_vacc_Date = . and InfectionDate_1 NE . then Vaccination_status_2 = "YesVacc_YESPrevInfect" ;
		if fully_Booster_vacc_Date NE . then Vaccination_status_2 = "BoosterVacc" ;


		Partially_vaccinated = 0 ;
		if  first_VaccineDate < PrDate_index <= fully_vaccinated_Date then Partially_vaccinated = 1 ;



		* INDEX ;
		if fully_vaccinated_Date_index > PrDate_index then fully_vaccinated_Date_index = . ;
		if fully_Booster_vacc_Date_index > PrDate_index then fully_Booster_vacc_Date_index = . ;
		if InfectionDate_1_index > PrDate_index-14 then InfectionDate_1_index = . ;
		if InfectionDate_2_index > PrDate_index-14 then InfectionDate_2_index = . ;
		if InfectionDate_3_index > PrDate_index-14 then InfectionDate_3_index = . ;

		Last_vaccination_date_index = max(fully_vaccinated_Date_index, fully_Booster_vacc_Date_index, InfectionDate_1_index, InfectionDate_2_index, InfectionDate_3_index) ;
			format Last_vaccination_date_index date9. ;

		length Vaccination_status_index $ 18 ;
		Vaccination_status_index = "Fully vaccinated" ;
		if Last_vaccination_date_index = . then Vaccination_status_index = "Not vaccinated" ;
		if fully_Booster_vacc_Date_index ne . then Vaccination_status_index = "Booster vaccinated" ;

		Days_since_vaccination_index = PrDate_index - Last_vaccination_date_index  ;

		Partially_vaccinated_index = 0 ;
		if  first_VaccineDate_index < PrDate_index <= fully_vaccinated_Date_index then Partially_vaccinated_index = 1 ;



		length Vaccination_status_index_2 $ 25 ;
		if Last_vaccination_date_index = . then Vaccination_status_index_2 = "NoVacc_NoPrevInfect" ;
		if fully_vaccinated_Date_index = . and fully_Booster_vacc_Date_index = . and InfectionDate_1_index NE . then Vaccination_status_index_2 = "NoVacc_YesPrevInfect" ;
		if fully_vaccinated_Date_index NE . and fully_Booster_vacc_Date_index = . and InfectionDate_1_index = . then Vaccination_status_index_2 = "YesVacc_NoPrevInfect" ;
		if fully_vaccinated_Date_index NE . and fully_Booster_vacc_Date_index = . and InfectionDate_1_index NE . then Vaccination_status_index_2 = "YesVacc_YESPrevInfect" ;
		if fully_Booster_vacc_Date_index NE . then Vaccination_status_index_2 = "BoosterVacc" ;

run;

proc sql;
	create table	data.Contact_house_6

	as select distinct
						C.*,
						D.*,
						MA.PrDate as PrDate_PCR,
						MA.test_pos as test_pos_PCR,
						MA.Test as Test_PCR,
						MA.CT_value,
						MB.PrDate as PrDate_Antigen,
						MB.test_pos as test_pos_Antigen,
						MB.Test as Test_Antigen,
						PV.variant as variant_secondary,
						PV.TCD as TCD_secondary

	from			data.Contact_house_5X		C

	right join		data.dates_day_final		D
		on 	C.pnr
		and	c.PrDate_index -0 <= d.date <= c.PrDate_index +14

	left join		DATA.miba_final_1			MA
		on C.pnr = MA.pnr
		and D.date = MA.PrDate
		and MA.Casedef = "SARS2"

	left join		DATA.miba_final_1			MB
		on C.pnr = MB.pnr
		and D.date = MB.PrDate
		and MB.Casedef = "SARSG"

	left join		data.Positive_PCR_Tests_4 		PV
		on MA.PNR = PV.pnr
		and MA.PrDate = PV.PrDate

	where c.pnr ^= ""

	order by
			house_number,
			pnr,
			date
;quit;


data data.Contact_house_7 ;
	set data.Contact_house_6 ;
		time_from_index = date - PrDate_index ;

		* ANY Test + PCR Test ;
		if Test_PCR = . then Test_PCR = 0 ;
		if Test_Antigen = . then Test_Antigen = 0 ;
		Test_any = max(Test_PCR,Test_Antigen) ;
		test_pos_any = max(test_pos_PCR,test_pos_Antigen) ;
		if test_pos_Antigen = 1 and test_pos_PCR = 0 then test_pos_any = 0 ;

			by house_number pnr ;
				if first.pnr then 
					do;
						test_cum 	 = 0 ;
						test_pos_cum = 0 ;
						test_cum_PCR 	 = 0 ;
						test_pos_cum_PCR = 0 ;
					end;
					test_cum 		+ Test_any ;
					test_pos_cum 	+ test_pos_any ;
					test_cum_PCR 		+ Test_PCR ;
					test_pos_cum_PCR 	+ test_pos_PCR ;

		ever_test 		= min(test_cum,1) ;
		ever_test_pos	= min(test_pos_cum,1) ;
		ever_test_PCR 		= min(test_cum_PCR,1) ;
		ever_test_pos_PCR	= min(test_pos_cum_PCR,1) ;

		ever_test_1 	= min(test_cum,1) ;
		ever_test_pos_1	= min(test_pos_cum,1) ;

		ever_test_PCR_1 	= min(test_cum_PCR,1) ;
		ever_test_pos_PCR_1	= min(test_pos_cum_PCR,1) ;

		ever_test_2 	= min(test_cum,2) ;
			if ever_test_2 < 2 then ever_test_2 = 0 ;
			if ever_test_2 = 2 then ever_test_2 = 1 ;
		ever_test_pos_2	= min(test_pos_cum,2) ;
			if ever_test_pos_2 < 2 then ever_test_pos_2 = 0 ;

		ever_PCR_test_2 	= min(test_cum_PCR,2) ;
			if ever_PCR_test_2 < 2 then ever_test_PCR_2 = 0 ;
			if ever_PCR_test_2 = 2 then ever_test_PCR_2 = 1 ;
		ever_test_pos_PCR_2	= min(test_pos_cum_PCR,2) ;
			if ever_test_pos_PCR_2 < 2 then ever_test_pos_PCR_2 = 0 ;
run;





proc sql;
	create table data.first_day

	as select
				pnr,
				test_pos_any,
				test_pos_cum,
				time_from_index

	from data.Contact_house_7

	where 	test_pos_any = 1
	and		test_pos_cum = 1
;quit;

proc sql;
	create table data.Contact_house_8

	as select
				C.*,
				F.time_from_index as test_pos_day

	from		data.Contact_house_7	C

	left join	data.first_day			F
		on C.pnr = F.pnr
;quit;

data data.Contact_house_8 ;
	set data.Contact_house_8 ;
		if test_pos_day = . then test_pos_day = 99 ;
run;

data data.CO_prim_homes_1 ;
	set data.Contact_house_8 ;	
		where 	time_from_index = 14 ;
			keep
				test_pos_day
				house_number
				co_primary_dayZERO_home
				;

		co_primary_dayZERO_home = 0 ;
		if test_pos_day = 0 then co_primary_dayZERO_home = 1 ;
run;

proc sql;
	create table	data.Co_primary_homes

	as select distinct 	
						house_number,
						max(co_primary_dayZERO_home) as co_primary_dayZERO_home

	from data.CO_prim_homes_1

	group by house_number
;quit;

/*
proc means data = data.Co_primary_homes ;
	var co_primary_dayZERO_home ;
RUN;
*/
	
proc sql;
	create table data.Contact_house_9

	as select
				A.*,
				C.co_primary_dayZERO_home

	from 		data.Contact_house_8			A

	left join 	data.Co_primary_homes	C
		on A.house_number = C.house_number
;quit;



data data.Contact_house_10 ;
	set data.Contact_house_9 ;
		where
			co_primary_dayZERO_home = 0 
			;

		ever_test_100 = ever_test*100 ;
		ever_test_pos_100 = ever_test_pos*100 ; 

		ever_test_PCR_100 = ever_test_PCR*100 ;
		ever_test_pos_PCR_100 = ever_test_pos_PCR*100 ; 

		ever_test_1_100 	= ever_test_1*100 ;
		ever_test_pos_1_100	= ever_test_pos_1*100 ;
		ever_test_2_100 	= ever_test_2*100 ;
		ever_test_pos_2_100	= ever_test_pos_2*100 ;

		ever_test_PCR_1_100 	= ever_test_PCR_1*100 ;
		ever_test_pos_PCR_1_100	= ever_test_pos_PCR_1*100 ;
		ever_test_2_PCR_100 	= ever_test_PCR_2*100 ;
		ever_test_pos_PCR_2_100	= ever_test_pos_PCR_2*100 ;

		* Dummies for OR-interaction ;

		length Vacc_omicron_group $ 20 ;
		if Vaccination_status = "Not vaccinated" 		and variant_index = "Delta" then Vacc_omicron_group = "DEL_NoVacc" ;
		if Vaccination_status = "Fully vaccinated" 		and variant_index = "Delta" then Vacc_omicron_group = "DEL_FullVacc" ;
		if Vaccination_status = "Booster vaccinated" 	and variant_index = "Delta" then Vacc_omicron_group = "DEL_BoostVacc" ;

		if Vaccination_status = "Not vaccinated" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group = "OMI_BA1_NoVacc" ;
		if Vaccination_status = "Fully vaccinated" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group = "OMI_BA1_FullVacc" ;
		if Vaccination_status = "Booster vaccinated" 	and variant_index = "Omicron - BA.1" then Vacc_omicron_group = "OMI_BA1_BoostVacc" ;

		if Vaccination_status = "Not vaccinated" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group = "OMI_BA2_NoVacc" ;
		if Vaccination_status = "Fully vaccinated" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group = "OMI_BA2_FullVacc" ;
		if Vaccination_status = "Booster vaccinated" 	and variant_index = "Omicron - BA.2" then Vacc_omicron_group = "OMI_BA2_BoostVacc" ;

		length index_Vacc_omicron_group  $ 20 ;
		if Vaccination_status_index = "Not vaccinated" 		and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group = "OMI_BA1_NoVacc" ;
		if Vaccination_status_index = "Fully vaccinated" 	and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group = "OMI_BA1_FullVacc" ;
		if Vaccination_status_index = "Booster vaccinated" 	and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group = "OMI_BA1_BoostVacc" ;

		if Vaccination_status_index = "Not vaccinated" 		and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group = "OMI_BA2_NoVacc" ;
		if Vaccination_status_index = "Fully vaccinated" 	and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group = "OMI_BA2_FullVacc" ;
		if Vaccination_status_index = "Booster vaccinated" 	and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group = "OMI_BA2_BoostVacc" ;



		length Vacc_omicron_group_2 $ 25 ;
		if Vaccination_status_2 = "NoVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group_2 = "BA1_NoVacc_NoPrevInfect" ;
		if Vaccination_status_2 = "NoVacc_YesPrevInfect" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group_2 = "BA1_NoVacc_YesPrevInfect" ;
		if Vaccination_status_2 = "YesVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group_2 = "BA1_YesVacc_NoPrevInfect" ;
		if Vaccination_status_2 = "YesVacc_YESPrevInfect" 		and variant_index = "Omicron - BA.1" then Vacc_omicron_group_2 = "BA1_YesVacc_YESPrevInfect" ;
		if Vaccination_status_2 = "BoosterVacc" 				and variant_index = "Omicron - BA.1" then Vacc_omicron_group_2 = "BA1_BoosterVacc" ;
		if Vaccination_status_2 = "NoVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group_2 = "BA2_NoVacc_NoPrevInfect" ;
		if Vaccination_status_2 = "NoVacc_YesPrevInfect" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group_2 = "BA2_NoVacc_YesPrevInfect" ;
		if Vaccination_status_2 = "YesVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group_2 = "BA2_YesVacc_NoPrevInfect" ;
		if Vaccination_status_2 = "YesVacc_YESPrevInfect" 		and variant_index = "Omicron - BA.2" then Vacc_omicron_group_2 = "BA2_YesVacc_YESPrevInfect" ;
		if Vaccination_status_2 = "BoosterVacc" 				and variant_index = "Omicron - BA.2" then Vacc_omicron_group_2 = "BA2_BoosterVacc" ;

		length index_Vacc_omicron_group_2 $ 25 ;
		if Vaccination_status_index_2 = "NoVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group_2 = "BA1_NoVacc_NoPrevInfect" ;
		if Vaccination_status_index_2 = "NoVacc_YesPrevInfect" 		and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group_2 = "BA1_NoVacc_YesPrevInfect" ;
		if Vaccination_status_index_2 = "YesVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group_2 = "BA1_YesVacc_NoPrevInfect" ;
		if Vaccination_status_index_2 = "YesVacc_YESPrevInfect" 	and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group_2 = "BA1_YesVacc_YESPrevInfect" ;
		if Vaccination_status_index_2 = "BoosterVacc" 				and variant_index = "Omicron - BA.1" then index_Vacc_omicron_group_2 = "BA1_BoosterVacc" ;
		if Vaccination_status_index_2 = "NoVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group_2 = "BA2_NoVacc_NoPrevInfect" ;
		if Vaccination_status_index_2 = "NoVacc_YesPrevInfect" 		and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group_2 = "BA2_NoVacc_YesPrevInfect" ;
		if Vaccination_status_index_2 = "YesVacc_NoPrevInfect" 		and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group_2 = "BA2_YesVacc_NoPrevInfect" ;
		if Vaccination_status_index_2 = "YesVacc_YESPrevInfect" 	and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group_2 = "BA2_YesVacc_YESPrevInfect" ;
		if Vaccination_status_index_2 = "BoosterVacc" 				and variant_index = "Omicron - BA.2" then index_Vacc_omicron_group_2 = "BA2_BoosterVacc" ;



		* bi-months since vaccination ;
		BiMonth_since_Vaccinated = int(Days_since_vaccination/60)+1 ;
		if Days_since_vaccination = . then BiMonth_since_Vaccinated = 99 ;
		Month_since_Vaccinated = int(Days_since_vaccination/30)+1 ;
		if Days_since_vaccination = . then Month_since_Vaccinated = 99 ;

		if age > 70 then age_10 = 75 ;
		if age_index > 70 then age_index_10 = 75 ;
run;


data data.Analysis_daily_BIG ;
	set data.Contact_house_10 ;
		where  	0<=time_from_index<=14 
		and 	'20dec2021'd <= PrDate_index <= '28jan2022'd  
		;
		count = 1 ;

		
		same_variant = 0 ;
		if variant_index = variant_secondary then same_variant = 1 ;
		if variant_secondary in ("","Unknown") then same_variant = . ;

		same_variant_100 = same_variant*100 ;
run;

data data.Analysis_daily ;
	set data.Analysis_daily_BIG ;
		where variant_index in ("Omicron - BA.1", "Omicron - BA.2") ;
run;

data data.Analysis_final ;
	set data.Analysis_daily ;
		where variant_index in ("Omicron - BA.1", "Omicron - BA.2")
		and  time_from_index=7  ;
run;

data data.Analysis_final_14Days ;
	set data.Analysis_daily ;
		where variant_index in ("Omicron - BA.1", "Omicron - BA.2")
		and  time_from_index=14  ;
run;
/*
proc sql;
	select distinct PrDate_index
	from data.Analysis_final  
;quit;
proc sql;
	select distinct PrDate_index
	from data.Analysis_daily_BIG
;quit;


proc sql;
	select distinct PrDate_index
	from data.Analysis_daily_BIG
	where variant_index in ("Omicron - BA.1", "Omicron - BA.2")
;quit;

proc sql;
	select distinct variant_index
	from data.Analysis_daily_BIG
;quit;

proc sql;
	select 
			sum(same_variant)
	from data.Analysis_final
;quit;

proc sql;
	select 
			variant_secondary,
			sum(same_variant)
	from data.Analysis_final
	group by variant_secondary
;quit;
*/





/*
proc freq data = data.Analysis_final ;
	tables
		fully_vacc_no_omicron*booster_vacc_no_omicron*fully_vacc_yes_omicron*booster_vacc_yes_omicron*Suspected_omicron_index / list ;
run;

proc freq data = data.Analysis_final ;
	tables
		fully_vacc_no_omicron_index*booster_vacc_no_omicron_index*fully_vacc_yes_omicron_index*booster_vacc_yes_omicron_index*Suspected_omicron_index / list ;
run;

proc freq data = data.Analysis_final ;
	tables
		Suspected_omicron_index*vax_dummy*boost_dummy / list ;
run;
*/
proc sql;
	create table data.Primary_cases_stat

	as select distinct
						PNR_index,
						PrDate_index,
						ct_value_index,
						Age_index_5,
						Age_index_10,
						female_index,
						house_members,
						Vaccination_status_index,
						variant_index,
						TCD_index,
						first_VaccineName_adj_index,
						second_VaccineName_adj_index,
						Booster_VaccineName_adj_index,
						fully_vaccinated_Date_index,
						fully_Booster_vacc_Date_index,
						InfectionDate_1_index,
						InfectionDate_2_index,
						InfectionDate_3_index,
						Vaccination_status_index,
						Days_since_vaccination_index

	from data.Analysis_final

	order by variant_index desc
;quit;


/*
proc sql;
	select
			index_Vacc_omicron_group,
			count(*) as count

	from data.Analysis_final

	group by index_Vacc_omicron_group
;quit;
*/
