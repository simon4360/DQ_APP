CREATE OR REPLACE FUNCTION DQ_USER.fn_get_session_id ( p_prefix     IN  VARCHAR2 ) 
RETURN VARCHAR2
IS
  o_session_id VARCHAR2(200);
BEGIN 
  SELECT p_prefix || SQ_SESSION_ID.nextval INTO o_session_id FROM DUAL;

RETURN o_session_id;

END;
/