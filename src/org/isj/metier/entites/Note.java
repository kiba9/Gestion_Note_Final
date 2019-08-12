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
 * cette classe crée la table note dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "note")

public class Note extends Securite implements Serializable {

    @Column(name = "valeur_note", nullable = false)
    private double valeurNote;

    @Column(name = "numero_table")
    private int numeroTable;

    @OneToMany(mappedBy = "note",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <HistoriqueNote> historiqueNotes = new ArrayList<>();

    @OneToOne(mappedBy = "note",cascade = {CascadeType.REFRESH,CascadeType.MERGE})
    private Anonymat anonymat;

    @OneToOne
    @JoinColumn(name="est_inscrit")
    private EstInscrit estInscrit;

    @ManyToOne
    @JoinColumn(name = "evaluation")
    private Evaluation evaluation;

    public Note(String libelle, String description, double valeurNote, int numeroTable, Anonymat anonymat, EstInscrit estInscrit, Evaluation evaluation) {
        super(libelle, description);
        this.valeurNote = valeurNote;
        this.numeroTable = numeroTable;
        this.anonymat = anonymat;
        this.estInscrit = estInscrit;
        this.evaluation = evaluation;
    }

    public Note(){}
    public double getValeurNote() {
        return valeurNote;
    }

    public void setValeurNote(double valeurNote) {
        this.valeurNote = valeurNote;
    }

    public List<HistoriqueNote> getHistoriqueNotes() {
        return historiqueNotes;
    }

    public void setHistoriqueNotes(List<HistoriqueNote> historiqueNotes) {
        this.historiqueNotes = historiqueNotes;
    }

    public Anonymat getAnonymat() {
        return anonymat;
    }

    public void setAnonymat(Anonymat anonymat) {
        this.anonymat = anonymat;
    }

    public EstInscrit getEstInscrit() {
        return estInscrit;
    }

    public void setEstInscrit(EstInscrit estInscrit) {
        this.estInscrit = estInscrit;
    }

    public Evaluation getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(Evaluation evaluation) {
        this.evaluation = evaluation;
    }

    public int getNumeroTable() {
        return numeroTable;
    }

    public void setNumeroTable(int numeroTable) {
        this.numeroTable = numeroTable;
    }

    /*@Override
    public String getLibelle(){
        return evaluation.getLibelle() + "-" + valeurNote + "-" + numeroTable + "-"+
                estInscrit.getLibelle()+"-"+anonymat;
    }*/

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getValeurNote(), getEvaluation(), getNumeroTable(), getEstInscrit());
    }

    @Override
    public String toString() {
        return valeurNote+"";
    }
}
