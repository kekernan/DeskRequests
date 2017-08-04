WITH Last3Years AS
(SELECT PIDM
, COUNT(CASH_CREDIT_PERSON) GiftCount
FROM C_GI_CREDIT_DETAIL
WHERE CASH_CREDIT_PERSON > 0
AND Fiscal_YEAR > 2014
GROUP BY PIDM)
, Last5Years AS
(SELECT PIDM
, COUNT(CASH_CREDIT_PERSON) GiftCount
FROM C_GI_CREDIT_DETAIL
WHERE CASH_CREDIT_PERSON > 0
AND FISCAL_YEAR > 2012
GROUP BY PIDM)
, Last10Years AS
(SELECT PIDM
, COUNT(CASH_CREDIT_PERSON) GiftCount
FROM C_GI_CREDIT_DETAIL
WHERE CASH_CREDIT_PERSON > 0
AND FISCAL_YEAR > 2008
GROUP BY PIDM)
SELECT *
FROM C_CN_CONSTITUENT con
, PENTAHO.C_GI_CREDIT_SUMMARY credit
, C_CN_CURRENT_NAMES names
, PENTAHO.C_CN_EXCLUSIONS_BY_ID excl
, PENTAHO.C_CN_INDICATORS ind
, PENTAHO.C_CN_DONOR_STATUS_BY_ID status
, Last3Years
, Last5Years
, Last10Years
WHERE --JOINS
    con.pidm = credit.pidm
AND con.pidm = names.pidm
AND con.pidm = excl.pidm
AND con.pidm = ind.pidm
AND con.pidm = status.pidm
AND con.pidm = Last3Years.PIDM
AND con.pidm = Last5Years.PIDM
AND con.pidm = Last10Years.pidm
AND credit.REPORTING_YEAR = 2017
--Exclusions
AND excl.TRUMP_IND = 'N'
AND con.DEAD_IND = 'N'
AND con.ENTITY_CODE = 'P'
--Inclusions
AND (--FROM STELTER:
--Donors aged 50+ who have made 10 or more total gifts, including a minimum of at least 2 gifts in the past 5-years
  (con.AGE >=50 AND credit.LT_GIFT_NUM_COUNT >= 10 AND Last5Years.GiftCount >= 2)
--Donors aged 40+ who have made 7 gifts or more in the past 10-years
OR (con.age >= 40 AND Last10Years.GiftCount >= 10)
--All donors who have made 15+ gifts, including 1 gift in the past 3-years (no age minimum)
OR (credit.LT_GIFT_NUM_COUNT >= 15 AND Last3Years.GiftCount > 0)
--All donors who have been “on file” for 15+ years, including at least 1 gift in the past 5-years
OR (con.FIRST_CONS_FY > 2002 AND Last5Years.GiftCount > 0)
--All donors who have made at least 1 gift of $1,000 or more, including one gift of any amount in the past 3-years (no age minimum)
OR (status.largest_cash_cred_amount_0 >= 1000 AND Last3Years.GiftCount > 0)
--Include all current planned gift donors
OR (ind.Tower_Society_Ind = 'Y')
--Include all former and current board members, staff, key volunteers, volunteer groups, capital campaign participants, and third-party centers of influence (attorneys, CPAs, clergy, bankers, estate planning council, corporate and business leaders, etc.)
OR (ind.trustee_all_ind = 'Y' OR ind.T1_Prospect_ind = 'Y' OR ind.T1_spouse_ind = 'Y' OR LUAA_Board_ind = 'Y' OR yac_board_ind = 'Y' OR current_volunteer_ind = 'Y')
)
ORDER BY con.name_sort