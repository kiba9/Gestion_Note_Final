/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.mail;;


public class Requetemail {

        private int code;
        private String niveau;
        private String[] codeUE;
        private String email;
        private String type;
        private boolean mailOk = false;

    public Requetemail(int code, String type, String[] codeUE, String email, boolean mailOk) {
        this.code = code;
        this.niveau = type;
        this.codeUE = codeUE;
        this.email = email;
        this.type = niveau;
        this.mailOk = mailOk;
    }

    public int getcode() {
        return code;
    }

    public String getType() {
        return type;
    }

    public String[] getCodeUE() {
        return codeUE;
    }



    public String getEmail() {
        return email;
    }

    public String getNiveau() {
        return niveau;
    }


    public boolean isMailOk() {
        return mailOk;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public void setType(String type) {
        this.niveau = type;
    }

    public void setCodeUE(String[] codeUE) {
        this.codeUE = codeUE;
    }



    public void setEmail(String email) {
        this.email = email;
    }

    public void setNiveau(String niveau) {
        this.type = niveau;
    }


    public void setMailOk(boolean mailOk) {
        this.mailOk = mailOk;
    }

}

