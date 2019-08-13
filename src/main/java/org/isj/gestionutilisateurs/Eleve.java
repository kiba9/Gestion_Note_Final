/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.gestionutilisateurs;

import java.util.Date;
import java.util.Random;
/**
 *
 * @author Dodolina
 */
public class Eleve {
//package com.company;

   
    String nomDeLaMere;
   
    String nomDuPere;
   
    int telephoneDuPere;
  
     int telephoneDeLaMere;
   
     String professionDeLaMere;
  
    String professionDupere;
  
    String matricule;
  
    String email;
  
  int codeAuthentification;
  
  private static final int MIN = 1234;
   
 private static final int MAX = 2134;

 
   public String getNomDeLaMere() {
      
  return nomDeLaMere;
    }

   
 public void setNomDeLaMere(String nomDeLaMere) {
   
     this.nomDeLaMere = nomDeLaMere;
    }

  
  public String getNomDuPere() {
        return nomDuPere;
    }

  
  public void setNomDuPere(String nomDuPere) {
        this.nomDuPere = nomDuPere;
    }

  
  public int getTelephoneDuPere() {
        return telephoneDuPere;
    }

  
  public void setTelephoneDuPere(int telephoneDuPere) {
        this.telephoneDuPere = telephoneDuPere;
    }

  
  public int getTelephoneDeLaMere() {
        return telephoneDeLaMere;
    }

  
  public void setTelephoneDeLaMere(int telephoneDeLaMere) {
        this.telephoneDeLaMere = telephoneDeLaMere;
    }

  
  public String getProfessionDeLaMere() {
        return professionDeLaMere;
    }

   
 public void setProfessionDeLaMere(String professionDeLaMere) {
        this.professionDeLaMere = professionDeLaMere;
    }

 
   public String getProfessionDupere() {
        return professionDupere;
    }

  
  public void setProfessionDupere(String professionDupere) {
        this.professionDupere = professionDupere;
    }

  
  public String getMatricule() {
        return matricule;
    }

   
 public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

 
   public int getCodeAuthentification() {
        return codeAuthentification;
    }

 
   public void setCodeAuthentification(int codeAuthentification) {
        this.codeAuthentification = codeAuthentification;
    }

  
  public double code(String matricule){
        return MIN + (Math.random() * (MAX-MIN));
    }
   
 String getMatricule(String email) {

        return this.matricule;
    }


  
  public String message(String email, String objet, String message, Date date){
     
   System.out.println("Objet: "+objet+"\n Message: "+message+"\n\n "+date);

        return (getMatricule(email));

    }


}
