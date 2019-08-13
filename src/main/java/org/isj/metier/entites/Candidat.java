package org.isj.metier.entites;
/**
 * importation des classes
 */

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
/**
 * cette classe crée la table candidat dans la base de données
 * cette classe herite de la classe Personne
 * @author traitement metier
 */
@Inheritance(strategy = InheritanceType.JOINED)
@Entity
@XmlRootElement
@Table(name = "candidat")
public class Candidat extends Personne implements Serializable {

    @Column(name = "nom_de_la_mere")
    private String nomDeLaMere;

    @Column(name= "nom_du_pere")
    private String nomDuPere;

    @Column(name= "telephone_de_la_mere")
    private int telephoneDeLaMere;

    @Column(name= "telephone_du_pere")
    private int telephoneDuPere;

    @Column(name= "profession_du_pere")
    private String professionDuPere;

    @Column(name= "profession_de_la_mere")
    private String professionDelaMere;

    @Column(name= "region_origine")
    private String regionOrigine;

    @Column(name= "ecole_origine")
    private String ecoleOrigine;

    @ManyToOne
    @JoinColumn(name = "classe")
    private Classe classe;

    @OneToMany(mappedBy = "candidat",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <EnvoiMessage> envoiMessages = new ArrayList<>();

    @OneToMany(mappedBy = "candidatInscrit",cascade = {CascadeType.REFRESH,CascadeType.PERSIST,CascadeType.MERGE})
    private List <EstInscrit> estInscrits = new ArrayList<>();

    public Candidat(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Sexe sexe, Statut statut, String nomDeLaMere, String nomDuPere, int telephoneDeLaMere, int telephoneDuPere, String professionDuPere, String professionDelaMere, String regionOrigine, String ecoleOrigine, Classe classe) {
        super(libelle, description, nom, prenom, email, telephone, dateNaissance, sexe, statut);
        this.nomDeLaMere = nomDeLaMere;
        this.nomDuPere = nomDuPere;
        this.telephoneDeLaMere = telephoneDeLaMere;
        this.telephoneDuPere = telephoneDuPere;
        this.professionDuPere = professionDuPere;
        this.professionDelaMere = professionDelaMere;
        this.regionOrigine = regionOrigine;
        this.ecoleOrigine = ecoleOrigine;
        this.classe = classe;
    }

    public Candidat(){}

    public String getNomDeLaMere() {
        return nomDeLaMere;
    }

    public void setNomDeLaMere(String nomDeLaMere) {
        this.nomDeLaMere = nomDeLaMere;
    }

    public String getNomDuPere() {
        return nomDuPere;
    }

    public void setNomDuPere(String nomDuPere) {
        this.nomDuPere = nomDuPere;
    }

    public int getTelephoneDeLaMere() {
        return telephoneDeLaMere;
    }

    public void setTelephoneDeLaMere(int telephoneDeLaMere) {
        this.telephoneDeLaMere = telephoneDeLaMere;
    }

    public int getTelephoneDuPere() {
        return telephoneDuPere;
    }

    public void setTelephoneDuPere(int telephoneDuPere) {
        this.telephoneDuPere = telephoneDuPere;
    }

    public String getProfessionDuPere() {
        return professionDuPere;
    }

    public void setProfessionDuPere(String professionDuPere) {
        this.professionDuPere = professionDuPere;
    }

    public String getProfessionDelaMere() {
        return professionDelaMere;
    }

    public void setProfessionDelaMere(String professionDelaMere) {
        this.professionDelaMere = professionDelaMere;
    }

    public String getRegionOrigine() {
        return regionOrigine;
    }

    public void setRegionOrigine(String regionOrigine) {
        this.regionOrigine = regionOrigine;
    }

    public String getEcoleOrigine() {
        return ecoleOrigine;
    }

    public void setEcoleOrigine(String ecoleOrigine) {
        this.ecoleOrigine = ecoleOrigine;
    }

    public Classe getClasse() {
        return classe;
    }

    public void setClasse(Classe classe) {
        this.classe = classe;
    }

    public List<EnvoiMessage> getEnvoiMessages() {
        return envoiMessages;
    }

    public void setEnvoiMessages(List<EnvoiMessage> envoiMessages) {
        this.envoiMessages = envoiMessages;
    }

    @Override
    public String getLibelle(){
        return super.getLibelle()+ "-" + classe.getLibelle() + "-" + nomDeLaMere + "-"
                + telephoneDeLaMere + "-"+ professionDelaMere + "-" + nomDuPere + "-"
                + telephoneDuPere + "-" + professionDuPere + "-" +regionOrigine+ "-"+ecoleOrigine;
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getNomDeLaMere(), getNomDuPere(), getTelephoneDeLaMere(), getTelephoneDuPere(), getProfessionDuPere(), getProfessionDelaMere(), getRegionOrigine(), getEcoleOrigine(), getClasse(), getNom());
    }

    @Override
    public String toString() {
        return getNom() +" "+ getPrenom();
    }
}

