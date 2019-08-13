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
 * cette classe crée la table module dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "Module")

public class Module extends Securite implements Serializable {

    @Column(name= "code_module")
    private String codeModule;

    public String getCodeModule() {
        return codeModule;
    }

    public void setCodeModule(String codeModule) {
        this.codeModule = codeModule;
    }

    @OneToMany(mappedBy = "module",fetch = FetchType.LAZY,cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List<UE> ues = new ArrayList<>();

    public List<UE> getUes() {
        return ues;
    }

    public void setUes(List<UE> ues) {
        this.ues = ues;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getCodeModule());
    }

    @Override
    public String toString() {
        return getCodeModule()+" - "+getLibelle();
    }

    public Module(String libelle, String description, String codeModule) {
        super(libelle, description);
        this.codeModule = codeModule;
    }

    public Module(){}
}
