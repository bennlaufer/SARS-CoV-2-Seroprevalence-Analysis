


/*import PI dataset*/
PROC SQL;
CREATE TABLE WORK.query1 AS
SELECT gender , race2 , Census_Region , urban_rural , age_yrs2 , age_cat , true_sero , dhq_vaccinated , pat_id , pre_dt , post_dt , sci_dt , last_dt FROM _TEMP0.calpoly_pi;
RUN;
QUIT;

/*import RI dataset*/
PROC SQL;
CREATE TABLE WORK.query2 AS
SELECT ri_true_sero , gender , race2 , Census_Region , urban_rural , age_yrs2 , age_cat , pat_id , dhq_vaccinated2 , pre_dt , post_dt , sci_dt , last_dt FROM _TEMP1.calpoly_ri;
RUN;
QUIT;

/*combine datasets and join by pat_id, additionally makes new variable in dataset where the observation is classified as RI
b/c combined dataset shows same number of observation as PI dataset, we know that the RI dataset is a full subset of the PI dataset
*/

PROC SQL;
CREATE TABLE WORK.combined_data AS
  SELECT q1.*, q2.*,
         CASE WHEN q2.pat_id IS NULL THEN 'PI' ELSE 'RI' END AS data_source
  FROM WORK.query1 AS q1
  LEFT JOIN WORK.query2 AS q2
  ON q1.pat_id = q2.pat_id;
QUIT;

/*
everyone on the dataset has known infection whether its primary or primary and reinfection. 
Now we are comparing which ones reported that they had it and which ones had no idea

Is it useful to know what predictors there are to people self-reporting it or not?
*/


/* 
Logistic Regression 
*/

/* logistic regression WITHOUT significant interaction terms (Combined Dataset)*/
proc logistic data=WORK.combined_data;
  class gender age_cat race2 Census_Region dhq_vaccinated urban_rural data_source;
  model true_sero = gender age_cat race2 Census_Region dhq_vaccinated urban_rural data_source;
run;


/* logistic regression WITH significant interaction terms (Combined Dataset)*/
proc logistic data=WORK.combined_data;
  class gender age_cat race2 Census_Region dhq_vaccinated urban_rural data_source;
  model true_sero = gender age_cat race2 Census_Region dhq_vaccinated urban_rural data_source
                    gender*age_cat race2*Census_Region;
run;


/* logistic regression WITHOUT significant interaction terms RI Dataset*/
proc logistic data=WORK.Query2;
  class gender age_cat race2 Census_Region dhq_vaccinated2 urban_rural;
  model ri_true_sero = gender age_cat race2 Census_Region dhq_vaccinated2 urban_rural;
run;


/* logistic regression WITH significant interaction terms RI Dataset*/
proc logistic data=WORK.query2;
  class gender age_cat race2 Census_Region dhq_vaccinated2 urban_rural;
  model ri_true_sero = gender age_cat race2 Census_Region dhq_vaccinated2 urban_rural
                      gender*race2 gender*urban_rural
                      race2*urban_rural;
run;


/* 
ODDS RATIO
*/

/* odds ratio WITH CI (unadjusted)
Replace variables one at a time to get full output: 
List of variables to put:
gender age_cat race2 Census_Region dhq_vaccinated urban_rural*/
ods output OddsRatios=logistic_oddsratios;  /* Capture odds ratios */

proc logistic data=WORK.Query1;
  class gender;
  model true_sero = gender;
run;

ods output close;  /* Close the ODS output stream */


/* odds ratio WITH CI (adjusted) 
Put all variables down*/
ods output OddsRatios=logistic_oddsratios;  /* Capture odds ratios */

proc logistic data=WORK.Query1;
  class gender age_cat race2 Census_Region dhq_vaccinated urban_rural;
  model true_sero = gender age_cat race2 Census_Region dhq_vaccinated urban_rural;
run;

ods output close;  /* Close the ODS output stream */


/* Create frequency tables for gender and age_cat 
Look at each of the tables to get counts of each unique variable type (N) */
proc freq data=WORK.Query1;
  tables gender age_cat race2 Census_Region dhq_vaccinated urban_rural;
run;



data work.modified_query1;
   set work.query1;
   if age_yrs2 > 0 then log_age_yrs2 = log(age_yrs2);
   interaction = age_yrs2 * log_age_yrs2;
run;

proc logistic data=work.modified_query1;
   class gender race2 Census_Region urban_rural age_cat dhq_vaccinated;
   model true_sero = gender race2 Census_Region urban_rural age_cat dhq_vaccinated age_yrs2 interaction / lackfit;
run;


proc logistic data=WORK.query1;
   class gender race2 Census_Region urban_rural age_cat dhq_vaccinated;
   model true_sero = gender race2 Census_Region urban_rural age_cat dhq_vaccinated age_yrs2 / lackfit;
run;


ods graphics on;  /* Enable ODS graphics for producing plots */

/* Logistic regression with main effects plot for vaccination status */
proc logistic data=WORK.query1 plots(only)=effects;
   class dhq_vaccinated;
   model true_sero = dhq_vaccinated;
run;

ods graphics off;  /* Disable ODS graphics if not needed later */


