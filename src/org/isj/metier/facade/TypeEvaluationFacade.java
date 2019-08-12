package org.isj.metier.facade;

import org.isj.metier.entites.Enseignement;
import org.isj.metier.entites.TypeEvaluation;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet TypeEvaluation dans la base de donnée
 *
 **/

public class TypeEvaluationFacade extends AbstractFacade<TypeEvaluation> {

    public TypeEvaluationFacade(){
        super(TypeEvaluation.class);
    }

    /**
     * fonction qui permet de créer un objet TypeEvaluation en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param pourcentage
     * @param enseignement
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, float pourcentage, Enseignement enseignement){
        TypeEvaluation typeEvaluation = new TypeEvaluation(libelle,description,pourcentage,enseignement);
        return create(typeEvaluation);
    }

    /**
     *fonction qui permet de mettre à jour les champs de l'objet TypeEvaluation
     * @param typeEvaluation
     * @param libelle
     * @param description
     * @param pourcentage
     * @param enseignement
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(TypeEvaluation typeEvaluation,String libelle,String description,float pourcentage,Enseignement enseignement){
        typeEvaluation.setLibelle(libelle);
        typeEvaluation.setDescription(description);
        typeEvaluation.setPourcentage(pourcentage);
        typeEvaluation.setEnseignement(enseignement);
        return merge(typeEvaluation);
    }

    /**
     * fonction qui permet de supprimer un objet TypeEvaluation
     * @param typeEvaluation
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(TypeEvaluation typeEvaluation){
        return remove(typeEvaluation);
    }

    /**
     * fonction qui permet de lister tous les objets de la table TypeEvaluation en BD
     * @return une liste d'objets TypeEvaluation
     */
    public List<TypeEvaluation> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets TypeEvaluation selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets TypeEvaluation
     */
    public List<TypeEvaluation> lister(String requete){
        return findAllNative(requete);
    }
}
