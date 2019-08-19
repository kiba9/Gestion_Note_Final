package org.isj.interfaces.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import org.apache.commons.collections.map.HashedMap;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;
import org.isj.metier.facade.UtilisateurFacade;

import java.io.IOException;
import java.net.URL;
import java.util.Map;
import java.util.Properties;
import java.util.ResourceBundle;

import static org.isj.gestionutilisateurs.Connexion.utilisateurCourant;

/**
 * Cette classe implémente les différentes fonctionnalités de la fenêtre de Connexion
 *
 * @author Interface
 */
public class ConnexionController implements Initializable {
    @FXML
    private TextField login;

    @FXML
    private TextField password;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    /**
     * Cette classe vérifie la taille des informations saisies et si les champs ne sont pas vides
     *
     * @return
     */
    public String isInputValid() {
        String errorMessage = "";

        if (login.getText() == null || login.getText().length() == 0) {
            errorMessage += "Login non valide!\n";
        }
        if (password.getText() == null || password.getText().length() == 0) {
            errorMessage += "Mot de passe non valide!\n";
        }

        return errorMessage;
    }

    /**
     * Fonction permettant de faire apparaître la fenêtre de récupération du mot de passe
     *
     * @throws IOException
     */
    @FXML
    public void handleOubli() throws IOException {

        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/RecuperationMotDePasse.fxml"));
        AnchorPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Récupération du mot de passe");
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    /**
     * Cette classe permet de vérifier l'authentification d'un utilisateur
     */

    @FXML
    public void handleSeConnecter(ActionEvent event) {
        try {
            String log;
            String pass;
            String isInputValid=isInputValid();
            if (isInputValid.equals("")) {
                log = login.getText();
                pass = password.getText();
                Properties properties = new Isj().readSettingApplication();
                new UtilisateurFacade().setProperties((Map)properties);
                utilisateurCourant = new Connexion().connect(log, pass);
                if (utilisateurCourant != null) {
                    FXMLLoader loader = new FXMLLoader();
                    loader.setLocation(Appli.class.getResource("../view/Candidat.fxml"));
                    BorderPane page = loader.load();
                    Stage dialogStage = new Stage();
                    dialogStage.setTitle("Liste des candidats");
                    dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
                    Scene scene = new Scene(page);
                    dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
                    dialogStage.setScene(scene);
                    dialogStage.show();
                } else {
                    Alert alert = new Alert(Alert.AlertType.ERROR);
                    alert.initOwner(Appli.getPrimaryStage);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Utilisateur Inconnu ou Désactivé");
                    alert.setContentText("Vos paramètres de connexion n'ont pas été reconnus dans le système !");
                    alert.show();
                }
            }else{
                Alert alert = new Alert(Alert.AlertType.WARNING);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Paramètres Incorrects");
                alert.setContentText(isInputValid);
                alert.show();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void handleSetting() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Properties.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Propriétés de l'application");
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }
}
