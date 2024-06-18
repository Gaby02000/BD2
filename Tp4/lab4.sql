/* II) Para distribuir en Fragmentos correspondientes a Pilotos de Trelew, Pilotos de Madryn,
Todos los pilotos
Para las tablas : piloto, trabajador, localidad, pilotoAvion, avion, modeloAvion
- Hacer esquema de fragmentación, Esquema de asignación
- Caracterizar el tipo y características de la fragmentación de cada fragmento, de cada
tabla y de la asignación */
-------------------------------------------------- LOCALIDAD DE MADRYN Y PILOTO DE MADRYN ---------------------------------------------------------
SELECT * FROM localidad
INSERT INTO localidad VALUES (9120, 'Puerto Madryn')

SELECT * FROM trabajador
INSERT INTO trabajador VALUES (7, 'Trabajador 7', 'Dir. 7', 9120, '7', 107)

SELECT * FROM piloto
INSERT INTO piloto VALUES (7, 300, 7000, '2002-03-03')

SELECT * FROM "pilotoAvion"
INSERT INTO "pilotoAvion" VALUES (7, 1004)


----------------------------------------------- CREACION DE FRAGMENTOS PARA PILOTOS DE TRELEW ----------------------------------------------------
-- Fragmento localidad Trelew
CREATE VIEW "fragTrelew" AS
SELECT * FROM localidad L WHERE L."idLocalidad" = 9100;

-- Fragmento trabajador Trelew
CREATE VIEW "fragTrabajadoresTrelew" AS
SELECT * FROM trabajador T WHERE T."idLocalidad" IN (SELECT "idLocalidad" FROM "fragTrelew");

-- Fragmento piloto Trelew
CREATE VIEW "fragPilotosTrelew" AS
SELECT * FROM piloto P WHERE P."dniPiloto" IN (SELECT dni FROM "fragTrabajadoresTrelew");

-- Fragmento pilotoAvion Trelew
CREATE VIEW "fragPilotosAvionesTrelew" AS
SELECT * FROM "pilotoAvion" PA WHERE PA."dniPiloto" IN (SELECT "dniPiloto" FROM "fragPilotosTrelew");

-- Fragmento avion Trelew
CREATE VIEW "fragAvionesTrelew" AS
SELECT * FROM avion A WHERE A."nroAvion" IN (SELECT "nroAvion" FROM "fragPilotosAvionesTrelew");

-- Fragmento modeloAvion Trelew
CREATE VIEW "fragModelosAvionesTrelew" AS
SELECT * FROM "modeloAvion" MA WHERE MA."tipoModelo" IN (SELECT "tipoModelo" FROM "fragAvionesTrelew");


-------------------------------------------- CREACION DE FRAGMENTOS PARA PILOTOS DE PUERTO MADRYN ------------------------------------------------
-- Fragmento localidad Puerto Madryn
CREATE VIEW "fragPuertoMadryn" AS
SELECT * FROM localidad L WHERE L."idLocalidad" = 9120;

-- Fragmento trabajador Puerto Madryn
CREATE VIEW "fragTrabajadoresPuertoMadryn" AS
SELECT * FROM trabajador T WHERE T."idLocalidad" IN (SELECT "idLocalidad" FROM "fragPuertoMadryn");

-- Fragmento piloto Puerto Madryn
CREATE VIEW "fragPilotosPuertoMadryn" AS
SELECT * FROM piloto P WHERE P."dniPiloto" IN (SELECT dni FROM "fragTrabajadoresPuertoMadryn");

-- Fragmento pilotoAvion Puerto Madryn
CREATE VIEW "fragPilotosAvionesPuertoMadryn" AS
SELECT * FROM "pilotoAvion" PA WHERE PA."dniPiloto" IN (SELECT "dniPiloto" FROM "fragPilotosPuertoMadryn");

-- Fragmento avion Puerto Madryn
CREATE VIEW "fragAvionesPuertoMadryn" AS
SELECT * FROM avion A WHERE A."nroAvion" IN (SELECT "nroAvion" FROM "fragPilotosAvionesPuertoMadryn");

-- Fragmento modeloAvion Puerto Madryn
CREATE VIEW "fragModelosAvionesPuertoMadryn" AS
SELECT * FROM "modeloAvion" MA WHERE MA."tipoModelo" IN (SELECT "tipoModelo" FROM "fragAvionesPuertoMadryn");


