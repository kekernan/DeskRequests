WITH OCM AS
(SELECT aprvipc_pidm AS PIDM
 from aprvipc@prod
 where aprvipc_vipc_code = 'OCM')
, IAN AS
(SELECT goradid_pidm AS PIDM , goradid_additional_id AS Add_ID
   FROM goradid@prod
  WHERE goradid_adid_code = 'IAN'
    and not exists(select 'x' from aprvipc@prod
                   where aprvipc_pidm = goradid_pidm
                     and aprvipc_vipc_code = 'OCM')
)
, Score AS
(SELECT PIDM, SCORE_DML05
 FROM DONOR@prod)
, Donor AS
(SELECT PIDM, SUM(CASH_CREDIT_PERSON) LT_Giving
 FROM C_GI_CREDIT_DETAIL
 GROUP BY PIDM)
SELECT  cons.PIDM
, cons.banner_id
, cons.name_sort
, cons.CLASS_YEAR_PREF "Class"
, cons.donor_code_primary "Category"
, cons.RESEARCH_RATE_CODE "Rating"
, cons.PRIMARY_STAFF_DESC "PR_Staff"
, score.SCORE_DML05 "LF_DM"
, cons.dead_ind "Deceased"
, excl.TRUMP_IND
, cons.GENDER_CODE "Gender"
, cons.ENTITY_CODE "E"
, contact.pref_atyp_code "Pref_Addr"
, cons.NAME_LEGAL "Full_Name"
, contact.pref_street1 "Address_Line_1"
, contact.pref_street2 "Address_Line_2"
, contact.pref_street3 "Address_Line_3"
, contact.pref_city "City"
, contact.pref_state_code "State"
, contact.pref_zip9 "Zip"
, contact.PREF_NATION_DESC "Nation"
, contact.TELE_PREF_NUMBER "Phone"
, contact.EMAIL_PREF_ADDRESS "Preferred_Email_Address"
, names.COMBINED_FORMAL_SALU
, names.INFORMAL_SALU
, names.FORMAL_SALU
, names.COMBINED_INFORMAL_SALU
, names.COMBINED_FORMAL_SALU
, names.GIFT_SOCIETY_NAME
, cons.SPOUSE_BANNER_ID
, cons.SPOUSE_NAME_SORT
, names.MAIDEN_NAME
, cons.SPOUSE_CLASS_YEAR_PREF
, cons.SPOUSE_DONOR_CODE
, names.FORMAL_ADDRESS_NAME
, names.COMBINED_INFORMAL_ADDRESS_NAME
, names.COMBINED_FORMAL_ADDRESS_NAME
, cons.NAME_FIRST
, cons.NAME_LAST
, names.JBPC_SALUTATION
, names.JBPF_SALUTATION
, NVL2(ocm.pidm, 'Y', 'N')"OCM"
, NVL2(ian.add_id, cons.name_first, NULL) "FirstName"
, ian.Add_ID "IAN"
, NVL2(spouse_ocm.pidm, 'Y', 'N') "OCM2"
, NVL2(spouse_ian.add_id, cons.spouse_first_name, NULL) "FirstName2"
, spouse_ian.add_id "IAN2"
, donor.LT_Giving
, cons.qualified_rate_code "Q_RTG"
, contact.email_lehigh "Lehigh_Email"
, ind.CURRENT_YEAR_UG_PARENT_IND "Current_Parent_Ind"
, ind.STAFF_IND
, ind.FACULTY_IND
, ind.T1_PROSPECT_IND "Principal_Gift_Prospect"
, cons.SPOUSE_FIRST_NAME
FROM PENTAHO.C_CN_CONSTITUENT cons
, C_CN_CONTACT_PREF contact
, PENTAHO.C_CN_CURRENT_NAMES names
, donor
, PENTAHO.C_CN_INDICATORS ind
, PENTAHO.C_CN_EXCLUSIONS_BY_ID excl
, OCM
, IAN
, OCM SPOUSE_OCM
, IAN SPOUSE_IAN
, Score
, CAS_GIVING
, PENTAHO.C_GI_DESIGNATIONS desg
WHERE
--joins
    cons.pidm = contact.pidm(+)
AND cons.pidm = names.pidm (+)
AND cons.pidm = donor.pidm (+)
AND cons.pidm = ind.pidm (+)
AND cons.pidm = excl.pidm (+)
AND cons.pidm = ocm.pidm(+)
AND cons.pidm = ian.pidm(+)
AND cons.spouse_pidm = spouse_ocm.pidm(+)
AND cons.spouse_pidm = spouse_ian.pidm(+)
AND cons.pidm = score.pidm (+)
AND cons.pidm = cas_giving.pidm
AND cas_giving.Designation_code = desg.designation_code
--exclusions 
AND excl.TRUMP_IND = 'N'
AND cons.DEAD_IND = 'N'
AND UPPER(cons.name_sort) NOT LIKE '%ANONY%'
ORDER BY cons.name_sort