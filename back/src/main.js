import Fastify from "fastify";
import dataSource from "./dataSource.js";

const app = Fastify({
    logger: true
});

app.get("/interaction/conseillers", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM public.get_interactions_by_conseiller(${id})`;
});

app.get("/interaction/clients", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM public.get_interactions_by_client(${id})`;

});

app.get("/interaction", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM public.read_interaction(${id})`;

});

app.get("/interaction/conseiller/:id", async (request, reply) => {
    const { id } = request.params
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM public.read_conseiller_from_interaction(${id})`;

});



/*
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
 */

app.post("/salarie", async (request, reply) => {
    const { nom,
        prenom,
        date_naissance,
        num_securite_sociale,
        salaire,
        date_entree,
        type_contact,
        adresse,
        ville,
        code_postal,
        futur_entretien,
        numero_telephone
    } = request.body;
    if (!nom || !prenom || !date_naissance || !num_securite_sociale || !salaire || !date_entree || !type_contact || !adresse || !ville || !code_postal || !numero_telephone) {
        return reply.code(400).send({ message: "Missing fields" });
    }
    return dataSource`CALL create_salarie(${nom}, ${prenom}, ${date_naissance}, ${num_securite_sociale}, ${salaire}, ${date_entree}, ${type_contact}, ${adresse}, ${ville}, ${code_postal}, ${futur_entretien}, ${numero_telephone})`;
});

app.delete('/salarie', async (request, reply) => {
    const {id} = request.query;
    if (!id) {
        return reply.code(400).send({message: "Missing id"});
    }
    return dataSource`CALL delete_salarie(${id})`;
});

app.put('/salarie', async (request, reply) => {
    const {id, nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree, type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone} = request.body;
    if (!id || !nom || !prenom || !date_naissance || !num_securite_sociale || !salaire || !date_entree || !type_contact || !adresse || !ville || !code_postal || !numero_telephone) {
        return reply.code(400).send({message: "Missing fields"});
    }
    return dataSource`CALL update_salarie(${id}, ${nom}, ${prenom}, ${date_naissance}, ${num_securite_sociale}, ${salaire}, ${date_entree}, ${type_contact}, ${adresse}, ${ville}, ${code_postal}, ${futur_entretien}, ${numero_telephone})`;
});

