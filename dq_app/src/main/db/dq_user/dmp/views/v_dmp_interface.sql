CREATE OR REPLACE VIEW DQ_USER.V_DMP_INTERFACE
AS 
  select category_name                  as USE_CASE_CATEGORY
     , last_start_time                  as LAST_START_TIME
     , decode(status,1,'E',2,'X',3,'C') as status
     , category_group
  from (select cat.category_name
             , cat.category_group
             , max(DMP.LAST_START_TIME) as LAST_START_TIME
             , min(DMP.BATCH_STATUS)    as status
          from DQ_USER.t_dmp_use_case_category cat
          join v_dmp_interface_details dmp
            on cat.category_group = dmp.use_case_category
         group by cat.category_name
                , cat.category_group)
 order by 1;
/