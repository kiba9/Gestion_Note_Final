package org.isj.metier.facade;

import org.isj.metier.entites.Filiere;
import org.isj.metier.entites.Specialite;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Specialite dans la base de données
 *
 * @author traitement metier
 **/

public class SpecialiteFacade extends AbstractFacade<Specialite> {

    public SpecialiteFacade(){
        super(Specialite.class);
    }

    /**
     * fonction qui permet de créer un objet Specialite en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param filiere
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Filiere filiere){
        Specialite specialite = new Specialite(libelle,description,filiere);
        return create(specialite);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Specialite
     * @param libelle
     * @param description
     * @param filiere
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Specialite specialite,String libelle,String description,Filiere filiere){
        specialite.setLibelle(libelle);
        specialite.setDescription(description);
        specialite.setFiliere(filiere);
        return merge(specialite);
    }

    /**
     * fonction qui permet de supprimer un objet Specialite
     * @param specialite
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Specialite specialite){
        return remove(specialite);
    }

    /**
     * fonction qui permet de lister tous les objets  de la table Specialite en BD
     * @return une liste d'objets Specialite
     */
    public List<Specialite> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Specialite selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Specialite
     */
    public List<Specialite> lister(String requete){
        return findAllNative(requete);
    }
}
