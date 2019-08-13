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
 * cette classe crée la table Specialite dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "specialite")

public class Specialite extends Securite implements Serializable {

    @OneToMany(mappedBy = "specialite",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <UE> ues = new ArrayList<>();

    @OneToMany(mappedBy = "specialite",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <Classe> classes = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name="filiere")
    private Filiere filiere;

    public Filiere getFiliere() {
        return filiere;
    }

    public void setFiliere(Filiere filiere) {
        this.filiere = filiere;
    }

    public Specialite() {
    }

    public Specialite(String libelle, String description, Filiere filiere) {
        super(libelle, description);
        this.filiere = filiere;
    }

    public List<UE> getUes() {
        return ues;
    }

    public void setUes(List<UE> ues) {
        this.ues = ues;
    }

    public List<Classe> getClasses() {
        return classes;
    }

    public void setClasses(List<Classe> classes) {
        this.classes = classes;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(),getFiliere());
    }

    @Override
    public String toString() {
        return getLibelle()+" - "+getFiliere();
    }


}
