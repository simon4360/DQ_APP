create table DQ_USER.t_task_worker
(
   t_task_worker_id number generated by default on null as identity (start with 1 order)
  ,task_name varchar2(4000) not null
  ,constraint pk_t_task_worker primary key(t_task_worker_id)
);