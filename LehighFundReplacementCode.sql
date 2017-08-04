to_char(((select sum(amt_paid)
   from aw_ppg, ADRATTR
   where fiscal_year = :FY4DIGIT.ATVFISC_CODE
   --and campaign like 'AF%'
   AND desg = ADRATTR_DESG
   AND ADRATTR_DATR_CODE = 'LF'
   )),'$999,999,990')