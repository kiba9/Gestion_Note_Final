/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 50723
 Source Host           : localhost:3306
 Source Schema         : isj

 Target Server Type    : MySQL
 Target Server Version : 50723
 File Encoding         : 65001

 Date: 24/05/2019 11:17:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for annee_academique
-- ----------------------------
DROP TABLE IF EXISTS `annee_academique`;
CREATE TABLE `annee_academique`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_cloture` datetime(0) NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_debut` datetime(0) NULL DEFAULT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_annee_academique_createur`(`createur`) USING BTREE,
  INDEX `FK_annee_academique_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of annee_academique
-- ----------------------------
INSERT INTO `annee_academique` VALUES (1, '2020-05-08 00:00:00', '2019-04-08 13:32:34', '2019-09-02 00:00:00', '2019-04-08 13:32:34', NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1);
INSERT INTO `annee_academique` VALUES (2, '2021-05-03 00:00:00', '2019-04-08 13:36:43', '2020-09-01 00:00:00', '2019-04-08 13:36:43', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `annee_academique` VALUES (3, '2022-05-02 00:00:00', '2019-04-08 13:39:37', '2021-09-01 00:00:00', '2019-04-08 13:39:37', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `annee_academique` VALUES (4, '2020-05-15 00:00:00', '2019-05-20 21:49:15', '2019-06-23 12:00:00', '2019-09-02 16:33:15', 'NULL', 'NULL', 'NULL', 'ACTIVE', 1, 1);
INSERT INTO `annee_academique` VALUES (5, '2020-05-15 00:00:00', '2019-05-20 21:49:15', '2019-06-23 12:00:00', '2019-09-15 16:20:15', 'NULL', 'NULL', NULL, 'ACTIVE', 1, 1);
INSERT INTO `annee_academique` VALUES (6, '2020-05-15 00:00:00', '2019-05-20 21:49:15', '2019-06-23 12:00:00', '2019-09-15 16:20:15', 'NULL', 'NULL', NULL, 'ACTIVE', 1, 1);

-- ----------------------------
-- Table structure for anonymat
-- ----------------------------
DROP TABLE IF EXISTS `anonymat`;
CREATE TABLE `anonymat`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `numero_anonymat` int(11) NULL DEFAULT NULL,
  `numero_table` int(11) NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `est_inscrit` bigint(20) NULL DEFAULT NULL,
  `note` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_anonymat_createur`(`createur`) USING BTREE,
  INDEX `FK_anonymat_note`(`note`) USING BTREE,
  INDEX `FK_anonymat_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_anonymat_est_inscrit`(`est_inscrit`) USING BTREE,
  INDEX `FK_anonymat_evaluation`(`evaluation`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of anonymat
-- ----------------------------
INSERT INTO `anonymat` VALUES (1, '2019-05-20 21:49:15', '2019-10-20 12:30:15', 'NULL', 'NULL', 1, 1, NULL, 'ACTIVE', 1, NULL, 1, NULL, NULL);
INSERT INTO `anonymat` VALUES (2, '2019-05-20 21:49:15', '2020-01-02 12:30:00', NULL, NULL, 2, 43, NULL, 'ACTIVE', 1, 6, 1, 3, 1);
INSERT INTO `anonymat` VALUES (3, '2019-05-20 21:49:15', '2020-01-02 12:30:00', NULL, NULL, 3, 4, NULL, 'ACTIVE', 1, 6, 1, 3, 1);

-- ----------------------------
-- Table structure for candidat
-- ----------------------------
DROP TABLE IF EXISTS `candidat`;
CREATE TABLE `candidat`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `DTYPE` varchar(31) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `date_naissance` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `ecole_origine` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `nom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nom_de_la_mere` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `nom_du_pere` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `prenom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `profession_de_la_mere` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `profession_du_pere` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `region_origine` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sexe` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `telephone` int(11) NOT NULL,
  `telephone_de_la_mere` int(11) NULL DEFAULT NULL,
  `telephone_du_pere` int(11) NULL DEFAULT NULL,
  `classe` bigint(20) NULL DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  UNIQUE INDEX `telephone`(`telephone`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_candidat_classe`(`classe`) USING BTREE,
  INDEX `FK_candidat_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_candidat_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of candidat
-- ----------------------------
INSERT INTO `candidat` VALUES (1, 'Etudiant', '2019-04-08 13:13:03', '2019-04-08 13:13:03', '1996-04-01 00:00:00', NULL, 'Excellence', 'anthonyfouda@gmail.com', NULL, 'FOUDA', 'GOURIOU', 'FOUDA', 'ANTHONY', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 691063708, NULL, NULL, 3, 1, 1);
INSERT INTO `candidat` VALUES (2, 'Etudiant', '2019-04-08 13:19:18', '2019-04-08 13:19:18', '1995-04-17 00:00:00', NULL, 'NESCAS', 'nsola@gmail.com', NULL, 'nsola', NULL, 'OYANE', 'STAHNN', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698745632, NULL, NULL, 4, 1, 1);
INSERT INTO `candidat` VALUES (3, 'Etudiant', '2019-04-08 13:23:46', '2019-04-08 13:23:46', '1997-08-16 00:00:00', NULL, 'vogt', 'cena@gmail.com', NULL, 'SONG', 'SONG', NULL, 'JUNIOR', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 658974121, NULL, NULL, 4, 1, 1);
INSERT INTO `candidat` VALUES (4, 'Etudiant', '2019-04-20 12:38:47', '2019-04-20 12:38:53', '1996-02-14 12:39:03', NULL, 'vogt', 'ntonga@gmail.com', NULL, 'ntonga', NULL, 'NTONGA', 'JEANNE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 698959632, NULL, NULL, 5, 1, 1);
INSERT INTO `candidat` VALUES (5, 'Etudiant', '2019-04-21 23:20:45', '2019-04-21 23:20:49', '1999-03-17 23:20:53', NULL, 'Saint benoit', 'pie@gmail.com', NULL, 'Mandeng', NULL, 'Mandeng', 'IRENE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 698784512, NULL, NULL, 6, 1, 1);
INSERT INTO `candidat` VALUES (6, 'Etudiant', '2019-04-21 23:23:02', '2019-04-21 23:23:06', '1997-10-07 23:23:10', NULL, 'Advantiste', 'anne@gmail.com', NULL, 'Mboa', 'NANDA', 'Mboa', 'ANNE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 632541258, NULL, NULL, 3, 1, 1);
INSERT INTO `candidat` VALUES (7, 'Candidat', '2019-05-24 09:55:24', '2019-05-24 09:55:27', '1995-06-22 09:55:36', NULL, 'Advantiste', 'j@gmail.com', NULL, 'Tic', 'tac', 'toc', 'touk', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 699874563, NULL, NULL, 2, 1, 1);
INSERT INTO `candidat` VALUES (8, 'Candidat', '2019-05-24 09:57:33', '2019-05-24 09:57:36', '2001-05-24 09:57:39', NULL, 'vogt', 'v@gmail.com', NULL, 'la', 'lo', 'li', 'lou', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698745217, NULL, NULL, 1, 1, 1);

-- ----------------------------
-- Table structure for classe
-- ----------------------------
DROP TABLE IF EXISTS `classe`;
CREATE TABLE `classe`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `niveau` bigint(20) NULL DEFAULT NULL,
  `specialite` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_classe_createur`(`createur`) USING BTREE,
  INDEX `FK_classe_niveau`(`niveau`) USING BTREE,
  INDEX `FK_classe_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_classe_specialite`(`specialite`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of classe
-- ----------------------------
INSERT INTO `classe` VALUES (4, '2019-04-20 12:45:51', '2019-04-20 12:45:55', NULL, NULL, NULL, 'ACTIVE', 1, 1, 2, 2);
INSERT INTO `classe` VALUES (3, '2019-04-20 12:45:16', '2019-04-20 12:45:20', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1, 1);
INSERT INTO `classe` VALUES (5, '2019-04-20 12:46:36', '2019-04-20 12:46:41', NULL, NULL, NULL, 'ACTIVE', 1, 1, 3, 2);
INSERT INTO `classe` VALUES (6, '2019-04-20 12:47:14', '2019-04-20 12:47:18', NULL, NULL, NULL, 'ACTIVE', 1, 1, 4, 1);

-- ----------------------------
-- Table structure for discipline
-- ----------------------------
DROP TABLE IF EXISTS `discipline`;
CREATE TABLE `discipline`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `nb_heures_absences` int(11) NULL DEFAULT NULL,
  `nb_retards` int(11) NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `etudiant` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `semestre` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_discipline_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_discipline_createur`(`createur`) USING BTREE,
  INDEX `FK_discipline_semestre`(`semestre`) USING BTREE,
  INDEX `FK_discipline_etudiant`(`etudiant`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discipline
-- ----------------------------
INSERT INTO `discipline` VALUES (1, '2019-04-22 00:00:30', '2019-04-22 00:00:35', NULL, NULL, 10, 7, NULL, 'ACTIVE', 1, 1, 1, 1);
INSERT INTO `discipline` VALUES (2, '2019-04-22 00:02:21', '2019-04-22 00:02:21', NULL, NULL, 5, 18, NULL, 'ACTIVE', 1, 1, 1, 2);
INSERT INTO `discipline` VALUES (3, '2019-04-22 00:04:00', '2019-04-22 00:04:00', NULL, NULL, 0, 5, NULL, 'ACTIVE', 1, 2, 1, 1);
INSERT INTO `discipline` VALUES (4, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 25, 8, NULL, 'ACTIVE', 1, 2, 1, 2);
INSERT INTO `discipline` VALUES (5, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 2, 4, NULL, 'ACTIVE', 1, 3, 1, 1);
INSERT INTO `discipline` VALUES (6, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 0, NULL, 'ACTIVE', 1, 3, 1, 2);
INSERT INTO `discipline` VALUES (7, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 35, 18, NULL, 'ACTIVE', 1, 4, 1, 1);
INSERT INTO `discipline` VALUES (8, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 2, 0, NULL, 'ACTIVE', 1, 4, 1, 2);
INSERT INTO `discipline` VALUES (9, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 3, 6, NULL, 'ACTIVE', 1, 5, 1, 1);
INSERT INTO `discipline` VALUES (10, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 0, NULL, 'ACTIVE', 1, 5, 1, 2);
INSERT INTO `discipline` VALUES (11, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 1, 1, NULL, 'ACTIVE', 1, 6, 1, 1);
INSERT INTO `discipline` VALUES (12, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 21, NULL, 'ACTIVE', 1, 6, 1, 2);

-- ----------------------------
-- Table structure for droit
-- ----------------------------
DROP TABLE IF EXISTS `droit`;
CREATE TABLE `droit`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `categorie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `ecriture` tinyint(1) NULL DEFAULT 0,
  `lecture` tinyint(1) NULL DEFAULT 0,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `modification` tinyint(1) NULL DEFAULT 0,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `suppression` tinyint(1) NULL DEFAULT 0,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `role` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_droit_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_droit_role`(`role`) USING BTREE,
  INDEX `FK_droit_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 580 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of droit
-- ----------------------------
INSERT INTO `droit` VALUES (1, '', '2019-04-22 02:00:55', '2019-04-22 02:00:55', NULL, 1, 1, NULL, 1, NULL, 'ACTIVE', 1, 1, 1, 2);
INSERT INTO `droit` VALUES (2, '', '2019-04-22 02:01:59', '2019-04-22 02:01:59', NULL, 0, 1, NULL, 0, NULL, 'ACTIVE', 0, 1, 1, 3);
INSERT INTO `droit` VALUES (3, '', '2019-04-22 02:03:51', '2019-04-22 02:03:51', NULL, 1, 1, NULL, 0, NULL, 'ACTIVE', 0, 1, 1, 1);
INSERT INTO `droit` VALUES (4, '', '2019-04-22 02:04:37', '2019-04-22 02:04:37', NULL, 1, 1, NULL, 1, NULL, 'ACTIVE', 0, 1, 1, 4);
INSERT INTO `droit` VALUES (552, 'AnneeAcademique', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-1450658700', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (553, 'Anonymat', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-568103000', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (554, 'Candidat', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-497078883', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (555, 'Classe', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-1282112430', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (556, 'Discipline', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-998044837', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (557, 'Droit', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '113226976', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (558, 'Email', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '475172208', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (559, 'Enseignant', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1057523214', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (560, 'Enseignement', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-985537325', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (561, 'EnvoiMessage', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '238387489', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (562, 'EstInscrit', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '690762011', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (563, 'Etudiant', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '39972146', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (564, 'Evaluation', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-139815438', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (565, 'Filiere', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-892809286', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (566, 'HistoriqueNote', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1553444050', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (567, 'Message', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '333972539', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (568, 'Module', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '466154838', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (569, 'Niveau', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1681150581', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (570, 'Note', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '544830213', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (571, 'Personne', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1172136731', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (572, 'Role', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '924772994', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (573, 'Securite', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1767096408', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (574, 'Semestre', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1499945894', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (575, 'Session', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-1082593358', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (576, 'Specialite', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '1352326792', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (577, 'TypeEvaluation', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '927233907', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (578, 'UE', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '2038624757', 'ACTIVE', 1, 1, 1, 551);
INSERT INTO `droit` VALUES (579, 'Utilisateur', '2019-05-19 11:25:37', '2019-05-19 11:25:37', '', 1, 1, '', 1, '-1316159533', 'ACTIVE', 1, 1, 1, 551);

-- ----------------------------
-- Table structure for email
-- ----------------------------
DROP TABLE IF EXISTS `email`;
CREATE TABLE `email`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `objet` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 152 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of email
-- ----------------------------
INSERT INTO `email` VALUES (1, 'salutation');
INSERT INTO `email` VALUES (151, 'test');
INSERT INTO `email` VALUES (2, 'salutation 2');
INSERT INTO `email` VALUES (3, 'salution3');

-- ----------------------------
-- Table structure for enseignant
-- ----------------------------
DROP TABLE IF EXISTS `enseignant`;
CREATE TABLE `enseignant`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `date_naissance` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `nom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `prenom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `qualification` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sexe` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `telephone` int(11) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  UNIQUE INDEX `telephone`(`telephone`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_enseignant_createur`(`createur`) USING BTREE,
  INDEX `FK_enseignant_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enseignant
-- ----------------------------
INSERT INTO `enseignant` VALUES (1, '2019-04-11 08:37:29', '2019-04-11 08:37:29', '1968-04-10 00:00:00', NULL, 'kiampi@gmail.com', NULL, 'Kiampi', NULL, 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 699333333, 1, 1);
INSERT INTO `enseignant` VALUES (2, '2019-04-11 08:38:57', '2019-04-11 08:38:57', '1968-10-04 00:00:00', NULL, 'SAHA@gmail.com', NULL, 'Saha', NULL, 'MASTER', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 699989796, 1, 1);
INSERT INTO `enseignant` VALUES (3, '2019-04-11 08:40:49', '2019-04-11 08:40:49', '1975-04-09 00:00:00', NULL, 'Tchio@gmail.com', NULL, 'Tchio', 'Corneille', NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 601063708, 1, 1);
INSERT INTO `enseignant` VALUES (4, '2019-04-11 08:42:14', '2019-04-11 08:42:14', '1964-03-09 00:00:00', NULL, 'Mballa@gmail.com', NULL, 'Mballa', 'Fabien', 'Pr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 601043507, 1, 1);
INSERT INTO `enseignant` VALUES (5, '2019-04-11 08:46:09', '2019-04-11 08:46:09', '1963-08-21 00:00:00', NULL, 'kwamo@gmail.com', NULL, 'Kouamo', 'Georges', 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698451425, 1, 1);
INSERT INTO `enseignant` VALUES (6, '2019-04-11 08:47:57', '2019-04-11 08:47:57', '1963-08-21 00:00:00', NULL, 'Tchantcho@gmail.com', NULL, 'Tchantcho', 'Hugues', 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 658471425, 1, 1);

-- ----------------------------
-- Table structure for enseignement
-- ----------------------------
DROP TABLE IF EXISTS `enseignement`;
CREATE TABLE `enseignement`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `heures_de_cours` int(11) NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `programme_de_cours` varchar(1020) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `semestre` bigint(20) NULL DEFAULT NULL,
  `ue` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_enseignement_ue`(`ue`) USING BTREE,
  INDEX `FK_enseignement_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_enseignement_createur`(`createur`) USING BTREE,
  INDEX `FK_enseignement_semestre`(`semestre`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enseignement
-- ----------------------------
INSERT INTO `enseignement` VALUES (1, '2019-04-11 08:20:57', '2019-04-11 08:20:57', NULL, 35, 'ARHITECTURE', NULL, NULL, 'ACTIVE', 1, 1, 1, 2);
INSERT INTO `enseignement` VALUES (2, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'MATH INFO', NULL, NULL, 'ACTIVE', 1, 1, 1, 1);
INSERT INTO `enseignement` VALUES (3, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'JAVA I', NULL, NULL, 'ACTIVE', 1, 1, 2, 3);
INSERT INTO `enseignement` VALUES (4, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'PROG C', NULL, NULL, 'ACTIVE', 1, 1, 2, 4);
INSERT INTO `enseignement` VALUES (5, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'SYSTEME D\'INFORMATION', NULL, NULL, 'ACTIVE', 1, 1, 1, 5);
INSERT INTO `enseignement` VALUES (6, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'MATH DISCRETES', NULL, NULL, 'ACTIVE', 1, 1, 1, 6);

-- ----------------------------
-- Table structure for enseignement_enseignant
-- ----------------------------
DROP TABLE IF EXISTS `enseignement_enseignant`;
CREATE TABLE `enseignement_enseignant`  (
  `code_enseignant` bigint(20) NOT NULL,
  `code_enseignement` bigint(20) NOT NULL,
  PRIMARY KEY (`code_enseignant`, `code_enseignement`) USING BTREE,
  INDEX `FK_enseignement_enseignant_code_enseignement`(`code_enseignement`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of enseignement_enseignant
-- ----------------------------
INSERT INTO `enseignement_enseignant` VALUES (1, 2);
INSERT INTO `enseignement_enseignant` VALUES (2, 1);
INSERT INTO `enseignement_enseignant` VALUES (3, 4);
INSERT INTO `enseignement_enseignant` VALUES (4, 5);
INSERT INTO `enseignement_enseignant` VALUES (5, 3);
INSERT INTO `enseignement_enseignant` VALUES (6, 6);

-- ----------------------------
-- Table structure for envoi_message
-- ----------------------------
DROP TABLE IF EXISTS `envoi_message`;
CREATE TABLE `envoi_message`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_envoi` datetime(0) NULL DEFAULT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `candidat` bigint(20) NULL DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `message` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_envoi_message_createur`(`createur`) USING BTREE,
  INDEX `FK_envoi_message_candidat`(`candidat`) USING BTREE,
  INDEX `FK_envoi_message_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_envoi_message_message`(`message`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 402 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of envoi_message
-- ----------------------------
INSERT INTO `envoi_message` VALUES (1, '2019-04-22 01:16:49', '2019-04-22 01:16:49', '2019-04-22 01:16:49', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 1, 1, 1, 1);
INSERT INTO `envoi_message` VALUES (2, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 2, 1, 1, 2);
INSERT INTO `envoi_message` VALUES (3, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 3, 1, 1, 3);
INSERT INTO `envoi_message` VALUES (4, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'ECHEC', 'ACTIVE', 4, 1, 1, 4);
INSERT INTO `envoi_message` VALUES (5, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'ECHEC', 'ACTIVE', 5, 1, 1, 5);
INSERT INTO `envoi_message` VALUES (6, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 6, 1, 1, 6);
INSERT INTO `envoi_message` VALUES (401, '2019-04-26 12:58:26', '2019-04-26 12:58:26', '2019-04-26 12:58:26', 'test', 'test', '31', 'SUCCES', 'ACTIVE', 1, 1, 1, 151);

-- ----------------------------
-- Table structure for est_inscrit
-- ----------------------------
DROP TABLE IF EXISTS `est_inscrit`;
CREATE TABLE `est_inscrit`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `candidat_inscrit` bigint(20) NULL DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `enseignement` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_est_inscrit_candidat_inscrit`(`candidat_inscrit`) USING BTREE,
  INDEX `FK_est_inscrit_createur`(`createur`) USING BTREE,
  INDEX `FK_est_inscrit_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_est_inscrit_enseignement`(`enseignement`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of est_inscrit
-- ----------------------------
INSERT INTO `est_inscrit` VALUES (3, '2019-04-22 00:47:36', '2019-04-22 00:47:36', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 1, 1, 3, 1);
INSERT INTO `est_inscrit` VALUES (4, '2019-04-22 00:47:36', '2019-04-22 00:47:36', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 1, 1, 4, 1);
INSERT INTO `est_inscrit` VALUES (5, '2019-04-22 00:50:11', '2019-04-22 00:50:11', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 2, 1, 1, 1);
INSERT INTO `est_inscrit` VALUES (6, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 2, 3, 1, 1);
INSERT INTO `est_inscrit` VALUES (7, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 3, 1, 1, 1);
INSERT INTO `est_inscrit` VALUES (8, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 4, 1, 2, 1);
INSERT INTO `est_inscrit` VALUES (9, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 4, 1, 6, 1);
INSERT INTO `est_inscrit` VALUES (10, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 3, 1);
INSERT INTO `est_inscrit` VALUES (11, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 4, 1);
INSERT INTO `est_inscrit` VALUES (12, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 5, 1);

-- ----------------------------
-- Table structure for etudiant
-- ----------------------------
DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE `etudiant`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_authentification` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `matricule` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `matricule`(`matricule`) USING BTREE,
  UNIQUE INDEX `code_authentification`(`code_authentification`, `matricule`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of etudiant
-- ----------------------------
INSERT INTO `etudiant` VALUES (1, '1', 'ISJ0001');
INSERT INTO `etudiant` VALUES (2, '2', 'ISJ0002');
INSERT INTO `etudiant` VALUES (3, '3', 'ISJ0003');
INSERT INTO `etudiant` VALUES (4, '4', 'ISJ0004');
INSERT INTO `etudiant` VALUES (5, '5', 'ISJ0005');
INSERT INTO `etudiant` VALUES (6, '6', 'ISJ0006');

-- ----------------------------
-- Table structure for evaluation
-- ----------------------------
DROP TABLE IF EXISTS `evaluation`;
CREATE TABLE `evaluation`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_evaluation` datetime(0) NULL DEFAULT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `type_evaluation` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_evaluation_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_evaluation_type_evaluation`(`type_evaluation`) USING BTREE,
  INDEX `FK_evaluation_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluation
-- ----------------------------
INSERT INTO `evaluation` VALUES (1, '2019-04-22 00:14:46', '2019-12-10 07:00:00', '2019-04-22 00:14:46', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1);
INSERT INTO `evaluation` VALUES (2, '2019-04-22 00:17:57', '2019-12-11 07:00:00', '2019-04-22 00:17:57', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 4);
INSERT INTO `evaluation` VALUES (6, '2019-04-22 00:22:43', '2019-12-13 10:00:00', '2019-04-22 00:22:43', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 19);
INSERT INTO `evaluation` VALUES (5, '2019-04-22 00:22:29', '2019-12-13 08:00:00', '2019-04-22 00:22:29', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 16);
INSERT INTO `evaluation` VALUES (7, '2019-05-23 23:57:32', '2019-12-16 08:00:00', '2019-12-16 08:00:00', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 6);

-- ----------------------------
-- Table structure for filiere
-- ----------------------------
DROP TABLE IF EXISTS `filiere`;
CREATE TABLE `filiere`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_filiere_createur`(`createur`) USING BTREE,
  INDEX `FK_filiere_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of filiere
-- ----------------------------
INSERT INTO `filiere` VALUES (1, '2019-04-11 07:53:49', '2019-04-11 07:53:49', NULL, 'LICENCE', NULL, 'ACTIVE', 1, 1);
INSERT INTO `filiere` VALUES (3, '2019-04-11 07:54:19', '2019-04-11 07:54:19', NULL, 'INGENIEUR', NULL, 'ACTIVE', 1, 1);

-- ----------------------------
-- Table structure for historique_note
-- ----------------------------
DROP TABLE IF EXISTS `historique_note`;
CREATE TABLE `historique_note`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `valeur_note` double NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `note` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_historique_note_note`(`note`) USING BTREE,
  INDEX `FK_historique_note_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_historique_note_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of historique_note
-- ----------------------------
INSERT INTO `historique_note` VALUES (1, '2019-04-22 01:25:46', '2019-04-22 01:25:46', NULL, NULL, NULL, 'ACTIVE', 17, 1, 1, 1);
INSERT INTO `historique_note` VALUES (2, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 17, 1, 1, 2);
INSERT INTO `historique_note` VALUES (3, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 14, 1, 1, 3);
INSERT INTO `historique_note` VALUES (4, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 8, 1, 1, 4);
INSERT INTO `historique_note` VALUES (5, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 11, 1, 1, 5);

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `DTYPE` varchar(31) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `contenu` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `destinataire` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `emetteur` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_message_createur`(`createur`) USING BTREE,
  INDEX `FK_message_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 152 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (1, 'Email', 'BONjour 1', '2019-04-22 01:20:09', '2019-04-22 01:20:09', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `message` VALUES (2, 'Email', 'BONjour 2', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `message` VALUES (3, 'Email', 'BONjour 3', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `message` VALUES (4, 'Sms', 'BONjour 4', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `message` VALUES (5, 'Sms', 'BONjour 5', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `message` VALUES (6, 'Sms', 'BONjour 6', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS `module`;
CREATE TABLE `module`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_Module_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_Module_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of module
-- ----------------------------
INSERT INTO `module` VALUES (1, '2019-04-11 07:44:06', '2019-04-11 07:44:06', NULL, 'SYSTEME D\'INFORMATION ET ARCHITECTURE', NULL, 'ACTIVE', 1, 1);
INSERT INTO `module` VALUES (2, '2019-04-11 07:44:54', '2019-04-11 07:44:54', NULL, 'MATH APPLIQUEES POUR INFO', NULL, 'ACTIVE', 1, 1);
INSERT INTO `module` VALUES (3, '2019-04-11 07:45:34', '2019-04-11 07:45:34', NULL, 'JAVA1 ET PROGRAMMATION EN C', NULL, 'ACTIVE', 1, 1);

-- ----------------------------
-- Table structure for niveau
-- ----------------------------
DROP TABLE IF EXISTS `niveau`;
CREATE TABLE `niveau`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `numero` int(11) NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_Niveau_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_Niveau_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of niveau
-- ----------------------------
INSERT INTO `niveau` VALUES (1, '2019-04-11 07:50:44', '2019-04-11 07:50:44', 'NIVEAU 1 LICENCE', '', 1, NULL, 'ACTIVE', 1, 1);
INSERT INTO `niveau` VALUES (2, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 1 INGENIEUR', '', 1, NULL, 'ACTIVE', 1, 1);
INSERT INTO `niveau` VALUES (3, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 2 INGENIEUR', '', 2, NULL, 'ACTIVE', 1, 1);
INSERT INTO `niveau` VALUES (4, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 2 LICENCE', '', 2, NULL, 'ACTIVE', 1, 1);

-- ----------------------------
-- Table structure for note
-- ----------------------------
DROP TABLE IF EXISTS `note`;
CREATE TABLE `note`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `numero_table` int(11) NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `valeur_note` double NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `est_inscrit` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_note_est_inscrit`(`est_inscrit`) USING BTREE,
  INDEX `FK_note_createur`(`createur`) USING BTREE,
  INDEX `FK_note_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_note_evaluation`(`evaluation`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of note
-- ----------------------------
INSERT INTO `note` VALUES (1, '2019-04-22 01:25:46', '2019-04-22 01:25:46', NULL, NULL, 10, NULL, 'ACTIVE', 17, 1, 1, 1, 6);
INSERT INTO `note` VALUES (2, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 10, NULL, 'ACTIVE', 17, 1, 1, 1, 7);
INSERT INTO `note` VALUES (3, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 15, NULL, 'ACTIVE', 14, 1, 2, 1, 8);
INSERT INTO `note` VALUES (4, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 20, NULL, 'ACTIVE', 8, 1, 5, 1, 12);
INSERT INTO `note` VALUES (5, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 22, NULL, 'ACTIVE', 11, 1, 6, 1, 9);
INSERT INTO `note` VALUES (6, '2019-05-24 00:01:17', '2019-05-24 00:01:21', NULL, NULL, 15, NULL, 'ACTIVE', 10, 1, 7, 1, 8);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_role_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_role_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 552 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, '2019-04-21 23:41:21', '2019-04-21 23:41:21', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `role` VALUES (2, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `role` VALUES (3, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `role` VALUES (4, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1);
INSERT INTO `role` VALUES (551, '2019-05-19 11:25:36', '2019-05-19 11:41:34', '', 'Role Test', '1156087968', 'ACTIVE', 1, 2);

-- ----------------------------
-- Table structure for semestre
-- ----------------------------
DROP TABLE IF EXISTS `semestre`;
CREATE TABLE `semestre`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_cloture` datetime(0) NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_debut` datetime(0) NULL DEFAULT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `annee_academique` bigint(20) NULL DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_semestre_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_semestre_createur`(`createur`) USING BTREE,
  INDEX `FK_semestre_annee_academique`(`annee_academique`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of semestre
-- ----------------------------
INSERT INTO `semestre` VALUES (1, '2020-01-30 00:00:00', '2019-04-08 13:44:32', '2019-09-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `semestre` VALUES (2, '2020-05-18 00:00:00', '2019-04-08 13:54:54', '2020-01-03 00:00:00', '2019-04-08 13:54:54', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `semestre` VALUES (3, '2021-01-30 00:00:00', '2019-04-21 23:46:20', '2020-09-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 2, 1, 1);
INSERT INTO `semestre` VALUES (4, '2021-05-30 00:00:00', '2019-04-21 23:46:20', '2021-01-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 2, 1, 1);

-- ----------------------------
-- Table structure for sequence
-- ----------------------------
DROP TABLE IF EXISTS `sequence`;
CREATE TABLE `sequence`  (
  `SEQ_NAME` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `SEQ_COUNT` decimal(38, 0) NULL DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sequence
-- ----------------------------
INSERT INTO `sequence` VALUES ('SEQ_GEN', 2650);

-- ----------------------------
-- Table structure for session
-- ----------------------------
DROP TABLE IF EXISTS `session`;
CREATE TABLE `session`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_connection` datetime(0) NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_deconnection` datetime(0) NULL DEFAULT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `machine_cliente` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `utilisateur` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_Session_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_Session_utilisateur`(`utilisateur`) USING BTREE,
  INDEX `FK_Session_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2602 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of session
-- ----------------------------
INSERT INTO `session` VALUES (1, '2019-04-30 15:33:01', '2019-04-30 15:33:20', '2019-04-30 15:45:24', '2019-04-30 15:33:36', NULL, NULL, 'MA1', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1);
INSERT INTO `session` VALUES (2, '2019-04-30 15:35:11', '2019-04-30 15:35:18', '2019-04-30 15:49:22', '2019-04-30 15:35:48', NULL, NULL, 'MA2', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2);
INSERT INTO `session` VALUES (3, '2019-04-30 15:36:27', '2019-04-30 15:36:36', '2019-04-30 16:36:42', '2019-04-30 15:36:51', NULL, NULL, 'MA3', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 3);
INSERT INTO `session` VALUES (4, '2019-04-30 15:37:17', '2019-04-30 15:37:21', '2019-04-30 17:37:25', '2019-04-30 15:37:35', NULL, NULL, 'MA4', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 4);
INSERT INTO `session` VALUES (601, '2019-05-22 19:56:38', '2019-05-22 19:56:38', NULL, '2019-05-22 19:56:38', NULL, NULL, 'CRUNCH10', '1065256361', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (651, '2019-05-22 20:04:26', '2019-05-22 20:04:26', NULL, '2019-05-22 20:04:26', NULL, NULL, 'CRUNCH10', '-1569648338', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (701, '2019-05-22 20:10:49', '2019-05-22 20:10:49', NULL, '2019-05-22 20:10:49', NULL, NULL, 'CRUNCH10', '1865410461', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (751, '2019-05-22 20:17:39', '2019-05-22 20:17:39', NULL, '2019-05-22 20:17:39', NULL, NULL, 'CRUNCH10', '212184526', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (801, '2019-05-22 20:32:14', '2019-05-22 20:32:14', NULL, '2019-05-22 20:32:14', NULL, NULL, 'CRUNCH10', '21963020', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (851, '2019-05-22 20:35:23', '2019-05-22 20:35:23', NULL, '2019-05-22 20:35:23', NULL, NULL, 'CRUNCH10', '148076679', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (901, '2019-05-22 20:44:45', '2019-05-22 20:44:45', NULL, '2019-05-22 20:44:45', NULL, NULL, 'CRUNCH10', '-1516668111', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (951, '2019-05-22 20:50:27', '2019-05-22 20:50:27', NULL, '2019-05-22 20:50:27', NULL, NULL, 'CRUNCH10', '1465863697', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1001, '2019-05-22 22:28:10', '2019-05-22 22:28:10', NULL, '2019-05-22 22:28:10', NULL, NULL, 'CRUNCH10', '1898312775', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1051, '2019-05-22 22:44:16', '2019-05-22 22:44:16', NULL, '2019-05-22 22:44:16', NULL, NULL, 'CRUNCH10', '77862787', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1101, '2019-05-22 22:52:02', '2019-05-22 22:52:02', NULL, '2019-05-22 22:52:02', NULL, NULL, 'CRUNCH10', '299119551', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1151, '2019-05-22 22:53:10', '2019-05-22 22:53:10', NULL, '2019-05-22 22:53:10', NULL, NULL, 'CRUNCH10', '191662843', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1201, '2019-05-22 22:55:58', '2019-05-22 22:55:58', NULL, '2019-05-22 22:55:58', NULL, NULL, 'CRUNCH10', '-1666910466', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1251, '2019-05-22 22:58:04', '2019-05-22 22:58:04', NULL, '2019-05-22 22:58:04', NULL, NULL, 'CRUNCH10', '-987251049', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1301, '2019-05-22 23:00:09', '2019-05-22 23:00:09', NULL, '2019-05-22 23:00:09', NULL, NULL, 'CRUNCH10', '-2013791438', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1351, '2019-05-22 23:00:51', '2019-05-22 23:00:51', NULL, '2019-05-22 23:00:51', NULL, NULL, 'CRUNCH10', '61131718', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1401, '2019-05-23 04:39:17', '2019-05-23 04:39:17', NULL, '2019-05-23 04:39:17', NULL, NULL, 'CRUNCH10', '-112764396', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1451, '2019-05-23 04:49:28', '2019-05-23 04:49:28', NULL, '2019-05-23 04:49:28', NULL, NULL, 'CRUNCH10', '-169172942', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1501, '2019-05-23 04:55:02', '2019-05-23 04:55:02', NULL, '2019-05-23 04:55:02', NULL, NULL, 'CRUNCH10', '-937214768', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1551, '2019-05-23 04:56:19', '2019-05-23 04:56:19', NULL, '2019-05-23 04:56:19', NULL, NULL, 'CRUNCH10', '-1738070018', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1601, '2019-05-23 04:58:59', '2019-05-23 04:58:59', NULL, '2019-05-23 04:58:59', NULL, NULL, 'CRUNCH10', '1872928910', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1651, '2019-05-23 05:00:52', '2019-05-23 05:00:52', NULL, '2019-05-23 05:00:52', NULL, NULL, 'CRUNCH10', '-169182569', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1701, '2019-05-23 05:03:06', '2019-05-23 05:03:06', NULL, '2019-05-23 05:03:06', NULL, NULL, 'CRUNCH10', '-84545940', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1751, '2019-05-23 05:04:38', '2019-05-23 05:04:38', NULL, '2019-05-23 05:04:38', NULL, NULL, 'CRUNCH10', '1580808750', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1801, '2019-05-23 05:05:28', '2019-05-23 05:05:28', NULL, '2019-05-23 05:05:28', NULL, NULL, 'CRUNCH10', '-1558339174', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1851, '2019-05-23 05:08:24', '2019-05-23 05:08:24', NULL, '2019-05-23 05:08:24', NULL, NULL, 'CRUNCH10', '-199289746', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1901, '2019-05-23 05:10:03', '2019-05-23 05:10:03', NULL, '2019-05-23 05:10:03', NULL, NULL, 'CRUNCH10', '-869397587', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (1951, '2019-05-23 05:11:24', '2019-05-23 05:11:24', NULL, '2019-05-23 05:11:24', NULL, NULL, 'CRUNCH10', '1187230422', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2001, '2019-05-23 05:14:46', '2019-05-23 05:14:46', NULL, '2019-05-23 05:14:46', NULL, NULL, 'CRUNCH10', '-129811705', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2051, '2019-05-23 05:16:07', '2019-05-23 05:16:07', NULL, '2019-05-23 05:16:07', NULL, NULL, 'CRUNCH10', '-885445299', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2101, '2019-05-23 05:17:47', '2019-05-23 05:17:47', NULL, '2019-05-23 05:17:47', NULL, NULL, 'CRUNCH10', '-1637940485', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2151, '2019-05-23 05:18:55', '2019-05-23 05:18:55', NULL, '2019-05-23 05:18:55', NULL, NULL, 'CRUNCH10', '1773133977', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2201, '2019-05-23 05:19:52', '2019-05-23 05:19:52', NULL, '2019-05-23 05:19:52', NULL, NULL, 'CRUNCH10', '-548141960', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2251, '2019-05-23 05:40:25', '2019-05-23 05:40:25', NULL, '2019-05-23 05:40:25', NULL, NULL, 'CRUNCH10', '298013994', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2301, '2019-05-23 05:46:31', '2019-05-23 05:46:31', NULL, '2019-05-23 05:46:31', NULL, NULL, 'CRUNCH10', '-391744929', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2351, '2019-05-23 05:48:12', '2019-05-23 05:48:12', NULL, '2019-05-23 05:48:12', NULL, NULL, 'CRUNCH10', '-413031821', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2401, '2019-05-23 05:49:56', '2019-05-23 05:49:56', NULL, '2019-05-23 05:49:56', NULL, NULL, 'CRUNCH10', '1659694305', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2451, '2019-05-23 05:51:54', '2019-05-23 05:51:54', NULL, '2019-05-23 05:51:54', NULL, NULL, 'CRUNCH10', '-941885863', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2501, '2019-05-23 05:53:22', '2019-05-23 05:53:22', NULL, '2019-05-23 05:53:22', NULL, NULL, 'CRUNCH10', '1246775998', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2551, '2019-05-23 06:01:25', '2019-05-23 06:01:25', NULL, '2019-05-23 06:01:25', NULL, NULL, 'CRUNCH10', '29320510', 'ACTIF', 'ACTIVE', 1, 1, NULL);
INSERT INTO `session` VALUES (2601, '2019-05-23 06:04:33', '2019-05-23 06:04:33', NULL, '2019-05-23 06:04:33', NULL, NULL, 'CRUNCH10', '1556647731', 'ACTIF', 'ACTIVE', 1, 1, NULL);

-- ----------------------------
-- Table structure for sms
-- ----------------------------
DROP TABLE IF EXISTS `sms`;
CREATE TABLE `sms`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of sms
-- ----------------------------
INSERT INTO `sms` VALUES (4);
INSERT INTO `sms` VALUES (5);
INSERT INTO `sms` VALUES (6);

-- ----------------------------
-- Table structure for specialite
-- ----------------------------
DROP TABLE IF EXISTS `specialite`;
CREATE TABLE `specialite`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `filiere` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_specialite_filiere`(`filiere`) USING BTREE,
  INDEX `FK_specialite_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_specialite_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of specialite
-- ----------------------------
INSERT INTO `specialite` VALUES (1, '2019-04-11 07:56:37', '2019-04-11 07:56:37', NULL, 'genie logiciel', NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `specialite` VALUES (2, '2019-04-11 07:56:54', '2019-04-11 07:56:54', NULL, 'genie logiciel', NULL, 'ACTIVE', 1, 3, 1);

-- ----------------------------
-- Table structure for type_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `type_evaluation`;
CREATE TABLE `type_evaluation`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `pourcentage` float NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `enseignement` bigint(20) NULL DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_type_evaluation_enseignement`(`enseignement`) USING BTREE,
  INDEX `FK_type_evaluation_createur`(`createur`) USING BTREE,
  INDEX `FK_type_evaluation_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 22 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type_evaluation
-- ----------------------------
INSERT INTO `type_evaluation` VALUES (1, '2019-04-21 23:27:49', '2019-04-21 23:27:52', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `type_evaluation` VALUES (2, '2019-04-21 23:28:35', '2019-04-21 23:28:37', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `type_evaluation` VALUES (3, '2019-04-21 23:29:18', '2019-04-21 23:29:22', NULL, 'Rattrapage', 70, NULL, 'ACTIVE', 1, 1, 1);
INSERT INTO `type_evaluation` VALUES (4, '2019-04-21 23:32:32', '2019-04-21 23:32:32', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 2, 1);
INSERT INTO `type_evaluation` VALUES (6, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 2, 1);
INSERT INTO `type_evaluation` VALUES (7, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapage', 70, NULL, 'ACTIVE', 1, 2, 1);
INSERT INTO `type_evaluation` VALUES (8, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 20, NULL, 'ACTIVE', 1, 3, 1);
INSERT INTO `type_evaluation` VALUES (9, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 40, NULL, 'ACTIVE', 1, 3, 1);
INSERT INTO `type_evaluation` VALUES (10, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Travaux pratiques', 40, NULL, 'ACTIVE', 1, 3, 1);
INSERT INTO `type_evaluation` VALUES (11, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 40, NULL, 'ACTIVE', 1, 3, 1);
INSERT INTO `type_evaluation` VALUES (12, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 20, NULL, 'ACTIVE', 1, 4, 1);
INSERT INTO `type_evaluation` VALUES (13, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 40, NULL, 'ACTIVE', 1, 4, 1);
INSERT INTO `type_evaluation` VALUES (14, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Travaux pratiques', 40, NULL, 'ACTIVE', 1, 4, 1);
INSERT INTO `type_evaluation` VALUES (15, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 40, NULL, 'ACTIVE', 1, 4, 1);
INSERT INTO `type_evaluation` VALUES (16, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 5, 1);
INSERT INTO `type_evaluation` VALUES (17, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 5, 1);
INSERT INTO `type_evaluation` VALUES (18, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 70, NULL, 'ACTIVE', 1, 5, 1);
INSERT INTO `type_evaluation` VALUES (19, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 6, 1);
INSERT INTO `type_evaluation` VALUES (20, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 6, 1);
INSERT INTO `type_evaluation` VALUES (21, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 70, NULL, 'ACTIVE', 1, 6, 1);

-- ----------------------------
-- Table structure for ue
-- ----------------------------
DROP TABLE IF EXISTS `ue`;
CREATE TABLE `ue`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_ue` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `credits` int(11) NULL DEFAULT NULL,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `module` bigint(20) NULL DEFAULT NULL,
  `niveau` bigint(20) NULL DEFAULT NULL,
  `specialite` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_UE_niveau`(`niveau`) USING BTREE,
  INDEX `FK_UE_modificateur`(`modificateur`) USING BTREE,
  INDEX `FK_UE_specialite`(`specialite`) USING BTREE,
  INDEX `FK_UE_module`(`module`) USING BTREE,
  INDEX `FK_UE_createur`(`createur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ue
-- ----------------------------
INSERT INTO `ue` VALUES (1, 'MATH111', 3, '2019-05-20 21:49:15', '2020-01-02 12:30:00', NULL, 'mathématiques pour informatique', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2, 1, 1);
INSERT INTO `ue` VALUES (2, 'SECU20', 4, '2019-05-20 21:49:15', '2020-01-02 12:30:00', NULL, 'securité informatique', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1, 3, 1);
INSERT INTO `ue` VALUES (3, 'INF115', 4, '2019-05-23 18:37:27', '2019-05-23 18:37:27', NULL, 'JAVA', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 3, 1, 1);
INSERT INTO `ue` VALUES (4, 'INF110', 3, '2019-05-23 18:38:05', '2019-05-23 18:38:05', NULL, 'C', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 3, 1, 1);
INSERT INTO `ue` VALUES (5, 'INF112', 3, '2019-05-23 18:39:13', '2019-05-23 18:39:13', NULL, 'systeme information', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1, 1, 1);
INSERT INTO `ue` VALUES (6, 'MAT105', 4, '2019-05-23 18:40:29', '2019-05-23 18:40:29', NULL, 'MATH DISCRETES', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2, 1, 1);

-- ----------------------------
-- Table structure for utilisateur
-- ----------------------------
DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE `utilisateur`  (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime(0) NOT NULL,
  `date_modification` datetime(0) NOT NULL,
  `date_naissance` datetime(0) NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `libelle` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `login` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `mot_de_passe` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `prenom` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sexe` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `signature` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `statut` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `statut_vie` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `telephone` int(11) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  UNIQUE INDEX `login`(`login`) USING BTREE,
  UNIQUE INDEX `telephone`(`telephone`) USING BTREE,
  UNIQUE INDEX `signature`(`signature`) USING BTREE,
  INDEX `FK_utilisateur_createur`(`createur`) USING BTREE,
  INDEX `FK_utilisateur_modificateur`(`modificateur`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of utilisateur
-- ----------------------------
INSERT INTO `utilisateur` VALUES (1, '2019-04-08 12:52:09', '2019-05-19 11:51:08', '1990-04-09 00:00:00', NULL, 'channeldonkeng@gmail.com', NULL, 'channel', 'BA-32-53-87-6A-ED-6B-C2-2D-4A-6F-F5-3D-84-6-C6-AD-86-41-95-ED-14-4A-B5-C8-76-21-B6-C2-33-B5-48-BA-EA-E6-95-6D-F3-46-EC-8C-17-F5-EA-10-F3-5E-E3-CB-C5-14-79-7E-D7-DD-D3-14-54-64-E2-A0-BA-B4-13', 'Donkeng', 'Channel', 'FEMININ', '853839448', 'ACTIVE', 'ACTIVE', 656307859, 1, 1);
INSERT INTO `utilisateur` VALUES (2, '2019-04-08 12:55:52', '2019-05-19 11:52:14', '1987-02-10 00:00:00', NULL, 'constantinnitcheu6@gmail.com', NULL, 'constantin', 'DF-6B-9F-B1-5C-FD-BB-75-27-BE-5A-8A-6E-39-F3-9E-57-2C-8D-DB-94-3F-BC-79-A9-43-43-8E-9D-3D-85-EB-FC-2C-CF-9E-E-CC-D9-34-60-26-C0-B6-87-6E-E-1-55-6F-E5-6F-13-55-82-C0-5F-BD-BB-50-5D-46-75-5A', 'Nitcheu', 'Constantin', 'MASCULIN', '442177959', 'ACTIVE', 'ACTIVE', 695585034, 1, 2);
INSERT INTO `utilisateur` VALUES (3, '2019-04-08 12:59:48', '2019-04-08 12:59:48', '1978-06-21 00:00:00', NULL, 'herve@gmail.com', NULL, 'jeanherve', 'isj123', 'JEAN', 'HERVE', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 690548932, 1, 1);
INSERT INTO `utilisateur` VALUES (4, '2019-04-08 13:03:59', '2019-04-08 13:03:59', '1984-04-17 00:00:00', NULL, 'emmamoupo@gmail.com', NULL, 'emmanuel', 'isj456', 'MOUPOJOU', 'EMMANUEL', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698745621, 1, 1);

-- ----------------------------
-- Table structure for utilisateur_role
-- ----------------------------
DROP TABLE IF EXISTS `utilisateur_role`;
CREATE TABLE `utilisateur_role`  (
  `code_utilisateur` bigint(20) NOT NULL,
  `code_role` bigint(20) NOT NULL,
  PRIMARY KEY (`code_utilisateur`, `code_role`) USING BTREE,
  INDEX `FK_utilisateur_role_code_role`(`code_role`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of utilisateur_role
-- ----------------------------
INSERT INTO `utilisateur_role` VALUES (1, 1);
INSERT INTO `utilisateur_role` VALUES (1, 551);
INSERT INTO `utilisateur_role` VALUES (2, 2);
INSERT INTO `utilisateur_role` VALUES (3, 3);
INSERT INTO `utilisateur_role` VALUES (4, 4);

-- ----------------------------
-- Procedure structure for AFFICHER_NOTE
-- ----------------------------
DROP PROCEDURE IF EXISTS `AFFICHER_NOTE`;
delimiter ;;
CREATE PROCEDURE `AFFICHER_NOTE`(IN `type_evaluation.libelle` VARCHAR(255), IN `code_ue` VARCHAR(255), IN `code_authentification` VARCHAR(255))
BEGIN
	select DISTINCT valeur_note, ue.code_ue as code_ue, type_evaluation.libelle as examen
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite
where note.est_inscrit=est_inscrit.code
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code_authentification
and ue.code_ue=code_ue
and type_evaluation.libelle=type_evaluation.libelle
and etudiant.code_authentification=code_authentification
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and niveau.`code`=ue.niveau
and ue.module=module.`code`;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for inf_etud
-- ----------------------------
DROP PROCEDURE IF EXISTS `inf_etud`;
delimiter ;;
CREATE PROCEDURE `inf_etud`(IN `mat` VARCHAR(255))
  NO SQL 
SELECT nom,prenom,date_naissance,sexe,matricule,filiere.libelle as filiere,niveau.numero as niveau
from candidat,filiere,classe,niveau,specialite,etudiant
where candidat.code=etudiant.code
AND candidat.classe=classe.code
AND classe.specialite=specialite.code
AND specialite.filiere=filiere.code
AND classe.niveau=niveau.code
AND etudiant.matricule=mat
;;
delimiter ;

-- ----------------------------
-- Function structure for moyenne_ue_etudiant
-- ----------------------------
DROP FUNCTION IF EXISTS `moyenne_ue_etudiant`;
delimiter ;;
CREATE FUNCTION `moyenne_ue_etudiant`(`matricule_etudiant` varchar(255),`codeenseignement` bigint(20))
 RETURNS float
BEGIN

DECLARE resultat float;

select SUM(valeur_note*pourcentage/100) into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite,annee_academique, semestre
where note.est_inscrit=est_inscrit.code
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`	
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=matricule_etudiant
and enseignement.`code`=codeenseignement
and classe.niveau=niveau.`code`;

	RETURN resultat;
	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for releve_note
-- ----------------------------
DROP PROCEDURE IF EXISTS `releve_note`;
delimiter ;;
CREATE PROCEDURE `releve_note`(IN `mat` varchar(255),IN `niv` int,IN `an` int)
BEGIN
	#Routine body goes here...
	select DISTINCT matricule, niveau.description as niveau,
module.libelle as module, ue.libelle as ue, extract(year from annee_academique.date_debut) as annee, nom, moyenne_ue_etudiant(mat,enseignement.`code`) as moyenne, (case when (moyenne_ue_etudiant(mat,enseignement.`code`) >=10) 
 THEN
      "CA" 
	WHEN (moyenne_ue_etudiant(mat,enseignement.`code`)>=9) THEN
      "CANT" 
	WHEN (moyenne_ue_etudiant(mat,enseignement.`code`) <9) THEN
      "NC" 
 END)
 as decision,(case when (moyenne_ue_etudiant(mat,enseignement.`code`) >=16 and moyenne_ue_etudiant(mat,enseignement.`code`)<=20) 
 THEN
      "A" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=15 and moyenne_ue_etudiant(mat,enseignement.`code`)<16) THEN
      "A-" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=14 and moyenne_ue_etudiant(mat,enseignement.`code`)<15) THEN
      "B+" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=13 and moyenne_ue_etudiant(mat,enseignement.`code`)<14) THEN
      "B" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=12 and moyenne_ue_etudiant(mat,enseignement.`code`)<13) THEN
      "B-" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=11 and moyenne_ue_etudiant(mat,enseignement.`code`)<12) THEN
      "C+" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=10 and moyenne_ue_etudiant(mat,enseignement.`code`)<11) THEN
      "C" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=9 and moyenne_ue_etudiant(mat,enseignement.`code`)<10) THEN
      "C-" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=8 and moyenne_ue_etudiant(mat,enseignement.`code`)<9) THEN
      "D+" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=7 and moyenne_ue_etudiant(mat,enseignement.`code`)<8) THEN
      "D" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=6 and moyenne_ue_etudiant(mat,enseignement.`code`)<7) THEN
      "E" 
	when (moyenne_ue_etudiant(mat,enseignement.`code`) >=0 and moyenne_ue_etudiant(mat,enseignement.`code`)<6) THEN
      "F" 
 END) as grade,(case when (moyenne_ue_etudiant(mat,enseignement.`code`) >=9) 
 THEN
     CONCAT(credits,"/",credits)
	when (moyenne_ue_etudiant(mat,enseignement.`code`)<9) THEN
      CONCAT("0/",credits)
 END) as credits
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre
where note.est_inscrit=est_inscrit.code
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=an
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=`mat`
and niveau.numero= niv
and classe.niveau=niveau.`code`
order by module;

END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
