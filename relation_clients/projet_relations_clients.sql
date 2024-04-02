CREATE SCHEMA IF NOT EXISTS module_client;

\c module_client;

create table module_client.client
(
    id                  serial,
    nom                 varchar(50)  not null,
    prenom              varchar(50)  not null,
    mail                varchar(255) not null,
    telephone           varchar(15)  not null,
    adresse             varchar(100) not null,
    futur_entretien_tel timestamp with time zone,
    PRIMARY KEY (id)
);

create table module_client.salarie
(
    id                   serial,
    nom                  varchar(50)              not null,
    prenom               varchar(50)              not null,
    date_naissance       date                     not null,
    num_securite_sociale int                      not null unique,
    salaire              double precision         not null,
    date_entree          timestamp with time zone not null,
    type_contact         varchar(100)             not null,
    adresse              varchar(50)              not null,
    ville                varchar(50)              not null,
    code_postal          int                      not null,
    futur_entretien      date,
    numero_telephone     int                      not null,
    PRIMARY KEY (id)
);

create table module_client.type_interaction
(
    libelle  varchar(25),
    priorite smallint not null,
    PRIMARY KEY (libelle)
);

create table module_client.interaction
(
    id                  serial,
    date_debut          timestamp with time zone default now(),
    description         text not null,
    date_resolution     timestamp with time zone,
    last_updated        timestamp with time zone default now(),
    client_id           int  not null REFERENCES module_client.client (id),
    libelle_interaction varchar(25) REFERENCES module_client.type_interaction (libelle),
    PRIMARY KEY (id)
);

create table module_client.interaction_conseiller
(
    id_conseiller  int REFERENCES module_client.salarie (id),
    id_interaction int REFERENCES module_client.interaction (id),
    PRIMARY KEY (id_conseiller, id_interaction)
);


create table module_client.commande
(
    id             serial,
    date_commande  timestamp with time zone not null,
    montant        double precision         not null,
    quantite       int                      not null,
    statut         varchar(15)              not null,
    id_client      int                      not null REFERENCES module_client.client (id),
    id_interaction int REFERENCES module_client.interaction (id),
    PRIMARY KEY (id)
);

/*
Insertion du jeu de données
*/

/*
 Clients
 */

INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Doe', 'John', 'john@doe.fr', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Doe', 'Jane', 'jane@doe.fr', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Doe', 'Jack', 'jack@doe.fr', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Doe', 'Jill', 'jill@doe.fr', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Baker', 'Tom', 'baker.tom@gmail.com', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Baker', 'Jerry', 'baker.terry@gmail.com', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Lennon', 'John', 'lennon.john@gmail.com', '0601020304', '1 rue de la paix');
INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
VALUES ('Nash', 'Graham', 'nash.graham@outlook.com', '0601020304', '1 rue de la paix');

/*
 Salariés
*/

INSERT INTO module_client.salarie (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree,
                                   type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone)
VALUES ('Smith', 'John', '1980-01-01', 1094428383, 2300, '2019-01-01 00:00:00', 'mail', '1 rue de la paix', 'Paris',
        75000, '2021-01-01', 0601020304);

INSERT INTO module_client.salarie (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree,
                                   type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone)
VALUES ('Badi', 'John', '1983-01-01', 1039458555, 1800, '2020-01-01 00:00:00', 'mail', '1 rue de la paix', 'Paris',
        75000, '2021-01-01', 0601020304);

INSERT INTO module_client.salarie (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree,
                                   type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone)
VALUES ('Carter', 'Paul', '1990-01-01', 1029433434, 1500, '2021-01-01 00:00:00', 'mail', '1 rue de la paix', 'Paris',
        75000, '2021-01-01', 0601020304);

/*
Type d'interaction
*/

INSERT INTO module_client.type_interaction (libelle, priorite)
VALUES ('PROBLEME_TECHNIQUE', 3);
INSERT INTO module_client.type_interaction (libelle, priorite)
VALUES ('DEMANDE_COMMERCIALE', 2);
INSERT INTO module_client.type_interaction (libelle, priorite)
VALUES ('DEMANDE_INFORMATION', 1);
INSERT INTO module_client.type_interaction (libelle, priorite)
VALUES ('RECLAMATION', 4);

/*
Interaction
*/

INSERT INTO module_client.interaction (date_debut, description, client_id, libelle_interaction)
VALUES ('2021-01-01 00:00:00', 'Problème technique', 1, 'PROBLEME_TECHNIQUE');
INSERT INTO module_client.interaction (date_debut, description, client_id, libelle_interaction)
VALUES ('2021-01-01 00:00:00', 'Demande commerciale', 2, 'DEMANDE_COMMERCIALE');
INSERT INTO module_client.interaction (date_debut, description, client_id, libelle_interaction)
VALUES ('2021-01-01 00:00:00', 'Demande information', 3, 'DEMANDE_INFORMATION');
INSERT INTO module_client.interaction (date_debut, description, client_id, libelle_interaction)
VALUES ('2021-01-01 00:00:00', 'Réclamation', 4, 'RECLAMATION');

