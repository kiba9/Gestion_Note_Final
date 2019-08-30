/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.sms.entities;

import java.util.Date;

/**
 *
 * @author Channel
 */

//Cette classe permet de défini les requetes d'un étudiant

public class Requete {
    private String matricule;
    private String codesecret;
    private String type;
    private String niveau;
    private String[] codeUE;
    private String filiere;
    private String num;
    private Date date;
    private boolean messageOk = false;
    /**
     * fonction Requete
     * @param matricule
     * @param codesecret
     * @param type
     * @param niveau
     * @param codeUE
     * @param filiere
     * @param num
     * @param date
     *  @param msgOk
     */
    public Requete(String matricule, String codesecret, String type, String niveau, String[] codeUE, String filiere, String num, Date date, boolean msgOk) {
        this.matricule = matricule;
        this.codesecret = codesecret;
        this.type = type;
        this.niveau = niveau;
        this.codeUE = codeUE;
        this.filiere = filiere;
        this.num = num;
        this.date = date;
        this.messageOk = msgOk;
    }

    public String getMatricule() {
        return matricule;
    }

    public String getCodesecret() {
        return codesecret;
    }

    public String gettype() { return type; }

    public String getNiveau() {
        return niveau;
    }

    public String[] getCodeUE() {
        return codeUE;
    }

    public String getFiliere() {
        return filiere;
    }

    public String getNum() {
        return num;
    }

    public Date getDate() {
        return date;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public void setCodesecret(String codesecret) {
        this.codesecret = codesecret;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    public void setCodeUE(String[] codeUE) {
        this.codeUE = codeUE;
    }

    public void setFiliere(String filiere) {
        this.filiere = filiere;
    }

    public void setNum(String num) {
        this.num = num;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public boolean isMessageOk() {
        return messageOk;
    }

    public void setMessageOk(boolean messageOk) {
        this.messageOk = messageOk;
    } 
    
}
