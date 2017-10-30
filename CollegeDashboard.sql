WITH Willingness AS
  (select distinct pidm, rating.rating_desc willingness
  from c_rm_ratings rating
  where rating.rate_type_code = 'W')
, LT_Giving AS
  (SELECT PIDM, sum(c_gi_credit_detail.cash_credit_person) Lehigh_Lifetime_Giving
  FROM c_gi_credit_detail
  Group by pidm) 
, CollegeLTGiving AS
  (SELECT PIDM, sum(c_gi_credit_detail.cash_credit_person) College_Lifetime_Giving
    FROM c_gi_credit_detail
       , c_gi_designations
    WHERE c_gi_credit_detail.designation_code = c_gi_designations.designation_code
      AND c_gi_designations.coll_code IN('ED','BU','AS','EN')
    GROUP BY PIDM)
, CYRGiving AS
  (SELECT PIDM, sum(c_gi_credit_detail.cash_credit_person) CYR_Giving
  FROM c_gi_credit_detail
  WHERE c_gi_credit_detail.fiscal_year = 2018
  GROUP BY PIDM)
, PYRGiving AS
  (SELECT PIDM,  sum(c_gi_credit_detail.cash_credit_person) PYR_Giving
  FROM c_gi_credit_detail
  WHERE c_gi_credit_detail.fiscal_year = 2017
  GROUP BY PIDM)
, TwoAgo AS
   (SELECT PIDM, sum(c_gi_credit_detail.cash_credit_person) Two_Ago_Giving
    FROM c_gi_credit_detail
    WHERE c_gi_credit_detail.fiscal_year = 2016
    GROUP BY PIDM)
, ThreeAgo AS
  (SELECT pidm,  sum(c_gi_credit_detail.cash_credit_person) Three_Ago_Giving
   FROM c_gi_credit_detail
   WHERE c_gi_credit_detail.fiscal_year = 2015
   GROUP BY pidm)
, FourAgo AS
   (SELECT pidm,  sum(c_gi_credit_detail.cash_credit_person) Four_Ago_Giving
   FROM c_gi_credit_detail
   WHERE c_gi_credit_detail.fiscal_year = 2014
   GROUP BY pidm)
, FiveAgo AS
  (SELECT pidm,  sum(c_gi_credit_detail.cash_credit_person) Five_Ago_Giving
   FROM c_gi_credit_detail
   WHERE c_gi_credit_detail.fiscal_year = 2013
   GROUP BY PIDM)
, Marts_Lundy AS
  (SELECT AMREXRT_pidm pidm, 'YES' Marts_Lundy
   FROM amrexrt@prod
   WHERE amrexrt_exrs_code = 'MLC16')
, Avg5Giving AS
  (SELECT PIDM, (sum(cash_credit_person))/5 Average_5YR_Giving
   FROM PENTAHO.C_GI_CREDIT_DETAIL
   WHERE fiscal_year IN (2013, 2014, 2015, 2016, 2017)
   GROUP BY PIDM)
, NumContacts AS
  (SELECT AMRCONT_PIDM, COUNT(AMRCONT_ITEM_REFNO) Number_Of_Contacts
   FROM AMRCONT@PROD
   GROUP BY AMRCONT_PIDM)
, Last_Contact AS
  (SELECT a.AMRCONT_PIDM, a.AMRCONT_contact_DATE, a.AMRCONT_IDEN_CODE,  a.AMRCONT_SCNT_CODE, a.AMRCONT_MOVE_CODE
   FROM AMRCONT@PROD a
   WHERE AMRCONT_ITEM_REFNO = (SELECT MAX(b.AMRCONT_ITEM_REFNO)
                                 FROM AMRCONT@prod b
                                WHERE b.amrcont_pidm = a.amrcont_pidm)
  )
, LastVisitDate AS
  (select AMRCONT_PIDM, max(AMRCONT_CONTACT_DATE) Last_Requested_Visit_Date
  from amrcont@prod, aw_history@prod
  where amrcont_pidm = aw_history.pidm
  and   amrcont_item_refno = AW_HISTORY.LAST_CONTACT_ITEM_REFNO
  and   AMRCONT_SCNT_CODE = 'REV'
  GROUP BY amrcont_pidm)
