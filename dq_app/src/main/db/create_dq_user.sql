sqlplus ADMIN/Medieval180492!@db202104261350_medium

DROP USER "DQ_USER" CASCADE;

CREATE USER DQ_USER IDENTIFIED BY ABVdgbXCI8nd;


-- USER SQL
ALTER USER "DQ_USER"
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP"
ACCOUNT UNLOCK ;

-- QUOTAS
ALTER USER DQ_USER quota 100M on USERS;

-- ROLES

-- SYSTEM PRIVILEGES
GRANT DROP ANY TRIGGER TO "DQ_USER" ;
GRANT ALTER ANY INDEX TO "DQ_USER" ;
GRANT DROP ANY SEQUENCE TO "DQ_USER" ;
GRANT CREATE TRIGGER TO "DQ_USER" ;
GRANT ALTER ANY PROCEDURE TO "DQ_USER" ;
GRANT CREATE ANY PROCEDURE TO "DQ_USER" ;
GRANT CREATE SESSION TO "DQ_USER" ;
GRANT ALTER SESSION TO "DQ_USER" ;
GRANT CREATE MATERIALIZED VIEW TO "DQ_USER" ;
GRANT CREATE ANY INDEX TO "DQ_USER" ;
GRANT ALTER ANY MATERIALIZED VIEW TO "DQ_USER" ;
GRANT GRANT ANY OBJECT PRIVILEGE TO "DQ_USER" ;
GRANT CREATE ANY SEQUENCE TO "DQ_USER" ;
GRANT ALTER ANY TABLE TO "DQ_USER" ;
GRANT SELECT ANY TABLE TO "DQ_USER" ;
GRANT DELETE ANY TABLE TO "DQ_USER" ;
GRANT ALTER ANY SEQUENCE TO "DQ_USER" ;
GRANT DROP ANY MATERIALIZED VIEW TO "DQ_USER" ;
GRANT DROP ANY TABLE TO "DQ_USER" ;
GRANT SELECT ANY SEQUENCE TO "DQ_USER" ;
GRANT CREATE TYPE TO "DQ_USER" ;
GRANT DROP ANY TYPE TO "DQ_USER" ;
GRANT CREATE PUBLIC SYNONYM TO "DQ_USER" ;
GRANT CREATE ANY SYNONYM TO "DQ_USER" ;
GRANT DROP ANY SYNONYM TO "DQ_USER" ;
GRANT EXECUTE ANY PROCEDURE TO "DQ_USER" ;
GRANT CREATE SYNONYM TO "DQ_USER" ;
GRANT EXECUTE ANY TYPE TO "DQ_USER" ;
GRANT CREATE SEQUENCE TO "DQ_USER" ;
GRANT DROP ANY INDEX TO "DQ_USER" ;
GRANT UPDATE ANY TABLE TO "DQ_USER" ;
GRANT DROP ANY VIEW TO "DQ_USER" ;
GRANT GRANT ANY PRIVILEGE TO "DQ_USER" ;
GRANT ALTER ANY TRIGGER TO "DQ_USER" ;
GRANT CREATE ANY VIEW TO "DQ_USER" ;
GRANT DROP PUBLIC SYNONYM TO "DQ_USER" ;
GRANT INSERT ANY TABLE TO "DQ_USER" ;
GRANT CREATE ANY MATERIALIZED VIEW TO "DQ_USER" ;
GRANT ALTER ANY TYPE TO "DQ_USER" ;
GRANT DROP ANY PROCEDURE TO "DQ_USER" ;
GRANT CREATE ANY TRIGGER TO "DQ_USER" ;
GRANT CREATE ANY TABLE TO "DQ_USER" ;
GRANT CREATE ANY TYPE TO "DQ_USER" ;
GRANT CREATE PROCEDURE TO "DQ_USER" ;
GRANT GRANT ANY ROLE TO "DQ_USER" ;
