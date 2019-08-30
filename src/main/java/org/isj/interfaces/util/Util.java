package org.isj.interfaces.util;

import javafx.collections.ObservableList;
import javafx.css.Styleable;
import javafx.scene.Node;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;

public class Util {


    public static void activationDesactivationDetails(GridPane gridPane, boolean activation) {

        ObservableList<Node> childrens = gridPane.getChildren();
        for (int i = 0; i < childrens.size(); i++) {
            if (childrens.get(i) instanceof HBox) {
                HBox nodes = (HBox) childrens.get(i);
                for(int j=0;j<nodes.getChildren().size();j++) {
                    activationDesactivationNode(nodes.getChildren().get(j), activation);
                }
            } else {
                activationDesactivationNode(childrens.get(i), activation);
            }
        }
    }

    public static void activationDesactivationNode(Node node, boolean activation) {

        if (activation) {
            if (node.getId() != null && !node.getId().equalsIgnoreCase("code")) {
                node.setDisable(false);
                node.setStyle("");
            }
        } else {
            node.setDisable(true);
            node.setStyle("-fx-opacity: 1.0;");
        }
    }
}
