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
 * cette classe crée la table classe dans la base de données
 * cette classe hérite de la classe Securite
 * @author traitement metier
 */

@XmlRootElement
@Entity
@Table(name = "classe")
public class Classe extends Securite implements Serializable {

    @OneToMany(mappedBy = "classe", fetch = FetchType.LAZY,cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List<Candidat> candidats = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "niveau")
    private Niveau niveau;

    @ManyToOne
    @JoinColumn(name = "specialite")
    private Specialite specialite;

    public Classe(String libelle, String description, Niveau niveau, Specialite specialite) {
        super(libelle, description);
        this.niveau = niveau;
        this.specialite = specialite;
    }

    public Classe(){}

    public List<Candidat> getCandidats() {
        return candidats;
    }

    public void setCandidats(List<Candidat> candidats) {
        this.candidats = candidats;
    }

    public Niveau getNiveau() {
        return niveau;
    }

    public void setNiveau(Niveau niveau) {
        this.niveau = niveau;
    }

    public Specialite getSpecialite() {
        return specialite;
    }

    public void setSpecialite(Specialite specialite) {
        this.specialite = specialite;
    }

    /**
     * creation d'une methode getLibelle
     */
    @Override
    public String getLibelle(){
        return super.getLibelle();
    }

    @Override
    public String getDescription(){
        return niveau.getDescription()+" - "+specialite.getLibelle();
    }

    /**
     * creation d'une methode hashcode
     */
    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getNiveau(), getSpecialite());
    }

    /**
     * creation d'une methode toString
     */
    @Override
    public String toString() {
        return getLibelle()+" - "+specialite.getLibelle();
    }
}