/*
Interaction conseiller
*/

INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction)
VALUES (1, 1);
INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction)
VALUES (2, 2);
INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction)
VALUES (3, 3);
INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction)
VALUES (1, 4);

/*
Commande
*/

INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction)
VALUES ('2021-01-01 00:00:00', 100, 1, 'CLOTURE', 1, 1);
INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction)
VALUES ('2022-01-01 00:00:00', 200, 2, 'CLOTURE', 2, 2);
INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction)
VALUES ('2024-03-30 00:00:00', 300, 3, 'EN COURS', 3, 3);
INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction)
VALUES ('2024-03-31 00:00:00', 400, 4, 'EN COURS', 4, 4);



CREATE OR REPLACE FUNCTION update_last_updated()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.last_updated = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_interaction
    BEFORE UPDATE
    ON module_client.interaction
    FOR EACH ROW
EXECUTE FUNCTION update_last_updated();

/*
 Mettre à jour automatique un champ « Date de futur point téléphonique » à partir de la date de mise en relation avec le client
 */

CREATE OR REPLACE FUNCTION update_futur_entretien_tel()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE module_client.client
    SET futur_entretien_tel = NEW.date_debut + INTERVAL '1 day'
    WHERE id = NEW.client_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_futur_entretien_tel
    BEFORE INSERT OR UPDATE
    ON module_client.interaction
    FOR EACH ROW
EXECUTE FUNCTION update_futur_entretien_tel();

/*
 La création de procédures stockées pour chaque élément d’un CRUD
 */

CREATE OR REPLACE PROCEDURE create_client(nom varchar(50), prenom varchar(50), mail varchar(255), telephone varchar(15),
                                          adresse varchar(100))
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse)
    VALUES (nom, prenom, mail, telephone, adresse);
END;
$$;

