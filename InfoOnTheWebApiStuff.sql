http://localhost/WebApiTest/AWVapi_client.php?db=9826&id=853629415
http://localhost/WebApiTest/AWVapi_prod.php?db=9657&id=853629415
820112004
831735460
817727960
838462364
895775218
832986466
821655697
852581300
894029340
853629415
(upper(donor_base.SORT_NAME) like '%'||upper(:A_TB_SearchCriteria)||'%'
  or upper(apbcons_maiden_last_name)||', '||upper(apbcons_pref_first_name) like '%'||upper(:A_TB_SearchCriteria)||'%'
  OR ( donor_base.ID = :A_TB_SearchCriteria))  and :M_CB_UseTheseIDs = 'N'
