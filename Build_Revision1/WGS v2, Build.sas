proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Data_Revision1\wgs_data_20220617_cpr10.csv"
	out 		= WGS
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
	guessingrows = 10000 ;
run; 

data data.WGS_JUNE ;
	set WGS ;
		where date_sampling ne . ;		
		rename CPR_ENCRYPTED = pnr ;

		WGS_Selection = 0 ;
		if sequence_status ne "not_sequenced" then WGS_Selection = 1 ;

		WGS_genome = 0 ;
		if sequence_status = "genome" then WGS_genome = 1 ;

		/*
		if lineage = "BA.1" then variant = "Omicron - BA.1" ;
		if lineage = "BA.2" then variant = "Omicron - BA.2" ;
		if WHO_variant = "Delta" then Variant = "Delta" ;
		*/
		
		if substr(lineage,1,4) = "BA.2" then variant = "Omicron - BA.2" ;
		if substr(lineage,1,4) = "BA.1" then variant = "Omicron - BA.1" ;
		if WHO_variant = "Delta" then Variant = "Delta" ;

		keep
			CPR_ENCRYPTED
			sequence_status
			Episodekey
			date_sampling
			date_sequencing
			WHO_variant
			lineages_of_interest
			lineage
			WGS_Selection
			WGS_genome
			variant			
			;
run;


proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Data_Revision1\wgs_data_20220121_cpr10.csv"
	out 		= WGS
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
	guessingrows = 10000 ;
run; 

data data.WGS_JAN ;
	set WGS ;
		where date_sampling ne . ;
		
		rename CPR_ENCRYPTED = pnr ;

		WGS_Selection = 0 ;
		if sequence_status ne "not_sequenced" then WGS_Selection = 1 ;

		WGS_genome = 0 ;
		if sequence_status = "genome" then WGS_genome = 1 ;

		/*
		if lineage = "BA.1" then variant = "Omicron - BA.1" ;
		if lineage = "BA.2" then variant = "Omicron - BA.2" ;
		if WHO_variant = "Delta" then Variant = "Delta" ;
		*/
		
		if substr(lineage,1,4) = "BA.2" then variant = "Omicron - BA.2" ;
		if substr(lineage,1,4) = "BA.1" then variant = "Omicron - BA.1" ;
		if WHO_variant = "Delta" then Variant = "Delta" ;
		
		keep
			CPR_ENCRYPTED
			sequence_status
			Episodekey
			date_sampling
			date_sequencing
			WHO_variant
			lineages_of_interest
			lineage
			WGS_Selection
			WGS_genome
			variant			
			;
run;



proc sql;
	create table WGS_temp

	as select
				A.*,
				b.pnr as pnr_JAN,
				b.date_sampling as date_sampling_JAN,
				b.variant as variant_JAN,
				b.WGS_Selection as WGS_Selection_JAN,
				b.WGS_genome as WGS_genome_JAN,
				b.lineage as lineage_JAN


	from 				data.WGS_JUNE		A

	full outer join		data.WGS_JAN			B
		on A.pnr = b.pnr
		and a.date_sampling = b.date_sampling

;quit;

data aa ;
	set WGS_temp ;
		where pnr = "" ;
run;

data WGS_temp_2 ;
	set WGS_temp ;
		WGS_JUNE = 1 ;
		if pnr = "" then 
			do;
				WGS_JUNE = 0 ;
				variant = variant_JAN ;
				date_sampling = date_sampling_JAN ;
				WGS_Selection = WGS_Selection_JAN ;
				WGS_genome = WGS_genome_JAN ;
				pnr = pnr_JAN ;			
				lineage = lineage_JAN ;	
			end;
run;

data data.WGS ;
	set WGS_temp_2 ;

		keep
			pnr
			date_sampling
			lineage
			WGS_Selection
			WGS_genome
			variant			
			;
run;

/*
data temptemp ;
	set data.WGS ;
		where '01dec2021'd <= date_sampling <= '01mar2022'd ;
run;
	

proc sql;	
	select
			WGS_genome,
			variant,
			count(*) as count

	from temptemp

	group by 
			WGS_genome,
			variant
;quit;


data aa ;
	set temptemp ;
		where WGS_genome = 1 and variant = "" ;
run;


proc sql;
	select
			date_sampling,
			variant,
			count(*) as count 

	from temptemp

	where variant <> ""

	group by
			date_sampling,
			variant
;quit;
*/
