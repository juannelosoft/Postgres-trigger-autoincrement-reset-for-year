CREATE OR REPLACE FUNCTION set_prelation() RETURNS TRIGGER AS $set_prelation$
            DECLARE
                new_increment integer;
            BEGIN
                SELECT MAX("invoice") INTO new_increment FROM "prelations" WHERE EXTRACT(YEAR FROM "created_at") = EXTRACT(YEAR FROM current_date);
                IF(new_increment IS NULL)
                    THEN
                        new_increment = 1;
                    ELSE
                        new_increment = new_increment + 1;
                END IF;
                NEW.invoice = new_increment;
                RETURN NEW;
            END;
        $set_prelation$ LANGUAGE plpgsql;

        CREATE TRIGGER "tr_prelation_page" BEFORE INSERT ON "prelations"
            FOR EACH ROW
            EXECUTE PROCEDURE set_prelation();
