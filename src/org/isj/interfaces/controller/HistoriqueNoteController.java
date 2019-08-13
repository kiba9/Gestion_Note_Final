package org.isj.interfaces.controller;

import ar.com.fdvs.dj.domain.constants.Page;
import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.interfaces.main.Appli;
import org.isj.interfaces.util.litsenners.AutoCompleteComboBoxListener;
import org.isj.metier.Isj;
import org.isj.metier.entites.HistoriqueNote;
import org.isj.metier.entites.Note;
import org.isj.metier.facade.HistoriqueNoteFacade;
import org.isj.metier.facade.NoteFacade;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;
import java.util.ResourceBundle;

import static org.isj.interfaces.util.Util.activationDesactivationDetails;

public class HistoriqueNoteController implements Initializable {

    @FXML
    private TextField code;

    @FXML
    private TextField libelle;

    @FXML
    private TextField note;

    @FXML
    private TextField valeur_note;

    @FXML
    private TableView<HistoriqueNote> table;
    ObservableList<HistoriqueNote> listeHistoriqueNote = FXCollections.observableArrayList();

    @FXML
    private TableColumn<HistoriqueNote, String> libellecolumn;

    @FXML
    private TableColumn<HistoriqueNote, Double> valeurNotecolumn;

    @FXML
    private TableColumn<HistoriqueNote, Long> codecolumn;

    @FXML
    private TableColumn<HistoriqueNote, Double> noteColumn;

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

    public HistoriqueNoteController(){
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        operateurs.setItems(listOperateurs);
        try{
            listHistoriqueNote();
            afficheDetail(null);
            table.getSelectionModel().selectedItemProperty().addListener(((observable, oldValue, newValue) -> afficheDetail(newValue)));
        }catch(SQLException e){
            e.printStackTrace();
        }
    }

    /**
     * Fonction permettant de lister les différentes notes dans un tableau (numero, valeur)
     *
     * @throws SQLException
     */
    public void listHistoriqueNote() throws SQLException {

        if (Connexion.peutLire(HistoriqueNote.class)) {

            filtrer(true);

            table.setItems(listeHistoriqueNote);
            activationDesactivationDetails(gridPane, false);
            //libellecolumn.setCellValueFactory(cellData -> new SimpleStringProperty(cellData.getValue().getLibelle()));
            //noteColumn.setCellValueFactory(cellData -> new SimpleDoubleProperty(cellData.getValue().getNote().getValeurNote()).asObject());
            valeurNotecolumn.setCellValueFactory(cellData -> new SimpleDoubleProperty(cellData.getValue().getValeurNote()).asObject());
            codecolumn.setCellValueFactory(cellData -> new SimpleLongProperty(cellData.getValue().getCode()).asObject());

            ResultSetMetaData resultSetMetaData = new Isj().renvoyerChamp("historique_note");
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
     * Fonction permettant d'afficher les détails d'une note archivée
     *
     * @param historiqueNote variable de type CandidatController
     */

    HistoriqueNote historiqueNoteSelectionne = null;

    public void afficheDetail(HistoriqueNote historiquenote) {


        if (Connexion.peutLire(HistoriqueNote.class)) {
            //Desactivation de tous les TextFields du panneau des détails
            activationDesactivationDetails(gridPane,false);

            if (historiquenote != null) {
                historiqueNoteSelectionne = historiquenote;
                code.setText(String.valueOf(historiquenote.getCode()));
                libelle.setText(historiquenote.getLibelle());
                note.setText(historiquenote.getNote().toString());
                valeur_note.setText(String.valueOf(historiquenote.getValeurNote()));
            } else {
                code.setText("");
                libelle.setText("");
                valeur_note.setText("");
                note.setText("");
            }
        }
    }

    /**
     * Fonction permettant de vider les zones de détails d'une note pour en créer un autre
    */
    @FXML
    public void handleNouveau() {

    }

    /**
     * Fonction permettant d'éditer les informations d'un candidat
     */
    @FXML
    public void handleModifier() {

    }

    /**
     * Fonction permettant d'enregistrer une note dans la base de données
     */


    HistoriqueNoteFacade historiqueNoteFacade = new HistoriqueNoteFacade();

    /**
     * Fonction permettant de supprimer une note dans la base de données
     */
    @FXML
    public void handleSupprimer() {

    }

    @FXML
    public void handleEnregistrer() {

    }

    private boolean raffraichir = false;

    @FXML
    public void handleRaffraichir() {
        filtrer(true);
    }

    @FXML
    public void handleImprimer() throws IOException {

        if (Connexion.peutLire(HistoriqueNote.class)) {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Appli.class.getResource("../view/selectionChampsReport.fxml"));

            BorderPane page = loader.load();

            SelectionChampsReport selectionChampsReport = loader.getController();

            selectionChampsReport.setAttributs(listAttributs);
            selectionChampsReport.setRequete(requeteFiltrage);
            selectionChampsReport.setTitre("Historique des Notes");
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

    String requeteFiltrage = "select * from historique_note";

    @FXML
    public void handleFiltrer() {

        filtrer(false);
    }

    private void filtrer(boolean raffraichir) {

        requeteFiltrage = "select * from historique_note";
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
        listeHistoriqueNote.clear();
        listeHistoriqueNote.addAll(historiqueNoteFacade.findAllNative(requeteFiltrage));
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

}
