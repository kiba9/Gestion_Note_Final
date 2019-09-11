package org.isj.metier.entites;

/**
 * importation des classes
 */

import org.isj.metier.facade.AbstractFacade;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
/**
 * cette classe crée la table etudiant dans la base de données
 * cette classe herite de la classe CandidatController
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "etudiant")
public class Etudiant extends Candidat implements Serializable {

    @Column(name = "matricule")
    private String matricule;

    @Column(name = "code_authentification")
    private String codeAuthentification;

    @OneToMany(mappedBy = "etudiant",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Discipline> disciplines = new ArrayList<>();

    public Etudiant(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Sexe sexe, Statut statut, String nomDeLaMere, String nomDuPere, int telephoneDeLaMere, int telephoneDuPere, String professionDuPere, String professionDelaMere, String regionOrigine, String ecoleOrigine, Classe classe, String matricule, String codeAuthentification) {
        super(libelle, description, nom, prenom, email, telephone, dateNaissance, sexe, statut, nomDeLaMere, nomDuPere, telephoneDeLaMere, telephoneDuPere, professionDuPere, professionDelaMere, regionOrigine, ecoleOrigine, classe);
        this.matricule = matricule;
        this.codeAuthentification = codeAuthentification;
    }

    public Etudiant(){}

    public String getMatricule() {
        if(matricule==null)
            matricule= AbstractFacade.getMatricule(getCode());
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getCodeAuthentification() {

        if(codeAuthentification==null)
            codeAuthentification=AbstractFacade.getCodeAuthentification(getCode());
        return codeAuthentification;
    }

    public void setCodeAuthentification(String codeAuthentification) {
        this.codeAuthentification = codeAuthentification;
    }

    public List<Discipline> getDisciplines() {
        return disciplines;
    }

    public void setDisciplines(List<Discipline> disciplines) {
        this.disciplines = disciplines;
    }

    @Override
    public String getLibelle(){
        return matricule +"-" + super.getLibelle();
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.getCode(), getMatricule(), getCodeAuthentification());
    }

    @Override
    public String toString() {
        return getNom()+" "+getPrenom()+" "+matricule;
    }
}
