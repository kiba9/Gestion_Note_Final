package org.isj.metier.facade;

import org.isj.metier.entites.Niveau;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Niveau dans la base de données
 *
 * @author traitement metier
 **/

public class NiveauFacade extends AbstractFacade <Niveau> {

    public NiveauFacade(){
        super(Niveau.class);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Niveau
     * @param libelle
     * @param description
     * @param numero
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle,String description,int numero){
        Niveau niveau = new Niveau(libelle,description,numero);
        return create(niveau);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Niveau
     * @param libelle
     * @param description
     * @param numero
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Niveau niveau,String libelle,String description,int numero){
        niveau.setLibelle(libelle);
        niveau.setDescription(description);
        niveau.setNumero(numero);
        return merge(niveau);
    }

    /**
     * fonction qui permet de supprimer un objet Niveau
     * @param niveau
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Niveau niveau){
        return remove(niveau);
    }

    /**
     * fonction qui permet de lister tous les objets Niveau de la table Module en BD
     * @return une liste d'objets Niveau
     */
    public List<Niveau> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Niveau selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Niveau
     */
    public List<Niveau> lister(String requete){
        return findAllNative(requete);
    }

}
