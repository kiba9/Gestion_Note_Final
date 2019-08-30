package org.isj.interfaces.controller;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
import org.isj.etats.GeneratePDF;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.entites.Classe;
import org.isj.metier.facade.ClasseFacade;

import java.net.URL;
import java.util.ResourceBundle;

public class ChoixReleveController implements Initializable {

    @FXML
    private TextField matricule;

    @FXML
    private ComboBox<Classe> classe;
    ObservableList<Classe> listeClasses = FXCollections.observableArrayList();

    @FXML
    private TextField annee;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        listeClasses();
    }

    public void listeClasses() {
        listeClasses.addAll(new ClasseFacade().lister());
        classe.setItems(listeClasses);
        AutoCompleteComboBoxListener<Classe> classeAutocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    @FXML
    public void handleOK(){
        try{
            String mat, ann;
            mat = matricule.getText();
            Classe clas = classe.getSelectionModel().getSelectedItem();
            String clas1 = clas.getLibelle();
            ann = annee.getText();
            new GeneratePDF().genererReleve(mat, clas1, Integer.parseInt(ann));
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
