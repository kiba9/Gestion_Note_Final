/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.messagerie.sms.modulesms;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.spec.SecretKeySpec;
import javax.swing.JOptionPane;
import org.smslib.AGateway;
import org.smslib.GatewayException;
import org.smslib.ICallNotification;
import org.smslib.IGatewayStatusNotification;
import org.smslib.IInboundMessageNotification;
import org.smslib.IOrphanedMessageNotification;
import org.smslib.IOutboundMessageNotification;
import org.smslib.InboundMessage;
import org.smslib.Message;
import org.smslib.OutboundMessage;
import org.smslib.SMSLibException;
import org.smslib.Service;
import org.smslib.TimeoutException;
import org.smslib.crypto.AESKey;
import org.smslib.modem.SerialModemGateway;

/**
 *
 * @author Channel
 */




public class InteractionModem extends OutboundMessage {

    private String nomModem; // Nom choisir de facon personnel pour désigner le modem utiliser 
    private String port;     // port ouvert détecter
    private String NumeroTelephonePuce;
    private int frequence;
    private String codePin;
    private String marqueModem;
    private String versionModemUtiliser;
    private SerialModemGateway gateway;

    // Utiliser lors de la configuration automatique des ports
    public static int NUM_COMPORT = 0;

    public InteractionModem() {

        this.nomModem = "MODCOM10";
        this.port = "COM12";
        this.versionModemUtiliser = "AT+CGMME173";
        this.frequence = 9600;
        this.NumeroTelephonePuce = "656531071"; //656315924
        this.marqueModem = "HUAWEI";
        this.gateway = new SerialModemGateway(this.nomModem, this.port, this.frequence, this.marqueModem, this.versionModemUtiliser);

    }

    public String getNomModem() {
        return nomModem;
    }

    public String getPort() {
        return port;
    }

    public String getNumeroTelephonePuce() {
        return NumeroTelephonePuce;
    }

    public int getFrequence() {
        return frequence;
    }

    public String getCodePin() {
        return codePin;
    }

    public String getMarqueModem() {
        return marqueModem;
    }

    public String getVersionModemUtiliser() {
        return versionModemUtiliser;
    }

    public SerialModemGateway getGateway() {
        return gateway;
    }

