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
 * cette classe crée la table evaluation dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name ="evaluation")

public class Evaluation extends Securite implements Serializable {

    @Column(name = "date_evaluation")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateEvaluation;

    public enum Statut {
        ACTIVE, NONACTIVE
    }


    @Column(name = "statut",nullable = false)
    @Enumerated(EnumType.STRING)
    public Statut statut;

    @ManyToOne
    @JoinColumn(name = "type_evaluation")
    private TypeEvaluation typeEvaluation;

    @OneToMany(mappedBy = "evaluation",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Anonymat> anonymats = new ArrayList<>();

    @OneToMany(mappedBy = "evaluation",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Note> notes = new ArrayList<>();

    public Evaluation(String libelle, String description, Date dateEvaluation, Statut statut, TypeEvaluation typeEvaluation) {
        super(libelle, description);
        this.dateEvaluation = dateEvaluation;
        this.statut = statut;
        this.typeEvaluation = typeEvaluation;
    }

    public Evaluation(){}

    public Date getDateEval() {
        return dateEvaluation;
    }

    public void setDateEval(Date dateEvaluation) {
        this.dateEvaluation = dateEvaluation;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public TypeEvaluation getTypeEvaluation() {
        return typeEvaluation;
    }

    public void setTypeEvaluation(TypeEvaluation typeEvaluation) {
        this.typeEvaluation = typeEvaluation;
    }


    public List<Anonymat> getAnonymats() {
        return anonymats;
    }

    public void setAnonymats(List<Anonymat> anonymats) {
        this.anonymats = anonymats;
    }

    public List<Note> getNotes() {
        return notes;
    }

    public void setNotes(List<Note> notes) {
        this.notes = notes;
    }

    /*@Override
    public String getLibelle(){
        return dateEvaluation +"-"+ typeEvaluation.getLibelle()+"-"+statut;
    }*/

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getDateEval(), getStatut(), getTypeEvaluation());
    }

    @Override
    public String toString() {
        return getTypeEvaluation().getLibelle()+" - "+getTypeEvaluation().getEnseignement().getUe();
    }
}
