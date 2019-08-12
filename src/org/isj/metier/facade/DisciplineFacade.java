package org.isj.metier.facade;

import org.isj.metier.entites.Discipline;
import org.isj.metier.entites.Etudiant;
import org.isj.metier.entites.Semestre;

import java.util.Date;
import java.util.List;

/**
 * cette classe permet de créer, lire, supprimer et mettre à jour un objet CandidatController dans la base de donnée
 *
 * @author traitement metier
 **/

public class DisciplineFacade extends AbstractFacade<Discipline> {

    public DisciplineFacade() {
        super(Discipline.class);
    }

    /**
     * fonction qui permet de créer un objet Discipline en base de données en utilisant les paramètres du constructeur
     *
     * @param libelle
     * @param description
     * @param nbHeures
     * @param nbRetards
     * @param etudiant
     * @param semestre
     * @param dateRetard
     * @param heureJustifie
     * @return la chaine des caractères succes si la création est une réussite et echec sinon
     */

    public String enregistrer(String libelle, String description, int nbHeures, int nbRetards, Etudiant etudiant, Semestre semestre, Date dateRetard, int heureJustifie) {
        Discipline discipline = new Discipline(libelle, description, etudiant, semestre, nbHeures, nbRetards, dateRetard, heureJustifie);
        return create(discipline);
    }

    /**
     * fonction qui permet de mettre à jour les champs de l'objet Discipline
     *
     * @param libelle
     * @param description
     * @param nbHeures
     * @param nbRetards
     * @param etudiant
     * @param semestre
     * @param dateRetard
     * @param heureJustifie
     * @return la chaine des caractères succes si la modification est une réussite et echec sinon
     */
    public String modifier(Discipline discipline, String libelle, String description, int nbHeures, int nbRetards, Etudiant etudiant, Semestre semestre, Date dateRetard, int heureJustifie) {
        discipline.setLibelle(libelle);
        discipline.setDescription(description);
        discipline.setNbHeures(nbHeures);
        discipline.setNbRetards(nbRetards);
        discipline.setEtudiant(etudiant);
        discipline.setSemestre(semestre);
        discipline.setDateRetard(dateRetard);
        discipline.setHeureJustifie(heureJustifie);
        return merge(discipline);
    }

    /**
     * fonction qui permet de supprimer un objet Discipline
     *
     * @param discipline
     * @return la chaine des caractères succes si la suppression est une réussite et echec sinon
     */

    public String supprimer(Discipline discipline) {
        return remove(discipline);
    }

    /**
     * fonction qui permet de lister tous les objets de la table Discipline en BD
     *
     * @return une liste d'objets Discipline
     */
    public List<Discipline> lister() {
        return findAll();
    }

    /**
     * fonction qui permet de lister les objets Discipline selon la requete passée en paramètre
     *
     * @param requete
     * @return une liste d'objets Discipline
     */
    public List<Discipline> lister(String requete) {
        return findAllNative(requete);
    }
}
