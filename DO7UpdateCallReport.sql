DECLARE
 refno NUMBER(13, 0);
BEGIN
refno := nvl((select max(amrcont_item_refno) + 1 from amrcont where amrcont_pidm = :parm_MC_search_results.pidm), 1);

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
    :parm_LB_UpdateAttendee.GURIDEN_IDEN_CODE,
    :multicolumn13.AMRCONT_SCNT_CODE,
    refno,
    sysdate,
    'Additional Attendee on this ' || :multicolumn13.AMRCONT_SCNT_CODE || ' for ' || :parm_MC_search_results.sort_name || ' on ' || :parm_DT_date_update || ', See original call report for full detail. FOR DARS ONLY: <' || donor.pidm || '>,<' || :multicolumn13.amrcont_item_refno || '> of original',
    :parm_DT_contact_date_update
    upper(:$User.Name),
    'N',
    :multicolumn13.AMRCONT_PROJ_CODE,
    :multicolumn13.AMRCONT_PROJ_CODE_2,
    :multicolumn13.AMRCONT_PROJ_CODE_3,
    :multicolumn13.AMRCONT_PROJ_CODE_4,
    :multicolumn13.AMRCONT_ASK_AMT,
    :multicolumn13.AMRCONT_ASK_AMT_2,
    :multicolumn13.AMRCONT_ASK_AMT_3,
    :multicolumn13.AMRCONT_ASK_AMT_4,
    NULL
    NULL,
    :parm_DD_move_update.ATVMOVE_CODE,
    NULL,
    :parm_LB_UpdateAttendee.GURIDEN_IDEN_CODE,
    ' ',
    sysdate,
    'DO 07 UPDATE'
 from donor
 where id = :parm_EB_ID
 and :parm_BT_update_past_call_report is not null 
       AND '*** Choose One ***' <> :parm_LB_UpdateAttendeeToAdd
       and :parm_MC_search_results.ID is not null;
--Add crosstable reference
Insert into U_Call_Report_Crosstable
(ORIGINATOR_PIDM,
ORIGINATOR_REFNO,
ATTENDEE_PIDM,
ATTENDEE_PIDM,
CREATE_DATE,
CREATE_USERID)
VALUES
(:parm_MC_search_results.PIDM,
:multicolumn13.amrcont_item_refno,
:parm_MC_search_results.PIDM
refno,
trunc(sysdate),
upper(:$User.Name));
END;