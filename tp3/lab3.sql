/* I)Crear un tipo Aeropuertos que almacene las siguientes propiedades: nombre del
aeropuerto, ubicación (ciudad, provincia, país), medidas de la pista (longitud, ancho, tipo de
compuesto) y una colección de las aerolíneas que trabajan en el mismo. */
CREATE TYPE tAerolinea as (
	nombre char(50)
);
--DROP TYPE tAerolinea

CREATE TYPE tMedida as (
	longitud float,
	ancho float,
	tipoCompuesto varchar(30)
);
--DROP TYPE tMedida

CREATE TYPE tUbicacion as (
	ciudad char(30),
	provincia char(30),
	pais char(30)
);
--DROP TYPE tUbicacion

CREATE TYPE tAeropuerto as (
	nombre char(60),
	ubicacion tUbicacion,
	medida tMedida,
	aerolineas tAerolinea[]
);
--DROP TYPE tAeropuerto

------------------------------------------------------------------------------------------------------
/* II)Crear una tabla aeropuertos basada en el tipo creado en el punto 1. Hacer varios INSERT
(y documentarlos) para poblar la tabla aeropuertos con datos. */
CREATE TABLE aeropuerto of tAeropuerto;
--DROP TABLE aeropuerto

--------------------------------- CODIGO DE PREUBA ---------------------------------
SELECT * FROM aeropuerto

INSERT INTO aeropuerto (
    nombre, 
    ubicacion, 
    medida, 
    aerolineas
) VALUES (
    'Aeropuerto 1',
    ( 'Ciudad 1', 'Provincia 1', 'Pais 1' ),
    ( 4000.0, 60.0, 'Hormigon' ),
    ARRAY[
        (ROW('Aerolínea 1')::tAerolinea),
        (ROW('Aerolínea 2')::tAerolinea)
    ]
);
--DELETE FROM aeropuerto WHERE nombre = 'Aeropuerto 1'

INSERT INTO aeropuerto (
    nombre, 
    ubicacion, 
    medida, 
    aerolineas
) VALUES (
    'Aeropuerto 2',
    ( 'Ciudad 2', 'Provincia 2', 'Pais 2' ),
    ( 5000.0, 70.0, 'Asfalto' ),
    ARRAY[
        (ROW('Aerolínea 1')::tAerolinea),
        (ROW('Aerolínea 3')::tAerolinea)
    ]
);
--DELETE FROM aeropuerto WHERE nombre = 'Aeropuerto 2'

------------------------------------------------------------------------------------------------------
/* III)Crear una subtabla aeropuertosHangares de aeropuertos que refleje aquellos aeropuertos
en los que se alquilan hangares que agregue la siguiente información: precioEspacio y una
coleccion de espacios que registre para cada elemento el nro. de parcela, ocupado (si/no) y
una referencia a un avion (objeto de la tabla homónima, deberán considerarse los pasos
para tratar a los aviones como objetos OID)
Hacer varios INSERT (y documentarlos) para poblar la tabla aeropuertosHangares con datos. */
CREATE TRIGGER tgEsNroAvion BEFORE INSERT OR UPDATE ON aeropuertoHangar 
FOR EACH ROW EXECUTE PROCEDURE "fcCheckNroAvionAeropuertosHangares"();
--DROP TRIGGER tgEsNroAvion 

CREATE OR REPLACE FUNCTION "fcCheckNroAvionAeropuertosHangares"()
RETURNS TRIGGER AS $$
DECLARE
    espacio tEspacio;
BEGIN
    FOREACH espacio IN ARRAY NEW.espacios LOOP
       IF NOT EXISTS (SELECT 1 FROM avion WHERE "nroAvion" = espacio.nro_avion) THEN
	    RAISE NOTICE 'Error: el avion de la parcela no existe';
            RETURN NULL;
        END IF;
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE tEspacio AS (
	nroParcela int,
	ocupada boolean,
	nro_avion int
);
--DROP TYPE tEspacio

CREATE TABLE aeropuertoHangar (
	precioEspacio float,
	espacios tEspacio []
)INHERITS (aeropuerto);
--DROP TABLE aeropuertoHangar

--------------------------------- CODIGO DE PREUBA ---------------------------------
SELECT * FROM aeropuertoHangar

INSERT INTO aeropuertoHangar (
    nombre, 
    ubicacion, 
    medida, 
    aerolineas,
    precioEspacio,
    espacios
) VALUES (
    'Aeropuerto 1',
    ( 'Ciudad 1', 'Provincia 1', 'Pais 1' ),
    ( 4000.0, 60.0, 'Hormigon' ),
    ARRAY[
        (ROW('Aerolínea 1')::tAerolinea),
        (ROW('Aerolínea 2')::tAerolinea)
    ],
    27000,
    ARRAY[
        (ROW(1, TRUE, 1000)::tEspacio),
        (ROW(2, FALSE, 1001)::tEspacio)
    ]
);
--DELETE FROM aeropuertoHangar WHERE nombre = 'Aeropuerto 1'