    /**
     * fonction activeService permet d'activer les services

     */
    public boolean activerService() {
        // Set the modem protocol to PDU (alternative is TEXT). PDU is the default, anyway...
        gateway.setProtocol(AGateway.Protocols.PDU);
        //Do we want the Gateway to be used for Inbound messages?
        gateway.setInbound(true);
        // Do we want the Gateway to be used for Outbound messages?
        gateway.setOutbound(true);
        // Let SMSLib know which is the SIM PIN.
        gateway.setSimPin("0000");
        try {
            // Add the Gateway to the Service object.
            Service.getInstance().addGateway(gateway);
        } catch (GatewayException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "Erreur d'ajout du gatewai", "Gateway Error", JOptionPane.ERROR_MESSAGE);
        }
        try {
            Service.getInstance().startService();
        } catch (SMSLibException | IOException | InterruptedException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "Erreur d'ajout du gatewai. RECUPERATION AUTOMATIQUE DES PORTS EN COURS", "Gateway Error", JOptionPane.ERROR_MESSAGE);
           /* try {
                TestPort tpClass = new TestPort();
                List<PortSms> listePort = new ArrayList<>();
                String[] args = null;
                listePort = tpClass.main(args);
                PortSms myPort = new PortSms();

                if (listePort.size() > 0) {
                    System.err.println("ITERATION NUMERO " + NUM_COMPORT);

                    myPort = listePort.get(NUM_COMPORT);

                    if (myPort.isFrequencesOK()) {
                        this.port = myPort.getNomComPort();
                        this.fréquence = myPort.getTabFrequence().get(0);
                    }
                    NUM_COMPORT++;

                    if (NUM_COMPORT < 5) {
                        this.activerService();
                    }
                }else{
                    JOptionPane.showMessageDialog(null, "Erreur... VOtre modem est mal connecté ou incompatible", "Gateway Error", JOptionPane.ERROR_MESSAGE);
                }

            } catch (Exception except) {
                Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, except);
            }*/

        }
        System.out.println("**************Service activer****************");
        return true;
    }
    /**
     * fonction stopperService permet fermer les services

     */
    public boolean stopperService() {
        try {
            Service.getInstance().stopService();
        } catch (SMSLibException | IOException | InterruptedException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "SERVICE NON STOPPER", "ERREUR", JOptionPane.INFORMATION_MESSAGE);
            return false;
        }
        System.err.println("*****Service stoper***********");
        return true;
    }

    /**
     * fonction envoiDuMessage permet l'envoie d'un message
     * @param message(le contenu du message)
     * @param numeroDestinataire(le numéro de celui à qui le message est envoyé)


     */
    public void envoiDuMessage(String message, String numeroDestinataire) {

        OutboundMessage msg = new OutboundMessage(numeroDestinataire, message);
        System.err.println("******DEBUT DE L'ENVOI********");
        try {
            Service.getInstance().sendMessage(msg);//C'est cette methode qui fait l'envoie du message
        } catch (TimeoutException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "msg non envoyé, temps d'envoi tres long", "SENDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (GatewayException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "msg non envoyé, probleme lié au gateway utilisé", "SENDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (IOException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "msg non envoyé, probleme d'Input/ Output", "SENDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (InterruptedException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "msg non envoyé, probleme due à une interuption", "SENDING ERROR", JOptionPane.ERROR_MESSAGE);
        }
        System.err.println(msg);
        System.err.println("******FIN DE L'ENVOI********");
        OutboundNotification out = new OutboundNotification();

        // on vérifi que le message est partir
        out.process(this.gateway, msg);

    }

    /**
     * fonction lectureSMS permet la lecture des messages


     */

    public List<InboundMessage> lectureSMS() {

        List<InboundMessage> msgList;
        List<InboundMessage> msgListRetour = new ArrayList<>();
        GatewayStatusNotification statusNotification = new GatewayStatusNotification();
        OrphanedMessageNotification orphanedMessageNotification = new OrphanedMessageNotification();
        CallNotification callNotification = new CallNotification();
        InboundNotification inboundNotification = new InboundNotification();

        // Set up the notification methods.
        Service.getInstance().setInboundMessageNotification(inboundNotification);
        Service.getInstance().setCallNotification(callNotification);
        Service.getInstance().setGatewayStatusNotification(statusNotification);
        Service.getInstance().setOrphanedMessageNotification(orphanedMessageNotification);
        Service.getInstance().getKeyManager().registerKey(this.NumeroTelephonePuce, new AESKey(new SecretKeySpec("0011223344556677".getBytes(), "AES")));
        msgList = new ArrayList<InboundMessage>();

        System.err.println("*****DEBUT DE LA LECTURE*****");
        try {
            Service.getInstance().readMessages(msgList, InboundMessage.MessageClasses.ALL);// Cette methode fait la lecture des messages
        } catch (TimeoutException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "LECTURE NON TERMINEE, temps de lecture très long", "REDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (GatewayException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "LECTURE NON TERMINEE, probleme lié au gateway utilisé", "REDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (IOException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "LECTURE NON TERMINEE, probleme d'Input/ Output", "REDING ERROR", JOptionPane.ERROR_MESSAGE);
        } catch (InterruptedException ex) {
            Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "LECTURE NON TERMINEE PROBLEME DUE A UNE INTERUPTION", "REDING ERROR", JOptionPane.ERROR_MESSAGE);
        }
        System.err.println("****FIN DE LA LECTURE*****");

        System.err.println("*******************DEBUT DE LA COPIE ET SUPPRESSION***********************");
        //On copie toute la liste lue dans la nouvelle variable créee et on suprime le message de la puce
        for (InboundMessage msg : msgList) {
            msgListRetour.add(msg);
            try {
                //On supprime chaque message lue de la liste
                Service.getInstance().deleteMessage(msg);
            } catch (TimeoutException | GatewayException | IOException | InterruptedException ex) {
                Logger.getLogger(InteractionModem.class.getName()).log(Level.SEVERE, null, ex);
                JOptionPane.showMessageDialog(null, "SMS non supprimer de la SIM", "ERREUR", JOptionPane.ERROR_MESSAGE);
            }
        }
        System.err.println("*******************FIN DE LA COPIE ET DE LA SUPRESSION***********************");

        // on affiche pour vérifier que les des messages ont été supprimés
        for (InboundMessage msg : msgList) {
            System.err.println(msg.getText() + "    " + msg.getOriginator() + "  " + msg.getMessageId() + " " + msg.getDate());
        }

        return msgListRetour;
    }

    public class InboundNotification implements IInboundMessageNotification {

        @Override
        public void process(AGateway gateway, Message.MessageTypes msgType, InboundMessage msg) {
            if (msgType == Message.MessageTypes.INBOUND) {
                System.out.println(">>> New Inbound message detected from Gateway: " + gateway.getGatewayId());
                JOptionPane.showMessageDialog(null, "Nouveau message réçu de: " + msg.getOriginator(), "Nouveau message", JOptionPane.INFORMATION_MESSAGE);
            } else if (msgType == Message.MessageTypes.STATUSREPORT) {
                System.out.println(">>> New Inbound Status Report message detected from Gateway: " + gateway.getGatewayId());
                JOptionPane.showMessageDialog(null, "Accuser de reception venant de: " + msg.getOriginator(), "Accuser de reception", JOptionPane.INFORMATION_MESSAGE);
            }
            System.out.println(msg);
        }
    }

    public class CallNotification implements ICallNotification {

        @Override
        public void process(AGateway gateway, String callerId) {
            System.out.println(">>> New call detected from Gateway: " + gateway.getGatewayId() + " : " + callerId);
        }
    }

    public class GatewayStatusNotification implements IGatewayStatusNotification {

        @Override
        public void process(AGateway gateway, AGateway.GatewayStatuses oldStatus, AGateway.GatewayStatuses newStatus) {
            System.out.println(">>> Gateway Status change for " + gateway.getGatewayId() + ", OLD: " + oldStatus + " -> NEW: " + newStatus);
        }
    }

    public class OrphanedMessageNotification implements IOrphanedMessageNotification {

        @Override
        public boolean process(AGateway gateway, InboundMessage msg) {
            System.out.println(">>> Orphaned message part detected from " + gateway.getGatewayId());
            System.out.println(msg);
            // Since we are just testing, return FALSE and keep the orphaned message part.
            return false;
        }
    }

    public class OutboundNotification implements IOutboundMessageNotification {

        @Override
        public void process(AGateway gateway, OutboundMessage msg) {
            System.out.println("Outbound handler called from Gateway: " + gateway.getGatewayId());
            System.out.println(msg);

            OutboundMessage.MessageStatuses status = msg.getMessageStatus();
            System.out.println(msg);

            if (status.SENT.compareTo(OutboundMessage.MessageStatuses.SENT) == 0) {
                System.out.println("\n Message envoyé avec succes");
            } else if (status.FAILED == OutboundMessage.MessageStatuses.SENT) {
                System.out.println("\n echec d'envoi de message");
                JOptionPane.showMessageDialog(null, "echec d'envoi de message");
            }
        }
    }
}
