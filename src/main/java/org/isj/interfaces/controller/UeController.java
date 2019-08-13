package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.entites.Module;
import org.isj.metier.facade.*;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

public class UeController implements Initializable {
    @FXML
    private TextField code;

    @FXML
    private TextField codeUe;

    @FXML
    private ComboBox<Module> module;
    ObservableList<Module> listModule = FXCollections.observableArrayList();

    @FXML
    private TextField libelle;

    @FXML
    private TextArea description;

    @FXML
    private TextField credit;

    @FXML
    private ComboBox<Specialite> specialite;
    ObservableList<Specialite> listSpecialite = FXCollections.observableArrayList();

    @FXML
    private ComboBox<Niveau> niveau;
    ObservableList<Niveau> listNiveau = FXCollections.observableArrayList();

    @FXML
    private ComboBox<String> attributs;
    ObservableList<String> listAttributs = FXCollections.observableArrayList();

    @FXML
    private ComboBox<String> operateurs;
    ObservableList<String> listOperateurs = FXCollections.observableArrayList("<", ">", "<=", ">=", "=", "!=", "like", "in");

    @FXML
    private TextField valeurs;

    @FXML
    private ListView<String> listeFiltrage;

    @FXML
    private TableView<UE> table;
    ObservableList<UE> listeUes = FXCollections.observableArrayList();

    @FXML
    private TableColumn<UE, String> codeUeColumn;

    @FXML
    private TableColumn<UE, String> moduleColumn;

    @FXML
    private TableColumn<UE, String> libelleColumn;

    @FXML
    private TableColumn<UE, Integer> niveauColumn;

    @FXML
    private TableColumn<UE, String> specialiteColumn;

