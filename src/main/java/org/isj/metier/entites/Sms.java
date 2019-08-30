package org.isj.metier.entites;

/**
 * importation des classes
 */
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
/**
 * cette classe crée la table Sms dans la base de données
 * cette classe herite de la classe message
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "Sms")
public class Sms extends Message implements Serializable {

    @Override
    public String toString() {
        return "Sms{} " + super.toString();
    }

    public Sms(String libelle, String description, String contenu, String destinataire, String emetteur) {
        super(libelle, description, contenu, destinataire, emetteur);
    }

    public Sms() {
    }

    @Override
    public String getLibelle(){
        return "Sms";
    }

}
