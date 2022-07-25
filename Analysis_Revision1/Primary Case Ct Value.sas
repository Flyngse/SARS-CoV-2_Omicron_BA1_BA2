
*****
* Ct value distribution for primary cases - Histogram¨;


proc sort data = data.Primary_cases_stat ;	 
	by descending vaccination_status_index ;
run;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\Ct_value.xlsx" ;
proc means data = data.Primary_cases_stat q1 median q3 mean STD maxdec=2 ;
	class vaccination_status_index variant_index ;
	var ct_value_index ;
run;
ods excel close ;

/*
ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = data.Primary_cases_stat ;
		styleattrs 
				datacontrastcolors = (red blue ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid longdash ) 
				datacolors=(red blue ) 
				;
	density	ct_value_index / type=kernel 
						group=variant_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Variant"  position=topright location=inside across=1 noborder opaque;

run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = data.Primary_cases_stat ;
	by descending vaccination_status_index ;
		styleattrs 
				datacontrastcolors = (red blue ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid longdash ) 
				datacolors=(red blue ) 
				;
	density	ct_value_index / type=kernel 
						group=variant_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Variant"  position=topright location=inside across=1 noborder opaque;

run;
*/


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density_FULLvaccinated" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = data.Primary_cases_stat ;
	where vaccination_status_index = "Fully vaccinated";
		styleattrs 
				datacontrastcolors = (red blue ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid longdash ) 
				datacolors=(red blue ) 
				;
	density	ct_value_index / type=kernel 
						group=variant_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Variant"  position=topright location=inside across=1 noborder opaque;

run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density_Unvaccinated" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = data.Primary_cases_stat ;
	where vaccination_status_index = "Not vaccinated";
		styleattrs 
				datacontrastcolors = (red blue ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid longdash ) 
				datacolors=(red blue ) 
				;
	density	ct_value_index / type=kernel 
						group=variant_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Variant"  position=topright location=inside across=1 noborder opaque;

run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Output_Revision1\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density_booster" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = data.Primary_cases_stat ;
	where vaccination_status_index = "Booster vaccinated";
		styleattrs 
				datacontrastcolors = (red blue ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid longdash ) 
				datacolors=(red blue ) 
				;
	density	ct_value_index / type=kernel 
						group=variant_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Variant"  position=topright location=inside across=1 noborder opaque;

run;