CREATE OR REPLACE PROCEDURE read_client(id_client int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    SELECT * FROM module_client.client WHERE id = id_client;
END;
$$;

CREATE OR REPLACE PROCEDURE update_client(id_client int, nom varchar(50), prenom varchar(50), mail varchar(255),
                                          telephone varchar(15), adresse varchar(100))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE module_client.client
    SET nom       = nom,
        prenom    = prenom,
        mail      = mail,
        telephone = telephone,
        adresse   = adresse
    WHERE id = id_client;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_client(id_client int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM module_client.client WHERE id = id_client;
END;
$$;

CREATE OR REPLACE PROCEDURE create_salarie(nom varchar(50), prenom varchar(50), date_naissance date,
                                           num_securite_sociale int, salaire double precision,
                                           date_entree timestamp with time zone, type_contact varchar(100),
                                           adresse varchar(50), ville varchar(50), code_postal int,
                                           futur_entretien date, numero_telephone int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO module_client.salarie (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree,
                                       type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone)
    VALUES (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree, type_contact, adresse, ville,
            code_postal, futur_entretien, numero_telephone);
END;
$$;

CREATE OR REPLACE PROCEDURE read_salarie(id_salarie int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    SELECT * FROM module_client.salarie WHERE id = id_salarie;
END;
$$;

CREATE OR REPLACE PROCEDURE update_salarie(id_salarie int, nom_salarie varchar(50), prenom_salarie varchar(50),
                                           date_naissance_salarie date, num_securite_sociale_salarie int,
                                           salaire_salarie double precision,
                                           date_entree_salarie timestamp with time zone,
                                           type_contact_salarie varchar(100), adresse_salarie varchar(50),
                                           ville_salarie varchar(50), code_postal_salarie int,
                                           futur_entretien_salarie date, numero_telephone_salarie int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE module_client.salarie
    SET nom                  = nom_salarie,
        prenom               = prenom_salarie,
        date_naissance       = date_naissance_salarie,
        num_securite_sociale = num_securite_sociale_salarie,
        salaire              = salaire_salarie,
        date_entree          = date_entree_salarie,
        type_contact         = type_contact_salarie,
        adresse              = adresse_salarie,
        ville                = ville_salarie,
        code_postal          = code_postal_salarie,
        futur_entretien      = futur_entretien_salarie,
        numero_telephone     = numero_telephone_salarie
    WHERE id = id_salarie;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_salarie(id_salarie int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM module_client.salarie WHERE id = id_salarie;
END;
$$;

CREATE OR REPLACE PROCEDURE create_interaction(date_debut timestamp with time zone, description text,
                                               date_resolution timestamp with time zone, client_id int,
                                               libelle_interaction varchar(25))
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO module_client.interaction (date_debut, description, date_resolution, client_id, libelle_interaction)
    VALUES (date_debut, description, date_resolution, client_id, libelle_interaction);
END;
$$;

CREATE OR REPLACE FUNCTION get_interactions_by_conseiller(conseiller_id INT)
    RETURNS TABLE
            (
                interaction_id      INT,
                date_debut          TIMESTAMP WITH TIME ZONE,
                description         TEXT,
                date_resolution     TIMESTAMP WITH TIME ZONE,
                last_updated        TIMESTAMP WITH TIME ZONE,
                client_id           INT,
                libelle_interaction VARCHAR(25)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT i.id       AS interaction_id,
               i.date_debut,
               i.description,
               i.date_resolution,
               i.last_updated,
               i.client_id,
               ti.libelle AS libelle_interaction
        FROM module_client.interaction_conseiller ic
                 JOIN
             module_client.interaction i ON ic.id_interaction = i.id
                 JOIN
             module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
        WHERE ic.id_conseiller = conseiller_id;
END;
$$ LANGUAGE plpgsql;

/*
 get interactions by client
 */

CREATE OR REPLACE FUNCTION get_interactions_by_client(id_client INT)
    RETURNS TABLE
            (
                interaction_id      INT,
                date_debut          TIMESTAMP WITH TIME ZONE,
                description         TEXT,
                date_resolution     TIMESTAMP WITH TIME ZONE,
                last_updated        TIMESTAMP WITH TIME ZONE,
                client_id           INT,
                libelle_interaction VARCHAR(25)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT i.id       AS interaction_id,
               i.date_debut,
               i.description,
               i.date_resolution,
               i.last_updated,
               i.client_id,
               ti.libelle AS libelle_interaction
        FROM module_client.interaction i
                 JOIN
             module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
        WHERE i.client_id = id_client;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION read_interaction(id_interaction int)
    RETURNS TABLE
            (
                interaction_id      INT,
                date_debut          TIMESTAMP WITH TIME ZONE,
                description         TEXT,
                date_resolution     TIMESTAMP WITH TIME ZONE,
                last_updated        TIMESTAMP WITH TIME ZONE,
                client_id           INT,
                libelle_interaction VARCHAR(25)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT i.id       AS interaction_id,
               i.date_debut,
               i.description,
               i.date_resolution,
               i.last_updated,
               i.client_id,
               ti.libelle AS libelle_interaction
        FROM module_client.interaction i
                 JOIN
             module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
        WHERE i.id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE update_interaction(id_interaction int, date_debut timestamp with time zone,
                                               description text, date_resolution timestamp with time zone,
                                               client_id int, libelle_interaction varchar(25))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE module_client.interaction
    SET date_debut          = date_debut,
        description         = description,
        date_resolution     = date_resolution,
        client_id           = client_id,
        libelle_interaction = libelle_interaction
    WHERE id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_interaction(id_interaction int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM module_client.interaction WHERE id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE create_commande(date_commande timestamp with time zone, montant double precision,
                                            quantite int, statut varchar(15), id_client int, id_interaction int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction)
    VALUES (date_commande, montant, quantite, statut, id_client, id_interaction);
END;
$$;

CREATE OR REPLACE PROCEDURE read_commande(id_commande int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    SELECT * FROM module_client.commande WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE FUNCTION get_date_derniere_commandes()
    RETURNS TABLE
            (
                id INT,
                derniere_date TIMESTAMP WITH TIME ZONE
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY SELECT id_client as id, max(date_commande) as derniere_date FROM module_client.commande mc GROUP BY id_client;
end
$$;

CREATE OR REPLACE FUNCTION last_commande(client_id int) RETURNS TIMESTAMP WITH TIME ZONE
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN (SELECT max(date_commande) FROM module_client.commande WHERE id_client = client_id);
END;
$$;

CREATE OR REPLACE PROCEDURE update_commande(id_commande int, date_commande timestamp with time zone,
                                            montant double precision, quantite int, statut varchar(15), id_client int,
                                            id_interaction int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE module_client.commande
    SET date_commande  = date_commande,
        montant        = montant,
        quantite       = quantite,
        statut         = statut,
        id_client      = id_client,
        id_interaction = id_interaction
    WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_commande(id_commande int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM module_client.commande WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE PROCEDURE create_conseiller(id_conseiller int, id_interaction int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction)
    VALUES (id_conseiller, id_interaction);
END;
$$;

CREATE OR REPLACE FUNCTION read_conseiller_from_interaction(id_int int)
    RETURNS TABLE
            (
                conseiller_id INT,
                nom           VARCHAR(50),
                prenom        VARCHAR(50)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT s.id AS conseiller_id,
               s.nom,
               s.prenom
        FROM module_client.interaction_conseiller ic
                 JOIN
             module_client.salarie s ON ic.id_conseiller = s.id
        WHERE ic.id_interaction = id_int;
END;
$$;

CREATE OR REPLACE PROCEDURE update_conseiller(id_cons int, id_int int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE module_client.interaction_conseiller SET id_conseiller = id_cons WHERE id_interaction = id_int;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_conseiller(id_cons int, id_int int)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM module_client.interaction_conseiller WHERE id_conseiller = id_cons AND id_interaction = id_int;
END;
$$;


SELECT *
FROM read_conseiller_from_interaction(1);

SELECT *
FROM get_interactions_by_conseiller(1);

SELECT *
FROM get_interactions_by_client(1);

SELECT *
FROM get_date_derniere_commandes();


SELECT *
FROM last_commande(2);