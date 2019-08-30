package org.isj.interfaces.main;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import javafx.stage.Window;

import java.io.File;
import java.io.IOException;

public class Appli extends Application {

    public static Window getPrimaryStage;
    private Stage primaryStage;

    @Override
    public void start(Stage primaryStage) {
        try{
            this.primaryStage = primaryStage;
            this.primaryStage.setTitle("ISJ Application");
            this.primaryStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));

            showSeConnecter();
        }catch (Exception e){
            e.printStackTrace();
            e.getMessage();
        }

    }

    public void showSeConnecter(){
        try {
            if(!new File("config.properties").exists()){
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/Properties.fxml"));
                BorderPane page = loader.load();
                Stage dialogStage = new Stage();
                dialogStage.setTitle("Propriétés de l'application");
                dialogStage.getIcons().add(new Image("org/isj/interfaces/images/logo_isj.jpeg"));
                Scene scene = new Scene(page);
                dialogStage.setScene(scene);
                dialogStage.show();
            }else{
                FXMLLoader loader = new FXMLLoader();
                loader.setLocation(Appli.class.getResource("../view/Connexion.fxml"));
                AnchorPane connex = loader.load();

                Scene fen = new Scene(connex);
                primaryStage.setScene(fen);
                primaryStage.show();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public Stage getPrimaryStage(){

        return primaryStage;
    }

    public static void main(String[] args) {
        launch(args);
    }
}
