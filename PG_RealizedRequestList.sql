SELECT con.PIDM
, con.name_sort
, detail.cash_credit_person
, (CASE
   WHEN detail.PLEDGE_NUM = '0000000' AND detail.MEMO_THIRD_PARTY_PMT = 0
   THEN 'Y'
   ELSE 'N'
  END) "New_Commitment"
, detail.CAMPAIGN_CODE
, detail.designation_desc
, detail.TRANSACTION_DATE
, con.banner_id
, con.primary_staff_code
, con.primary_staff_desc
FROM PENTAHO.C_GI_CREDIT_DETAIL detail
, C_CN_Constituent con
WHERE con.pidm = detail.pidm
AND FISCAL_YEAR = :FY4DIGIT.calc1
AND con.donor_code_primary LIKE 'EST%'
AND detail.cash_credit_person > 0
and :parm_BT_view_prior_year_EOY_totals is not null
AND DESIGNATION_CODE IN 
(SELECT DESIGNATION_CODE
FROM PENTAHO.C_GI_DESIGNATIONS
WHERE Fund_code not like '06%')
ORDER BY con.name_sort