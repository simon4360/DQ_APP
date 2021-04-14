CREATE OR REPLACE PACKAGE DQ_USER.pkg_g77 AS
--proc name max 30 - 8 = 22 PKG_G77.[proc_name], if calling from aptitude. 

  PROCEDURE pr_batch_task_stats (  p_aptitude_project   IN VARCHAR2,
                                   p_aptitude_microflow IN VARCHAR2
                                );
                     
END pkg_g77;
/
