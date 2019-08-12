-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  Dim 12 mai 2019 à 10:47
-- Version du serveur :  5.7.21
-- Version de PHP :  7.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `isj`
--

-- --------------------------------------------------------

--
-- Structure de la table `annee_academique`
--

DROP TABLE IF EXISTS `annee_academique`;
CREATE TABLE IF NOT EXISTS `annee_academique` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_cloture` datetime DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_debut` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_annee_academique_createur` (`createur`) USING BTREE,
  KEY `FK_annee_academique_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `annee_academique`
--

INSERT INTO `annee_academique` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, '2020-05-08 00:00:00', '2019-04-08 13:32:34', '2019-09-02 00:00:00', '2019-04-08 13:32:34', NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1),
(2, '2021-05-03 00:00:00', '2019-04-08 13:36:43', '2020-09-01 00:00:00', '2019-04-08 13:36:43', NULL, NULL, NULL, 'ACTIVE', 1, 1),
(3, '2022-05-02 00:00:00', '2019-04-08 13:39:37', '2021-09-01 00:00:00', '2019-04-08 13:39:37', NULL, NULL, NULL, 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `anonymat`
--

DROP TABLE IF EXISTS `anonymat`;
CREATE TABLE IF NOT EXISTS `anonymat` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `numero_anonymat` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `note` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_anonymat_createur` (`createur`) USING BTREE,
  KEY `FK_anonymat_note` (`note`) USING BTREE,
  KEY `FK_anonymat_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_anonymat_evaluation` (`evaluation`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `anonymat`
--

INSERT INTO `anonymat` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero_anonymat`, `signature`, `statut_vie`, `createur`, `evaluation`, `modificateur`, `note`) VALUES
(1, '2019-04-22 01:10:16', '2019-04-22 01:10:16', NULL, NULL, 1, NULL, 'ACTIVE', 1, 1, 1, 1),
(2, '2019-04-22 01:13:41', '2019-04-22 01:13:41', NULL, NULL, 6, NULL, 'ACTIVE', 1, 1, 1, 2),
(3, '2019-04-22 01:13:41', '2019-04-22 01:13:41', NULL, NULL, 7, NULL, 'ACTIVE', 1, 5, 1, 4),
(4, '2019-04-22 01:13:41', '2019-04-22 01:13:41', NULL, NULL, 8, NULL, 'ACTIVE', 1, 6, 1, 5),
(5, '2019-04-22 01:13:41', '2019-04-22 01:13:41', NULL, NULL, 9, NULL, 'ACTIVE', 1, 2, 1, 3);

-- --------------------------------------------------------

--
-- Structure de la table `candidat`
--

