package org.isj.metier.facade;

import org.isj.metier.entites.Session;
import org.isj.metier.entites.Utilisateur;

import java.util.Date;
import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet session dans la base de données
 *
 * @author traitement metier
 **/
public class SessionFacade extends AbstractFacade<Session> {

    public SessionFacade(){
        super(Session.class);
    }

    /**
     * fonction qui permet de créer un objet Session en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @param dateConnection
     * @param dateDeconnection
     * @param utilisateur
     * @param statut
     * @param machineCliente
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Date dateConnection, Date dateDeconnection, Session.Statut statut, String machineCliente, Utilisateur utilisateur){
        Session session = new Session(libelle,description,dateConnection,dateDeconnection,utilisateur,statut,machineCliente);
        return create(session);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Session
     * @param libelle
     * @param description
     * @param dateConnection
     * @param dateDeconnection
     * @param utilisateur
     * @param statut
     * @param machineCliente
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Session session, String libelle, String description, Date dateConnection, Date dateDeconnection, Session.Statut statut, String machineCliente,Utilisateur utilisateur){
        session.setLibelle(libelle);
        session.setDescription(description);
        session.setStatut(statut);
        session.setMachineCliente(machineCliente);
        session.setDateConnection(dateConnection);
        session.setDateDeconnection(dateDeconnection);
        session.setUtilisateur(utilisateur);
        return merge(session);
    }

    /**
     * fonction qui permet de supprimer un objet Session
     * @param session
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Session session){
        return remove(session);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Session en BD
     * @return une liste d'objets Session
     */
    public List<Session> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Session selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Session
     */
    public List<Session> lister(String requete){
        return findAllNative(requete);
    }
}
