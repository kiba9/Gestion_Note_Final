package org.isj.metier.entites;

/**
 * importation des classes
 */
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Objects;
/**
 * cette classe crée la table email dans la base de données
 * cette classe herite de la classe Message
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "email")

public class Email extends Message implements Serializable {

    @Column(name = "objet")
    private String objet;

    public Email(String libelle, String description, String contenu, String destinataire, String emetteur, String objet) {
        super(libelle, description, contenu, destinataire, emetteur);
        this.objet = objet;
    }

    public Email(){}

    public String getObjet() {
        return objet;
    }

    public void setObjet(String objet) {
        this.objet = objet;
    }

    @Override
    public String getLibelle(){
        return "Email";
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getObjet());
    }

    @Override
    public String toString() {
        return getObjet();
    }
}
