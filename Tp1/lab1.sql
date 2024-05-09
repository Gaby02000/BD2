-- language: PL/pgSQL
CREATE OR REPLACE FUNCTION cargaMasiva(cantModelos integer, cantAviones integer) RETURNS void AS
DECLARE 
	vTipoModelo int; 
	vDescripcion char(50); 
	vCapacidad int; 
	vNroAvion int; 
	vModeloActual int; 
	vAño int; vHorasVuelo int;
	vDniTrabajador int; 
	vFechaInicioReparacion date; 
	vFechaFinReparacion date; 
	vTipoFallaReparada int;
	vNumModelo int;
	i int; 
	j int;
BEGIN
	vNumModelo := (SELECT MAX("tipoModelo") FROM "modeloAvion") + 1;
	vCapacidad := (SELECT MAX(capacidad) FROM "modeloAvion");
	IF vCapacidad IS NULL THEN
    	vCapacidad := 0;
	END IF;

	FOR i IN 1 .. cantModelos LOOP
		vCapacidad:=vCapacidad +1;
		vTipoModelo := (SELECT MAX("tipoModelo") FROM "modeloAvion")+1;
		vDescripcion := 'Modelo '||vNumModelo;
		INSERT INTO "modeloAvion" VALUES (vTipoModelo, vDescripcion, vCapacidad);	
		FOR j IN  1 .. cantAviones LOOP
			vNroAvion := (SELECT MAX("nroAvion") FROM avion)+1;
			vModeloActual := vTipoModelo;
			vAño := floor((random() * 24 + 1)+2000);
			vHorasVuelo := floor((random() * 5950 + 1)+50);
			INSERT INTO avion VALUES (vNroAvion, vModeloActual, vAño, vHorasVuelo);
			
			vDniTrabajador := (SELECT dni FROM trabajador ORDER BY random() LIMIT 1);
			vFechaInicioReparacion := random() * (timestamp '2024-04-01' - timestamp '2000-01-01') + timestamp '2000-01-01';
			vFechaFinReparacion := random() * (timestamp '2024-04-01' - vFechaInicioReparacion) + vFechaInicioReparacion;
			vTipoFallaReparada := (SELECT "tipoFalla" FROM falla ORDER BY random() LIMIT 1);
			INSERT INTO "trabajadorReparacion" VALUES (vDniTrabajador, vNroAvion, vFechaInicioReparacion, vFechaFinReparacion, vTipoFallaReparada);
		
	END LOOP;
		vNumModelo:=vNumModelo+1;
	END LOOP;
END

