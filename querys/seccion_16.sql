---------------------------------------------------------------------------
-------------------------- TRIGGERS --------------------------
---------------------------------------------------------------------------

ALTER TABLE "usuarios" 
ALTER COLUMN username TYPE varchar

ALTER TABLE "usuarios" 
ALTER COLUMN last_login SET DEFAULT now();

INSERT INTO "usuarios" (username, password)
VALUES ('STIVEN', crypt('123456', gen_salt('bf')) );


SELECT * FROM "usuarios";

CREATE EXTENSION pgcrypto;

SELECT * FROM "usuarios" 
	WHERE  username='STIVEN'
	AND password = crypt('123456', password);

---------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS $$

DECLARE
	was_found BOOLEAN;

BEGIN

	SELECT COUNT(*) INTO was_found FROM "usuarios"
		WHERE username = user_name AND
		password = crypt(user_password, password);

	IF ( was_found = false ) THEN
		INSERT INTO session_faild (username, attempt)
		VALUES (user_name, NOW());
		COMMIT;
		RAISE EXCEPTION 'Usuario y contrasena no son correctos';
	END IF;

	UPDATE "usuarios" SET last_login = NOW() WHERE username = user_name;
	
	COMMIT;
	
	RAISE NOTICE 'Usuario encontrado %', was_found;
		
END;

$$ LANGUAGE plpgsql;


CALL user_login('STIVEN', '123456')

SELECT * FROM session_faild

---------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER create_session_trigger AFTER UPDATE ON "usuarios"
FOR EACH ROW EXECUTE PROCEDURE create_session_log();

CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$

	BEGIN

		INSERT INTO "session"(user_id, last_login)
		VALUES( NEW.id, NOW());

		RETURN NEW;
	
	END;

$$ LANGUAGE plpgsql;

SELECT * FROM session

---------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER create_session_trigger_when AFTER UPDATE ON "usuarios"
FOR EACH ROW 
WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login)
EXECUTE FUNCTION create_session_log();

CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$

	BEGIN

		INSERT INTO "session"(user_id, last_login)
		VALUES( NEW.id, NOW());

		RETURN NEW;
	
	END;

$$ LANGUAGE plpgsql;