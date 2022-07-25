
proc sql;
	create table All_pop

	as select distinct 
						pnr,
						house_number,
						house_members

	from data.Analysis_daily
;quit;

proc sql;
	create table first_test

	as select
				pnr,
				min(time_from_index) as first_test

	from data.Analysis_daily

	where ever_test = 1
	and time_from_index <= 14

	group by pnr
;quit;

proc sql;
	create table first_test_pos

	as select
				pnr,
				min(time_from_index) as first_test_pos

	from data.Analysis_daily

	where ever_test_pos = 1
	and time_from_index <= 14

	group by pnr
;quit;

proc sql;
	create table test

	as select
				a.*,
				f.*,
				p.*

	from		All_pop			a
	left join	first_test		f
		on a.pnr = f.pnr
	left join	first_test_pos	p
		on a.pnr = p.pnr

	order by house_number
;quit;

data test ;
	set test ;

		tested = 1 ;
		if first_test = . then tested = 0 ;

		test_neg_confirm = 0 ;
		if first_test < first_test_pos or first_test_pos = . then test_neg_confirm = 1 ;
		if tested=0 then test_neg_confirm = 0 ;

		if first_test = first_test_pos then test_neg_before_pos = 0 ;
		if first_test < first_test_pos then test_neg_before_pos = 1 ;

		count = 1 ;
run;

proc means data = test n sum mean maxdec=2;
	var 
		count
		tested
		test_neg_confirm
		first_test_pos
		test_neg_before_pos
		;
run;

proc sql;
	create table test_hh

	as select 
			house_number,
			mean(tested) as tested,
			mean(test_neg_confirm) as test_neg_confirm,
			mean(test_neg_before_pos) as test_neg_before_pos,
			mean(count) as count_HH,
			count(*) as contacts

	from test

	group by house_number
;quit;

proc sql;
	create table data.Analysis_final_2

	as select
				A.*,
				T.*

	from 		data.Analysis_final 	A

	left join	test_hh					T
		on A.house_number = T.house_number

	order by variant_index 
;quit;



/*
proc genmod data = Analysis_final_2 plots=none ;
	class 
			house_number 
			Vaccination_status (ref="Not vaccinated")
			Vaccination_status_index (ref="Not vaccinated")
			/ param=glm;
	model	test_neg_before_pos = 	Suspected_omicron_index	Vaccination_status*Suspected_omicron_index  /  ;
	repeated subject=house_number / type=ind ;	
run;quit; 

proc means data = test_hh  sum n ;
	where test_neg_confirm = 1 ;
	var contacts count_HH ;
run;

proc means data = test_hh  sum n ;
	*where tested = 1 ;
	var contacts count_HH ;
run;

proc means data = test_hh  sum n ;
	where tested = 1 ;
	var contacts count_HH ;
run;

proc means data = test_hh  sum n ;
	where test_neg_before_pos > 0 and test_neg_confirm = 1 ;
	var contacts count_HH ;
run;

proc means data = test_hh  sum n ;
	where test_neg_before_pos > 0 and test_neg_confirm = 1 ;
	class contacts ;
	var contacts count_HH ;
run;

*/
