********************************
	BUILD_HouseHoldTransmission - START
********************************;

********************************
	BUILD - START
********************************;

%let in = In04942 ;
libname Data "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Data_Revision1\" ;

options compress = yes;
options obs = max ;
dm 'cle log' ;
options compress=yes ;


********;

/*
%let Update = 211214 ; %put &Update. ;
%let Update = 211215 ; %put &Update. ;
%let Update = 211216 ; %put &Update. ;
%let Update = 211217 ; %put &Update. ;
%let Update = 211218 ; %put &Update. ;
%let Update = 211219 ; %put &Update. ;
%let Update = 220121 ; %put &Update. ;
*/

%let Update = 220617 ; %put &Update. ;

**************;
** BUILD ;
**************;

* Formater ;
* %include "F:\Projekter\FSEID00004942\Formater_2019.sas" ;

* WGS ;
 %include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\WGS v2, Build.sas" ;

* DATES ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\DATES, Build.sas" ;

* CPR ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\CPR, Build.sas" ;

* Households from CPR ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\Households, Build.sas" ;

* Vaccinations ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\Vaccinations.sas" ;

* MIBA ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\MIBA, Build.sas" ;

* Merge ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\merge 2.sas" ;

%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\primary misclass_build.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Build_Revision1\Community Misclassification, Build.sas" ;


**************;
** ANALYSIS ;
**************;

* Descriptive Statistics ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Descriptive Stats.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Overall Stats.sas" ;

* Testing plots ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Prob Test_SMALL_7Days.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Prob Test_SMALL_14Days.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Prob Test_BIG_14Days.sas" ;

* Sampling prob ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\WGS_prob of sampling by Age_TCDK.sas" ;

* Primary case ct value ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Primary Case Ct Value.sas" ;

* model test ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Model selection, AIC.sas" ;

* misclassifications ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Community Misclassification.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Prob Test_SMALL_14Days_2PersonHH.sas" ;

* model estimates ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Model1_parms_Estimates.sas" ;


* Estimates for Constrast plot ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\Model1_parms_COV_dummy_2.sas" ;


* OR estimates ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\OR Estimates_relative effect.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\OR Estimates_relative effect_statification.sas" ;


* extra specifications ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Omicron_BA1_BA2\Analysis_Revision1\OR - Extra models.sas" ;










*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	BUILD - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
