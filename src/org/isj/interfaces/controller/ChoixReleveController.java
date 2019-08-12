package org.isj.interfaces.controller;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.TextField;
import org.isj.etats.dynamicreports.SimpleDynamicReport;
import org.isj.interfaces.main.Appli;

import java.net.URL;
import java.util.ResourceBundle;

public class ChoixReleveController implements Initializable {

    @FXML
    private TextField matricule;

    @FXML
    private TextField niveau;

    @FXML
    private TextField annee;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    @FXML
    public void handleOK(){
        try{
            String mat, niv, ann;
            mat = matricule.getText();
            niv = niveau.getText();
            ann = annee.getText();
            SimpleDynamicReport.genererReleve(mat, Integer.parseInt(niv), Integer.parseInt(ann));
            Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("SUCCES");
            alert.show();
        }catch (Exception e){
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("ERROR");
            alert.show();
        }
    }
}
