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
    return dataSource`SELECT * FROM module_client.get_interactions_by_conseiller(${id})`;
});

app.get("/interaction/clients", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM module_client.get_interactions_by_client(${id})`;

});

app.get("/interaction", async (request, reply) => {
    const { id } = request.query
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM module_client.read_interaction(${id})`;

});

app.get("/interaction/conseiller/:id", async (request, reply) => {
    const { id } = request.params
    if (!id) {
        return reply.code(400).send({ message: "Missing id" });
    }
    return dataSource`SELECT * FROM module_client.read_conseiller_from_interaction(${id})`;

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
    return dataSource`SELECT * FROM module_client.read_salarie(${id})`;
});

app.get('/commande', async (request, reply) => {
    const {id} = request.query;
    if (!id) {
        return reply.code(400).send({message: "Missing id"});
    }
    return dataSource`SELECT * FROM module_client.read_commande(${id})`;
});

app.get('/client/lastcommandes', async (request, reply) => {
    return dataSource`SELECT * FROM module_client.get_date_derniere_commandes()`;
});

app.get('/client/lastcommande/:id', async (request, reply) => {
    const {id} = request.params;
    if (!id) {
        return reply.code(400).send({message: "Missing id"});
    }
    return dataSource`SELECT * FROM module_client.last_commande(${id})`;
})
/*
Commande
    id             serial,
    date_commande  timestamp with time zone not null,
    montant        double precision         not null,
    quantite       int                      not null,
    statut         varchar(15)              not null,
    id_client      int                      not null REFERENCES module_client.client (id),
    id_interaction int REFERENCES module_client.interaction (id),
    PRIMARY KEY (id)
 */
app.post('/commande', async (request, reply) => {
    const {date_commande, montant, quantite, statut, id_client, id_interaction} = request.body;
    if (!date_commande || !montant || !quantite || !statut || !id_client || !id_interaction) {
        return reply.code(400).send({message: "Missing fields"});
    }
    return dataSource`CALL create_commande(${date_commande}, ${montant}, ${quantite}, ${statut}, ${id_client}, ${id_interaction})`;
});

app.delete('/commande', async (request, reply) => {
    const {id} = request.query;
    if (!id) {
        return reply.code(400).send({message: "Missing id"});
    }
    return dataSource`CALL delete_commande(${id})`;
});

app.listen({ port: 3000 }, function (err, address) {
    if (err) {
        app.log.error(err);
        process.exit(1);
    }
    // Server is now listening on ${address}
})