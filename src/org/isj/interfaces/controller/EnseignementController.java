package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.EnseignantFacade;
import org.isj.metier.facade.EnseignementFacade;
import org.isj.metier.facade.SemestreFacade;
import org.isj.metier.facade.UEFacade;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

public class EnseignementController implements Initializable {

    @FXML
    private TextField libelle;

    @FXML
    private TextArea description;

    @FXML
    private TextArea programmeDeCours;

    @FXML
    private TextField heuresDeCours;

    @FXML
    private TextField code;

    @FXML
    private ComboBox<Semestre> semestre;
    ObservableList<Semestre> listeSemestres = FXCollections.observableArrayList();

    @FXML
    private ComboBox<UE> ue;
    ObservableList<UE> listeUEs = FXCollections.observableArrayList();

    @FXML
    private TableView<Enseignement> table;
    ObservableList<Enseignement> listeEnseignements = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Enseignement, String> libellecolumn;

    @FXML
    private TableColumn<Enseignement, Integer> heuresDeCourscolumn;

    @FXML
    private TableColumn<Enseignement, UE> uecolumn;

    @FXML
    private TableColumn<Enseignement, Long> semestrecolumn;

    @FXML
    private TableColumn<Enseignement, Long> codecolumn;

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

    public EnseignementController() {

    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        try {
            listEnseignement();
            afficheDetail(null);
            listeUe();
            listeSemestre();
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //AutoCompleteComboBoxListener<Classe> classeAutocomplete;

    /**
     * Fonction permettant de lister les différentes ues concernées par un enseignement
     */
    public void listeUe() {
        listeUEs.addAll(new UEFacade().lister());
        ue.setItems(listeUEs);
        //classeAutocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    /**
     * Fonction permettant de lister les différents semestres
     */
    public void listeSemestre() {
        listeSemestres.addAll(new SemestreFacade().lister());
        semestre.setItems(listeSemestres);
        //classeAutocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    /**
     * Fonction permettant de lister les différents enseignements dans un tableau
     *
     * @throws SQLException
     */
    public void listEnseignement() throws SQLException {

        if (Connexion.peutLire(Enseignement.class)) {

            filtrer(true);

            table.setItems(listeEnseignements);
            activationDesactivationDetails(gridPane,false);
            libellecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getLibelle()));
            heuresDeCourscolumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getHeuresDeCours()).asObject());
            uecolumn.setCellValueFactory(cellData -> new SimpleObjectProperty(cellData.getValue().getUe()));
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());
            semestrecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());

            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(Enseignement.class);
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

    /**
     * Fonction permettant d'afficher les détails d'un enseignement
     *
     * @param enseignement variable de type EnseignementController
     */

    Enseignement enseignementSelectionne = null;

    public void afficheDetail(Enseignement enseignement) {


        if (Connexion.peutLire(Enseignement.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane,false);

            if (enseignement != null) {
                enseignementSelectionne = enseignement;
                code.setText(String.valueOf(enseignement.getCode()));
                libelle.setText(enseignement.getLibelle());
                description.setText(enseignement.getDescription());
                heuresDeCours.setText(Integer.toString(enseignement.getHeuresDeCours()));
                programmeDeCours.setText(enseignement.getProgrammeDeCours());
                ue.setValue(enseignement.getUe());
                semestre.setValue(enseignement.getSemestre());
            } else {
                enseignementSelectionne = null;
                code.setText("");
                libelle.setText("");
                description.setText("");
                heuresDeCours.setText("");
                programmeDeCours.setText("");
                ue.setValue(null);
                semestre.setValue(null);
            }
        }
    }


    /**
     * Fonction permettant de vider les zones de détails d'un enseignement pour en créer un autre
     */
    @FXML
    public void handleNouveau() {

        if (Connexion.peutEcrire(Enseignement.class)) {
            enseignementSelectionne = null;
            //Reactivation de tous TextField du panneau des détails
            activationDesactivationDetails(gridPane,true);
            code.setText("");
            libelle.setText("");
            description.setText("");
            heuresDeCours.setText("");
            programmeDeCours.setText("");
            ue.setValue(null);
            semestre.setValue(null);
        }
    }

