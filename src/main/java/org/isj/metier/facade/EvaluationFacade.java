package org.isj.metier.facade;

import org.isj.metier.entites.Evaluation;
import org.isj.metier.entites.TypeEvaluation;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Evaluation dans la base de données
 *
 * @author traitement metier
 **/

public class EvaluationFacade extends AbstractFacade <Evaluation> {

    public EvaluationFacade(){
        super(Evaluation.class);
    }

    /**
     * fonction qui permet de créer un objet Evaluation en base de données en utilisant les paramètres du constructeur
        * @param libelle
         * @param description
         * @param dateEval
         * @param statut
         * @param typeEvaluation
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Date dateEval, Evaluation.Statut statut, TypeEvaluation typeEvaluation){
        Evaluation evaluation = new Evaluation(libelle,description,dateEval,statut,typeEvaluation);
        return create(evaluation);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Evaluation
     * @param libelle
     * @param description
     * @param statut
     * @param typeEvaluation
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Evaluation evaluation, String libelle, String description, Date dateEval, Evaluation.Statut statut,TypeEvaluation typeEvaluation){
        evaluation.setLibelle(libelle);
        evaluation.setDescription(description);
        evaluation.setDateEval(dateEval);
        evaluation.setStatut(statut);
        evaluation.setTypeEvaluation(typeEvaluation);
        return merge(evaluation);
    }

    /**
     * fonction qui permet de supprimer un objet Evaluation
     * @param evaluation
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Evaluation evaluation){
        return remove(evaluation);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Evaluation en BD
     * @return une liste d'objets Evaluation
     */
    public List<Evaluation> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Evaluation selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Evaluation
     */
    public List<Evaluation> lister(String requete){
        return findAllNative(requete);
    }
}
