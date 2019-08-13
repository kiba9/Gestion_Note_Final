package org.isj.metier.facade;

import org.isj.metier.entites.AnneeAcademique;

import java.util.Date;
import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet anneeAcademique dans la base de données
 *
 * @author traitement metier
 **/

public class AnneeAcademiqueFacade extends AbstractFacade <AnneeAcademique> {

    public AnneeAcademiqueFacade(){super(AnneeAcademique.class);}
    /**
     * fonction qui permet de créer un objet anneeAcademique en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param dateDebut
     * @param dateCloture
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, Date dateDebut,Date dateCloture){
        AnneeAcademique anneeAcademique = new AnneeAcademique(libelle,description,dateDebut,dateCloture);
        return create(anneeAcademique);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet
     * @param libelle
     * @param description
     * @param dataDebut
     * @param dateCloture
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(AnneeAcademique anneeAcademique,String libelle,String description,Date dataDebut,Date dateCloture){
        anneeAcademique.setLibelle(libelle);
        anneeAcademique.setDescription(description);
        anneeAcademique.setDateDebut(dataDebut);
        anneeAcademique.setDateCloture(dateCloture);
        return merge(anneeAcademique);
    }

    /**
     * fonction qui permet de supprimer un objet anneeAcademique
     * @param anneeAcademique
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(AnneeAcademique anneeAcademique){
        return remove(anneeAcademique);
    }

    /**
     * fonction qui permet de lister tous les objets de la table anneeAcademique en BD
     * @return une liste d'objets AnneeAcademique
     */
    public List<AnneeAcademique> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets AnneeAcademique
     */
    public List<AnneeAcademique> lister(String requete){
        return findAllNative(requete);
    }
}
