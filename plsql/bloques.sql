/*************/
/* FUNCIONES */
/*************/
CREATE OR REPLACE FUNCTION TOTAL_RESERVAS_PISTA(
    p_codigopista PISTA.codigo%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM RESERVA r
    WHERE r.codigopista = p_codigopista;

    RETURN v_total;
END;
/
CREATE OR REPLACE FUNCTION TOTAL_GASTO_SALARIOS
RETURN NUMBER
IS
    v_total NUMBER := 0;
BEGIN
    SELECT NVL(SUM(salario), 0)
    INTO v_total
    FROM TRABAJADOR;

    RETURN v_total;
EXCEPTION
    WHEN OTHERS THEN
        -- En caso de error devolvemos -1 para indicar fallo.
        RETURN -1;
END;
/

CREATE OR REPLACE FUNCTION PISTAS_RESERVA_FECHA(
    p_fecha IN DATE
) RETURN VARCHAR2
IS
    v_lista  VARCHAR2(4000) := NULL;
    v_first  BOOLEAN := TRUE;
BEGIN
    FOR r IN (
        SELECT DISTINCT TRIM(p.codigo) AS codigo
        FROM RESERVA res
        JOIN PISTA   p ON TRIM(res.codigopista) = TRIM(p.codigo)
        WHERE TRUNC(res.fechayhora) = TRUNC(p_fecha)
        ORDER BY TRIM(p.codigo)
    ) LOOP
        -- Imprimir cada pista encontrada
        DBMS_OUTPUT.PUT_LINE('Pista con reserva: ' || r.codigo);

        -- Construir la lista devuelta
        IF v_first THEN
            v_lista := r.codigo;
            v_first := FALSE;
        ELSE
            v_lista := v_lista || ', ' || r.codigo;
        END IF;
    END LOOP;

    IF v_lista IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('No hay reservas para la fecha ' || TO_CHAR(p_fecha,'YYYY-MM-DD'));
        RETURN NULL;
    ELSE
        RETURN v_lista;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en PISTAS_RESERVA_FECHA: ' || SQLERRM);
        RETURN NULL;
END PISTAS_RESERVA_FECHA;
/

/******************/
/* PROCEDIMIENTOS */
/******************/
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
/


CREATE OR REPLACE PROCEDURE MARCAR_DESCUENTO_USADO (
  p_numabonado   IN TIENE.numabonado%TYPE,
  p_ciftien      IN TIENE.ciftien%TYPE,
  p_coddescuento IN TIENE.coddescuento%TYPE
) IS
  v_existe    NUMBER;
  v_utilizado TIENE.descuentoutilizado%TYPE;
BEGIN
  SELECT COUNT(*)
  INTO v_existe
  FROM ABONADO
  WHERE numabonado = p_numabonado;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20011, 'No existe el abonado indicado.');
  END IF;

  SELECT COUNT(*)
  INTO v_existe
  FROM TIENDA
  WHERE cif = p_ciftien;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20012, 'No existe la tienda indicada.');
  END IF;

  SELECT COUNT(*)
  INTO v_existe
  FROM DESCUENTO
  WHERE cif = p_ciftien
    AND codigo = p_coddescuento;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20013, 'No existe el descuento indicado para esa tienda.');
  END IF;

  BEGIN
    SELECT descuentoutilizado
    INTO v_utilizado
    FROM TIENE
    WHERE numabonado = p_numabonado
      AND ciftien = p_ciftien
      AND coddescuento = p_coddescuento;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20014, 'El abonado no tiene asignado ese descuento.');
  END;


  IF v_utilizado = 'SI' THEN
    RAISE_APPLICATION_ERROR(-20015, 'El descuento ya consta como utilizado.');
  END IF;


  UPDATE TIENE
  SET descuentoutilizado = 'SI'
  WHERE numabonado = p_numabonado
    AND ciftien = p_ciftien
    AND coddescuento = p_coddescuento;

  DBMS_OUTPUT.PUT_LINE('Descuento marcado como utilizado correctamente.');

END MARCAR_DESCUENTO_USADO;
/

CREATE OR REPLACE PROCEDURE LISTAR_CLASES_MONITOR (
  p_dni IN MONITOR.dni%TYPE
) IS
  v_existe NUMBER;
  v_total  NUMBER := 0;

  CURSOR c_clases IS
    SELECT i.fechayhora, i.codigoclase, i.codigosala
    FROM IMPARTIR i
    WHERE i.dnimon = p_dni
    ORDER BY i.fechayhora;

BEGIN
 
  SELECT COUNT(*)
  INTO v_existe
  FROM MONITOR
  WHERE dni = p_dni;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20021, 'No existe el monitor indicado.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Clases impartidas por el monitor ' || p_dni || ':');

  FOR r IN c_clases LOOP
    v_total := v_total + 1;
    DBMS_OUTPUT.PUT_LINE(
      '- ' || TO_CHAR(r.fechayhora, 'DD/MM/YYYY HH24:MI') ||
      ' | Clase: ' || r.codigoclase ||
      ' | Sala: ' || r.codigosala
    );
  END LOOP;

  IF v_total = 0 THEN
    DBMS_OUTPUT.PUT_LINE('El monitor no imparte ninguna clase.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Total clases: ' || v_total);

END LISTAR_CLASES_MONITOR;

/

CREATE OR REPLACE PROCEDURE SUBIR_SALARIO_TRABAJADOR (
  p_dni     IN TRABAJADOR.dni%TYPE,
  p_importe IN NUMBER
) IS
  v_existe         NUMBER;
  v_salario_actual TRABAJADOR.salario%TYPE;
BEGIN

  SELECT COUNT(*)
  INTO v_existe
  FROM TRABAJADOR
  WHERE dni = p_dni;

  IF v_existe = 0 THEN
    RAISE_APPLICATION_ERROR(-20031, 'No existe ningún trabajador con ese DNI.');
  END IF;


  IF p_importe <= 0 THEN
    RAISE_APPLICATION_ERROR(-20032, 'El importe de subida debe ser mayor que 0.');
  END IF;


  SELECT salario
  INTO v_salario_actual
  FROM TRABAJADOR
  WHERE dni = p_dni;


  UPDATE TRABAJADOR
  SET salario = salario + p_importe
  WHERE dni = p_dni;

  

  DBMS_OUTPUT.PUT_LINE('Salario actualizado de ' || v_salario_actual ||' a ' || (v_salario_actual + p_importe));

END SUBIR_SALARIO_TRABAJADOR;

/
/************/
/* TRIGGERS */
/************/
CREATE OR REPLACE TRIGGER ins_numclases AFTER INSERT ON IMPARTIR
 FOR EACH ROW
 BEGIN
    UPDATE MONITOR
       SET numclases = numclases + 1
       WHERE :NEW.dnimon = MONITOR.dni;
 END;
 /
 CREATE OR REPLACE TRIGGER upd_numclases AFTER UPDATE ON IMPARTIR
 FOR EACH ROW
 BEGIN
    UPDATE MONITOR
       SET numclases = numclases - 1
       WHERE :OLD.dnimon = MONITOR.dni;
    UPDATE MONITOR
       SET numclases = numclases + 1
       WHERE :NEW.dnimon = MONITOR.dni;
 END;
 /
CREATE OR REPLACE TRIGGER del_numclases AFTER DELETE ON IMPARTIR
 FOR EACH ROW
 BEGIN
    UPDATE MONITOR
       SET numclases = numclases - 1
       WHERE :OLD.dnimon = MONITOR.dni;
 END;
 /
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







