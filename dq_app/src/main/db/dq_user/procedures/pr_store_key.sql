CREATE OR REPLACE PROCEDURE DQ_USER.pr_store_key
(
  p_key_type              IN  VARCHAR2,
  p_key_attribute_string  IN  VARCHAR2,
  p_key                   OUT VARCHAR2
)
AS
  PRAGMA AUTONOMOUS_TRANSACTION;

  l_last_generated_key    VARCHAR2(256);
  l_new_key               VARCHAR2(256);
  l_key_width             PLS_INTEGER := 0;
  l_count                 PLS_INTEGER := 0;

BEGIN

  p_key := NULL;

  -- Check attribute string already exists
  SELECT COUNT(1)
  INTO   l_count
  FROM   t_key_combinations pkc
  WHERE  pkc.key_type = p_key_type
  AND    pkc.key_attribute_string = p_key_attribute_string;

  -- Attribute string does not exist
  IF l_count = 0 THEN

    -- Get info from key type
    SELECT pkd.last_generated_key,
           pkd.key_width
    INTO   l_last_generated_key,
           l_key_width
    FROM   t_key_definitions pkd
    WHERE  pkd.key_type = p_key_type;

    -- Generate new key
    l_new_key := fn_generate_key (l_last_generated_key,l_key_width);

    -- If key generated then add to key combinations table

    IF l_new_key IS NOT NULL THEN

      INSERT INTO t_key_combinations
      (
        key_type,
        key_generated,
        key_attribute_string,
        created_by,
        created_on
      )
      VALUES
      (
        p_key_type,
        l_new_key,
        p_key_attribute_string,
        USER,
        SYSDATE
      );

      -- Update t_key_definitions with last_generated_key
      UPDATE t_key_definitions pkd
      SET    last_generated_key = l_new_key,
             amended_on = SYSDATE,
             amended_by = USER
      WHERE  pkd.key_type = p_key_type;

      p_key := l_new_key;

    END IF;

  END IF;

  COMMIT;

EXCEPTION

  WHEN OTHERS THEN

    -- handle exceptions here
    ROLLBACK;

END pr_store_key;
/
