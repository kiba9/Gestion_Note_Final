package org.isj.metier.facade;

import org.isj.metier.entites.Anonymat;
import org.isj.metier.entites.EstInscrit;
import org.isj.metier.entites.Evaluation;
import org.isj.metier.entites.Note;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Anonymat dans la base de données
 *
 * @author traitement metier
 **/

public class AnonymatFacade extends AbstractFacade<Anonymat> {
    public AnonymatFacade() {
        super(Anonymat.class);
    }

    /**
     * fonction qui permet de créer un objet Anonymat en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param numeroAnonymat
     * @param note
     * @param evaluation
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, int numeroAnonymat, Note note, Evaluation evaluation, EstInscrit estInscrit, int numeroTable){
        Anonymat anonymat = new Anonymat(libelle,description,numeroAnonymat,note,evaluation,estInscrit,numeroTable);
        return create(anonymat);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet
     * @param libelle
     * @param description
     * @param numeroAnonymat
     * @param note
     * @param evaluation
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Anonymat anonymat,String libelle,String description,int numeroAnonymat,Note note, Evaluation evaluation,EstInscrit estInscrit, int numeroTable){
        anonymat.setLibelle(libelle);
        anonymat.setDescription(description);
        anonymat.setNumeroAnonymat(numeroAnonymat);
        anonymat.setNote(note);
        anonymat.setEvaluation(evaluation);
        anonymat.setEstInscrit(estInscrit);
        anonymat.setNumeroTable(numeroTable);
        return merge(anonymat);
    }

    /**
     * fonction qui permet de supprimer un objet Anonymat
     * @param anonymat
     * @return
     */
    public String supprimer(Anonymat anonymat){
        return remove(anonymat);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Anonymat en BD
     * @return une liste d'objets Anonymat
     */
    public List<Anonymat> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Anonymat selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Anonymat
     */
    public List<Anonymat> lister(String requete){
        return findAllNative(requete);
    }
}