--------------------------------------- CREACION DE FRAGMENTOS PARA PILOTOS DE TODAS LAS LOCALIDADES ---------------------------------------------
-- Fragmento localidad
CREATE VIEW "fragLocalidades" AS
SELECT * FROM localidad;

-- Fragmento trabajador localidad
CREATE VIEW "fragTrabajadoresLocalidades" AS
SELECT * FROM trabajador T WHERE T."idLocalidad" IN (SELECT "idLocalidad" FROM "fragLocalidades");

-- Fragmento piloto localidad
CREATE VIEW "fragPilotosLocalidades" AS
SELECT * FROM piloto P WHERE P."dniPiloto" IN (SELECT dni FROM "fragTrabajadoresLocalidades");

-- Fragmento pilotoAvion localidades
CREATE VIEW "fragPilotosAvionesLocalidades" AS
SELECT * FROM "pilotoAvion" PA WHERE PA."dniPiloto" IN (SELECT "dniPiloto" FROM "fragPilotosLocalidades");

-- Fragmento avion localidades
CREATE VIEW "fragAvionesLocalidades" AS
SELECT * FROM avion A WHERE A."nroAvion" IN (SELECT "nroAvion" FROM "fragPilotosAvionesLocalidades");

-- Fragmento modeloAvion localidades
CREATE VIEW "fragModelosAvionesLocalidades" AS
SELECT * FROM "modeloAvion" MA WHERE MA."tipoModelo" IN (SELECT "tipoModelo" FROM "fragAvionesLocalidades");


---------------------------------------------------------- CODIGO DE TESTEO --------------------------------------------------------------------
-- Fragmentos correspondientes a localidad
SELECT * FROM "fragTrelew"
SELECT * FROM "fragPuertoMadryn"
SELECT * FROM "fragLocalidades"

-- Fragmentos correspondientes a trabajador
SELECT * FROM "fragTrabajadoresTrelew"
SELECT * FROM "fragTrabajadoresPuertoMadryn"
SELECT * FROM "fragTrabajadoresLocalidades"

-- Fragmentos correspondientes a piloto
SELECT * FROM "fragPilotosTrelew"
SELECT * FROM "fragPilotosPuertoMadryn"
SELECT * FROM "fragPilotosLocalidades"

-- Fragmentos correspondientes a pilotoAvion
SELECT * FROM "fragPilotosAvionesTrelew"
SELECT * FROM "fragPilotosAvionesPuertoMadryn"
SELECT * FROM "fragPilotosAvionesLocalidades"

-- Fragmentos correspondientes a avion
SELECT * FROM "fragAvionesTrelew"
SELECT * FROM "fragAvionesPuertoMadryn"
SELECT * FROM "fragAvionesLocalidades"

-- Fragmentos correspondientes a modeloAvion
SELECT * FROM "fragModelosAvionesTrelew"
SELECT * FROM "fragModelosAvionesPuertoMadryn"
SELECT * FROM "fragModelosAvionesLocalidades"


-----------------------------------------------------------------------------------------------------------------------------------------------
/* 5) Con el módulo dbLink de Postgres establecer una conexión entre dos servidores (si es 
posible, entre dos máquinas virtuales, caso contrario entre dos bases de datos del mismo 
servidor) para lograr lo siguiente 
- Crear una tabla “alumnos” en el servidor local con las siguientes columnas dni, nombre 
  (PK dni) 
- Crear una tabla “cursos” en el servidor remoto con las columnas idCurso, nombre, idProfesor, 
  departamento (PK idCurso) 
- Crear una tabla “inscriptos” en el servidor local con las siguientes columnas dniAlumno, 
  idCurso, año, nota (PK dniAlumno, idCurso, año FK dniAlumno) 

- Hacer varios insert en la tabla local alumnos 
- Hacer varios insert en la tabla remota cursos 
- Hacer varios insert en la tabla local inscriptos teniendo en cuenta que algunos idCurso sean 
  existentes en la tabla remota cursos y otros no 

- Hacer una consulta de los cursos que tengan algun inscripto 
- Hacer una consulta de los alumnos que hayan recursado al menos una vez una materia 
- Hacer una función que cree un cursor sobre toda la tabla local “inscriptos” y lo recorra, y 
  por cada tupla verifique, si existe el alumno y si existe el curso y muestre: nombre del 
  alumno, nombre del curso (o INEXISTENTE si no existe), año y nota*/

