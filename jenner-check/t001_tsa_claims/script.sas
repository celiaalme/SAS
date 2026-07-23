%let StateName=Hawaii;

/*1. ACCESSING DATA:
Original case study imports TSAClaims2002_2017.csv via PROC IMPORT from a
SAS OnDemand path. For a self-contained, runnable bundle the same claims are
loaded inline below (a representative sample of the original file) into the
identical column layout the rest of the program expects. All downstream
cleaning, PROC, and reporting logic is unchanged from the original tsa.sas.*/
libname tsa ".";
run;
options validvarname=v7;

data tsa.claims_cleaned;
  length Claim_Number $20 Airport_Code $8 Airport_Name $60 Claim_Type $50 Claim_Site $30 Item_Category $130 Disposition $30 StateName $30 State $20 County $30 City $30;
  infile datalines dsd dlm='|' truncover;
  input Claim_Number : $char20. Date_Received : best32. Incident_Date : best32. Airport_Code : $char8. Airport_Name : $char60. Claim_Type : $char50. Claim_Site : $char30. Item_Category : $char130. Close_Amount : best32. Disposition : $char30. StateName : $char30. State : $char20. County : $char30. City : $char30.;
datalines;
2005062787294|16242|.|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Other|.||HAWAII|HI|HONOLULU|HONOLULU
2004101364925|16323|.|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Other|0||HAWAII|HI|HONOLULU|HONOLULU
0115033M|16085|.|HNL|Honolulu International Airport||Checked Baggage|Clothing - Shoes, belts, accessories, etc.|138|Settle|HAWAII|HI|HONOLULU|HONOLULU
0506124L|15831|.|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Luggage (all types including footlockers)|50|Settle|HAWAII|HI|HONOLULU|HONOLULU
1117499M|16026|.|HNL|Honolulu International Airport|Passenger Property Loss|Checkpoint|Cameras - Digital|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2005062487119|16610|.|HNL|Honolulu International Airport||Checked Baggage|Luggage (all types including footlockers)|.||HAWAII|HI|HONOLULU|HONOLULU
2005120797191|16762|.|KOA|Kona International|Passenger Property Loss|Checked Baggage|Eyeglasses - (including contact lenses)|.||HAWAII|HI|HAWAII|KAILUA/KONA
2004061756133|16204|.|KOA|Kona International|Passenger Property Loss|Checkpoint|Cameras - Digital|.||HAWAII|HI|HAWAII|KAILUA/KONA
2012112098793|19275|19267|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Baggage/Cases/Purses|10|Approve in Full|HAWAII|HI|HONOLULU|HONOLULU
2012100197302|19226|19185|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Clothing|43.81|Approve in Full|HAWAII|HI|HONOLULU|HONOLULU
2013012400229|19382|19340|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Personal Electronics|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2012071295343|19151|19135|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Food & Drink|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2013021401450|19380|19377|HNL|Honolulu International Airport|Property Damage|Checkpoint|Clothing|153.42|Settle|HAWAII|HI|HONOLULU|HONOLULU
2013021301409|19380|19312|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Travel Accessories|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2013012500364|19277|19223|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Sporting Equipment & Supplies|261.78|Approve in Full|HAWAII|HI|HONOLULU|HONOLULU
2013022201931|19403|19387|HNL|Honolulu International Airport|Property Damage|Checked Baggage|-|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2012110798415|19260|19258|HNL|Honolulu International Airport|Passenger Property Loss|Checked Baggage|Personal Electronics|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2012051593943|19106|19095|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Baggage/Cases/Purses|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
2017083142571|21062|20886|-|-|Property Damage/Personal Injury|-|Computer & Accessories; Personal Electronics|.|*Insufficient||||
2017110745011|21130|21060|-|-|Property Damage/Personal Injury|Checkpoint|Personal Electronics|.|*Insufficient||||
2018011146756|21150|20938|-|-|Passenger Property Loss/Personal Injury|Checked Baggage|Clothing; Jewelry & Watches; Medical/Science|.|*Insufficient||||
2017061340526|21152|20919|ATL|Hartsfield-Jackson Atlanta International Airport|Passenger Property Loss/Personal Injury|Checkpoint|Baggage/Cases/Purses|.|In Review|GEORGIA|GA|FULTON|ATLANTA
2017122646293|21174|21157|BWI|Baltimore/Washington Intl Thurgood Marshall|Passenger Property Loss/Personal Injury|Checkpoint|Cosmetics & Grooming|.|In Review|MARYLAND|MD|ANNE ARUNDEL|BALTIMORE
2018010946649|21179|21157|BWI|Baltimore/Washington Intl Thurgood Marshall|Passenger Property Loss/Personal Injury|Checkpoint|Other|.|Closed: Canceled|MARYLAND|MD|ANNE ARUNDEL|BALTIMORE
2017042138771|20874|20868|ABQ|Albuquerque International Sunport Airport|Property Damage|Checked Baggage|Other|.|Closed: Canceled|NEW MEXICO|NM|BERNALILLO|ALBUQUERQUE
2017051839725|20887|20884|ACY|Atlantic City International|Property Damage|Checked Baggage|Audio/Video|.|Closed: Canceled|NEW JERSEY|NJ|ATLANTIC|ATLANTIC CITY
2017111445118|21111|21024|ACY|Atlantic City International|Complaint|Other|-|.|Closed: Canceled|NEW JERSEY|NJ|ATLANTIC|ATLANTIC CITY
2017042138758|20930|20871|AIA|Alliance Municipal Airport|-|-|-|.|Closed: Canceled|NEBRASKA|NE|BOX BUTTE|ALLIANCE
2017110745018|21130|21128|ASE|Aspen Pitkin County Sardy Field|Passenger Property Loss|-|-|.|Closed: Canceled|COLORADO|CO|PITKIN|ASPEN
2017050139146|20891|20888|ATL|Hartsfield-Jackson Atlanta International Airport|Passenger Property Loss|Checkpoint|Computer & Accessories|.|Closed: Canceled|GEORGIA|GA|FULTON|ATLANTA
2010031769653|18329|18320|-|-|Passenger Property Loss|Checked Baggage|Clothing; Cosmetics & Grooming; Jewelry & Watches|.|-||||
2010020468312|18297|18297|-|-|-|-|-|.|-||||
2010022268640|18296|18285|-|-|Passenger Property Loss|Checked Baggage|Other|.|-||||
2010030969294|18326|18265|-|-|-|-|-|.|-||||
2010032570047|18343|18324|-|-|Passenger Property Loss|Checked Baggage|Other|.|-||||
2010020368206|18290|18266|-|-|Property Damage|-|Baggage/Cases/Purses|.|-||||
2010032269879|18336|18330|-|-|-|-|Computer & Accessories|.|-||||
2010021368379|18297|18264|-|-|-|-|-|.|-||||
2006081611123|17027|17006|||Passenger Property Loss|Checked Baggage|Candles - Decorative and other; Clothing - Shoes, belts, accessories, etc.; Dishes, Pottery, Glassware, Plasticware|.|||||
2006062108380|16972|16957|||Passenger Property Loss|Checkpoint|Jewelry - Fine|.|||||
2006062008258|16972|16938|||Passenger Property Loss|Checked Baggage|Cosmetics - Perfume, toilet articles, medicines, soaps, etc.; Medicines|.|||||
2006010699056|16831|16793|||Passenger Property Loss|Checked Baggage|Other|.|||||
2006032303625|16880|16861|||Property Damage|Checked Baggage|Luggage (all types including footlockers)|.|||||
2006081511005|17021|.|||Property Damage|Checked Baggage|Locks; Luggage (all types including footlockers)|.|||||
2006082111318|17029|17015|||Property Damage|Checked Baggage|Locks|.|||||
2006070709101|16988|16979|||Passenger Property Loss|Checkpoint|Jewelry - Fine|.|||||
2006041704637|16898|.|||Passenger Property Loss|Checked Baggage|Eyeglasses - (including contact lenses)|.|||||
2006061408002|16966|.|||||Luggage (all types including footlockers)|.|||||
2006032303589|16880|.|||Passenger Property Loss|Checked Baggage|Jewelry - Fine|.|||||
2006090611995|17021|.|||Passenger Property Loss|Checked Baggage|Other|.|||||
2006051506283|16931|.|||Property Damage|Checked Baggage|Luggage (all types including footlockers)|.|||||
2006042405039|16908|.|||Passenger Property Loss|Checked Baggage|Currency|.|||||
2006050305680|16918|.|||Property Damage|Checked Baggage|Watches - Expensive more than $100|.|||||
2006060607460|16954|.|||Passenger Property Loss|Checkpoint|Other|.|||||
2006072109924|17003|16996|||Passenger Property Loss|Checkpoint|DVD/CD Players; Other|.|||||
2006081010689|17016|16866|||Property Damage|Checked Baggage|Luggage (all types including footlockers)|.|||||
2006042505214|16905|16896|||Property Damage|Checkpoint|Cell Phones|.|||||
2006081110819|17022|17014|||Passenger Property Loss|Checked Baggage|Other|.|||||
2006051806567|16937|16924|||Property Damage|Checked Baggage|Electrical and Gas Appliances Minor - $200 or less (humidifiers, tv's, etc)|.|||||
2006040504066|16877|16855|||Passenger Property Loss|Checked Baggage|Other|.|||||
2006073110251|17008|17001|||Passenger Property Loss|Checked Baggage|Clothing - Shoes, belts, accessories, etc.|.|||||
2006042505160|16909|16863|||Passenger Property Loss|Checkpoint|Eyeglasses - (including contact lenses)|.|||||
2006020801205|16834|16828|||Passenger Property Loss|Checked Baggage|Cameras - Digital|0|Deny||||
2006030302477|16859|16829|||Passenger Property Loss|Checkpoint||.|||||
2006030702656|16861|16794|||Property Damage|Checkpoint|Other|.|||||
2006042405125|16909|16889|||Property Damage|Checked Baggage|Luggage (all types including footlockers)|.|||||
2006061407915|16965|16941|||Passenger Property Loss|Checked Baggage|MP3 Players-(iPods, etc)|.|||||
2006062608528|16975|16948|||Property Damage|Checked Baggage|Luggage (all types including footlockers)|.|||||
2006050905781|16919|16899|||Property Damage|Checked Baggage||.|||||
2006020200854|16828|16800|||||DVD/CD Players|.|||||
2006020701013|16832|16789|||Property Damage|Checked Baggage|Other|0|||||
2006021301461|16839|16821|||Property Damage|Checkpoint|Other|.|||||
2006051906611|16937|16935|||Passenger Property Loss|Checked Baggage|Cameras - Digital; Cell Phones|.|||||
2006041904786|16904|16902|||Passenger Property Loss|Checked Baggage|Other|0|||||
2006062108424|16972|16963|||Property Damage|Checked Baggage|Mirrors (including frames)|.|||||
2006060607469|16954|16877|||Property Damage|Checkpoint|Computer - Laptop|.|||||
2006081511091|17024|16951|||Passenger Property Loss|Checkpoint|Eyeglasses - (including contact lenses)|.|||||
2006021001404|16834|16824|||Property Damage|Checked Baggage|Musical Instruments - Other - Over $250|.|||||
0506124L|15831|.|HNL|Honolulu International Airport|Property Damage|Checked Baggage|Luggage (all types including footlockers)|50|Settle|HAWAII|HI|HONOLULU|HONOLULU
1117499M|16026|.|HNL|Honolulu International Airport|Passenger Property Loss|Checkpoint|Cameras - Digital|0|Deny|HAWAII|HI|HONOLULU|HONOLULU
;
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
  a missing value for Incident_Date or Date_Received
  an Incident_Date or Date_Received value out of the predefined year
  range of 2002 through 2017
  an Incident_Date value that occurs after the Date_Received value
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

ods pdf file="./ClaimReports.pdf"
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
