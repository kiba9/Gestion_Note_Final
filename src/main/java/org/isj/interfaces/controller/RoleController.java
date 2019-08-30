package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.css.Styleable;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.CheckBoxTableCell;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.beans.ChoixRole;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.*;
import org.isj.metier.facade.CandidatFacade;
import org.isj.metier.facade.ClasseFacade;
import org.isj.metier.facade.RoleFacade;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.*;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

/**
 * Cette classe permet de gérer les roles
 *
 * @author Interface
 */

public class RoleController implements Initializable {

    @FXML
    private TextField role;

    @FXML
    private TableView<Role> tableRole;
    ObservableList<Role> listeRole = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Role, Long> codecolumn;

    @FXML
    private TableColumn<Role, String> libellecolumn;

    @FXML
    private TableView<Droit> tableSelection;
    ObservableList<Droit> listeCategorieRole = FXCollections.observableArrayList();

    @FXML
    private TableColumn<Droit, String> categoriecolumn;

    @FXML
    private TableColumn<Droit, Boolean> lecturecolumn;

    @FXML
    private TableColumn<Droit, Boolean> ecriturecolumn;

    @FXML
    private TableColumn<Droit, Boolean> modificationcolumn;

    @FXML
    private TableColumn<Droit, Boolean> suppressioncolumn;

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

    public RoleController() {
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        try {
            ListeRole();
            ListeChoixRole();
            afficheDetail(null);
            tableRole.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    /**
     * Fonction permettant de lister les différents role dans un tableau
     *
     * @throws SQLException
     */
    public void ListeRole() throws SQLException {

        if (Connexion.peutLire(Role.class)) {

            filtrer(true);

            tableRole.setItems(listeRole);
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());
            libellecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getLibelle()));
            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp(Role.class);
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

    Role roleSelectionne=null;

    public void afficheDetail(Role role) {

        if (Connexion.peutLire(Role.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            //activationDesactivationDetails(gridPane,false);

            if (role != null) {
                roleSelectionne = role;
                this.role.setText(role.getLibelle());

                listeCategorieRole.clear();
                listeCategorieRole.addAll(role.getDroits());

                tableSelection.setEditable(true);
                categoriecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getCategorie()));

                lecturecolumn.setCellFactory(column -> new CheckBoxTableCell<>());
                lecturecolumn.setCellValueFactory(cellData -> {
                    Droit cellValue = cellData.getValue();
                    BooleanProperty property = new SimpleBooleanProperty(cellValue.isLecture());
                    // Add listener to handler change
                    property.addListener((observable, oldValue, newValue) -> cellValue.setLecture(newValue));
                    return property;
                });


                ecriturecolumn.setCellFactory(column -> new CheckBoxTableCell<>());
                ecriturecolumn.setCellValueFactory(cellData -> {
                    Droit cellValue = cellData.getValue();
                    BooleanProperty property = new SimpleBooleanProperty(cellValue.isEcriture());
                    // Add listener to handler change
                    property.addListener((observable, oldValue, newValue) -> cellValue.setEcriture(newValue));
                    return property;
                });

                modificationcolumn.setCellFactory(column -> new CheckBoxTableCell<>());
                modificationcolumn.setCellValueFactory(cellData -> {
                    Droit cellValue = cellData.getValue();
                    BooleanProperty property = new SimpleBooleanProperty(cellValue.isModification());
                    // Add listener to handler change
                    property.addListener((observable, oldValue, newValue) -> cellValue.setModification(newValue));
                    return property;
                });

                suppressioncolumn.setCellFactory(column -> new CheckBoxTableCell<>());
                suppressioncolumn.setCellValueFactory(cellData -> {
                    Droit cellValue = cellData.getValue();
                    BooleanProperty property = new SimpleBooleanProperty(cellValue.isSuppression());
                    // Add listener to handler change
                    property.addListener((observable, oldValue, newValue) -> cellValue.setSuppression(newValue));
                    return property;
                });

            }
        }
    }



