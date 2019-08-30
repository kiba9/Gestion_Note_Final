package org.isj.metier.entites;

/**
 * importation des classes
 */

import org.apache.commons.lang.builder.HashCodeBuilder;

import javax.persistence.*;
import java.util.Date;
import java.util.Objects;
/**
 * cette classe est une superclasse à partir de laquelle héritent toutes les classes du projet
 * @author traitement metier
 */

@MappedSuperclass
public class Securite {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name="code")
    private Long code;


    public enum StatutVie {

        ATTENTE, ACTIVE, CLOTUREE
    }


    @Column(name="libelle")
    private String libelle;

    @Column(name="description")
    private String description;

    @Column(name="signature", unique = true)
    private String signature;

    @Column(name="statut_vie", nullable = false)
    @Enumerated(EnumType.STRING)
    private StatutVie statutVie;

    @JoinColumn(name = "createur",nullable = false)
    @ManyToOne(fetch = FetchType.LAZY,cascade={  CascadeType.MERGE,CascadeType.REFRESH})
    private Utilisateur createur;

    @Column(name = "date_creation",nullable = false)
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date dateCreation;

    @JoinColumn(name = "modificateur",nullable = false)
    @ManyToOne(fetch = FetchType.LAZY,cascade={  CascadeType.MERGE,CascadeType.REFRESH})
    private Utilisateur modificateur;

    @Column(name = "date_modification",nullable = false)
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date dateModification;

    public Securite(String libelle, String description) {
        this.libelle = libelle;
        this.description = description;
    }

    public Securite(){}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Securite securite = (Securite) o;
        return code.equals(securite.code);
    }

    @Override
    public int hashCode() {
       return new HashCodeBuilder(17, 37).
               append(createur).
               append(dateCreation).
               append(code).
               toHashCode();
    }
/*@Override
    public int hashCode() {
        return Objects.hash(getCode(),getDateCreation());
    }*/

    public Long getCode() {
        return code;
    }

    public void setCode(Long code) {
        this.code = code;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        //this.signature = signature;
        this.signature=String.valueOf(this.hashCode());
    }

    public StatutVie getStatutVie() {
        return statutVie;
    }

    public void setStatutVie(StatutVie statutVie) {
        this.statutVie = statutVie;
    }

    public Utilisateur getCreateur() {
        return createur;
    }

    public void setCreateur(Utilisateur createur) {
        this.createur = createur;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    public Utilisateur getModificateur() {
        return modificateur;
    }

    public void setModificateur(Utilisateur modificateur) {
        this.modificateur = modificateur;
    }

    public Date getDateModification() {
        return dateModification;
    }

    public void setDateModification(Date dateModification) {
        this.dateModification = dateModification;
    }

/*
    public String toString() {
        return "Securite{" +
                "code=" + code +
                ", libelle='" + libelle + '\'' +
                ", description='" + description + '\'' +
                ", signature='" + signature + '\'' +
                ", statutVie=" + statutVie +
                ", createur=" + createur +
                ", dateCreation=" + dateCreation +
                ", modificateur=" + modificateur +
                ", dateModification=" + dateModification +
                '}';
    }*/
}