INSERT INTO aeropuertoHangar ( 
    nombre, 
    ubicacion, 
    medida, 
    aerolineas,
    precioEspacio,
    espacios
) VALUES (
    'Aeropuerto 2',
    ( 'Ciudad 2', 'Provincia 2', 'Pais 2' ),
    ( 5000.0, 70.0, 'Asfalto' ),
    ARRAY[
        (ROW('Aerolínea 1')::tAerolinea),
        (ROW('Aerolínea 3')::tAerolinea)
    ],
    4700000,
    ARRAY[
        (ROW(1, TRUE, 1000)::tEspacio),
        (ROW(3, TRUE, 1002)::tEspacio)
    ]
);
--DELETE FROM aeropuertoHangar WHERE nombre = 'Aeropuerto 2'

INSERT INTO aeropuertoHangar ( 
    nombre, 
    ubicacion, 
    medida, 
    aerolineas,
    precioEspacio,
    espacios
) VALUES (
    'Aeropuerto 3',
    ( 'Ciudad 2', 'Provincia 2', 'Pais 2' ),
    ( 5000.0, 70.0, 'Asfalto' ),
    ARRAY[
        (ROW('Aerolínea 1')::tAerolinea),
        (ROW('Aerolínea 3')::tAerolinea)
    ],
    4700000,
    ARRAY[
	--Aca poner un nroAvion que no exista para probar el trigger
        (ROW(1, TRUE, 1000)::tEspacio),
        (ROW(3, TRUE, 1007)::tEspacio)  
    ]
);
--DELETE FROM aeropuertoHangar WHERE nombre = 'Aeropuerto 3'
------------------------------------------------------------------------------------------------------
/* IV)Resolver las siguientes consultas
a. Mostrar todos los aeropuertos que trabajan con la aerolínea X (elegir un
valor de X de acuerdo a los datos existentes en la tabla aeropuertos) (uso
del ANY)
b. Mostrar todos los aeropuertos de los cuales se tiene alquilados hangares y
que estén ocupados todas las parcelas (uso del ALL) en la consulta deben
aparecer los nros. de avion y descripción del modelo de avion que estén
ocupando cada parcela. */

-- a)
SELECT nombre, aerolineas
FROM aeropuerto
WHERE 'Aerolínea 2' = ANY (SELECT nombre FROM unnest(aerolineas));

-- b)
SELECT AH.nombre, 
       AH.parcela, 
       AH.ocupada, 
       AV."nroAvion", 
       MA.descripcion 
FROM  (SELECT nombre, 
	     (unnest(espacios)).nroParcela AS parcela, 
	     (unnest(espacios)).ocupada AS ocupada,
	     (unnest(espacios)).nro_avion
       FROM aeropuertoHangar
       WHERE 't' = ALL(SELECT ocupada 
		       FROM unnest(espacios))
       )AS AH, avion AS AV, "modeloAvion" AS MA
WHERE AH.nro_avion = AV."nroAvion" AND AV."tipoModelo" = MA."tipoModelo";

------------------------------------------------------------------------------------------------------
/* VI)Escribir una consulta y documentar el resultado para mostrar en una tabla en 1ra Forma
Normal el contenido de la tabla aeropuertosHangares. Verificar que las columnas tengan
nombre significativo. */ 
SELECT a.nombre AS "Aeropuerto",
       (a.ubicacion).ciudad AS "Ciudad",
       (a.ubicacion).provincia AS "Provincia", 
       (a.ubicacion).pais AS "País", 
       (a.medida).longitud AS "Longitud de Pista", 
       (a.medida).ancho AS "Ancho de Pista", 
       (a.medida).tipoCompuesto AS "Tipo Compuesto de Pista",
       (unnest(a.aerolineas)).nombre AS "Aerolinea",
       a.precioEspacio AS "Precio de Hangar",
       (unnest(espacios)).nroParcela AS "N° de Parcela",
       (unnest(espacios)).ocupada AS "Parcela Ocupada",
       (unnest(espacios)).nro_avion AS "Avion"
FROM aeropuertoHangar AS a;

------------------------------------------------------------------------------------------------------
/* VII)Escribir una consulta para mostrar los nombres de los trabajadores y un arreglo de todos
los aviones que repararon mostrando nro de avión y descripción del modelo, basándose en
un JOIN entre las tablas avión, modeloAvion y trabajador. */
SELECT T.nombre, ARRAY_AGG('('|| AV."nroAvion" || ',' || MA.descripcion || ')') aviones_reparados
FROM trabajador AS T
INNER JOIN "trabajadorReparacion" AS TR ON TR."dniTrabajador" = T.dni 
INNER JOIN avion AS AV ON AV."nroAvion" = TR."nroAvion"
INNER JOIN "modeloAvion" AS MA ON MA."tipoModelo" = AV."tipoModelo"
GROUP BY T.nombre;
