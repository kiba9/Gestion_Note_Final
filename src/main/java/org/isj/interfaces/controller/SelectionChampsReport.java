package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.CheckBoxTableCell;
import org.isj.etats.dynamicreports.SimpleDynamicReport;
import org.isj.interfaces.util.beans.Choix;

import java.net.URL;
import java.util.*;

public class SelectionChampsReport implements Initializable {

    @FXML
    private TableView<Choix> tableSelection;
    private ObservableList<Choix> listeChoix=FXCollections.observableArrayList();

    @FXML
    private TableColumn<Choix, Boolean> imprimer;

    @FXML
    private TableColumn<Choix, String> categorie;

    private ObservableList<String> listeAttributs;

    private String requete;
    private String titre;
    private String sousTitre;
    private Page orientation;

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }

    @FXML
    public void handleOkSelectionChamps(){

        List<String> champsSelectionnes=new ArrayList<String>();
        for(int i=0;i<tableSelection.getItems().size();i++){
            if(tableSelection.getItems().get(i).isSelected()){
                champsSelectionnes.add(tableSelection.getItems().get(i).getCategorie());
            }
        }
        new SimpleDynamicReport().printDynamicReport(
                getRequete(),
                champsSelectionnes,
                getTitre(),
                getSousTitre(),
                true,
                true,
                getOrientation());

    }


    public void setAttributs(ObservableList<String> listAttributs) {

        this.listeAttributs=listAttributs;

        for(int i=0;i<listeAttributs.size();i++) {
            listeChoix.add(new Choix(true,listeAttributs.get(i)));
        }
        tableSelection.setItems(listeChoix);

        categorie.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getCategorie()));

        //imprimer.setCellValueFactory(cellData -> new SimpleBooleanProperty(cellData.getValue().isSelected()));

        //imprimer.setEditable(true);
        tableSelection.setEditable(true);
        imprimer.setCellFactory(column -> new CheckBoxTableCell<>());
        imprimer.setCellValueFactory(cellData -> {
            Choix cellValue = cellData.getValue();
            BooleanProperty property = new SimpleBooleanProperty(cellValue.isSelected());
            // Add listener to handler change
            property.addListener((observable, oldValue, newValue) -> cellValue.setSelected(newValue));
            return property;
        });
    }

    public String getRequete() {
        return requete;
    }

    public void setRequete(String requete) {
        this.requete = requete;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getSousTitre() {
        return sousTitre;
    }

    public void setSousTitre(String sousTitre) {
        this.sousTitre = sousTitre;
    }

    public Page getOrientation() {
        return orientation;
    }

    public void setOrientation(Page orientation) {
        this.orientation = orientation;
    }
}
