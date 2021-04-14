CREATE OR REPLACE FUNCTION DQ_USER.fn_generate_key
(
  p_last_key                  VARCHAR2,
  p_key_width                 PLS_INTEGER
)
    RETURN VARCHAR2
AS

    c_ascii_0                 PLS_INTEGER := 48;
    c_ascii_9                 PLS_INTEGER := 57;
    c_ascii_A                 PLS_INTEGER := 65;
    c_ascii_Z                 PLS_INTEGER := 90;

    TYPE char_arr IS TABLE OF CHAR(1) INDEX BY PLS_INTEGER;
    l_arr                     char_arr;

    l_eval_ascii              PLS_INTEGER := 0;
    l_retval                  PLS_INTEGER := 0;
    l_key                     VARCHAR2(256);
    e_key_out_of_range        EXCEPTION;

    FUNCTION fn_get_next_char_in_seq ( p_char_ascii_code IN OUT PLS_INTEGER )
        RETURN PLS_INTEGER
    IS
        l_next_char_ascii_code      PLS_INTEGER;
    BEGIN
        l_next_char_ascii_code      := p_char_ascii_code + 1;

        IF (l_next_char_ascii_code BETWEEN c_ascii_0 AND c_ascii_9)
        OR (l_next_char_ascii_code BETWEEN c_ascii_A AND c_ascii_Z) THEN

            p_char_ascii_code       := l_next_char_ascii_code;
            RETURN 0;

        END IF;

        IF l_next_char_ascii_code = c_ascii_9 + 1 THEN

            p_char_ascii_code       := c_ascii_A;
            RETURN 0;

        END IF;

        IF l_next_char_ascii_code = c_ascii_Z + 1 THEN

            p_char_ascii_code       := c_ascii_0;
            RETURN 1;

        END IF;

        RAISE e_key_out_of_range;

    END fn_get_next_char_in_seq;

BEGIN

dbms_output.put_line('p_last_key='||p_last_key);

  IF p_last_key IS NULL THEN

    l_key := CHR(c_ascii_0);

  ELSE

    -- Store last key in character array for ease of manipulation
    FOR i IN 1..LENGTH(p_last_key)
    LOOP
        l_arr(i) := substr( p_last_key, i, 1 );
    END LOOP;

dbms_output.put_line('l_arr.count='||to_char(l_arr.count));

    -- Loop through array in reverse, e.g. XYZ, process Z, then Y, then X.
    FOR j in REVERSE 1..l_arr.count LOOP  -- Using reverse to know

dbms_output.put_line('j='||j);

     -- Convert to character in key to ASCII code
     l_eval_ascii := ASCII(l_arr(j));

dbms_output.put_line('eval_ascii='||l_eval_ascii||'('||CHR(l_eval_ascii)||')');

     -- Next character in sequence is returned in l_eval_ascii
     -- Retval = 0 indicates no wraparound has occurred
     -- Retval = 1 indicates wraparound has occurred
     l_retval := fn_get_next_char_in_seq ( l_eval_ascii );

dbms_output.put_line('retval='||l_retval);
dbms_output.put_line('new eval_ascii='||l_eval_ascii||'('||CHR(l_eval_ascii)||')');

     -- Replace last character in key string
     l_arr(j) := CHR(l_eval_ascii);

dbms_output.put_line('l_arr('||to_char(j)||')='||l_arr(j));

     -- No wraparound has occurred, so no need to process next character along - exit loop
     IF l_retval = 0 THEN
dbms_output.put_line('no wrapround, so no need to process next character along - exit loop');
       EXIT;
     ELSE
       -- If wraparound has occurred on leftmost character, prefix with 0 (zero) and exit loop
       IF j = 1 THEN
dbms_output.put_line('wraparound has occurred on leftmost character - if key width ok, prefix with 0 (zero) and exit loop');
         IF LENGTH(p_last_key) < p_key_width THEN
           l_key := CHR(c_ascii_0) || l_key;
           EXIT;
         ELSE
           -- Raise exception
           RAISE e_key_out_of_range;
         END IF;
       ELSE
         -- Continue in loop;
dbms_output.put_line('continue in loop='||l_key);
         NULL;
       END IF;
     END IF;

    END LOOP;

    -- Reconstruct key from character array
    FOR i In 1..l_arr.count
    LOOP
        l_key := l_key || l_arr(i);
    END LOOP;

  END IF;
dbms_output.put_line('new key='||l_key);

    RETURN l_key;

EXCEPTION

    WHEN e_key_out_of_range THEN
      RETURN NULL;
--        RAISE_APPLICATION_ERROR ( -20000, '!Error, Max sequence exceeded');

END fn_generate_key;
/
