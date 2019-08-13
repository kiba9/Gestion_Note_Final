package org.isj.metier.entites;

/**
 * importation des classes
 */

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
/**
 * cette classe crée la table Semestre dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "semestre")
public class Semestre extends Securite implements Serializable {

    @Column(name = "date_debut")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateDebut;

    @Column(name= "date_cloture")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCloture;

    @OneToMany(mappedBy = "semestre",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Discipline> disciplines = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "annee_academique")
    private AnneeAcademique anneeAcademique;

    @OneToMany(mappedBy = "semestre",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Enseignement> enseignements;

    public Semestre(String libelle, String description, Date dateDebut, Date dateCloture, AnneeAcademique anneeAcademique) {
        super(libelle, description);
        this.dateDebut = dateDebut;
        this.dateCloture = dateCloture;
        this.anneeAcademique = anneeAcademique;
    }

    public Semestre(){}

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateCloture() {
        return dateCloture;
    }

    public void setDateCloture(Date dateCloture) {
        this.dateCloture = dateCloture;
    }

    public List<Discipline> getDisciplines() {
        return disciplines;
    }

    public void setDisciplines(List<Discipline> disciplines) {
        this.disciplines = disciplines;
    }

    public AnneeAcademique getAnneeAcademique() {
        return anneeAcademique;
    }

    public void setAnneeAcademique(AnneeAcademique anneeAcademique) {
        this.anneeAcademique = anneeAcademique;
    }

    @Override
    public String getLibelle(){
        return super.getLibelle();
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(),getDateDebut(), getDateCloture());
    }

    @Override
    public String toString() {
        return super.getDescription();
    }
}
