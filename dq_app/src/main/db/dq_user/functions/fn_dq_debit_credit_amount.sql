CREATE OR REPLACE FUNCTION DQ_USER.FN_DQ_DEBIT_CREDIT_AMOUNT (   p_session_id   VARCHAR2
                                                          , p_table        VARCHAR2
                                                          , p_where        VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_return_code VARCHAR2(50);
  v_count       NUMBER;
  v_where       VARCHAR2(32000);
  v_sql         VARCHAR2(32000);
BEGIN

  v_where := NVL(p_where, ' 1=1 ');


  IF p_table = 'T_FA0_INVESTMENT_IN'
  THEN
   v_sql := '
        SELECT COUNT(*)FROM (
            SELECT SUM(AMOUNT_OC) AS SUM_DR_CR_AMOUNT_OC
            ,SUM(AMOUNT_FC) AS SUM_AMOUNT_FC
            FROM T_FA0_INVESTMENT_IN
            WHERE SESSION_ID  = ''' || p_session_id || '''
            AND ' || v_where || '
            GROUP BY
                ACCOUNTING_DATE,
                LEGAL_ENTITY_CODE,
                CURRENCY_ORIGINAL,
                CURRENCY_FUNCTIONAL
            )
        WHERE SUM_DR_CR_AMOUNT_OC <>0 OR (SUM_AMOUNT_FC > 10 OR SUM_AMOUNT_FC < -10)';

  ELSIF p_table = 'T_ADY_PAYROLL_IN'
  THEN
   v_sql := '
    SELECT COUNT(*) FROM(
        SELECT (SUM(AMOUNT_DEBIT)-SUM(AMOUNT_CREDIT)) AS SUM_DR_CR_AMOUNT
        FROM T_ADY_PAYROLL_IN
        WHERE SESSION_ID  = ''' || p_session_id || '''
        AND ' || v_where || '
        GROUP BY
            PAY_CYCLE,
            ENTITY_ID,
            CURRENCY
        )
        WHERE SUM_DR_CR_AMOUNT<>0';
        
  ELSIF p_table = 'T_G61_COST_TRANSPARENCY_IN'
  THEN
       v_sql := '
           SELECT COUNT(*) FROM
                (
                  SELECT 
                SUM
                    (
                    CASE WHEN DBCR = ''D''
                            THEN TO_NUMBER ( DOCAMOUNT )
                    ELSE 
                        0
                    END
                    ) -
                SUM
                    ( 
                    CASE WHEN DBCR = ''C''                      
                            THEN TO_NUMBER ( DOCAMOUNT )
                    ELSE 
                        0
                    END
        ) AS SUM_DR_CR_AMOUNT        
                   FROM T_G61_COST_TRANSPARENCY_IN
                   WHERE SESSION_ID = ''' || p_session_id || '''
                   AND ' || v_where || '
               GROUP BY 
                LASTDATE, 
                DOCCURR, 
                ENTITY_ID,
                AP_AR_FLAG
            ) 
WHERE SUM_DR_CR_AMOUNT <> 0';
  END IF;

  EXECUTE IMMEDIATE v_sql
  INTO v_count;

  IF v_count > 0
  THEN
    v_return_code := 'DQERROR';
  ELSE
    v_return_code := 'SUCCESS';
  END IF;


  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';    
END;
/