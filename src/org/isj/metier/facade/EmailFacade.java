package org.isj.metier.facade;

import org.isj.metier.entites.Email;
import org.isj.metier.entites.EnvoiMessage;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet anneeAcademique dans la base de données
 *
 * @author traitement metier
 **/
public class EmailFacade extends AbstractFacade<Email> {

    public EmailFacade(){
        super(Email.class);
    }

    /**
     * fonction qui permet de créer un objet Email en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     * @param objet
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, String contenu, String destinataire, String emetteur,String objet){
        Email email = new Email(libelle,description,contenu,destinataire,emetteur,objet);
        return create(email);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Email
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     * @param objet
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Email email,String libelle,String description,String contenu,String destinataire,String emetteur,String objet, EnvoiMessage envoiMessage){
        email.setLibelle(libelle);
        email.setDescription(description);
        email.setContenu(contenu);
        email.setDestinataire(destinataire);
        email.setEmetteur(emetteur);
        email.setObjet(objet);
        email.setEnvoiMessage(envoiMessage);
        return merge(email);
    }

    /**
     * fonction qui permet de supprimer un objet email
     * @param email
     * @return
     */

    public String supprimer(Email email){
        return remove(email);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Email en BD
     * @return une liste d'objets Email
     */

    public List<Email> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Email selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Email
     */
    public List<Email> lister(String requete){
        return findAllNative(requete);
    }
}
