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


-- Ejemplo de uso:
--SELECT TOTAL_RESERVAS_PISTA('Pista1') FROM DUAL;