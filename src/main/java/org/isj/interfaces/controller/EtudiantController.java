
package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.ClasseFacade;
import org.isj.metier.facade.EtudiantFacade;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

public class EtudiantController implements Initializable {

    @FXML
    private TextField nom;

    @FXML
    private TextField prenom;

    @FXML
    private RadioButton masculin;

    @FXML
    private RadioButton feminin;

    @FXML
    private DatePicker date;

    @FXML
    private TextField telephone;

    @FXML
    private TextField code;

    @FXML
    private TextField codeauthentification;

    @FXML
    private TextField email;

    @FXML
    private TextField ecoleOrigine;

    @FXML
    private TextField regionOrigine;

    @FXML
    private TextField nompere;

    @FXML
    private TextField profpere;

    @FXML
    private TextField telpere;

    @FXML
    private TextField nommere;

    @FXML
    private TextField profmere;

    @FXML
    private TextField telmere;

    @FXML
    private TextField matricule;

    @FXML
    private ComboBox<Classe> classe;
    ObservableList<Classe> listeClasse = FXCollections.observableArrayList();

    @FXML
    private TableView<Etudiant> table;
    ObservableList<Etudiant> listeEtudiants = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Etudiant, String> nomcolumn;

    @FXML
    private TableColumn<Etudiant, String> prenomcolumn;

    @FXML
    private TableColumn<Etudiant, Long> codecolumn;

    @FXML
    private TableColumn<Etudiant, String> datecolumn;

    @FXML
    private TableColumn<Etudiant, String> sexecolumn;

    @FXML
    private TableColumn<Etudiant, Integer> telcolumn;

    @FXML
    private TableColumn<Etudiant, String> emailcolumn;

    @FXML
    private TableColumn<Etudiant, String> matriculecolumn;

