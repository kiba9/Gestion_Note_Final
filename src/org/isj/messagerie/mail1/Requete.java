package org.isj.messagerie.mail1;

import java.util.Date;

public class Requete {

        private String matricule;
        private String codesecret;
        private String niveau;
        private String codeUE;
        private String filiere;
        private String email;
        private String type;
        private Date date;
        private boolean mailOk = false;

    public Requete(String matricule,String codesecret, String niveau, String codeUE, String filiere, String email, String type, Date date, boolean mailOk) {
        this.matricule = matricule;
        this.codesecret = codesecret;
        this.niveau = niveau;
        this.codeUE = codeUE;
        this.filiere = filiere;
        this.email = email;
        this.type = type;
        this.date = date;
        this.mailOk = mailOk;
    }

    public String getMatricule() {
        return matricule;
    }

    public String getcodesecret() {
        return codesecret;
    }

    public String getNiveau() {
        return niveau;
    }

    public String getCodeUE() {
        return codeUE;
    }

    public String getFiliere() {
        return filiere;
    }

    public String getEmail() {
        return email;
    }

    public String getType() {
        return type;
    }

    public Date getDate() {
        return date;
    }

    public boolean isMailOk() {
        return mailOk;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public void setCodesecret(String codesecret) {
        this.codesecret = codesecret;
    }


    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    public void setCodeUE(String codeUE) {
        this.codeUE = codeUE;
    }

    public void setFiliere(String filiere) {
        this.filiere = filiere;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setMailOk(boolean mailOk) {
        this.mailOk = mailOk;
    }

}

