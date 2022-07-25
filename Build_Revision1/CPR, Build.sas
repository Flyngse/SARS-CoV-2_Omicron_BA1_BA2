********************************
	CPR - START
********************************;

data Cpr_final ;
	set DATA.Cpr_final ;
run;

* DATE 14-12-2021 ;


/*
proc sql;
	create table CPR

	as select distinct
						V_PNR_ENCRYPTED as pnr,
						C_KON,
						C_STATUS,
						D_FODDATO

	from In04942.CPR3_T_PERSON

	where C_STATUS = "01"

;quit;
*/

/*

data DATA.CPR_final ;
	set CPR ;

		* Aldersgrupper ;
		age = 2021-year(D_FODDATO) ;

		length agegroup_2 $ 8 ;
		if 			age < 15 then agegroup_2 = "0 to 14" ;
		if 15 <=	age < 20 then agegroup_2 = "15 to 19" ;
		if 20 <=	age < 40 then agegroup_2 = "20 to 39" ;
		if 40 <=	age < 60 then agegroup_2 = "40 to 59" ;
		if 60 <=	age < 80 then agegroup_2 = "60 to 79" ;
		if 80 <=	age 	 then agegroup_2 = "80+" ;

		Age_20 = (int((age - 1) / 20) + 1 ) * 20 - 10 ;

		Age_10 = (int((age - 1) / 10) + 1 ) * 10 - 5 ;

		Age_5 = (int((age - 1) / 5) + 1 ) * 5 - 2.5;

		* Køn ;
		if C_KON = "K" then Female = 1 ;
		if C_KON = "M" then Female = 0 ;

		count = 1 ;
run;
*/


*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	CPR - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;


/*
proc sql;
	select 
			agegroup,
			count(distinct pnr) as count

	from cpr

	group by agegroup
;quit;
*/
