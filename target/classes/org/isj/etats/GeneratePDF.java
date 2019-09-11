package org.isj.etats;

import com.mysql.jdbc.Driver;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.ZoneId;
import java.util.*;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
import org.isj.metier.Isj;
import org.isj.metier.entites.Classe;
import org.isj.metier.entites.Etudiant;

/**
 *
 * @author USER
 */
public class GeneratePDF {

    public static void genererReleve(String matricule, String classe, int annee) {

        Etudiant etudiant = new Isj().retrouverEtudiantMatricule(matricule);

        // - Paramètres de Connexion à la base de données
        String url = "jdbc:mysql://localhost:3306/isj2";
        String login = "root";
        String password = "";
        Connection connection = null;

        try {
            // - ConnexionController à la base
            Driver monDriver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(monDriver);
            connection = DriverManager.getConnection(url, login, password);

            // - Chargement et compilation du rapport
            JasperDesign jasperDesign = JRXmlLoader.load("C:\\Users\\User\\Documents\\GitHub\\Gestion_Note_Final\\src\\main\\java\\org\\isj\\etats\\ReleveFinal.jrxml");
            JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);

            // - Paramètres à envoyer au rapport
            Map parameters = new HashMap();
            parameters.put("filiere", etudiant.getClasse().getSpecialite().getFiliere());
            parameters.put("nom_etudiant",etudiant.getNom() + " " + etudiant.getPrenom());
            parameters.put("date_naissance",etudiant.getDateNaissance().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
            parameters.put("classe",classe);
            parameters.put("niveau",etudiant.getClasse().getNiveau().getNumero());
            parameters.put("annee_academique",annee);
            parameters.put("sexe",etudiant.getSexe());
            parameters.put("matricule",matricule);
            parameters.put("image_isj","target/classes/org/isj/etats/images/logo isj.jpeg");
            parameters.put("image_uy1","target/classes/org/isj/etats/images/logo uy1.jpg");
            parameters.put("image_ensp","target/classes/org/isj/etats/images/logo ensp.jpg");
            parameters.put("numero",etudiant.getCode());

            // - Execution du rapport
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // - Création du rapport au format PDF
            JasperExportManager. exportReportToPdfFile(jasperPrint, "C:\\Users\\User\\Desktop\\etudiant1.pdf");
        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    public static void genererFicheAbsence(Integer niveau, String filiere, Integer annee_academique, String semestre){

        // - Paramètres de Connexion à la base de données
        String url = "jdbc:mysql://localhost/isj2";
        String login = "root";
        String password = "";
        Connection connection = null;

        try {
            // - ConnexionController à la base
            Driver monDriver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(monDriver);
            connection = DriverManager.getConnection(url, login, password);

            // - Chargement et compilation du rapport
            JasperDesign jasperDesign = JRXmlLoader.load("C:\\Users\\User\\Documents\\GitHub\\ProjetTutoreL2\\src\\org\\isj\\etats\\FicheAbsences.jrxml");
            JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);

            // - Paramètres à envoyer au rapport
            Map parameters = new HashMap();
            parameters.put("filiere", filiere);
            parameters.put("niveau",niveau);
            parameters.put("annee_academique",annee_academique);
            parameters.put("semestre", semestre);

            // - Execution du rapport
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // - Création du rapport au format PDF
            JasperExportManager.exportReportToPdfFile(jasperPrint, "C:\\Users\\User\\Desktop\\ficheAbsences.pdf");
            connection.close();
        } catch (JRException e) {

            e.printStackTrace();
        } catch (SQLException e) {

            e.printStackTrace();
        }
    }
    
public static void main(String[] args) {

    /*String[] cmd = {"cmd", "/C", "F:\\Pisj\\src\\org\\isj\\etat\\Models\\classic.pdf"};
     try{

        Runtime run = Runtime.getRuntime();
        Process procss = run.exec(cmd);
        procss.waitFor();
     }catch(Exception e){

        JOptionPane.showMessageDialog(null, e.getMessage(), "Erreur d'installation de mysql", JOptionPane.ERROR_MESSAGE);
     }*/
    }

}
