SELECT *
FROM data_sheet
WHERE data_sheet.code_type = 'PIPRO'
--AND PIDM IN (SELECT PIDM FROM (SELECT PIDM, COUNT(ATHLETE_TEAM) ct FROM data_sheet WHERE data_sheet.code_type = 'PIPRO' GROUP BY PIDM) WHERE ct > 1)
AND pidm IN (70034960, 70030124, 70027513, 491386, 124424)
ORDER BY PIDM, data_sheet.ATHLETE_TEAM