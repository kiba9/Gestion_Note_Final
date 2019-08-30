package org.isj.metier.facade;

import org.isj.metier.entites.HistoriqueNote;
import org.isj.metier.entites.Note;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet HistoriqueNote dans la base de donnée
 *
 * @author traitement metier
 **/

public class HistoriqueNoteFacade extends AbstractFacade<HistoriqueNote> {

    public HistoriqueNoteFacade(){
        super(HistoriqueNote.class);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet HistoriqueNote
     * @param libelle
     * @param description
     * @param note
     * @param valeurNote
     *
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, double valeurNote, Note note){
        HistoriqueNote historiqueNote = new HistoriqueNote(libelle,description,valeurNote,note);
        return create(historiqueNote);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet HistoriqueNote
     * @param libelle
     * @param description
     * @param note
     * @param valeurNote
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(HistoriqueNote historiqueNote,String libelle,String description,double valeurNote,Note note){
        historiqueNote.setLibelle(libelle);
        historiqueNote.setDescription(description);
        historiqueNote.setValeurNote(valeurNote);
        historiqueNote.setNote(note);
        return merge(historiqueNote);
    }
    /**
     * fonction qui permet de supprimer un objet HistoriqueNote
     * @param historiqueNote
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */

    public String supprimer(HistoriqueNote historiqueNote){
        return remove(historiqueNote);
    }

    /**
     * fonction qui permet de lister tous les objets de la table HistoriqueNote en BD
     * @return une liste d'objets HistoriqueNote
     */

    public List<HistoriqueNote> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets HistoriqueNote selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets HistoriqueNote
     */
    public List<HistoriqueNote> lister(String requete){
        return findAllNative(requete);
    }
}
