/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.gestionutilisateurs;

import org.isj.messagerie.mail.SendEmail;
import org.isj.messagerie.sms.modulesms.InteractionModem;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.UtilisateurFacade;

import javax.mail.MessagingException;
import java.security.MessageDigest;
import java.util.Date;

/**
 * @author Dodolina
 */
public class MDP {
    Isj i = new Isj();
    private double codegenere;

    /**
     * fonction permettant de creer des bits
     *
     * @param array
     * @return des bits
     */
    static String toHexString(byte[] array) {
        StringBuilder sb = new StringBuilder(array.length * 2);

        for (byte b : array) {

            int value = 0xFF & b;
            String toAppend = Integer.toHexString(value);
            sb.append(toAppend).append("-");
        }
        sb.setLength(sb.length() - 1);
        return sb.toString().toUpperCase();
    }

    int codeAuthentification;

    private static final int MIN = 1234;

    private static final int MAX = 2134;


    private String getMatricule(String email) {

        String matricule = null;

        return matricule;
    }

    /**
     * Fonction permettantde generer un code a 4 chiffres
     *
     * @return Des nombres eu aléatoirement
     */
    public double code() {
        return MIN + (Math.random() * (MAX - MIN));
    }

    /**
     * Fonction permettant d'&voir un message hashé avec sha-512
     *
     * @param a a est une chaine de caractere representant un mot de passe a hasher
     * @return Une chaine hashé à partir d'une chaine simple
     */
    public String Hachage(String a) {
        String msgHash = null;
        try {

            MessageDigest md = MessageDigest.getInstance("sha-512");

            byte[] hash = md.digest(a.getBytes());
            //System.out.println("message:");
            msgHash = toHexString(hash);

            //System.out.println("message hash:" +msgHash);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return msgHash;

    }

    public String message(String email, String objet, String message, Date date) {
        System.out.println("Objet: " + objet + "\n Message: " + message + "\n\n " + date);

        return (getMatricule(email));

    }

    Utilisateur d = null;

    /**
     * Fonction permettant de renvoyé un utilisateur si le code recupéré est egal au code généré
     *
     * @param code   le code entré par l'utiliateur
     * @param numtel le numero de telephone d'un utilisateur
     * @return un utilisateur ou nul en fonction de si l'utilisateur est présent en bd ou pas
     */
    public Utilisateur comparerCodeAvecTel(double code, int numtel) {//id c'est ce qui interfaces été généré,code ce que l'utilisateur entre


        if (code == codegenere) {

            d = i.renvoyerLoginTelephone(numtel);//prend le numero de tel et cherche interfaces quel utilisateur il appartient en bd

        }

        return d;
    }

    /**
     * Fonction permettant de mettre a jour le nouveau mot de passe de l'utilisateur
     *
     * @param newmdp c'est le nouveau mot de passe entré par l'utilisateur
     * @param d      c'est un utilisateur
     */
    public void modifierMotDePasse(String newmdp, Utilisateur d) {

        String z = Hachage(newmdp);
        d.setMotDePasse(z);
        UtilisateurFacade utilisateurFacade = new UtilisateurFacade();
        utilisateurFacade.create(d);//remplace le mot de passe interfaces l'aide du login recu
    }

    /**
     * Fonction qui compare le code que l'utilisateur a entré avec ce qui a été généré
     *
     * @param code  code entré par l'utilisateur
     * @param email email de l'utilisateur
     * @return un utilisateur si son email est present en base de donnée
     */
    public Utilisateur comparerCodeAvecMail(double code, String email) {//code ce que l'utilisateur entre sur l'interface

        Utilisateur d = new Utilisateur();
        if (code == codegenere) {
            d = i.renvoyerLoginEmail(email); //prend l'email et cherche si il appartient en bd
        }
        return d;
    }

    SendEmail s = new SendEmail();
    InteractionModem m = new InteractionModem();

    /**
     * Fonction qui permet de savoir si un numero de telephone est present en base se donnée et d'envoyer un code a ce numero
     *
     * @param numTel numero de telephone entré par l'utilisateur
     */
    public void recuperationtel(int numTel) {
        // num de tel entré par l'utilisateur

        boolean b = i.isTelephoneInBD(numTel);//par traitement metier pour voir si l'etudiant est present en bd

        if (b == true) {
            codegenere = code();
            m.envoiDuMessage(codegenere + "", numTel + "");//fait par smslib

        }
    }
    public Utilisateur retrieveUserByTel(int numtel){

        boolean b = i.isTelephoneInBD(numtel);
        Utilisateur u =new Utilisateur();
        if(b==true){
           u= i.renvoyerLoginTelephone(numtel);
        }
        return u;
    }
    public Utilisateur retrieveUserByMail(String mail){

        boolean b = i.isEmailInBD(mail);
        Utilisateur user =new Utilisateur();
        if(b==true){
            user= i.renvoyerLoginEmail(mail);
        }
        return user;
    }

    /**
     * Fonction permettant de savoir si un email est present en base de donnée et d'envoyer par mail le code généré si present
     *
     * @param mail email entré par l'utilisateur
     */
    public void recuperationmail(String mail) {
        //mail recupere par l'equipe interface une methode qui prend le num de tel entré par l'utilisateur

        boolean e = i.isEmailInBD(mail);//par traitement metier pour voir si l'etudiant est present en bd

        if (e == true) {
            codegenere = code();
            try {
                s.sendAsHtml(mail, "votre code", String.valueOf(codegenere));
            } catch (MessagingException e1) {
                e1.printStackTrace();
            }
        }
    }


}


