CREATE OR REPLACE FUNCTION DQ_USER.fn_get_todays_business_date
RETURN DATE IS

ld_todays_bus_date DATE ;

BEGIN

 SELECT todays_bus_date
 INTO   ld_todays_bus_date
 FROM   t_global_parameter
 WHERE calendar_id = 1;


 RETURN ld_todays_bus_date;

END fn_get_todays_business_date;
/
