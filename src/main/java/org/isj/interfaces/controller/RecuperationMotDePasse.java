package org.isj.interfaces.controller;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.MDP;
import org.isj.interfaces.main.Appli;
import org.isj.metier.entites.Utilisateur;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class RecuperationMotDePasse implements Initializable {

    @FXML
    private RadioButton sms;

    @FXML
    private RadioButton email;

    @FXML
    private TextField telephone;

    @FXML
    private TextField mail;

    @FXML
    private TextField code1;

    @FXML
    private TextField code2;

    @FXML
    private TextField code3;

    @FXML
    private TextField code4;

    @FXML
    private TextField telephonecode;

    @FXML
    private TextField nouveaumdp;

    @FXML
    private TextField confnouveaumdp;

    @FXML
    private TextField tel;

    @FXML
    private TextField mailconf;

    private Stage dialogStage;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    public void setDialogStage(Stage dialogStage) {
        this.dialogStage = dialogStage;
    }

    @FXML
    public void handleOkRecuperation() {
        try{
            if(sms.isSelected()) {
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/recuperationMotDePasseSMS.fxml"));
                AnchorPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.setTitle("Récupération par SMS");
                Scene scene = new Scene(page);
                dialogStage.setScene(scene);
                dialogStage.show();
            }else if(email.isSelected()){
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/recuperationMotDePasseEmail.fxml"));
                AnchorPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.setTitle("Récupération par EMAIL");
                Scene scene = new Scene(page);
                dialogStage.setScene(scene);
                dialogStage.show();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public String isInputValidTelephone() {
        String errorMessage = "";

        if (telephone.getText() == null || telephone.getText().length() == 0) {
            errorMessage += "Numéro de téléphone non valide!\n";
        }

        return errorMessage;
    }

    public String isInputValidMail() {
        String errorMessage = "";

        if (mail.getText() == null || mail.getText().length() == 0) {
            errorMessage += "Adresse mail non valide!\n";
        }

        return errorMessage;
    }

    public String isInputValidCode() {
        String errorMessage = "";

        if ((code1.getText() == null || code1.getText().length() == 0) || (code2.getText() == null || code2.getText().length() == 0) || (code3.getText() == null || code3.getText().length() == 0) ||(code4.getText() == null || code4.getText().length() == 0)) {
            errorMessage += "Code non valide!\n";
        }

        return errorMessage;
    }

    @FXML
    public void handleOkRecuperationSMS(){
        try{
            String isInputValid=isInputValidTelephone();
            if (isInputValid.equalsIgnoreCase("")) {
                String recuperationTel;
                recuperationTel = telephone.getText();
                new MDP().recuperationtel(Integer.parseInt(recuperationTel));
                System.out.println(recuperationTel);
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/recuperationMotDePasseCodeSms.fxml"));
                AnchorPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.setTitle("Code de récupération");
                Scene scene = new Scene(page);
                dialogStage.setScene(scene);
                dialogStage.show();
            }else {
                Alert alert = new Alert(Alert.AlertType.WARNING);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Paramètres Incorrects");
                alert.setContentText(isInputValid);
                alert.show();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @FXML
    public void handleOkRecuperationEmail() {
        try{
            String recuperationMail;
            String isInputValid=isInputValidMail();
            if (isInputValid.equalsIgnoreCase("")) {
                recuperationMail = mail.getText();
                new MDP().recuperationmail(recuperationMail);
                System.out.println(recuperationMail);
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/recuperationMotDePasseCodeEmail.fxml"));
                AnchorPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.setTitle("Code de récupération");
                Scene scene = new Scene(page);
                dialogStage.setScene(scene);
                dialogStage.show();
            }else {
                Alert alert = new Alert(Alert.AlertType.WARNING);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Paramètres Incorrects");
                alert.setContentText(isInputValid);
                alert.show();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @FXML
    public void handleCodeSms()throws Exception{
        String codex1, codex2, codex3, codex4, code, tel;
        String isInputValid=isInputValidCode();
        if (isInputValid.equalsIgnoreCase("")) {
            codex1 = code1.getText();
            codex2 = code2.getText();
            codex3 = code3.getText();
            codex4 = code4.getText();
            code = codex1 + codex2 + codex3 + codex4;
            tel = telephonecode.getText();
            new MDP().comparerCodeAvecTel(Double.parseDouble(code), Integer.parseInt(tel));
            System.out.println(code);

        }
    }

    @FXML
    public void handleCodeEmail()throws Exception{
        String codex1, codex2, codex3, codex4, code, email;
        String isInputValid=isInputValidCode();
        if (isInputValid.equalsIgnoreCase("")) {
            codex1 = code1.getText();
            codex2 = code2.getText();
            codex3 = code3.getText();
            codex4 = code4.getText();
            code = codex1 + codex2 + codex3 + codex4;
            email = mail.getText();
            new MDP().comparerCodeAvecMail(Double.parseDouble(code), email);
            System.out.println(code);
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/recuperationMotDePasseConfirmation.fxml"));
            AnchorPane page = loader.load();
            Stage dialogStage = new Stage();
            dialogStage.setTitle("Code de récupération");
            Scene scene = new Scene(page);
            dialogStage.setScene(scene);
            dialogStage.show();
        }
    }

    /*@FXML
    public void handleConfirmation(){
        String newmdp, confnew, telephone;
        telephone = tel.getText();
        Utilisateur user = new MDP().retrieveUserByTel(Integer.parseInt(telephone));
        newmdp = nouveaumdp.getText();
        confnew = confnouveaumdp.getText();
        if(newmdp.equals(confnew)){
            new MDP().modifierMotDePasse(confnew, user);
        }
    }*/

    @FXML
    public void handleConfirmation(){
        String newmdp, confnew, email;
        email = mailconf.getText();
        Utilisateur user = new MDP().retrieveUserByMail(email);
        newmdp = nouveaumdp.getText();
        confnew = confnouveaumdp.getText();
        if(newmdp.equals(confnew)){
            new MDP().modifierMotDePasse(confnew, user);
        }
    }

    @FXML
    public void handleAnnuler() {
        dialogStage.close();
    }

}
