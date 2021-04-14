CREATE OR REPLACE VIEW DQ_USER.V_DMP_SESSION_SUMMARY
AS
 with e as (select sum(error_count) as error_count
                ,  USE_CASE_ID
                , SESSION_ID
             from v_dmp_error_log
             group by 
                  USE_CASE_ID
                , SESSION_ID
          )
, dq_t as (select sum(DQ_RECORDS_FAILED) as DQ_RECORDS_FAILED
                , APTITUDE_PROJECT
                , APTITUDE_MICROFLOW
                , USE_CASE_ID
                , SESSION_ID
                , batch_process_id
                , DQ_RULE_TYPE
             from v_dmp_dq_log
            where DQ_RULE_TYPE ='T'
            group by  APTITUDE_PROJECT
                , APTITUDE_MICROFLOW
                , USE_CASE_ID
                , SESSION_ID
                , batch_process_id
                , DQ_RULE_TYPE
          )
, dq_b as (select sum(DQ_RECORDS_FAILED) as DQ_RECORDS_FAILED
                , APTITUDE_PROJECT
                , APTITUDE_MICROFLOW
                , USE_CASE_ID
                , SESSION_ID
                , batch_process_id
                , DQ_RULE_TYPE
             from v_dmp_dq_log
            where DQ_RULE_TYPE ='B'
            group by  APTITUDE_PROJECT
                , APTITUDE_MICROFLOW
                , USE_CASE_ID
                , SESSION_ID
                , batch_process_id
                , DQ_RULE_TYPE
          )
, joined as (          
select bs.use_case_id
     , bs.session_id
     , max(bs.STATUS)                        as BATCH_STATUS
     , max(CASE WHEN NVL(dq_b.DQ_RECORDS_FAILED,0) + NVL(dq_t.DQ_RECORDS_FAILED,0) > 0
            THEN 'E'
            WHEN NVL(dq_b.DQ_RECORDS_FAILED,0) + NVL(dq_t.DQ_RECORDS_FAILED,0) = 0
            THEN 'C'
           END)                               as DQ_STATUS
     , min(bs.START_TIME)                    as START_TIME
     , max(bs.END_TIME)                      as END_TIME
     , MAX(NVL(e.error_count,0))             as ERROR_COUNT
     , MAX(NVL(dq_t.DQ_RECORDS_FAILED,0))    as TECH_ERROR_COUNT
     , MAX(NVL(dq_b.DQ_RECORDS_FAILED,0))    as BUS_ERROR_COUNT
  from v_dmp_batch_status bs
  left join e
    on  bs.use_case_id           = e.use_case_id
    and bs.session_id            = e.session_id
  left join dq_t
    on  bs.use_case_id           = dq_t.use_case_id
    and bs.session_id            = dq_t.session_id
    and bs.aptitude_microflow    = dq_t.aptitude_microflow
  left join dq_b
    on  bs.use_case_id           = dq_b.use_case_id
    and bs.session_id            = dq_b.session_id 
    and bs.aptitude_microflow    = dq_b.aptitude_microflow
    group by bs.use_case_id
           , bs.session_id
)
select USE_CASE_ID
     , SESSION_ID
     , BATCH_STATUS
     , DQ_STATUS
     , START_TIME
     , END_TIME
     , ERROR_COUNT
     , TECH_ERROR_COUNT
     , BUS_ERROR_COUNT 
  from joined
where ( BATCH_STATUS != 'C' OR  DQ_STATUS != 'C')
   OR ( BATCH_STATUS != 'C' AND DQ_STATUS != 'C')
   OR ( BATCH_STATUS = 'C' AND DQ_STATUS = 'C' AND (START_TIME, USE_CASE_ID) in (select max(START_TIME)
                                                                                    , USE_CASE_ID
                                                                                 from joined
                                                                                where BATCH_STATUS = 'C' 
                                                                                  and DQ_STATUS = 'C'
                                                                             group by USE_CASE_ID
                                                                                ) 
      )
order by START_TIME;

/