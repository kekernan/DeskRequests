SELECT
  con.banner_id
, con.name_sort
, con.class_year_pref
, con.donor_code_primary
, con.pref_college_code
, con.RESEARCH_RATE_CODE
, con.primary_staff_code
, con.DEAD_IND
, con.GENDER_CODE
, con.ENTITY_CODE
, contact.PREF_ATYP_CODE
, con.NAME_LEGAL
, contact.pref_street1
, contact.pref_street2
, contact.pref_street3
, contact.pref_city
, contact.pref_state_code
, contact.pref_zip9
, contact.pref_nation_desc
, contact.email_pref_address
, contact.TELE_PREF_NUMBER
, names.combined_formal_address_name
, names.informal_salu
, names.formal_salu
, names.combined_informal_salu
, names.combined_formal_salu
, con.SPOUSE_BANNER_ID
, con.SPOUSE_NAME_SORT
, con.SPOUSE_FIRST_NAME
, con.SPOUSE_CLASS_YEAR_PREF
, con.SPOUSE_DONOR_CODE
, names.formal_address_name
, names.combined_formal_address_name
, names.AP_SOCIETY_NAME
, ind.STAFF_IND
, ind.FACULTY_IND
, ind.T1_PROSPECT_IND "Principal_Gift_Prospect"
, status.donor_status_0
, status.LAST_CASH_CRED_DATE_0
, con.pref_college_code "College"
, con.name_last
, con.name_first
, ed.D1_MAJOR_DESC_1
, ed.D1_MAJOR_DESC_2
, ed.D2_MAJOR_DESC_1
, ed.D2_MAJOR_DESC_2
, D1_MINOR_DESC_1 
, D1_MINOR_DESC_2 
, D2_MINOR_DESC_1 
, D2_MINOR_DESC_2 
FROM C_CN_Constituent con
, C_CN_Contact_Pref contact
, PENTAHO.C_CN_EXCLUSIONS_BY_ID excl
, PENTAHO.C_CN_CURRENT_NAMES names
, PENTAHO.C_CN_EDUCATION_LU_BY_ID ed
, PENTAHO.C_CN_INDICATORS ind
, PENTAHO.C_CN_DONOR_STATUS_BY_ID status
WHERE --joins
    con.pidm = contact.pidm(+)
AND con.pidm = excl.pidm
AND con.pidm = names.pidm (+)
AND con.pidm = ed.pidm
AND con.pidm = ind.pidm (+)
AND con.pidm = status.pidm (+)
--exclusions
AND excl.TRUMP_IND = 'N'
AND con.DEAD_IND = 'N'
--inclusion criteria
AND ( (D1_DEPT_DESC_1 = 'Civil and Environmental Engr'
  OR D1_DEPT_DESC_2 = 'Civil and Environmental Engr'
  OR D2_DEPT_DESC_1 = 'Civil and Environmental Engr'
  OR D2_DEPT_DESC_2 = 'Civil and Environmental Engr'
  OR D3_DEPT_DESC_1 = 'Civil and Environmental Engr'
  OR D3_DEPT_DESC_2 = 'Civil and Environmental Engr'
  OR D4_DEPT_DESC_1 = 'Civil and Environmental Engr'
  OR D4_DEPT_DESC_2 = 'Civil and Environmental Engr')
  OR D1_MAJOR_CODE_1 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D1_MAJOR_CODE_2 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D2_MAJOR_CODE_1 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D2_MAJOR_CODE_2 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D1_MINOR_DESC_1 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D1_MINOR_DESC_2 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D2_MINOR_DESC_1 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU')
  OR D2_MINOR_DESC_2 IN ('CE', 'CLEG', 'EENG', 'SENG', 'STRU'))
ORDER BY 2