package org.isj.metier.entites;
/**
 * importation des classes
 */

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Objects;
/**
 * cette classe crée la table droit dans la base de données
 * cette classe hérite de la classe Securite
 * @author traitement metier
 */

@Entity
@Table(name = "droit")
@XmlRootElement
public class Droit extends Securite implements Serializable {

    @Column(name = "categorie", nullable = false)
    private String categorie;

    @Column(name = "lecture")
    private boolean lecture;

    @Column(name = "ecriture")
    private boolean ecriture;

    @Column(name = "modification")
    private boolean modification;

    @Column(name = "suppression", nullable = true)
    private boolean suppression;

    @ManyToOne
    @JoinColumn(name = "role")
    private Role role;

    public Droit(String libelle, String description, String categorie, boolean lecture, boolean ecriture, boolean modification, boolean suppression, Role role) {
        super(libelle, description);
        this.categorie = categorie;
        this.lecture = lecture;
        this.ecriture = ecriture;
        this.modification = modification;
        this.suppression = suppression;
        this.role = role;
    }

    public Droit(){}

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public boolean isLecture() {
        return lecture;
    }

    public void setLecture(boolean lecture) {
        this.lecture = lecture;
    }

    public boolean isEcriture() {
        return ecriture;
    }

    public void setEcriture(boolean ecriture) {
        this.ecriture = ecriture;
    }

    public boolean isModification() {
        return modification;
    }

    public void setModification(boolean modification) {
        this.modification = modification;
    }

    public boolean isSuppression() {
        return suppression;
    }

    public void setSuppression(boolean suppression) {
        this.suppression = suppression;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public String getLibelle(){
        return categorie+"-"+ suppression+"-"+modification+"-"+lecture
                +"-"+lecture+"-"+ecriture+ "-" + role.getLibelle();
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getCategorie(), isLecture(), isEcriture(), isModification(), isSuppression(), getRole());
    }

    @Override
    public String toString() {
        return "DroitFacade{" +
                "categorie='" + categorie + '\'' +
                ", lecture=" + lecture +
                ", ecriture=" + ecriture +
                ", modification=" + modification +
                ", suppression=" + suppression +
                ", role=" + role.getCode() +
                "} " ;
                //+ super.toString();
    }
}
