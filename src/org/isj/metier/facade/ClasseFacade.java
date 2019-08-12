package org.isj.metier.facade;

import org.isj.metier.entites.Classe;
import org.isj.metier.entites.Niveau;
import org.isj.metier.entites.Specialite;

import java.util.List;
/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet Classe dans la base de données
 *
 * @author traitement metier
 **/

public class ClasseFacade extends AbstractFacade<Classe>{

    public ClasseFacade(){
        super(Classe.class);
    }

    /**
     * fonction qui permet de créer un objet Classe en base de données en utilisant les paramètres du constructeur
     * @param libelle
     * @param description
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */
    public String enregistrer(String libelle, String description, Niveau niveau, Specialite specialite){
        Classe classe = new Classe(libelle,description,niveau,specialite);
        return create(classe);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Classe
     * @param libelle
     * @param description
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Classe classe,String libelle,String description, Niveau niveau, Specialite specialite){
        classe.setLibelle(libelle);
        classe.setDescription(description);
        return merge(classe);
    }

    /**
     * fonction qui permet de supprimer un objet Classe
     * @param classe
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */
    public String supprimer(Classe classe){
        return remove(classe);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Anonymat en BD
     * @return une liste d'objets Classe
     */
    public List<Classe> lister(){
        return findAll();
    }

    /**
     *fonction qui permet de lister les objets Classe selon la requete passée en paramètre
     * @param requete
     * @return une liste d'objets Classe
     */
    public List<Classe> lister(String requete){
        return findAllNative(requete);
    }
}
