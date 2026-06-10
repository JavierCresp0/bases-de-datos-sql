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

--Ejemplo
--SELECT TOTAL_GASTO_SALARIOS() FROM DUAL;
