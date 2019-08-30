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
 * cette classe crée la table utilisateur dans la base de données
 * cette classe herite de la classe Personne
 * @author traitement metier
 */

@XmlRootElement
@Entity
@Table(name = "utilisateur")
public class Utilisateur extends Personne implements Serializable {


    @Column(name = "login", nullable = false, unique=true)
    private String login;

    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;

    @ManyToMany(cascade={  CascadeType.MERGE,CascadeType.REFRESH,CascadeType.PERSIST})
    @JoinTable(joinColumns = {@JoinColumn(name = "code_utilisateur")}, inverseJoinColumns = {@JoinColumn(name = "code_role")})
    private List<Role> roles = new ArrayList<>();

    public Utilisateur(String libelle, String description, String nom, String prenom, String email, int telephone, Date dateNaissance, Sexe sexe, Statut statut, String login, String motDePasse) {
        super(libelle, description, nom, prenom, email, telephone, dateNaissance, sexe, statut);
        this.login = login;
        this.motDePasse = motDePasse;
    }


    public Utilisateur(){}

    public String getLogin() {
        return login;
    }
    public void setLogin(String login) {
        this.login = login;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public List<Role> getRoles() {
        return roles;
    }

    public void setRoles(List<Role> roles) {
        this.roles = roles;
    }

    @Override
    public String getLibelle(){
        return login + "-" + super.getLibelle();
    }

    @Override
    public String toString() {
        return getLogin();
    }

    @Override
    public int hashCode() {
        return Objects.hash(getLogin(), getMotDePasse());
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Utilisateur other = (Utilisateur) obj;
        if (!Objects.equals(this.login, other.login)) {
            return false;
        }
        if (!Objects.equals(this.motDePasse, other.motDePasse)) {
            return false;
        }
        return true;
    }
}
