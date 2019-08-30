package org.isj.metier.entites;

/**
 * importation des classes
 */
import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;
/**
 * cette classe crée la table Session dans la base de données
 * cette classe herite de la classe Securite
 * @author traitement metier
 */

@Entity
@XmlRootElement
@Table(name = "Session")

public class Session extends Securite implements Serializable {

    public enum Statut{
        ACTIF,NONACTIF
    }

    @Column(name = "date_connection")
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date dateConnection;

    @Column(name = "date_deconnection")
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date dateDeconnection;

    @ManyToOne
    @JoinColumn(name = "utilisateur")
    private Utilisateur utilisateur;

    @Column(name = "statut",nullable = false)
    @Enumerated(EnumType.STRING)
    private Statut statut;

    @Column(name="machine_cliente")
    private String machineCliente;

    public Session(String libelle, String description, Date dateConnection, Date dateDeconnection, Utilisateur utilisateur, Statut statut, String machineCliente) {
        super(libelle, description);
        this.dateConnection = dateConnection;
        this.dateDeconnection = dateDeconnection;
        this.utilisateur = utilisateur;
        this.statut = statut;
        this.machineCliente = machineCliente;
    }

    public Session(){}

    public Date getDateConnection() {
        return dateConnection;
    }

    public void setDateConnection(Date dateConnection) {
        this.dateConnection = dateConnection;
    }

    public Date getDateDeconnection() {
        return dateDeconnection;
    }

    public void setDateDeconnection(Date dateDeconnection) {
        this.dateDeconnection = dateDeconnection;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public String getMachineCliente() {
        return machineCliente;
    }

    public void setMachineCliente(String machineCliente) {
        this.machineCliente = machineCliente;
    }

    @Override
    public String getLibelle(){
        return dateConnection + "-" + dateDeconnection + "-" + utilisateur.getLibelle() + "-"+ machineCliente +"-"+statut;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getDateConnection(), getDateDeconnection(), getUtilisateur(), getStatut(), getMachineCliente());
    }

    @Override
    public String toString() {
        return "Session{" +
                "dateConnection=" + dateConnection +
                ", dateDeconnection=" + dateDeconnection +
                ", utilisateur=" + utilisateur.toString() +
                ", statut=" + statut +
                ", machineCliente='" + machineCliente + '\'' +
                "} " + super.toString();
    }
}
