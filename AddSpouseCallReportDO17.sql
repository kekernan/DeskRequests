DECLARE
  CURSOR spouse_cur
  IS SELECT spouse_PIDM
      FROM AW_Spouse_INFO
     WHERE donor_PIDM IN (SELECT PIDM FROM DONOR WHERE ID = :parm_ME_IDs)
       AND spouse_pidm IS NOT NULL;

  spouse_pidm_row spouse_cur%ROWTYPE;
  spouse_id       VARCHAR2(9);
  retval          Number;
BEGIN

  retval := 1;

  --Insert Call Report
  BEGIN
  insert into amrcont
 (AMRCONT_PIDM,
   AMRCONT_IDEN_CODE,
   AMRCONT_SCNT_CODE,
   AMRCONT_ITEM_REFNO,
   AMRCONT_ACTIVITY_DATE,
   AMRCONT_CONTACT,
   AMRCONT_CONTACT_DATE,
   AMRCONT_USER_ID,
   AMRCONT_GEN_CONTACT_IND,
   AMRCONT_PROJ_CODE,
   AMRCONT_PROJ_CODE_2,
   AMRCONT_PROJ_CODE_3,
   AMRCONT_PROJ_CODE_4,
   AMRCONT_ASK_AMT,
   AMRCONT_ASK_AMT_2,
   AMRCONT_ASK_AMT_3,
   AMRCONT_ASK_AMT_4,
   AMRCONT_TICKLER,
   AMRCONT_TICK_DATE,
   AMRCONT_MOVE_CODE,
   AMRCONT_TICK_STATUS,
   AMRCONT_IDEN_CODE_ASGN,
   AMRCONT_CALL_REPORT,
   AMRCONT_CREATE_DATE
   )
 select donor.pidm,
    :parm_LB_originator.GURIDEN_IDEN_CODE,
    :parm_LB_contact.ATVSCNT_CODE,
    nvl(((select max(amrcont_item_refno)+1
       from amrcont
       where amrcont_pidm = donor.pidm)),1),
    sysdate,
    :parm_ME_contact,
    :parm_DT_contact_date,
    upper(:$User.Name),
    'N',
    :parm_LB_projects.ATVPROJ_CODE,
     (CASE
       when '*** NONE ***' = :parm_LB_projects_2.calc1
       then null
       else :parm_LB_projects_2.ATVPROJ_CODE
    END),
     (CASE
       when '*** NONE ***' = :parm_LB_projects_3.calc1
       then null
       else :parm_LB_projects_3.ATVPROJ_CODE
    END),
    (CASE
       when '*** NONE ***' = :parm_LB_projects_4.calc1
       then null
       else :parm_LB_projects_4.ATVPROJ_CODE
    END),
    :parm_EB_ask_amount,
    :parm_EB_ask_amount_2,
    :parm_EB_ask_amount_3,
    :parm_EB_ask_amount_4,
   '',
    '',
    :parm_LB_move.ATVMOVE_CODE,
    '',
     :parm_LB_originator.GURIDEN_IDEN_CODE,
    :parm_ME_call_report,
    sysdate
 from donor
 where id = :parm_ME_IDs
 and :parm_BT_create_call_reports is not null
       and '*** CHOOSE ONE ***' <>  :parm_LB_move.calc1
       and '*** CHOOSE ONE ***' <> :parm_LB_contact.calc1
       and '*** CHOOSE ONE ***' <> :parm_LB_projects.calc1
       and :parm_DT_contact_date <= trunc(sysdate)
       and '<Enter a contact description>' <> :parm_ME_contact
       and  length(:parm_ME_contact) <= 3000
       and (('SOL' <> :parm_LB_move.ATVMOVE_CODE) or ('SOL' = :parm_LB_move.ATVMOVE_CODE and :parm_EB_ask_amount is not null))
       and (nvl(:parm_EB_ask_amount,'x') not like '%$%' and nvl(:parm_EB_ask_amount,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_2,'x') not like '%$%' and nvl(:parm_EB_ask_amount_2,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_3,'x') not like '%$%' and nvl(:parm_EB_ask_amount_3,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_4,'x') not like '%$%' and nvl(:parm_EB_ask_amount_4,'x') not like '%,%');
  EXCEPTION
    WHEN OTHERS
    THEN retval := 0;
  END;

  --insert spouse call report if main report is successful and box is checked.
  IF :parm_CB_SpouseDuplicate = 1 AND retval > 0 THEN
    BEGIN
    FOR spouse_pidm_row IN spouse_cur LOOP
      spouse_id := '000000000';
      BEGIN
         SELECT donor.id INTO spouse_id
          FROM DONOR
         WHERE spouse_pidm_row.spouse_pidm = donor.pidm;
      EXCEPTION
        WHEN OTHERS
        THEN spouse_id := '000000000';
      END;

      IF spouse_ID <> :parm_ME_IDs and spouse_ID > '000000000' THEN
        --do call report insert
          insert into amrcont
 (AMRCONT_PIDM,
   AMRCONT_IDEN_CODE,
   AMRCONT_SCNT_CODE,
   AMRCONT_ITEM_REFNO,
   AMRCONT_ACTIVITY_DATE,
   AMRCONT_CONTACT,
   AMRCONT_CONTACT_DATE,
   AMRCONT_USER_ID,
   AMRCONT_GEN_CONTACT_IND,
   AMRCONT_PROJ_CODE,
   AMRCONT_PROJ_CODE_2,
   AMRCONT_PROJ_CODE_3,
   AMRCONT_PROJ_CODE_4,
   AMRCONT_ASK_AMT,
   AMRCONT_ASK_AMT_2,
   AMRCONT_ASK_AMT_3,
   AMRCONT_ASK_AMT_4,
   AMRCONT_TICKLER,
   AMRCONT_TICK_DATE,
   AMRCONT_MOVE_CODE,
   AMRCONT_TICK_STATUS,
   AMRCONT_IDEN_CODE_ASGN,
   AMRCONT_CALL_REPORT,
   AMRCONT_CREATE_DATE
   )
 select donor.pidm,
    :parm_LB_originator.GURIDEN_IDEN_CODE,
    :parm_LB_contact.ATVSCNT_CODE,
    nvl(((select max(amrcont_item_refno)+1
       from amrcont
       where amrcont_pidm = donor.pidm)),1),
    sysdate,
    :parm_ME_contact,
    :parm_DT_contact_date,
    upper(:$User.Name),
    'N',
    :parm_LB_projects.ATVPROJ_CODE,
     (CASE
       when '*** NONE ***' = :parm_LB_projects_2.calc1
       then null
       else :parm_LB_projects_2.ATVPROJ_CODE
    END),
     (CASE
       when '*** NONE ***' = :parm_LB_projects_3.calc1
       then null
       else :parm_LB_projects_3.ATVPROJ_CODE
    END),
    (CASE
       when '*** NONE ***' = :parm_LB_projects_4.calc1
       then null
       else :parm_LB_projects_4.ATVPROJ_CODE
    END),
    :parm_EB_ask_amount,
    :parm_EB_ask_amount_2,
    :parm_EB_ask_amount_3,
    :parm_EB_ask_amount_4,
   '',
    '',
    :parm_LB_move.ATVMOVE_CODE,
    '',
     :parm_LB_originator.GURIDEN_IDEN_CODE,
    :parm_ME_call_report,
    sysdate
 from donor
 where id = spouse_id
 and :parm_BT_create_call_reports is not null
       and '*** CHOOSE ONE ***' <>  :parm_LB_move.calc1
       and '*** CHOOSE ONE ***' <> :parm_LB_contact.calc1
       and '*** CHOOSE ONE ***' <> :parm_LB_projects.calc1
       and :parm_DT_contact_date <= trunc(sysdate)
       and '<Enter a contact description>' <> :parm_ME_contact
       and  length(:parm_ME_contact) <= 3000
       and (('SOL' <> :parm_LB_move.ATVMOVE_CODE) or ('SOL' = :parm_LB_move.ATVMOVE_CODE and :parm_EB_ask_amount is not null))
       and (nvl(:parm_EB_ask_amount,'x') not like '%$%' and nvl(:parm_EB_ask_amount,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_2,'x') not like '%$%' and nvl(:parm_EB_ask_amount_2,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_3,'x') not like '%$%' and nvl(:parm_EB_ask_amount_3,'x') not like '%,%')
       and (nvl(:parm_EB_ask_amount_4,'x') not like '%$%' and nvl(:parm_EB_ask_amount_4,'x') not like '%,%');
      END IF;
    END LOOP;
   END;
    
  END IF;
END;