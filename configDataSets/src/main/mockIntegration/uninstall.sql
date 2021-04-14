@@db/g77_cfg/tables/99_uninstall.sql

@@db/g77_cfg/sequences/99_uninstall.sql

@@db/g77_cfg/triggers/99_uninstall.sql

@@db/g77_cfg/synonyms/99_uninstall.sql

@@db/g77_cfg/procedures/99_uninstall.sql


delete from g77_cfg.t_build_history where script like '%g77_cfgMockIntegration%';

commit;