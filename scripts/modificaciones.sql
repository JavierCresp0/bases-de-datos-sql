ALTER TABLE MONITOR ADD (numclases INTEGER DEFAULT 0);

ALTER TABLE PISTA ADD CONSTRAINT pista_estado_ch CHECK (estado IN ('Disponible', 'Ocupada'));


ALTER TABLE TIENE DROP CONSTRAINT tie_numabonado_coddesc_pk;
ALTER TABLE TIENE ADD CONSTRAINT tie_num_cod_cif_pk PRIMARY KEY (numabonado, ciftien, coddescuento);