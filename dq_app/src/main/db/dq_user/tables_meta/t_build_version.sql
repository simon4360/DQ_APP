create table DQ_USER.t_build_version
(
  current_build   varchar2(200 byte)
, build_date      date 
, constraint pk_build_version primary key (current_build)
  enable validate 
);