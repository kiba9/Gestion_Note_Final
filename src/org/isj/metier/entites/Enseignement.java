package org.isj.metier.entites;


/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
/**
 * cette classe crée la table enseignement dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement

@Table(name= "enseignement")

public class Enseignement extends Securite implements Serializable {

    @Column(name = "heures_de_cours")
    private int heuresDeCours;


    @Column(name = "programme_de_cours",length = 1020)
    private String programmeDeCours;


    @ManyToOne
    @JoinColumn(name = "semestre")
    private Semestre semestre;


    @ManyToOne
    @JoinColumn(name = "ue")
    private UE ue;


    @ManyToMany(fetch = FetchType.LAZY,cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    @JoinTable(joinColumns = {@JoinColumn(name = "code_enseignement")}, inverseJoinColumns = {@JoinColumn(name = "code_enseignant")})
    private List <Enseignant> enseignants = new ArrayList<>();


    @OneToMany(mappedBy = "enseignement")
    private List<EstInscrit> estInscrits = new ArrayList<>();


    @OneToMany(mappedBy = "enseignement")
    private List<TypeEvaluation> typeEvaluations = new ArrayList<>();

    public Enseignement(String libelle, String description, int heuresDeCours, String programmeDeCours, Semestre semestre, UE ue) {
        super(libelle, description);
        this.heuresDeCours = heuresDeCours;
        this.programmeDeCours = programmeDeCours;
        this.semestre = semestre;
        this.ue = ue;
    }

    public List<TypeEvaluation> getTypeEvaluations() {
        return typeEvaluations;
    }

    public void setTypeEvaluations(List<TypeEvaluation> typeEvaluations) {
        this.typeEvaluations = typeEvaluations;
    }

    public Enseignement(){}

    public void setSemestre(Semestre semestre) {
        this.semestre = semestre;
    }

    public Semestre getSemestre() {
        return semestre;
    }
    public int getHeuresDeCours() {
        return heuresDeCours;
    }

    public void setHeuresDeCours(int heuresDeCours) {
        this.heuresDeCours = heuresDeCours;
    }

    public String getProgrammeDeCours() {
        return programmeDeCours;
    }

    public void setProgrammeDeCours(String programmeDeCours) {
        this.programmeDeCours = programmeDeCours;
    }

    public UE getUe() {
        return ue;
    }

    public void setUe(UE ue) {
        this.ue = ue;
    }

    public List<Enseignant> getEnseignants() {
        return enseignants;
    }

    public void setEnseignants(List<Enseignant> enseignants) {
        this.enseignants = enseignants;
    }

    public List<EstInscrit> getEstInscrits() {
        return estInscrits;
    }

    public void setEstInscrits(List<EstInscrit> estInscrits) {
        this.estInscrits = estInscrits;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getHeuresDeCours(), getProgrammeDeCours(), getUe());
    }

    @Override
    public String toString() {
        return getLibelle();
    }
}
