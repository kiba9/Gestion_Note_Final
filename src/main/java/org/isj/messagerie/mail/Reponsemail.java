/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.mail;;

/**
 *
 * @author Tsafack Dagha cedric
 */
public class Reponsemail {
    String email;
    private String titre;
    private String contenu;

    public Reponsemail() {
    }
    
    

    public Reponsemail(String email, String titre, String contenu) {
        this.email = email;
        this.titre = titre;
        this.contenu = contenu;
    }

    public String getEmail() {
        return email;
    }

    public String getTitre() {
        return titre;
    }

    public String getContenu() {
        return contenu;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }
}