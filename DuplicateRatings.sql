SELECT AMRPRRT_PIDM, COUNT(AMRPRRT_PIDM)
FROM amrprrt
where amrprrt_rtgt_code in ('D', 'S')
AND AMRPRRT_RATE_EFF_TO_DATE iS null
GROUP BY AMRPRRT_PIDM
ORDER BY 2 DESC