    @FXML
    private TableColumn<Etudiant, String> classecolumn;

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
    private GridPane gridPane;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        table.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
        try{
            listeClasses();
            listEtudiants();
            afficheDetail(null);
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void listeClasses() {
        listeClasse.addAll(new ClasseFacade().lister());
        classe.setItems(listeClasse);
        AutoCompleteComboBoxListener<Classe> Autocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    public void listEtudiants() throws SQLException {

        if ((Connexion.peutLire(Etudiant.class))) {

            filtrer(true);

            table.setItems(listeEtudiants);
            activationDesactivationDetails(gridPane, false);
            nomcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getNom()));
            prenomcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getPrenom()));
            emailcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getEmail()));
            telcolumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getTelephone()).asObject());
            sexecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getSexe().toString()));
            matriculecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getMatricule()));
            classecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getClasse().toString()));
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());
            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
            datecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(format.format(cellData.getValue().getDateNaissance())));

            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(Etudiant.class);

            for (int i = 1; i <= resultSetMetaData.getColumnCount(); i++) {
                try {
                    listAttributs.add(resultSetMetaData.getColumnName(i));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    Etudiant etudiantSelectionne = null;

    public void afficheDetail(Etudiant etudiant) {


        if (Connexion.peutLire(Etudiant.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane,false);

            if (etudiant != null) {
                etudiantSelectionne = etudiant;
                code.setText(String.valueOf(etudiant.getCode()));
                codeauthentification.setText(String.valueOf(etudiant.getCodeAuthentification()));
                matricule.setText(etudiant.getMatricule());
                nom.setText(etudiant.getNom());
                prenom.setText(etudiant.getPrenom());
                if (etudiant.getSexe().equals(Personne.Sexe.FEMININ)) {
                    feminin.setSelected(true);
                    masculin.setSelected(false);
                } else {
                    feminin.setSelected(false);
                    masculin.setSelected(true);
                }
                date.setValue(etudiant.getDateNaissance().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
                telephone.setText(Integer.toString(etudiant.getTelephone()));
                email.setText(etudiant.getEmail());
                ecoleOrigine.setText(etudiant.getEcoleOrigine());
                regionOrigine.setText(etudiant.getRegionOrigine());
                classe.setValue(etudiant.getClasse());
                nompere.setText(etudiant.getNomDuPere());
                telpere.setText(Integer.toString(etudiant.getTelephoneDuPere()));
                profpere.setText(etudiant.getProfessionDuPere());
                nommere.setText(etudiant.getNomDeLaMere());
                telmere.setText(Integer.toString(etudiant.getTelephoneDeLaMere()));
                profmere.setText(etudiant.getProfessionDelaMere());
            } else {
                etudiantSelectionne = null;
                code.setText("");
                codeauthentification.setText("");
                matricule.setText("");
                nom.setText("");
                prenom.setText("");
                masculin.setSelected(false);
                date.setValue(null);
                telephone.setText("");
                email.setText("");
                ecoleOrigine.setText("");
                regionOrigine.setText("");
                classe.setValue(null);
                nompere.setText("");
                telpere.setText("");
                profpere.setText("");
                nommere.setText("");
                telmere.setText("");
                profmere.setText("");
            }
        }
    }

    @FXML
    public void handleNouveau() {

        if (Connexion.peutEcrire(Etudiant.class)) {
            etudiantSelectionne = null;
            //Réactivation de tous TextField du panneau des détails
            activationDesactivationDetails(gridPane,true);
            code.setText("");
            codeauthentification.setText("");
            nom.setText("");
            prenom.setText("");
            feminin.setSelected(false);
            masculin.setSelected(true);
            date.setValue(null);
            telephone.setText("");
            email.setText("");
            ecoleOrigine.setText("");
            regionOrigine.setText("");
            nompere.setText("");
            telpere.setText("");
            profpere.setText("");
            nommere.setText("");
            telmere.setText("");
            profmere.setText("");
            classe.setValue(null);
        }
    }

    @FXML
    public void handleModifier() {

        if (etudiantSelectionne == null) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Aucune donnée à modifier");
            alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
            alert.show();
            System.out.println();
        }
        else if (Connexion.peutModifier(Etudiant.class)) {
            activationDesactivationDetails(gridPane,true);
        }
    }

    EtudiantFacade etudiantFacade = new EtudiantFacade();
    @FXML
    public void handleEnregistrer() {

        if (Connexion.peutLire(Etudiant.class) || Connexion.peutModifier(Etudiant.class)) {
            try {
                String matriculeEtudiant, nomEtudiant, prenomEtudiant, regionO, ecoleO, emailEtudiant, telephoneEtudiant, nompereEtudiant, profpereEtudiant, telpereEtudiant, nommereEtudiant, profmereEtudiant, telmereEtudiant, codeauthentificationEtudiant;
                nomEtudiant = nom.getText();
                prenomEtudiant = prenom.getText();
                telephoneEtudiant = telephone.getText();
                regionO = regionOrigine.getText();
                ecoleO = ecoleOrigine.getText();
                emailEtudiant= email.getText();
                nompereEtudiant = nompere.getText();
                profpereEtudiant = profpere.getText();
                telpereEtudiant = telpere.getText();
                nommereEtudiant = nommere.getText();
                profmereEtudiant = profmere.getText();
                telmereEtudiant = telmere.getText();
                matriculeEtudiant = matricule.getText();
                codeauthentificationEtudiant = codeauthentification.getText();
                Classe classeEtudiant = classe.getSelectionModel().getSelectedItem();

                Personne.Sexe sexe = masculin.isSelected() ? Personne.Sexe.MASCULIN : Personne.Sexe.FEMININ;
                Date dateNaissance = Date.from(date.getValue().atStartOfDay(ZoneId.systemDefault()).toInstant());

                String resultat;
                if (etudiantSelectionne == null)
                    resultat = etudiantFacade.enregistrer("", "", nomEtudiant, prenomEtudiant, emailEtudiant, Integer.parseInt(telephoneEtudiant), dateNaissance, sexe, Personne.Statut.ACTIVE, nompereEtudiant, profpereEtudiant, Integer.parseInt(telmereEtudiant), Integer.parseInt(telpereEtudiant), nommereEtudiant, profmereEtudiant, regionO, ecoleO, matriculeEtudiant, codeauthentificationEtudiant, classeEtudiant);
                else
                    resultat = etudiantFacade.modifier(etudiantSelectionne, "", "", nomEtudiant, prenomEtudiant, emailEtudiant, Integer.parseInt(telephoneEtudiant), dateNaissance, sexe, Personne.Statut.ACTIVE, nompereEtudiant, profpereEtudiant, Integer.parseInt(telmereEtudiant), Integer.parseInt(telpereEtudiant), nommereEtudiant, profmereEtudiant, regionO, ecoleO, matriculeEtudiant, codeauthentificationEtudiant, classeEtudiant);

                Alert alert = new Alert(Alert.AlertType.INFORMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Resultat de l'opération");
                alert.setContentText(resultat.toUpperCase() + " !");
                alert.show();

            } catch (Exception e) {
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
    public void handleSupprimer() {

        if (Connexion.peutSupprimer(Etudiant.class)) {
            try {

                if (etudiantSelectionne != null) {
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Confirmation de Suppression");
                    alert.setContentText("Voulez-vous vraiment supprimer la donnée ?");

                    Optional<ButtonType> result = alert.showAndWait();
                    if (result.get() == ButtonType.OK) {
                        String suppression = etudiantFacade.remove(etudiantSelectionne);
                        if (suppression != null && suppression.equalsIgnoreCase("succes"))
                            table.getItems().remove(etudiantSelectionne);
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

    private boolean raffraichir = false;

    @FXML
    public void handleRaffraichir() {
        filtrer(true);
    }

    @FXML
    public void handleImprimer() throws IOException {

        if (Connexion.peutLire(Etudiant.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste des étudiants");
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

    String requeteFiltrage = "select * from etudiant";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from etudiant";
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
        listeEtudiants.clear();
        listeEtudiants.addAll(etudiantFacade.findAllNative(requeteFiltrage));
    }

    @FXML
    public void handleReleve() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/ChoixReleve.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();

        ObservableList<Etudiant> selectedItems = table.getSelectionModel().getSelectedItems();

        for(Etudiant e : selectedItems){
            System.out.println("selected item " + e.getMatricule());
        }

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
    public void handleUe() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Ue.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des unités d'enseignement");
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
    public void handleenvoyer(ActionEvent event) {

        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Typemessage.fxml"));
        AnchorPane page = null;
        try {
            page = loader.load();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Type de message");
        Scene scene = new Scene(page);
        dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
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
                //Isj.chargerEtudiant(file);
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

package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.ClasseFacade;
import org.isj.metier.facade.EtudiantFacade;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

public class EtudiantController implements Initializable {

    @FXML
    private TextField nom;

    @FXML
    private TextField prenom;

    @FXML
    private RadioButton masculin;

    @FXML
    private RadioButton feminin;

    @FXML
    private DatePicker date;

    @FXML
    private TextField telephone;

    @FXML
    private TextField code;

    @FXML
    private TextField codeauthentification;

    @FXML
    private TextField email;

    @FXML
    private TextField ecoleOrigine;

    @FXML
    private TextField regionOrigine;

    @FXML
    private TextField nompere;

    @FXML
    private TextField profpere;

    @FXML
    private TextField telpere;

    @FXML
    private TextField nommere;

    @FXML
    private TextField profmere;

    @FXML
    private TextField telmere;

    @FXML
    private TextField matricule;

    @FXML
    private ComboBox<Classe> classe;
    ObservableList<Classe> listeClasse = FXCollections.observableArrayList();


    @FXML
    private TableView<Etudiant> table;
    ObservableList<Etudiant> listeEtudiants = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Etudiant, String> nomcolumn;

    @FXML
    private TableColumn<Etudiant, String> prenomcolumn;

    @FXML
    private TableColumn<Etudiant, Long> codecolumn;

    @FXML
    private TableColumn<Etudiant, String> datecolumn;

    @FXML
    private TableColumn<Etudiant, String> sexecolumn;

    @FXML
    private TableColumn<Etudiant, Integer> telcolumn;

    @FXML
    private TableColumn<Etudiant, String> emailcolumn;

    @FXML
    private TableColumn<Etudiant, String> matriculecolumn;

    @FXML
    private TableColumn<Etudiant, String> classecolumn;

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
    private GridPane gridPane;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        table.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
        try{
            listeClasses();
            listEtudiants();
            afficheDetail(null);
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void listeClasses() {
        listeClasse.addAll(new ClasseFacade().lister());
        classe.setItems(listeClasse);
        AutoCompleteComboBoxListener<Classe> Autocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    public void listEtudiants() throws SQLException {

        if ((Connexion.peutLire(Etudiant.class))) {

            filtrer(true);

            table.setItems(listeEtudiants);
            activationDesactivationDetails(gridPane, false);
            nomcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getNom()));
            prenomcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getPrenom()));
            emailcolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getEmail()));
            telcolumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getTelephone()).asObject());
            sexecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getSexe().toString()));
            matriculecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getMatricule()));
            classecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getClasse().toString()));
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());
            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
            datecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(format.format(cellData.getValue().getDateNaissance())));

            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(Etudiant.class);

            for (int i = 1; i <= resultSetMetaData.getColumnCount(); i++) {
                try {
                    listAttributs.add(resultSetMetaData.getColumnName(i));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    Etudiant etudiantSelectionne = null;

    public void afficheDetail(Etudiant etudiant) {


        if (Connexion.peutLire(Etudiant.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane,false);

            if (etudiant != null) {
                etudiantSelectionne = etudiant;
                code.setText(String.valueOf(etudiant.getCode()));
                codeauthentification.setText(String.valueOf(etudiant.getCodeAuthentification()));
                matricule.setText(etudiant.getMatricule());
                nom.setText(etudiant.getNom());
                prenom.setText(etudiant.getPrenom());
                if (etudiant.getSexe().equals(Personne.Sexe.FEMININ)) {
                    feminin.setSelected(true);
                    masculin.setSelected(false);
                } else {
                    feminin.setSelected(false);
                    masculin.setSelected(true);
                }
                date.setValue(etudiant.getDateNaissance().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
                telephone.setText(Integer.toString(etudiant.getTelephone()));
                email.setText(etudiant.getEmail());
                ecoleOrigine.setText(etudiant.getEcoleOrigine());
                regionOrigine.setText(etudiant.getRegionOrigine());
                classe.setValue(etudiant.getClasse());
                nompere.setText(etudiant.getNomDuPere());
                telpere.setText(Integer.toString(etudiant.getTelephoneDuPere()));
                profpere.setText(etudiant.getProfessionDuPere());
                nommere.setText(etudiant.getNomDeLaMere());
                telmere.setText(Integer.toString(etudiant.getTelephoneDeLaMere()));
                profmere.setText(etudiant.getProfessionDelaMere());
            } else {
                etudiantSelectionne = null;
                code.setText("");
                codeauthentification.setText("");
                matricule.setText("");
                nom.setText("");
                prenom.setText("");
                masculin.setSelected(false);
                date.setValue(null);
                telephone.setText("");
                email.setText("");
                ecoleOrigine.setText("");
                regionOrigine.setText("");
                classe.setValue(null);
                nompere.setText("");
                telpere.setText("");
                profpere.setText("");
                nommere.setText("");
                telmere.setText("");
                profmere.setText("");
            }
        }
    }

    @FXML
    public void handleNouveau() {

        if (Connexion.peutEcrire(Etudiant.class)) {
            etudiantSelectionne = null;
            //Réactivation de tous TextField du panneau des détails
            activationDesactivationDetails(gridPane,true);
            code.setText("");
            codeauthentification.setText("");
            nom.setText("");
            prenom.setText("");
            feminin.setSelected(false);
            masculin.setSelected(true);
            date.setValue(null);
            telephone.setText("");
            email.setText("");
            ecoleOrigine.setText("");
            regionOrigine.setText("");
            nompere.setText("");
            telpere.setText("");
            profpere.setText("");
            nommere.setText("");
            telmere.setText("");
            profmere.setText("");
            classe.setValue(null);
        }
    }

    @FXML
    public void handleModifier() {

        if (etudiantSelectionne == null) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Aucune donnée à modifier");
            alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
            alert.show();
        }
        else if (Connexion.peutModifier(Etudiant.class)) {
            activationDesactivationDetails(gridPane,true);
        }
    }

    EtudiantFacade etudiantFacade = new EtudiantFacade();
    @FXML
    public void handleEnregistrer() {

        if (Connexion.peutLire(Etudiant.class) || Connexion.peutModifier(Etudiant.class)) {
            try {
                String matriculeEtudiant, nomEtudiant, prenomEtudiant, regionO, ecoleO, emailEtudiant, telephoneEtudiant, nompereEtudiant, profpereEtudiant, telpereEtudiant, nommereEtudiant, profmereEtudiant, telmereEtudiant, codeauthentificationEtudiant;
                nomEtudiant = nom.getText();
                prenomEtudiant = prenom.getText();
                telephoneEtudiant = telephone.getText();
                regionO = regionOrigine.getText();
                ecoleO = ecoleOrigine.getText();
                emailEtudiant= email.getText();
                nompereEtudiant = nompere.getText();
                profpereEtudiant = profpere.getText();
                telpereEtudiant = telpere.getText();
                nommereEtudiant = nommere.getText();
                profmereEtudiant = profmere.getText();
                telmereEtudiant = telmere.getText();
                matriculeEtudiant = matricule.getText();
                codeauthentificationEtudiant = codeauthentification.getText();
                Classe classeEtudiant = classe.getSelectionModel().getSelectedItem();

                Personne.Sexe sexe = masculin.isSelected() ? Personne.Sexe.MASCULIN : Personne.Sexe.FEMININ;
                Date dateNaissance = Date.from(date.getValue().atStartOfDay(ZoneId.systemDefault()).toInstant());

                String resultat;
                if (etudiantSelectionne == null)
                    resultat = etudiantFacade.enregistrer("", "", nomEtudiant, prenomEtudiant, emailEtudiant, Integer.parseInt(telephoneEtudiant), dateNaissance, sexe, Personne.Statut.ACTIVE, nompereEtudiant, profpereEtudiant, Integer.parseInt(telmereEtudiant), Integer.parseInt(telpereEtudiant), nommereEtudiant, profmereEtudiant, regionO, ecoleO, matriculeEtudiant, codeauthentificationEtudiant, classeEtudiant);
                else
                    resultat = etudiantFacade.modifier(etudiantSelectionne, "", "", nomEtudiant, prenomEtudiant, emailEtudiant, Integer.parseInt(telephoneEtudiant), dateNaissance, sexe, Personne.Statut.ACTIVE, nompereEtudiant, profpereEtudiant, Integer.parseInt(telmereEtudiant), Integer.parseInt(telpereEtudiant), nommereEtudiant, profmereEtudiant, regionO, ecoleO, matriculeEtudiant, codeauthentificationEtudiant, classeEtudiant);

                Alert alert = new Alert(Alert.AlertType.INFORMATION);
                alert.initOwner(Appli.getPrimaryStage);
                alert.setTitle("ISJ");
                alert.setHeaderText("Resultat de l'opération");
                alert.setContentText(resultat.toUpperCase() + " !");
                alert.show();

            } catch (Exception e) {
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
    public void handleSupprimer() {

        if (Connexion.peutSupprimer(Etudiant.class)) {
            try {

                if (etudiantSelectionne != null) {
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Confirmation de Suppression");
                    alert.setContentText("Voulez-vous vraiment supprimer la donnée ?");

                    Optional<ButtonType> result = alert.showAndWait();
                    if (result.get() == ButtonType.OK) {
                        String suppression = etudiantFacade.remove(etudiantSelectionne);
                        if (suppression != null && suppression.equalsIgnoreCase("succes"))
                            table.getItems().remove(etudiantSelectionne);
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

    private boolean raffraichir = false;

    @FXML
    public void handleRaffraichir() {
        filtrer(true);
    }

    @FXML
    public void handleImprimer() throws IOException {

        if (Connexion.peutLire(Etudiant.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste des étudiants");
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

    String requeteFiltrage = "select * from etudiant";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from etudiant";
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
        listeEtudiants.clear();
        listeEtudiants.addAll(etudiantFacade.findAllNative(requeteFiltrage));
    }

    @FXML
    public void handleReleve() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/ChoixReleve.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        Scene scene = new Scene(page);
        dialogStage.setScene(scene);
        dialogStage.show();

        ObservableList<Etudiant> selectedItems = table.getSelectionModel().getSelectedItems();

        for(Etudiant e : selectedItems){
            System.out.println("selected item " + e.getMatricule());
        }

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
    public void handleUe() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Ue.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des unités d'enseignement");
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
    public void handleenvoyer(ActionEvent event) {

        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Typemessage.fxml"));
        AnchorPane page = null;
        try {
            page = loader.load();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Type de message");
        Scene scene = new Scene(page);
        dialogStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
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
                //Isj.chargerEtudiant(file);
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

