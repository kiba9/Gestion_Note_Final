
package org.isj.etats;

import com.mysql.cj.jdbc.Driver;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.controller.PropertiesController;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.UtilisateurFacade;

import javax.swing.*;

import static ar.com.fdvs.dj.domain.constants.Page.Page_Letter_Portrait;

/**
 *
 * @author USER
 */
public class GeneratePDF {


    private static Isj isj = new Isj();
    private static Connection con = null ;
    public static String OUT_DIRECTORY = "";
    public static String PATTERN_RELEVE = "target/classes/org/isj/etats/ReleveFinal.jrxml";
    public static String PATTERN_ABSCENCE = "target/classes/org/isj/etats/FicheAbsences.jrxml";


    public static void genererReleve(String matricule, String classe, int annee) {

        Etudiant etudiant = new Isj().retrouverEtudiantMatricule(matricule);

        // - Paramètres de Connexion à la base de données
        String url = "jdbc:mysql://localhost:3306/isj2";
        String login = "root";
        String password = "";
        Connection connection = null;

        try {
            // - ConnexionController à la base
            Driver monDriver = new com.mysql.cj.jdbc.Driver();
            DriverManager.registerDriver(monDriver);
            connection = DriverManager.getConnection(url, login, password);
            // - Chargement et compilation du rapport
            JasperDesign jasperDesign = JRXmlLoader.load(PATTERN_RELEVE);

            JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);

            // - Paramètres à envoyer au rapport
            Map parameters = new HashMap();
            parameters.put("filiere", etudiant.getClasse().getSpecialite().getFiliere());
            parameters.put("nom_etudiant",etudiant.getNom() + " " + etudiant.getPrenom());
            parameters.put("date_naissance",etudiant.getDateNaissance().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
            parameters.put("niveau",etudiant.getClasse().getNiveau().getNumero());
            parameters.put("annee_academique",annee);
            parameters.put("sexe",etudiant.getSexe());
            parameters.put("matricule",matricule);

            if("semestre".equalsIgnoreCase("Semestre 1")){
                ArrayList re1 = isj.rangEtudiant(annee, classe, "Semestre 1", etudiant.getClasse().getSpecialite().getFiliere().toString());
                parameters.put("rang_semestriel",re1.indexOf(matricule)+1);
            }else{
                ArrayList re2 = isj.rangEtudiant(annee, classe, "Semestre 2", etudiant.getClasse().getSpecialite().getFiliere().toString());
                parameters.put("rang_semestriel",re2.indexOf(matricule)+1);
            }

            // - Execution du rapport
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // - Création du rapport au format PDF
            JasperExportManager. exportReportToPdfFile(jasperPrint, "etudiant1.pdf");
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
            JasperDesign jasperDesign = JRXmlLoader.load(PATTERN_ABSCENCE);
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

    public void produireReleverChaine(String libelleClasse, int annee){
        try {
            File file = new File(PATTERN_RELEVE);
            FileInputStream fis = new FileInputStream(file);

            // - Chargement et compilation du rapport
            JasperDesign jasperDesign = JRXmlLoader.load(fis);
            JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);
            Classe classe = isj.retrouverClasse(libelleClasse);
            int niv = classe.getNiveau().getNumero();
            List candidatList = classe.getCandidats();
            con = new UtilisateurFacade().getConnection();

            for(Object O: candidatList){
                Etudiant etudiant = ((Etudiant) O);
                // - Paramètres à envoyer au rapport
                Map parameters = new HashMap();
                parameters.put("filiere", etudiant.getClasse().getSpecialite().getFiliere());
                parameters.put("nom_etudiant",etudiant.getNom() + " " + etudiant.getPrenom());
                parameters.put("date_naissance",etudiant.getDateNaissance().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
                parameters.put("niveau",etudiant.getClasse().getNiveau().getNumero());
                parameters.put("annee_academique",annee);
                parameters.put("sexe",etudiant.getSexe());
                parameters.put("matricule",etudiant.getMatricule());
                //ArrayList re2 = isj.rangEtudiant(annee, classe, "Semestre 2", etudiant.getClasse().getSpecialite().getFiliere().toString());
               // parameters.put("rang_semestriel",re2.indexOf(matricule)+1);

                // - Execution du rapport
                JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, con);

                // - Création du rapport au format PDF
                String fileName = "Relévé_de_Note_"+etudiant+"_"+classe+"_"+annee+".pdf";
                JasperExportManager. exportReportToPdfFile(jasperPrint, fileName);
            }
        }catch (JRException |SQLException | FileNotFoundException e){
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
    Properties properties = new Isj().readSettingApplication();
    new UtilisateurFacade().setProperties((Map)properties);
    genererReleve("1718L031", "LIC 2", 2018);
    }

}

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
import org.isj.interfaces.controller.PropertiesController;
import org.isj.metier.Isj;
import org.isj.metier.entites.AnneeAcademique;
import org.isj.metier.entites.Etudiant;
import org.isj.metier.entites.Semestre;

import javax.swing.*;

import static ar.com.fdvs.dj.domain.constants.Page.Page_Letter_Portrait;

/**
 *
 * @author USER
 */
public class GeneratePDF {

    public static void genererReleve(String matricule, int niveau, int annee) {

        Etudiant etudiant = new Isj().retrouverEtudiantMatricule(matricule);
        //Semestre semestre = new Isj().retrouverSemestre("", AnneeAcademique.class.cast(annee));

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
            parameters.put("niveau",niveau);
            parameters.put("annee_academique",annee);
            parameters.put("sexe",etudiant.getSexe());
            parameters.put("matricule",matricule);
            Isj isj = new Isj();
            if("semestre".equalsIgnoreCase("Semestre 1")){
                ArrayList re1 = isj.rangEtudiant(annee, niveau, "Semestre 1", etudiant.getClasse().getSpecialite().getFiliere().toString());
                parameters.put("rang_semestriel",re1.indexOf(matricule)+1);
            }else{
                ArrayList re2 = isj.rangEtudiant(annee, niveau, "Semestre 2", etudiant.getClasse().getSpecialite().getFiliere().toString());
                parameters.put("rang_semestriel",re2.indexOf(matricule)+1);
            }

            // - Execution du rapport
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // - Création du rapport au format PDF
            JasperExportManager.exportReportToPdfFile(jasperPrint, "C:\\Users\\User\\Desktop\\etudiant1.pdf");
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
