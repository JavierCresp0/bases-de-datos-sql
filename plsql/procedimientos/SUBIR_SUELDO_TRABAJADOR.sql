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

