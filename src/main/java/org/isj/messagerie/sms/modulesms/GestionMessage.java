/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.sms.modulesms;


import org.isj.messagerie.sms.entities.Reponse;
import org.isj.messagerie.sms.entities.Requete;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.regex.Pattern;

import org.isj.metier.Isj;
import org.isj.metier.entites.Candidat;
import org.isj.metier.entites.Sms;
import org.isj.metier.facade.EtudiantFacade;
import org.isj.metier.facade.SmsFacade;
import org.jfree.chart.util.TextUtils;
import org.smslib.InboundMessage;
import org.smslib.Service;

import javax.mail.MessagingException;
import javax.persistence.NoResultException;
import javax.persistence.criteria.CriteriaBuilder;

/**
 *
 * @author Channel
 */
public class GestionMessage extends Thread {

    private static final String GROUPE_DESIGNER = "NOM_GROUPE";
    public static final String SEPARATEUR = "#";
    public static final String SEPARATE= ";";

    public GestionMessage() {
        InteractionModem im = new InteractionModem();
        im.activerService();
    }

    @Override
    public void run() {
        try {
            while (true) {
                executionSMS();
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }





    public void envoiMessagePersonnel(ArrayList<Reponse> listMsgPersonnel) {

        InteractionModem interactionModem = new InteractionModem();
        if(listMsgPersonnel!=null && !listMsgPersonnel.isEmpty()) {
            for (Reponse msgP : listMsgPersonnel) {
                interactionModem.envoiDuMessage(msgP.getContenu(), msgP.getTelPhon());
            }
        }
    }

     public void envoiMessageGroupe(String messageText, ArrayList<String> listeTelephones) {

        Service.getInstance().createGroup(GROUPE_DESIGNER);
        for (String phone : listeTelephones) {
            Service.getInstance().addToGroup(GROUPE_DESIGNER, phone);
        }
        InteractionModem interactionModem = new InteractionModem();
        interactionModem.envoiDuMessage(messageText, GROUPE_DESIGNER);

    }

    public void envoiMessageGroupe(String messageText, String listeTelephones) {
      envoiMessageGroupe(messageText, (ArrayList<String>) Arrays.asList(listeTelephones.split(",")));
    }
    public ArrayList<Requete> lireSms() {

        ArrayList<Requete> listeMsgRetour = new ArrayList<>();

        InteractionModem interactionModem = new InteractionModem();
        // apres chaque lecture les message sont supprimés
        List<InboundMessage> listNvMessage = interactionModem.lectureSMS();

        for (InboundMessage ibMssgCount : listNvMessage) {
            Requete R = spliteurMessage(ibMssgCount);
            listeMsgRetour.add(R);

            if (R!=null && R.isMessageOk()) {
                for (int i = 0; i < R.getCodeUE().length; i++) {
                    System.out.println("\n ********nouveau message: ******** \n"
                            + "Code Secret: " + R.getCodesecret() + "\n"
                            + "code UE: " + R.getCodeUE()[i] + "\n"
                            + "Type: " + R.gettype() + "\n"
                    );
                }
            } else {
                System.out.println("Message non pris en charge");
            }
        }
        return listeMsgRetour;
    }

    // a pour but de prendre un message dans son etat brut et le transformer en un objet de la classe  Requete
    /**
     * fonction spliteurMessage permet de découpper le message en bloc
     * @param IbMsg(le message reçu )


     */
    public static Requete spliteurMessage(InboundMessage IbMsg) {
        String msg = IbMsg.getText();


        String matricule = "";
        String codesecret = "";
        String type = "";
        String niveau = "";
        String codeUE = "";
        String filiere = "";
        Date date = IbMsg.getDate();
        String num = "";
        String[] listeUe = null;
        boolean isCorrectMsg = false;
        num = IbMsg.getOriginator();

        Requete R = new Requete(matricule, codesecret, type,  niveau, listeUe, filiere, num, date, isCorrectMsg);
       /* Isj isj = new Isj();
        try {
            Candidat candidat = isj.retrouverCandidatSms(Integer.valueOf(num.substring(4)));
            Sms sms = new Sms("","",msg,String.valueOf(656307859),num);
            SmsFacade smsFacade = new SmsFacade();
            smsFacade.create(sms);
            isj.sauvegarderSmsSucces(sms,candidat);
        }catch (NoResultException n){
            n.printStackTrace();
        }*/
        if (msg.contains(SEPARATEUR)){
            Pattern separateur = Pattern.compile(SEPARATEUR);
            String[] items = separateur.split(msg);

            try {
                codesecret = items[0];
                codeUE = items[1];
                type = items[2];
                isCorrectMsg = true;
               Pattern separate = Pattern.compile(SEPARATE);
               // String[] item = separateur.split(codeUE);
                listeUe = codeUE.split(";");
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        if (!codesecret.equalsIgnoreCase("") && !codeUE.equalsIgnoreCase("")
             && !type.equalsIgnoreCase("")) {
            R = new Requete(matricule, codesecret, type, niveau, listeUe, filiere, num, date, isCorrectMsg);
        }

        return R;
    }
//public static void main(String[]args){
    public void executionSMS() throws Exception {

        /**
         * ****** exemple d'utilisation! *******
         */
        // toujour activer le service au debut:
       //InteractionModem im = new InteractionModem();
        //im.activerService();
//
//        //crer un objet de la classe Gestion message:
        //GestionMessage gm = new GestionMessage();


        // lecture des messages
        ArrayList<Requete> nouveauxMessages = lireSms();
        ArrayList<Reponse> reponseList = new ArrayList<>();
        /*SmsFacade smsFacade = new SmsFacade();
        Sms sms = new Sms();
        Isj isj = new Isj();
        Candidat candidat = new Candidat();*/
        // on parcourt tous les messages recupérés de la SIM

        for (int j=0;j<nouveauxMessages.size();j++) {
            Requete rqt = nouveauxMessages.get(j);
            if (rqt != null) {
                Reponse rep = new Reponse();
                rep.setTitre("Réponse du logiciel \n");
                rep.setContenu("Message incorrect. Respectez le format requis s'il vous plait: code_d'authentification#code_ue#type_évaluation");
                rep.setTelPhon(rqt.getNum());
               /* String numero;
                if (rqt.getNum().length() == 13) {
                    numero = rqt.getNum().substring(4);
                } else {
                    numero = rqt.getNum().substring(3);
                }*/


                //candidat = isj.retrouverCandidatSms(Integer.valueOf(numero));
                //sms = new Sms(rep.getTitre(),"",rep.getContenu(),rqt.getNum(),String.valueOf(656307859));

                //on vérifi si le message respecte le format requit
                if (rqt.isMessageOk()) {
                /*String Arepondre = "UE1: 12.5 \n"
                        + "UE2: 17 "
                        + "UE3: 14 \n";*/
                /*ici on appelle la méthode fournie qui permet d'éffectuer une
                 requette dans la base de donnée pour recupérer les notes de l'étudiant
                
                 Arepondre = recuperationNotesEtudiant(rqt.getMatricule(), rqt.getFiliere(), rqt.getCodeUE(), rqt.getNiveau());
                 */
                    EtudiantFacade etudiantFacade = new EtudiantFacade();
                    Connection connection = null;
                    try {
                        connection = etudiantFacade.getConnection();

                        String Arepondre = "";
                        for (int i = 0; i < rqt.getCodeUE().length; i++) {
                            String requete = "CALL AFFICHER_NOTE(\"" + rqt.gettype() + "\",\"" + rqt.getCodeUE()[i] + "\",\"" + rqt.getCodesecret() + "\")";
                            Statement statement = connection.createStatement();
                            ResultSet resultSet = statement.executeQuery(requete);
                            while (resultSet.next()) {
                                Arepondre += (rqt.getCodeUE()[i] + ":" + rqt.gettype() + ":" + resultSet.getFloat("valeur_note"));
                            }
                        }

                        if (Arepondre != null && Arepondre.equalsIgnoreCase("")) {
                            Arepondre = "Aucune note trouvee !";
                        }
                        rep.setContenu(Arepondre);
                        //   sms.setContenu(Arepondre);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                }
                reponseList.add(rep);
            }
        }
        // on envoie la réponse aux differents concernés
       //smsFacade.create(sms);
       // isj.sauvegarderSmsSucces(sms,candidat);
       envoiMessagePersonnel(reponseList);

       
       
        //envoie de message de groupe
        /*String msg = "bonjour chers etudiant";
        ArrayList<String> tel = new ArrayList<>();
        tel.add("5656307859");
        tel.add("656499238");
        envoiMessageGroupe(msg, tel);*/

        // envoie des message differents aux personnes
        /*ArrayList<MessagePersonnel> msp = new ArrayList<>();
         msp.add(new MessagePersonnel("691621708", "BONSOIR  "));
         // msp.add(new MessagePersonnel( "54566677","message"));
         gm.envoiMessagePersonnel(msp);
 
         // toujours stopper le service à la fin
         */
       // im.stopperService();

    }

}
