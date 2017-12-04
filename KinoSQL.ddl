-- Generated by Oracle SQL Developer Data Modeler 17.3.0.261.1541
--   at:        2017-12-04 16:26:46 CET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



CREATE TABLE bilet (
    data_godzina_zakupu             DATE NOT NULL,
    id                              INTEGER NOT NULL,
    pracownik_id                    INTEGER NOT NULL,
    miejscenaseansie_id2            INTEGER NOT NULL,
    rezerwacja_id                   INTEGER,
    produktnaparagonie_paragon_id   INTEGER NOT NULL,
    produktnaparagonie_lp           INTEGER NOT NULL,
    miejscenaseansie_data_godzina   DATE NOT NULL,
    miejscenaseansie_rząd           CHAR(2) NOT NULL,
    miejscenaseansie_nr_miejsca     INTEGER NOT NULL,
    miejscenaseansie_nr_sali        INTEGER NOT NULL
);

CREATE UNIQUE INDEX bilet__idx ON
    bilet ( produktnaparagonie_paragon_id ASC,
    produktnaparagonie_lp ASC );

CREATE UNIQUE INDEX bilet__idxv1 ON
    bilet (
        miejscenaseansie_id2
    ASC,
        miejscenaseansie_data_godzina
    ASC,
        miejscenaseansie_rząd
    ASC,
        miejscenaseansie_nr_miejsca
    ASC,
        miejscenaseansie_nr_sali
    ASC );

ALTER TABLE bilet ADD CONSTRAINT bilet_pk PRIMARY KEY ( id );

CREATE TABLE film (
    id                  INTEGER NOT NULL,
    tytuł               VARCHAR2(50) NOT NULL,
    czas_trwania        INTEGER NOT NULL,
    gatunek             VARCHAR2(20) NOT NULL,
    kategoria_wiekowa   VARCHAR2(20) NOT NULL,
    opis                CLOB,
    reżyseria           CLOB,
    scenariusz          CLOB,
    zdjęcia             CLOB,
    występują           CLOB
);

ALTER TABLE film ADD CONSTRAINT film_pk PRIMARY KEY ( id );

CREATE TABLE klient (
    imie       VARCHAR2(50) NOT NULL,
    nazwisko   VARCHAR2(50) NOT NULL,
    mail   VARCHAR2(50) NOT NULL,
    login      VARCHAR2(20) NOT NULL,
    hasło      VARCHAR2(50) NOT NULL,
    telefon    VARCHAR2(9) NOT NULL
);

ALTER TABLE klient ADD CONSTRAINT klient_pk PRIMARY KEY ( login );

CREATE TABLE miejsce (
    rząd           CHAR(2) NOT NULL,
    nr_miejsca     INTEGER NOT NULL,
    sala_nr_sali   INTEGER NOT NULL
);

ALTER TABLE miejsce
    ADD CONSTRAINT miejsce_pk PRIMARY KEY ( rząd,
    nr_miejsca,
    sala_nr_sali );

CREATE TABLE miejscenaseansie (
    rezerwacja_id          INTEGER,
    seans_id               INTEGER NOT NULL,
    bilet_id               INTEGER,
    seans_data_godzina     DATE NOT NULL,
    miejsce_rząd           CHAR(2) NOT NULL,
    miejsce_nr_miejsca     INTEGER NOT NULL,
    miejsce_sala_nr_sali   INTEGER NOT NULL
);

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT arc_1 CHECK (
        (
            ( bilet_id IS NOT NULL )
            AND ( rezerwacja_id IS NULL )
        )
        OR (
            ( rezerwacja_id IS NOT NULL )
            AND ( bilet_id IS NULL )
        )
    );

CREATE UNIQUE INDEX miejscenaseansie__idx ON
    miejscenaseansie ( bilet_id ASC );

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT miejscenaseansie_pk PRIMARY KEY ( seans_id,
    seans_data_godzina,
    miejsce_rząd,
    miejsce_nr_miejsca,
    miejsce_sala_nr_sali );

CREATE TABLE paragon (
    id             INTEGER NOT NULL,
    data_godzina   DATE
);

ALTER TABLE paragon ADD CONSTRAINT paragon_pk PRIMARY KEY ( id );

CREATE TABLE pracownik (
    imie       VARCHAR2(50) NOT NULL,
    nazwisko   VARCHAR2(50) NOT NULL,
    id         INTEGER NOT NULL,
    płeć       CHAR(1)
);

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( id );

CREATE TABLE produkt (
    cena             NUMBER,
    nazwa            VARCHAR2(50),
    id               INTEGER NOT NULL,
    rozmiar_porcji   VARCHAR2(1)
);

ALTER TABLE produkt ADD CONSTRAINT produkt_pk PRIMARY KEY ( id );

CREATE TABLE produktnaparagonie (
    paragon_id   INTEGER NOT NULL,
    produkt_id   INTEGER,
    bilet_id     INTEGER,
    lp           INTEGER NOT NULL
);