----------------------------------- CREAMOS LAS BASES DE DATOS LOCAL Y REMOTA (USUARIO: POSTGRES) -------------------------------------------
--------------------------------------------------------------- LOCAL -----------------------------------------------------------------------
CREATE DATABASE dblocal
--DROP DATABASE dblocal

--Conectados desde la bases de datos local
CREATE TABLE alumnos (
	dni integer,
	nombre varchar(50),
	CONSTRAINT pk_alumno PRIMARY KEY (dni)
);

--SELECT * FROM alumnos
--DROP TABLE alumnos

CREATE TABLE inscriptos (
	"dniAlumno" integer,
	"idCurso" integer,
	anio integer,
	nota integer,
	CONSTRAINT "pkInscriptos" PRIMARY KEY ("dniAlumno", "idCurso", anio),
	CONSTRAINT "fkAlumno" FOREIGN KEY ("dniAlumno")
		REFERENCES alumnos (dni)
);

--SELECT * FROM inscriptos
--DROP TABLE inscriptos

--------------------------------------------------------------- REMOTA ----------------------------------------------------------------------
CREATE DATABASE dbremota 
--DROP DATABASE dbremota

--Conectados desde la bases de datos remota
CREATE TABLE cursos (
	"idCurso" integer,
	nombre varchar(50),
	"idProfesor" integer,
	departamento varchar(50),
	CONSTRAINT "pkCursos" PRIMARY KEY ("idCurso")
);

--SELECT * FROM cursos
--DROP TABLE cursos


--------------------- CREAMOS LOS USUARIOS CORRESPONDIENTES A LAS BASES DE DATOS LOCAL Y REMOTA (USUARIO: POSTGRES) -------------------------
--------------------------------------------------------------- LOCAL -----------------------------------------------------------------------
CREATE USER userdblocal WITH PASSWORD '123';
--DROP USER userdblocal
GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC TO userdblocal;
--REVOKE SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC FROM userdblocal

--Conectados desde la base de datos remota
GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC TO userdblocal;
--REVOKE SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC FROM userdblocal

-------------------------------------------------------------- REMOTA -----------------------------------------------------------------------
CREATE USER userdbremota WITH PASSWORD '321';
--DROP USER userdbremota
GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC TO userdbremota;
--REVOKE SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC FROM userdbremota

--Conectados desde la base de datos local
GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA PUBLIC TO userdbremota;
--REVOKE SELECT, INSERT, DELETE ON ALL TABLESA IN SCHEMA PUBLIC FROM userdbremota

------------------------------------------------------------ MODULO DBLINK -----------------------------------------------------------------
--------------------------------------------- EN LA BASE DE DATOS LOCAL (USUARIO: USERDBLOCAL) ---------------------------------------------
--La extension dblink necesita ser creada con el usuario postgres
CREATE EXTENSION dblink;
--DROP EXTENSION dblink;

SELECT dblink_connect('remota', 'dbname=dbremota user=userdblocal password=123')

SELECT * FROM alumnos
SELECT * FROM inscriptos

SELECT * 
FROM dblink('remota','SELECT * FROM cursos') 
AS t("idCurso" int, nombre varchar(50), "idProfesor" int, departamento varchar(50))

SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (1, ''Curso 1'', 1, ''Depto 1'')');
SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (2, ''Curso 2'', 1, ''Depto 1'')');
SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (3, ''Curso 3'', 2, ''Depto 1'')');
SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (4, ''Curso 4'', 3, ''Depto 2'')');
SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (5, ''Curso 5'', 3, ''Depto 2'')');
--SELECT dblink_exec('remota', 'INSERT INTO cursos VALUES (9, ''Curso 9'', 2, ''Depto 3'')');
--SELECT dblink_exec('remota', 'DELETE FROM cursos WHERE "idCurso" = 9');

-- Consulta cursos que tienen algun inscripto
SELECT * FROM dblink('remota', 'SELECT * FROM cursos') 
AS C("idCurso" int, nombre varchar(50), "idProfesor" int, departamento varchar(50))
WHERE C."idCurso" IN (SELECT "idCurso" FROM inscriptos);

