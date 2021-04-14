CREATE OR REPLACE FUNCTION g77_cfg.fn_get_arc_table_name(
   p_table_name    VARCHAR2,
   p_suffix        VARCHAR2 DEFAULT NULL
)
   RETURN VARCHAR2
IS
   lv_table_name  VARCHAR2( 50 ) := NULL;
   lv_max_length  NUMBER := 30;

   FUNCTION ifnotnull( p_value_f VARCHAR2, p_value_s VARCHAR2 )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_value_f IS NOT NULL
      THEN
         RETURN p_value_s;
      ELSE
         RETURN '';
      END IF;
   END ifnotnull;
BEGIN
   lv_max_length      :=
        lv_max_length
      - NVL( LENGTH( ifnotnull( p_suffix, '_' ) || p_suffix ), 0 );

   IF ( LENGTH( p_table_name ) > lv_max_length )
   THEN
      FOR rec IN (     SELECT REGEXP_SUBSTR( p_table_name,
                                             '[^_]+',
                                             1,
                                             LEVEL
                                            )
                                 AS item
                         FROM DUAL
                   CONNECT BY REGEXP_SUBSTR( p_table_name,
                                             '[^_]+',
                                             1,
                                             LEVEL
                                            )
                                 IS NOT NULL )
      LOOP
         IF ( LENGTH( rec.item ) > 3 )
         THEN
            lv_table_name      :=
                  lv_table_name
               || '_'
               || REGEXP_REPLACE( rec.item, '[aeiouyAEIOUY]', '' );
         ELSE
            lv_table_name      :=
               lv_table_name || ifnotnull( lv_table_name, '_' ) || rec.item;
         END IF;
      END LOOP;

      IF ( LENGTH( lv_table_name ) > lv_max_length )
      THEN
         lv_table_name   := SUBSTR( lv_table_name, 1, lv_max_length );
      END IF;
   ELSE
      lv_table_name   := p_table_name;
   END IF;

   RETURN lv_table_name || ifnotnull( p_suffix, '_' ) || p_suffix;
END fn_get_arc_table_name;
/