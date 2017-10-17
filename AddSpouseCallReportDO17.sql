DECLARE
  CURSOR spouse_cur
  IS SELECT spouse_PIDM
      FROM AW_Spouse_INFO
     WHERE donor_PIDM IN (SELECT PIDM FROM DONOR WHERE IN :ME_IDs)
       AND spouse_pidm IS NOT NULL;
  
  spouse_pidm     spouse_cur%ROWTYPE;
  spouse_id       VARCHAR2(9);
  retval          Number;
BEGIN
  --Insert Call Report 
  BEGIN
    --using existing logic
    retval := 1;
  EXCEPTION
    WHEN OTHERS
      retval := 0;
  END;
  
  --insert spouse call report if main report is successful and box is checked.
  IF :spouse_call_report = 1 AND retval > 0 THEN
    OPEN spouse_cur;
    
    LOOP      
      FETCH spouse_cur INTO spouse_pidm;
      EXIT WHEN spouse_cur%NOTFOUND;
      
      BEGIN
        SELECT id INTO spouse_id
          FROM DONOR
         WHERE spouse_pidm = pidm;
      EXCEPTION
        WHEN OTHERS
          spouse_id := '0';
      END;
      
      IF spouse_ID NOT IN :ME_IDS and spouse_ID > '0' THEN
        --do call report insert
      END IF;
    END LOOP;   
    
    CLOSE spouse_cur;
  END IF;
END;