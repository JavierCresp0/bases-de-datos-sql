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

-- Ejemplo de uso
SET SERVEROUTPUT ON
SELECT PISTAS_RESERVA_FECHA(DATE '2022-01-20') FROM DUAL;
