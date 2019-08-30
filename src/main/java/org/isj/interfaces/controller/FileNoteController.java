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

public class FileNoteController implements Initializable {

    @FXML
    private TextField parcourir;

    @FXML
    private ComboBox<String> choixNote;
    ObservableList<String> listChoix = FXCollections.observableArrayList("Matricule - Anonymat","Note - Anonymat","Note - Matricule");

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choixNote.setItems(listChoix);
    }

    File fileget = null;

    @FXML
    public void handleParcourir(){

        try{
            FileChooser fileChooser = new FileChooser();
            FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter("Excel files (*.xlsx)", "*.xlsx");
            fileChooser.getExtensionFilters().add(extFilter);
            fileget = fileChooser.showOpenDialog(Appli.getPrimaryStage);
            parcourir.setText(fileget.getAbsolutePath());
        }catch(Exception e){
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("Une erreur s'est produite!");
            alert.show();
        }
    }

    @FXML
    public void handleOk(){

        try{
            Isj isj = new Isj();
            if(choixNote.getSelectionModel().getSelectedItem().equals("Matricule - Anonymat")){
                isj.saveMatriculeAnonyma(fileget.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }else if(choixNote.getSelectionModel().getSelectedItem().equals("Note - Anonymat")){
                isj.saveNoteAnonymat(fileget.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }else if(choixNote.getSelectionModel().getSelectedItem().equals("Note - Matricule")){
                isj.enregistrerNoteExcel(fileget.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }
            new NoteController().handleRaffraichir();
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
