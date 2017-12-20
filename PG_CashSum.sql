SELECT sum(detail.cash_credit_person) "Sum_Cash"
FROM PENTAHO.C_GI_CREDIT_DETAIL detail
, C_CN_Constituent con
WHERE con.pidm = detail.pidm
AND FISCAL_YEAR = :FY4DIGIT.calc1
AND con.donor_code_primary LIKE 'EST%'
AND detail.cash_credit_person > 0
AND DESIGNATION_CODE IN 
(SELECT DESIGNATION_CODE
FROM PENTAHO.C_GI_DESIGNATIONS
WHERE Fund_code not like '06%')
ORDER BY con.name_sort