


proc sort data = data.Analysis_daily_BIG ;
	by variant_index ;
run;

ods output GeeemppEst = parms ;
proc genmod data = data.Analysis_daily_BIG plots=none ;
	*where PrDate_index <= '05JAN2022'd ;
	by variant_index ;
	class 
			house_number 
			time_from_index
			/ param=glm;
	model	ever_test_pos_100 = time_from_index   / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

data parms ;
	set parms ;
		Days = Level1+0 ;
		format estimate comma10.0 ;

		format LowerCL comma10.0 ;
		format UpperCL comma10.0 ;

		if variant_index = "Omicron - BA.1" then sort = 2 ;
		if variant_index = "Omicron - BA.2" then sort = 1 ;
		if variant_index = "Delta" then sort = 4 ;
		if variant_index = "Unknown" then sort = 3 ;

run;

proc sort data = parms ;
	by sort  ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "ProbTestPos_BIG_14Days" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title ;
proc sgplot data = parms ;
	where Days > 0 ;
	styleattrs 
				datacontrastcolors = (red blue gray purple) 
				datasymbols=( trianglefilled diamondfilled circlefilled starfilled) 
				datalinepatterns=( solid solid solid solid) 
				datacolors=(red blue gray purple) 
				;
	series
			y= estimate
			x= Days
			/ markers group=variant_index name="estimates" datalabel=estimate 
			;
		band 
			x = Days
			lower=LowerCL
			upper=UpperCL
			/   transparency = 0.9  group=variant_index name="band" ;

	yaxis 
			values = (0 to 50 by 10) 
			label = "Secondary Attack Rate (%)" ;
	xaxis 
			values = (0 to 14 by 1) 
			label = "Days since primary case" 
			;

	keylegend "estimates" / Title="Variant" location=inside position=bottomright across=1 exclude=("band")  noborder opaque;
run;
