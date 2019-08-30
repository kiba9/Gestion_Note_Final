package org.isj.messagerie.mail;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author cons
 */

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.xml.crypto.Data;
import java.util.Properties;

public class SendEmail {

    /**
     * classe permettant d'envoyer des mails aux etudiants en ouvrant une session sur gmail
     *  à travers les informations d'authentifications suivantes
     */
    private static final String senderEmail = "isjtestmail@gmail.com";//email de l'expéditeur
    private static final String senderPassword = "testisj2019";//mot de passe de l'email

    public static void sendAsHtml(String to, String title, String html) throws MessagingException {
        System.out.println("Envoi d'email à " + to);

        /**
         * fonction d'envoi de message
         * @param to varaible contenant l'adresse du destinatiare
         * @param title variable contenant le titre du mail
         * @param html est la variable contenant le message c'est à dire le contenu du mail
         * @param session objet de la classe Session permettant d'ouvrier une session sur gmail
         */

        Session session = createSession();

        //creation d'un message sur une session
        MimeMessage message = new MimeMessage(session);
        prepareEmailMessage(message, to, title, html);

        //envoi de message
        Transport.send(message);
        System.out.println("Envoyé");
    }

    public static void sendAttachFile(String to, String title, String html, String pathfile) throws MessagingException {
        System.out.println("Envoi d'email à " + to);

        /**
         * fonction d'envoi de message
         * @param to varaible contenant l'adresse du destinatiare
         * @param title variable contenant le titre du mail
         * @param html est la variable contenant le message c'est à dire le contenu du mail
         * @param session objet de la classe Session permettant d'ouvrier une session sur gmail
         */

        Session session = createSession();

        //creation d'un message sur une session
        MimeMessage message = new MimeMessage(session);
        prepareEmailMessage(message, to, title, html);
        Multipart multipart = new MimeMultipart();

        //corps
        BodyPart partieMessage = new MimeBodyPart();
        partieMessage.setContent(html, "text/html");
        multipart.addBodyPart(partieMessage);

        //piece jointes
       partieMessage = new MimeBodyPart();
        DataSource source = new FileDataSource(pathfile);
        partieMessage.setDataHandler(new DataHandler(source));
        partieMessage.setFileName(pathfile.substring(pathfile.lastIndexOf("\\") + 1));
        multipart.addBodyPart(partieMessage);


        message.setContent(multipart);
        //envoi de message

        Transport.send(message);

        System.out.println("Envoyé");
    }
    /**
     * fonction prepareEmailMessage permettant d'acceder et de modifier les varaibles passées en parametres
     * @param message
     * @param to
     * @param title
     * @param html
     * @throws MessagingException
     */
    private static void prepareEmailMessage(MimeMessage message, String to, String title, String html)
            throws MessagingException {
        message.setContent(html, "text/html; charset=utf-8");
        message.setFrom(new InternetAddress(senderEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(title);
    }

    private static Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");//Outgoing server requires authentication
        props.put("mail.smtp.starttls.enable", "true");//TLS must be activated
        props.put("mail.smtp.host", "smtp.gmail.com"); //Outgoing server (SMTP) - change it to your SMTP server landl
        props.put("mail.smtp.port", "587");//Outgoing port

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });
        return session;
    }

    public static void main(String[] args) throws MessagingException {
        SendEmail.sendAsHtml("constantinnitcheu6@gmail.com,channeldonkeng@gmail.com", "Test email", "<h2>Salut</h2><p>Voilà notre premier mail et javax.mail marche.</p>");
    }
}
