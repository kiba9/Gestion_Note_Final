package org.isj.interfaces.controller;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import javafx.stage.FileChooser;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;

import java.io.File;
import java.net.URL;
import java.util.ResourceBundle;

public class EmplacementDisciplineController implements Initializable {

    @FXML
    private TextField parcourir;

    @FXML
    private ComboBox<String> choixNote;
    ObservableList<String> listChoix = FXCollections.observableArrayList("Importer toutes les disciplines","Importer Absences","Importer Retard");

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    File file = null;

    public void handleParcourir(){
        try{
            FileChooser fileChooser = new FileChooser();

            // Set extension filter
            FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter(
                    "Excel files (*.xlsx)", "*.xlsx");
            fileChooser.getExtensionFilters().add(extFilter);

            // Show save file dialog
            file = fileChooser.showOpenDialog(Appli.getPrimaryStage);

            parcourir.setText(file.getAbsolutePath());
        }catch (Exception e){
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("Veuillez vérifier les paramètres du fichier".toUpperCase() + "!");
            alert.show();
        }
        new DisciplineController().handleRaffraichir();
    }

    public void handleOk(){
        choixNote.setItems(listChoix);
        try{
            Isj isj = new Isj();
            if(choixNote.getItems().equals("Importer toutes les disciplines")){
                isj.saveMatriculeAnonyma(file.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }else if(choixNote.getItems().equals("Importer Absences")){
                isj.saveNoteAnonymat(file.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }else if(choixNote.getItems().equals("Importer Retard")){
                isj.enregistrerNoteExcel(file.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }
            new DisciplineController().handleRaffraichir();
        }catch (Exception e){
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("Une erreur s'est produite!");
            alert.show();
        }
    }
}
