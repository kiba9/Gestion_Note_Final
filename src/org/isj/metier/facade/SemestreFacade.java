package org.isj.metier.facade;

import org.isj.metier.entites.AnneeAcademique;
import org.isj.metier.entites.Semestre;

import java.util.Date;
import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet semestre dans la base de données
 *
 * @author traitement metier
 **/

public class SemestreFacade extends AbstractFacade<Semestre> {

    public SemestreFacade(){
        super(Semestre.class);
    }

    /**
     * fonction qui permet de créer un objet semestre en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param dateDebut
     * @param dateCloture
     * @param anneeAcademique
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Date dateDebut, Date dateCloture, AnneeAcademique anneeAcademique){
        Semestre semestre = new Semestre(libelle,description,dateDebut,dateCloture,anneeAcademique);
        return create(semestre);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Semestre
     * @param libelle
     * @param description
     * @param dataDebut
     * @param dateCloture
     * @param anneeAcademique
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Semestre semestre,String libelle,String description,Date dataDebut,Date dateCloture,AnneeAcademique anneeAcademique){
        semestre.setLibelle(libelle);
        semestre.setDescription(description);
        semestre.setDateDebut(dataDebut);
        semestre.setDateCloture(dateCloture);
        semestre.setAnneeAcademique(anneeAcademique);
        return merge(semestre);
    }

    /**
     * fonction qui permet de supprimer un objet Semestre
     * @param semestre
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String supprimer(Semestre semestre){
        return remove(semestre);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Semestre en BD
     * @return une liste d'objets Semestre
     */
    public List<Semestre> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Semestre selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Semestre
     */
    public List<Semestre> lister(String requete){
        return findAllNative(requete);
    }
}
