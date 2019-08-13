package org.isj.metier.facade;

import org.isj.metier.entites.Candidat;
import org.isj.metier.entites.Enseignement;
import org.isj.metier.entites.EstInscrit;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet EstInscrit dans la base de données
 *
 * @author traitement metier
 **/

public class EstInscritFacade extends AbstractFacade<EstInscrit> {


    public EstInscritFacade(){
        super(EstInscrit.class);
    }
    /**
     * fonction qui permet de créer un objet EstInscrit en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param statut
     * @param candidatInscrit
     * @param enseignement
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, EstInscrit.Statut statut, Candidat candidatInscrit, Enseignement enseignement){
        EstInscrit estInscrit = new EstInscrit(libelle,description,statut,candidatInscrit,enseignement);
        return create(estInscrit);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet EstInscrit
     * @param libelle
     * @param description
     * @param statut
     * @param candidatInscrit
     * @param enseignement
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(EstInscrit estInscrit, String libelle, String description, EstInscrit.Statut statut, Candidat candidatInscrit, Enseignement enseignement){
        estInscrit.setLibelle(libelle);
        estInscrit.setDescription(description);
        estInscrit.setStatut(statut);
        estInscrit.setEnseignement(enseignement);
        estInscrit.setCandidatInscrit(candidatInscrit);
        return merge(estInscrit);
    }
    /**
     * fonction qui permet de supprimer un objet EstInscrit
     * @param estInscrit
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */

    public String supprimer(EstInscrit estInscrit){
        return remove(estInscrit);
    }

    /**
     * fonction qui permet de lister tous les objets de la table EstInscrit en BD
     * @return une liste d'objets EstInscrit
     */
    public List<EstInscrit> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets EstInscrit selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets EstInscrit
     */
    public List<EstInscrit> lister(String requete){
        return findAllNative(requete);
    }
}
