WITH Sports AS 
(SELECT sgrsprt_pidm pidm
, LISTAGG(sgrsprt_actc_code, ', ') WITHIN GROUP (ORDER BY sgrsprt_actc_code) sport_code 
FROM SGRSPRT@prod
WHERE sgrsprt_spst_code in ('AC','AI','EE')
  and sgrsprt_actc_code in (
            'CRM'
           ,'CRW'
           ,'MBA'
           ,'MBB'
           ,'WBB'
           ,'WCR'
           ,'MCC'
           ,'MCR'
           ,'WCC'
           ,'WFH'
           ,'MFB'
           ,'MGO'
           ,'WGO'
           ,'MLA'
           ,'WLA'
           ,'MSO'
           ,'WSO'
           ,'WSB'
           ,'MSW'
           ,'WSW'
           ,'MTE'
           ,'WTE'
           ,'WTI'
           ,'WTO'
           ,'MTI'
           ,'MTO'
           ,'WVB'
           ,'MWR'
           )
  GROUP BY sgrsprt_pidm)
, ATH_Giving_B5FY AS (Select PIDM, SUM(cash_credit_person) B5_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2013
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_Giving_B4FY AS (Select PIDM, SUM(cash_credit_person) B4_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2014
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_Giving_B3FY AS (Select PIDM, SUM(cash_credit_person) B3_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2015
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_Giving_B2FY AS (Select PIDM, SUM(cash_credit_person) B2_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2012
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_Giving_B1FY AS (Select PIDM, SUM(cash_credit_person) B1_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2017
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_Giving_CYR AS (Select PIDM, SUM(cash_credit_person) CFY_ATHL_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2018
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_B5FY AS (Select PIDM, SUM(cash_credit_person) B5_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2013
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_B4FY AS (Select PIDM, SUM(cash_credit_person) B4_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2014
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_B3FY AS (Select PIDM, SUM(cash_credit_person) B3_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2015
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_B2FY AS (Select PIDM, SUM(cash_credit_person) B2_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2012
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_B1FY AS (Select PIDM, SUM(cash_credit_person) B1_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2017
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, ATH_AF_Giving_CYR AS (Select PIDM, SUM(cash_credit_person) CFY_ATHL_AF_PD_MEMO_MG 
FROM PENTAHO.C_GI_CREDIT_DETAIL
WHERE FISCAL_YEAR = 2018
 AND campaign_code like ('AF%')
 AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND = 'Y')
GROUP BY pidm)
, NonAthlGivingLast5Years AS (SELECT PIDM, SUM(Cash_Credit_Person)/5 Avg_Giving_Non_Athl_Past_5_Yrs
 FROM PENTAHO.C_GI_CREDIT_DETAIL
 WHERE fiscal_year between 2013 and 2017
  AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND <> 'Y')
GROUP BY pidm
   )
SELECT con.banner_id
, con.name_sort
, con.name_legal
, con.class_year_pref
, con.donor_code_primary
, names.formal_salu
, names.informal_salu
, names.formal_address_name
, con.name_maiden
, emp.empl_position
, emp.empr_name
, con.research_rate_code "PRRT"
, con.qualified_rate_code "QRating"
, con.Gender_code
, con.Name_first
, con.name_last
, con.pref_college_code
, con.primary_staff_code
, contact.home_street1
, contact.home_street2
, contact.home_street3
, contact.home_city
, contact.home_state_code
, contact.home_zip9
, contact.home_nation_desc
, contact.TELE_home
, contact.TELE_business
, contact.email_pref_address
, contact.Home_Georegion_code
, 2013
, NVL(ATH_Giving_B5FY.B5_ATHL_PD_MEMO_MG, 0)
, NVL(ATH_AF_Giving_B5FY.B5_ATHL_AF_PD_MEMO_MG, 0)
, 2014
, NVL(ATH_Giving_B4FY.B4_ATHL_PD_MEMO_MG, 0)
, NVL(ATH_AF_Giving_B4FY.B4_ATHL_AF_PD_MEMO_MG, 0)
, 2015
, NVL(ATH_Giving_B3FY.B3_ATHL_PD_MEMO_MG, 0)
, NVL(ATH_AF_Giving_B3FY.B3_ATHL_AF_PD_MEMO_MG, 0)
, 2016
, NVL(ATH_Giving_B2FY.B2_ATHL_PD_MEMO_MG, 0)
, NVL(ATH_AF_Giving_B2FY.B2_ATHL_AF_PD_MEMO_MG, 0)
, 2017
, NVL(ATH_Giving_B1FY.B1_ATHL_PD_MEMO_MG, 0)
, NVL(ATH_AF_Giving_B1FY.B1_ATHL_AF_PD_MEMO_MG, 0)
, 2018
, NVL(ATH_Giving_CYR.CFY_ATHL_PD_MEMO_MG, 0) "CFY_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_CYR.CFY_ATHL_AF_PD_MEMO_MG, 0) "CFY_ATHL_AF_PD_MEMO_MG"
, NVL(NonAthlGivingLast5Years.Avg_Giving_Non_Athl_Past_5_Yrs, 0)
, (CASE
   WHEN Sports.sport_code IS NOT NULL
   THEN 'Yes'
   ELSE null
   END) "SGRSPRT"
, (CASE
   WHEN aact.ACTC_AAN = 'Y'
   THEN 'AAN'
   ELSE NULL
   END) "AAN"
, (CASE
   WHEN act.ACTC_CRM = 'Y'
   THEN 'CRM'
   ELSE NULL
   END) "CRM"
, (CASE
   WHEN act.ACTC_CRW = 'Y'
   THEN 'CRW'
   ELSE NULL
   END) "CRW"
, (CASE
   WHEN act.ACTC_MBA = 'Y'
   THEN 'MBA'
   ELSE NULL
   END) "MBA"
, (CASE
   WHEN act.ACTC_MBB = 'Y'
   THEN 'MBB'
   ELSE NULL
   END) "MBB"
, (CASE
   WHEN act.ACTC_MCC = 'Y'
   THEN 'MCC'
   ELSE NULL
   END) "MCC"
, (CASE
   WHEN act.ACTC_MCR = 'Y'
   THEN 'MCR'
   ELSE NULL
   END) "MCR"
, (CASE
   WHEN act.ACTC_MFB = 'Y'
   THEN 'MFB'
   ELSE NULL
   END) "MFB"
, (CASE
   WHEN act.ACTC_MGO = 'Y'
   THEN 'MGO'
   ELSE NULL
   END) "MGO"
, (CASE
   WHEN act.ACTC_MLA = 'Y'
   THEN 'MLA'
   ELSE NULL
   END) "MLA"
, (CASE
   WHEN act.ACTC_MSO = 'Y'
   THEN 'MSO'
   ELSE NULL
   END) "MSO"
, (CASE
   WHEN act.ACTC_MSW = 'Y'
   THEN 'MSW'
   ELSE NULL
   END) "MSW"
, (CASE
   WHEN act.ACTC_MTE = 'Y'
   THEN 'MTE'
   ELSE NULL
   END) "MTE"
, (CASE
   WHEN act.ACTC_MTI = 'Y'
   THEN 'MTI'
   ELSE NULL
   END) "MTI"
, (CASE
   WHEN act.ACTC_MTO = 'Y'
   THEN 'MTO'
   ELSE NULL
   END) "MTO"
, (CASE
   WHEN act.ACTC_MWR = 'Y'
   THEN 'MWR'
   ELSE NULL
   END)  "MWR"
, (CASE
   WHEN act.ACTC_WBB = 'Y'
   THEN 'WBB'
   ELSE NULL
   END) "WBB"
, (CASE
   WHEN act.ACTC_WCR = 'Y'
   THEN 'WCR'
   ELSE NULL
   END) "WCR"
, (CASE
   WHEN act.ACTC_WCC = 'Y'
   THEN 'WCC'
   ELSE NULL
   END) "WCC"
, (CASE
   WHEN act.ACTC_WFH = 'Y'
   THEN 'WFH'
   ELSE NULL
   END) "WFH"
, (CASE
   WHEN act.ACTC_WGO = 'Y'
   THEN 'WGO'
   ELSE NULL
   END) "WGO"
, (CASE
   WHEN act.ACTC_WLA = 'Y'
   THEN 'WLA'
   ELSE NULL
   END) "WLA"
, (CASE
   WHEN act.ACTC_WSO = 'Y'
   THEN 'WSO'
   ELSE NULL
   END) "WSO"
, (CASE
   WHEN act.ACTC_WSB = 'Y'
   THEN 'WSB'
   ELSE NULL
   END) "WSB"
, (CASE
   WHEN act.ACTC_WSW = 'Y'
   THEN 'WSW'
   ELSE NULL
   END) "WSW"
, (CASE
   WHEN act.ACTC_WTE = 'Y'
   THEN 'WTE'
   ELSE NULL
   END) "WTE"
, (CASE
   WHEN act.ACTC_WTI = 'Y'
   THEN 'WTI'
   ELSE NULL
   END) "WTI"
, (CASE
   WHEN act.ACTC_WTO = 'Y'
   THEN 'WTO'
   ELSE NULL
   END) "WTO"
, (CASE
   WHEN act.ACTC_WVB = 'Y'
   THEN 'WVB'
   ELSE NULL
   END) "WVB"
, names.AP_Society_Name "SOCIETY_NAME"
, names.Annual_Report_Name "ANNUAL_RPT_NAME"
, con.primary_staff_desc
FROM C_CN_Constituent con
, C_CN_Current_Names names
, C_CN_Contact_Pref contact
, C_CN_Exclusions_by_id excl
, C_CN_Activities_student act
, C_CN_Activities_alumni aact
, C_CN_Employment_primary emp
, sports
, ATH_Giving_B5FY
, ATH_AF_Giving_B5FY
, ATH_Giving_B4FY
, ATH_AF_Giving_B4FY
, ATH_Giving_B3FY
, ATH_AF_Giving_B3FY
, ATH_Giving_B2FY
, ATH_AF_Giving_B2FY
, ATH_Giving_B1FY
, ATH_AF_Giving_B1FY
, ATH_Giving_CYR 
, ATH_AF_Giving_CYR 
, NonAthlGivingLast5Years
WHERE --joins
    con.pidm = names.pidm
AND con.pidm = contact.pidm
AND con.pidm = excl.pidm
AND con.pidm = act.pidm
AND con.pidm = aact.pidm (+)
AND con.pidm = emp.pidm (+)
AND con.pidm = sports.pidm (+)
AND con.pidm = ATH_Giving_B5FY.pidm (+)
AND con.pidm = ATH_AF_Giving_B5FY.pidm (+)
AND con.pidm = ATH_Giving_B4FY.pidm (+)
AND con.pidm = ATH_AF_Giving_B4FY.pidm (+)
AND con.pidm = ATH_Giving_B3FY.pidm (+)
AND con.pidm = ATH_AF_Giving_B3FY.pidm (+)
AND con.pidm = ATH_Giving_B2FY.pidm (+)
AND con.pidm = ATH_AF_Giving_B2FY.pidm (+)
AND con.pidm = ATH_Giving_B1FY.pidm (+)
AND con.pidm = ATH_AF_Giving_B1FY.pidm (+)
AND con.pidm = ATH_Giving_CYR.pidm (+)
AND con.pidm = ATH_AF_Giving_CYR.pidm (+)
AND con.pidm = NonAthlGivingLast5Years.pidm (+)
--exclusions
AND con.dead_ind = 'N'
AND excl.trump_ind = 'N'
--inclusion criteria
AND con.donor_code_primary LIKE 'ALM%'
AND (sports.pidm IS NOT NULL
   OR act.actc_CRM = 'Y'
   OR act.actc_CRW = 'Y'
   OR act.actc_MBA = 'Y'
   OR act.actc_MBB = 'Y'
   OR act.actc_WBB = 'Y'
   OR act.actc_WCR = 'Y'
   OR act.actc_MCC = 'Y'
   OR act.actc_MCR = 'Y'
   OR act.actc_WCC = 'Y'
   OR act.actc_WFH = 'Y'
   OR act.actc_MFB = 'Y'
   OR act.actc_MGO = 'Y'
   OR act.actc_WGO = 'Y'
   OR act.actc_MLA = 'Y'
   OR act.actc_WLA = 'Y'
   OR act.actc_MSO = 'Y'
   OR act.actc_WSO = 'Y'
   OR act.actc_WSB = 'Y'
   OR act.actc_MSW = 'Y'
   OR act.actc_WSW = 'Y'
   OR act.actc_MTE = 'Y'
   OR act.actc_WTE = 'Y'
   OR act.actc_WTI = 'Y'
   OR act.actc_WTO = 'Y'
   OR act.actc_MTI = 'Y'
   OR act.actc_MTO = 'Y'
   OR act.actc_WVB = 'Y'
   OR act.actc_MWR = 'Y')
ORDER BY 2