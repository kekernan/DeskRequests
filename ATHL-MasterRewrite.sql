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
, ATH_Giving_B5FY.B5_ATHL_PD_MEMO_MG
, ATH_AF_Giving_B5FY.B5_ATHL_AF_PD_MEMO_MG
, 2014
, ATH_Giving_B4FY.B4_ATHL_PD_MEMO_MG
, ATH_AF_Giving_B4FY.B4_ATHL_AF_PD_MEMO_MG
, 2015
, ATH_Giving_B3FY.B3_ATHL_PD_MEMO_MG
, ATH_AF_Giving_B3FY.B3_ATHL_AF_PD_MEMO_MG
, 2016
, ATH_Giving_B2FY.B2_ATHL_PD_MEMO_MG
, ATH_AF_Giving_B2FY.B2_ATHL_AF_PD_MEMO_MG
, 2017
, ATH_Giving_B1FY.B1_ATHL_PD_MEMO_MG
, ATH_AF_Giving_B1FY.B1_ATHL_AF_PD_MEMO_MG
, 2018
, ATH_Giving_CYR.CFY_ATHL_PD_MEMO_MG
, ATH_AF_Giving_CYR.CFY_ATHL_AF_PD_MEMO_MG
FROM C_CN_Constituent con
, C_CN_Current_Names names
, C_CN_Contact_Pref contact
, C_CN_Exclusions_by_id excl
, C_CN_Activities_student act
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
WHERE --joins
    con.pidm = names.pidm
AND con.pidm = contact.pidm
AND con.pidm = excl.pidm
AND con.pidm = act.pidm
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