app.get("/salarie", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM public.read_salarie(${id})`;
});

app.get('commande', async (request, reply) => {
    const {id} = request.query;
    if (!id) {
        return reply.code(400).send({message: "Missing id"});
    }
    return dataSource`SELECT * FROM public.read_commande(${id})`;
});



/*
    CREATE OR REPLACE PROCEDURE create_client(nom varchar(50), prenom varchar(50), mail varchar(255), telephone varchar(15), adresse varchar(100))
        LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO module_client.client (nom, prenom, mail, telephone, adresse) VALUES (nom, prenom, mail, telephone, adresse);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE read_client(id_client int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        SELECT * FROM module_client.client WHERE id = id_client;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE update_client(id_client int, nom varchar(50), prenom varchar(50), mail varchar(255), telephone varchar(15), adresse varchar(100))
        LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE module_client.client SET nom = nom, prenom = prenom, mail = mail, telephone = telephone, adresse = adresse WHERE id = id_client;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE delete_client(id_client int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM module_client.client WHERE id = id_client;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE create_salarie(nom varchar(50), prenom varchar(50), date_naissance date, num_securite_sociale int, salaire double precision, date_entree timestamp with time zone, type_contact varchar(100), adresse varchar(50), ville varchar(50), code_postal int, futur_entretien date, numero_telephone int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO module_client.salarie (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree, type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone) VALUES (nom, prenom, date_naissance, num_securite_sociale, salaire, date_entree, type_contact, adresse, ville, code_postal, futur_entretien, numero_telephone);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE read_salarie(id_salarie int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        SELECT * FROM module_client.salarie WHERE id = id_salarie;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE update_salarie(id_salarie int, nom_salarie varchar(50), prenom_salarie varchar(50), date_naissance_salarie date, num_securite_sociale_salarie int, salaire_salarie double precision, date_entree_salarie timestamp with time zone, type_contact_salarie varchar(100), adresse_salarie varchar(50), ville_salarie varchar(50), code_postal_salarie int, futur_entretien_salarie date, numero_telephone_salarie int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE module_client.salarie SET nom = nom_salarie, prenom = prenom_salarie, date_naissance = date_naissance_salarie, num_securite_sociale = num_securite_sociale_salarie, salaire = salaire_salarie, date_entree = date_entree_salarie, type_contact = type_contact_salarie, adresse = adresse_salarie, ville = ville_salarie, code_postal = code_postal_salarie, futur_entretien = futur_entretien_salarie, numero_telephone = numero_telephone_salarie WHERE id = id_salarie;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE delete_salarie(id_salarie int)
        LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM module_client.salarie WHERE id = id_salarie;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE create_interaction(date_debut timestamp with time zone, description text, date_resolution timestamp with time zone, client_id int, libelle_interaction varchar(25))
        LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO module_client.interaction (date_debut, description, date_resolution, client_id, libelle_interaction) VALUES (date_debut, description, date_resolution, client_id, libelle_interaction);
    END;
    $$;

CREATE OR REPLACE FUNCTION get_interactions_by_conseiller(conseiller_id INT)
RETURNS TABLE (
    interaction_id INT,
    date_debut TIMESTAMP WITH TIME ZONE,
    description TEXT,
    date_resolution TIMESTAMP WITH TIME ZONE,
    last_updated TIMESTAMP WITH TIME ZONE,
    client_id INT,
    libelle_interaction VARCHAR(25)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.id AS interaction_id,
        i.date_debut,
        i.description,
        i.date_resolution,
        i.last_updated,
        i.client_id,
        ti.libelle AS libelle_interaction
    FROM
        module_client.interaction_conseiller ic
    JOIN
        module_client.interaction i ON ic.id_interaction = i.id
    JOIN
        module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
    WHERE
        ic.id_conseiller = conseiller_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_interactions_by_client(id_client INT)
RETURNS TABLE (
    interaction_id INT,
    date_debut TIMESTAMP WITH TIME ZONE,
    description TEXT,
    date_resolution TIMESTAMP WITH TIME ZONE,
    last_updated TIMESTAMP WITH TIME ZONE,
    client_id INT,
    libelle_interaction VARCHAR(25)
) AS $$
BEGIN
RETURN QUERY
SELECT
i.id AS interaction_id,
    i.date_debut,
    i.description,
    i.date_resolution,
    i.last_updated,
    i.client_id,
    ti.libelle AS libelle_interaction
FROM
module_client.interaction i
JOIN
module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
WHERE
i.client_id = id_client;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION read_interaction(id_interaction int) RETURNS TABLE (interaction_id INT, date_debut TIMESTAMP WITH TIME ZONE, description TEXT, date_resolution TIMESTAMP WITH TIME ZONE, last_updated TIMESTAMP WITH TIME ZONE, client_id INT, libelle_interaction VARCHAR(25))
LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT
i.id AS interaction_id,
    i.date_debut,
    i.description,
    i.date_resolution,
    i.last_updated,
    i.client_id,
    ti.libelle AS libelle_interaction
FROM
module_client.interaction i
JOIN
module_client.type_interaction ti ON i.libelle_interaction = ti.libelle
WHERE
i.id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE update_interaction(id_interaction int, date_debut timestamp with time zone, description text, date_resolution timestamp with time zone, client_id int, libelle_interaction varchar(25))
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE module_client.interaction SET date_debut = date_debut, description = description, date_resolution = date_resolution, client_id = client_id, libelle_interaction = libelle_interaction WHERE id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_interaction(id_interaction int)
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM module_client.interaction WHERE id = id_interaction;
END;
$$;

CREATE OR REPLACE PROCEDURE create_commande(date_commande timestamp with time zone, montant double precision, quantite int, statut varchar(15), id_client int, id_interaction int)
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO module_client.commande (date_commande, montant, quantite, statut, id_client, id_interaction) VALUES (date_commande, montant, quantite, statut, id_client, id_interaction);
END;
$$;

CREATE OR REPLACE PROCEDURE read_commande(id_commande int)
LANGUAGE plpgsql
AS $$
BEGIN
SELECT * FROM module_client.commande WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE PROCEDURE update_commande(id_commande int, date_commande timestamp with time zone, montant double precision, quantite int, statut varchar(15), id_client int, id_interaction int)
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE module_client.commande SET date_commande = date_commande, montant = montant, quantite = quantite, statut = statut, id_client = id_client, id_interaction = id_interaction WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_commande(id_commande int)
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM module_client.commande WHERE id = id_commande;
END;
$$;

CREATE OR REPLACE PROCEDURE create_conseiller(id_conseiller int, id_interaction int)
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO module_client.interaction_conseiller (id_conseiller, id_interaction) VALUES (id_conseiller, id_interaction);
END;
$$;

CREATE OR REPLACE FUNCTION read_conseiller_from_interaction(id_int int) RETURNS TABLE (conseiller_id INT, nom VARCHAR(50), prenom VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT
s.id AS conseiller_id,
    s.nom,
    s.prenom
FROM
module_client.interaction_conseiller ic
JOIN
module_client.salarie s ON ic.id_conseiller = s.id
WHERE
ic.id_interaction = id_int;
END;
$$;

CREATE OR REPLACE PROCEDURE update_conseiller(id_cons int, id_int int)
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE module_client.interaction_conseiller SET id_conseiller = id_cons WHERE id_interaction = id_int;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_conseiller(id_cons int, id_int int)
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM module_client.interaction_conseiller WHERE id_conseiller = id_cons AND id_interaction = id_int;
END;
$$;

 */



app.listen({ port: 3000 }, function (err, address) {
    if (err) {
        app.log.error(err);
        process.exit(1);
    }
    // Server is now listening on ${address}
})