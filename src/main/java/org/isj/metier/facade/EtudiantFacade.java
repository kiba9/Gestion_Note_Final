package org.isj.metier.facade;

import org.isj.metier.entites.Classe;
import org.isj.metier.entites.Etudiant;
import org.isj.metier.entites.Personne;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Etudiant dans la base de données
 *
 * @author traitement metier
 **/

public class EtudiantFacade extends AbstractFacade<Etudiant> {

    public EtudiantFacade(){
        super(Etudiant.class);
    }

    /**
      * fonction qui permet de créer un objet Etudiant en base de données en utilisant les paramètres du constructeur
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
     * @param professionPere
     * @param professionMere
     * @param regionOrigine
     * @param ecoleOrigine
     * @param matricule
     * @param codeAuthentification
     * @param classe
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut, String nomMere, String nomPere, int telephoneMere, int telephonePere, String professionPere, String professionMere, String regionOrigine, String ecoleOrigine, String matricule, String codeAuthentification, Classe classe){
        Etudiant etudiant = new Etudiant(libelle,description,nom,prenom,email,telephone,dateNaissance,sexe,statut,nomMere,nomPere,telephoneMere,telephonePere,professionPere,professionMere,regionOrigine,ecoleOrigine,classe,matricule,codeAuthentification);
        return create(etudiant);
/**
 *  fonction qui permet de mettre à jour les champs de l'objet Etudiant
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
 * @param professionPere
 * @param professionMere
 * @param regionOrigine
 * @param ecoleOrigine
 * @param matricule
 * @param codeAuthentification
 * @param classe
 * @return la chaine des caractères succes si la modification est une réussite et echec sinon
 */

    }

    public String modifier(Etudiant etudiant,String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut,String nomMere,String nomPere,int telephoneMere,int telephonePere,String professionPere,String professionMere,String regionOrigine,String ecoleOrigine,String matricule,String codeAuthentification,Classe classe){
        etudiant.setLibelle(libelle);
        etudiant.setDescription(description);
        etudiant.setNom(nom);
        etudiant.setPrenom(prenom);
        etudiant.setEmail(email);
        etudiant.setTelephone(telephone);
        etudiant.setDateNaissance(dateNaissance);
        etudiant.setSexe(sexe);
        etudiant.setStatut(statut);
        etudiant.setNomDeLaMere(nomMere);
        etudiant.setNomDuPere(nomPere);
        etudiant.setTelephoneDeLaMere(telephoneMere);
        etudiant.setTelephoneDuPere(telephonePere);
        etudiant.setProfessionDuPere(professionPere);
        etudiant.setProfessionDelaMere(professionMere);
        etudiant.setRegionOrigine(regionOrigine);
        etudiant.setEcoleOrigine(ecoleOrigine);
        etudiant.setMatricule(matricule);
        etudiant.setCodeAuthentification(codeAuthentification);
        etudiant.setClasse(classe);
        return merge(etudiant);
    }

    /**
     * fonction qui permet de supprimer un objet Etudiant
     * @param etudiant
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String supprimer(Etudiant etudiant){
        return remove(etudiant);
    }

    /**
     * fonction qui permet de lister tous les objets de la table etudiant en BD
     * @return une liste d'objets etudiant
     */
    public List<Etudiant> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Etudiant selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets etudiant
     */
    public List<Etudiant> lister(String requete){
        return findAllNative(requete);
    }
}
