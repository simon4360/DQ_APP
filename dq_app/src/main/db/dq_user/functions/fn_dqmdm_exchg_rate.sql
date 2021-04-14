CREATE OR REPLACE FUNCTION DQ_USER.FN_DQMDM_EXCHG_RATE (p_session_id IN VARCHAR2, p_rate_type IN VARCHAR2, p_perc NUMBER)
   RETURN VARCHAR2
   DETERMINISTIC
IS
  PRAGMA AUTONOMOUS_TRANSACTION;

--Defining variables :: Start

  v_sysdate_day_of_week   VARCHAR2(50);
  v_sysdate_hour   number;
  v_business_date DATE;
  v_return_code   VARCHAR2(50);
  v_sql           VARCHAR2(32000);
  v_count_ref     NUMBER;
  v_count_diff    NUMBER;
  v_message_text  varchar2(4000);
  v_message_text_tmp varchar2(1000);

--Defining variables :: End

BEGIN
  -- count of Active exchange rate currenty pairs in REF_EXCHANGE_RATE
  SELECT COUNT(*) into v_count_ref FROM
    (
    SELECT
      DISTINCT CRNCY_TO,CRNCY_FRM
    FROM
      DQ_USER.REF_EXCHANGE_RATE
    WHERE
      EXCH_RTE_TYP=p_rate_type AND ACTIVE_INDICATOR='Active'
    );

  -- Store the exact difference in count of Active and daily exchange rates present in Refernce Table and count of
  -- Active daily exchange rates present in Gateway Inbound table for current business date
  SELECT COUNT(*) into v_count_diff FROM
  (
    SELECT
      DISTINCT CRNCY_FRM,CRNCY_TO
      FROM
        DQ_USER.REF_EXCHANGE_RATE
      WHERE
        EXCH_RTE_TYP=p_rate_type AND ACTIVE_INDICATOR='Active'
    MINUS
    SELECT
      DISTINCT BASE_CURRENCY_CODE,TERM_CURRENCY_CODE
      FROM
        DQ_USER.T_MDM_EXCHANGE_RATE_IN
      WHERE
        EVENT_STATUS = 0
        AND EXCHANGE_RATE_TYPE_CODE=p_rate_type
        AND ACTIVE_INDICATOR='Active'
        AND SESSION_ID=p_session_id
  );

  v_message_text := 'p_session_id='||p_session_id||' p_rate_type='||p_rate_type||' p_perc='||p_perc||' v_count_ref='||v_count_ref||' v_count_diff='||v_count_diff||' error when this is true:'||((v_count_ref - v_count_diff) / nullif(v_count_ref,0))||'<'||p_perc;
  select 'DQ 1. SOURCE=MV_CUR_EXCHANGE_RATE, MAX_ARRIVAL_TIME='||nvl(to_char(max(ARRIVAL_TIME),'YYYY-MM-DD HH24:MI:SS'),'-')||', CNT='||count(*) into v_message_text_tmp from DQ_USER.T_MDM_EXCHANGE_RATE_IN where SOURCE_DEVICE_NAME = 'MV_CUR_EXCHANGE_RATE' AND EXCHANGE_RATE_TYPE_CODE=p_rate_type AND ACTIVE_INDICATOR='Active';
  v_message_text := v_message_text || ' ' || v_message_text_tmp;
  select 'DQ 2. SOURCE=T_MDM_EXCHANGE_RATE_IN, MAX_ARRIVAL_TIME='||nvl(to_char(max(ARRIVAL_TIME),'YYYY-MM-DD HH24:MI:SS'),'-')||', CNT='||count(*) into v_message_text_tmp from DQ_USER.T_MDM_EXCHANGE_RATE_IN where SOURCE_DEVICE_NAME = 'T_MDM_EXCHANGE_RATE_IN' AND EXCHANGE_RATE_TYPE_CODE=p_rate_type AND ACTIVE_INDICATOR='Active';
  v_message_text := v_message_text || ' ' || v_message_text_tmp;
  select 'DQ 3. SOURCE=MV_CUR_EXCHANGE_RATE, SESSION_ID='||p_session_id||',MAX_ARRIVAL_TIME='||nvl(to_char(max(ARRIVAL_TIME),'YYYY-MM-DD HH24:MI:SS'),'-')||', CNT='||count(*) into v_message_text_tmp from DQ_USER.T_MDM_EXCHANGE_RATE_IN where SOURCE_DEVICE_NAME = 'MV_CUR_EXCHANGE_RATE' AND SESSION_ID=p_session_id AND EXCHANGE_RATE_TYPE_CODE=p_rate_type AND ACTIVE_INDICATOR='Active';
  v_message_text := v_message_text || ' ' || v_message_text_tmp;
  select 'DQ 4. SOURCE=T_MDM_EXCHANGE_RATE_IN, SESSION_ID='||p_session_id||',MAX_ARRIVAL_TIME='||nvl(to_char(max(ARRIVAL_TIME),'YYYY-MM-DD HH24:MI:SS'),'-')||', CNT='||count(*) into v_message_text_tmp from DQ_USER.T_MDM_EXCHANGE_RATE_IN where SOURCE_DEVICE_NAME = 'T_MDM_EXCHANGE_RATE_IN' AND SESSION_ID=p_session_id AND EXCHANGE_RATE_TYPE_CODE=p_rate_type AND ACTIVE_INDICATOR='Active';
  v_message_text := v_message_text || ' ' || v_message_text_tmp;
  
  
  -- If the available exchange rates in Gateway Inbound table is less than
  -- <<p_perc>> % [where p_perc is the threshold percentage value which will be set in DQ_FUNCTION_PARAMETERS in table T_META_TABLE_DQ ]
  -- then the function will return "DQERROR', otherwise it will return 'SUCCESS'
  IF ((v_count_ref - v_count_diff) / nullif(v_count_ref,0) < p_perc) or (v_count_ref = 0)
  THEN
    v_return_code := 'DQERROR';
  ELSE
    v_return_code := 'SUCCESS';
  END IF;

  v_message_text := v_message_text || ' v_return_code (from calculation formula)=' || v_return_code;

  -- if there is DQERROR check whether it is weekend (SAT 04:00:00 - MON 04:00:00) if yes then assume that we can have incomplete data
  if (v_return_code = 'DQERROR')
  then
    v_sysdate_day_of_week := to_char(sysdate, 'DY');
    v_sysdate_hour := to_number(to_char(sysdate,'HH24'));
    if (v_sysdate_day_of_week = 'SAT' and v_sysdate_hour >= 4) or (v_sysdate_day_of_week = 'SUN') or (v_sysdate_day_of_week = 'MON' and v_sysdate_hour <= 4)
    then
      v_return_code := 'SUCCESS';
    else
      v_return_code := 'DQERROR';
    end if;
  end if;

  v_message_text := v_message_text || ' v_return_code=' || v_return_code;
  pr_info('G77_SRC_MDM','FN_DQMDM_EXCHG_RATE',v_message_text,'MDM','G77','T_MDM_EXCHANGE_RATE_IN',0,'UCN5002E',p_session_id,0,0,0);

RETURN v_return_code;

EXCEPTION
    WHEN OTHERS THEN
    RETURN 'DQERROR';
END FN_DQMDM_EXCHG_RATE;
/