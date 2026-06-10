CREATE OR REPLACE TRIGGER ins_resv_solapada_abonado BEFORE INSERT ON RESERVA
 FOR EACH ROW
 DECLARE n INTEGER;
 BEGIN
    SELECT COUNT(*) INTO n
    FROM RESERVA
    WHERE :NEW.numabonado = RESERVA.numabonado
      AND :NEW.fechayhora = RESERVA.fechayhora;
      
    IF (n>0) THEN
       RAISE_APPLICATION_ERROR(-20000, 'El abonado ' || :NEW.numabonado || ' ya tiene una reserva para esa fecha y hora.');
    END IF;
 END;
 /

