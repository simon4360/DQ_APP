CREATE OR REPLACE PACKAGE BODY g77_cfg.pkg_g77 AS

  PROCEDURE pr_batch_task_stats (  p_aptitude_project    IN VARCHAR2,
                                   p_aptitude_microflow IN VARCHAR2
                                 ) IS
  BEGIN
                                
       for gs in (select table_name, stats_refresh_min 
                    from v_meta_batch_task_gather_stats 
                   where aptitude_project = p_aptitude_project 
                     and aptitude_microflow = p_aptitude_microflow )
       loop
         begin
           pkg_maintenance_util.pr_stats  ( p_table_name => gs.table_name 
                                          , p_gather_after_x_min => gs.stats_refresh_min
                                           );
         end;
       end loop;
   END pr_batch_task_stats;     
END pkg_g77;
/