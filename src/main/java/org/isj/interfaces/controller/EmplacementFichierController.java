package org.isj.interfaces.controller;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;

import java.io.File;
import java.net.URL;
import java.util.ResourceBundle;

public class EmplacementFichierController implements Initializable {

    @FXML
    private RadioButton chargerUneEval;

    @FXML
    private RadioButton chargerPlusEval;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    @FXML
    public void handleOKChoixNote(ActionEvent event){
        try{
            if(chargerUneEval.isSelected()){
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/EmplacementFichier.fxml"));
                AnchorPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
                Scene scene = new Scene(page);
                dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
                dialogStage.setScene(scene);
                dialogStage.show();

            }else if(chargerPlusEval.isSelected()){
                new NoteController().stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
                FileChooser fileChooser = new FileChooser();

                // Set extension filter
                FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter(
                        "Excel files (*.xlsx)", "*.xlsx");
                fileChooser.getExtensionFilters().add(extFilter);

                // Show save file dialog
                File file = fileChooser.showOpenDialog(Appli.getPrimaryStage);

                if (file != null) {
                    new Isj().importerListeNote(file.getAbsolutePath());
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.initOwner(Appli.getPrimaryStage);
                    alert.setTitle("ISJ");
                    alert.setContentText("SUCCES");
                    alert.show();
                    new AnneeAcademiqueController().handleRaffraichir();
                }
            }
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
