package org.isj.metier.entites;
/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;
/**
 * cette classe crée la table discipline dans la base de donnée
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "discipline")
public class Discipline extends Securite implements Serializable {

    @ManyToOne
    @JoinColumn(name="etudiant")
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "semestre")
    private Semestre semestre;

    @Column(name="nb_heures_absences")
    private int nbHeures;

    @Column(name="nb_retards")
    private int nbRetards;

    @Column(name="date_retard")
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date dateRetard;

    @Column(name="heure_justifie")
    private int heureJustifie;



    public Discipline(String libelle, String description, Etudiant etudiant, Semestre semestre, int nbHeures, int nbRetards, Date dateRetard, int heureJustifie) {
        super(libelle, description);
        this.etudiant = etudiant;
        this.semestre = semestre;
        this.nbHeures = nbHeures;
        this.nbRetards = nbRetards;
        this.dateRetard = dateRetard;
        this.heureJustifie = heureJustifie;
    }

    public Discipline(){}

    public Etudiant getEtudiant() {
        return etudiant;
    }

    public void setEtudiant(Etudiant etudiant) {
        this.etudiant = etudiant;
    }

    public Semestre getSemestre() {
        return semestre;
    }

    public void setSemestre(Semestre semestre) {
        this.semestre = semestre;
    }

    public int getNbHeures() {
        return nbHeures;
    }

    public void setNbHeures(int nbHeures) {
        this.nbHeures = nbHeures;
    }

    public int getNbRetards() {
        return nbRetards;
    }

    public void setNbRetards(int nbRetards) {
        this.nbRetards = nbRetards;
    }

    public Date getDateRetard() {
        return dateRetard;
    }

    public void setDateRetard(Date dateRetard) {
        this.dateRetard = dateRetard;
    }

    @Override
    public String getLibelle(){
        return etudiant.getNom()+"-"+ etudiant.getPrenom()+"-"+nbHeures+ "-" +nbRetards+ "-" +dateRetard;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getEtudiant(), getSemestre(), getNbHeures(), getNbRetards(), getDateRetard(), getHeureJustifie());
    }

    public int getHeureJustifie() {
        return heureJustifie;
    }

    public void setHeureJustifie(int heureJustifie) {
        this.heureJustifie = heureJustifie;
    }

    @Override
    public String toString() {
        return "Discipline{" +
                "etudiant=" + etudiant.toString() +
                ", semestre=" + semestre.toString() +
                ", nbHeures=" + nbHeures +
                ", nbRetards=" + nbRetards +
                ", dateRetards=" + dateRetard +
                ", heureJustifie=" + heureJustifie +
                "} " ;
    }
}
