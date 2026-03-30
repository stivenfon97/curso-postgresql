CREATE OR REPLACE FUNCTION sayHello( user_name varchar)
RETURNS varchar
AS
$$
BEGIN
 RETURN 'Hola ' || user_name;
END;
$$
LANGUAGE plpgsql;

SELECT sayHello('stiven');

/* ======================================================= */

CREATE OR REPLACE FUNCTION comment_replies( id integer)
RETURNS JSON
AS
$function$

DECLARE result JSON;

BEGIN

	SELECT 
		json_agg( json_build_object(
		  'user', comments.user_id,
		  'comment', comments.content
		)) INTO result
	FROM comments WHERE comment_parent_id = id;

	RETURN result;
 
END;
$function$
LANGUAGE plpgsql;


SELECT comment_replies(1);