package org.isj.interfaces.controller;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.TextField;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;

import java.io.File;
import java.net.URL;
import java.util.Properties;
import java.util.ResourceBundle;

public class PropertiesController implements Initializable {

    @FXML
    private TextField url;

    @FXML
    private TextField user;

    @FXML
    private TextField mdp;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

        if(new File("config.properties").exists()){
            Properties properties = new Isj().readSettingApplication();
            String propUrl = properties.getProperty("javax.persistence.jdbc.url");
            propUrl = propUrl.substring(propUrl.indexOf("//")+2, propUrl.indexOf("/isj2"));
            url.setText(propUrl);
            user.setText(properties.getProperty("javax.persistence.jdbc.user"));
            mdp.setText(properties.getProperty("javax.persistence.jdbc.password"));
        }

    }

    Properties properties;
    String urlP, userP, mdpP;

    @FXML
    public void handleOK(){
        urlP = url.getText();
        userP = user.getText();
        mdpP = mdp.getText();
        properties = new Isj().writeSettingApplication(urlP, userP, mdpP);
        System.out.println(properties);
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.initOwner(Appli.getPrimaryStage);
        alert.setTitle("ISJ");
        alert.setHeaderText("SUCCES");
        alert.show();
    }
}
