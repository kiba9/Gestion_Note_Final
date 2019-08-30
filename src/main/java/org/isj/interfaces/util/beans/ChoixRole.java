package org.isj.interfaces.util.beans;

public class ChoixRole {

    boolean lecture;
    boolean ecriture;
    boolean modification;
    boolean suppression;
    String categorie;

    public ChoixRole() {
    }

    public ChoixRole(boolean lecture, boolean ecriture, boolean modification, boolean suppression, String categorie) {
        this.lecture = lecture;
        this.ecriture = ecriture;
        this.modification = modification;
        this.suppression = suppression;
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

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    @Override
    public String toString() {
        return "ChoixRole{" +
                "lecture=" + lecture +
                ", ecriture=" + ecriture +
                ", modification=" + modification +
                ", suppression=" + suppression +
                ", categorie='" + categorie + '\'' +
                '}';
    }
}
