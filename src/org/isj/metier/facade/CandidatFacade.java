package org.isj.metier.facade;

import org.isj.metier.entites.Candidat;
import org.isj.metier.entites.Classe;
import org.isj.metier.entites.Personne;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet CandidatController dans la base de données
 *
 * @author traitement metier
 **/

public class CandidatFacade extends AbstractFacade<Candidat> {
    public CandidatFacade(){
        super(Candidat.class);
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
     * @param nomMere
     * @param nomPere
     * @param telephoneMere
     * @param telephonePere
     * @param professionMere
     * @param professionPere
     * @param regionOrigine
     * @param ecoleOrigine
     * @param classe
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut, String nomMere, String nomPere, int telephoneMere, int telephonePere, String professionPere, String professionMere, String regionOrigine, String ecoleOrigine, Classe classe){
        Candidat candidat = new Candidat(libelle,description,nom,prenom,email,telephone,dateNaissance,sexe,statut,nomMere,nomPere,telephoneMere,telephonePere,professionPere,professionMere,regionOrigine,ecoleOrigine,classe);
        return create(candidat);
    }
    /**
     * fonction qui permet de mettre à jour les champs de l'objet
     * @param libelle
     * @param description
     * @param nom
     * @param prenom
     * @param email
     * @param telephone
     * @param dateNaissance
     * @param sexe
     * @param statut
     * @param nomMere
     * @param nomPere
     * @param telephoneMere
     * @param telephonePere
     * @param professionMere
     * @param professionPere
     * @param regionOrigine
     * @param ecoleOrigine
     * @param classe
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Candidat candidat,String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut,String nomMere,String nomPere,int telephoneMere,int telephonePere,String professionPere,String professionMere,String regionOrigine,String ecoleOrigine,Classe classe){
        candidat.setLibelle(libelle);
        candidat.setDescription(description);
        candidat.setNom(nom);
        candidat.setPrenom(prenom);
        candidat.setEmail(email);
        candidat.setTelephone(telephone);
        candidat.setDateNaissance(dateNaissance);
        candidat.setSexe(sexe);
        candidat.setStatut(statut);
        candidat.setNomDeLaMere(nomMere);
        candidat.setNomDuPere(nomPere);
        candidat.setTelephoneDeLaMere(telephoneMere);
        candidat.setTelephoneDuPere(telephonePere);
        candidat.setProfessionDuPere(professionPere);
        candidat.setProfessionDelaMere(professionMere);
        candidat.setRegionOrigine(regionOrigine);
        candidat.setEcoleOrigine(ecoleOrigine);
        candidat.setClasse(classe);
        return merge(candidat);
    }

    /**
     * fonction qui permet de supprimer un objet CandidatController
     * @param candidat
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Candidat candidat){
        return remove(candidat);
    }

    /**
     * fonction qui permet de lister tous les objets de la table CandidatController en BD
     * @return une liste d'objets CandidatController
     */
    public List<Candidat> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets CandidatController selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets CandidatController
     */
    public List<Candidat> lister(String requete){
        return findAllNative(requete);
    }
}
