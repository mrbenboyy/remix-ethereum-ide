// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract GestionLocations {

    address public proprietaire;
    enum EtatContrat { EnAttente, Actif, Termine }
    struct Contrat {
        uint montantLoyer;
        EtatContrat etat;
    }

    mapping(address => Contrat) public contrats;

    event ContratCree(address locataire, uint montant);
    event LoyerPaye(address locataire, uint montant);
    event ContratCloture(address locataire);

    constructor() {
        proprietaire = msg.sender;
    }

    function ajouterContrat(address locataire, uint montant) public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut ajouter un contrat");
        require(contrats[locataire].montantLoyer == 0, "Contrat deja existant");

        contrats[locataire] = Contrat({
            montantLoyer: montant,
            etat: EtatContrat.EnAttente
        });

        emit ContratCree(locataire, montant);
    }

    function payerLoyer() public payable {
        Contrat storage c = contrats[msg.sender];
        require(c.montantLoyer > 0, "Aucun contrat trouve");
        require(c.etat == EtatContrat.EnAttente, "Contrat deja actif ou termine");
        require(msg.value == c.montantLoyer, "Le montant doit correspondre au loyer");

        c.etat = EtatContrat.Actif;

        emit LoyerPaye(msg.sender, msg.value);
    }

    function cloturerMonContrat(address locataire) public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut cloturer un contrat");

        Contrat storage c = contrats[locataire];
        require(c.etat == EtatContrat.Actif, "Contrat non actif");

        c.etat = EtatContrat.Termine;

        emit ContratCloture(locataire);
    }
}
