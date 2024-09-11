%let StateName=Hawaii;

/*1. ACCESSING DATA:
Import the TSAClaims2002_2017.csv file.*/
libname tsa "/home/u63924529";
run;
options validvarname=v7;

proc import datafile="/home/u63924529/ECRB94/data/TSAClaims2002_2017.csv" 
		dbms=csv out=tsa.claims_cleaned replace;
	guessingrows=max;
run;

  /*2. EXPLORING DATA*/
proc print data=tsa.claims_cleaned(obs=100);
	id Claim_Number;
	*where Close_Amount is not missing;
	where State is not missing;
run;

proc contents data=tsa.claims_cleaned;
run;

proc freq data=tsa.claims_cleaned;
	tables Claim_Type Claim_Site Disposition;
run;

/*Removing duplicates:*/
proc sort data=tsa.claims_cleaned out=tsa.claims_nodup nodupkey 
		dupout=tsa.claims_dup;
	by _all_;
run;

/*Sorting by Incident_Date*/
proc sort data=tsa.claims_nodup;
    by Incident_Date;
run;

/*Since there are other Claim_Type values that don't appear
in the report requirements, we will need to make some changes:
- Change '-' and missing values to 'Unknown'.
- Rearrange the values Passenger Property Loss/Personal Injur
and Passenger Property Loss/Personal Injury into PPL.
- Rearrange the value Property Damage/Personal Injury into PD. 
Claim_Site changes:
- Change '-' and missing values to 'Unknown'.
Disposition changes:
- Change '-' and missing values to 'Unknown'.
- Change Closed: Canceled to Closed:Canceled.
- Rearrange the value losed: Contractor Claim into Closed:Contractor Claim.
The table must include a new column named Date_Issues with a value of Needs Review to
indicate that a row has a date issue. Date issues consist of the following:
  • a missing value for Incident_Date or Date_Received
  • an Incident_Date or Date_Received value out of the predefined year 
  range of 2002 through 2017
  • an Incident_Date value that occurs after the Date_Received value
- The County and City columns should not be included in the output table.
- Currency should be permanently formatted with a dollar sign and include two decimal points.
- All dates should be permanently formatted in the style 01JAN2000.
- Permanent labels should be assigned to columns by replacing any underscore with a space.
- Final data should be sorted in ascending order by Incident_Date.*/

  /*3. PREPARING DATA*/
data tsa.claims_clean;
	set tsa.claims_nodup;
  *Cleaning Claim_Type;
	if Claim_Type in("", "-") then Claim_Type="Unknown";
	  else if Claim_Type in("Passenger Property Loss/Personal Injur", 
		                    "Passenger Property Loss/Personal Injury") 
           then Claim_Type="Passenger Property Loss";
      else if Claim_Type="Property Damage/Personal Injury" 
           then Claim_Type="Property Damage";
  *Cleaning Claim_Site;
    if Claim_Site in("", "-") then Claim_Site="Unknown";
  *Cleaning Disposition;  
	if Disposition in("", "-") then Disposition="Unknown";
	  else if Disposition="Closed: Canceled" then Disposition="Closed:Canceled";
	  else if Disposition="losed: Contractor Claim" then Disposition="Closed:Contractor Claim";
  *StateName -> proper case;
    StateName=propcase(StateName);
  *State -> upper case;
    State=upcase(State);
  *Date_Issues;
    if (Incident_Date=. or 
       Date_Received=. or
       year(Incident_Date)<2002 or 
       year(Incident_Date)>2017 or
       year(Date_Received)<2002 or 
       year(Date_Received)>2017 or
       Incident_Date>Date_Received) then 
       Date_Issues="Needs Review";
   *Formatting;
     format Close_Amount dollar20.2 Date_Received Incident_Date date9.;
   *Labels;
     label Claim_Number="Claim Number"
           Date_Received="Date Received"
           Incident_Date="Incident Date"
           Airport_Code="Airport Code"
           Airport_Name="Airport Name"
           Claim_Type="Claim Type"
           Claim_Site="Claim Site"
           Item_Category="Item Category"
           Close_Amount="Close Amount"
           Date_Issues="Date Issues";
   *Drop County and City;
     drop County City;
run;

  /*4. ANALYZING AND EXPORTING DATA*/
 
/*The final single PDF report must answer the following questions:*/

ods pdf file="/home/u63924529/ECRB94/output/ClaimReports.pdf" 
  style=sapphire startpage=no pdftoc=1;
  options nodate nonumber;
ods noproctitle;

ods proclabel "Overall Data Questions";
   *1. How many date issues are in the overall data?;
title "Date Issues";
proc freq data=tsa.claims_clean order=freq;
  tables Date_Issues / missing nocum nopercent;
run;
title clean;

ods proclabel "Overall Claims by Year ";
/*For the remaining analyses, exclude all rows with date issues.*/
   *2. How many claims per year of Incident_Date are in the overall data? Be sure to include a plot.;
*As it's a discrete measurement, I'll represent the data through a bar chart.;
ods graphics on;
title "Claims by Year";
proc freq data=tsa.claims_clean;
  tables Incident_Date / nocum nopercent plots=freqplot;
  format Incident_Date year4.;
  where Date_Issues is null;
run;
title clean;

ods proclabel "State-Level Data Questions: &StateName Statistics";
   *3. Lastly, a user should be able to dynamically input a specific state value and answer the following:;
       *a. What are the frequency values for Claim_Type for the selected state?;
       *b. What are the frequency values for Claim_Site for the selected state?;
       *c. What are the frequency values for Disposition for the selected state?;
title "&StateName's Claim Types, Claim Sites and Dispositions";
proc freq data=tsa.claims_clean order=freq;
   tables Claim_Type Claim_Site Disposition / nocum nopercent;
   where StateName="&StateName" and 
         Incident_Date is null;
run;
title;
       *d. What is the mean, minimum, maximum, and sum of Close_Amount for the selected state? 
          The statistics should be rounded to the nearest integer.;
title "Close Amount in &StateName";
proc means data=tsa.claims_clean mean min max sum maxdec=0;
  var Close_Amount;
  where StateName="&StateName" and Incident_Date is null;
run;
title;

ods pdf close;