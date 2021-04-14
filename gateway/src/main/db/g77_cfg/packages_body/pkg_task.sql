create or replace package body g77_cfg.pkg_task as
  e_resource_busy exception;
  pragma exception_init(e_resource_busy, -54); /* ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired - raised is another process is trying to do for already locked row: select...for update */
  
  procedure update_task_workers is
    v_t_task_cfg_id t_task_cfg.t_task_cfg_id%type;
    v_task_name t_task_cfg.task_name%type;
    v_max_workers t_task_cfg.max_workers%type;
    v_cnt_workers number;
    v_cnt_workers_diff number;
    v_t_task_worker_id t_task_worker.t_task_worker_id%type;
    v_t_task_cfg_resource_busy pls_integer;
    v_t_task_worker_resource_busy pls_integer;
    cursor cur_t_task_cfg is 
      select distinct t_task_cfg.t_task_cfg_id, t_task_worker.task_name, nvl(t_task_cfg.max_workers,0) max_workers
      from t_task_cfg right outer join t_task_worker on t_task_cfg.task_name = t_task_worker.task_name; /* "right outer join" to be able to remove rows from t_task_worker for tasks which doesn't exist in t_task_cfg */
    cursor cur_t_task_worker(p_task_name t_task_worker.task_name%type) is select t_task_worker_id from t_task_worker where task_name = p_task_name order by t_task_worker_id desc;
  begin
    for row_t_task_cfg in cur_t_task_cfg /* loop on all rows in t_task_cfg */
    loop
      v_task_name := row_t_task_cfg.task_name;
      v_max_workers := row_t_task_cfg.max_workers;
      v_t_task_cfg_resource_busy := 0;
      if row_t_task_cfg.t_task_cfg_id is not null
      then
        begin
          select t_task_cfg_id into v_t_task_cfg_id from t_task_cfg where t_task_cfg_id = row_t_task_cfg.t_task_cfg_id for update nowait; /* to check whether row is currently processing */
        exception
        when e_resource_busy then
          v_t_task_cfg_resource_busy := 1;
        when others then
          null; -- TODO: logowanie
        end;
      end if;
      if (v_t_task_cfg_resource_busy = 0)
      then
        select count(1) into v_cnt_workers from t_task_worker where task_name = v_task_name;
        v_cnt_workers_diff := v_cnt_workers - v_max_workers; /* >0 - we have more workers in t_task_worker than there should be (based on cfg t_task_cfg) - then delete rows from t_task_worker 
                                                                <0 - we have LESS workersthan there should be (based on cfg t_task_cfg) - then add rows to t_task_worker    */
        while (v_cnt_workers_diff != 0)
        loop
          if (v_cnt_workers_diff > 0) /* then delete rows from t_task_worker  */
          then
            for row_t_task_worker in cur_t_task_worker(v_task_name)
            loop
              begin
                v_t_task_worker_resource_busy := 0;
                select t_task_worker_id into v_t_task_worker_id from t_task_worker where t_task_worker_id = row_t_task_worker.t_task_worker_id for update nowait; /* to check whether row is currently processing */
              exception
              when e_resource_busy then
                v_t_task_worker_resource_busy := 1;
              when others then
                null; -- TODO: logowanie
              end;
              if (v_t_task_worker_resource_busy = 0)
              then
                delete from t_task_worker where t_task_worker_id = v_t_task_worker_id;
                v_cnt_workers_diff := v_cnt_workers_diff - 1;
                exit when v_cnt_workers_diff = 0;
              end if;
            end loop;
            v_cnt_workers_diff := 0; /* to exit from while loop even not all workesrs were deleted (due to resource busy) */
          else /* add rows to t_task_worker */
            begin
              insert into t_task_worker(task_name) values(v_task_name);
              v_cnt_workers_diff := v_cnt_workers_diff + 1;
            exception
            when others then
              null; -- TODO: logowanie
            end;
          end if;
        end loop;
      end if;
    end loop;
  end;

  procedure update_task_list is
  begin
    null;
  end;
END pkg_task;
/