-- Consulta alumnos que recursaron al menos una vez una materia
SELECT A.dni, A.nombre, I."idCurso", C."nombreCurso" FROM inscriptos I
JOIN alumnos A ON A.dni = I."dniAlumno"
JOIN (SELECT * 
      FROM dblink('remota', 'SELECT "idCurso", nombre FROM cursos') 
      AS C(id int, "nombreCurso" varchar)) AS C ON C.id = I."idCurso"
GROUP BY A.dni, A.nombre, I."idCurso", C."nombreCurso"
HAVING COUNT(*) > 1;

-- Funcion que verifica la existencia de alumnos y cursos en las inscripciones
CREATE OR REPLACE FUNCTION fcVerificarInscripciones() RETURNS VOID AS $$
DECLARE
    rec record;
    nombre_alumno varchar;
    nombre_curso varchar;
BEGIN
    FOR rec IN (SELECT * FROM inscriptos) LOOP
        SELECT nombre INTO nombre_alumno FROM alumnos WHERE dni = rec."dniAlumno";
        
        SELECT "nombreCurso" INTO nombre_curso 
	FROM (SELECT * 
	      FROM dblink('remota', 'SELECT "idCurso", nombre FROM cursos') 
	      AS C(id int, "nombreCurso" varchar)) AS C WHERE C.id = rec."idCurso";
        
        IF nombre_curso IS NULL THEN
            nombre_curso := 'INEXISTENTE';
        END IF;
        
        RAISE NOTICE 'Alumno: %, Curso: %, Año: %, Nota: %', 
			nombre_alumno, 
			nombre_curso, 
			rec.anio, 
			rec.nota;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT fcVerificarInscripciones()

--SELECT dblink_disconnect('remota')

------------------------------------------- EN LA BASE DE DATOS REMOTA (USUARIO: USERDBREMOTA) ---------------------------------------------
--La extension dblink necesita ser creada con el usuario postgres
CREATE EXTENSION dblink;
--DROP EXTENSION dblink;

SELECT dblink_connect('local', 'dbname=dblocal user=userdbremota password=321')

SELECT * FROM cursos

SELECT * FROM dblink('local','SELECT * FROM alumnos') AS t(dni int, nombre varchar(50))
SELECT * FROM dblink('local','SELECT * FROM inscriptos') AS t("dniAlumno" int, "idCurso" int, anio int, nota int)

SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (1,''Roman'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (2,''Analia'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (3,''Karina'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (4,''Marcos'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (5,''Jazmin'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (6,''Juan'')');
SELECT dblink_exec('local', 'INSERT INTO alumnos (dni,nombre) VALUES (7,''Antonio'')');

SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (1, 1, 2019, 7)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (1, 2, 2019, 5)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (1, 6, 2019, 8)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (2, 1, 2018, 8)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (3, 2, 2018, 9)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (4, 5, 2018, 4)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (4, 5, 2019, 7)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (5, 3, 2018, 5)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (5, 3, 2019, 9)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (6, 4, 2017, 4)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (6, 4, 2018, 8)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (7, 6, 2018, 8)');
SELECT dblink_exec('local', 'INSERT INTO inscriptos ("dniAlumno", "idCurso", anio, nota) VALUES (7, 7, 2018, 6)');

-- Consulta cursos que tienen algun inscripto
SELECT * FROM cursos
WHERE "idCurso" IN (SELECT * 
		    FROM dblink('local', 'SELECT "idCurso" FROM inscriptos')
		    AS I("idCurso" int));

-- Consulta alumnos que recursaron al menos una vez una materia
SELECT AI.dni, AI.nombre, AI."idCurso", C.nombre AS "nombreCurso" FROM cursos C
JOIN (SELECT * 
      FROM dblink('local','SELECT A.dni, A.nombre, I."idCurso" 
			   FROM inscriptos I
			   JOIN alumnos A ON A.dni = I."dniAlumno"
			   GROUP BY A.dni, A.nombre, I."idCurso"
			   HAVING COUNT(*) > 1') AS AI(dni int, nombre varchar, "idCurso" int)) 
      AS AI ON AI."idCurso" = C."idCurso";		   

--SELECT dblink_disconnect('local')