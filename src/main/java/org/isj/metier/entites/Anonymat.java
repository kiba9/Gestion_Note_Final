package org.isj.metier.entites;
/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Objects;

/**
 * cette classe crée la table annonymat dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */
@Entity
@XmlRootElement
@Table(name = "anonymat")
public class Anonymat extends Securite implements Serializable {

    @Column(name = "numero_anonymat")
    private int numeroAnonymat;

    @OneToOne
    @JoinColumn(name = "note")
    private Note note;

    @ManyToOne
    @JoinColumn(name = "evaluation")
    private Evaluation evaluation;

    @OneToOne
    @JoinColumn(name = "est_inscrit")
    private EstInscrit estInscrit;

    @Column(name = "numero_table")
    private int numeroTable;

    public Anonymat(String libelle, String description, int numeroAnonymat, Note note, Evaluation evaluation, EstInscrit estInscrit, int numeroTable) {
        super(libelle, description);
        this.numeroAnonymat = numeroAnonymat;
        this.note = note;
        this.evaluation = evaluation;
        this.estInscrit = estInscrit;
        this.numeroTable = numeroTable;
    }

    public Anonymat(){}

    public int getNumeroAnonymat() {
        return numeroAnonymat;
    }

    public void setNumeroAnonymat(int numeroAnonymat) {
        this.numeroAnonymat = numeroAnonymat;
    }

    public EstInscrit getEstInscrit() {
        return estInscrit;
    }

    public void setEstInscrit(EstInscrit estInscrit) {
        this.estInscrit = estInscrit;
    }

    public int getNumeroTable() {
        return numeroTable;
    }

    public void setNumeroTable(int numeroTable) {
        this.numeroTable = numeroTable;
    }

    public Note getNote() {
        return note;
    }


    public void setNote(Note note) {
        this.note = note;
    }

    public Evaluation getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(Evaluation evaluation) {
        this.evaluation = evaluation;
    }

    @Override
    public String getLibelle(){
        return numeroAnonymat +
                "-" + note.getLibelle();
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getNumeroAnonymat(),getNumeroTable(), getNote(), getEstInscrit(), getEvaluation());
    }

    @Override
    public String toString() {
        return ""+ numeroAnonymat;
    }
}
