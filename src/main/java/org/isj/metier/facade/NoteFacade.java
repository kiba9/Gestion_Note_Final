package org.isj.metier.facade;

import org.isj.metier.entites.Anonymat;
import org.isj.metier.entites.EstInscrit;
import org.isj.metier.entites.Evaluation;
import org.isj.metier.entites.Note;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Note dans la base de données
 *
 * @author traitement metier
 **/

public class NoteFacade extends AbstractFacade <Note> {

    public NoteFacade(){
        super(Note.class);
    }
    /**
     * fonction qui permet de mettre à jour les champs de l'objet Note
     * @param libelle
     * @param description
     * @param valeurNote
     * @param numeroTable
     * @param anonymat
     * @param estInscrit
     * @param evaluation
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle,String description,double valeurNote,int numeroTable,Anonymat anonymat, EstInscrit estInscrit, Evaluation evaluation){
        Note note = new Note(libelle,description,valeurNote,numeroTable,anonymat,estInscrit,evaluation);
        return create(note);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Note
     * @param libelle
     * @param description
     * @param valeurNote
     * @param numeroTable
     * @param anonymat
     * @param estInscrit
     * @param evaluation
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Note note, String libelle, String description, double valeurNote, int numeroTable, Anonymat anonymat, EstInscrit estInscrit, Evaluation evaluation){
        note.setLibelle(libelle);
        note.setDescription(description);
        note.setValeurNote(valeurNote);
        note.setNumeroTable(numeroTable);
        note.setAnonymat(anonymat);
        note.setEstInscrit(estInscrit);
        note.setEvaluation(evaluation);
        return merge(note);
    }

    /**
     * fonction qui permet de supprimer un objet Note
     * @param note
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Note note){
        return remove(note);
    }

    /**
     * fonction qui permet de lister tous les objets Note de la table Module en BD
     * @return une liste d'objets Note
     */
    public List<Note> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Note selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Note
     */
    public List<Note> lister(String requete){
        return findAllNative(requete);
    }
}
