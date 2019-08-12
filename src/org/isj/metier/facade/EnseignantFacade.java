package org.isj.metier.facade;

import org.isj.metier.entites.Enseignant;
import org.isj.metier.entites.Personne;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Enseigant dans la base de données
 *
 * @author traitement metier
 **/

public class EnseignantFacade extends AbstractFacade<Enseignant> {

    public EnseignantFacade(){
        super(Enseignant.class);
    }

    /**
     * fonction qui permet de créer un objet Email en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param nom
     * @param prenom
     * @param email
     * @param telephone
     * @param dateNaissance
     * @param dateNaissance
     * @param dateNaissance
     * @param dateNaissance
     * @param dateNaissance
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut,String qualification){
        Enseignant enseignant = new Enseignant(libelle,description,nom,prenom,email,telephone,dateNaissance,sexe,statut,qualification);
        return create(enseignant);

    }

    /**
     * fonction qui permet de mettre à jour les valeurs des champs d'un objet enseignant
     * @param enseignant
     * @param libelle
     * @param description
     * @param nom
     * @param prenom
     * @param email
     * @param telephone
     * @param dateNaissance
     * @param sexe
     * @param statut
     * @param qualification
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Enseignant enseignant,String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Personne.Sexe sexe, Personne.Statut statut,String qualification){
        enseignant.setLibelle(libelle);
        enseignant.setDescription(description);
        enseignant.setNom(nom);
        enseignant.setPrenom(prenom);
        enseignant.setEmail(email);
        enseignant.setTelephone(telephone);
        enseignant.setDateNaissance(dateNaissance);
        enseignant.setSexe(sexe);
        enseignant.setStatut(statut);
        enseignant.setQualification(qualification);
        return merge(enseignant);
    }

    /**
     * fonction qui permet de supprimer un objet Enseignant
     * @param enseignant
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Enseignant enseignant){
        return remove(enseignant);
    }

    /**
     * fonction qui permet de lister tous les objets Enseignant
     * @return une liste d'objets Enseignant
     */
    public List<Enseignant> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Enseignant selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Enseignant
     */
    public List<Enseignant> lister(String requete){
        return findAllNative(requete);
    }
}
