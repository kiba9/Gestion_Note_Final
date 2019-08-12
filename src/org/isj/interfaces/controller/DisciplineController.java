package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.css.Styleable;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.*;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

/**
 * Cette classe permet de gérer les disciplines
 *
 * @author Interface
 */
public class DisciplineController implements Initializable {


    @FXML
    private TextField code;

    @FXML
    private TextArea description;

    @FXML
    private TextField libelle;

    @FXML
    private TextField absence;

    @FXML
    private TextField retard;


    @FXML
    private ComboBox<Etudiant> etudiant;
    ObservableList<Etudiant> listeEtudiant = FXCollections.observableArrayList();


    @FXML
    private ComboBox<Semestre> semestre;
    ObservableList<Semestre> listeSemestre = FXCollections.observableArrayList();

    @FXML
    private TableView<Discipline> table;
    ObservableList<Discipline> listeDiscipline = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Discipline, Long> codecolumn;

    @FXML
    private TableColumn<Discipline, String> libellecolumn;

    @FXML
    private TableColumn<Discipline, Integer> absencecolumn;

    @FXML
    private TableColumn<Discipline,Integer > retardcolumn;

    @FXML
    private TableColumn<Discipline, Etudiant> etudiantcolumn;

    @FXML
    private TableColumn<Discipline, Semestre> semestrecolumn;

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

    public DisciplineController() {

    }
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        try {
            listDiscipline();
            afficheDetail(null);
            listeEtudiant();
            listeSemestre();
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    /**
     * Fonction permettant de lister les différents semestres
     */
    public void listeSemestre() {
        listeSemestre.addAll(new SemestreFacade().lister());
        semestre.setItems(listeSemestre);
        //classeAutocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }
    /**
     * Fonction permettant de lister les différents etudiants
     */
    public void listeEtudiant() {
        listeEtudiant.addAll(new EtudiantFacade().lister());
       etudiant.setItems(listeEtudiant);
        //classeAutocomplete = new AutoCompleteComboBoxListener<Classe>(classe);
    }

    public void listDiscipline() throws SQLException {

        if (Connexion.peutLire(Discipline.class)) {

            filtrer(true);

            table.setItems(listeDiscipline);
            activationDesactivationDetails(gridPane, false);
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());
            libellecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getLibelle()));
            absencecolumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getNbHeures()).asObject());
            retardcolumn.setCellValueFactory(cellData -> new SimpleIntegerProperty(cellData.getValue().getNbRetards()).asObject());
            etudiantcolumn.setCellValueFactory(cellData -> new SimpleObjectProperty<>(cellData.getValue().getEtudiant()));
            semestrecolumn.setCellValueFactory(cellData -> new SimpleObjectProperty<>(cellData.getValue().getSemestre()));


            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(Discipline.class);
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
     * Fonction permettant d'afficher les détails d'une discipline
     *
     * @param discipline variable de type DisciplineController
     */

    Discipline disciplineSelectionne = null;
    DisciplineFacade disciplineFacade = new DisciplineFacade();

    public void afficheDetail(Discipline discipline) {


        if (Connexion.peutLire(Discipline.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane, false);

            if (discipline != null) {
                disciplineSelectionne = discipline;
                code.setText(String.valueOf(discipline.getCode()));
                description.setText(discipline.getDescription());
                libelle.setText(discipline.getLibelle());
                absence.setText(String.valueOf(discipline.getNbHeures()));
                retard.setText(String.valueOf(discipline.getNbRetards()));
                etudiant.setValue(discipline.getEtudiant());
                semestre.setValue(discipline.getSemestre());
            }
        }
    }

    /**
     * Fonction permettant de vider les zones de détails d'un candidat pour en créer un autre
     */
    @FXML
    public void handleNouveau() {

        if (Connexion.peutEcrire(Discipline.class)) {
            disciplineSelectionne = null;
            //Raactivation de tous TextField du panneau des détails
            activationDesactivationDetails(gridPane, true);
            code.setText("");
            description.setText("");
            libelle.setText("");
            absence.setText("");
            retard.setText("");
            etudiant.setValue(null);
            semestre.setValue(null);
        }
    }


    /**
     * Fonction permettant d'éditer les informations d'un candidat
     */
    @FXML
    public void handleModifier() {

        if (disciplineSelectionne == null) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.initOwner(Appli.getPrimaryStage);
            alert.setTitle("ISJ");
            alert.setHeaderText("Aucune donnée à modifier");
            alert.setContentText("Veuillez sélectionner une ligne dans le tableau.");
            alert.show();
        } else if (Connexion.peutModifier(Discipline.class)) {
            activationDesactivationDetails(gridPane, true);
        }
    }

    /**
     * Fonction permettant de vérifier les informations entrées par l'utilisateur
     *
     * @return
     */


    /* Fonction permettant d'enregistrer un candidat dans la base de données
     */
    @FXML
    public void handleEnregistrer() {

        if (Connexion.peutLire(Discipline.class) || Connexion.peutModifier(Discipline.class)) {
            try {
                String descriptionDiscipline, libelleDiscipline,retardDiscipline,absenceDiscipline;

                descriptionDiscipline = description.getText();
                libelleDiscipline = libelle.getText();
                retardDiscipline = retard.getText();
               absenceDiscipline  = absence.getText();
                Etudiant etudiantclasse = etudiant.getSelectionModel().getSelectedItem();
                Semestre semestreclasse = semestre.getSelectionModel().getSelectedItem();

                //Classe classe = new ClasseFacade().find(new Long(4));
                String resultat;
                if (disciplineSelectionne == null)
                    resultat = disciplineFacade.enregistrer(libelleDiscipline, descriptionDiscipline, Integer.parseInt(absenceDiscipline), Integer.parseInt(retardDiscipline), etudiantclasse, semestreclasse, null, 0);
                else
                    resultat = disciplineFacade.modifier(disciplineSelectionne, libelleDiscipline, descriptionDiscipline, Integer.parseInt(absenceDiscipline), Integer.parseInt(retardDiscipline), etudiantclasse, semestreclasse, null, 0);

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



    /**
     * Fonction permettant de supprimer un candidat dans la base de données
     */
    @FXML
    public void handleSupprimer() {

        if (Connexion.peutSupprimer(Discipline.class)) {
            try {

                if (disciplineSelectionne != null) {
                    Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
                    alert.setTitle("ISJ");
                    alert.setHeaderText("Confirmation de Suppression");
                    alert.setContentText("Voulez-vous vraiment supprimer la donnée ?");

                    Optional<ButtonType> result = alert.showAndWait();
                    if (result.get() == ButtonType.OK) {
                        String suppression = disciplineFacade.remove(disciplineSelectionne);
                        if (suppression != null && suppression.equalsIgnoreCase("succes"))
                            table.getItems().remove(disciplineSelectionne);
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

        if (Connexion.peutLire(Discipline.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste de disciplines");
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

    String requeteFiltrage = "select * from discipline";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from discipline";
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
        listeDiscipline.clear();
        listeDiscipline.addAll(disciplineFacade.findAllNative(requeteFiltrage));
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
    public void handleEnseignement() throws Exception{
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(Appli.class.getResource("../view/Enseignement.fxml"));
        BorderPane page = loader.load();
        Stage dialogStage = new Stage();
        dialogStage.setTitle("Liste des enseignements");
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
        dialogStage.setTitle("Liste des Email");
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
}
