create table g77_cfg.t_build_history
(
  build           varchar2(200 byte)
, branch          varchar2(100 byte)
, script          varchar2(500 byte)
, release_date    date 
, constraint pk_build_history primary key (build, branch, script)
  enable validate 
);