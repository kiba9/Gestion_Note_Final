package org.isj.gestionutilisateurs;

import javafx.scene.control.Alert;
import org.isj.interfaces.main.Appli;
import org.isj.metier.entites.Droit;
import org.isj.metier.entites.Role;
import org.isj.metier.entites.Session;
import org.isj.metier.entites.Utilisateur;
import org.isj.metier.facade.RoleFacade;
import org.isj.metier.facade.SessionFacade;
import org.isj.metier.facade.UtilisateurFacade;
import org.isj.metier.Isj;

import java.net.InetAddress;
import java.security.MessageDigest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * cette classe regroupe les methodes permettant l'authentification, la hachage du mot de passe, la creation et l'attribution des  droits et roles
 */
public class Connexion {
    /**
     * fonction permettant de creer des bits
     *
     * @param array tableau des codes
     * @return sb.toString().toUpperCase()
     */
    public static Utilisateur utilisateurCourant;

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

    /**
     * Fonction permettant d'&voir un message hashé avec sha-512;
     *
     * @param a a est une chaine de caractere representant un mot de passe a hasher
     * @return Une chaine hashé à partir d'une chaine simple
     */
    public String hachage(String a) {
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

    /**
     * Fonction qui permet de retourner le nom d'une machine
     */
    public static String getComputerFullName(){
        String hostname = null;
        try{
            final InetAddress ADDR = InetAddress.getLocalHost();
            hostname = new String(ADDR.getHostName());
        }catch(final Exception e){
            e.printStackTrace();
        }
        return hostname;
    }

    Isj isj = new Isj();
    Session session = new Session();
    SessionFacade sessionFacade = new SessionFacade();
    /**
     * Fonction qui permet authentifier un utilisateur
     * Fonction qui ouvre une session lorsqu'un utilisateur est trouvé
     * @param login le nom d'utilisateur
     * @param mdp   le mot de passe de l'utilisateur
     * @return Un utilisateur ou null en fonction de s'il est présent ou pas en base de donnée
     */
    public Utilisateur connect(String login, String mdp) {
        String hashmdp = hachage(mdp);
        utilisateurCourant=isj.authentification(login, hashmdp);
        if (utilisateurCourant != null) {
            droitsFinaux(utilisateurCourant);
/*            //d.getRoles();
            UtilisateurFacade uf = new UtilisateurFacade();
            Utilisateur utilisateur = uf.find(new Long(1));
            List<Role> roles = utilisateur.getRoles();
            for (int i = 0; i < roles.size(); i++) {
                System.out.println(roles.get(i).getLibelle());
                List<Droit> droits = roles.get(i).getDroits();
                for (int j = 0; j < droits.size(); j++) {
                    System.out.println(droits.get(j).toString());
                }
            }*/
            Date dateConnexion = new Date();
            String hostname = getComputerFullName();
            session.setDateConnection(dateConnexion);
            session.setMachineCliente(hostname);
            session.setStatut(Session.Statut.ACTIF );
            sessionFacade.create(session);
        }
        return utilisateurCourant;
    }

    /**
     * Fonction permettant de mettre à jour la session d'un utilisateur en inscrivant la date de deconnexion et le statut
     */
    public  void  deconnexion(){
        Date dateDeconnexion = new Date();
        session.setStatut(Session.Statut.NONACTIF);
        session.setDateDeconnection(dateDeconnexion);
        sessionFacade.merge(session);
    }

    static Map<String, Droit> map = new HashMap<String, Droit>();

    /**
     * Fonction qui permet de lister les autorisation d'un utilisateur
     *
     * @param u c'est un utilisateur
     * @return les droits de cet utilisaateur
     */
    public Map<String, Droit> droitsFinaux(Utilisateur u) {


        for (int i = 0; i < u.getRoles().size(); i++) {
            /*if (map.isEmpty()) {
                map.put(roles.get(i).getDroits().get(i).getLibelle(), roles.get(i).getDroits().get(i));
            }
            else */
            Role roleCourant = u.getRoles().get(i);
            //map.put(roles.get(i).getDroits().get(i).getLibelle(),(map.get(roles.get(i).getDroits().get(i).getLibelle()). || roles.get(i).getDroits().get(i)));
            for (int j = 0; j < roleCourant.getDroits().size(); j++) {
                Droit droitCourant = roleCourant.getDroits().get(j);
                if (map.containsKey(droitCourant.getCategorie())) {
                    Droit droitExistant = map.get(droitCourant.getCategorie());
                    droitCourant.setEcriture(droitCourant.isEcriture() || droitExistant.isEcriture());
                    droitCourant.setLecture(droitCourant.isLecture() || droitExistant.isLecture());
                    droitCourant.setModification(droitCourant.isModification() || droitExistant.isModification());
                    droitCourant.setSuppression(droitCourant.isSuppression() || droitExistant.isSuppression());

                    map.replace(droitCourant.getCategorie(), droitCourant);
                } else {
                    map.put(droitCourant.getCategorie(), droitCourant);
                }
            }
        }
        return map;
    }

    /**
     * Fonction qui permet affecter un utilisateur a un role
     *
     * @param user c'est un utilisateur
     * @param role c'est un role
     */
    public void affecterUtilisateurRole(Utilisateur user, Role role) {
        role.getUtilisateurs().add(user);
        user.getRoles().add(role);
    }

    /**
     * ces fonctions permettent de definir si un utilisateur à des droits pour une classe précise
     *
     * @param c classe
     * @return vrai ou faux en fonction de si l'utilisateur peut ou ne peut pas
     */
    public static boolean peutLire(Class c) {

        return true;
        /*if (map.get(c.getSimpleName()) != null && map.get(c.getSimpleName()).isLecture())
            return true;
        else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Droits d'accès");
            alert.setContentText("Vous ne pouvez accéder à ces données !");
            alert.show();
            return false;
        }*/
    }

    public static boolean peutEcrire(Class c) {
        /*if (map.get(c.getSimpleName()) != null && map.get(c.getSimpleName()).isEcriture())
            return true;
        else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Droits d'accès");
            alert.setContentText("Vous ne pouvez enregistrer ces données !");
            alert.show();
            return false;
        }*/
        return true;
    }

    public static boolean peutModifier(Class c) {
        /*if (map.get(c.getSimpleName()) != null && map.get(c.getSimpleName()).isModification())
            return true;
        else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Droits d'accès");
            alert.setContentText("Vous ne pouvez modifier ces données !");
            alert.show();
            return false;
        }*/

        return true;
    }

    public static boolean peutSupprimer(Class c) {

        /*if (map.get(c.getSimpleName()) != null && map.get(c.getSimpleName()).isSuppression())
            return true;
        else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Droits d'accès");
            alert.setContentText("Vous ne pouvez supprimer ces données !");
            alert.show();
            return false;
        }*/

        return true;
    }

    /**
     * Fonction permettant de lister les droits d'un utilisateur
     *
     * @param u represente l'utilisateur
     */
    public void listerDroits(UtilisateurFacade u) {
        // UtilisateurFacade uf = new UtilisateurFacade();
        Utilisateur utilisateur = u.find(new Long(1));
        List<Role> roles = utilisateur.getRoles();
        for (int i = 0; i < roles.size(); i++) {
            System.out.println(roles.get(i).getLibelle());
            List<Droit> droits = roles.get(i).getDroits();
            for (int j = 0; j < droits.size(); j++) {
                System.out.println(droits.get(j).toString());
            }
        }
    }

    /**
     * Fonction qui permet de creer un role en fonction du libellé et de la description
     *
     * @param libelle     comment on appelle le role
     * @param description comment ou de quoi est constitué le role
     */
    public void enregistrerRole(String libelle, String description) {
        RoleFacade r = new RoleFacade();
        r.enregistrer(libelle, description);
    }

    int tableau[] = new int[4];


    /**
     * fonction permettant d'affecter des roles a un utilisateur
     *
     * @param u represente l'utilisateur
     * @param r represente la liste des roles
     */
    public void affecterRole(Utilisateur u, List<Role> r) {

        for (int i = 0; i < r.size(); i++) {
            u.getRoles().add(r.get(i));
        }
        new UtilisateurFacade().merge(u);
    }

    /**
     * fonction permettant de creer un role avec ses droits
     *
     * @param d liste des droits
     * @param role le role de l'utilisateur
     */
    public void creerRole(List<Droit> d, Role role) {
        for (int i = 0; i < d.size(); i++) {
            d.get(i).setRole(role);
        }
    }
}