    /**
     *         Droit d1 = new Droit("", "", AnneeAcademique.class.getSimpleName(), true, true, true, true, role);
     *         Droit d2 = new Droit("", "", Anonymat.class.getSimpleName(), true, true, true, true, role);
     *         Droit d3 = new Droit("", "", Candidat.class.getSimpleName(), true, true, true, true, role);
     *         Droit d4 = new Droit("", "", Classe.class.getSimpleName(), true, true, true, true, role);
     *         Droit d5 = new Droit("", "", Discipline.class.getSimpleName(), true, true, true, true, role);
     *         Droit d6 = new Droit("", "", Droit.class.getSimpleName(), true, true, true, true, role);
     *         Droit d7 = new Droit("", "", Email.class.getSimpleName(), true, true, true, true, role);
     *         Droit d8 = new Droit("", "", Enseignant.class.getSimpleName(), true, true, true, true, role);
     *         Droit d9 = new Droit("", "", Enseignement.class.getSimpleName(), true, true, true, true, role);
     *         Droit d10 = new Droit("", "", EnvoiMessage.class.getSimpleName(), true, true, true, true, role);
     *         Droit d11 = new Droit("", "", EstInscrit.class.getSimpleName(), true, true, true, true, role);
     *         Droit d12 = new Droit("", "", Etudiant.class.getSimpleName(), true, true, true, true, role);
     *         Droit d13 = new Droit("", "", Evaluation.class.getSimpleName(), true, true, true, true, role);
     *         Droit d14 = new Droit("", "", Filiere.class.getSimpleName(), true, true, true, true, role);
     *         Droit d15 = new Droit("", "", HistoriqueNote.class.getSimpleName(), true, true, true, true, role);
     *         Droit d16 = new Droit("", "", Message.class.getSimpleName(), true, true, true, true, role);
     *         Droit d17 = new Droit("", "", Module.class.getSimpleName(), true, true, true, true, role);
     *         Droit d18 = new Droit("", "", Niveau.class.getSimpleName(), true, true, true, true, role);
     *         Droit d19 = new Droit("", "", Note.class.getSimpleName(), true, true, true, true, role);
     *         Droit d20 = new Droit("", "", Personne.class.getSimpleName(), true, true, true, true, role);
     *         Droit d21 = new Droit("", "", Role.class.getSimpleName(), true, true, true, true, role);
     *         Droit d22 = new Droit("", "", Securite.class.getSimpleName(), true, true, true, true, role);
     *         Droit d23 = new Droit("", "", Semestre.class.getSimpleName(), true, true, true, true, role);
     *         Droit d24 = new Droit("", "", Session.class.getSimpleName(), true, true, true, true, role);
     *         Droit d25 = new Droit("", "", Specialite.class.getSimpleName(), true, true, true, true, role);
     *         Droit d26 = new Droit("", "", TypeEvaluation.class.getSimpleName(), true, true, true, true, role);
     *         Droit d27 = new Droit("", "", UE.class.getSimpleName(), true, true, true, true, role);
     *         Droit d28 = new Droit("", "", Utilisateur.class.getSimpleName()
     * @param listeEntites
     */
    public List<Class> classesEntites= Arrays.asList(new Class[]{AnneeAcademique.class,Anonymat.class,Candidat.class,Classe.class,Discipline.class,Droit.class,Email.class,Enseignant.class,Enseignement.class,EnvoiMessage.class,EstInscrit.class,Etudiant.class,Evaluation.class,Filiere.class,HistoriqueNote.class,Message.class,Module.class,Niveau.class,Note.class,Personne.class,Role.class,Securite.class,Semestre.class,Session.class,Specialite.class,TypeEvaluation.class,UE.class,Utilisateur.class});
            
    public void ListeChoixRole() {

/*        this.listeEntites = listeEntites;
        for(int i=0;i<listeEntites.size();i++) {
            listeCategorieRole.add(new ChoixRole(true, true, true, true, listeEntites.get(i)));
        }
        tableSelection.setItems(listeCategorieRole);

        categoriecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getCategorie()));

        tableSelection.setEditable(true);
        lecturecolumn.setCellFactory(column -> new CheckBoxTableCell<>());
        lecturecolumn.setCellValueFactory(cellData -> {
            ChoixRole cellValue = cellData.getValue();
            BooleanProperty property = new SimpleBooleanProperty(cellValue.isEcriture());
            // Add listener to handler change
            property.addListener((observable, oldValue, newValue) -> cellValue.setEcriture(newValue));
            return property;
        });*/
    }

    /**
     * Fonction permettant de vider les zones de détails d'un role pour en créer un autre
     */
    @FXML
    public void handleNouveau() {

    }

    /**
     * Fonction permettant d'éditer les informations d'un role
     */
    @FXML
    public void handleModifier() {

    }

    /**
     * Fonction permettant d'enregistrer un role dans la base de données
     */
    @FXML
    public void handleEnregistrer() {

    }

    RoleFacade roleFacade = new RoleFacade();

    /**
     * Fonction permettant de supprimer un role dans la base de données
     */
    @FXML
    public void handleSupprimer() {

    }

    private boolean raffraichir = false;

    @FXML
    public void handleRaffraichir() {
        filtrer(true);
    }

    @FXML
    public void handleImprimer() throws IOException {

        if (Connexion.peutLire(Role.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Liste des rôles");
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

    String requeteFiltrage = "select * from role";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from role";
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
        listeRole.clear();
        listeRole.addAll(roleFacade.findAllNative(requeteFiltrage));
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


}
