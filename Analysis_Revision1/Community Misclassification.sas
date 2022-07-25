
* Overall, pool, 1-7 days ;
ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 ;
	*by variant_index ;
	class house_number  C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

* by subvariant ;
ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 ;
	by variant_index ;
	class house_number C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;


ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 and variant_share_belowMedian = 1;
	*by variant_index ;
	class house_number C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 and variant_share_AboveMedian = 1;
	*by variant_index ;
	class house_number C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;





ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 and incidence_AboveMedian = 1;
	*by variant_index ;
	class house_number C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_Muni plots=none ;
	where same_variant ne . and 1<=time_from_index<=7 and incidence_BelowMedian = 1;
	*by variant_index ;
	class house_number C_KOM	/ param=glm;
	model	same_variant = count   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;
