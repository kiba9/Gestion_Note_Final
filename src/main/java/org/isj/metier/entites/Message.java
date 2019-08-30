package org.isj.metier.entites;

/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Objects;
/**
 * cette classe crée la table message dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@XmlRootElement
@Table(name = "message")

public class Message extends Securite implements Serializable{

    @Column(name = "contenu")
    private String contenu;

    @Column(name = "destinataire")
    private String destinataire;

    @Column(name = "emetteur")
    private String emetteur;

    @OneToOne(mappedBy = "message",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private EnvoiMessage envoiMessage;


    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(String destinataire) {
        this.destinataire = destinataire;
    }

    public String getEmetteur() {
        return emetteur;
    }

    public void setEmetteur(String emetteur) {
        this.emetteur = emetteur;
    }

    public EnvoiMessage getEnvoiMessage() {
        return envoiMessage;
    }

    public void setEnvoiMessage(EnvoiMessage envoiMessage) {
        this.envoiMessage = envoiMessage;
    }


    public Message(String libelle, String description, String contenu, String destinataire, String emetteur) {
        super(libelle, description);
        this.contenu = contenu;
        this.destinataire = destinataire;
        this.emetteur = emetteur;
    }

    public Message(){}

    /*
    @Override
    public String getLibelle(){
        return "Message";
    }
    */

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getContenu(), getDestinataire(), getEmetteur());
    }

    @Override
    public String toString() {
        return "Message{" +
                "contenu='" + contenu + '\'' +
                ", destinataire='" + destinataire + '\'' +
                ", emetteur='" + emetteur + '\'' +
                "} ";
    }
}
