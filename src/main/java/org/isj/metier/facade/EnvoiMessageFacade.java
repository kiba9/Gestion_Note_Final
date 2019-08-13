package org.isj.metier.facade;

import org.isj.metier.entites.Candidat;
import org.isj.metier.entites.EnvoiMessage;
import org.isj.metier.entites.Message;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet EnvoiMessage dans la base de données
 *
 * @author traitement metier
 **/

public class EnvoiMessageFacade extends AbstractFacade <EnvoiMessage> {

    public EnvoiMessageFacade(){
        super(EnvoiMessage.class);
    }

    /**
     * fonction qui permet de créer un objet EnvoiMessage en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param dateEnvoi
     * @param statut
     * @param message
     * @param candidat
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Date dateEnvoi, EnvoiMessage.Statut statut, Message message, Candidat candidat){
        EnvoiMessage envoiMessage = new EnvoiMessage(libelle,description,dateEnvoi,statut,message, candidat);
        return create(envoiMessage);
    }

    /**
     * fonction qui permet de créer un objet EnvoiMessage en base de données en utilisant les paramètres du constructeur
     * @param envoiMessage
     * @param libelle
     * @param description
     * @param dateEnvoi
     * @param statut
     * @param message
     * @param candidat
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(EnvoiMessage envoiMessage, String libelle, String description, Date dateEnvoi, EnvoiMessage.Statut statut,Message message, Candidat candidat){
        envoiMessage.setLibelle(libelle);
        envoiMessage.setDescription(description);
        envoiMessage.setDateEnvoi(dateEnvoi);
        envoiMessage.setStatut(statut);
        envoiMessage.setCandidat(candidat);
        envoiMessage.setMessage(message);
        return merge(envoiMessage);
    }

    /**
     * fonction qui permet de supprimer un objet EnvoiMessage
     * @param envoiMessage
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String supprimer(EnvoiMessage envoiMessage){
        return remove(envoiMessage);
    }

    /**
     * fonction qui permet de lister tous les objets de la table EnvoiMessage en BD
     * @return une liste d'objets EnvoiMessage
     */

    public List<EnvoiMessage> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets EnvoiMessage selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets EnvoiMessage
     */

    public List<EnvoiMessage> lister(String requete){
        return findAllNative(requete);
    }
}