SELECT 
con.banner_id ID,
  con.name_sort sort_name,
  con.name_legal legal_name,
  con.name_first frist_name,
  con.name_last last_name,
  con.name_suffix suffix_name,
  con.primary_staff_desc primary_staff,
  edu.d1_degree_desc LU_Degree1,
  edu.d1_college_desc LU_College1,
  edu.d1_major_desc_1 LU_Major1,
  edu.d2_degree_desc LU_Degree2,
  edu.d2_college_desc LU_College2,
  edu.d2_major_desc_2 LU_Major2,
  con.donor_code_primary cfae_primary, 
  con.class_year_pref preferred_class,
  donorstatus.donor_status_0 donorstatus,
  con.gender_code gender,
  con.date_birth dob,
  con.pref_college_desc college, 
  con.qualified_rate_code q_rating_code,
  con.qualified_rate_desc q_rating_desc,
  ind.t1_prospect_ind, 
  con.research_rate_type d_s_code,
  con.research_rate_code research_rating_code,
  con.research_rate_desc research_rating_desc,
  willingness.Willingness,
  LT_Giving.Lehigh_Lifetime_Giving,
  donorstatus.last_cash_cred_amount_0 lastgift,
  donorstatus.last_cash_cred_date_0 lastgiftdate,
  donorstatus.last_cash_cred_desg_code_0 lastgiftdesg,
  nvl(Marts_Lundy.Marts_Lundy,'NO') Marts_Lundy,
  contact.home_street1 h_street1,
  contact.home_street2 h_street2,
  contact.home_street3 h_steet3,
  contact.home_city h_city,
  contact.home_state_code h_state,
  contact.home_nation_desc h_nation,
  contact.TELE_HOME,
  contact.email_home,  
  contact.business_street1 b_street1,
  contact.business_street2 b_street2,
  contact.business_street3 b_steet3,
  contact.business_city b_city,
  contact.business_state_code b_state,
  contact.business_nation_desc b_nation,
  contact.TELE_BUSINESS,
  contact.EMAIL_BUSINESS,
  employ.empr_name,
  employ.empl_position,
  con.spouse_last_name spouselastname,
  con.spouse_first_name spousefirstname,
  con.spouse_donor_code spousecfae,
  con.spouse_class_year_pref spouseclass,
  contact.email_pref_address preferred_email,
  CollegeLTGiving.College_Lifetime_Giving,
  CYRGiving.CYR_Giving,
  PYRGiving.PYR_Giving,
  TwoAgo.Two_Ago_Giving,
  ThreeAgo.Three_Ago_Giving,
  FourAgo.Four_Ago_Giving,
  FiveAgo.Five_Ago_Giving,
  Avg5Giving.Average_5YR_Giving,
  NumContacts.Number_Of_Contacts,
  Last_Contact.amrcont_contact_date Last_Contact_Date,
  Last_Contact.AMRCONT_IDEN_CODE Last_Contact_Orig,
  Last_Contact.AMRCONT_SCNT_CODE Last_Contact_Type,
  Last_Contact.AMRCONT_MOVE_CODE Last_Contact_Move,
  LastVisitDate.Last_Requested_Visit_Date,
  con.donor_code_string cfae_string,
  contact.pref_georegion_code p_geocode,
  contact.pref_georegion_desc p_geodesc,
  contact.pref_street1 p_street1,
  contact.pref_street2 p_street2,
  contact.pref_street3 p_street3,
  contact.pref_city p_city,
  contact.pref_state_code p_state,
  contact.pref_nation_desc p_nation,
  ind.luaa_board_ind luaa_board,
  ind.trustee_current_ind current_trustee,
  ind.trustee_all_ind trustee_ever,
  ind.current_year_parent_ind current_parent,
  ind.leadership_plaza_ind leadership_plaza,
  ind.tower_society_ind tower_soceity
FROM 
 c_cn_constituent con
, c_cn_contact_pref contact
, c_cn_indicators ind
, c_cn_donor_status_by_id donorstatus
, c_cn_employment_primary employ
, c_cn_education_lu_by_id edu
, c_cn_exclusions_by_id excl
, willingness
, LT_Giving
, CollegeLTGiving
, CYRGiving
, PYRGiving
, TwoAgo
, ThreeAgo
, FourAgo
, FiveAgo
, Marts_Lundy
, Avg5Giving
, NumContacts
, Last_Contact
, LastVisitDate
WHERE --joins
    con.pidm = donorstatus.pidm
AND con.pidm = employ.pidm
AND con.pidm = edu.pidm
AND con.pidm = ind.pidm
AND con.pidm = contact.pidm
AND con.pidm = excl.pidm
AND con.pidm = willingness.pidm (+)
AND con.pidm = LT_Giving.pidm (+)
AND con.pidm = CollegeLTGiving.PIDM (+)
AND con.pidm = CYRGiving.pidm (+)
AND con.pidm = PYRGiving.pidm (+)
AND con.pidm = TwoAgo.pidm (+)
AND con.pidm = ThreeAgo.pidm (+)
AND con.pidm = FourAgo.pidm (+)
AND con.pidm = FiveAgo.pidm (+)
AND con.pidm = Marts_Lundy.pidm (+)
AND con.pidm = Avg5Giving.pidm (+)
AND con.pidm = NumContacts.amrcont_pidm (+)
AND con.pidm = Last_Contact.amrcont_pidm (+)
AND con.pidm = LastVisitDate.amrcont_pidm (+)
--exclusions
AND con.name_sort NOT LIKE '%Anon%'
AND con.dead_ind = 'N'
--inclustions
AND con.pref_college_code IN('ED','BU','AS','EN')
ORDER BY sort_name