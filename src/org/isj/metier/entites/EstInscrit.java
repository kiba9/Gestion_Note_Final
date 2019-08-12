package org.isj.metier.entites;

/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Objects;
/**
 * cette classe crée la table est_inscrit dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */


@Entity
@XmlRootElement
@Table(name = "est_inscrit")

public class EstInscrit extends Securite implements Serializable {

   public enum Statut {
       VALIDE, NONVALIDE
   }

    @Column(name = "statut")
    @Enumerated(EnumType.STRING)
    private Statut statut;

    @ManyToOne
    @JoinColumn(name = "candidat_inscrit")
    private Candidat candidatInscrit;

    /*@OneToOne(mappedBy = "estInscrit")
    private Note note;

    @OneToOne(mappedBy = "estInscrit")
    private Anonymat anonymat;*/

    @ManyToOne
    @JoinColumn(name="enseignement")
    private Enseignement enseignement;

    public EstInscrit(String libelle, String description, Statut statut, Candidat candidatInscrit, Enseignement enseignement) {
        super(libelle, description);
        this.statut = statut;
        this.candidatInscrit = candidatInscrit;
        this.enseignement = enseignement;
    }

    public  EstInscrit(){}

    public EstInscrit.Statut getStatut() {
        return statut;
    }

    public void setStatut(EstInscrit.Statut statut) {
        this.statut = statut;
    }

    public Candidat getCandidatInscrit() {
        return candidatInscrit;
    }

    public void setCandidatInscrit(Candidat candidatInscrit) {
        this.candidatInscrit = candidatInscrit;
    }

    /*public Note getNote() {
        return note;
    }

    public void setNote(Note note) {
        this.note = note;
    }*/

    public Enseignement getEnseignement() {
        return enseignement;
    }

    public void setEnseignement(Enseignement enseignement) {
        this.enseignement = enseignement;
    }

    /*@Override
    public String getLibelle(){
        return candidatInscrit.getLibelle() +"-" +enseignement.getLibelle()+ "-"+statut
                +"-"+ note.getLibelle();
                 {
        return Objects.hash(super.hashCode(), getNiveau(), getSpecialite());
    }*/

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getEnseignement(), getCandidatInscrit());
    }

    @Override
    public String toString() {
        return candidatInscrit.getNom()+" "+ candidatInscrit.getPrenom() + "-"+enseignement.getLibelle();
    }
}
