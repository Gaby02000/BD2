/* I) Crear la tabla "audit" con los siguientes atributos
Tabla (investigar si se puede crear una restricción para que solamente permita en
este campo un nombre de tabla que exista en la base de datos)
Tipo Operacion (crear una restricción para que solamente permita el siguiente
domino 'SELECT', 'INSERT', 'DELETE', 'UPDATE')
Usuario
Fecha/Hora */

CREATE FUNCTION tables_BD(nombre char) RETURNS boolean
AS $$
BEGIN

    RETURN (nombre IN(SELECT table_name FROM information_schema.tables where table_schema='public'));

END;
$$ LANGUAGE plpgsql;

CREATE TABLE audit (
	tabla tipoTabla,
	operacion tipoOperacion,
	fecha_hora timestamp,
	usuario char(50),
	constraint "chkTablaValida" CHECK (tables_bd(tabla)));

------------------------- CODIGO DE TESTEO -------------------------
SELECT * FROM audit
--DROP TABLE audit 

------------------------------------------------------------------------------------------------------------------------------
/* II) Crear los siguientes TRIGGERS
para INSERCION sobre Tabla avion que inserte en la tabla audit la operación
realizada
para ELIMINACION sobre Tabla avion que inserte en la tabla audit , la operación
realizada */

CREATE OR REPLACE FUNCTION fcAuditAvion() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO audit ("tabla","operacion","fecha_hora","usuario") VALUES ('avion', TG_OP, now(), USER);
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION fcAuditAvion()

CREATE TRIGGER auditInsertAvion AFTER INSERT ON avion FOR EACH ROW EXECUTE PROCEDURE fcAuditAvion()
--DROP TRIGGER auditInsertAvion ON avion


CREATE TRIGGER auditDeleteAvion AFTER DELETE ON avion FOR EACH ROW EXECUTE PROCEDURE fcAuditAvion()
--DROP TRIGGER auditDeleteAvion ON avion

------------------------- CODIGO DE TESTEO -------------------------
INSERT INTO avion VALUES (31000000, 10, 2002, 670)
SELECT * FROM audit
--DELETE FROM audit WHERE "operacion" = 'INSERT' 

DELETE FROM avion WHERE "nroAvion" = 31000000
SELECT * FROM audit
--DELETE FROM audit WHERE "operacion" = 'DELETE' 

------------------------------------------------------------------------------------------------------------------------------
/* III) Crear dos usuarios en la base de datos TP1-Aviones, denominados userA y userB */

CREATE USER "userA" WITH PASSWORD '321'
--DROP USER "userA"

CREATE USER "userB" WITH PASSWORD '123'
--DROP USER "userB"

------------------------------------------------------------------------------------------------------------------------------
/* V) Otorgar los siguientes permisos:
de seleccion al userA sobre todas las tablas y permisos de INSERT sobre la tabla
audit con la opción WITH GRANT OPTION
Otorgar permisos de seleccion, insert y update al userB sobre las siguientes tablas:
avion, piloto, pilotoAvion */

GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO "userA"
--REVOKE SELECT ON ALL TABLES IN SCHEMA PUBLIC FROM "userA" CASCADE
GRANT INSERT ON TABLE audit TO "userA" WITH GRANT OPTION
--REVOKE INSERT ON TABLE audit FROM "userA"

GRANT SELECT ON TABLE avion, piloto, "pilotoAvion" TO "userB"
--REVOKE SELECT ON TABLE avion, piloto, "pilotoAvion" FROM "userB" CASCADE

GRANT INSERT ON TABLE avion, piloto, "pilotoAvion" TO "userB"
--REVOKE INSERT ON TABLE avion, piloto, "pilotoAvion" FROM "userB" CASCADE

GRANT UPDATE ON TABLE avion, piloto, "pilotoAvion" TO "userB"
--REVOKE UPDATE ON TABLE avion, piloto, "pilotoAvion" FROM "userB" CASCADE

------------------------- CODIGO DE TESTEO -------------------------
---------------------------- Para userA ----------------------------
SELECT * FROM avion
SELECT * FROM "modeloAvion"
SELECT * FROM falla
SELECT * FROM localidad
SELECT * FROM piloto
SELECT * FROM "pilotoAvion"
SELECT * FROM trabajador
SELECT * FROM "trabajadorReparacion"
INSERT INTO audit VALUES ('avion', 'SELECT', now(), 'userB') 
GRANT INSERT ON TABLE audit TO "userB"
--REVOKE INSERT ON TABLE audit FROM "userB"

---------------------------- Para userB ----------------------------
SELECT * FROM avion
INSERT INTO avion VALUES (50000000, 10, 2002, 670)
--DELETE FROM avion WHERE "nroAvion" = 1006
UPDATE avion SET "horasVuelo" = 550 WHERE "nroAvion" = 1002 

SELECT * FROM piloto
INSERT INTO piloto VALUES (4, 200, 6000, '2003-04-17')
--DELETE FROM piloto WHERE "dniPiloto" = 4
UPDATE piloto SET "horasVuelo" = 8950  WHERE "dniPiloto" = 1

SELECT * FROM "pilotoAvion"
INSERT INTO "pilotoAvion" VALUES (1, 1003)
--DELETE FROM "pilotoAvion" WHERE "dniPiloto" = 1 AND "nroAvion" = 1003
UPDATE "pilotoAvion" SET "dniPiloto" = 2  WHERE "nroAvion" = 1003

------------------------------------------------------------------------------------------------------------------------------
/* VI) Conectarse con el usuario userB a la base de datos y hacer una inserción sobre la tabla
avion, documentar lo que arroja el motor. Si no fue posible solucionar el inconveniente
conectándose con el usuario userA */

INSERT INTO avion VALUES (52000000, 12, 2008, 650)
--DELETE FROM avion WHERE "nroAvion" = 21000000




