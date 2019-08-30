package org.isj.metier.facade;

import org.isj.metier.entites.Message;

import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Message dans la base de données
 *
 * @author traitement metier
 **/
public class MessageFacade extends AbstractFacade<Message> {

    public MessageFacade(){
        super(Message.class);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Message
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, String contenu, String destinataire, String emetteur){
        Message message = new Message(libelle,description,contenu,destinataire,emetteur);
        return create(message);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Message
     * @param libelle
     * @param description
     * @param contenu
     * @param destinataire
     * @param emetteur
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Message message,String libelle,String description,String contenu,String destinataire,String emetteur){
        message.setLibelle(libelle);
        message.setDescription(description);
        message.setContenu(contenu);
        message.setDestinataire(destinataire);
        message.setEmetteur(emetteur);
        return merge(message);
    }
    /**
     * fonction qui permet de supprimer un objet Message
     * @param message
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Message message){
        return remove(message);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Message en BD
     * @return une liste d'objets Message
     */
    public List<Message> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Message selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Message
     */
    public List<Message> lister(String requete){
        return findAllNative(requete);
    }
}
