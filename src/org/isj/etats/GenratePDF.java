/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.etats;

import com.mysql.jdbc.Driver;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.swing.JOptionPane;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

/**
 *
 * @author USER
 */
public class GenratePDF {
    
public static void main(String[] args) {

        // - Paramètres de Connexion à la base de données
        String url = "jdbc:mysql://localhost/jasper_database";
        String login = "root";
        String password = "";
        Connection connection = null;

        try {
            // - ConnexionController à la base
            Driver monDriver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(monDriver);
            connection = DriverManager.getConnection(url, login, password);

            // - Chargement et compilation du rapport
            JasperDesign jasperDesign = JRXmlLoader.load("F:\\Pisj\\src\\org\\isj\\etat\\Models\\classic.jrxml");
            JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);

            // - Paramètres à envoyer au rapport
            Map parameters = new HashMap();
            parameters.put("Titre", "Titre");

            // - Execution du rapport
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // - Création du rapport au format PDF
            JasperExportManager.exportReportToPdfFile(jasperPrint, "F:\\Pisj\\src\\org\\isj\\etat\\Models\\classic.pdf");
        } catch (JRException e) {

            e.printStackTrace();
        } catch (SQLException e) {

            e.printStackTrace();
        } finally {
            try {
                 connection.close();
                } catch (SQLException e) {

                        e.printStackTrace();
                }
        }
//            File sgbd = new File(repertoire);
    
    String[] cmd = {"cmd", "/C", "F:\\Pisj\\src\\org\\isj\\etat\\Models\\classic.pdf"};
    
     //String cmd = "cmd /C msiexec.exe /passive "+sgbd.getAbsolutePatfh();
     //String[] cmd = {"cmd", "/C", "start", sgbd.getAbsolutePath()};
       
     try{
     
        Runtime run = Runtime.getRuntime();
        Process procss = run.exec(cmd);
        procss.waitFor();
     }catch(Exception e){
        
        JOptionPane.showMessageDialog(null, e.getMessage(), "Erreur d'installation de mysql", JOptionPane.ERROR_MESSAGE);
     }
    }
}
