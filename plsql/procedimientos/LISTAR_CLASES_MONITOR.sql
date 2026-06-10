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

