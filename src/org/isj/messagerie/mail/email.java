package org.isj.messagerie.mail;;




/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author cons
 */
public class  email {

    public  String Subject;
    public  String From;
    public  String Content;

    public email(String Subject, String From, String Content) {
        this.Subject = Subject;
        this.From = From;
        this.Content = Content;
    }

    public String getSubject() {
        return Subject;
    }

    public void setSubject(String Subject) {
        this.Subject = Subject;
    }

    public String getFrom() {
        return From;
    }

    public void setFrom(String From) {
        this.From = From;
    }

    public String getContent() {
        return Content;
    }

    public void setContent(String Content) {
        this.Content = Content;
    }

    
    public email() {
    }

    @Override
    public String toString() {
        return "email{" + "Subject=" + Subject + ", From=" + From + ", Content=" + Content + '}';
    }
    
    
    
}

