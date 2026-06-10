SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER ins_numclases AFTER INSERT ON IMPARTIR
 FOR EACH ROW
 BEGIN
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
 
 