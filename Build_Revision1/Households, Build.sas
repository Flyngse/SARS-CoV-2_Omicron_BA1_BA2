********************************
	Households - START
********************************;

* DATE 14-12-2021 ;

/*
data DATA.CPR3_T_ADRESSE ;
	set &in..CPR3_T_ADRESSE ;
run;
*/

/*
proc sql;
	create table DATA.CPR_adresse_raw

	as select distinct

						V_PNR_ENCRYPTED as pnr,
						C_KOM,
						C_VEJ_ENCRYPTED,
						V_HUSNUM,
						V_ETAGE,
						V_SIDEDOER

	from DATA.CPR3_T_ADRESSE
;quit;
*/

data CPR_adresse_raw ;
	set DATA.CPR_adresse_raw ;
run;

* Unikke adresser ;
proc sql;
	create table home_distinct

	as select distinct
						C_KOM,
						C_VEJ_ENCRYPTED,
						V_HUSNUM,
						V_ETAGE,
						V_SIDEDOER

	from CPR_adresse_raw
;quit;

data home_distinct ;
	set home_distinct ;
		house_number = _n_ ;
run;

* merge alle medbeboere ;
proc sql;
	create table 	home_full

	as select	
				R.pnr,
				R.C_KOM,
				D.house_number,
				P.age,
				P.age_5,
				P.age_10,
				p.Age_20,
				p.agegroup_2,
				P.female

	from 		data.CPR_adresse_raw	R

	left join	home_distinct			D
		on 	R.C_KOM = D.C_KOM
		and	R.C_VEJ_ENCRYPTED = D.C_VEJ_ENCRYPTED
		and	R.V_HUSNUM = D.V_HUSNUM
		and	R.V_ETAGE = D.V_ETAGE
		and	R.V_SIDEDOER = D.V_SIDEDOER

	left join	data.cpr_final			P
		on R.pnr = P.pnr
;quit;

data home_full ;
	set home_full ;
		where age ne . and female ne . ;
run;

* Numbers per adress ;
proc sql;
	create table home_count

	as select
			house_number,
			count(pnr) as house_members

	from 	home_full

	group by 
			house_number
;quit;

* merge ;
proc sql;
	create table 	DATA.home_full_2

	as select	
				H.*,
				C.house_members

	from 		home_full	H

	left join	home_count	C
		on H.house_number = C.house_number

	where 2 <= house_members <= 6
;quit;

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	CPR - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;


/*
proc sql;
	create table househould_size

	as select
			house_members,
			count(distinct house_number) as homes

	from	home_full_2

	where house_members < 20

	group by 
			house_members
;quit;

proc sgplot data = househould_size ;
	where house_members < 10 ;
	vbar
			house_members / response = homes ;
run;
*/
