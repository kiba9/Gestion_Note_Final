package org.isj.metier.facade;

import org.isj.metier.entites.Role;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Role dans la base de donnée
 *
 * @author traitement metier
 **/
public class RoleFacade extends AbstractFacade<Role> {

    public RoleFacade(){
        super(Role.class);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Role
     * @param libelle
     * @param description
     *
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle,String description){
        Role role = new Role(libelle,description);
        return create(role);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Role
     * @param libelle
     * @param description
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Role role,String libelle,String description){
        role.setLibelle(libelle);
        role.setDescription(description);
        return merge(role);
    }

    /**
     * fonction qui permet de supprimer un objet
     * @param role
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Role role){
        return remove(role);
    }

    /**
     * fonction qui permet de lister tous les objets Role de la table Module en BD
     * @return une liste d'objets Role
     */
    public List<Role> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Role selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Role
     */
    public List<Role> lister(String requete){
        return findAllNative(requete);
    }
}
