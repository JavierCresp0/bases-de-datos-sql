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
