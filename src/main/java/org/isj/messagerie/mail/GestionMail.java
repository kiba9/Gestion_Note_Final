/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.mail;;

import org.isj.metier.Isj;
import org.isj.metier.entites.Candidat;
import org.isj.metier.entites.Email;
import org.isj.metier.facade.EmailFacade;
import org.isj.metier.facade.EtudiantFacade;


import javax.mail.MessagingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TimerTask;
import java.util.regex.Pattern;

public class GestionMail extends Thread {

    private static final String GROUPE_DESIGNER = "NOM_GROUPE";
    public static final String SEPARATEUR = "#";
    public static final String SEPARATE = ";";

    public GestionMail() {
    }

    @Override
    public void run() {
        try {
            while (true) {
                ExecutionMail();
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    public void envoiMailPersonnel(ArrayList<Reponsemail> listMsgPersonnel) throws MessagingException {

        SendEmail sendEmail = new SendEmail();
        for (Reponsemail msgP : listMsgPersonnel) {
            sendEmail.sendAsHtml(msgP.getEmail(), msgP.getTitre(), msgP.getContenu());
        }
    }

    public ArrayList<Requetemail> lireMail() {

        String host = "pop.gmail.com";// change accordingly
        String mailStoreType = "pop3";
        String username = "isjtestmail@gmail.com";// change accordingly
        String password = "testisj2019";// change accordingly

        ArrayList<Requetemail> listeMsgRetour = new ArrayList<>();

        ReceiveMail receiveMail = new ReceiveMail();
        // apres chaque lecture les messages sont supprimés
        ArrayList<email> listNvMessage = ReceiveMail.check(host, mailStoreType, username, password);
        //List<ReceiveMail> listNvMessage = receiveMail.check(host, mailStoreType, username, password);

        for (email ibMssgCount : listNvMessage) {
            Requetemail R = spliteurMail(ibMssgCount);
            listeMsgRetour.add(R);

            if (R.isMailOk()) {
                for (int i = 0; i < R.getCodeUE().length; i++) {
                    System.out.println("\n ******** Nouveau Mail: ******** \n"
                            + "email : " + R.getEmail() + "\n"
                            + "Code : " + R.getcode() + "\n"
                            + "code UE : " + R.getCodeUE()[i] + "\n"
                            + "Type : " + R.getType() + "\n"
                    );
                }
            } else {
                System.out.println("Email non pris en charge");
            }
        }

        return listeMsgRetour;
    }

    public static Requetemail spliteurMail(email IbMsg) {
        String msg = IbMsg.getContent();

        int code = 0;
        String type = "";
        String codeUE = "";
        String email = "";
        boolean isCorrectMsg = false;
        email = IbMsg.getFrom();
        String[] listeUe = null;
        Requetemail R = new Requetemail(code, type, listeUe, email, isCorrectMsg);
        Isj isj = new Isj();
       /* try {
            Candidat candidat = isj.retrouverCandidatEmail();
            Email email = new Email();
            isj.sauvegarderEmailSucces(email, candidat);
        } catch (NoResultException n) {
            n.printStackTrace();
        }*/
/*code#ue;ue;ue#type*/
        if (msg.contains(SEPARATEUR)) {
            Pattern separateur = Pattern.compile(SEPARATEUR);
            String[] items = separateur.split(msg);
            try {
                code = Integer.valueOf(items[0]);
                codeUE = items[1];
                type = items[2];
                isCorrectMsg = true;
                //Pattern separate = Pattern.compile(SEPARATE);
                listeUe = codeUE.split(";");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (code!=0 && !type.equalsIgnoreCase("")
                && !codeUE.equalsIgnoreCase("")) {
            R = new Requetemail(code, type, listeUe, email, isCorrectMsg);
        }

        return R;
    }

    public  void ExecutionMail() throws MessagingException {

//        //crer un objet de la classe Gestion message:
        //GestionMail gm = new GestionMail();

        // lecture des messages
        ArrayList<Requetemail> nouveauxMessages = lireMail();
        ArrayList<Reponsemail> reponseList = new ArrayList<>();
       /* EmailFacade emailFacade = new EmailFacade();
        Email email = new Email();
        Isj isj = new Isj();
        Candidat candidat = new Candidat();
*/

        // on parcourt tous les messages recupérés de la SIM
        for (Requetemail rqt : nouveauxMessages) {
            Reponsemail rep = new Reponsemail();

            rep.setTitre("Reponsemail du logiciel \n");
            rep.setContenu("message incorect recpectez le format requit SVP");
            rep.setEmail(rqt.getEmail());
           /* candidat = isj.retrouverCandidatEmail();
            email = new Email();*/
            //on vérifi si le message respecte le format requit
            if (rqt.isMailOk()) {
                /*String Arepondre = "UE1: 12.5 \n"
                        + "UE2: 17 "
                        + "UE3: 14 \n";*/
                /*ici on appelle la méthode fournie qui permet d'éffectuer une
                 requette dans la base de donnée pour recupérer les notes de l'étudiant*/
                EtudiantFacade etudiantFacade=new EtudiantFacade();
                Connection connection=null;
                try {
                    connection=etudiantFacade.getConnection();

                    String Arepondre ="";
                for (int i = 0; i < rqt.getCodeUE().length; i++) {
                    String requete= "CALL AFFICHER_NOTE(\""+rqt.getType()+"\",\""+rqt.getCodeUE()[i]+"\",\""+rqt.getcode()+"\")";
                    Statement statement=connection.createStatement();
                    ResultSet resultSet=statement.executeQuery(requete);
                    while(resultSet.next()){
                        Arepondre+=(rqt.getCodeUE()[i]+":"+rqt.getType()+":"+resultSet.getFloat("valeur_note"));
                    }
                 }

                rep.setContenu(Arepondre);

                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            reponseList.add(rep);
        }
        // on envoie la réponse aux differents concernés
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    envoiMailPersonnel(reponseList);
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        //im.stopperService();
    }

}
