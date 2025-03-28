// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract ContratVente {
    address payable public vendeur;
    address public acheteur;
    uint256 public prix;
    
    enum EtatVente { Disponible, Paye, Livre }
    EtatVente public etat;
    
    constructor(uint256 _prix) {
        vendeur = payable(msg.sender);
        prix = _prix;
        etat = EtatVente.Disponible;
    }
    
    function acheter() public payable {
        require(etat == EtatVente.Disponible, "Article non disponible");
        require(msg.value == prix, "Montant incorrect");
        
        acheteur = msg.sender;
        etat = EtatVente.Paye;
    }
    
    function confirmerLivraison() public {
        require(msg.sender == vendeur, "Seul le vendeur peut confirmer la livraison");
        require(etat == EtatVente.Paye, "L'article n'a pas encore ete paye");
        
        etat = EtatVente.Livre;
        vendeur.transfer(prix);
    }
    
    function rembourserAcheteur() public {
        require(msg.sender == vendeur, "Seul le vendeur peut rembourser");
        require(etat == EtatVente.Paye, "Aucun paiement a rembourser");
        
        payable(acheteur).transfer(prix);
        acheteur = address(0);
        etat = EtatVente.Disponible;
    }
    
    function getEtat() public view returns (EtatVente) {
        return etat;
    }
}
