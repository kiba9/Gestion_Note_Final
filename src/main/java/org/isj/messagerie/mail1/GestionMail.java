/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.mail1;

import org.eclipse.persistence.queries.Call;
import org.isj.metier.Isj;

import javax.mail.MessagingException;
import java.util.ArrayList;
import java.util.regex.Pattern;

;
/**
 * @author cons
 */

public class GestionMail {

    private static final String GROUPE_DESIGNER = "NOM_GROUPE";
    public static final String SEPARATEUR = "#";
    public static final String SEPARATE = ";";

    //Gestionmail est la classe nous permettant de decoder le mail d'un étudiant, le traité et repondre par la suite
    public GestionMail() {
    }

    /**
     *
     * @param listMsgPersonnel est un objet de la classe Reponse mail qui est une liste objet devant être parcourue par chaque mail sortant
     * @throws MessagingException
     */
    public void envoiMailPersonnel(ArrayList<Reponsemail> listMsgPersonnel) throws MessagingException {

        SendEmail sendEmail = new SendEmail();
        for (Reponsemail msgP : listMsgPersonnel) {
            sendEmail.sendAsHtml(msgP.getEmail(), msgP.getTitre(), msgP.getContenu());
        }
    }

    /**
     *
     * @return
     */

    public ArrayList<Requetemail> lireMail() {

        //cette méthode nous permet de lire tout les mails entrant sur l'adresse passée en paramètre au username

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

    /**
     *
     * @param IbMsg objet de la classe email afin de recuperer l"expediteur, le titre et le contenu du mail
     * @return
     */

    public static Requetemail spliteurMail(email IbMsg) {
        String msg = IbMsg.getContent();

/**
 * la méthode SpliteurMail permet de définir une syntaxe que la classe GestionMail doit reconnaitre pour le traitement des mails
 *
 * l"expéditeur doit passer en paramètre son code, le type de l'ue et le code de l'ue tout ca séparé par un #
 */
        String code = "";
        String type = "";
        String codeUE = "";
        String email = "";
        boolean isCorrectMsg = false;
        email = IbMsg.getFrom();
        String[] listeUe = null;
        Requetemail R = new Requetemail(code, type, listeUe, email, isCorrectMsg);
       /* Isj isj = new Isj();
        try {
            Candidat candidat = isj.retrouverCandidatEmail();
            Email email = new Email();
            isj.sauvegarderEmailSucces(email, candidat);
        } catch (NoResultException n) {
            n.printStackTrace();
        }*/

        if (msg.contains(SEPARATEUR) && msg.contains(SEPARATE)) {
            Pattern separateur = Pattern.compile(SEPARATEUR);
            String[] items = separateur.split(msg);
            try {
                code = items[0];
                codeUE = items[1];
                type = items[2];
                isCorrectMsg = true;
                Pattern separate = Pattern.compile(SEPARATE);
                listeUe = separate.split(codeUE);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (!code.equalsIgnoreCase("") && !type.equalsIgnoreCase("")
                && !codeUE.equalsIgnoreCase("")) {
            R = new Requetemail(code, type, listeUe, email, isCorrectMsg);
        }

        return R;
    }

    public static void main(String[] args) throws MessagingException {

//        //créer un objet de la classe Gestion message:
        GestionMail gm = new GestionMail();

        // lecture des messages
        ArrayList<Requetemail> nouveauxMessages = gm.lireMail();
        ArrayList<Reponsemail> reponseList = new ArrayList<>();
      /* EmailFacade emailFacade = new EmailFacade();
        Email email = new Email();
        Isj isj = new Isj();
        Candidat candidat = new Candidat();
*/

        // on parcourt tous les messages recupérés du mail
        for (Requetemail rqt : nouveauxMessages) {
            Reponsemail rep = new Reponsemail();

            rep.setTitre("Reponsemail du logiciel \n");
            rep.setContenu("message incorect recpectez le format requit SVP");
            rep.setEmail(rqt.getEmail());
           //candidat = isj.retrouverCandidatEmail();
            //email = new Email();
            //on vérifi si le message respecte le format requit
            if (rqt.isMailOk()) {
                /*String Arepondre = "UE1: 12.5 \n"
                        + "UE2: 17 "
                        + "UE3: 14 \n";
                /*ici on appelle la méthode fournie qui permet d'éffectuer une
                 requette dans la base de données pour recupérer les notes de l'étudiant

                 Arepondre = recuperationNotesEtudiant(rqt.getCode, rqt.getCodeUE(), rqt.getType);
                 */
                String Arepondre1 = " SELECT * FROM AFFICHER_NOTE(rqt.getcode(), rqt.getCodeUE(), rqt.getType())";
                rep.setContenu(Arepondre1);
            }
            reponseList.add(rep);
        }
        // on envoie la réponse au déclencheur de la requete
        gm.envoiMailPersonnel(reponseList);

        //im.stopperService();
    }

}
