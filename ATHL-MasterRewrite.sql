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
, NonAthlGivingCYR AS (SELECT PIDM, SUM(Cash_Credit_Person) CYR_NO_ATHL
 FROM PENTAHO.C_GI_CREDIT_DETAIL
 WHERE fiscal_year = 2018
  AND DESIGNATION_CODE IN (SELECT DESIGNATION_CODE FROM PENTAHO.C_GI_DESIGNATIONS
WHERE PENTAHO.C_GI_DESIGNATIONS.ATHLETICS_IND <> 'Y')
GROUP BY pidm
   )
, Occupation AS (select apbcons_pidm pidm, atvdott_desc Occupational_Title
          from atvdott@prod, apbcons@prod
          where atvdott_code = apbcons_dott_code)
SELECT con.banner_id
, con.name_sort
, con.name_legal "FULL_NAME"
, names.formal_salu
, names.informal_salu
, names.formal_address_name
, con.name_maiden "Maiden"
, con.class_year_pref "Class"
, con.donor_code_primary "CFAE"
, emp.empl_position "POSITION"
, emp.empr_name "EMPLOYER"
, occupation.Occupational_Title
, emp.SICC_DESC "Industry"
, con.research_rate_code "PRRT"
, con.qualified_rate_code "QRating"
, con.Gender_code
, con.Name_first
, con.name_last
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_street1
   ELSE NULL
   END) "H_ADDR1"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_street2
   ELSE NULL
   END) "H_ADDR2"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_street3
   ELSE NULL
   END) "H_ADDR3"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_city
   ELSE NULL
   END) "H_ADDRCITY"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_state_code
   ELSE NULL
   END) "H_ADDRSTATE"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_zip9
   ELSE NULL
   END) "H_ADDRZIP"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.home_nation_desc
   ELSE NULL
   END) "H_ADDRNATION"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.TELE_home
   ELSE NULL
   END) "H_PH"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.TELE_business
   ELSE NULL
   END) "B_PH"
, (CASE
   WHEN excl.excl_RPD = 'N' AND excl.excl_INR = 'N' AND excl.excl_NOC = 'N' AND excl.excl_INL = 'N' AND excl.excl_NML = 'N' AND excl.excl_NAD = 'N' AND excl.excl_DNS = 'N' AND excl.excl_NAU = 'N'
   THEN contact.email_pref_address
   ELSE NULL
   END) "P_EMAIL"
, contact.Home_Georegion_code "GEO"
, 2013 "B4FY"
, NVL(ATH_Giving_B5FY.B5_ATHL_PD_MEMO_MG, 0) "B5_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_B5FY.B5_ATHL_AF_PD_MEMO_MG, 0) "B5_ATHL_AF_PD_MEMO_MG"
, 2014 "B4FY"
, NVL(ATH_Giving_B4FY.B4_ATHL_PD_MEMO_MG, 0) "B4_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_B4FY.B4_ATHL_AF_PD_MEMO_MG, 0) "B4_ATHL_AF_PD_MEMO_MG"
, 2015 "B4FY"
, NVL(ATH_Giving_B3FY.B3_ATHL_PD_MEMO_MG, 0) "B3_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_B3FY.B3_ATHL_AF_PD_MEMO_MG, 0) "B3_ATHL_AF_PD_MEMO_MG"
, 2016 "B4FY"
, NVL(ATH_Giving_B2FY.B2_ATHL_PD_MEMO_MG, 0) "B2_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_B2FY.B2_ATHL_AF_PD_MEMO_MG, 0) "B2_ATHL_AF_PD_MEMO_MG"
, 2017 "B4FY"
, NVL(ATH_Giving_B1FY.B1_ATHL_PD_MEMO_MG, 0) "B1_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_B1FY.B1_ATHL_AF_PD_MEMO_MG, 0) "B1_ATHL_AF_PD_MEMO_MG"
, 2018 "CYR"
, NVL(ATH_Giving_CYR.CFY_ATHL_PD_MEMO_MG, 0) "CFY_ATHL_PD_MEMO_MG"
, NVL(ATH_AF_Giving_CYR.CFY_ATHL_AF_PD_MEMO_MG, 0) "CFY_ATHL_AF_PD_MEMO_MG"
, NVL(NonAthlGivingLast5Years.Avg_Giving_Non_Athl_Past_5_Yrs, 0) "Avg_Giving_Non_Athl_Past_5_Yrs"
, names.AP_Society_Name "SOCIETY_NAME"
, names.Annual_Report_Name "ANNUAL_RPT_NAME"
, con.primary_staff_desc "PRIM_STAFF"
, CYR_NO_ATHL
, (donor.PD_5YR + donor.PD_MEMO_5YR ) "ALL_PAST_5YRS"
, (donor.annual_pd_pyr + donor.annual_pd_memo_pyr +
   donor.annual_pd_3yr + donor.annual_pd_memo_3yr +
   donor.annual_pd_4yr + donor.annual_pd_memo_4yr +
   donor.annual_pd_5yr + donor.annual_pd_memo_5yr +
   donor.annual_pd_6yr + donor.annual_pd_memo_6yr) "ALL_PAST_5YRS_AF"
, (donor.LT_PD + donor.LT_PD_MEMO) "ALL_LT_GIVING"
, AW_HISTORY.LAST_ATHL_GIFT_AMT "Last_Athl_Gift_Amt"
, AW_HISTORY.LAST_ATHL_GIFT_DATE "Last_Athl_Gift_Date"
, AW_HISTORY.LAST_ATHL_GIFT_DESIGNATION "Last_Athl_Gift_Designation"
, AW_HISTORY.LAST_ATHL_GIFT_NUMBER "Last_Athl_Gift_Number"
, AW_HISTORY.LAST_ATHL_FY_GIVEN "Last_Athl_FY_Given"
, DONOR.CONS_YEARS_ATHL "ATHL_CONS_YRS"
, emp.SICC_DESC "Industry"
, occupation.Occupational_Title "Occupational_Title"
, (donor.lt_athl_pd + donor.lt_athl_pd_memo) "LT_ATHL_GIVING"
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
, ratings.p_rating_code "Priority"
FROM C_CN_Constituent con
, C_CN_Current_Names names
, C_CN_Contact_Pref contact
, C_CN_Exclusions_by_id excl
, C_CN_Activities_student act
, C_CN_Activities_alumni aact
, C_CN_Employment_primary emp
, C_RM_RATINGS_ACTIVE_BY_ID ratings
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
, NonAthlGivingCYR
, Donor@prod
, aw_history@prod
, occupation
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
AND con.pidm = NonAthlGivingCyr.pidm (+)
AND con.pidm = donor.pidm
AND con.pidm = aw_history.pidm
AND con.pidm = ratings.pidm (+)
AND con.pidm = occupation.pidm (+)
--exclusions
AND con.dead_ind = 'N'
AND excl.excl_INR = 'N'
AND excl.excl_RPD = 'N'
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