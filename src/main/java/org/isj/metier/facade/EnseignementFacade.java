package org.isj.metier.facade;

import org.isj.metier.entites.Enseignement;
import org.isj.metier.entites.Semestre;
import org.isj.metier.entites.UE;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Enseignement dans la base de données
 *
 * @author traitement metier
 **/
public class EnseignementFacade extends AbstractFacade <Enseignement> {

    public EnseignementFacade(){
        super(Enseignement.class);
    }
    /**
     * fonction qui permet de créer un objet anneeAcademique en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param heuresCours
     * @param programmeDeCours
     * @param semestre
     * @param ue
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, int heuresCours, String programmeDeCours, Semestre semestre, UE ue){
        Enseignement enseignement = new Enseignement(libelle,description,heuresCours,programmeDeCours,semestre,ue);
        return create(enseignement);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Enseignement
     * @param libelle
     * @param description
     *  @param heuresCours
     * @param programmeCours
     * @param semestre
     * @param ue

     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Enseignement enseignement,String libelle,String description,int heuresCours,String programmeCours,Semestre semestre, UE ue){
        enseignement.setLibelle(libelle);
        enseignement.setDescription(description);
        enseignement.setHeuresDeCours(heuresCours);
        enseignement.setProgrammeDeCours(programmeCours);
        enseignement.setSemestre(semestre);
        enseignement.setUe(ue);
        return merge(enseignement);
    }

    /**
     * fonction qui permet de supprimer un objet Enseignement
     * @param enseignement
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Enseignement enseignement){
        return remove(enseignement);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Enseignement en BD
     * @return une liste d'objets Enseignement
     */
    public List<Enseignement> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Enseignement selon la requete passée en paramètre
     * @param requete
     * @return
     */
    public List<Enseignement> lister(String requete){
        return findAllNative(requete);
    }
}
