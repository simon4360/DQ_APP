# Privilege maintenance

We have a bespoke process for granting privileges to technical and non-technical users.
The process will use the following table to grant the privileges: t_privs_config

For every object type it will assign the grants based on the configuration.
Follow the following steps if grants need to be added to a new role/user:
1) Create the role/user in all environments used
2) Add the correct configuration to t_privs_config: configDataSets\src\main\g77_cfgGrantPrivileges\db\g77_cfg\data\t_privs_config_cfg.sql
   - USER_OR_ROLE_NAME: Add the name of the user/role to which the privileges need to be granted.
   - OBJECT_NAME: Set the name of the object in field OBJECT_NAME.
     In case multiple objects need to have grants, create multiple records. 
     In case all objects of a certain type need to have grant, populate this field with 'ALL'
   - OBJECT_TYPE: Add only entries for object types to which the user need access, e.g. TABLE/VIEW etc.
   - PRIVILEGE: Set the privileges for that object type.
     Note that this will be the command executed when assigning grants, so this needs to be a correct Oracle value
     e.g. don't set a SELECT privilege on a procedure (causing ORA-02225 error)
	 Sample population:
	 USER_OR_ROLE_NAME	OBJECT_NAME	OBJECT_TYPE	PRIVILEGE
	 G77_CFG_TEC				ALL					TABLE				SELECT, UPDATE, INSERT, DELETE
	 G77_CFG_TEC				ALL					VIEW				SELECT
	 G77_CFG_TEC				ALL					PROCEDURE		EXECUTE
	 G77_CFG_TEC				ALL					FUNCTION		EXECUTE
	 G77_CFG_TEC				ALL					PACKAGE			EXECUTE

3) The grants will be assigned automatically during deployment.
4) If applicable (probably tech users only), create a script to create synonyms dynamically based on the grants
   in the tech user schema. So no prefixing is required:
   - Create a new schema directory in g77_cfgGrantPrivileges\db\ 
   - Add the script in there:
   Sample script:
   begin
     for obj in (select distinct table_name 
                   from user_tab_privs privs
                  where lower(privs.grantee) = '@g77_cfg_tecUsername@'
                  and   lower(privs.owner)   = '@g77_cfgUsername@'
                 union
                 select distinct synonym_name  
                   from user_tab_privs privs inner join all_synonyms syn 
                           on syn.table_name = privs.table_name                         
                  where lower(privs.grantee) = '@g77_cfg_tecUsername@'
                  and   lower(privs.owner)   = '@g77_cfgUsername@'
                  and   lower(syn.owner)     = '@g77_cfgUsername@'
                )
     loop 
       execute immediate 'create or replace synonym @g77_cfg_tecUsername@.' || obj.table_name || '
                           for @g77_cfgUsername@.' || obj.table_name;
     end loop ;
   end;
   / 
   - Create also synonyms for the synonyms to be able to connect to the mock tables.
   - Replace the above g77_cfg_tecUsername with the actual value or with the variable from 
     the .properties file.
5) If applicable (probably tech users only), add the correct username and encrypted password 
   to the .properties files.
6) If applicable (probably tech users only), change the corresponding Apitude Configuration Definitions to use
   the new user.
7) Make sure all scripts are called from an install.sql
