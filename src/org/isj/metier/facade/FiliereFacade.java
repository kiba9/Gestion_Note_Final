/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.metier.facade;

import org.isj.metier.entites.Filiere;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Filiere dans la base de données
 *
 * @author traitement metier
 **/

public class FiliereFacade extends AbstractFacade<Filiere> {

    public FiliereFacade() {
        super(Filiere.class);
    }

    /**
     * fonction qui permet de créer un objet Filiere en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle,String description){
        Filiere filiere = new Filiere(libelle,description);
        return create(filiere);
    }
    /**
     * fonction qui permet de mettre à jour les champs de l'objet Filiere
     * @param libelle
     * @param description
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */

    public String modifier(Filiere filiere,String libelle,String description){
        filiere.setLibelle(libelle);
        filiere.setDescription(description);
        return merge(filiere);
    }

    /**
     * fonction qui permet de supprimer un objet Filiere
     * @param filiere
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Filiere filiere){
        return remove(filiere);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Filiere en BD
     * @return une liste d'objets Filiere
     */
    public List <Filiere> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Filiere selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Filiere
     */
    public List<Filiere> lister(String requete){
        return findAllNative(requete);
    }
}
