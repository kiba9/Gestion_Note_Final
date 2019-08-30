package org.isj.messagerie;

import org.isj.messagerie.mail.GestionMail;
import org.isj.messagerie.sms.modulesms.GestionMessage;
import org.isj.messagerie.sms.modulesms.InteractionModem;

import java.util.Timer;

public class Mythread {

    GestionMail gestionMail=new GestionMail();
    GestionMessage gestionMessage = new GestionMessage();

    public void stopThreads (){

        //gestionMail.stop();
       // gestionMessage.stop();
    }

    public void runThreads (){

        gestionMail.start();
        gestionMessage.start();

        // toujours activer le service au démmarage du logiciel:




        //Timer timerGestionMail = new Timer();
        //Timer timerGestionSms = new Timer();

        //lancement de la lecture des mails et des SMS à chaque 10secondes(=10x1000 ms)
        //timerGestionMail.schedule(new GestionMail(), 0, 10*1000);

       // timerGestionSms.schedule(new GestionMessage(), 0, 10*1000);
        // im.stopperService();

    }

    /*public static void main(String[] args) {
        Mythread th = new Mythread();
        th.runThreads();
    }*/

}
