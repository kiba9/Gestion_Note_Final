package org.isj.metier.facade;

import org.isj.metier.entites.Droit;
import org.isj.metier.entites.Role;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Droit dans la base de données
 *
 * @author traitement metier
 **/

public class DroitFacade extends AbstractFacade<Droit> {

    public DroitFacade(){
        super(Droit.class);
    }

    /**
     * fonction qui permet de créer un objet Droit en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param lecture
     * @param ecriture
     * @param modification
     * @param suppression
     * @param role
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, String categorie, boolean lecture, boolean ecriture, boolean modification, boolean suppression, Role role){
        Droit droit = new Droit(libelle,description,categorie,lecture,ecriture,modification,suppression,role);
        return create(droit);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Droit
     * @param libelle
     * @param description
     * @param lecture
     * @param ecriture
     * @param modification
     * @param suppression
     * @param role
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */

    public String modifier(Droit droit,String libelle,String description,String categorie,boolean lecture,boolean ecriture,boolean modification,boolean suppression,Role role){
        droit.setLibelle(libelle);
        droit.setDescription(description);
        droit.setCategorie(categorie);
        droit.setEcriture(ecriture);
        droit.setLecture(lecture);
        droit.setModification(modification);
        droit.setSuppression(suppression);
        droit.setRole(role);
        return merge(droit);
    }

    /**
     * fonction qui permet de supprimer un objet Droit
     * @param droit
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String supprimer(Droit droit){
        return remove(droit);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Droit en BD
     * @return une liste d'objets Droit
     */
    public List<Droit> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Droit selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Droit
     */
    public List<Droit> lister(String requete){
        return findAllNative(requete);
    }
}
