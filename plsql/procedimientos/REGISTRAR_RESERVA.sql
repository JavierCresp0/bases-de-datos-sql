CREATE OR REPLACE PROCEDURE REGISTRAR_RESERVA (
    p_numabonado  IN RESERVA.numabonado%TYPE,
    p_codigopista IN RESERVA.codigopista%TYPE,
    p_fechayhora  IN RESERVA.fechayhora%TYPE
) IS
    v_existe NUMBER;
BEGIN
    
    SELECT COUNT(*)
    INTO v_existe
    FROM ABONADO
    WHERE numabonado = p_numabonado;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No existe el abonado indicado.');
    END IF;

    
    SELECT COUNT(*)
    INTO v_existe
    FROM PISTA
    WHERE codigo = p_codigopista;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No existe la pista indicada.');
    END IF;

   
    SELECT COUNT(*)
    INTO v_existe
    FROM RESERVA
    WHERE codigopista = p_codigopista
      AND fechayhora  = p_fechayhora;

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Ya existe una reserva para esa pista en esa fecha y hora.');
    END IF;

    
    SELECT COUNT(*)
    INTO v_existe
    FROM RESERVA
    WHERE numabonado = p_numabonado
      AND fechayhora  = p_fechayhora;

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El abonado ya tiene una reserva en esa fecha y hora.');
    END IF;

   
    INSERT INTO RESERVA (numabonado, codigopista, fechayhora)
    VALUES (p_numabonado, p_codigopista, p_fechayhora);

    DBMS_OUTPUT.PUT_LINE('Reserva realizada correctamente.');

END REGISTRAR_RESERVA;