DROP TABLE IF EXISTS `candidat`;
CREATE TABLE IF NOT EXISTS `candidat` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `DTYPE` varchar(31) DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `date_naissance` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ecole_origine` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  `nom_de_la_mere` varchar(255) DEFAULT NULL,
  `nom_du_pere` varchar(255) DEFAULT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `profession_de_la_mere` varchar(255) DEFAULT NULL,
  `profession_du_pere` varchar(255) DEFAULT NULL,
  `region_origine` varchar(255) DEFAULT NULL,
  `sexe` varchar(255) NOT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `telephone` int(11) NOT NULL,
  `telephone_de_la_mere` int(11) DEFAULT NULL,
  `telephone_du_pere` int(11) DEFAULT NULL,
  `classe` bigint(20) DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_candidat_classe` (`classe`) USING BTREE,
  KEY `FK_candidat_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_candidat_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `candidat`
--

INSERT INTO `candidat` (`code`, `DTYPE`, `date_creation`, `date_modification`, `date_naissance`, `description`, `ecole_origine`, `email`, `libelle`, `nom`, `nom_de_la_mere`, `nom_du_pere`, `prenom`, `profession_de_la_mere`, `profession_du_pere`, `region_origine`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `telephone_de_la_mere`, `telephone_du_pere`, `classe`, `createur`, `modificateur`) VALUES
(1, 'Etudiant', '2019-04-08 13:13:03', '2019-04-08 13:13:03', '1996-04-01 00:00:00', NULL, 'Excellence', 'anthonyfouda@gmail.com', NULL, 'FOUDA', 'GOURIOU', 'FOUDA', 'ANTHONY', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 691063708, NULL, NULL, 3, 1, 1),
(2, 'Etudiant', '2019-04-08 13:19:18', '2019-04-08 13:19:18', '1995-04-17 00:00:00', NULL, 'NESCAS', 'nsola@gmail.com', NULL, 'nsola', NULL, 'OYANE', 'STAHNN', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698745632, NULL, NULL, 4, 1, 1),
(3, 'Etudiant', '2019-04-08 13:23:46', '2019-04-08 13:23:46', '1997-08-16 00:00:00', NULL, 'vogt', 'cena@gmail.com', NULL, 'SONG', 'SONG', NULL, 'JUNIOR', NULL, NULL, NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 658974121, NULL, NULL, 4, 1, 1),
(4, 'Etudiant', '2019-04-20 12:38:47', '2019-04-20 12:38:53', '1996-02-14 12:39:03', NULL, 'vogt', 'ntonga@gmail.com', NULL, 'ntonga', NULL, 'NTONGA', 'JEANNE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 698959632, NULL, NULL, 5, 1, 1),
(5, 'Etudiant', '2019-04-21 23:20:45', '2019-04-21 23:20:49', '1999-03-17 23:20:53', NULL, 'Saint benoit', 'pie@gmail.com', NULL, 'Mandeng', NULL, 'Mandeng', 'IRENE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 698784512, NULL, NULL, 6, 1, 1),
(6, 'Etudiant', '2019-04-21 23:23:02', '2019-04-21 23:23:06', '1997-10-07 23:23:10', NULL, 'Advantiste', 'anne@gmail.com', NULL, 'Mboa', 'NANDA', 'Mboa', 'ANNE', NULL, NULL, NULL, 'FEMININ', NULL, 'ACTIVE', 'ACTIVE', 632541258, NULL, NULL, 3, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `classe`
--

DROP TABLE IF EXISTS `classe`;
CREATE TABLE IF NOT EXISTS `classe` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `niveau` bigint(20) DEFAULT NULL,
  `specialite` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_classe_createur` (`createur`) USING BTREE,
  KEY `FK_classe_niveau` (`niveau`) USING BTREE,
  KEY `FK_classe_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_classe_specialite` (`specialite`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `classe`
--

INSERT INTO `classe` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`, `niveau`, `specialite`) VALUES
(4, '2019-04-20 12:45:51', '2019-04-20 12:45:55', NULL, NULL, NULL, 'ACTIVE', 1, 1, 2, 2),
(3, '2019-04-20 12:45:16', '2019-04-20 12:45:20', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1, 1),
(5, '2019-04-20 12:46:36', '2019-04-20 12:46:41', NULL, NULL, NULL, 'ACTIVE', 1, 1, 3, 2),
(6, '2019-04-20 12:47:14', '2019-04-20 12:47:18', NULL, NULL, NULL, 'ACTIVE', 1, 1, 4, 1);

-- --------------------------------------------------------

--
-- Structure de la table `discipline`
--

DROP TABLE IF EXISTS `discipline`;
CREATE TABLE IF NOT EXISTS `discipline` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `nb_heures_absences` int(11) DEFAULT NULL,
  `nb_retards` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `etudiant` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `semestre` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_discipline_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_discipline_createur` (`createur`) USING BTREE,
  KEY `FK_discipline_semestre` (`semestre`) USING BTREE,
  KEY `FK_discipline_etudiant` (`etudiant`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `discipline`
--

INSERT INTO `discipline` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `nb_heures_absences`, `nb_retards`, `signature`, `statut_vie`, `createur`, `etudiant`, `modificateur`, `semestre`) VALUES
(1, '2019-04-22 00:00:30', '2019-04-22 00:00:35', NULL, NULL, 10, 7, NULL, 'ACTIVE', 1, 1, 1, 1),
(2, '2019-04-22 00:02:21', '2019-04-22 00:02:21', NULL, NULL, 5, 18, NULL, 'ACTIVE', 1, 1, 1, 2),
(3, '2019-04-22 00:04:00', '2019-04-22 00:04:00', NULL, NULL, 0, 5, NULL, 'ACTIVE', 1, 2, 1, 1),
(4, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 25, 8, NULL, 'ACTIVE', 1, 2, 1, 2),
(5, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 2, 4, NULL, 'ACTIVE', 1, 3, 1, 1),
(6, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 0, NULL, 'ACTIVE', 1, 3, 1, 2),
(7, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 35, 18, NULL, 'ACTIVE', 1, 4, 1, 1),
(8, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 2, 0, NULL, 'ACTIVE', 1, 4, 1, 2),
(9, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 3, 6, NULL, 'ACTIVE', 1, 5, 1, 1),
(10, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 0, NULL, 'ACTIVE', 1, 5, 1, 2),
(11, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 1, 1, NULL, 'ACTIVE', 1, 6, 1, 1),
(12, '2019-04-22 00:07:30', '2019-04-22 00:07:30', NULL, NULL, 0, 21, NULL, 'ACTIVE', 1, 6, 1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `droit`
--

DROP TABLE IF EXISTS `droit`;
CREATE TABLE IF NOT EXISTS `droit` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `categorie` varchar(255) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ecriture` tinyint(1) DEFAULT '0',
  `lecture` tinyint(1) DEFAULT '0',
  `libelle` varchar(255) DEFAULT NULL,
  `modification` tinyint(1) DEFAULT '0',
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `suppression` tinyint(1) DEFAULT '0',
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `role` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_droit_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_droit_role` (`role`) USING BTREE,
  KEY `FK_droit_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=629 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `droit`
--

INSERT INTO `droit` (`code`, `categorie`, `date_creation`, `date_modification`, `description`, `ecriture`, `lecture`, `libelle`, `modification`, `signature`, `statut_vie`, `suppression`, `createur`, `modificateur`, `role`) VALUES
(1, '', '2019-04-22 02:00:55', '2019-04-22 02:00:55', NULL, 1, 1, NULL, 1, NULL, 'ACTIVE', 1, 1, 1, 2),
(2, '', '2019-04-22 02:01:59', '2019-04-22 02:01:59', NULL, 0, 1, NULL, 0, NULL, 'ACTIVE', 0, 1, 1, 3),
(3, '', '2019-04-22 02:03:51', '2019-04-22 02:03:51', NULL, 1, 1, NULL, 0, NULL, 'ACTIVE', 0, 1, 1, 1),
(4, '', '2019-04-22 02:04:37', '2019-04-22 02:04:37', NULL, 1, 1, NULL, 1, NULL, 'ACTIVE', 0, 1, 1, 4),
(628, 'Utilisateur', '2019-05-12 10:15:21', '2019-05-12 10:15:21', '', 1, 1, '', 1, '1402844090', 'ACTIVE', 1, 1, 1, 551),
(627, 'UE', '2019-05-12 10:15:21', '2019-05-12 10:15:21', '', 1, 1, '', 1, '1065062547', 'ACTIVE', 1, 1, 1, 551),
(626, 'TypeEvaluation', '2019-05-12 10:15:21', '2019-05-12 10:15:21', '', 1, 1, '', 1, '-1651258554', 'ACTIVE', 1, 1, 1, 551),
(625, 'Specialite', '2019-05-12 10:15:21', '2019-05-12 10:15:21', '', 1, 1, '', 1, '1004021022', 'ACTIVE', 1, 1, 1, 551),
(624, 'Session', '2019-05-12 10:15:21', '2019-05-12 10:15:21', '', 1, 1, '', 1, '-1430899128', 'ACTIVE', 1, 1, 1, 551),
(623, 'Semestre', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '406687552', 'ACTIVE', 1, 1, 1, 551),
(622, 'Securite', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-66443481', 'ACTIVE', 1, 1, 1, 551),
(621, 'Role', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '2006649339', 'ACTIVE', 1, 1, 1, 551),
(620, 'Personne', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-785770315', 'ACTIVE', 1, 1, 1, 551),
(619, 'Note', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-700321288', 'ACTIVE', 1, 1, 1, 551),
(618, 'Niveau', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1447869918', 'ACTIVE', 1, 1, 1, 551),
(617, 'Module', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '692724529', 'ACTIVE', 1, 1, 1, 551),
(616, 'Message', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1300823777', 'ACTIVE', 1, 1, 1, 551),
(615, 'HistoriqueNote', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1231993574', 'ACTIVE', 1, 1, 1, 551),
(614, 'Filiere', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1186924822', 'ACTIVE', 1, 1, 1, 551),
(613, 'Evaluation', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1467544945', 'ACTIVE', 1, 1, 1, 551),
(612, 'Etudiant', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '524118053', 'ACTIVE', 1, 1, 1, 551),
(611, 'EstInscrit', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1772705343', 'ACTIVE', 1, 1, 1, 551),
(610, 'EnvoiMessage', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1912451645', 'ACTIVE', 1, 1, 1, 551),
(609, 'Enseignement', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1903543409', 'ACTIVE', 1, 1, 1, 551),
(608, 'Enseignant', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-35735128', 'ACTIVE', 1, 1, 1, 551),
(607, 'Email', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1712534978', 'ACTIVE', 1, 1, 1, 551),
(606, 'Droit', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1642155858', 'ACTIVE', 1, 1, 1, 551),
(605, 'Discipline', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1541539625', 'ACTIVE', 1, 1, 1, 551),
(604, 'Classe', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1469433065', 'ACTIVE', 1, 1, 1, 551),
(603, 'Candidat', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-541848409', 'ACTIVE', 1, 1, 1, 551),
(602, 'Anonymat', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '-1500376207', 'ACTIVE', 1, 1, 1, 551),
(601, 'AnneeAcademique', '2019-05-12 10:15:20', '2019-05-12 10:15:20', '', 1, 1, '', 1, '1452185035', 'ACTIVE', 1, 1, 1, 551);

-- --------------------------------------------------------

--
-- Structure de la table `email`
--

DROP TABLE IF EXISTS `email`;
CREATE TABLE IF NOT EXISTS `email` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `objet` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=152 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `email`
--

INSERT INTO `email` (`code`, `objet`) VALUES
(1, 'salutation'),
(151, 'test'),
(2, 'salutation 2'),
(3, 'salution3');

-- --------------------------------------------------------

--
-- Structure de la table `enseignant`
--

DROP TABLE IF EXISTS `enseignant`;
CREATE TABLE IF NOT EXISTS `enseignant` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `date_naissance` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `qualification` varchar(255) DEFAULT NULL,
  `sexe` varchar(255) NOT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `telephone` int(11) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_enseignant_createur` (`createur`) USING BTREE,
  KEY `FK_enseignant_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `enseignant`
--

INSERT INTO `enseignant` (`code`, `date_creation`, `date_modification`, `date_naissance`, `description`, `email`, `libelle`, `nom`, `prenom`, `qualification`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `createur`, `modificateur`) VALUES
(1, '2019-04-11 08:37:29', '2019-04-11 08:37:29', '1968-04-10 00:00:00', NULL, 'kiampi@gmail.com', NULL, 'Kiampi', NULL, 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 699333333, 1, 1),
(2, '2019-04-11 08:38:57', '2019-04-11 08:38:57', '1968-10-04 00:00:00', NULL, 'SAHA@gmail.com', NULL, 'Saha', NULL, 'MASTER', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 699989796, 1, 1),
(3, '2019-04-11 08:40:49', '2019-04-11 08:40:49', '1975-04-09 00:00:00', NULL, 'Tchio@gmail.com', NULL, 'Tchio', 'Corneille', NULL, 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 601063708, 1, 1),
(4, '2019-04-11 08:42:14', '2019-04-11 08:42:14', '1964-03-09 00:00:00', NULL, 'Mballa@gmail.com', NULL, 'Mballa', 'Fabien', 'Pr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 601043507, 1, 1),
(5, '2019-04-11 08:46:09', '2019-04-11 08:46:09', '1963-08-21 00:00:00', NULL, 'kwamo@gmail.com', NULL, 'Kouamo', 'Georges', 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698451425, 1, 1),
(6, '2019-04-11 08:47:57', '2019-04-11 08:47:57', '1963-08-21 00:00:00', NULL, 'Tchantcho@gmail.com', NULL, 'Tchantcho', 'Hugues', 'Dr', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 658471425, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `enseignement`
--

DROP TABLE IF EXISTS `enseignement`;
CREATE TABLE IF NOT EXISTS `enseignement` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `heures_de_cours` int(11) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `programme_de_cours` varchar(1020) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `semestre` bigint(20) DEFAULT NULL,
  `ue` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_enseignement_ue` (`ue`) USING BTREE,
  KEY `FK_enseignement_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_enseignement_createur` (`createur`) USING BTREE,
  KEY `FK_enseignement_semestre` (`semestre`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `enseignement`
--

INSERT INTO `enseignement` (`code`, `date_creation`, `date_modification`, `description`, `heures_de_cours`, `libelle`, `programme_de_cours`, `signature`, `statut_vie`, `createur`, `modificateur`, `semestre`, `ue`) VALUES
(1, '2019-04-11 08:20:57', '2019-04-11 08:20:57', NULL, 35, 'ARHITECTURE', NULL, NULL, 'ACTIVE', 1, 1, 1, 2),
(2, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'MATH INFO', NULL, NULL, 'ACTIVE', 1, 1, 1, 3),
(3, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'JAVA I', NULL, NULL, 'ACTIVE', 1, 1, 2, 5),
(4, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'PROG C', NULL, NULL, 'ACTIVE', 1, 1, 2, 6),
(5, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'SYSTEME D INFORMATION', NULL, NULL, 'ACTIVE', 1, 1, 1, 1),
(6, '2019-04-11 08:25:20', '2019-04-11 08:25:20', NULL, 35, 'MATH DISCRETES', NULL, NULL, 'ACTIVE', 1, 1, 1, 4);

-- --------------------------------------------------------

--
-- Structure de la table `enseignement_enseignant`
--

DROP TABLE IF EXISTS `enseignement_enseignant`;
CREATE TABLE IF NOT EXISTS `enseignement_enseignant` (
  `code_enseignant` bigint(20) NOT NULL,
  `code_enseignement` bigint(20) NOT NULL,
  PRIMARY KEY (`code_enseignant`,`code_enseignement`) USING BTREE,
  KEY `FK_enseignement_enseignant_code_enseignement` (`code_enseignement`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

--
-- Déchargement des données de la table `enseignement_enseignant`
--

INSERT INTO `enseignement_enseignant` (`code_enseignant`, `code_enseignement`) VALUES
(1, 2),
(2, 1),
(3, 4),
(4, 5),
(5, 3),
(6, 6);

-- --------------------------------------------------------

--
-- Structure de la table `envoi_message`
--

DROP TABLE IF EXISTS `envoi_message`;
CREATE TABLE IF NOT EXISTS `envoi_message` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_envoi` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `candidat` bigint(20) DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `message` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_envoi_message_createur` (`createur`) USING BTREE,
  KEY `FK_envoi_message_candidat` (`candidat`) USING BTREE,
  KEY `FK_envoi_message_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_envoi_message_message` (`message`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=402 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `envoi_message`
--

INSERT INTO `envoi_message` (`code`, `date_creation`, `date_envoi`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat`, `createur`, `modificateur`, `message`) VALUES
(1, '2019-04-22 01:16:49', '2019-04-22 01:16:49', '2019-04-22 01:16:49', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 1, 1, 1, 1),
(2, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 2, 1, 1, 2),
(3, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 3, 1, 1, 3),
(4, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'ECHEC', 'ACTIVE', 4, 1, 1, 4),
(5, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'ECHEC', 'ACTIVE', 5, 1, 1, 5),
(6, '2019-04-22 01:18:05', '2019-04-22 01:18:05', '2019-04-22 01:18:05', NULL, NULL, NULL, 'SUCCES', 'ACTIVE', 6, 1, 1, 6),
(401, '2019-04-26 12:58:26', '2019-04-26 12:58:26', '2019-04-26 12:58:26', 'test', 'test', '31', 'SUCCES', 'ACTIVE', 1, 1, 1, 151);

-- --------------------------------------------------------

--
-- Structure de la table `est_inscrit`
--

DROP TABLE IF EXISTS `est_inscrit`;
CREATE TABLE IF NOT EXISTS `est_inscrit` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `candidat_inscrit` bigint(20) DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `enseignement` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_est_inscrit_candidat_inscrit` (`candidat_inscrit`) USING BTREE,
  KEY `FK_est_inscrit_createur` (`createur`) USING BTREE,
  KEY `FK_est_inscrit_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_est_inscrit_enseignement` (`enseignement`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `est_inscrit`
--

INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(3, '2019-04-22 00:47:36', '2019-04-22 00:47:36', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 1, 1, 3, 1),
(4, '2019-04-22 00:47:36', '2019-04-22 00:47:36', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 1, 1, 4, 1),
(5, '2019-04-22 00:50:11', '2019-04-22 00:50:11', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 2, 1, 1, 1),
(6, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 2, 1, 1, 1),
(7, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 3, 1, 1, 1),
(8, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 4, 1, 2, 1),
(9, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 4, 1, 6, 1),
(10, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 3, 1),
(11, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 4, 1),
(12, '2019-04-22 00:55:17', '2019-04-22 00:55:17', NULL, NULL, NULL, 'VALIDE', 'ACTIVE', 6, 1, 5, 1);

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE IF NOT EXISTS `etudiant` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_authentification` varchar(255) DEFAULT NULL,
  `matricule` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`code`, `code_authentification`, `matricule`) VALUES
(1, '1', 'ISJ0001'),
(2, '2', 'ISJ0002'),
(3, '3', 'ISJ0003'),
(4, '4', 'ISJ0004'),
(5, '5', 'ISJ0005'),
(6, '6', 'ISJ0006');

-- --------------------------------------------------------

--
-- Structure de la table `evaluation`
--

DROP TABLE IF EXISTS `evaluation`;
CREATE TABLE IF NOT EXISTS `evaluation` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_evaluation` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `type_evaluation` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_evaluation_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_evaluation_type_evaluation` (`type_evaluation`) USING BTREE,
  KEY `FK_evaluation_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `evaluation`
--

INSERT INTO `evaluation` (`code`, `date_creation`, `date_evaluation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `type_evaluation`) VALUES
(1, '2019-04-22 00:14:46', '2019-12-10 07:00:00', '2019-04-22 00:14:46', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1),
(2, '2019-04-22 00:17:57', '2019-12-11 07:00:00', '2019-04-22 00:17:57', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 4),
(6, '2019-04-22 00:22:43', '2019-12-13 10:00:00', '2019-04-22 00:22:43', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 19),
(5, '2019-04-22 00:22:29', '2019-12-13 08:00:00', '2019-04-22 00:22:29', NULL, NULL, NULL, 'ACTIVE', 'ACTIVE', 1, 1, 16);

-- --------------------------------------------------------

--
-- Structure de la table `filiere`
--

DROP TABLE IF EXISTS `filiere`;
CREATE TABLE IF NOT EXISTS `filiere` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_filiere_createur` (`createur`) USING BTREE,
  KEY `FK_filiere_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `filiere`
--

INSERT INTO `filiere` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, '2019-04-11 07:53:49', '2019-04-11 07:53:49', NULL, 'LICENCE', NULL, 'ACTIVE', 1, 1),
(3, '2019-04-11 07:54:19', '2019-04-11 07:54:19', NULL, 'INGENIEUR', NULL, 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `historique_note`
--

DROP TABLE IF EXISTS `historique_note`;
CREATE TABLE IF NOT EXISTS `historique_note` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `valeur_note` double NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `note` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_historique_note_note` (`note`) USING BTREE,
  KEY `FK_historique_note_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_historique_note_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `historique_note`
--

INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(1, '2019-04-22 01:25:46', '2019-04-22 01:25:46', NULL, NULL, NULL, 'ACTIVE', 17, 1, 1, 1),
(2, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 17, 1, 1, 2),
(3, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 14, 1, 1, 3),
(4, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 8, 1, 1, 4),
(5, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, NULL, 'ACTIVE', 11, 1, 1, 5);

-- --------------------------------------------------------

--
-- Structure de la table `message`
--

DROP TABLE IF EXISTS `message`;
CREATE TABLE IF NOT EXISTS `message` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `DTYPE` varchar(31) DEFAULT NULL,
  `contenu` varchar(255) DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `destinataire` varchar(255) DEFAULT NULL,
  `emetteur` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_message_createur` (`createur`) USING BTREE,
  KEY `FK_message_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=152 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `message`
--

INSERT INTO `message` (`code`, `DTYPE`, `contenu`, `date_creation`, `date_modification`, `description`, `destinataire`, `emetteur`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, 'Email', 'BONjour 1', '2019-04-22 01:20:09', '2019-04-22 01:20:09', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1),
(2, 'Email', 'BONjour 2', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1),
(3, 'Email', 'BONjour 3', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1),
(4, 'Sms', 'BONjour 4', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1),
(5, 'Sms', 'BONjour 5', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1),
(6, 'Sms', 'BONjour 6', '2019-04-22 01:21:05', '2019-04-22 01:21:05', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_Module_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_Module_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `module`
--

INSERT INTO `module` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, '2019-04-11 07:44:06', '2019-04-11 07:44:06', NULL, 'SYSTEME D\'INFORMATION ET ARCHITECTURE', NULL, 'ACTIVE', 1, 1),
(2, '2019-04-11 07:44:54', '2019-04-11 07:44:54', NULL, 'MATH APPLIQUEES POUR INFO', NULL, 'ACTIVE', 1, 1),
(3, '2019-04-11 07:45:34', '2019-04-11 07:45:34', NULL, 'JAVA1 ET PROGRAMMATION EN C', NULL, 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `niveau`
--

DROP TABLE IF EXISTS `niveau`;
CREATE TABLE IF NOT EXISTS `niveau` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `numero` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_Niveau_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_Niveau_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `niveau`
--

INSERT INTO `niveau` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, '2019-04-11 07:50:44', '2019-04-11 07:50:44', 'NIVEAU 1 LICENCE', '', 1, NULL, 'ACTIVE', 1, 1),
(2, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 1 INGENIEUR', '', 1, NULL, 'ACTIVE', 1, 1),
(3, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 2 INGENIEUR', '', 2, NULL, 'ACTIVE', 1, 1),
(4, '2019-04-11 07:52:25', '2019-04-11 07:52:25', 'NIVEAU 2 LICENCE', '', 2, NULL, 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `note`
--

DROP TABLE IF EXISTS `note`;
CREATE TABLE IF NOT EXISTS `note` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `numero_table` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `valeur_note` double NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `est_inscrit` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_note_est_inscrit` (`est_inscrit`) USING BTREE,
  KEY `FK_note_createur` (`createur`) USING BTREE,
  KEY `FK_note_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_note_evaluation` (`evaluation`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `note`
--

INSERT INTO `note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero_table`, `signature`, `statut_vie`, `valeur_note`, `createur`, `evaluation`, `modificateur`, `est_inscrit`) VALUES
(1, '2019-04-22 01:25:46', '2019-04-22 01:25:46', NULL, NULL, 10, NULL, 'ACTIVE', 17, 1, 1, 1, 6),
(2, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 10, NULL, 'ACTIVE', 17, 1, 1, 1, 7),
(3, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 15, NULL, 'ACTIVE', 14, 1, 2, 1, 8),
(4, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 20, NULL, 'ACTIVE', 8, 1, 5, 1, 12),
(5, '2019-04-22 01:28:03', '2019-04-22 01:28:03', NULL, NULL, 22, NULL, 'ACTIVE', 11, 1, 6, 1, 9);

-- --------------------------------------------------------

--
-- Structure de la table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_role_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_role_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=552 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `role`
--

INSERT INTO `role` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1, '2019-04-21 23:41:21', '2019-04-21 23:41:21', NULL, NULL, NULL, 'ACTIVE', 1, 1),
(2, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1),
(3, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1),
(4, '2019-04-21 23:42:24', '2019-04-21 23:42:24', NULL, NULL, NULL, 'ACTIVE', 1, 1),
(551, '2019-05-12 09:57:07', '2019-05-12 10:41:18', '', 'Role Test', '1407260751', 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `semestre`
--

DROP TABLE IF EXISTS `semestre`;
CREATE TABLE IF NOT EXISTS `semestre` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_cloture` datetime DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_debut` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `annee_academique` bigint(20) DEFAULT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_semestre_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_semestre_createur` (`createur`) USING BTREE,
  KEY `FK_semestre_annee_academique` (`annee_academique`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `semestre`
--

INSERT INTO `semestre` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `annee_academique`, `createur`, `modificateur`) VALUES
(1, '2020-01-30 00:00:00', '2019-04-08 13:44:32', '2019-09-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1),
(2, '2020-05-18 00:00:00', '2019-04-08 13:54:54', '2020-01-03 00:00:00', '2019-04-08 13:54:54', NULL, NULL, NULL, 'ACTIVE', 1, 1, 1),
(3, '2021-01-30 00:00:00', '2019-04-21 23:46:20', '2020-09-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 2, 1, 1),
(4, '2021-05-30 00:00:00', '2019-04-21 23:46:20', '2021-01-02 00:00:00', '2019-04-08 13:44:32', NULL, NULL, NULL, 'ACTIVE', 2, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `sequence`
--

DROP TABLE IF EXISTS `sequence`;
CREATE TABLE IF NOT EXISTS `sequence` (
  `SEQ_NAME` varchar(50) NOT NULL,
  `SEQ_COUNT` decimal(38,0) DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `sequence`
--

INSERT INTO `sequence` (`SEQ_NAME`, `SEQ_COUNT`) VALUES
('SEQ_GEN', '650');

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE IF NOT EXISTS `session` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_connection` datetime DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_deconnection` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `machine_cliente` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `utilisateur` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_Session_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_Session_utilisateur` (`utilisateur`) USING BTREE,
  KEY `FK_Session_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`code`, `date_connection`, `date_creation`, `date_deconnection`, `date_modification`, `description`, `libelle`, `machine_cliente`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `utilisateur`) VALUES
(1, '2019-04-30 15:33:01', '2019-04-30 15:33:20', '2019-04-30 15:45:24', '2019-04-30 15:33:36', NULL, NULL, 'MA1', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1),
(2, '2019-04-30 15:35:11', '2019-04-30 15:35:18', '2019-04-30 15:49:22', '2019-04-30 15:35:48', NULL, NULL, 'MA2', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2),
(3, '2019-04-30 15:36:27', '2019-04-30 15:36:36', '2019-04-30 16:36:42', '2019-04-30 15:36:51', NULL, NULL, 'MA3', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 3),
(4, '2019-04-30 15:37:17', '2019-04-30 15:37:21', '2019-04-30 17:37:25', '2019-04-30 15:37:35', NULL, NULL, 'MA4', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 4);

-- --------------------------------------------------------

--
-- Structure de la table `sms`
--

DROP TABLE IF EXISTS `sms`;
CREATE TABLE IF NOT EXISTS `sms` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

--
-- Déchargement des données de la table `sms`
--

INSERT INTO `sms` (`code`) VALUES
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- Structure de la table `specialite`
--

DROP TABLE IF EXISTS `specialite`;
CREATE TABLE IF NOT EXISTS `specialite` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `filiere` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_specialite_filiere` (`filiere`) USING BTREE,
  KEY `FK_specialite_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_specialite_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `specialite`
--

INSERT INTO `specialite` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `filiere`, `modificateur`) VALUES
(1, '2019-04-11 07:56:37', '2019-04-11 07:56:37', NULL, 'genie logiciel', NULL, 'ACTIVE', 1, 1, 1),
(2, '2019-04-11 07:56:54', '2019-04-11 07:56:54', NULL, 'genie logiciel', NULL, 'ACTIVE', 1, 3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `type_evaluation`
--

DROP TABLE IF EXISTS `type_evaluation`;
CREATE TABLE IF NOT EXISTS `type_evaluation` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `pourcentage` float DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `enseignement` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_type_evaluation_enseignement` (`enseignement`) USING BTREE,
  KEY `FK_type_evaluation_createur` (`createur`) USING BTREE,
  KEY `FK_type_evaluation_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `type_evaluation`
--

INSERT INTO `type_evaluation` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `pourcentage`, `signature`, `statut_vie`, `createur`, `enseignement`, `modificateur`) VALUES
(1, '2019-04-21 23:27:49', '2019-04-21 23:27:52', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 1, 1),
(2, '2019-04-21 23:28:35', '2019-04-21 23:28:37', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 1, 1),
(3, '2019-04-21 23:29:18', '2019-04-21 23:29:22', NULL, 'Rattrapage', 70, NULL, 'ACTIVE', 1, 1, 1),
(4, '2019-04-21 23:32:32', '2019-04-21 23:32:32', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 2, 1),
(6, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normaale', 70, NULL, 'ACTIVE', 1, 2, 1),
(7, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapage', 70, NULL, 'ACTIVE', 1, 2, 1),
(8, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 20, NULL, 'ACTIVE', 1, 3, 1),
(9, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 40, NULL, 'ACTIVE', 1, 3, 1),
(10, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Travaux pratiques', 40, NULL, 'ACTIVE', 1, 3, 1),
(11, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 40, NULL, 'ACTIVE', 1, 3, 1),
(12, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 20, NULL, 'ACTIVE', 1, 4, 1),
(13, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 40, NULL, 'ACTIVE', 1, 4, 1),
(14, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Travaux pratiques', 40, NULL, 'ACTIVE', 1, 4, 1),
(15, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 40, NULL, 'ACTIVE', 1, 4, 1),
(16, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 5, 1),
(17, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 5, 1),
(18, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 70, NULL, 'ACTIVE', 1, 5, 1),
(19, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Controle continu', 30, NULL, 'ACTIVE', 1, 6, 1),
(20, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Session normale', 70, NULL, 'ACTIVE', 1, 6, 1),
(21, '2019-04-21 23:38:31', '2019-04-21 23:38:31', NULL, 'Rattrapages', 70, NULL, 'ACTIVE', 1, 6, 1);

-- --------------------------------------------------------

--
-- Structure de la table `ue`
--

DROP TABLE IF EXISTS `ue`;
CREATE TABLE IF NOT EXISTS `ue` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_ue` varchar(255) DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `module` bigint(20) DEFAULT NULL,
  `niveau` bigint(20) DEFAULT NULL,
  `specialite` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_UE_niveau` (`niveau`) USING BTREE,
  KEY `FK_UE_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_UE_specialite` (`specialite`) USING BTREE,
  KEY `FK_UE_module` (`module`) USING BTREE,
  KEY `FK_UE_createur` (`createur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ue`
--

INSERT INTO `ue` (`code`, `code_ue`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `module`, `niveau`, `specialite`) VALUES
(1, 'INF111', '2019-04-11 08:04:22', '2019-04-11 08:04:22', NULL, 'Systeme d indormation', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1, 1, 1),
(2, 'INF113', '2019-04-11 08:05:41', '2019-04-11 08:05:41', NULL, 'Architecture des ordinateurs', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 1, 2, 2),
(3, 'MAT111', '2019-04-11 08:07:55', '2019-04-11 08:07:55', NULL, 'MATH POUR INFORMATIQUE', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2, 3, 2),
(4, 'MAT112', '2019-04-11 08:09:21', '2019-04-11 08:09:21', NULL, 'MATH DISCRETES I', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 2, 3, 2),
(5, 'INF121', '2019-04-11 08:11:52', '2019-04-11 08:11:52', NULL, 'JAVA I', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 3, 1, 1),
(6, 'INF124', '2019-04-11 08:12:31', '2019-04-11 08:12:31', NULL, 'PROGRAMMATION C', NULL, 'ACTIVE', 'ACTIVE', 1, 1, 4, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `date_naissance` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `login` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `sexe` varchar(255) NOT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut` varchar(255) NOT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `telephone` int(11) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `login` (`login`) USING BTREE,
  UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_utilisateur_createur` (`createur`) USING BTREE,
  KEY `FK_utilisateur_modificateur` (`modificateur`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`code`, `date_creation`, `date_modification`, `date_naissance`, `description`, `email`, `libelle`, `login`, `mot_de_passe`, `nom`, `prenom`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `createur`, `modificateur`) VALUES
(1, '2019-04-08 12:52:09', '2019-05-12 10:35:52', '1990-04-09 00:00:00', NULL, 'ongono@gmail.com', NULL, 'yannick', 'BA-32-53-87-6A-ED-6B-C2-2D-4A-6F-F5-3D-84-6-C6-AD-86-41-95-ED-14-4A-B5-C8-76-21-B6-C2-33-B5-48-BA-EA-E6-95-6D-F3-46-EC-8C-17-F5-EA-10-F3-5E-E3-CB-C5-14-79-7E-D7-DD-D3-14-54-64-E2-A0-BA-B4-13', 'ONGONO', 'YANNICKK', 'MASCULIN', '1277867969', 'ACTIVE', 'ACTIVE', 691063708, 1, 1),
(2, '2019-04-08 12:55:52', '2019-05-12 10:41:18', '1987-02-10 00:00:00', NULL, 'tapigue@gmail.com', NULL, 'tapigue', 'azerty', 'TAPIGUE', 'DELPHIN', 'MASCULIN', '-1185743807', 'ACTIVE', 'ACTIVE', 698785474, 1, 1),
(3, '2019-04-08 12:59:48', '2019-04-08 12:59:48', '1978-06-21 00:00:00', NULL, 'herve@gmail.com', NULL, 'jeanherve', 'isj123', 'JEAN', 'HERVE', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 690548932, 1, 1),
(4, '2019-04-08 13:03:59', '2019-04-08 13:03:59', '1984-04-17 00:00:00', NULL, 'emmamoupo@gmail.com', NULL, 'emmanuel', 'isj456', 'MOUPOJOU', 'EMMANUEL', 'MASCULIN', NULL, 'ACTIVE', 'ACTIVE', 698745621, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur_role`
--

DROP TABLE IF EXISTS `utilisateur_role`;
CREATE TABLE IF NOT EXISTS `utilisateur_role` (
  `code_utilisateur` bigint(20) NOT NULL,
  `code_role` bigint(20) NOT NULL,
  PRIMARY KEY (`code_utilisateur`,`code_role`) USING BTREE,
  KEY `FK_utilisateur_role_code_role` (`code_role`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

--
-- Déchargement des données de la table `utilisateur_role`
--

INSERT INTO `utilisateur_role` (`code_utilisateur`, `code_role`) VALUES
(1, 1),
(1, 551),
(2, 2),
(2, 551),
(3, 3),
(4, 4);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
