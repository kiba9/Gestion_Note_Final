/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.sms.entities;

/**
 *
 * @author Channel
 */
public class Reponse {
    String telPhon;
    private String titre;
    private String contenu;

    public Reponse() {
    }
    /**
     * fonction Reponse
     * @param titre
     * @param contenu
     * @param phone
     */

    public Reponse(String titre, String contenu, String phone) {
        this.titre = titre;
        this.contenu = contenu;
        this.telPhon = phone;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getTelPhon() {
        return telPhon;
    }

    public void setTelPhon(String telPhon) {
        this.telPhon = telPhon;
    }
}
