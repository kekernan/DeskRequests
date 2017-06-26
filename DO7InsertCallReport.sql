DECLARE
 refno NUMBER;
BEGIN
refno := nvl((select max(amrcont_item_refno)+1 from amrcont where amrcont_pidm = :parm_MC_search_results.pidm), 1);
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
   AMRCONT_CREATE_DATE,
   amrcont_data_origin
   )
 select donor.pidm,
    :parm_LB_originator.GURIDEN_IDEN_CODE,
    :parm_LB_scnt_code.ATVSCNT_CODE,
    refno,
    sysdate,
    :parm_ME_contact,
    :parm_DT_contact_date,
    upper(:$User.Name),
    'N',
    :parm_LB_project_1.ATVPROJ_CODE,
     (CASE
       when '*** NONE ***' = :parm_LB_project_2.calc1
       then null
       else :parm_LB_project_2.ATVPROJ_CODE
    END),
     (CASE
       when '*** NONE ***' = :parm_LB_project_3.calc1
       then null
       else :parm_LB_project_3.ATVPROJ_CODE
    END),
    (CASE
       when '*** NONE ***' = :parm_LB_project_4.calc1
       then null
       else :parm_LB_project_4.ATVPROJ_CODE
    END),
    :parm_EB_project_1_ask_amount,
    :parm_EB_project_2_ask_amount,
    :parm_EB_project_3_ask_amount,
    :parm_EB_project_4_ask_amount,
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN null
       ELSE :parm_ME_next_step
    END),
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN null
       ELSE :parm_DT_next_step_date
    END),
    :parm_LB_move_code.ATVMOVE_CODE,
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step 
       THEN null
       ELSE 'P'
    END),
     (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN :parm_LB_next_step_person.GURIDEN_IDEN_CODE
       ELSE :parm_LB_next_step_person.GURIDEN_IDEN_CODE
    END),
    nvl(:parm_ME_Call_report,' '),
    sysdate,
    'DO 07 CREATE'
 from donor
 where id = :parm_EB_ID
 and :parm_BT_create_call_report is not null 
       and '*** Choose One ***' <>  :parm_LB_move_code.ATVMOVE_DESC
       and '*** Choose One ***' <> :parm_LB_scnt_code.ATVSCNT_DESC
       and '*** Choose One ***' <> :parm_LB_project_1.calc1
       and :parm_MC_search_results.ID is not null
       and :parm_DT_contact_date is not null and :parm_DT_contact_date <= trunc(sysdate)
       and '<Enter the description of the contact>' <> :parm_ME_contact
       and  nvl((length(:parm_ME_Call_report)),0) <= 4000
       and (('SOL' <> :parm_LB_move_code.ATVMOVE_CODE) or ('SOL' = :parm_LB_move_code.ATVMOVE_CODE and :parm_EB_project_1_ask_amount is not null ))
       and ( (:parm_ME_next_step is not null
                and :parm_DT_next_step_date is not null and trunc(sysdate) <= :parm_DT_next_step_date
                and :parm_ME_next_step <> '<Enter next step>') or (:parm_ME_next_step = '<Enter next step>') );
--add second attendee
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
   AMRCONT_CREATE_DATE,
   amrcont_data_origin
   )
 select donor.pidm,
    :parm_LB_attendee.GURIDEN_IDEN_CODE,
    :parm_LB_scnt_code.ATVSCNT_CODE,
    refno + 1,
    sysdate,
    'Additional Attendee on this ' || :parm_LB_scnt_code.ATVSCNT_CODE || ' for ' || :parm_MC_search_results.sort_name || ' on ' || :parm_DT_contact_date || ', See original call report for full detail. FOR DARS ONLY: <' || donor.pidm || '>,<' || refno || '> of original',
    :parm_DT_contact_date,
    upper(:$User.Name),
    'N',
    :parm_LB_project_1.ATVPROJ_CODE,
     (CASE
       when '*** NONE ***' = :parm_LB_project_2.calc1
       then null
       else :parm_LB_project_2.ATVPROJ_CODE
    END),
     (CASE
       when '*** NONE ***' = :parm_LB_project_3.calc1
       then null
       else :parm_LB_project_3.ATVPROJ_CODE
    END),
    (CASE
       when '*** NONE ***' = :parm_LB_project_4.calc1
       then null
       else :parm_LB_project_4.ATVPROJ_CODE
    END),
    :parm_EB_project_1_ask_amount,
    :parm_EB_project_2_ask_amount,
    :parm_EB_project_3_ask_amount,
    :parm_EB_project_4_ask_amount,
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN null
       ELSE :parm_ME_next_step
    END),
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN null
       ELSE :parm_DT_next_step_date
    END),
    :parm_LB_move_code.ATVMOVE_CODE,
    (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step 
       THEN null
       ELSE 'P'
    END),
     (CASE
       WHEN '<Enter next step>' = :parm_ME_next_step
       THEN :parm_LB_next_step_person.GURIDEN_IDEN_CODE
       ELSE :parm_LB_next_step_person.GURIDEN_IDEN_CODE
    END),
    ' ',
    sysdate,
    'DO 07 CREATE'
 from donor
 where id = :parm_EB_ID
 and :parm_BT_create_call_report is not null 
       AND '*** Choose One ***' <> :parm_LB_attendee.GURIDEN_IDEN_CODE
       and '*** Choose One ***' <> :parm_LB_move_code.ATVMOVE_DESC
       and '*** Choose One ***' <> :parm_LB_scnt_code.ATVSCNT_DESC
       and '*** Choose One ***' <> :parm_LB_project_1.calc1
       and :parm_MC_search_results.ID is not null
       and :parm_DT_contact_date is not null and :parm_DT_contact_date <= trunc(sysdate)
       and '<Enter the description of the contact>' <> :parm_ME_contact
       and  nvl((length(:parm_ME_Call_report)),0) <= 4000
       and (('SOL' <> :parm_LB_move_code.ATVMOVE_CODE) or ('SOL' = :parm_LB_move_code.ATVMOVE_CODE and :parm_EB_project_1_ask_amount is not null ))
       and ( (:parm_ME_next_step is not null
                and :parm_DT_next_step_date is not null and trunc(sysdate) <= :parm_DT_next_step_date
                and :parm_ME_next_step <> '<Enter next step>') or (:parm_ME_next_step = '<Enter next step>') );
END;