ALTER TABLE produktnaparagonie
    ADD CONSTRAINT arc_2 CHECK (
        (
            ( produkt_id IS NOT NULL )
            AND ( bilet_id IS NULL )
        )
        OR (
            ( bilet_id IS NOT NULL )
            AND ( produkt_id IS NULL )
        )
    );

CREATE UNIQUE INDEX produktnaparagonie__idx ON
    produktnaparagonie ( bilet_id ASC );

ALTER TABLE produktnaparagonie ADD CONSTRAINT produktnaparagonie_pk PRIMARY KEY ( paragon_id,
lp );

CREATE TABLE rezerwacja (
    data_godzina   DATE NOT NULL,
    id             INTEGER NOT NULL,
    klient_login   VARCHAR2(20) NOT NULL,
    czy_oplacona   CHAR(1) NOT NULL
);

ALTER TABLE rezerwacja ADD CONSTRAINT rezerwacja_pk PRIMARY KEY ( id );

CREATE TABLE rodzajbiletu (
    cena   NUMBER NOT NULL,
    typ    CHAR(1)
);

CREATE TABLE sala (
    nr_sali   INTEGER NOT NULL
);

ALTER TABLE sala ADD CONSTRAINT sala_pk PRIMARY KEY ( nr_sali );

CREATE TABLE seans (
    data_godzina   DATE NOT NULL,
    film_id        INTEGER NOT NULL
);

ALTER TABLE seans ADD CONSTRAINT seans_pk PRIMARY KEY ( film_id,
data_godzina );

ALTER TABLE bilet
    ADD CONSTRAINT bilet_miejscenaseansie_fk FOREIGN KEY ( miejscenaseansie_id2,
    miejscenaseansie_data_godzina,
    miejscenaseansie_rząd,
    miejscenaseansie_nr_miejsca,
    miejscenaseansie_nr_sali )
        REFERENCES miejscenaseansie ( seans_id,
        seans_data_godzina,
        miejsce_rząd,
        miejsce_nr_miejsca,
        miejsce_sala_nr_sali );

ALTER TABLE bilet
    ADD CONSTRAINT bilet_pracownik_fk FOREIGN KEY ( pracownik_id )
        REFERENCES pracownik ( id );

ALTER TABLE bilet
    ADD CONSTRAINT bilet_produktnaparagonie_fk FOREIGN KEY ( produktnaparagonie_paragon_id,
    produktnaparagonie_lp )
        REFERENCES produktnaparagonie ( paragon_id,
        lp );

ALTER TABLE bilet
    ADD CONSTRAINT bilet_rezerwacja_fk FOREIGN KEY ( rezerwacja_id )
        REFERENCES rezerwacja ( id );

-- Error - Foreign Key Bilet_RodzajBiletu_FK has no columns

ALTER TABLE miejsce
    ADD CONSTRAINT miejsce_sala_fk FOREIGN KEY ( sala_nr_sali )
        REFERENCES sala ( nr_sali );

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT miejscenaseansie_bilet_fk FOREIGN KEY ( bilet_id )
        REFERENCES bilet ( id );

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT miejscenaseansie_miejsce_fk FOREIGN KEY ( miejsce_rząd,
    miejsce_nr_miejsca,
    miejsce_sala_nr_sali )
        REFERENCES miejsce ( rząd,
        nr_miejsca,
        sala_nr_sali );

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT miejscenaseansie_rezerwacja_fk FOREIGN KEY ( rezerwacja_id )
        REFERENCES rezerwacja ( id );

ALTER TABLE miejscenaseansie
    ADD CONSTRAINT miejscenaseansie_seans_fk FOREIGN KEY ( seans_id,
    seans_data_godzina )
        REFERENCES seans ( film_id,
        data_godzina );

ALTER TABLE produktnaparagonie
    ADD CONSTRAINT produktnaparagonie_bilet_fk FOREIGN KEY ( bilet_id )
        REFERENCES bilet ( id );

ALTER TABLE produktnaparagonie
    ADD CONSTRAINT produktnaparagonie_paragon_fk FOREIGN KEY ( paragon_id )
        REFERENCES paragon ( id );

ALTER TABLE produktnaparagonie
    ADD CONSTRAINT produktnaparagonie_produkt_fk FOREIGN KEY ( produkt_id )
        REFERENCES produkt ( id );

ALTER TABLE rezerwacja
    ADD CONSTRAINT rezerwacja_klient_fk FOREIGN KEY ( klient_login )
        REFERENCES klient ( login );

ALTER TABLE seans
    ADD CONSTRAINT seans_film_fk FOREIGN KEY ( film_id )
        REFERENCES film ( id );

CREATE SEQUENCE bilet_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER bilet_id_trg BEFORE
    INSERT ON bilet
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := bilet_id_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                             4
-- ALTER TABLE                             28
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          1
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   2
-- WARNINGS                                 1