    /**
     * Fonction permettant d'éditer les informations d'un enseignement
     */
    @FXML
    public void handleModifier() {

        if (enseignementSelectionne == null) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Aucune donnée à modifier");
            alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
            alert.show();
        }
        else if (Connexion.peutModifier(Enseignement.class)) {
            activationDesactivationDetails(gridPane,true);
        }
    }

    /**
     * Fonction permettant de vérifier les informations entrées par l'utilisateur
     *
     * @return
     */
    public boolean verifierValeurs() {
        String errorMessage = "";

        if (libelle.getText() == null || libelle.getText().length() == 0) {
            errorMessage += "Libelle mal écrit!\n";
        }
        if (programmeDeCours.getText() == null || programmeDeCours.getText().length() == 0) {
            errorMessage += "Programme de cours mal écrit!\n";
        }

        /*if (date.getValue() == null || date.getValue().compareTo(null) == 0) {
            errorMessage += "rien coché!\n";
        }*/
        if (heuresDeCours.getText() == null || heuresDeCours.getText().length() == 0) {
            errorMessage += "Heures de cours non saisies!\n";
        }
        if (description.getText() == null || description.getText().length() == 0) {
            errorMessage += "Nom du père non saisi!\n";
        }

        if (errorMessage.length() == 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Fonction permettant d'enregistrer un enseignement dans la base de données
     */
    @FXML
    public void handleEnregistrer() {

        if (Connexion.peutLire(Enseignement.class) || Connexion.peutModifier(Enseignement.class)) {
            try {
                String libelleEnseignement, descriptionEnseignement,heuresDeCoursEnseignement, programmeDeCoursEnseignement;
                libelleEnseignement = libelle.getText();
                descriptionEnseignement = description.getText();
                heuresDeCoursEnseignement = heuresDeCours.getText();
                programmeDeCoursEnseignement= programmeDeCours.getText();
                UE ueEnseignement = ue.getSelectionModel().getSelectedItem();
                Semestre semestreEnseignement = semestre.getSelectionModel().getSelectedItem();

                String resultat;
                if (enseignementSelectionne == null) {
                    Enseignement enseignement = new Enseignement(libelleEnseignement,descriptionEnseignement,Integer.parseInt(heuresDeCoursEnseignement),programmeDeCoursEnseignement,semestreEnseignement,ueEnseignement);
                    resultat = enseignementFacade.create(enseignement);
                }else {
                    resultat = new EnseignementFacade().modifier(enseignementSelectionne,libelleEnseignement,descriptionEnseignement,Integer.parseInt(heuresDeCoursEnseignement),programmeDeCoursEnseignement,semestreEnseignement,ueEnseignement);
                }
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


    EnseignementFacade enseignementFacade = new EnseignementFacade();

    /**
     * Fonction permettant de supprimer un candidat dans la base de données
     */
    @FXML
    public void handleSupprimer() {

        if (Connexion.peutSupprimer(Enseignement.class)) {
            try {

                if (enseignementSelectionne != null) {
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Confirmation de Suppression");
                    alert.setContentText("Voulez-vous vraiment supprimer la donnée ?");

                    Optional<ButtonType> result = alert.showAndWait();
                    if (result.get() == ButtonType.OK) {
                        String suppression = enseignementFacade.remove(enseignementSelectionne);
                        if (suppression != null && suppression.equalsIgnoreCase("succes"))
                            table.getItems().remove(enseignementSelectionne);
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

        if (Connexion.peutLire(Enseignement.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste des enseignements");
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

    String requeteFiltrage = "select * from enseignement";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from enseignement";
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
        listeEnseignements.clear();
        listeEnseignements.addAll(enseignementFacade.findAllNative(requeteFiltrage));
    }

    @FXML
    public void handleEtudiant() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Etudiant.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des étudiants");
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
        dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
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
                new Isj().sauvegarderEnseignement(file.getAbsolutePath());
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
