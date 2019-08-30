package org.isj.metier.facade;

import org.isj.metier.entites.Sms;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Sms dans la base de données
 *
 * @author traitement metier
 **/

public class SmsFacade extends AbstractFacade<Sms> {

    public SmsFacade(){
        super(Sms.class);
    }

    /**
     * fonction qui permet de créer un objet Sms en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, String contenu, String destinataire, String emetteur) {
        Sms sms = new Sms(libelle,description,contenu,destinataire,emetteur);
        return create(sms);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Sms
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String modifier(Sms sms,String libelle,String description,String contenu,String destinataire,String emetteur){
        sms.setLibelle(libelle);
        sms.setDescription(description);
        sms.setContenu(contenu);
        sms.setDestinataire(destinataire);
        sms.setEmetteur(emetteur);
        return merge(sms);
    }

    /**
     * fonction qui permet de supprimer un objet Sms
     * @param sms
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String supprimer(Sms sms){
        return remove(sms);
    }

    /**
     * fonction qui permet de lister tous les objets Sms de la table Session en BD
     * @return une liste d'objets session
     */
    public List<Sms> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Sms selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Sms
     */
    public List<Sms> lister(String requete){
        return findAllNative(requete);
    }
}
