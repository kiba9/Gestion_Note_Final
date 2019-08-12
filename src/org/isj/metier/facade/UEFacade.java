package org.isj.metier.facade;

import org.isj.metier.entites.Module;
import org.isj.metier.entites.Niveau;
import org.isj.metier.entites.Specialite;
import org.isj.metier.entites.UE;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet UE dans la base de données
 *
 * @author traitement metier
 **/
public class UEFacade extends AbstractFacade <UE> {

    public UEFacade(){
        super(UE.class);
    }
    /**
     * fonction qui permet de créer un objet UE en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param codeUE
     * @param statut
     * @param module
     * @param niveau
     * @param specialite

     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, String codeUE, UE.Statut statut, Module module, Niveau niveau, Specialite specialite,int credits){
        UE ue = new UE(libelle,description,codeUE,statut,credits,module,niveau,specialite);
        return create(ue);
    }
    /**
     * fonction qui permet de créer un objet Sms en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param codeUE
     * @param statut
     * @param module
     * @param niveau
     * @param specialite
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(UE ue, String libelle, String description, String codeUE, UE.Statut statut,int credits,Module module, Niveau niveau, Specialite specialite){
        ue.setLibelle(libelle);
        ue.setDescription(description);
        ue.setCodeUE(codeUE);
        ue.setStatut(statut);
        ue.setModule(module);
        ue.setNiveau(niveau);
        ue.setSpecialite(specialite);
        ue.setCredits(credits);
        return merge(ue);
    }

    /**
     * fonction qui permet de supprimer un objet Sms
     * @param ue
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(UE ue){
        return remove(ue);
    }

    /**
     * fonction qui permet de lister tous les objets de la table UE en BD
     * @return une liste d'objets UE
     */
    public List<UE> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets UE selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets UE
     */
    public List<UE> lister(String requete){
        return findAllNative(requete);
    }
}
