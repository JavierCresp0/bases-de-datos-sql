CONNECT system/bdadmin;
CREATE USER p4 IDENTIFIED BY p4;
GRANT connect, resource TO p4;
connect p4/p4;

CREATE TABLE SALA
(
 codigo VARCHAR2(30),
 ubicacion VARCHAR2(30),
 tipo VARCHAR2(25),
 metros NUMBER (3),
 CONSTRAINT sala_cod_pk PRIMARY KEY(codigo) 
);

CREATE TABLE CLASES
(
 codigo VARCHAR2(30),
 fecha DATE,
 descripcion VARCHAR2(35),
 CONSTRAINT clases_cod_pk PRIMARY KEY(codigo)
);

CREATE TABLE PISTA 
(
 codigo VARCHAR2(10), 
 estado VARCHAR2(25),
 CONSTRAINT pista_cod_pk PRIMARY KEY(codigo) 
);

CREATE TABLE ABONADO
(
 numabonado VARCHAR2(10),
 direccion VARCHAR2(30),
 telefono VARCHAR2(30),
 nombre VARCHAR2(25),
 apellido VARCHAR2(25),
 fechanac DATE,
 dni VARCHAR2(10) CONSTRAINT abonado_dni_nn NOT NULL,
 CONSTRAINT abonado_numabonado_pk PRIMARY KEY(numabonado),
 CONSTRAINT abonado_dni_uq UNIQUE(dni)
);

CREATE TABLE TRABAJADOR
(
 dni VARCHAR2(10),
 nombre VARCHAR2(25),
 salario NUMBER(4),
 telefono VARCHAR2(30),
 CONSTRAINT trabaj_dni_pk PRIMARY KEY(dni)
);

CREATE TABLE ASISTIR
(
 numabonado VARCHAR2(10),
 codigoclase VARCHAR2(30),
 fechayhora TIMESTAMP,
 CONSTRAINT asis_dyh_codclas_numab_pk PRIMARY KEY(fechayhora, codigoclase, numabonado),
 CONSTRAINT asis_numabonado_fk FOREIGN KEY (numabonado) REFERENCES ABONADO,
 CONSTRAINT asis_codigoclase_fk FOREIGN KEY (codigoclase) REFERENCES CLASES
);

CREATE TABLE RESERVA
(
 numabonado VARCHAR2(10) CONSTRAINT reserva_numabonado_nn NOT NULL,
 codigopista VARCHAR2(30),
 fechayhora TIMESTAMP,
 CONSTRAINT reserva_diayhora_codpista_pk PRIMARY KEY(fechayhora, codigopista),
 CONSTRAINT reserva_numabonado_fk FOREIGN KEY (numabonado) REFERENCES ABONADO,
 CONSTRAINT reserva_codigopista_fk FOREIGN KEY (codigopista) REFERENCES PISTA
);

CREATE TABLE TIENDA
(
 cif VARCHAR2(10),
 nombre VARCHAR2(25),
 telefono VARCHAR2(30),
 CONSTRAINT tienda_cif_pk PRIMARY KEY(cif)
);

CREATE TABLE MONITOR
(
 dni VARCHAR2(10),
 tipo VARCHAR2(20),
 titulacion VARCHAR2(20),
 CONSTRAINT monitor_dni_pk PRIMARY KEY(dni),
 CONSTRAINT monitor_dni_fk FOREIGN KEY (dni) REFERENCES TRABAJADOR
);

CREATE TABLE VENDEDOR
(
 dni VARCHAR2(10),
 numventas NUMBER(3),
 ciftien VARCHAR2(10),
 CONSTRAINT vendedor_dni_pk PRIMARY KEY(dni),
 CONSTRAINT vendedor_dni_fk FOREIGN KEY (dni) REFERENCES TRABAJADOR,
 CONSTRAINT vendedor_ciftien_fk FOREIGN KEY (ciftien) REFERENCES TIENDA
);
CREATE TABLE DESCUENTO
(
 cif VARCHAR2(10),
 codigo VARCHAR2(30),
 descripcion VARCHAR2(30),
 vigenciadescuento DATE,
 CONSTRAINT descuento_diayhora_cif_pk PRIMARY KEY(codigo, cif),
 CONSTRAINT descuento_cif_fk FOREIGN KEY (cif) REFERENCES TIENDA
);

CREATE TABLE TIENE
(
 numabonado VARCHAR2(10),
 coddescuento VARCHAR2(30),
 descuentoutilizado VARCHAR2(10),
 ciftien VARCHAR2(10),
 CONSTRAINT tie_numabonado_coddesc_pk PRIMARY KEY(numabonado, coddescuento),
 CONSTRAINT tiene_numabonado_fk FOREIGN KEY (numabonado) REFERENCES ABONADO,
 CONSTRAINT tie_coddescuento_ciftien_fk FOREIGN KEY (coddescuento, ciftien) REFERENCES DESCUENTO 
);

CREATE TABLE IMPARTIR
(
 codigosala VARCHAR2(30),
 codigoclase VARCHAR2(30),
 fechayhora TIMESTAMP,
 dnimon VARCHAR2(10) CONSTRAINT impartir_dnimon_nn NOT NULL,
 CONSTRAINT imp_codsala_codclase_dyh_pk PRIMARY KEY(codigosala, codigoclase,fechayhora),
 CONSTRAINT imp_dnimon_fk FOREIGN KEY (dnimon) REFERENCES MONITOR,
 CONSTRAINT imp_codigoclase_fk FOREIGN KEY (codigoclase) REFERENCES CLASES,
 CONSTRAINT imp_codigosala_fk FOREIGN KEY (codigosala) REFERENCES SALA
);






ALTER TABLE SALA MODIFY(metros DEFAULT 0
			CONSTRAINT sal_met_ch CHECK (metros >=50));

ALTER TABLE TRABAJADOR MODIFY(salario DEFAULT 0
			CONSTRAINT tra_sal_ch CHECK (salario >=800));

ALTER TABLE ABONADO MODIFY(CONSTRAINT abo_tel_ch CHECK (telefono < 1000000000));

/******************/
/* MODIFICACIONES */
/******************/
ALTER TABLE MONITOR ADD (numclases INTEGER DEFAULT 0);

ALTER TABLE PISTA ADD CONSTRAINT pista_estado_ch CHECK (estado IN ('Disponible', 'Ocupada'));


ALTER TABLE TIENE DROP CONSTRAINT tie_numabonado_coddesc_pk;
ALTER TABLE TIENE ADD CONSTRAINT tie_num_cod_cif_pk PRIMARY KEY (numabonado, ciftien, coddescuento);
