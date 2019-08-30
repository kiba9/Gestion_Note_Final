package org.isj.metier.facade;

import org.isj.metier.entites.Module;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Module dans la base de donnée
 *
 * @author traitement metier
 **/

public class ModuleFacade extends AbstractFacade <Module> {

    public ModuleFacade(){
        super(Module.class);
    }
    /**
     * fonction qui permet de mettre à jour les champs de l'objet Module
     * @param libelle
     * @param description
     * @param codeModule
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, String codeModule){
        Module module = new Module(libelle,description,codeModule);
        return create(module);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Module
     * @param libelle
     * @param description
     *
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Module module,String libelle,String description, String codeModule){
        module.setLibelle(libelle);
        module.setDescription(description);
        module.setCodeModule(codeModule);
        return merge(module);
    }

    /**
     * fonction qui permet de supprimer un objet Module
     * @param module
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Module module){
        return remove(module);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Module en BD
     * @return une liste d'objets Module
     */
    public List<Module> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Module selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Module
     */
    public List<Module> lister(String requete){
        return findAllNative(requete);
    }
}
