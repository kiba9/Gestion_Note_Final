package org.isj.interfaces.util.beans;

public class Choix {

    boolean selected;
    String categorie;

    public Choix() {
    }

    public Choix(boolean selected, String categorie) {
        this.selected = selected;
        this.categorie = categorie;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    @Override
    public String toString() {
        return "Choix{" +
                "selected=" + selected +
                ", categorie='" + categorie + '\'' +
                '}';
    }
}