    @FXML
    private GridPane gridPane;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        try{
            listeNiveaux();
            listeSpecialites();
            listeModules();
            listUe();
            AfficheUe(null);
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> AfficheUe(newValue)));
        }catch(Exception e){
            e.getMessage();
        }
    }

    public void listeNiveaux() {
        listNiveau.addAll(new NiveauFacade().lister());
        niveau.setItems(listNiveau);
        AutoCompleteComboBoxListener<Niveau> Autocomplete = new AutoCompleteComboBoxListener<Niveau>(niveau);
    }

    public void listeSpecialites() {
        listSpecialite.addAll(new SpecialiteFacade().lister());
        specialite.setItems(listSpecialite);
        AutoCompleteComboBoxListener<Specialite> Autocomplete = new AutoCompleteComboBoxListener<Specialite>(specialite);
    }

    public void listeModules() {
        listModule.addAll(new ModuleFacade().lister());
        module.setItems(listModule);
        AutoCompleteComboBoxListener<Module> Autocomplete = new AutoCompleteComboBoxListener<Module>(module);
    }


    public void listUe() throws SQLException {

        if(Connexion.peutLire(UE.class)){
            filtrer(true);
            table.setItems(listeUes);
            activationDesactivationDetails(gridPane,false);
            codeUeColumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getCodeUE()));
            libelleColumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getLibelle()));
            moduleColumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getModule().getLibelle()));
            specialiteColumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getSpecialite().getLibelle()));
            niveauColumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getNiveau().getNumero()).asObject());

            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(UE.class);
            for (int i = 1; i <= resultSetMetaData.getColumnCount(); i++) {
                try {
                    listAttributs.add(resultSetMetaData.getColumnName(i));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            attributs.setItems(listAttributs);
        }
    }

    UE ueSelectionne = null;

    public void AfficheUe(UE ue){

        if (Connexion.peutLire(UE.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane, false);
            if(ue != null){
                ueSelectionne = ue;
                code.setText(String.valueOf(ue.getCode()));
                codeUe.setText(ue.getCodeUE());
                module.setValue(ue.getModule());
                libelle.setText(ue.getLibelle());
                description.setText(ue.getDescription());
                niveau.setValue(ue.getNiveau());
                specialite.setValue(ue.getSpecialite());
                credit.setText(String.valueOf(ue.getCredits()));
            }else{
                ueSelectionne = null;
                code.setText("");
                codeUe.setText("");
                module.setValue(null);
                libelle.setText("");
                description.setText("");
                niveau.setValue(null);
                specialite.setValue(null);
                credit.setText("");
            }
        }

    }

    @FXML
    public void handleNouvelleUe(){
        if (Connexion.peutEcrire(UE.class)) {
            ueSelectionne = null;
            //Raactivation de tous TextField du panneau des détails
            activationDesactivationDetails(gridPane,true);
            code.setText("");
            code.setText("");
            codeUe.setText("");
            module.setValue(null);
            libelle.setText("");
            description.setText("");
            niveau.setValue(null);
            specialite.setValue(null);
            credit.setText("");
        }
    }

    @FXML
    public void handleEditerUe(){
        if (ueSelectionne == null) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Aucune donnée à modifier");
            alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
            alert.show();
        }
        else if (Connexion.peutModifier(UE.class)) {
            activationDesactivationDetails(gridPane,true);
        }
    }

    UEFacade ueFacade = new UEFacade();

    @FXML
    public void handleEnregistrerUe(){

        if (Connexion.peutLire(UE.class) || Connexion.peutModifier(UE.class)) {
            try{
                String codeUE, libelleUE, descriptionUE, creditUE;
                codeUE = codeUe.getText();
                Module moduleUE = module.getValue();
                libelleUE = libelle.getText();
                descriptionUE = description.getText();
                Niveau niveauUe = niveau.getValue();
                Specialite specialiteUe = specialite.getValue();
                creditUE = credit.getText();

                String resultat;
                if(ueSelectionne == null){
                    resultat = ueFacade.enregistrer(libelleUE,descriptionUE,codeUE,UE.Statut.ACTIVE,moduleUE,niveauUe,specialiteUe,Integer.parseInt(creditUE));
                }else{
                    resultat = ueFacade.modifier(ueSelectionne, libelleUE, descriptionUE, codeUE, UE.Statut.ACTIVE,Integer.parseInt(creditUE), moduleUE, niveauUe, specialiteUe);
                }
                Alert alert = new Alert(Alert.AlertType.INFORMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Resultat de l'opération");
                alert.setContentText(resultat.toUpperCase() + " !");
                alert.show();
            }catch (Exception e) {
                e.printStackTrace();
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Erreur lors de l'opération");
                alert.setContentText(e.getMessage() + " !");
                alert.show();
            }
        }
        handleRaffraichir();
    }

    @FXML
    public void handleSupprimerUe() {

        if (Connexion.peutSupprimer(UE.class)) {
            try {
                if (ueSelectionne != null) {
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Confirmation de Suppression");
                    alert.setContentText("Voulez-vous vraiment supprimer la donnée ?");

                    Optional<ButtonType> result = alert.showAndWait();
                    if (result.get() == ButtonType.OK) {
                        String suppression = ueFacade.remove(ueSelectionne);
                        if (suppression != null && suppression.equalsIgnoreCase("succes"))
                            table.getItems().remove(ueSelectionne);
                        else {
                            alert = new Alert(Alert.AlertType.ERROR);
                            alert.initOwner(Appli.getPrimaryStage);
                            alert.setTitle("ISJ");
                            alert.setHeaderText("La donnée ne peut être supprimée.");
                            alert.setContentText("Il est possible qu'une contrainte d'intégrité empêche la suppression de la donnée.");
                            alert.show();
                        }
                    } else {
                        alert.close();
                    }

                } else {
                    Alert alert = new Alert(Alert.AlertType.WARNING);
                    alert.initOwner(Appli.getPrimaryStage);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Aucune donnée sélectionnée.");
                    alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
                    alert.show();
                }

            } catch (Exception e) {
                e.getMessage();
            }
        }
    }

    String requeteFiltrage = "select * from ue";

    @FXML
    public void handleImprimerUe() throws IOException {

        if (Connexion.peutLire(UE.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste des unités d'enseignements");
            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            selectionChampsReport.setSousTitre("Imprime à " + format.format(new Date()));
            selectionChampsReport.setOrientation(Page.Page_A4_Landscape());

            Stage dialogStage = new Stage();
            dialogStage.setTitle("Sélection des choix");
            Scene scene = new Scene(page);
            dialogStage.setScene(scene);
            dialogStage.show();
        }
    }

    @FXML
    public void handleAjouterCritere() {
        try {
            String attribut, operateur, valeur;
            attribut = attributs.getValue();
            operateur = operateurs.getValue();
            valeur = valeurs.getText();
            String critere = attribut + " " + operateur + " " + valeur;
            listeFiltrage.getItems().add(critere);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void handleSupprimerCritere() {
        try {
            int selectedIndex = listeFiltrage.getSelectionModel().getSelectedIndex();
            listeFiltrage.getItems().remove(selectedIndex);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //private boolean raffraichir = false;

    @FXML
    public void handleRaffraichir() {
        filtrer(true);
    }

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from ue";
        if (raffraichir == false) {
            String listeCriteres = "";
            for (int i = 0; i < listeFiltrage.getItems().size(); i++) {
                if (requeteFiltrage.contains(" where "))
                    listeCriteres = listeCriteres + " and " + listeFiltrage.getItems().get(i);
                else
                    listeCriteres = " where " + listeFiltrage.getItems().get(i);
            }
            requeteFiltrage = requeteFiltrage + listeCriteres;
        }
        listeUes.clear();
        listeUes.addAll(ueFacade.findAllNative(requeteFiltrage));
    }


    @FXML
    public void handleEtudiant() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Etudiant.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des étudiants");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleNote() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Note.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des notes");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleAnonymat() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Anonymat.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des anonymats");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleDiscipline() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Discipline.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des disciplines");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleEstInscrit() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/EstInscrit.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des candidats inscrits");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }


    @FXML
    public void handleAnneeAcademique() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/AnneeAcademique.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des années académiques");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleSemestre() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Semestre.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des semestres");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleEvaluation() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Evaluation.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des évaluations");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleTypeEvaluation() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/TypeEvaluation.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des types d'évaluation");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleHistoriqueNote() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/HistoriqueNote.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Historique des notes");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }


    @FXML
    public void handleClasse() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Classe.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des classes");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleFiliere() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Filiere.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des filières");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleNiveau() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Niveau.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des niveaux");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleSpecialite() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Specialite.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des spécialités");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }


    @FXML
    public void handleEnseignant() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Enseignant.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des enseignants");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleEnseignement() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Enseignement.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des enseignements");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleCandidat() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Candidat.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des candidats");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleModule() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Module.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des modules");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }


    @FXML
    public void handleUtilisateur() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Utilisateur.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des utilisateurs");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleRole() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Role.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des rôles");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleDroit() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Droit.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des droits");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }


    @FXML
    public void handleSms() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Sms.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des Sms");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleEmail() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Email.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des mails");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleEnvoiMessage() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/EnvoiMessage.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des messages envoyés");
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();
    }

    @FXML
    public void handleCharger(){
        try{
            FileChooser fileChooser = new FileChooser();

            // Set extension filter
            FileChooser.ExtensionFilter extFilter = new FileChooser.ExtensionFilter(
                    "Excel files (*.xlsx)", "*.xlsx");
            fileChooser.getExtensionFilters().add(extFilter);

            // Show save file dialog
            File file = fileChooser.showOpenDialog(Appli.getPrimaryStage);

            if (file != null) {
                new Isj().sauvegarderUe(file.getAbsolutePath());
                Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setContentText("SUCCES");
                alert.show();
            }
        }catch (Exception e){
            e.printStackTrace();
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setContentText("Veuillez vérifier les paramètres du fichier".toUpperCase() + "!");
            alert.show();
        }
        handleRaffraichir();
    }
}
