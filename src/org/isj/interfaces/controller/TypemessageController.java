package org.isj.interfaces.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.RadioButton;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import org.isj.interfaces.main.Appli;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class TypemessageController implements Initializable {

    @FXML
    private RadioButton sms;

    @FXML
    private RadioButton email;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    @FXML
    public void handleOK(ActionEvent event) {
        if(this.sms.isSelected()) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/Sms.fxml"));
            BorderPane page = null;
            try {
                page = loader.load();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Stage dialogStage = new Stage();
            dialogStage.setTitle("Liste des sms");
            Scene scene = new Scene(page);
            dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            dialogStage.setScene(scene);
            dialogStage.show();

        }
        else if(this.email.isSelected()){
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/Email.fxml"));
            BorderPane page = null;
            try {
                page = loader.load();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Stage dialogStage = new Stage();
            dialogStage.setTitle("Liste des mails");
            Scene scene = new Scene(page);
            dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            dialogStage.setScene(scene);
            dialogStage.show();

        }
    }
}
