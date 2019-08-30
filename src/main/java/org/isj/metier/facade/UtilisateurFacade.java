/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.metier.facade;

import org.isj.metier.entites.Personne;
import org.isj.metier.entites.Utilisateur;

import java.util.Date;
import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet UE dans la base de données
 *
 * @author traitement metier
 **/

public class UtilisateurFacade extends AbstractFacade<Utilisateur> {

    public UtilisateurFacade() {
        super(Utilisateur.class);
    }

    /**
     * fonction qui permet de créer un objet CandidatController en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param nom
     * @param prenom
     * @param email
     * @param telephone
     * @param dateNaissance
     * @param sexe
     * @param statut
     * @param login
     * @param motDePasse
     * @return
     */
    public String enregistrer(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut, String login, String motDePasse){
        Utilisateur utilisateur = new Utilisateur(libelle,description,nom,prenom,email,telephone,dateNaissance,sexe,statut,login,motDePasse);
        return create(utilisateur);
    }
    
    /**
     * fonction fonction qui permet de mettre à jour les champs de l'objet
     * @param libelle
     * @param description
     * @param nom
     * @param prenom
     * @param email
     * @param telephone
     * @param dateNaissance
     * @param sexe
     * @param statut
     * @param login
     * @param motDePasse
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String modifier(Utilisateur utilisateur,String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut,String login,String motDePasse){
        utilisateur.setLibelle(libelle);
        utilisateur.setDescription(description);
        utilisateur.setNom(nom);
        utilisateur.setPrenom(prenom);
        utilisateur.setEmail(email);
        utilisateur.setTelephone(telephone);
        utilisateur.setDateNaissance(dateNaissance);
        utilisateur.setSexe(sexe);
        utilisateur.setStatut(statut);
        utilisateur.setLogin(login);
        utilisateur.setMotDePasse(motDePasse);
        return merge(utilisateur);
    }

    /**
     * fonction qui permet de supprimer un objet Utilisateur
     * @param utilisateur
     * @return la chaine des caractères succes si la création est une réussite et echec sinon*/
    public String supprimer(Utilisateur utilisateur){
        return remove(utilisateur);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Utilisateur en BD
     * @return une liste d'objets Utilisateur
     */
    public List<Utilisateur> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Utilisateur selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Utilisateur
     */
    public List<Utilisateur> lister(String requete){
        return findAllNative(requete);
    }
    
}
