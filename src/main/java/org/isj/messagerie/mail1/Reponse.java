package org.isj.messagerie.mail1;

public class Reponse {
    String email;
    private String titre;
    private String contenu;

    public Reponse() {
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
