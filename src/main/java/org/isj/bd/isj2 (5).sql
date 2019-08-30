-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  lun. 12 août 2019 à 14:14
-- Version du serveur :  5.7.23
-- Version de PHP :  7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `isj2`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `abs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abs` (IN `niv` INT, IN `fil` VARCHAR(255), IN `ans` INT, IN `sem` VARCHAR(255))  BEGIN
SELECT distinct matricule,CONCAT(nom," ",prenom) as pers,MONTHNAME(date_retard) as mois,nb_heures_absences,heure_justifie,(nb_heures_absences-heure_justifie) as HNJ
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
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
#and classe.niveau=niveau.`code`
and semestre.libelle=sem
and filiere.libelle=fil;
end$$

DROP PROCEDURE IF EXISTS `AFFICHER_NOTE`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AFFICHER_NOTE` (IN `eval` VARCHAR(255), IN `code_ue` VARCHAR(255), IN `code_authentification` VARCHAR(255))  BEGIN
	select DISTINCT valeur_note, ue.code_ue as code_ue, type_evaluation.libelle as examen
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite
where note.est_inscrit=est_inscrit.code
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
and ue.code_ue=code_ue
and type_evaluation.libelle=eval
and etudiant.code_authentification=code_authentification
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and niveau.`code`=ue.niveau
and ue.module=module.`code`;

END$$

DROP PROCEDURE IF EXISTS `cursus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cursus` (IN `mat` VARCHAR(255))  BEGIN
	#Routine body goes here...
	select matricule, CONCAT(filiere.libelle," ",niveau.numero) as niveau,ue.code_ue as codeue,
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
 END) as credits,(case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then CONCAT('Rattrapge',' ',extract(year from annee_academique.date_debut)) when COUNT(case when type_evaluation.libelle='Rattrapage' then 1 else NULL end )=0 then CONCAT('Normale',' ',extract(year from annee_academique.date_debut))end) as Session,semestre.libelle as Semestre,(case when (((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1))=0 then 0
	else CONCAT("-",((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1)) end) as penalites
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
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
and etudiant.matricule=`mat`
#and classe.niveau=niveau.`code`
group by ue.libelle
order by annee,semestre;
END$$

DROP PROCEDURE IF EXISTS `etud_class`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `etud_class` (IN `niv` INT, IN `fil` VARCHAR(255), IN `ans` INT)  BEGIN
	#Routine body goes here...
		select DISTINCT matricule, CONCAT(nom, " ", prenom)
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
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
and filiere.libelle=fil
and niveau.numero= niv;

END$$

DROP PROCEDURE IF EXISTS `inf_etud`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inf_etud` (IN `mat` VARCHAR(255))  SELECT nom,prenom,date_naissance,sexe,matricule,filiere.libelle as filiere,niveau.numero as niveau
from candidat,filiere,classe,niveau,specialite,etudiant
where candidat.code=etudiant.code
AND candidat.classe=classe.code
AND classe.specialite=specialite.code
AND specialite.filiere=filiere.code
AND classe.niveau=niveau.code
AND etudiant.matricule=mat$$

DROP PROCEDURE IF EXISTS `pv`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pv` (IN `fil` VARCHAR(255), IN `niv` INT, IN `an` INT, IN `sem` VARCHAR(255))  BEGIN
	select DISTINCT matricule,CONCAT(UPPER(nom)," ",UPPER(prenom)) as nom_prenom, niveau.description as niveau,
module.libelle as module,ue.code_ue as codeue, ue.libelle as ue,( case when type_evaluation.libelle="Controle continu" then moy_ue_etud_typ_ev(matricule,enseignement.`code`)
else valeur_note END) as moyenne,grade(moyenne_ue_etudiant(matricule,enseignement.`code`))as grade,type_evaluation.libelle,CONCAT(type_evaluation.pourcentage,"%") as pourcentage,decision(( case when type_evaluation.libelle="Controle continu" then moyenne_ue_etudiant(matricule,enseignement.`code`)
else valeur_note END)) as decision,(case when (moyenne_ue_etudiant(matricule,enseignement.`code`) >=9) 
 THEN credits
	when (moyenne_ue_etudiant(matricule,enseignement.`code`)<9) THEN
      0
 END) as credits, extract(year from annee_academique.date_debut) as annee
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
and niveau.numero= niv
and filiere.libelle=fil
and semestre.libelle=sem
group by matricule,ue.libelle,type_evaluation.libelle
order by nom;
END$$

DROP PROCEDURE IF EXISTS `releve_note`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `releve_note` (IN `mat` VARCHAR(255), IN `niv` INT, IN `an` INT)  BEGIN
	#Routine body goes here...
	select DISTINCT matricule, niveau.description as niveau,ue.code_ue as codeue,module.code_module,
module.libelle as module, ue.libelle as ue, extract(year from annee_academique.date_debut) as annee, nom, moyenne_ue_etudiant(mat,enseignement.`code`) as moyenne,decision((moyenne_ue_etudiant(mat,enseignement.`code`))) as decision,grade(moyenne_ue_etudiant(mat,enseignement.`code`))as grade,(case when (moyenne_ue_etudiant(mat,enseignement.`code`) >=9) 
 THEN
     CONCAT(credits,"/",credits)
	when (moyenne_ue_etudiant(mat,enseignement.`code`)<9) THEN
      CONCAT("0/",credits)
 END) as credits,(case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then CONCAT('Rattrapge',' ',extract(year from annee_academique.date_debut)) when COUNT(case when type_evaluation.libelle='Rattrapage' then 1 else NULL end )=0 then CONCAT('Normale',' ',extract(year from annee_academique.date_debut))end) as Session,semestre.libelle as Semestre,penalites(mat,niv,an,semestre.libelle) as penalites
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
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
group by ue.libelle,semestre
order by semestre asc;

END$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `decision`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `decision` (`val` FLOAT) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
	#Routine body goes here...
	declare resultat varchar(255);
	select case when val >=10
 THEN
      "CA" 
	WHEN val>=9 THEN
      "CANT" 
	WHEN val <9 THEN
      "NC" 
 END into resultat;

	RETURN resultat;
END$$

DROP FUNCTION IF EXISTS `grade`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `grade` (`val` FLOAT) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
	#Routine body goes here...
	declare resultat VARCHAR(255);
 select 
 case when val >=18 and val<=20 
 THEN
      "A+" 
	when val >=16 and val<18 THEN
      "A" 
	when val >=14 and val<16 THEN
      "B+" 
	when val >=13 and val<14 THEN
      "B" 
	when val >=12 and val<13 THEN
      "B-" 
	when val >=11 and val<12 THEN
      "C+" 
	when val >=10 and val<11 THEN
      "C" 
	when val >=9 and val<10 THEN
      "C-" 
	when val >=8 and val<9 THEN
      "D" 
	when val >=6 and val<8 THEN
      "E" 
	when val >=0 and val<6 THEN
      "F" 
 END as grade into resultat;
 
	RETURN resultat;
END$$

DROP FUNCTION IF EXISTS `mgp`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `mgp` (`val` FLOAT) RETURNS DECIMAL(10,1) BEGIN
	#Routine body goes here...
 declare resultat DECIMAL(10,1);
 select 
 (case when val >=18.0 and val<=20.0
 THEN 4.0 
 when val >=16.0 and val<18.0 THEN 3.7
      
	when val >=14.0 and val<16.0 THEN 3.3
	
	when val >=13.0 and val<14.0 THEN 3
	
	when val >=12.0 and val<13.0 THEN 2.7
	
	when val >=11.0 and val<12.0 THEN 2.3
      
	when val >=10.0 and val<11.0 THEN 2.0
   
	when val >=9.0 and val<10.0 THEN 1.7
      
	when val >=8.0 and val<9.0 THEN 1.3
       
	when val >=6.0 and val<8.0 THEN 1.0
      
	when val >=0.0 and val<6.0 THEN 0
      
 END ) into resultat;
 
	RETURN resultat ;

END$$

DROP FUNCTION IF EXISTS `mgp_sem`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `mgp_sem` (`mat` VARCHAR(255), `niv` BIGINT(20), `ans` BIGINT(20), `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here...
	declare resultat float;
	select mgp((SUM(moyenne_ue_etudiant(matricule,enseignement.`code`)*credits)/SUM(credits))- penalites(mat,niv,ans,sem))into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
#and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=mat
and niveau.numero= niv
and classe.niveau=niveau.`code`
and semestre.libelle=sem;
return resultat;

END$$

DROP FUNCTION IF EXISTS `moyenne_ue_etudiant`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `moyenne_ue_etudiant` (`matricule_etudiant` VARCHAR(255), `codeenseignement` BIGINT(20)) RETURNS FLOAT BEGIN

DECLARE resultat float;

select (case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then ROUND(SUM(case when type_evaluation.libelle='Session normale' then 0 ELSE (valeur_note*pourcentage)/100 END),2) when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=0 then ROUND(SUM((valeur_note*pourcentage)/100 ),2)end) into resultat
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
	
END$$

DROP FUNCTION IF EXISTS `moy_sem`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `moy_sem` (`mat` VARCHAR(255), `niv` BIGINT(20), `ans` BIGINT(20), `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here...
	declare resultat float;
	select ((SUM(moyenne_ue_etudiant(matricule,enseignement.`code`)*credits)/SUM(credits))- penalites(mat,niv,ans,sem))into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
#and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=mat
and niveau.numero= niv
and classe.niveau=niveau.`code`
and semestre.libelle=sem;
return resultat;

END$$

DROP FUNCTION IF EXISTS `moy_ue_etud_typ_ev`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `moy_ue_etud_typ_ev` (`matricule_etudiant` VARCHAR(255), `codeenseignement` BIGINT(20)) RETURNS FLOAT BEGIN

DECLARE resultat float;

select ROUND(AVG(valeur_note),2) into resultat
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
and type_evaluation.libelle="Controle continu"
and etudiant.matricule=matricule_etudiant
and enseignement.`code`=codeenseignement
and classe.niveau=niveau.`code`;

	RETURN resultat;
	
END$$

DROP FUNCTION IF EXISTS `penalites`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `penalites` (`mat` VARCHAR(255), `niv` INT, `ans` INT, `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here...
	DECLARE resultat float;
SELECT distinct TRUNCATE((case when (((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1))=0 then 0
	else (((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1)) end),3) into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
#and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=mat
and niveau.numero= niv
and classe.niveau=niveau.`code`
and semestre.libelle=sem;
	RETURN resultat;
END$$

DELIMITER ;

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
) ENGINE=MyISAM AUTO_INCREMENT=355 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `annee_academique`
--

INSERT INTO `annee_academique` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(206, '2017-08-30 22:00:00', '2019-08-02 11:18:09', '2016-08-31 22:00:00', '2019-08-02 11:18:09', 'Année Académique 2016/2017', '', '2122578073', 'ACTIVE', 1, 1),
(352, '2018-08-30 22:00:00', '2019-08-02 11:31:31', '2017-08-31 22:00:00', '2019-08-02 11:31:31', 'Année Académique 2017/2018', '', '-1199522912', 'ACTIVE', 1, 1),
(353, '2019-08-30 22:00:00', '2019-08-02 11:32:44', '2018-08-31 22:00:00', '2019-08-02 11:32:44', 'Année Académique 2018/2019', '', '-1294000977', 'ACTIVE', 1, 1),
(354, '2020-08-30 22:00:00', '2019-08-02 11:33:16', '2019-08-31 22:00:00', '2019-08-02 11:33:16', 'Année Académique 2019/2020', '', '-1341002424', 'ACTIVE', 1, 1);

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
  `numero_table` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `est_inscrit` bigint(20) DEFAULT NULL,
  `note` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `signature` (`signature`) USING BTREE,
  KEY `FK_anonymat_createur` (`createur`) USING BTREE,
  KEY `FK_anonymat_note` (`note`) USING BTREE,
  KEY `FK_anonymat_modificateur` (`modificateur`) USING BTREE,
  KEY `FK_anonymat_est_inscrit` (`est_inscrit`) USING BTREE,
  KEY `FK_anonymat_evaluation` (`evaluation`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
) ENGINE=MyISAM AUTO_INCREMENT=3126 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `candidat`
--

INSERT INTO `candidat` (`code`, `DTYPE`, `date_creation`, `date_modification`, `date_naissance`, `description`, `ecole_origine`, `email`, `libelle`, `nom`, `nom_de_la_mere`, `nom_du_pere`, `prenom`, `profession_de_la_mere`, `profession_du_pere`, `region_origine`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `telephone_de_la_mere`, `telephone_du_pere`, `classe`, `createur`, `modificateur`) VALUES
(3124, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1996-02-02 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'keisper99@gmail.com', NULL, 'TIYOUH  NGONGANG ', 'DOMCHE NGOGAING Carine', 'TIYOUH CHRISTOPHER NGOULAPPE', 'Keisper', '', '', 'OUEST', 'MASCULIN', '-1692746767', 'ACTIVE', 'ACTIVE', 690123155, 696664700, 0, 53, 1, 1),
(3125, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1999-01-31 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'touko.doline@yahoo.fr', NULL, 'TOUKO CHOKOUAFI ', 'CHEMALEU DJINE Fride', 'MOUKAM Timothé Jéhu', 'Doline', '', '', 'OUEST', 'FEMININ', '122886250', 'ACTIVE', 'ACTIVE', 697981605, 699816006, 699871636, 53, 1, 1),
(3122, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:46:27', '1994-01-29 23:00:00', '', 'LYCEE GENERAL LECLERC', 'lionneltemgoua18@gmail.com', '', 'TEMGOUA NJOUNANG ', 'DIFFO Odette', 'TEMGOUA Appolinaire', 'Cédric Lionnel', '', '', 'OUEST', 'MASCULIN', '1184911240', 'ACTIVE', 'ACTIVE', 683063752, 0, 696785339, 53, 1, 1),
(3123, 'Etudiant', '2019-08-07 14:43:44', '2019-08-12 12:25:24', '2001-04-25 22:00:00', '', 'LYCEE MGR BESSIEUX', 'timamomarion9@gmail.com', '', 'TIMAMO ', 'KANBOUM KAMBA Antoinette', 'TIMAMO SIMO Eugène', 'Viorika Shany Marion', '', '', 'OUEST', 'FEMININ', '3030994', 'ACTIVE', 'ACTIVE', 656499228, 2147483647, 2147483647, 53, 1, 1),
(3121, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1998-06-22 22:00:00', NULL, 'COLLEGE DE LA RETRAITE', 'divine_elvira@yahoo.com', NULL, 'TCHEUTCHOA TCHEUTCHOA ', 'MAYOUMO DEFFO NOEME Chantale', 'TCHEUTCHOA Jean Pierre', 'Divine Elvira', '', '', 'OUEST', 'FEMININ', '-1245198940', 'ACTIVE', 'ACTIVE', 698177440, 699569571, 699924195, 53, 1, 1),
(3120, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:44:21', '1997-07-03 22:00:00', '', 'COLLEGE VOGT', 'songcedriccena@yahoo.fr', '', 'SONG ', 'BAHANAG SONG Aimée Téclaire', 'ONANA ABENG Lazare', 'Cédric Junior', '', '', 'CENTRE', 'MASCULIN', '1916394346', 'ACTIVE', 'ACTIVE', 698786691, 698312070, 699808633, 53, 1, 1),
(3119, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:52:48', '1998-04-02 22:00:00', '', 'COLLEGE VOGT', 'georgesnyemb37@gmail.com', '', 'SALLA NYEMB ', 'SALLA BOUAMBO Josette', '', 'Georges Olivier', '', '', 'SUD', 'MASCULIN', '-569926006', 'ACTIVE', 'ACTIVE', 699849761, 699849761, 699849761, 53, 1, 1),
(3118, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1996-10-13 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'franckbryan0@gmail.com', NULL, 'ONANA TSOGO ', 'NDONGO Lucie', 'ONANA Barnabé Paul', 'Franck Bryan', '', '', 'SUD', 'MASCULIN', '743358084', 'ACTIVE', 'ACTIVE', 697628538, 677577751, 677785786, 53, 1, 1),
(3117, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-01-25 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'bricemichael808@gmail.com', NULL, 'NZOKOU FONGANG ', 'MAFOHK Régine', 'FONGANG', 'Brice Michael', '', '', 'OUEST', 'MASCULIN', '-1263493348', 'ACTIVE', 'ACTIVE', 695563032, 670601545, 677487105, 53, 1, 1),
(3116, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 15:05:07', '1997-05-10 22:00:00', '', 'COLLEGE MARIE ALBERT', '', '', 'NZIKO SIMO  ', '', 'MAKEMTA SIMO Odette', 'Yvan  Arthur', '', 'SIMO Gilles', 'OUEST', 'MASCULIN', '-223346564', 'ACTIVE', 'ACTIVE', 693222744, 699302414, 699302414, 53, 1, 1),
(3115, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-06-25 22:00:00', NULL, 'UNIVERSITE DE BUEA', 'oyanestahnn@gmail.com', NULL, 'NSOLA OYANE ', 'NYANGONO NKOULOU Ernestine Yvonne', 'OYANE NSOLA JOSUE', 'Rick Stahnn Lewis', '', '', 'SUD', 'MASCULIN', '1743636595', 'ACTIVE', 'ACTIVE', 694194638, 677589196, 677616535, 53, 1, 1),
(3114, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-06-06 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE 1 (ICT4D)', 'djeuchombrice13@gmail.com', NULL, 'NOUTCHEDJAM DJEUCHOM ', 'SIAKAM PEPOUBA MARLINNE', 'DJEUCHOM PASCAL', 'Thomas', '', '', 'OUEST', 'MASCULIN', '-387188878', 'ACTIVE', 'ACTIVE', 696899526, 677000375, 677792655, 53, 1, 1),
(3112, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1996-03-25 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'ndoumouandre@gmail.com', NULL, 'NDOUMOU FOUDA MBALLA ', 'BELOMO OBONO Joséphine', 'NDOUMOU André', 'André', '', '', 'CENTRE', 'MASCULIN', '-844093074', 'ACTIVE', 'ACTIVE', 651069554, 670094999, 670910402, 53, 1, 1),
(3113, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1994-02-10 23:00:00', NULL, 'UNIVERSITE DE BUEA', 'nonoivan3@gmail.com', NULL, 'NGUEPNANG NONO ', 'DJAMPOU Madeleine', 'NGANYO Michel', 'Ivan-Dasny', '', '', 'OUEST', 'MASCULIN', '-1138459545', 'ACTIVE', 'ACTIVE', 690614621, 673793205, 242020471, 53, 1, 1),
(3111, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '2000-06-21 22:00:00', NULL, 'LYCEE BILINGUE DE MENDONG', 'momokarel2@gmail.com', NULL, 'MOMO KOUDJOU ', 'DONGMO MOMO MARIE MADOUCE', 'KOUDJOU TSAFACK Elie', 'Karel Orly', '', '', 'OUEST', 'FEMININ', '-1768818010', 'ACTIVE', 'ACTIVE', 655269592, 677810123, 677810123, 53, 1, 1),
(3110, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '2000-01-13 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'mfomenndafeu@yahoo.fr', NULL, 'MFOMEN NDAFEU ', 'KOUAMOU TCHIENGUE', 'NDAFEU Célesstin', 'Elvira Ruth', '', '', 'OUEST', 'FEMININ', '2117244794', 'ACTIVE', 'ACTIVE', 690150916, 2147483647, 675946548, 53, 1, 1),
(3108, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1998-08-16 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'mbouendenorman@gmail.com', NULL, 'MBOUENDE TCHANDJA ', 'TCHANDJA TIAKO Chantal', 'MBOUENDE SIEWE André', 'Norman Frejus', '', '', 'OUEST', 'MASCULIN', '1578210021', 'ACTIVE', 'ACTIVE', 673391176, 699298367, 699879606, 53, 1, 1),
(3109, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:43', '1999-12-31 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'jordanmelong@yahoo.com', NULL, 'MELONG FOUDJI ', 'TIOGONO Thérèse', 'MELONG Simon', 'Winnie Jordane', '', '', 'OUEST', 'FEMININ', '-1973141086', 'ACTIVE', 'ACTIVE', 691737831, 699008519, 696296021, 53, 1, 1),
(3107, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1997-01-19 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE 1 (ICT4D)', 'francklowe547@gmail.com', NULL, 'LOWE NANMEGNE ', 'TCHONANG MBOUPDA RACHEL', 'NANMEGNE JEAN CLAUDE', 'Giresse Franck', '', '', 'OUEST', 'MASCULIN', '-480613223', 'ACTIVE', 'ACTIVE', 690582022, 699460982, 697768481, 53, 1, 1),
(3106, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '2000-04-20 22:00:00', NULL, 'LYCEE CLASSIQUE DE BAFOUSSAM', 'aclotchouang@gmail.com', NULL, 'LOTCHOUANG KOUSSEU ', 'NONO Marie Caroline', 'LOTCHOUANG Etienne', 'Ange Cécile', '', '', 'OUEST', 'FEMININ', '870569717', 'ACTIVE', 'ACTIVE', 677947592, 699848953, 677947592, 53, 1, 1),
(3105, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1997-04-29 22:00:00', NULL, 'COLLEGE FLEMING', 'lansivalerois@gmail.com', NULL, 'LANSI DJOUMALE  ', 'KWEMOU Yvonne', 'DJOUMALE TOWA Pierre Paul', 'Valère', '', '', 'Ouest', 'MASCULIN', '885977549', 'ACTIVE', 'ACTIVE', 695823451, 67762877, 677623877, 53, 1, 1),
(3102, 'Etudiant', '2019-08-07 14:43:41', '2019-08-07 14:44:48', '2000-01-27 23:00:00', '', 'NESCAS', 'channeldonkeng@gmail.com', '', 'DONKENG DONFACK', 'DJOUKAM Thérèse', 'DONKENG Augustin', 'Channel Laetitia', '', '', 'OUEST', 'FEMININ', '-26725379', 'ACTIVE', 'ACTIVE', 656307859, 677640961, 677607064, 53, 1, 1),
(3103, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1996-11-05 23:00:00', NULL, 'COLLEGE SAINT BENOIT', 'fodjomaximejr@gmail.com', NULL, 'FODJO ', 'KAMTCHUANT Clotilde', 'FUMTHUM', 'Maxime Junior', '', '', 'OUEST', 'MASCULIN', '288952523', 'ACTIVE', 'ACTIVE', 656531071, 677454346, 677882493, 53, 1, 1),
(3104, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1999-07-11 22:00:00', NULL, 'COLLEGE EXCELLENCE', 'anthonyfouda@gmail.com', NULL, 'FOUDA ', 'GOURIOU Irène Floberte', 'DABBAGH MAROUANE SALAH', 'Hyacinthe Anthony', '', '', 'BRETAGNE', 'MASCULIN', '-1717650719', 'ACTIVE', 'ACTIVE', 691063708, 699824737, 699934699, 53, 1, 1),
(3101, 'Etudiant', '2019-08-07 14:43:41', '2019-08-07 14:43:41', '1997-05-20 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE (ICT4D)', 'constantinnitcheu6@gmail.com', NULL, 'CHEUTCHOUA NITCHEU ', 'TCHANGA JACQUELINE', 'NITCHEU JEAN BAPTISTE', 'Constantin', '', '', 'OUEST', 'MASCULIN', '-1152360690', 'ACTIVE', 'ACTIVE', 695585034, 674000847, 694160102, 53, 1, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=206 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `classe`
--

INSERT INTO `classe` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`, `niveau`, `specialite`) VALUES
(52, '2019-08-02 10:54:24', '2019-08-02 10:54:24', '', 'LIC 1', '-2062447409', 'ACTIVE', 1, 1, 7, 4),
(53, '2019-08-02 10:55:08', '2019-08-02 10:55:08', '', 'LIC 2', '-1690386618', 'ACTIVE', 1, 1, 8, 4),
(55, '2019-08-02 10:55:23', '2019-08-02 10:55:23', '', 'LIC 3', '-1528531123', 'ACTIVE', 1, 1, 9, 4),
(58, '2019-08-02 10:59:28', '2019-08-02 10:59:28', '', 'ING 1A', '-2012567747', 'ACTIVE', 1, 1, 7, 57),
(60, '2019-08-02 11:00:29', '2019-08-02 11:00:29', '', 'ING 2', '-1640506956', 'ACTIVE', 1, 1, 8, 57),
(202, '2019-08-02 11:14:10', '2019-08-02 11:14:10', '', 'ING 1B', '569441626', 'ACTIVE', 1, 1, 7, 57),
(203, '2019-08-02 11:14:42', '2019-08-02 11:14:42', '', 'ING 3', '1103357912', 'ACTIVE', 1, 1, 9, 57),
(204, '2019-08-02 11:14:55', '2019-08-02 11:14:55', '', 'ING 4', '2082411475', 'ACTIVE', 1, 1, 10, 5),
(205, '2019-08-02 11:14:59', '2019-08-02 11:14:59', '', 'ING 4', '2083807250', 'ACTIVE', 1, 1, 10, 6);

-- --------------------------------------------------------

--
-- Structure de la table `discipline`
--

DROP TABLE IF EXISTS `discipline`;
CREATE TABLE IF NOT EXISTS `discipline` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `date_retard` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `heure_justifie` int(11) DEFAULT NULL,
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
) ENGINE=MyISAM AUTO_INCREMENT=2653 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
) ENGINE=MyISAM AUTO_INCREMENT=580 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
) ENGINE=MyISAM AUTO_INCREMENT=6135 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `enseignement`
--

INSERT INTO `enseignement` (`code`, `date_creation`, `date_modification`, `description`, `heures_de_cours`, `libelle`, `programme_de_cours`, `signature`, `statut_vie`, `createur`, `modificateur`, `semestre`, `ue`) VALUES
(6134, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Sagesse et science2', 40, 'Sagesse et science2', '', '-1326040992', 'ACTIVE', 1, 1, 706, 6047),
(6130, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Enterprise Resource Planning (ERP)', 120, 'Enterprise Resource Planning (ERP)', '', '956227343', 'ACTIVE', 1, 1, 706, 6043),
(6131, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Projet Tutoré', 120, 'Projet Tutoré', '', '-2131668215', 'ACTIVE', 1, 1, 706, 6044),
(6132, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Conception et Développement d’applications pour mobiles', 120, 'Conception et Développement d’applications pour mobiles', '', '-556229801', 'ACTIVE', 1, 1, 706, 6045),
(6133, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Stage Professionnel', 300, 'Stage Professionnel', '', '1838194151', 'ACTIVE', 1, 1, 706, 6046),
(6128, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'JEE(Programmation par Objets avancée)', 120, 'JEE(Programmation par Objets avancée)', '', '-387854165', 'ACTIVE', 1, 1, 706, 6041),
(6129, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Technologie.NET', 120, 'Technologie.NET', '', '222950708', 'ACTIVE', 1, 1, 706, 6042),
(6127, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Sagesse et science1', 15, 'Sagesse et science1', '', '1946406185', 'ACTIVE', 1, 1, 705, 6040),
(6126, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Anglais pratique', 30, 'Anglais pratique', '', '841587639', 'ACTIVE', 1, 1, 705, 6039),
(6125, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Fondamentaux de la communication', 60, 'Fondamentaux de la communication', '', '1707381474', 'ACTIVE', 1, 1, 705, 6038),
(6124, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Marketing Informatique', 60, 'Marketing Informatique', '', '1163614031', 'ACTIVE', 1, 1, 705, 6037),
(6121, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Sécurité avancée des réseaux et systèmes', 120, 'Sécurité avancée des réseaux et systèmes', '', '-1853321984', 'ACTIVE', 1, 1, 705, 6034),
(6123, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Ateliers de création d\'entreprise', 60, 'Ateliers de création d\'entreprise', '', '-1668803468', 'ACTIVE', 1, 1, 705, 6036),
(6122, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Gestion des Projets informatique', 120, 'Gestion des Projets informatique', '', '-993404769', 'ACTIVE', 1, 1, 705, 6035),
(6120, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Apprendre a manipuler les grosses quantites de donnees', 120, 'Introduction au Big Data', '', '1327014086', 'ACTIVE', 1, 1, 705, 6033),
(6116, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Stage qui mettra en exergue nos competences techniques', 1056, 'Stage Technique', '', '-1495202281', 'ACTIVE', 1, 1, 706, 6029),
(6117, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Acquerir les notions avancees de bases des bases de donnees', 120, 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '', '2012622025', 'ACTIVE', 1, 1, 705, 6030),
(6118, '2019-08-12 14:03:16', '2019-08-12 14:03:16', '', 120, 'Recherche opérationnelle et aide à la décision', '', '-1076840889', 'ACTIVE', 1, 1, 705, 6031),
(6119, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Avoir les notons de la notion de genie logiciel', 120, 'Ingénierie du Génie Logiciel', '', '505676216', 'ACTIVE', 1, 1, 705, 6032),
(6115, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'developper l\'ethique', 60, 'Éthique et Philosophie', '', '-169255963', 'ACTIVE', 1, 1, 706, 6028),
(6114, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'anglais niveau B2', 60, 'Anglais Niveau pratique B2', '', '361204376', 'ACTIVE', 1, 1, 706, 6027),
(6113, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'projet effectue en groupe pour la realisation d\'une application qui resous un probleme reel', 90, 'Projets tutorés', '', '-36618993', 'ACTIVE', 1, 1, 706, 6026),
(6112, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Avoir les notions de bases de ;a securite informatiques', 120, 'Introduction à la sécurité informatique', '', '-1437962389', 'ACTIVE', 1, 1, 706, 6025),
(6111, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser les ruages de l\'economie numerique', 90, 'économie numérique', '', '2045438485', 'ACTIVE', 1, 1, 706, 6024),
(6110, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'environnement comptable de l\'entreprise ', 120, 'L\'entreprise et la gestion, environnement comptable, financier', '', '620315639', 'ACTIVE', 1, 1, 706, 6023),
(6109, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser un langage sur web', 120, 'Programmation Web II', '', '415898654', 'ACTIVE', 1, 1, 706, 6022),
(6108, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'algebre 2', 120, 'Algèbre linéaire II', '', '-313492623', 'ACTIVE', 1, 1, 706, 6021),
(6107, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Appliquer la POO sur le c++', 120, 'Langage C++ et POO', '', '-1485899204', 'ACTIVE', 1, 1, 706, 6020),
(6106, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Developper l\'ethique de travail', 30, 'Ethique et Développement    ', '', '-821028434', 'ACTIVE', 1, 1, 705, 6019),
(6105, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'anglais du niveau B1/B2', 60, 'Anglais niveau pratique B1/B2', '', '-844979566', 'ACTIVE', 1, 1, 705, 6018),
(6102, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Acquerir les notions en bases de donnees', 120, 'Introduction aux Base de données', '', '291698588', 'ACTIVE', 1, 1, 705, 6015),
(6103, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Acquerir les notions de bases de reseaux', 120, 'Introduction aux Réseaux informatiques', '', '2021365009', 'ACTIVE', 1, 1, 705, 6016),
(6104, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Avoir les bases de Linux', 90, 'Systèmes d\'exploitation', '', '-1563532841', 'ACTIVE', 1, 1, 705, 6017),
(6101, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'notion avancee en Programmation Oriente Objet', 120, 'Programmation Orientée Objet II', '', '-804103765', 'ACTIVE', 1, 1, 705, 6014),
(6069, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Maitriser les bases de l\'algebre ', 120, 'Algèbre linaire I', '', '705344848', 'ACTIVE', 1, 1, 705, 6013),
(6068, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Maitriser la modelisation UML', 120, 'modélisation des Systèmes d\'Information(UML)', '', '465629959', 'ACTIVE', 1, 1, 705, 6012),
(6067, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Rendre nos algorithmes efficient', 120, 'Algorithmique et Complexité', '', '-60340711', 'ACTIVE', 1, 1, 705, 6011),
(6066, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Se familiariser avec le monde de l\'emploi', 528, 'Stage découverte de l’entreprise', '', '617100803', 'ACTIVE', 1, 1, 706, 6010),
(6065, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Developper l\'ethique', 30, 'Réflexion Humaine 2', '', '-620189480', 'ACTIVE', 1, 1, 706, 6009),
(6064, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Pouvoir bien s\'exprimer dans differentes situations en anglais', 60, 'Anglais niveau pratique B1', '', '1938215526', 'ACTIVE', 1, 1, 706, 6008),
(6063, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Maitriser les ruage de la communication', 60, 'Communication Orale, Ecrite et audio Visual', '', '-294274063', 'ACTIVE', 1, 1, 706, 6007),
(6060, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Notions avancee d\'algorithmique', 120, 'Algorithmique et Structure de données I', '', '1993472658', 'ACTIVE', 1, 1, 706, 6004),
(6061, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'notions en logique mathematique', 120, 'Mathématiques discrètes II', '', '882131609', 'ACTIVE', 1, 1, 706, 6005),
(6062, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'maitriser l\'algebre de bool', 60, 'Logique pour l\'Informatique', '', '-2100235076', 'ACTIVE', 1, 1, 706, 6006),
(6059, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Apprendre les bases de l\'analye Merise', 120, 'Introduction à l\'Analyse Merise', '', '-1772693757', 'ACTIVE', 1, 1, 706, 6003),
(6055, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Etre capable de parler et bien ecrire l\'Anglais', 60, 'Anglais Remise à niveau A2', '', '-463091889', 'ACTIVE', 1, 1, 705, 5958),
(6056, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Developper l\'ethique', 30, 'Réflexion Humaine1', '', '-1246344041', 'ACTIVE', 1, 1, 705, 5959),
(6058, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Apprendre les bases du langage C', 150, 'Initiation à la programmation C', '', '192266185', 'ACTIVE', 1, 1, 706, 6002),
(6057, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Apprendre les bases de l\'oriente objet', 180, 'Initiation Programmation orientée objet I', '', '1401240202', 'ACTIVE', 1, 1, 706, 6001),
(6053, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'familiariser avec les notions de maths propres a l\'informatique', 150, 'Mathématiques pour l\'informatique', '', '-1074589762', 'ACTIVE', 1, 1, 705, 5956),
(6054, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Acquerir la bonne logique informatique', 120, 'Mathématiques discrètes I', '', '743198437', 'ACTIVE', 1, 1, 705, 5957),
(6051, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Connaitre les enjeux de l\'econoimie numerique ', 60, 'Enjeux de l’économie Numérique', '', '-148279227', 'ACTIVE', 1, 1, 705, 5954),
(6052, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Acquerir les notions de baeses de l\'algorithme', 120, 'Introduction aux algorithmes', '', '1598067271', 'ACTIVE', 1, 1, 705, 5955),
(6049, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Connaitre les composants de l\'ordinateur', 120, 'Architecture des ordinateurs', '', '1743475007', 'ACTIVE', 1, 1, 705, 5952),
(6050, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Les bases du html,css et javascript', 120, 'Programmation Web I', '', '-1155753187', 'ACTIVE', 1, 1, 705, 5953),
(6048, '2019-08-12 14:03:10', '2019-08-12 14:03:10', 'Maitriser les bases du systeme d\'information', 120, 'Introduction aux systèmes d\'information', '', '1123851998', 'ACTIVE', 1, 1, 705, 5951);

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
) ENGINE=MyISAM AUTO_INCREMENT=6873 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `est_inscrit`
--

INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(6867, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF233', '', '1121702569', 'VALIDE', 'ACTIVE', 3125, 1, 6101, 1),
(6869, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF236', '', '-914086682', 'VALIDE', 'ACTIVE', 3125, 1, 6103, 1),
(6868, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF235', '', '244098679', 'VALIDE', 'ACTIVE', 3125, 1, 6102, 1),
(6866, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'MAT231', '', '-894217291', 'VALIDE', 'ACTIVE', 3125, 1, 6069, 1),
(6865, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'MAT241', '', '-375810832', 'VALIDE', 'ACTIVE', 3125, 1, 6108, 1),
(6864, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF232', '', '-1005319155', 'VALIDE', 'ACTIVE', 3125, 1, 6068, 1),
(6863, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF231', '', '741049877', 'VALIDE', 'ACTIVE', 3125, 1, 6067, 1),
(6861, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF243', '', '451301122', 'VALIDE', 'ACTIVE', 3125, 1, 6112, 1),
(6862, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'IN245', '', '-111094543', 'VALIDE', 'ACTIVE', 3125, 1, 6113, 1),
(6860, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF244', '', '-1179496014', 'VALIDE', 'ACTIVE', 3125, 1, 6111, 1),
(6859, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ENV241', '', '-613604153', 'VALIDE', 'ACTIVE', 3125, 1, 6110, 1),
(6858, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'STG241', '', '46954373', 'VALIDE', 'ACTIVE', 3125, 1, 6116, 1),
(6857, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ETH231', '', '468141', 'VALIDE', 'ACTIVE', 3125, 1, 6106, 1),
(6856, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ANG241', '', '762676994', 'VALIDE', 'ACTIVE', 3125, 1, 6114, 1),
(6855, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF242', '', '-2048936625', 'VALIDE', 'ACTIVE', 3125, 1, 6109, 1),
(6854, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF241', '', '-2083778527', 'VALIDE', 'ACTIVE', 3125, 1, 6107, 1),
(6853, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ETH241', '', '-1760756715', 'VALIDE', 'ACTIVE', 3124, 1, 6115, 1),
(6852, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ANG231', '', '1874475196', 'VALIDE', 'ACTIVE', 3124, 1, 6105, 1),
(6848, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF233', '', '-1751589750', 'VALIDE', 'ACTIVE', 3124, 1, 6101, 1),
(6849, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF235', '', '1968897081', 'VALIDE', 'ACTIVE', 3124, 1, 6102, 1),
(6850, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF236', '', '-390759310', 'VALIDE', 'ACTIVE', 3124, 1, 6103, 1),
(6851, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF234', '', '-500978005', 'VALIDE', 'ACTIVE', 3124, 1, 6104, 1),
(6847, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'MAT231', '', '787592698', 'VALIDE', 'ACTIVE', 3124, 1, 6069, 1),
(6846, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'MAT241', '', '502446514', 'VALIDE', 'ACTIVE', 3124, 1, 6108, 1),
(6845, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF232', '', '-364049214', 'VALIDE', 'ACTIVE', 3124, 1, 6068, 1),
(6844, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF231', '', '1068173723', 'VALIDE', 'ACTIVE', 3124, 1, 6067, 1),
(6843, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'IN245', '', '784799075', 'VALIDE', 'ACTIVE', 3124, 1, 6113, 1),
(6842, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF243', '', '1347194740', 'VALIDE', 'ACTIVE', 3124, 1, 6112, 1),
(6841, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF244', '', '248792565', 'VALIDE', 'ACTIVE', 3124, 1, 6111, 1),
(6840, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ENV241', '', '851059237', 'VALIDE', 'ACTIVE', 3124, 1, 6110, 1),
(6838, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ETH231', '', '602056470', 'VALIDE', 'ACTIVE', 3124, 1, 6106, 1),
(6839, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'STG241', '', '947257059', 'VALIDE', 'ACTIVE', 3124, 1, 6116, 1),
(6837, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ANG241', '', '1129482452', 'VALIDE', 'ACTIVE', 3124, 1, 6114, 1),
(6836, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF242', '', '-1146429405', 'VALIDE', 'ACTIVE', 3124, 1, 6109, 1),
(6835, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF241', '', '-1152612365', 'VALIDE', 'ACTIVE', 3124, 1, 6107, 1),
(6832, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF234', '', '245785217', 'VALIDE', 'ACTIVE', 3123, 1, 6104, 1),
(6834, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'ETH241', '', '-458450925', 'VALIDE', 'ACTIVE', 3123, 1, 6115, 1),
(6833, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'ANG231', '', '-1122595378', 'VALIDE', 'ACTIVE', 3123, 1, 6105, 1),
(6831, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF236', '', '149879983', 'VALIDE', 'ACTIVE', 3123, 1, 6103, 1),
(6830, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF235', '', '-1820703466', 'VALIDE', 'ACTIVE', 3123, 1, 6102, 1),
(6829, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF233', '', '-929872372', 'VALIDE', 'ACTIVE', 3123, 1, 6101, 1),
(6828, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'MAT231', '', '1394368011', 'VALIDE', 'ACTIVE', 3123, 1, 6069, 1),
(6827, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'MAT241', '', '1089381021', 'VALIDE', 'ACTIVE', 3123, 1, 6108, 1),
(6826, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF232', '', '45420306', 'VALIDE', 'ACTIVE', 3123, 1, 6068, 1),
(6825, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF231', '', '2111446768', 'VALIDE', 'ACTIVE', 3123, 1, 6067, 1),
(6822, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF244', '', '254832363', 'VALIDE', 'ACTIVE', 3123, 1, 6111, 1),
(6824, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'IN245', '', '1230643406', 'VALIDE', 'ACTIVE', 3123, 1, 6113, 1),
(6823, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF243', '', '994997763', 'VALIDE', 'ACTIVE', 3123, 1, 6112, 1),
(6821, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ENV241', '', '655384174', 'VALIDE', 'ACTIVE', 3123, 1, 6110, 1),
(6820, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'STG241', '', '1638906931', 'VALIDE', 'ACTIVE', 3123, 1, 6116, 1),
(6819, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ETH231', '', '1340001556', 'VALIDE', 'ACTIVE', 3123, 1, 6106, 1),
(6818, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ANG241', '', '1279919227', 'VALIDE', 'ACTIVE', 3123, 1, 6114, 1),
(6817, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF242', '', '-1497524115', 'VALIDE', 'ACTIVE', 3123, 1, 6109, 1),
(6815, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'ETH241', '', '-1871412776', 'VALIDE', 'ACTIVE', 3122, 1, 6115, 1),
(6816, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF241', '', '-1184049645', 'VALIDE', 'ACTIVE', 3123, 1, 6107, 1),
(6814, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'ANG231', '', '1456286642', 'VALIDE', 'ACTIVE', 3122, 1, 6105, 1),
(6813, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF234', '', '-1424004845', 'VALIDE', 'ACTIVE', 3122, 1, 6104, 1),
(6812, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF236', '', '-1567307560', 'VALIDE', 'ACTIVE', 3122, 1, 6103, 1),
(6811, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF235', '', '499145809', 'VALIDE', 'ACTIVE', 3122, 1, 6102, 1),
(6810, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF233', '', '1654520983', 'VALIDE', 'ACTIVE', 3122, 1, 6101, 1),
(6808, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'MAT241', '', '-580409041', 'VALIDE', 'ACTIVE', 3122, 1, 6108, 1),
(6809, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'MAT231', '', '-267706182', 'VALIDE', 'ACTIVE', 3122, 1, 6069, 1),
(6807, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF232', '', '-1701528446', 'VALIDE', 'ACTIVE', 3122, 1, 6068, 1),
(6806, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF231', '', '399770560', 'VALIDE', 'ACTIVE', 3122, 1, 6067, 1),
(6803, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF244', '', '-1451332510', 'VALIDE', 'ACTIVE', 3122, 1, 6111, 1),
(6805, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'IN245', '', '-207670586', 'VALIDE', 'ACTIVE', 3122, 1, 6113, 1),
(6804, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF243', '', '157419286', 'VALIDE', 'ACTIVE', 3122, 1, 6112, 1),
(6802, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ENV241', '', '-1048576165', 'VALIDE', 'ACTIVE', 3122, 1, 6110, 1),
(6801, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'STG241', '', '141070521', 'VALIDE', 'ACTIVE', 3122, 1, 6116, 1),
(6800, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ETH231', '', '-381595055', 'VALIDE', 'ACTIVE', 3122, 1, 6106, 1),
(6799, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ANG241', '', '-398688971', 'VALIDE', 'ACTIVE', 3122, 1, 6114, 1),
(6798, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF242', '', '1141982590', 'VALIDE', 'ACTIVE', 3122, 1, 6109, 1),
(6797, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF241', '', '1492934138', 'VALIDE', 'ACTIVE', 3122, 1, 6107, 1),
(6796, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'ETH241', '', '1081331684', 'VALIDE', 'ACTIVE', 3121, 1, 6115, 1),
(6795, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'ANG231', '', '157052219', 'VALIDE', 'ACTIVE', 3121, 1, 6105, 1),
(6793, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF236', '', '-1413754077', 'VALIDE', 'ACTIVE', 3121, 1, 6103, 1),
(6794, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF234', '', '-1896539018', 'VALIDE', 'ACTIVE', 3121, 1, 6104, 1),
(6791, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF233', '', '467717794', 'VALIDE', 'ACTIVE', 3121, 1, 6101, 1),
(6792, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF235', '', '407996018', 'VALIDE', 'ACTIVE', 3121, 1, 6102, 1),
(6790, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'MAT231', '', '-1479861512', 'VALIDE', 'ACTIVE', 3121, 1, 6069, 1),
(6789, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'MAT241', '', '-854535154', 'VALIDE', 'ACTIVE', 3121, 1, 6108, 1),
(6787, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF231', '', '-971111218', 'VALIDE', 'ACTIVE', 3121, 1, 6067, 1),
(6788, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF232', '', '1772588305', 'VALIDE', 'ACTIVE', 3121, 1, 6068, 1),
(6786, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'IN245', '', '-1172918108', 'VALIDE', 'ACTIVE', 3121, 1, 6113, 1),
(6785, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF243', '', '-1606971811', 'VALIDE', 'ACTIVE', 3121, 1, 6112, 1),
(6784, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF244', '', '1665649733', 'VALIDE', 'ACTIVE', 3121, 1, 6111, 1),
(6783, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ENV241', '', '-1639052907', 'VALIDE', 'ACTIVE', 3121, 1, 6110, 1),
(6781, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ETH231', '', '2063004318', 'VALIDE', 'ACTIVE', 3121, 1, 6106, 1),
(6782, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'STG241', '', '-935505968', 'VALIDE', 'ACTIVE', 3121, 1, 6116, 1),
(6780, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ANG241', '', '-1125846821', 'VALIDE', 'ACTIVE', 3121, 1, 6114, 1),
(6779, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'INF242', '', '458915420', 'VALIDE', 'ACTIVE', 3121, 1, 6109, 1),
(6778, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'INF241', '', '-292400032', 'VALIDE', 'ACTIVE', 3121, 1, 6107, 1),
(6777, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'ETH241', '', '1706023354', 'VALIDE', 'ACTIVE', 3120, 1, 6115, 1),
(6776, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'ANG231', '', '797175627', 'VALIDE', 'ACTIVE', 3120, 1, 6105, 1),
(6773, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF235', '', '91351670', 'VALIDE', 'ACTIVE', 3120, 1, 6102, 1),
(6775, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF234', '', '-1965173291', 'VALIDE', 'ACTIVE', 3120, 1, 6104, 1),
(6774, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF236', '', '-1755750566', 'VALIDE', 'ACTIVE', 3120, 1, 6103, 1),
(6772, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF233', '', '237050272', 'VALIDE', 'ACTIVE', 3120, 1, 6101, 1),
(6771, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'MAT231', '', '-1382053468', 'VALIDE', 'ACTIVE', 3120, 1, 6069, 1),
(6769, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'INF232', '', '1404137408', 'VALIDE', 'ACTIVE', 3120, 1, 6068, 1),
(6770, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'MAT241', '', '-1054339200', 'VALIDE', 'ACTIVE', 3120, 1, 6108, 1),
(6768, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'INF231', '', '-928416524', 'VALIDE', 'ACTIVE', 3120, 1, 6067, 1),
(6767, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'IN245', '', '2031613406', 'VALIDE', 'ACTIVE', 3120, 1, 6113, 1),
(6766, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'INF243', '', '-1541129510', 'VALIDE', 'ACTIVE', 3120, 1, 6112, 1),
(6765, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'INF244', '', '1018325285', 'VALIDE', 'ACTIVE', 3120, 1, 6111, 1),
(6764, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'ENV241', '', '1857579362', 'VALIDE', 'ACTIVE', 3120, 1, 6110, 1),
(6763, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'STG241', '', '1900868368', 'VALIDE', 'ACTIVE', 3120, 1, 6116, 1),
(6762, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ETH231', '', '1561179114', 'VALIDE', 'ACTIVE', 3120, 1, 6106, 1),
(6761, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ANG241', '', '1382051949', 'VALIDE', 'ACTIVE', 3120, 1, 6114, 1),
(6760, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF242', '', '-1129745046', 'VALIDE', 'ACTIVE', 3120, 1, 6109, 1),
(6758, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ETH241', '', '-366997058', 'VALIDE', 'ACTIVE', 3119, 1, 6115, 1),
(6759, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF241', '', '-850440853', 'VALIDE', 'ACTIVE', 3120, 1, 6107, 1),
(6756, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF234', '', '853100040', 'VALIDE', 'ACTIVE', 3119, 1, 6104, 1),
(6757, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ANG231', '', '-1122629672', 'VALIDE', 'ACTIVE', 3119, 1, 6105, 1),
(6755, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF236', '', '109061810', 'VALIDE', 'ACTIVE', 3119, 1, 6103, 1),
(6754, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF235', '', '2101663290', 'VALIDE', 'ACTIVE', 3119, 1, 6102, 1),
(6753, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF233', '', '-1343256791', 'VALIDE', 'ACTIVE', 3119, 1, 6101, 1),
(6752, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'MAT231', '', '934688378', 'VALIDE', 'ACTIVE', 3119, 1, 6069, 1),
(6751, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'MAT241', '', '1453094837', 'VALIDE', 'ACTIVE', 3119, 1, 6108, 1),
(6750, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF232', '', '894131602', 'VALIDE', 'ACTIVE', 3119, 1, 6068, 1),
(6748, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'IN245', '', '1738754199', 'VALIDE', 'ACTIVE', 3119, 1, 6113, 1),
(6749, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF231', '', '-1949874218', 'VALIDE', 'ACTIVE', 3119, 1, 6067, 1),
(6747, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF243', '', '1447995206', 'VALIDE', 'ACTIVE', 3119, 1, 6112, 1),
(6746, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF244', '', '670352728', 'VALIDE', 'ACTIVE', 3119, 1, 6111, 1),
(6745, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ENV241', '', '984927713', 'VALIDE', 'ACTIVE', 3119, 1, 6110, 1),
(6744, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'STG241', '', '-2086222620', 'VALIDE', 'ACTIVE', 3119, 1, 6116, 1),
(6742, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ANG241', '', '-1926042567', 'VALIDE', 'ACTIVE', 3119, 1, 6114, 1),
(6743, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ETH231', '', '1892203029', 'VALIDE', 'ACTIVE', 3119, 1, 6106, 1),
(6741, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF242', '', '-160508538', 'VALIDE', 'ACTIVE', 3119, 1, 6109, 1),
(6739, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ETH241', '', '-1025151613', 'VALIDE', 'ACTIVE', 3118, 1, 6115, 1),
(6740, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF241', '', '-1020948423', 'VALIDE', 'ACTIVE', 3119, 1, 6107, 1),
(6738, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ANG231', '', '-2024385234', 'VALIDE', 'ACTIVE', 3118, 1, 6105, 1),
(6737, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF234', '', '193843218', 'VALIDE', 'ACTIVE', 3118, 1, 6104, 1),
(6736, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF236', '', '575219595', 'VALIDE', 'ACTIVE', 3118, 1, 6103, 1),
(6735, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF235', '', '-1679748740', 'VALIDE', 'ACTIVE', 3118, 1, 6102, 1),
(6734, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF233', '', '-882610341', 'VALIDE', 'ACTIVE', 3118, 1, 6101, 1),
(6731, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF232', '', '180863697', 'VALIDE', 'ACTIVE', 3118, 1, 6068, 1),
(6733, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'MAT231', '', '1399743896', 'VALIDE', 'ACTIVE', 3118, 1, 6069, 1),
(6732, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'MAT241', '', '1902718617', 'VALIDE', 'ACTIVE', 3118, 1, 6108, 1),
(6730, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF231', '', '1923925928', 'VALIDE', 'ACTIVE', 3118, 1, 6067, 1),
(6729, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'IN245', '', '1075088309', 'VALIDE', 'ACTIVE', 3118, 1, 6113, 1),
(6728, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF243', '', '1908641656', 'VALIDE', 'ACTIVE', 3118, 1, 6112, 1),
(6727, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF244', '', '1103442503', 'VALIDE', 'ACTIVE', 3118, 1, 6111, 1),
(6726, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ENV241', '', '1421324289', 'VALIDE', 'ACTIVE', 3118, 1, 6110, 1),
(6725, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'STG241', '', '-1979403877', 'VALIDE', 'ACTIVE', 3118, 1, 6116, 1),
(6724, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ETH231', '', '1185548726', 'VALIDE', 'ACTIVE', 3118, 1, 6106, 1),
(6722, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF242', '', '-861651506', 'VALIDE', 'ACTIVE', 3118, 1, 6109, 1),
(6723, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ANG241', '', '1949962113', 'VALIDE', 'ACTIVE', 3118, 1, 6114, 1),
(6720, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ETH241', '', '355213261', 'VALIDE', 'ACTIVE', 3117, 1, 6115, 1),
(6721, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF241', '', '-894288874', 'VALIDE', 'ACTIVE', 3118, 1, 6107, 1),
(6719, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ANG231', '', '-347510537', 'VALIDE', 'ACTIVE', 3117, 1, 6105, 1),
(6718, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF234', '', '1589639830', 'VALIDE', 'ACTIVE', 3117, 1, 6104, 1),
(6717, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF236', '', '877567343', 'VALIDE', 'ACTIVE', 3117, 1, 6103, 1),
(6716, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF235', '', '-1377400992', 'VALIDE', 'ACTIVE', 3117, 1, 6102, 1),
(6714, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'MAT231', '', '1799091140', 'VALIDE', 'ACTIVE', 3117, 1, 6069, 1),
(6715, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF233', '', '-811738663', 'VALIDE', 'ACTIVE', 3117, 1, 6101, 1),
(6713, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'MAT241', '', '-1703005214', 'VALIDE', 'ACTIVE', 3117, 1, 6108, 1),
(6712, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF232', '', '1669250737', 'VALIDE', 'ACTIVE', 3117, 1, 6068, 1),
(6711, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF231', '', '-1133971204', 'VALIDE', 'ACTIVE', 3117, 1, 6067, 1),
(6709, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF243', '', '-2039887212', 'VALIDE', 'ACTIVE', 3117, 1, 6112, 1),
(6710, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'IN245', '', '-1794321166', 'VALIDE', 'ACTIVE', 3117, 1, 6113, 1),
(6706, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'STG241', '', '-1619738245', 'VALIDE', 'ACTIVE', 3117, 1, 6116, 1),
(6707, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ENV241', '', '1733592440', 'VALIDE', 'ACTIVE', 3117, 1, 6110, 1),
(6708, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF244', '', '1422324256', 'VALIDE', 'ACTIVE', 3117, 1, 6111, 1),
(6705, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ETH231', '', '-1710315157', 'VALIDE', 'ACTIVE', 3117, 1, 6106, 1),
(6704, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ANG241', '', '-954719906', 'VALIDE', 'ACTIVE', 3117, 1, 6114, 1),
(6702, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF241', '', '567643758', 'VALIDE', 'ACTIVE', 3117, 1, 6107, 1),
(6703, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF242', '', '571622184', 'VALIDE', 'ACTIVE', 3117, 1, 6109, 1),
(6701, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ETH241', '', '-744331904', 'VALIDE', 'ACTIVE', 3114, 1, 6115, 1),
(6698, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF234', '', '85531924', 'VALIDE', 'ACTIVE', 3114, 1, 6104, 1),
(6699, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ANG231', '', '-1285053205', 'VALIDE', 'ACTIVE', 3114, 1, 6105, 1),
(6697, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF236', '', '158273541', 'VALIDE', 'ACTIVE', 3114, 1, 6103, 1),
(6696, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF235', '', '1920501218', 'VALIDE', 'ACTIVE', 3114, 1, 6102, 1),
(6695, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF233', '', '-1187125161', 'VALIDE', 'ACTIVE', 3114, 1, 6101, 1),
(6694, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'MAT231', '', '1346545952', 'VALIDE', 'ACTIVE', 3114, 1, 6069, 1),
(6692, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF232', '', '711867263', 'VALIDE', 'ACTIVE', 3114, 1, 6068, 1),
(6693, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'MAT241', '', '1589385661', 'VALIDE', 'ACTIVE', 3114, 1, 6108, 1),
(6691, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF231', '', '1591854433', 'VALIDE', 'ACTIVE', 3114, 1, 6067, 1),
(6690, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'IN245', '', '973390617', 'VALIDE', 'ACTIVE', 3114, 1, 6113, 1),
(6688, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF244', '', '486986122', 'VALIDE', 'ACTIVE', 3114, 1, 6111, 1),
(6689, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF243', '', '1248094595', 'VALIDE', 'ACTIVE', 3114, 1, 6112, 1),
(6687, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ENV241', '', '1359308209', 'VALIDE', 'ACTIVE', 3114, 1, 6110, 1),
(6686, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'STG241', '', '-2049135826', 'VALIDE', 'ACTIVE', 3114, 1, 6116, 1),
(6685, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ETH231', '', '1871971939', 'VALIDE', 'ACTIVE', 3114, 1, 6106, 1),
(6684, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ANG241', '', '-1945171390', 'VALIDE', 'ACTIVE', 3114, 1, 6114, 1),
(6683, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF242', '', '-188455497', 'VALIDE', 'ACTIVE', 3114, 1, 6109, 1),
(6682, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF241', '', '-999293367', 'VALIDE', 'ACTIVE', 3114, 1, 6107, 1),
(6681, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ETH241', '', '1864260562', 'VALIDE', 'ACTIVE', 3116, 1, 6115, 1),
(6680, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ANG231', '', '1110832482', 'VALIDE', 'ACTIVE', 3116, 1, 6105, 1),
(6679, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF234', '', '-964804095', 'VALIDE', 'ACTIVE', 3116, 1, 6104, 1),
(6678, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF236', '', '-582325451', 'VALIDE', 'ACTIVE', 3116, 1, 6103, 1),
(6676, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF233', '', '2009006368', 'VALIDE', 'ACTIVE', 3116, 1, 6101, 1),
(6677, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF235', '', '1447753107', 'VALIDE', 'ACTIVE', 3116, 1, 6102, 1),
(6675, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'MAT231', '', '299516734', 'VALIDE', 'ACTIVE', 3116, 1, 6069, 1),
(6674, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'MAT241', '', '-29720130', 'VALIDE', 'ACTIVE', 3116, 1, 6108, 1),
(6673, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF232', '', '-907238528', 'VALIDE', 'ACTIVE', 3116, 1, 6068, 1),
(6672, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF231', '', '515064006', 'VALIDE', 'ACTIVE', 3116, 1, 6067, 1),
(6668, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ENV241', '', '301256321', 'VALIDE', 'ACTIVE', 3116, 1, 6110, 1),
(6669, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF244', '', '-276760477', 'VALIDE', 'ACTIVE', 3116, 1, 6111, 1),
(6670, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF243', '', '749994343', 'VALIDE', 'ACTIVE', 3116, 1, 6112, 1),
(6671, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'IN245', '', '-96786208', 'VALIDE', 'ACTIVE', 3116, 1, 6113, 1),
(6667, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'STG241', '', '395249609', 'VALIDE', 'ACTIVE', 3116, 1, 6116, 1),
(6666, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ETH231', '', '64378491', 'VALIDE', 'ACTIVE', 3116, 1, 6106, 1),
(6665, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ANG241', '', '549918327', 'VALIDE', 'ACTIVE', 3116, 1, 6114, 1),
(6664, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF242', '', '-1980617207', 'VALIDE', 'ACTIVE', 3116, 1, 6109, 1),
(6663, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF241', '', '-1734381024', 'VALIDE', 'ACTIVE', 3116, 1, 6107, 1),
(6662, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ETH241', '', '-1993674200', 'VALIDE', 'ACTIVE', 3115, 1, 6106, 1),
(6661, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ANG231', '', '-2076402897', 'VALIDE', 'ACTIVE', 3115, 1, 6105, 1),
(6660, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF234', '', '155052759', 'VALIDE', 'ACTIVE', 3115, 1, 6104, 1),
(6659, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF236', '', '-593394539', 'VALIDE', 'ACTIVE', 3115, 1, 6103, 1),
(6658, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF235', '', '1439990820', 'VALIDE', 'ACTIVE', 3115, 1, 6102, 1),
(6657, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF233', '', '2058561965', 'VALIDE', 'ACTIVE', 3115, 1, 6101, 1),
(6656, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'MAT231', '', '634559484', 'VALIDE', 'ACTIVE', 3115, 1, 6069, 1),
(6655, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'MAT241', '', '1141943273', 'VALIDE', 'ACTIVE', 3115, 1, 6108, 1),
(6654, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF232', '', '8698931', 'VALIDE', 'ACTIVE', 3115, 1, 6068, 1),
(6650, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF244', '', '205986051', 'VALIDE', 'ACTIVE', 3115, 1, 6111, 1),
(6651, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF243', '', '687118706', 'VALIDE', 'ACTIVE', 3115, 1, 6112, 1),
(6652, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'IN245', '', '87245963', 'VALIDE', 'ACTIVE', 3115, 1, 6113, 1),
(6653, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF231', '', '927265446', 'VALIDE', 'ACTIVE', 3115, 1, 6067, 1),
(6649, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ENV241', '', '562447182', 'VALIDE', 'ACTIVE', 3115, 1, 6110, 1),
(6648, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'STG241', '', '622270193', 'VALIDE', 'ACTIVE', 3115, 1, 6116, 1),
(6647, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ETH231', '', '101809151', 'VALIDE', 'ACTIVE', 3115, 1, 6106, 1),
(6646, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ANG241', '', '880552009', 'VALIDE', 'ACTIVE', 3115, 1, 6114, 1),
(6643, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'ETH241', '', '1136477796', 'VALIDE', 'ACTIVE', 3113, 1, 6106, 1),
(6644, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF241', '', '-1555860188', 'VALIDE', 'ACTIVE', 3115, 1, 6107, 1),
(6645, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF242', '', '-1285133148', 'VALIDE', 'ACTIVE', 3115, 1, 6109, 1),
(6641, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF234', '', '-620662290', 'VALIDE', 'ACTIVE', 3113, 1, 6104, 1),
(6642, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'ANG231', '', '1140828192', 'VALIDE', 'ACTIVE', 3113, 1, 6105, 1),
(6640, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF236', '', '-741919665', 'VALIDE', 'ACTIVE', 3113, 1, 6103, 1),
(6639, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF235', '', '535310532', 'VALIDE', 'ACTIVE', 3113, 1, 6102, 1),
(6638, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF233', '', '1127427269', 'VALIDE', 'ACTIVE', 3113, 1, 6101, 1),
(6637, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'MAT231', '', '-202882517', 'VALIDE', 'ACTIVE', 3113, 1, 6069, 1),
(6636, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'MAT241', '', '103888678', 'VALIDE', 'ACTIVE', 3113, 1, 6108, 1),
(6635, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF232', '', '-1577182363', 'VALIDE', 'ACTIVE', 3113, 1, 6068, 1),
(6634, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF231', '', '-44653129', 'VALIDE', 'ACTIVE', 3113, 1, 6067, 1),
(6632, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF243', '', '109811717', 'VALIDE', 'ACTIVE', 3113, 1, 6112, 1),
(6633, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'IN245', '', '-258584956', 'VALIDE', 'ACTIVE', 3113, 1, 6113, 1),
(6631, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF244', '', '-1701757207', 'VALIDE', 'ACTIVE', 3113, 1, 6111, 1),
(6630, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'ENV241', '', '-699367614', 'VALIDE', 'ACTIVE', 3113, 1, 6110, 1),
(6629, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'STG241', '', '29531466', 'VALIDE', 'ACTIVE', 3113, 1, 6116, 1),
(6626, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'INF242', '', '538832453', 'VALIDE', 'ACTIVE', 3113, 1, 6109, 1),
(6627, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'ANG241', '', '-146479916', 'VALIDE', 'ACTIVE', 3113, 1, 6114, 1),
(6628, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'ETH231', '', '-1298891287', 'VALIDE', 'ACTIVE', 3113, 1, 6106, 1),
(6625, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'INF241', '', '933874681', 'VALIDE', 'ACTIVE', 3113, 1, 6107, 1),
(6624, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'ETH241', '', '-1255444614', 'VALIDE', 'ACTIVE', 3112, 1, 6115, 1),
(6623, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'ANG231', '', '-1684806196', 'VALIDE', 'ACTIVE', 3112, 1, 6105, 1),
(6622, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'INF234', '', '-29836181', 'VALIDE', 'ACTIVE', 3112, 1, 6104, 1),
(6621, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF236', '', '-781590280', 'VALIDE', 'ACTIVE', 3112, 1, 6103, 1),
(6620, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF235', '', '1475555280', 'VALIDE', 'ACTIVE', 3112, 1, 6102, 1),
(6619, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF233', '', '1459220633', 'VALIDE', 'ACTIVE', 3112, 1, 6101, 1),
(6618, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'MAT231', '', '-317507288', 'VALIDE', 'ACTIVE', 3112, 1, 6069, 1),
(6616, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF232', '', '-1481274137', 'VALIDE', 'ACTIVE', 3112, 1, 6068, 1),
(6617, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'MAT241', '', '250501186', 'VALIDE', 'ACTIVE', 3112, 1, 6108, 1),
(6613, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF243', '', '-87483079', 'VALIDE', 'ACTIVE', 3112, 1, 6112, 1),
(6614, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'IN245', '', '-639958341', 'VALIDE', 'ACTIVE', 3112, 1, 6113, 1),
(6615, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF231', '', '249663157', 'VALIDE', 'ACTIVE', 3112, 1, 6067, 1),
(6611, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ENV241', '', '-24769213', 'VALIDE', 'ACTIVE', 3112, 1, 6110, 1),
(6612, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF244', '', '-591763341', 'VALIDE', 'ACTIVE', 3112, 1, 6111, 1),
(6610, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'STG241', '', '585085031', 'VALIDE', 'ACTIVE', 3112, 1, 6116, 1),
(6609, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ETH231', '', '269645651', 'VALIDE', 'ACTIVE', 3112, 1, 6106, 1),
(6608, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ANG241', '', '229404128', 'VALIDE', 'ACTIVE', 3112, 1, 6114, 1),
(6607, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF242', '', '1735905412', 'VALIDE', 'ACTIVE', 3112, 1, 6109, 1),
(6605, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'ETH241', '', '-202752737', 'VALIDE', 'ACTIVE', 3111, 1, 6115, 1),
(6606, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF241', '', '1715392981', 'VALIDE', 'ACTIVE', 3112, 1, 6107, 1),
(6604, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'ANG231', '', '-1119316333', 'VALIDE', 'ACTIVE', 3111, 1, 6105, 1),
(6603, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF234', '', '266700534', 'VALIDE', 'ACTIVE', 3111, 1, 6104, 1),
(6602, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF236', '', '389044166', 'VALIDE', 'ACTIVE', 3111, 1, 6103, 1),
(6601, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF235', '', '-2073150365', 'VALIDE', 'ACTIVE', 3111, 1, 6102, 1),
(6552, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF233', '', '-1492430127', 'VALIDE', 'ACTIVE', 3111, 1, 6101, 1),
(6551, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'MAT231', '', '826298921', 'VALIDE', 'ACTIVE', 3111, 1, 6069, 1),
(6550, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'MAT241', '', '529027800', 'VALIDE', 'ACTIVE', 3111, 1, 6108, 1),
(6549, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF232', '', '-312115787', 'VALIDE', 'ACTIVE', 3111, 1, 6068, 1),
(6548, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF231', '', '1199470374', 'VALIDE', 'ACTIVE', 3111, 1, 6067, 1),
(6547, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'IN245', '', '913891192', 'VALIDE', 'ACTIVE', 3111, 1, 6113, 1),
(6546, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF243', '', '1249219855', 'VALIDE', 'ACTIVE', 3111, 1, 6112, 1),
(6543, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'STG241', '', '1308927513', 'VALIDE', 'ACTIVE', 3111, 1, 6116, 1),
(6545, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF244', '', '-264736979', 'VALIDE', 'ACTIVE', 3111, 1, 6111, 1),
(6544, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'ENV241', '', '117076293', 'VALIDE', 'ACTIVE', 3111, 1, 6110, 1),
(6542, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ETH231', '', '738864456', 'VALIDE', 'ACTIVE', 3111, 1, 6106, 1),
(6540, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF242', '', '-2003866253', 'VALIDE', 'ACTIVE', 3111, 1, 6109, 1),
(6541, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ANG241', '', '715156938', 'VALIDE', 'ACTIVE', 3111, 1, 6114, 1),
(6539, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF241', '', '-1709130322', 'VALIDE', 'ACTIVE', 3111, 1, 6107, 1),
(6538, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ETH241', '', '641196336', 'VALIDE', 'ACTIVE', 3110, 1, 6115, 1),
(6535, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF236', '', '1612173087', 'VALIDE', 'ACTIVE', 3110, 1, 6103, 1),
(6536, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF234', '', '1164660690', 'VALIDE', 'ACTIVE', 3110, 1, 6104, 1),
(6537, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ANG231', '', '-832012095', 'VALIDE', 'ACTIVE', 3110, 1, 6105, 1),
(6534, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF235', '', '-804828497', 'VALIDE', 'ACTIVE', 3110, 1, 6102, 1),
(6533, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF233', '', '-755027124', 'VALIDE', 'ACTIVE', 3110, 1, 6101, 1),
(6532, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'MAT231', '', '1602281269', 'VALIDE', 'ACTIVE', 3110, 1, 6069, 1),
(6529, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF231', '', '-1932618857', 'VALIDE', 'ACTIVE', 3110, 1, 6067, 1),
(6531, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'MAT241', '', '-1801713322', 'VALIDE', 'ACTIVE', 3110, 1, 6108, 1),
(6530, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF232', '', '1400793511', 'VALIDE', 'ACTIVE', 3110, 1, 6068, 1),
(6528, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'IN245', '', '1515715354', 'VALIDE', 'ACTIVE', 3110, 1, 6113, 1),
(6527, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF243', '', '-1883971643', 'VALIDE', 'ACTIVE', 3110, 1, 6112, 1),
(6526, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF244', '', '1448172319', 'VALIDE', 'ACTIVE', 3110, 1, 6111, 1),
(6525, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ENV241', '', '1287670227', 'VALIDE', 'ACTIVE', 3110, 1, 6110, 1),
(6524, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'STG241', '', '1964762758', 'VALIDE', 'ACTIVE', 3110, 1, 6116, 1),
(6523, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ETH231', '', '1949140002', 'VALIDE', 'ACTIVE', 3110, 1, 6106, 1),
(6522, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ANG241', '', '-1754469826', 'VALIDE', 'ACTIVE', 3110, 1, 6114, 1),
(6521, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF242', '', '-814533780', 'VALIDE', 'ACTIVE', 3110, 1, 6109, 1),
(6519, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'ETH241', '', '-1735214544', 'VALIDE', 'ACTIVE', 3109, 1, 6115, 1),
(6520, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF241', '', '-1002590795', 'VALIDE', 'ACTIVE', 3110, 1, 6107, 1),
(6518, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'ANG231', '', '846250115', 'VALIDE', 'ACTIVE', 3109, 1, 6105, 1),
(6517, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF234', '', '-1407953716', 'VALIDE', 'ACTIVE', 3109, 1, 6104, 1),
(6516, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF236', '', '-967054921', 'VALIDE', 'ACTIVE', 3109, 1, 6103, 1),
(6515, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF235', '', '914217592', 'VALIDE', 'ACTIVE', 3109, 1, 6102, 1),
(6514, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF233', '', '1018030048', 'VALIDE', 'ACTIVE', 3109, 1, 6101, 1),
(6512, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'MAT241', '', '-1037230455', 'VALIDE', 'ACTIVE', 3109, 1, 6108, 1),
(6513, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'MAT231', '', '-939469661', 'VALIDE', 'ACTIVE', 3109, 1, 6069, 1),
(6509, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'IN245', '', '-1588191746', 'VALIDE', 'ACTIVE', 3109, 1, 6113, 1),
(6510, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'INF231', '', '-867217099', 'VALIDE', 'ACTIVE', 3109, 1, 6067, 1),
(6511, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'INF232', '', '-2011748349', 'VALIDE', 'ACTIVE', 3109, 1, 6068, 1),
(6508, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'INF243', '', '-875887769', 'VALIDE', 'ACTIVE', 3109, 1, 6112, 1),
(6506, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'ENV241', '', '1765563674', 'VALIDE', 'ACTIVE', 3109, 1, 6110, 1),
(6507, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'INF244', '', '1717737303', 'VALIDE', 'ACTIVE', 3109, 1, 6111, 1),
(6504, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ETH231', '', '-1955012940', 'VALIDE', 'ACTIVE', 3109, 1, 6106, 1),
(6505, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'STG241', '', '-1424631495', 'VALIDE', 'ACTIVE', 3109, 1, 6116, 1),
(6503, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ANG241', '', '-1978720458', 'VALIDE', 'ACTIVE', 3109, 1, 6114, 1),
(6502, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'INF242', '', '-436946630', 'VALIDE', 'ACTIVE', 3109, 1, 6109, 1),
(6501, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'INF241', '', '-78279213', 'VALIDE', 'ACTIVE', 3109, 1, 6107, 1),
(6500, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ETH241', '', '1967096957', 'VALIDE', 'ACTIVE', 3108, 1, 6115, 1),
(6499, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ANG231', '', '436570642', 'VALIDE', 'ACTIVE', 3108, 1, 6105, 1),
(6498, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF234', '', '-1817633189', 'VALIDE', 'ACTIVE', 3108, 1, 6104, 1),
(6497, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF236', '', '-1331541447', 'VALIDE', 'ACTIVE', 3108, 1, 6103, 1),
(6496, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF235', '', '554140134', 'VALIDE', 'ACTIVE', 3108, 1, 6102, 1),
(6492, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF232', '', '2025652320', 'VALIDE', 'ACTIVE', 3108, 1, 6068, 1),
(6493, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'MAT241', '', '-633436882', 'VALIDE', 'ACTIVE', 3108, 1, 6108, 1),
(6494, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'MAT231', '', '-1023980369', 'VALIDE', 'ACTIVE', 3108, 1, 6069, 1),
(6495, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF233', '', '364749568', 'VALIDE', 'ACTIVE', 3108, 1, 6101, 1),
(6491, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF231', '', '-428150982', 'VALIDE', 'ACTIVE', 3108, 1, 6067, 1),
(6490, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'IN245', '', '-1165659634', 'VALIDE', 'ACTIVE', 3108, 1, 6113, 1),
(6489, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF243', '', '-1352805529', 'VALIDE', 'ACTIVE', 3108, 1, 6112, 1),
(6488, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF244', '', '-2011403171', 'VALIDE', 'ACTIVE', 3108, 1, 6111, 1),
(6487, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'ENV241', '', '-1581090151', 'VALIDE', 'ACTIVE', 3108, 1, 6110, 1),
(6486, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'STG241', '', '-1644721044', 'VALIDE', 'ACTIVE', 3108, 1, 6116, 1),
(6485, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'ETH231', '', '-1793718107', 'VALIDE', 'ACTIVE', 3108, 1, 6106, 1),
(6484, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'ANG241', '', '-1759005474', 'VALIDE', 'ACTIVE', 3108, 1, 6114, 1),
(6483, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'INF242', '', '230288756', 'VALIDE', 'ACTIVE', 3108, 1, 6109, 1),
(6482, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF241', '', '-871547602', 'VALIDE', 'ACTIVE', 3108, 1, 6107, 1),
(6481, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'ETH241', '', '328187255', 'VALIDE', 'ACTIVE', 3107, 1, 6115, 1),
(6480, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'ANG231', '', '-1189111856', 'VALIDE', 'ACTIVE', 3107, 1, 6105, 1),
(6476, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF233', '', '-416596408', 'VALIDE', 'ACTIVE', 3107, 1, 6101, 1),
(6477, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF235', '', '-1056110626', 'VALIDE', 'ACTIVE', 3107, 1, 6102, 1),
(6478, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF236', '', '856052672', 'VALIDE', 'ACTIVE', 3107, 1, 6103, 1),
(6479, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF234', '', '776697453', 'VALIDE', 'ACTIVE', 3107, 1, 6104, 1),
(6472, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF231', '', '-1519233985', 'VALIDE', 'ACTIVE', 3107, 1, 6067, 1),
(6473, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF232', '', '730649922', 'VALIDE', 'ACTIVE', 3107, 1, 6068, 1),
(6474, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'MAT241', '', '1623600058', 'VALIDE', 'ACTIVE', 3107, 1, 6108, 1),
(6475, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'MAT231', '', '1368635412', 'VALIDE', 'ACTIVE', 3107, 1, 6069, 1),
(6471, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'IN245', '', '1890520881', 'VALIDE', 'ACTIVE', 3107, 1, 6113, 1),
(6469, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF244', '', '920221173', 'VALIDE', 'ACTIVE', 3107, 1, 6111, 1),
(6470, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF243', '', '-1815596342', 'VALIDE', 'ACTIVE', 3107, 1, 6112, 1),
(6468, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'ENV241', '', '1227080289', 'VALIDE', 'ACTIVE', 3107, 1, 6110, 1),
(6466, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'ETH231', '', '-2131952749', 'VALIDE', 'ACTIVE', 3107, 1, 6106, 1),
(6467, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'STG241', '', '-1865013117', 'VALIDE', 'ACTIVE', 3107, 1, 6116, 1),
(6465, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ANG241', '', '-1600117699', 'VALIDE', 'ACTIVE', 3107, 1, 6114, 1),
(6463, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF241', '', '-891227081', 'VALIDE', 'ACTIVE', 3107, 1, 6107, 1),
(6464, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF242', '', '-643647648', 'VALIDE', 'ACTIVE', 3107, 1, 6109, 1),
(6462, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ETH241', '', '-555510263', 'VALIDE', 'ACTIVE', 3106, 1, 6115, 1),
(6460, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF234', '', '793552074', 'VALIDE', 'ACTIVE', 3106, 1, 6104, 1),
(6461, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ANG231', '', '-1232881920', 'VALIDE', 'ACTIVE', 3106, 1, 6105, 1),
(6459, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF236', '', '61638781', 'VALIDE', 'ACTIVE', 3106, 1, 6103, 1),
(6458, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF235', '', '1894411546', 'VALIDE', 'ACTIVE', 3106, 1, 6102, 1),
(6457, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF233', '', '-1281555387', 'VALIDE', 'ACTIVE', 3106, 1, 6101, 1),
(6456, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'MAT231', '', '1322660814', 'VALIDE', 'ACTIVE', 3106, 1, 6069, 1),
(6455, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'MAT241', '', '1642659213', 'VALIDE', 'ACTIVE', 3106, 1, 6108, 1),
(6454, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF232', '', '-74786639', 'VALIDE', 'ACTIVE', 3106, 1, 6068, 1),
(6453, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF231', '', '1415856449', 'VALIDE', 'ACTIVE', 3106, 1, 6067, 1),
(6451, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF243', '', '1481037668', 'VALIDE', 'ACTIVE', 3106, 1, 6112, 1),
(6452, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'IN245', '', '1164447544', 'VALIDE', 'ACTIVE', 3106, 1, 6113, 1),
(6446, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF244', '', '141116012', 'VALIDE', 'ACTIVE', 3106, 1, 6111, 1),
(6445, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ENV241', '', '-32613284', 'VALIDE', 'ACTIVE', 3106, 1, 6110, 1),
(6442, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ANG241', '', '1171714211', 'VALIDE', 'ACTIVE', 3106, 1, 6114, 1),
(6443, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ETH231', '', '690583443', 'VALIDE', 'ACTIVE', 3106, 1, 6106, 1),
(6444, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'STG241', '', '644479247', 'VALIDE', 'ACTIVE', 3106, 1, 6116, 1),
(6441, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF242', '', '-2103953815', 'VALIDE', 'ACTIVE', 3106, 1, 6109, 1),
(6440, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF241', '', '1947843116', 'VALIDE', 'ACTIVE', 3106, 1, 6107, 1),
(6439, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ETH241', '', '1043682055', 'VALIDE', 'ACTIVE', 3105, 1, 6115, 1),
(6436, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF236', '', '1440377699', 'VALIDE', 'ACTIVE', 3105, 1, 6103, 1),
(6437, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF234', '', '1559430540', 'VALIDE', 'ACTIVE', 3105, 1, 6104, 1),
(6438, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'ANG231', '', '103970852', 'VALIDE', 'ACTIVE', 3105, 1, 6105, 1),
(6434, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF233', '', '-591733344', 'VALIDE', 'ACTIVE', 3105, 1, 6101, 1),
(6435, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF235', '', '-456353861', 'VALIDE', 'ACTIVE', 3105, 1, 6102, 1),
(6433, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'MAT231', '', '1831711069', 'VALIDE', 'ACTIVE', 3105, 1, 6069, 1),
(6432, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'MAT241', '', '-1833520801', 'VALIDE', 'ACTIVE', 3105, 1, 6108, 1),
(6431, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF232', '', '814545731', 'VALIDE', 'ACTIVE', 3105, 1, 6068, 1),
(6430, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF231', '', '-1871835908', 'VALIDE', 'ACTIVE', 3105, 1, 6067, 1),
(6429, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'IN245', '', '1922610141', 'VALIDE', 'ACTIVE', 3105, 1, 6113, 1),
(6428, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF243', '', '1723339309', 'VALIDE', 'ACTIVE', 3105, 1, 6112, 1),
(6427, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF244', '', '806811189', 'VALIDE', 'ACTIVE', 3105, 1, 6111, 1),
(6426, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ENV241', '', '1486236551', 'VALIDE', 'ACTIVE', 3105, 1, 6110, 1),
(6423, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ANG241', '', '1422956996', 'VALIDE', 'ACTIVE', 3105, 1, 6114, 1),
(6424, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ETH231', '', '1559095748', 'VALIDE', 'ACTIVE', 3105, 1, 6106, 1),
(6425, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'STG241', '', '1701479209', 'VALIDE', 'ACTIVE', 3105, 1, 6116, 1),
(6422, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'INF242', '', '-920193148', 'VALIDE', 'ACTIVE', 3105, 1, 6109, 1),
(6421, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'INF241', '', '-1788348902', 'VALIDE', 'ACTIVE', 3105, 1, 6107, 1),
(6419, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'ANG231', '', '1272785137', 'VALIDE', 'ACTIVE', 3104, 1, 6105, 1),
(6417, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF236', '', '-1490674053', 'VALIDE', 'ACTIVE', 3104, 1, 6103, 1),
(6420, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'ETH241', '', '-1469610504', 'VALIDE', 'ACTIVE', 3104, 1, 6115, 1),
(6418, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF234', '', '-549330030', 'VALIDE', 'ACTIVE', 3104, 1, 6104, 1),
(6416, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF235', '', '569165714', 'VALIDE', 'ACTIVE', 3104, 1, 6102, 1),
(6415, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF233', '', '1702495548', 'VALIDE', 'ACTIVE', 3104, 1, 6101, 1),
(6412, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF232', '', '-687967989', 'VALIDE', 'ACTIVE', 3104, 1, 6068, 1),
(6414, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'MAT231', '', '-43368897', 'VALIDE', 'ACTIVE', 3104, 1, 6069, 1),
(6413, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'MAT241', '', '193959477', 'VALIDE', 'ACTIVE', 3104, 1, 6108, 1),
(6411, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF231', '', '198632783', 'VALIDE', 'ACTIVE', 3104, 1, 6067, 1),
(6410, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'IN245', '', '-409910630', 'VALIDE', 'ACTIVE', 3104, 1, 6113, 1),
(6409, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF243', '', '-139615720', 'VALIDE', 'ACTIVE', 3104, 1, 6112, 1),
(6408, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF244', '', '-974576082', 'VALIDE', 'ACTIVE', 3104, 1, 6111, 1),
(6407, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'ENV241', '', '-377820745', 'VALIDE', 'ACTIVE', 3104, 1, 6110, 1),
(6406, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'STG241', '', '782064732', 'VALIDE', 'ACTIVE', 3104, 1, 6116, 1),
(6405, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ETH231', '', '466625352', 'VALIDE', 'ACTIVE', 3104, 1, 6106, 1),
(6403, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF242', '', '-1593802084', 'VALIDE', 'ACTIVE', 3104, 1, 6109, 1),
(6404, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ANG241', '', '938937984', 'VALIDE', 'ACTIVE', 3104, 1, 6114, 1),
(6402, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF241', '', '1847338929', 'VALIDE', 'ACTIVE', 3104, 1, 6107, 1),
(6401, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ETH241', '', '-1767330541', 'VALIDE', 'ACTIVE', 3103, 1, 6115, 1),
(6400, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ANG231', '', '1547141673', 'VALIDE', 'ACTIVE', 3103, 1, 6105, 1),
(6399, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF234', '', '-201121605', 'VALIDE', 'ACTIVE', 3103, 1, 6104, 1),
(6396, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF233', '', '-1766981712', 'VALIDE', 'ACTIVE', 3103, 1, 6101, 1),
(6397, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF235', '', '1632745422', 'VALIDE', 'ACTIVE', 3103, 1, 6102, 1),
(6398, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF236', '', '-90902910', 'VALIDE', 'ACTIVE', 3103, 1, 6103, 1),
(6395, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'MAT231', '', '-64419917', 'VALIDE', 'ACTIVE', 3103, 1, 6069, 1);
INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(6393, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF232', '', '-656110193', 'VALIDE', 'ACTIVE', 3103, 1, 6068, 1),
(6394, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'MAT241', '', '455088809', 'VALIDE', 'ACTIVE', 3103, 1, 6108, 1),
(6392, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF231', '', '1369132390', 'VALIDE', 'ACTIVE', 3103, 1, 6067, 1),
(6391, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'IN245', '', '737441370', 'VALIDE', 'ACTIVE', 3103, 1, 6113, 1),
(6389, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF244', '', '270877681', 'VALIDE', 'ACTIVE', 3103, 1, 6111, 1),
(6390, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF243', '', '1048520159', 'VALIDE', 'ACTIVE', 3103, 1, 6112, 1),
(6388, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ENV241', '', '18887428', 'VALIDE', 'ACTIVE', 3103, 1, 6110, 1),
(6386, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ETH231', '', '273620680', 'VALIDE', 'ACTIVE', 3103, 1, 6106, 1),
(6387, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'STG241', '', '883365349', 'VALIDE', 'ACTIVE', 3103, 1, 6116, 1),
(6385, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ANG241', '', '1060079407', 'VALIDE', 'ACTIVE', 3103, 1, 6114, 1),
(6384, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF242', '', '-1210321115', 'VALIDE', 'ACTIVE', 3103, 1, 6109, 1),
(6383, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF241', '', '-1459002815', 'VALIDE', 'ACTIVE', 3103, 1, 6107, 1),
(6382, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ETH241', '', '1220435571', 'VALIDE', 'ACTIVE', 3102, 1, 6115, 1),
(6381, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ANG231', '', '-340954220', 'VALIDE', 'ACTIVE', 3102, 1, 6105, 1),
(6380, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF234', '', '1857433426', 'VALIDE', 'ACTIVE', 3102, 1, 6104, 1),
(6379, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF236', '', '1731766983', 'VALIDE', 'ACTIVE', 3102, 1, 6103, 1),
(6378, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF235', '', '-552962561', 'VALIDE', 'ACTIVE', 3102, 1, 6102, 1),
(6377, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF233', '', '631071555', 'VALIDE', 'ACTIVE', 3102, 1, 6101, 1),
(6376, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'MAT231', '', '-1398075509', 'VALIDE', 'ACTIVE', 3102, 1, 6069, 1),
(6375, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'MAT241', '', '-832271569', 'VALIDE', 'ACTIVE', 3102, 1, 6108, 1),
(6374, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF232', '', '1723204535', 'VALIDE', 'ACTIVE', 3102, 1, 6068, 1),
(6373, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF231', '', '-1080017406', 'VALIDE', 'ACTIVE', 3102, 1, 6067, 1),
(6372, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'IN245', '', '-1338039913', 'VALIDE', 'ACTIVE', 3102, 1, 6113, 1),
(6371, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF243', '', '-739269437', 'VALIDE', 'ACTIVE', 3102, 1, 6112, 1),
(6370, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF244', '', '-1802399068', 'VALIDE', 'ACTIVE', 3102, 1, 6111, 1),
(6369, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'ENV241', '', '-2014707709', 'VALIDE', 'ACTIVE', 3102, 1, 6110, 1),
(6368, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'STG241', '', '-1318876639', 'VALIDE', 'ACTIVE', 3102, 1, 6116, 1),
(6367, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ETH231', '', '-1347726599', 'VALIDE', 'ACTIVE', 3102, 1, 6106, 1),
(6366, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ANG241', '', '-778414471', 'VALIDE', 'ACTIVE', 3102, 1, 6114, 1),
(6364, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF241', '', '235804106', 'VALIDE', 'ACTIVE', 3102, 1, 6107, 1),
(6365, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF242', '', '1006960364', 'VALIDE', 'ACTIVE', 3102, 1, 6109, 1),
(6363, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ETH241', '', '1833025134', 'VALIDE', 'ACTIVE', 3101, 1, 6115, 1),
(6362, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ANG231', '', '1464288237', 'VALIDE', 'ACTIVE', 3101, 1, 6105, 1),
(6359, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF235', '', '270159999', 'VALIDE', 'ACTIVE', 3101, 1, 6102, 1),
(6361, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF234', '', '-807551866', 'VALIDE', 'ACTIVE', 3101, 1, 6104, 1),
(6360, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF236', '', '-1515215285', 'VALIDE', 'ACTIVE', 3101, 1, 6103, 1),
(6358, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF233', '', '1157684292', 'VALIDE', 'ACTIVE', 3101, 1, 6101, 1),
(6357, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'MAT231', '', '-212307106', 'VALIDE', 'ACTIVE', 3101, 1, 6069, 1),
(6356, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'MAT241', '', '-737747496', 'VALIDE', 'ACTIVE', 3101, 1, 6108, 1),
(6355, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF232', '', '-1818083022', 'VALIDE', 'ACTIVE', 3101, 1, 6068, 1),
(6354, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF231', '', '244636639', 'VALIDE', 'ACTIVE', 3101, 1, 6067, 1),
(6353, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'IN245', '', '-496178814', 'VALIDE', 'ACTIVE', 3101, 1, 6113, 1),
(6351, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'INF244', '', '-1692443257', 'VALIDE', 'ACTIVE', 3101, 1, 6111, 1),
(6352, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF243', '', '-682222442', 'VALIDE', 'ACTIVE', 3101, 1, 6112, 1),
(6350, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ENV241', '', '-994279356', 'VALIDE', 'ACTIVE', 3101, 1, 6110, 1),
(6349, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'STG241', '', '-786752567', 'VALIDE', 'ACTIVE', 3101, 1, 6116, 1),
(6348, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ETH231', '', '-998578849', 'VALIDE', 'ACTIVE', 3101, 1, 6106, 1),
(6347, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ANG241', '', '-327858157', 'VALIDE', 'ACTIVE', 3101, 1, 6114, 1),
(6346, '2019-08-12 14:10:13', '2019-08-12 14:10:13', 'INF242', '', '518385194', 'VALIDE', 'ACTIVE', 3101, 1, 6109, 1),
(6345, '2019-08-12 14:10:13', '2019-08-12 14:10:13', 'INF241', '', '-90737815', 'VALIDE', 'ACTIVE', 3101, 1, 6107, 1),
(6870, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF234', '', '-1023203110', 'VALIDE', 'ACTIVE', 3125, 1, 6104, 1),
(6871, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'ANG231', '', '1330204751', 'VALIDE', 'ACTIVE', 3125, 1, 6105, 1),
(6872, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'ETH241', '', '1722089255', 'VALIDE', 'ACTIVE', 3125, 1, 6115, 1);

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE IF NOT EXISTS `etudiant` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_authentification` varchar(255) DEFAULT NULL,
  `matricule` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`) USING BTREE,
  UNIQUE KEY `matricule` (`matricule`) USING BTREE,
  UNIQUE KEY `code_authentification` (`code_authentification`,`matricule`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3126 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`code`, `code_authentification`, `matricule`) VALUES
(3121, '1624.387852054459', '1718L032'),
(3120, '1493.3914477525109', '1718L024'),
(3119, '2094.781637709097', '1617L25'),
(3118, '1625.5235243470318', '1718L005'),
(3117, '1691.914686872678', '1718L023'),
(3116, '1941.4693836637673', '1718L035'),
(3115, '1855.0011168175342', '1819L108'),
(3114, '1986.9911219545875', '1617L22'),
(3113, '1264.2535774992382', '1718L037'),
(3112, '1521.243114904074', '1718L033'),
(3111, '1669.7998154893905', '1718L021'),
(3110, '1775.1462261210345', '1718L030'),
(3109, '2041.0909754457984', '1718L020'),
(3108, '1268.1150037150248', '1718L003'),
(3107, '1728.5890374939938', '1819L107'),
(3106, '1477.9004699436466', '1718L019'),
(3105, '1631.2210634467656', '1617L13'),
(3104, '1381.651049770484', '1718L016'),
(3102, '1697.3237691072713', '1718L001'),
(3103, '1456.5303671938777', '1718L014'),
(3101, '1474.642074511742', '1819L106'),
(3122, '1648.9812499140207', '1718L025'),
(3123, '1760.329992808751', '1718L031'),
(3124, '1548.854377891203', '1718L006'),
(3125, '1858.271683706163', '1718L011');

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
) ENGINE=MyISAM AUTO_INCREMENT=6267 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `evaluation`
--

INSERT INTO `evaluation` (`code`, `date_creation`, `date_evaluation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `type_evaluation`) VALUES
(6266, '2019-08-12 14:07:29', '2019-02-11 23:00:00', '2019-08-12 14:07:30', 'TP INF242', 'Travaux pratiques', '-929581291', 'ACTIVE', 'ACTIVE', 1, 1, 6142),
(6264, '2019-08-12 14:07:29', '2019-02-13 23:00:00', '2019-08-12 14:07:29', 'TP INF235', 'Travaux pratiques', '531728743', 'ACTIVE', 'ACTIVE', 1, 1, 6212),
(6265, '2019-08-12 14:07:29', '2019-02-10 23:00:00', '2019-08-12 14:07:29', 'TP INF241', 'Travaux pratiques', '-698568839', 'ACTIVE', 'ACTIVE', 1, 1, 6137),
(6262, '2019-08-12 14:07:29', '2019-02-12 23:00:00', '2019-08-12 14:07:29', 'TP INF233', 'Travaux pratiques', '1604870300', 'ACTIVE', 'ACTIVE', 1, 1, 6209),
(6263, '2019-08-12 14:07:29', '2019-02-14 23:00:00', '2019-08-12 14:07:29', 'TP INF234', 'Travaux pratiques', '1124120311', 'ACTIVE', 'ACTIVE', 1, 1, 6220),
(6258, '2019-08-12 14:07:28', '2019-06-07 22:00:00', '2019-08-12 14:07:28', 'SN INF243', 'Session normale', '-1250693684', 'ACTIVE', 'ACTIVE', 1, 1, 6157),
(6259, '2019-08-12 14:07:28', '2019-06-08 22:00:00', '2019-08-12 14:07:28', 'SN INF244', 'Session normale', '-539212326', 'ACTIVE', 'ACTIVE', 1, 1, 6154),
(6260, '2019-08-12 14:07:28', '2018-02-04 23:00:00', '2019-08-12 14:07:28', 'SN MAT231', 'Session normale', '-498288759', 'ACTIVE', 'ACTIVE', 1, 1, 6205),
(6261, '2019-08-12 14:07:29', '2019-06-06 22:00:00', '2019-08-12 14:07:29', 'SN MAT241', 'Session normale', '-819851818', 'ACTIVE', 'ACTIVE', 1, 1, 6202),
(6256, '2019-08-12 14:07:28', '2019-02-09 23:00:00', '2019-08-12 14:07:28', 'SN INF241', 'Session normale', '1505655954', 'ACTIVE', 'ACTIVE', 1, 1, 6136),
(6257, '2019-08-12 14:07:28', '2019-02-10 23:00:00', '2019-08-12 14:07:28', 'SN INF242', 'Session normale', '380704004', 'ACTIVE', 'ACTIVE', 1, 1, 6140),
(6255, '2019-08-12 14:07:28', '2018-02-05 23:00:00', '2019-08-12 14:07:28', 'SN INF236', 'Session normale', '-1300639738', 'ACTIVE', 'ACTIVE', 1, 1, 6215),
(6254, '2019-08-12 14:07:28', '2019-06-04 22:00:00', '2019-08-12 14:07:28', 'SN INF235', 'Session normale', '-807087346', 'ACTIVE', 'ACTIVE', 1, 1, 6211),
(6253, '2019-08-12 14:07:27', '2018-02-04 23:00:00', '2019-08-12 14:07:27', 'SN INF234', 'Session normale', '-2078740871', 'ACTIVE', 'ACTIVE', 1, 1, 6219),
(6248, '2019-08-12 14:07:27', '2019-06-03 22:00:00', '2019-08-12 14:07:27', 'SN ETH231', 'Session normale', '1418682290', 'ACTIVE', 'ACTIVE', 1, 1, 6148),
(6249, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN ETH241', 'Session normale', '-581858834', 'ACTIVE', 'ACTIVE', 1, 1, 6225),
(6250, '2019-08-12 14:07:27', '2019-02-07 23:00:00', '2019-08-12 14:07:27', 'SN INF231', 'Session normale', '921799698', 'ACTIVE', 'ACTIVE', 1, 1, 6163),
(6251, '2019-08-12 14:07:27', '2018-02-05 23:00:00', '2019-08-12 14:07:27', 'SN INF232', 'Session normale', '-1910097535', 'ACTIVE', 'ACTIVE', 1, 1, 6166),
(6252, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN INF233', 'Session normale', '-1723651806', 'ACTIVE', 'ACTIVE', 1, 1, 6208),
(6247, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN ENV241', 'Session normale', '119649611', 'ACTIVE', 'ACTIVE', 1, 1, 6151),
(6246, '2019-08-12 14:07:27', '2018-02-07 23:00:00', '2019-08-12 14:07:27', 'SN ANG241', 'Session normale', '1689275090', 'ACTIVE', 'ACTIVE', 1, 1, 6145),
(6245, '2019-08-12 14:07:27', '2019-06-04 22:00:00', '2019-08-12 14:07:27', 'SN ANG231', 'Session normale', '-1646222230', 'ACTIVE', 'ACTIVE', 1, 1, 6222),
(6244, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC MAT241', 'Controle Continu', '-1592805083', 'ACTIVE', 'ACTIVE', 1, 1, 6201),
(6243, '2019-08-12 14:07:26', '2018-10-19 22:00:00', '2019-08-12 14:07:26', 'CC MAT231', 'Controle Continu', '-753082685', 'ACTIVE', 'ACTIVE', 1, 1, 6204),
(6242, '2019-08-12 14:07:26', '2019-04-19 22:00:00', '2019-08-12 14:07:26', 'CC INF245', 'Controle Continu', '191618888', 'ACTIVE', 'ACTIVE', 1, 1, 6159),
(6240, '2019-08-12 14:07:26', '2019-04-19 22:00:00', '2019-08-12 14:07:26', 'CC INF243', 'Controle Continu', '-202314935', 'ACTIVE', 'ACTIVE', 1, 1, 6156),
(6241, '2019-08-12 14:07:26', '2019-04-12 22:00:00', '2019-08-12 14:07:26', 'CC INF244', 'Controle Continu', '1424843400', 'ACTIVE', 'ACTIVE', 1, 1, 6153),
(6238, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC INF241', 'Controle Continu', '-8396137', 'ACTIVE', 'ACTIVE', 1, 1, 6135),
(6239, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC INF242', 'Controle Continu', '-1781168961', 'ACTIVE', 'ACTIVE', 1, 1, 6139),
(6237, '2019-08-12 14:07:25', '2018-11-16 23:00:00', '2019-08-12 14:07:25', 'CC INF236', 'Controle Continu', '1589975745', 'ACTIVE', 'ACTIVE', 1, 1, 6214),
(6235, '2019-08-12 14:07:25', '2018-10-26 22:00:00', '2019-08-12 14:07:25', 'CC INF234', 'Controle Continu', '-751889142', 'ACTIVE', 'ACTIVE', 1, 1, 6218),
(6236, '2019-08-12 14:07:25', '2018-11-09 23:00:00', '2019-08-12 14:07:25', 'CC INF235', 'Controle Continu', '1463135945', 'ACTIVE', 'ACTIVE', 1, 1, 6210),
(6233, '2019-08-12 14:07:25', '2018-10-19 22:00:00', '2019-08-12 14:07:25', 'CC INF232', 'Controle Continu', '895819126', 'ACTIVE', 'ACTIVE', 1, 1, 6165),
(6234, '2019-08-12 14:07:25', '2018-11-02 23:00:00', '2019-08-12 14:07:25', 'CC INF233', 'Controle Continu', '-1917780183', 'ACTIVE', 'ACTIVE', 1, 1, 6207),
(6231, '2019-08-12 14:07:25', '2019-04-26 22:00:00', '2019-08-12 14:07:25', 'CC ETH241', 'Controle Continu', '696056612', 'ACTIVE', 'ACTIVE', 1, 1, 6224),
(6232, '2019-08-12 14:07:25', '2018-10-26 22:00:00', '2019-08-12 14:07:25', 'CC INF231', 'Controle Continu', '1318930053', 'ACTIVE', 'ACTIVE', 1, 1, 6162),
(6230, '2019-08-12 14:07:24', '2018-11-02 23:00:00', '2019-08-12 14:07:24', 'CC ETH231', 'Controle Continu', '-1385599868', 'ACTIVE', 'ACTIVE', 1, 1, 6146),
(6227, '2019-08-12 14:07:23', '2018-11-02 23:00:00', '2019-08-12 14:07:24', 'CC ANG231', 'Controle Continu', '2101651604', 'ACTIVE', 'ACTIVE', 1, 1, 6221),
(6229, '2019-08-12 14:07:24', '2019-04-12 22:00:00', '2019-08-12 14:07:24', 'CC ENV241', 'Controle Continu', '-1929393729', 'ACTIVE', 'ACTIVE', 1, 1, 6150),
(6228, '2019-08-12 14:07:24', '2019-04-26 22:00:00', '2019-08-12 14:07:24', 'CC ANG241', 'Controle Continu', '8558044', 'ACTIVE', 'ACTIVE', 1, 1, 6143);

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
(2, '2019-08-02 10:25:34', '2019-08-02 10:31:03', 'Licence Informatique', 'Licence', '-848006121', 'ACTIVE', 1, 1),
(3, '2019-08-02 10:29:14', '2019-08-02 10:29:14', 'Ingénieur  Informatique', 'Ingénieur', '-847785401', 'ACTIVE', 1, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=1170 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `historique_note`
--

INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(1169, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Éthique et Philosophie', '2098908625', 'ACTIVE', 14, 1, 1, 6967),
(1168, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Éthique et Philosophie', '-40294886', 'ACTIVE', 14, 1, 1, 6967),
(1167, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Éthique et Philosophie', '-1516611805', 'ACTIVE', 16, 1, 1, 6966),
(1166, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Éthique et Philosophie', '640075501', 'ACTIVE', 16, 1, 1, 6966),
(1165, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Anglais niveau pratique B1/B2', '-1449729135', 'ACTIVE', 14, 1, 1, 6965),
(1164, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Anglais niveau pratique B1/B2', '707881692', 'ACTIVE', 14, 1, 1, 6965),
(1163, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Anglais niveau pratique B1/B2', '1262754890', 'ACTIVE', 14.4, 1, 1, 6964),
(1162, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Anglais niveau pratique B1/B2', '-873678058', 'ACTIVE', 14.4, 1, 1, 6964),
(1161, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '1739262478', 'ACTIVE', 17.5, 1, 1, 6963),
(1160, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-396246949', 'ACTIVE', 17.5, 1, 1, 6963),
(1159, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '1427585580', 'ACTIVE', 11, 1, 1, 6962),
(1158, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-707000326', 'ACTIVE', 11, 1, 1, 6962),
(1157, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-1260486830', 'ACTIVE', 12.5, 1, 1, 6961),
(1156, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '900818081', 'ACTIVE', 12.5, 1, 1, 6961),
(1155, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '63556781', 'ACTIVE', 10.75, 1, 1, 6960),
(1154, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '-2069182083', 'ACTIVE', 10.75, 1, 1, 6960),
(1153, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Réseaux informatiques', '878533126', 'ACTIVE', 9.5, 1, 1, 6959),
(1152, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '-1253282217', 'ACTIVE', 9.5, 1, 1, 6959),
(1151, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-368844606', 'ACTIVE', 16, 1, 1, 6958),
(1150, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '1795230868', 'ACTIVE', 16, 1, 1, 6958),
(1149, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-1250150641', 'ACTIVE', 17.25, 1, 1, 6957),
(1148, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '914848354', 'ACTIVE', 17.25, 1, 1, 6957),
(1147, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-1896186393', 'ACTIVE', 12.25, 1, 1, 6956),
(1146, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '269736123', 'ACTIVE', 12.25, 1, 1, 6956),
(1145, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '1168142587', 'ACTIVE', 16.5, 1, 1, 6955),
(1144, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Programmation Orientée Objet II', '-959978672', 'ACTIVE', 16.5, 1, 1, 6955),
(1143, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '1403736576', 'ACTIVE', 7, 1, 1, 6954),
(1142, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '-723461162', 'ACTIVE', 7, 1, 1, 6954),
(1141, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '209491517', 'ACTIVE', 14.75, 1, 1, 6953),
(1140, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '-1916782700', 'ACTIVE', 14.75, 1, 1, 6953),
(1139, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '-360355024', 'ACTIVE', 19, 1, 1, 6952),
(1138, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '1809261576', 'ACTIVE', 19, 1, 1, 6952),
(1137, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '-968714662', 'ACTIVE', 18.33, 1, 1, 6951),
(1136, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '1201825459', 'ACTIVE', 18.33, 1, 1, 6951),
(1135, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '-506194770', 'ACTIVE', 12, 1, 1, 6950),
(1134, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '1665268872', 'ACTIVE', 12, 1, 1, 6950),
(1133, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'modélisation des Systèmes d\'Information(UML)', '27078038', 'ACTIVE', 12.75, 1, 1, 6949),
(1132, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2095502095', 'ACTIVE', 12.75, 1, 1, 6949),
(1131, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Algorithmique et Complexité', '-1810460163', 'ACTIVE', 9, 1, 1, 6948),
(1130, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algorithmique et Complexité', '362850521', 'ACTIVE', 9, 1, 1, 6948),
(1129, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Algorithmique et Complexité', '-788473868', 'ACTIVE', 12, 1, 1, 6947),
(1128, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algorithmique et Complexité', '1385760337', 'ACTIVE', 12, 1, 1, 6947),
(1127, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Introduction à la sécurité informatique', '1281425521', 'ACTIVE', 11.5, 1, 1, 6946),
(1126, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Introduction à la sécurité informatique', '-838384049', 'ACTIVE', 11.5, 1, 1, 6946),
(1125, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Introduction à la sécurité informatique', '-976183367', 'ACTIVE', 12.88, 1, 1, 6945),
(1124, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Introduction à la sécurité informatique', '1199897880', 'ACTIVE', 12.88, 1, 1, 6945),
(1123, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '1312660156', 'ACTIVE', 12.5, 1, 1, 6944),
(1122, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '-805302372', 'ACTIVE', 12.5, 1, 1, 6944),
(1121, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '1016103447', 'ACTIVE', 18.17, 1, 1, 6943),
(1120, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '-1100935560', 'ACTIVE', 18.17, 1, 1, 6943),
(1119, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-38323471', 'ACTIVE', 13, 1, 1, 6942),
(1118, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '2140528339', 'ACTIVE', 13, 1, 1, 6942),
(1117, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1582024002', 'ACTIVE', 14.33, 1, 1, 6941),
(1116, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '597751329', 'ACTIVE', 14.33, 1, 1, 6941),
(1115, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '-334849862', 'ACTIVE', 17.5, 1, 1, 6940),
(1114, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '1845848990', 'ACTIVE', 17.5, 1, 1, 6940),
(1113, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Ethique et Développement    ', '-468081918', 'ACTIVE', 13.5, 1, 1, 6939),
(1112, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '1713540455', 'ACTIVE', 13.5, 1, 1, 6939),
(1111, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Anglais Niveau pratique B2', '2025778216', 'ACTIVE', 15.2, 1, 1, 6938),
(1110, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Anglais Niveau pratique B2', '-86643186', 'ACTIVE', 15.2, 1, 1, 6938),
(1109, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Anglais Niveau pratique B2', '-1181068069', 'ACTIVE', 12.5, 1, 1, 6937),
(1108, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Anglais Niveau pratique B2', '1002401346', 'ACTIVE', 12.5, 1, 1, 6937),
(1107, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1659968000', 'ACTIVE', 14.5, 1, 1, 6936),
(1106, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Programmation Web II', '-450606360', 'ACTIVE', 14.5, 1, 1, 6936),
(1105, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1976228664', 'ACTIVE', 16.5, 1, 1, 6935),
(1104, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '-133422175', 'ACTIVE', 16.5, 1, 1, 6935),
(1103, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1976585300', 'ACTIVE', 14, 1, 1, 6934),
(1102, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '-132142018', 'ACTIVE', 14, 1, 1, 6934),
(1101, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '1534726705', 'ACTIVE', 14, 1, 1, 6933),
(1100, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '-573077092', 'ACTIVE', 14, 1, 1, 6933),
(1098, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '1230939215', 'ACTIVE', 16.25, 1, 1, 6932),
(1099, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '-957147805', 'ACTIVE', 16.25, 1, 1, 6932),
(1097, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '-360426891', 'ACTIVE', 16, 1, 1, 6931),
(1096, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '1828583650', 'ACTIVE', 16, 1, 1, 6931),
(1095, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Langage C++ et POO', '1679180139', 'ACTIVE', 16, 1, 1, 6930),
(1094, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '-425853095', 'ACTIVE', 16, 1, 1, 6930),
(1093, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Langage C++ et POO', '-1720573449', 'ACTIVE', 15.33, 1, 1, 6929),
(1092, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '470284134', 'ACTIVE', 15.33, 1, 1, 6929),
(1091, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Éthique et Philosophie', '1478671768', 'ACTIVE', 17.75, 1, 1, 6928),
(1090, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Éthique et Philosophie', '-624514424', 'ACTIVE', 17.75, 1, 1, 6928),
(1089, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Éthique et Philosophie', '609071466', 'ACTIVE', 15.75, 1, 1, 6927),
(1088, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Éthique et Philosophie', '-1493191205', 'ACTIVE', 15.75, 1, 1, 6927),
(1087, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '1055377856', 'ACTIVE', 13.4, 1, 1, 6926),
(1086, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '-1045961294', 'ACTIVE', 13.4, 1, 1, 6926),
(1085, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '-1642523596', 'ACTIVE', 16, 1, 1, 6925),
(1084, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '552028071', 'ACTIVE', 16, 1, 1, 6925),
(1083, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-1231845138', 'ACTIVE', 18.25, 1, 1, 6924),
(1082, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '963630050', 'ACTIVE', 18.25, 1, 1, 6924),
(1081, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-150161336', 'ACTIVE', 15, 1, 1, 6923),
(1080, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '2046237373', 'ACTIVE', 15, 1, 1, 6923),
(1079, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Systèmes d\'exploitation', '1610009698', 'ACTIVE', 13.5, 1, 1, 6922),
(1078, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-487635368', 'ACTIVE', 13.5, 1, 1, 6922),
(1077, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Réseaux informatiques', '90117021', 'ACTIVE', 10.5, 1, 1, 6921),
(1076, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Réseaux informatiques', '-2006604524', 'ACTIVE', 10.5, 1, 1, 6921),
(1075, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Réseaux informatiques', '-1741159575', 'ACTIVE', 10, 1, 1, 6920),
(1074, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Réseaux informatiques', '458009697', 'ACTIVE', 10, 1, 1, 6920),
(1073, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '1866204762', 'ACTIVE', 12, 1, 1, 6919),
(1072, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Base de données', '-228669741', 'ACTIVE', 12, 1, 1, 6919),
(1071, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '951383112', 'ACTIVE', 9.25, 1, 1, 6918),
(1070, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '-1142567870', 'ACTIVE', 9.25, 1, 1, 6918),
(1069, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '302525619', 'ACTIVE', 12.25, 1, 1, 6917),
(1068, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '-1790501842', 'ACTIVE', 12.25, 1, 1, 6917),
(1067, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '-1704713044', 'ACTIVE', 17.75, 1, 1, 6916),
(1066, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '498150312', 'ACTIVE', 17.75, 1, 1, 6916),
(1065, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Programmation Orientée Objet II', '-253134957', 'ACTIVE', 12.5, 1, 1, 6915),
(1064, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '1950651920', 'ACTIVE', 12.5, 1, 1, 6915),
(1063, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Programmation Orientée Objet II', '680584593', 'ACTIVE', 13.25, 1, 1, 6914),
(1062, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '-1409672305', 'ACTIVE', 13.25, 1, 1, 6914),
(1061, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '50375616', 'ACTIVE', 11.5, 1, 1, 6913),
(1060, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Algèbre linaire I', '-2038957761', 'ACTIVE', 11.5, 1, 1, 6913),
(1059, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '1761550046', 'ACTIVE', 14, 1, 1, 6912),
(1058, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '-326859810', 'ACTIVE', 14, 1, 1, 6912),
(1057, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1238004792', 'ACTIVE', 12, 1, 1, 6911),
(1056, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '969476169', 'ACTIVE', 12, 1, 1, 6911),
(1055, '2019-08-12 14:12:23', '2019-08-12 14:12:22', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2103005851', 'ACTIVE', 12.75, 1, 1, 6910),
(1054, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '105398631', 'ACTIVE', 12.75, 1, 1, 6910),
(1053, '2019-08-12 14:12:23', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '-417659134', 'ACTIVE', 15, 1, 1, 6909),
(1052, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algorithmique et Complexité', '1791668869', 'ACTIVE', 15, 1, 1, 6909),
(1051, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '-1935899912', 'ACTIVE', 11.83, 1, 1, 6908),
(1050, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '274351612', 'ACTIVE', 11.83, 1, 1, 6908),
(1049, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '-1806584234', 'ACTIVE', 9.25, 1, 1, 6907),
(1048, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '404590811', 'ACTIVE', 9.25, 1, 1, 6907),
(1047, '2019-08-12 14:12:22', '2019-08-12 14:12:21', NULL, 'Introduction à la sécurité informatique', '-1704626758', 'ACTIVE', 9.63, 1, 1, 6906),
(1046, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '507471808', 'ACTIVE', 9.63, 1, 1, 6906),
(1045, '2019-08-12 14:12:22', '2019-08-12 14:12:21', NULL, 'économie numérique', '-1797732714', 'ACTIVE', 15, 1, 1, 6905),
(1044, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'économie numérique', '415289373', 'ACTIVE', 15, 1, 1, 6905),
(1043, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'économie numérique', '1667562774', 'ACTIVE', 16, 1, 1, 6904),
(1042, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'économie numérique', '-413458914', 'ACTIVE', 16, 1, 1, 6904),
(1041, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1421583147', 'ACTIVE', 16, 1, 1, 6903),
(1040, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-658515020', 'ACTIVE', 16, 1, 1, 6903),
(1039, '2019-08-12 14:12:21', '2019-08-12 14:12:20', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-800246776', 'ACTIVE', 15, 1, 1, 6902),
(1038, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1415545874', 'ACTIVE', 15, 1, 1, 6902),
(1037, '2019-08-12 14:12:21', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '688467954', 'ACTIVE', 14.5, 1, 1, 6901),
(1036, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'Ethique et Développement    ', '-1389783171', 'ACTIVE', 14.5, 1, 1, 6901),
(1035, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '1564787897', 'ACTIVE', 15.75, 1, 1, 6883),
(1034, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '-496839850', 'ACTIVE', 15.75, 1, 1, 6883),
(1033, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '-927086301', 'ACTIVE', 12.2, 1, 1, 6882),
(1032, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '1307176769', 'ACTIVE', 12.2, 1, 1, 6882),
(1031, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Anglais Niveau pratique B2', '-1685393766', 'ACTIVE', 11.1, 1, 1, 6881),
(1030, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '549792825', 'ACTIVE', 11.1, 1, 1, 6881),
(1029, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-424752414', 'ACTIVE', 14.5, 1, 1, 6880),
(1028, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Programmation Web II', '1811357698', 'ACTIVE', 14.5, 1, 1, 6880),
(1027, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-134661348', 'ACTIVE', 13, 1, 1, 6879),
(1026, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Programmation Web II', '2102372285', 'ACTIVE', 13, 1, 1, 6879),
(1025, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-1303699301', 'ACTIVE', 6.5, 1, 1, 6878),
(1024, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '934257853', 'ACTIVE', 6.5, 1, 1, 6878),
(1023, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '408880529', 'ACTIVE', 12, 1, 1, 6877),
(1022, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '-1647206092', 'ACTIVE', 12, 1, 1, 6877),
(1021, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '242371540', 'ACTIVE', 9.75, 1, 1, 6876),
(1020, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '-1812791560', 'ACTIVE', 9.75, 1, 1, 6876),
(1019, '2019-08-12 14:12:19', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '283402415', 'ACTIVE', 16, 1, 1, 6875),
(1018, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Langage C++ et POO', '-1770837164', 'ACTIVE', 16, 1, 1, 6875),
(1017, '2019-08-12 14:12:19', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '-883604236', 'ACTIVE', 14.75, 1, 1, 6874),
(1016, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Langage C++ et POO', '1358047002', 'ACTIVE', 14.75, 1, 1, 6874),
(1015, '2019-08-12 14:12:18', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '302848933', 'ACTIVE', 14.75, 1, 1, 6873),
(1014, '2019-08-12 14:12:18', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '-1749543604', 'ACTIVE', 14.75, 1, 1, 6873),
(1013, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-1815756469', 'ACTIVE', 14, 1, 1, 6344),
(1012, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '915360899', 'ACTIVE', 14, 1, 1, 6344),
(1011, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-65828569', 'ACTIVE', 16, 1, 1, 6343),
(1010, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-1628754976', 'ACTIVE', 16, 1, 1, 6343),
(1009, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Anglais niveau pratique B1/B2', '259938667', 'ACTIVE', 14, 1, 1, 6342),
(1008, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Anglais niveau pratique B1/B2', '-1302064219', 'ACTIVE', 14, 1, 1, 6342),
(1007, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Anglais niveau pratique B1/B2', '1041554974', 'ACTIVE', 14.4, 1, 1, 6341),
(1006, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Anglais niveau pratique B1/B2', '-519524391', 'ACTIVE', 14.4, 1, 1, 6341),
(1005, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '719077946', 'ACTIVE', 17.5, 1, 1, 6340),
(1004, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-841077898', 'ACTIVE', 17.5, 1, 1, 6340),
(1003, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '199580784', 'ACTIVE', 11, 1, 1, 6339),
(1002, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-1359651539', 'ACTIVE', 11, 1, 1, 6339),
(1001, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '1044553819', 'ACTIVE', 12.5, 1, 1, 6338),
(1000, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-513754983', 'ACTIVE', 12.5, 1, 1, 6338),
(999, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '2073438418', 'ACTIVE', 10.75, 1, 1, 6337),
(998, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '516053137', 'ACTIVE', 10.75, 1, 1, 6337),
(997, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '35291796', 'ACTIVE', 9.5, 1, 1, 6336),
(996, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '-1521169964', 'ACTIVE', 9.5, 1, 1, 6336),
(995, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-1393965043', 'ACTIVE', 16, 1, 1, 6335),
(994, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '1345464014', 'ACTIVE', 16, 1, 1, 6335),
(993, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '812252608', 'ACTIVE', 17.25, 1, 1, 6334),
(992, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-742362110', 'ACTIVE', 17.25, 1, 1, 6334),
(991, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-1290685593', 'ACTIVE', 12.25, 1, 1, 6333),
(990, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '1450590506', 'ACTIVE', 12.25, 1, 1, 6333),
(989, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '-2123751767', 'ACTIVE', 16.5, 1, 1, 6332),
(988, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '618447853', 'ACTIVE', 16.5, 1, 1, 6332),
(987, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Programmation Orientée Objet II', '-949437069', 'ACTIVE', 7, 1, 1, 6331),
(986, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '1793686072', 'ACTIVE', 7, 1, 1, 6331),
(985, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Programmation Orientée Objet II', '302759053', 'ACTIVE', 14.75, 1, 1, 6330),
(984, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '-1248161581', 'ACTIVE', 14.75, 1, 1, 6330),
(983, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algèbre linaire I', '-1928273845', 'ACTIVE', 19, 1, 1, 6329),
(982, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algèbre linaire I', '816696338', 'ACTIVE', 19, 1, 1, 6329),
(981, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algèbre linaire I', '-607879907', 'ACTIVE', 18.33, 1, 1, 6328),
(980, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algèbre linaire I', '2138013797', 'ACTIVE', 18.33, 1, 1, 6328),
(979, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'modélisation des Systèmes d\'Information(UML)', '-174302555', 'ACTIVE', 12, 1, 1, 6327),
(978, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1722452626', 'ACTIVE', 12, 1, 1, 6327),
(977, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'modélisation des Systèmes d\'Information(UML)', '1545096421', 'ACTIVE', 12.75, 1, 1, 6326),
(976, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2130129', 'ACTIVE', 12.75, 1, 1, 6326),
(975, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '658071709', 'ACTIVE', 9, 1, 1, 6325),
(974, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algorithmique et Complexité', '-888231320', 'ACTIVE', 9, 1, 1, 6325),
(973, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '1957466218', 'ACTIVE', 12, 1, 1, 6324),
(972, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '412086710', 'ACTIVE', 12, 1, 1, 6324),
(971, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '-1598593690', 'ACTIVE', 11.5, 1, 1, 6323),
(970, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '1151917619', 'ACTIVE', 11.5, 1, 1, 6323),
(969, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '1524060824', 'ACTIVE', 12.88, 1, 1, 6322),
(968, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '-19471642', 'ACTIVE', 12.88, 1, 1, 6322),
(967, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '-838836507', 'ACTIVE', 12.5, 1, 1, 6321),
(966, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '1913521844', 'ACTIVE', 12.5, 1, 1, 6321),
(965, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '1267356010', 'ACTIVE', 18.17, 1, 1, 6320),
(964, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '-274329414', 'ACTIVE', 18.17, 1, 1, 6320),
(963, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '150035811', 'ACTIVE', 13, 1, 1, 6319),
(962, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1390726092', 'ACTIVE', 13, 1, 1, 6319),
(961, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-66438835', 'ACTIVE', 14.33, 1, 1, 6318),
(960, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1606277217', 'ACTIVE', 14.33, 1, 1, 6318),
(959, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Ethique et Développement    ', '-533955359', 'ACTIVE', 17.5, 1, 1, 6317),
(958, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Ethique et Développement    ', '-2072870220', 'ACTIVE', 17.5, 1, 1, 6317),
(957, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Ethique et Développement    ', '1563311125', 'ACTIVE', 13.5, 1, 1, 6316),
(956, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Ethique et Développement    ', '25319785', 'ACTIVE', 13.5, 1, 1, 6316),
(955, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Anglais Niveau pratique B2', '1219409211', 'ACTIVE', 15.2, 1, 1, 6315),
(954, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Anglais Niveau pratique B2', '-317658608', 'ACTIVE', 15.2, 1, 1, 6315),
(953, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Anglais Niveau pratique B2', '-1189070860', 'ACTIVE', 12.5, 1, 1, 6314),
(952, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Anglais Niveau pratique B2', '1569752138', 'ACTIVE', 12.5, 1, 1, 6314),
(951, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-75673935', 'ACTIVE', 14.5, 1, 1, 6313),
(950, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Programmation Web II', '-1610894712', 'ACTIVE', 14.5, 1, 1, 6313),
(949, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-1768333546', 'ACTIVE', 16.5, 1, 1, 6312),
(948, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Programmation Web II', '992336494', 'ACTIVE', 16.5, 1, 1, 6312),
(947, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '543091321', 'ACTIVE', 14, 1, 1, 6311),
(946, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-990282414', 'ACTIVE', 14, 1, 1, 6311),
(945, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '-1123926235', 'ACTIVE', 14, 1, 1, 6310),
(944, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '1638590847', 'ACTIVE', 14, 1, 1, 6310),
(943, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '-2060646130', 'ACTIVE', 16.25, 1, 1, 6309),
(942, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '702794473', 'ACTIVE', 16.25, 1, 1, 6309),
(941, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-507750569', 'ACTIVE', 16, 1, 1, 6308),
(940, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-2038353741', 'ACTIVE', 16, 1, 1, 6308),
(939, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-1686279336', 'ACTIVE', 16, 1, 1, 6307),
(938, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '1079008309', 'ACTIVE', 16, 1, 1, 6307),
(937, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-1235560697', 'ACTIVE', 15.33, 1, 1, 6306),
(936, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '1530650469', 'ACTIVE', 15.33, 1, 1, 6306),
(935, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Éthique et Philosophie', '-1801275440', 'ACTIVE', 17.75, 1, 1, 6305),
(934, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Éthique et Philosophie', '965859247', 'ACTIVE', 17.75, 1, 1, 6305),
(933, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Éthique et Philosophie', '520869925', 'ACTIVE', 15.75, 1, 1, 6304),
(932, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Éthique et Philosophie', '-1006039163', 'ACTIVE', 15.75, 1, 1, 6304),
(931, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Anglais niveau pratique B1/B2', '-776790397', 'ACTIVE', 13.4, 1, 1, 6303),
(930, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Anglais niveau pratique B1/B2', '1992191332', 'ACTIVE', 13.4, 1, 1, 6303),
(929, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Anglais niveau pratique B1/B2', '440265259', 'ACTIVE', 16, 1, 1, 6302),
(928, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Anglais niveau pratique B1/B2', '-1084796787', 'ACTIVE', 16, 1, 1, 6302),
(927, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '-154571336', 'ACTIVE', 18.25, 1, 1, 6301),
(926, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-1678709861', 'ACTIVE', 18.25, 1, 1, 6301),
(925, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '-53429104', 'ACTIVE', 15, 1, 1, 6300),
(924, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-1576644108', 'ACTIVE', 15, 1, 1, 6300),
(923, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '1312912979', 'ACTIVE', 13.5, 1, 1, 6299),
(922, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-209378504', 'ACTIVE', 13.5, 1, 1, 6299),
(921, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '520262141', 'ACTIVE', 10.5, 1, 1, 6298),
(920, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '-1001105821', 'ACTIVE', 10.5, 1, 1, 6298),
(919, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '1027037223', 'ACTIVE', 10, 1, 1, 6297),
(918, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '-493407218', 'ACTIVE', 10, 1, 1, 6297),
(917, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '278675971', 'ACTIVE', 12, 1, 1, 6296),
(916, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-1240844949', 'ACTIVE', 12, 1, 1, 6296),
(915, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-1010307576', 'ACTIVE', 9.25, 1, 1, 6295),
(914, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '1766062321', 'ACTIVE', 9.25, 1, 1, 6295),
(913, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-597954626', 'ACTIVE', 12.25, 1, 1, 6294),
(912, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-2115628504', 'ACTIVE', 12.25, 1, 1, 6294),
(911, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '1932055058', 'ACTIVE', 17.75, 1, 1, 6293),
(910, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '415304701', 'ACTIVE', 17.75, 1, 1, 6293),
(909, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '1580951547', 'ACTIVE', 12.5, 1, 1, 6292),
(908, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '65124711', 'ACTIVE', 12.5, 1, 1, 6292),
(907, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '-1991356477', 'ACTIVE', 13.25, 1, 1, 6291),
(906, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '788707504', 'ACTIVE', 13.25, 1, 1, 6291),
(905, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Algèbre linaire I', '1252833063', 'ACTIVE', 11.5, 1, 1, 6290),
(904, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Algèbre linaire I', '-261146731', 'ACTIVE', 11.5, 1, 1, 6290),
(902, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Algèbre linaire I', '146723546', 'ACTIVE', 14, 1, 1, 6289),
(903, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Algèbre linaire I', '1659779819', 'ACTIVE', 14, 1, 1, 6289),
(901, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '255553213', 'ACTIVE', 12, 1, 1, 6288),
(900, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1256579539', 'ACTIVE', 12, 1, 1, 6288),
(899, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '1428227788', 'ACTIVE', 12.75, 1, 1, 6287),
(898, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '-82981443', 'ACTIVE', 12.75, 1, 1, 6287),
(897, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '-906162465', 'ACTIVE', 15, 1, 1, 6286),
(896, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '1878519121', 'ACTIVE', 15, 1, 1, 6286),
(895, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '126511006', 'ACTIVE', 11.83, 1, 1, 6285),
(894, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '-1382851183', 'ACTIVE', 11.83, 1, 1, 6285),
(893, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '-602292774', 'ACTIVE', 9.25, 1, 1, 6284),
(892, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '-2110731442', 'ACTIVE', 9.25, 1, 1, 6284),
(891, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'Introduction à la sécurité informatique', '-1118480354', 'ACTIVE', 9.63, 1, 1, 6283),
(890, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '1668971795', 'ACTIVE', 9.63, 1, 1, 6283),
(889, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'économie numérique', '665903202', 'ACTIVE', 15, 1, 1, 6282),
(888, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'économie numérique', '-840688424', 'ACTIVE', 15, 1, 1, 6282),
(887, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'économie numérique', '1411113825', 'ACTIVE', 16, 1, 1, 6281),
(886, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'économie numérique', '-94554280', 'ACTIVE', 16, 1, 1, 6281),
(885, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-85938631', 'ACTIVE', 16, 1, 1, 6280),
(884, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1590683215', 'ACTIVE', 16, 1, 1, 6280),
(883, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '2039636772', 'ACTIVE', 15, 1, 1, 6279),
(882, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '535815709', 'ACTIVE', 15, 1, 1, 6279),
(881, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '1082825678', 'ACTIVE', 14.5, 1, 1, 6278),
(880, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '-420071864', 'ACTIVE', 14.5, 1, 1, 6278),
(879, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '-1864112453', 'ACTIVE', 15.75, 1, 1, 6277),
(878, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '928880822', 'ACTIVE', 15.75, 1, 1, 6277),
(877, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '-520057078', 'ACTIVE', 12.2, 1, 1, 6276),
(876, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '-2021107578', 'ACTIVE', 12.2, 1, 1, 6276),
(875, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '2132845247', 'ACTIVE', 11.1, 1, 1, 6275),
(874, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '632718268', 'ACTIVE', 11.1, 1, 1, 6275),
(873, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '1726407862', 'ACTIVE', 14.5, 1, 1, 6274),
(872, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '227204404', 'ACTIVE', 14.5, 1, 1, 6274),
(871, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '1532046053', 'ACTIVE', 13, 1, 1, 6273),
(870, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '33766116', 'ACTIVE', 13, 1, 1, 6273),
(869, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '-719610928', 'ACTIVE', 6.5, 1, 1, 6272),
(868, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '2077999952', 'ACTIVE', 6.5, 1, 1, 6272),
(867, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '522766419', 'ACTIVE', 12, 1, 1, 6271),
(866, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '-973666476', 'ACTIVE', 12, 1, 1, 6271),
(865, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '1827511197', 'ACTIVE', 9.75, 1, 1, 6270),
(864, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '332001823', 'ACTIVE', 9.75, 1, 1, 6270),
(863, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '-2075330882', 'ACTIVE', 16, 1, 1, 6269),
(862, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '725050561', 'ACTIVE', 16, 1, 1, 6269),
(861, '2019-08-12 14:08:36', '2019-08-12 14:08:35', NULL, 'Langage C++ et POO', '-1571416260', 'ACTIVE', 14.75, 1, 1, 6268),
(860, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '1229888704', 'ACTIVE', 14.75, 1, 1, 6268),
(859, '2019-08-12 14:08:36', '2019-08-12 14:08:35', NULL, 'Langage C++ et POO', '1141930300', 'ACTIVE', 14.75, 1, 1, 6267),
(858, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '-350808511', 'ACTIVE', 14.75, 1, 1, 6267);

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

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `code` bigint(20) NOT NULL,
  `code_module` varchar(255) DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `signature` (`signature`),
  KEY `FK_Module_modificateur` (`modificateur`),
  KEY `FK_Module_createur` (`createur`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `module`
--

INSERT INTO `module` (`code`, `code_module`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1801, 'LP001', '2019-08-05 17:55:23', '2019-08-05 17:55:23', '', 'Stage', '1519622815', 'ACTIVE', 1, 1),
(1126, 'LP324', '2019-08-02 16:05:36', '2019-08-02 16:05:36', 'L3 Semestre 6', 'Stage et Ethique', '41851139', 'ACTIVE', 1, 1),
(1125, 'LP323', '2019-08-02 16:05:35', '2019-08-02 16:05:36', 'L3 Semestre 6', 'Applications pour mobiles', '41850516', 'ACTIVE', 1, 1),
(1124, 'LP322', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 6', 'ERP et Projet', '41848743', 'ACTIVE', 1, 1),
(1123, 'LP321', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 6', 'Java EE et Technologie.NET', '41848028', 'ACTIVE', 1, 1),
(1122, 'LP000', '2019-08-02 16:05:35', '2019-08-05 17:53:39', 'L3 Semestre 5', 'Expression Anglaise, Sagesse et Science', '1253183312', 'ACTIVE', 1, 1),
(1121, 'LP314', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 5', 'Outils de management', '41845369', 'ACTIVE', 1, 1),
(1120, 'LP313', '2019-08-02 16:05:34', '2019-08-02 16:05:35', 'L3 Semestre 5', 'Administration système et Gestion des projets', '41844614', 'ACTIVE', 1, 1),
(1119, 'LP312', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L3 Semestre 5', 'Ingénierie du Logiciel et Big Data', '41843003', 'ACTIVE', 1, 1),
(1118, 'LP311', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L3 Semestre 5', 'Administration de Base de données et R.O.', '41841963', 'ACTIVE', 1, 1),
(1117, 'LP224', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Communication et Stage', '41841355', 'ACTIVE', 1, 1),
(1116, 'LP223', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'sécurité informatique et Projet d\'équipe', '41840233', 'ACTIVE', 1, 1),
(1115, 'LP222', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Culture de l’entreprise', '41839357', 'ACTIVE', 1, 1),
(1114, 'LP221', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Langage C++ et Programmation Web2', '41837746', 'ACTIVE', 1, 1),
(1113, 'LP214', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Communication et Ethique', '41836652', 'ACTIVE', 1, 1),
(1112, 'LP213', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Réseaux et Système d’exploitation', '41836040', 'ACTIVE', 1, 1),
(1111, 'LP212', '2019-08-02 16:05:33', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Algèbre, POO et Base de données', '41834922', 'ACTIVE', 1, 1),
(1110, 'LP211', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L2 Semestre 3', 'Complexité et modélisation UML', '41834043', 'ACTIVE', 1, 1),
(1109, 'LP124', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Communication et Réflexion Humaine2', '41832450', 'ACTIVE', 1, 1),
(1108, 'LP123', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Mathématiques et Logique', '41831321', 'ACTIVE', 1, 1),
(1107, 'LP122', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Analyse et Algorithmique Structuré', '41830783', 'ACTIVE', 1, 1),
(1106, 'LP121', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Java1 et Programmation en C', '41829673', 'ACTIVE', 1, 1),
(1105, 'LP114', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Communication Bilingue et Réflexion Humaine', '41827866', 'ACTIVE', 1, 1),
(1104, 'LP113', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Mathématiques appliquées pour l’informatique', '41827300', 'ACTIVE', 1, 1),
(1103, 'LP112', '2019-08-02 16:05:32', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Economie Numérique, Algorithmique et Programmation Web1', '41826263', 'ACTIVE', 1, 1),
(1102, 'LP111', '2019-08-02 16:05:32', '2019-08-02 16:05:32', 'L1 Semestre 1', 'systèmes d\'information et Architecture', '41825336', 'ACTIVE', 1, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `niveau`
--

INSERT INTO `niveau` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(7, '2019-08-02 10:37:15', '2019-08-05 09:19:56', 'Premiere Année', 'Niveau 1', 1, '-124548899', 'ACTIVE', 1, 1),
(8, '2019-08-02 10:37:26', '2019-08-05 09:21:20', 'Deuxieme Année', 'Niveau 2', 2, '-112546938', 'ACTIVE', 1, 1),
(9, '2019-08-02 10:37:31', '2019-08-05 09:21:53', 'Troisième Année', 'Niveau 3', 3, '-107325793', 'ACTIVE', 1, 1),
(10, '2019-08-02 10:38:04', '2019-08-05 09:22:56', 'Quatrième Année', 'Niveau 4', 4, '-74181832', 'ACTIVE', 1, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=6968 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `note`
--

INSERT INTO `note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero_table`, `signature`, `statut_vie`, `valeur_note`, `createur`, `evaluation`, `modificateur`, `est_inscrit`) VALUES
(6967, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'EXA', 'Éthique et Philosophie', 24, '2098908625', 'ACTIVE', 14, 1, 6249, 1, 6420),
(6966, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'CC', 'Éthique et Philosophie', 4, '-1516611805', 'ACTIVE', 16, 1, 6231, 1, 6420),
(6965, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'EXA', 'Anglais niveau pratique B1/B2', 18, '-1449729135', 'ACTIVE', 14, 1, 6245, 1, 6419),
(6964, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'CC', 'Anglais niveau pratique B1/B2', 3, '1262754890', 'ACTIVE', 14.4, 1, 6227, 1, 6419),
(6963, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Systèmes d\'exploitation', 21, '1739262478', 'ACTIVE', 17.5, 1, 6263, 1, 6418),
(6962, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Systèmes d\'exploitation', 22, '1427585580', 'ACTIVE', 11, 1, 6253, 1, 6418),
(6961, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Systèmes d\'exploitation', 7, '-1260486830', 'ACTIVE', 12.5, 1, 6235, 1, 6418),
(6960, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Introduction aux Réseaux informatiques', 18, '63556781', 'ACTIVE', 10.75, 1, 6255, 1, 6417),
(6959, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Introduction aux Réseaux informatiques', 14, '878533126', 'ACTIVE', 9.5, 1, 6237, 1, 6417),
(6951, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Algèbre linaire I', 24, '-968714662', 'ACTIVE', 18.33, 1, 6243, 1, 6414),
(6952, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Algèbre linaire I', 25, '-360355024', 'ACTIVE', 19, 1, 6260, 1, 6414),
(6953, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Programmation Orientée Objet II', 25, '209491517', 'ACTIVE', 14.75, 1, 6234, 1, 6415),
(6954, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Programmation Orientée Objet II', 2, '1403736576', 'ACTIVE', 7, 1, 6252, 1, 6415),
(6955, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Programmation Orientée Objet II', 11, '1168142587', 'ACTIVE', 16.5, 1, 6262, 1, 6415),
(6956, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Introduction aux Base de données', 5, '-1896186393', 'ACTIVE', 12.25, 1, 6236, 1, 6416),
(6957, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Introduction aux Base de données', 8, '-1250150641', 'ACTIVE', 17.25, 1, 6254, 1, 6416),
(6958, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Introduction aux Base de données', 14, '-368844606', 'ACTIVE', 16, 1, 6264, 1, 6416),
(6950, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 16, '-506194770', 'ACTIVE', 12, 1, 6251, 1, 6412),
(6946, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Introduction à la sécurité informatique', 9, '1281425521', 'ACTIVE', 11.5, 1, 6258, 1, 6409),
(6947, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Algorithmique et Complexité', 18, '-788473868', 'ACTIVE', 12, 1, 6232, 1, 6411),
(6948, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Algorithmique et Complexité', 5, '-1810460163', 'ACTIVE', 9, 1, 6250, 1, 6411),
(6949, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'modélisation des Systèmes d\'Information(UML)', 13, '27078038', 'ACTIVE', 12.75, 1, 6233, 1, 6412),
(6943, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'économie numérique', 10, '1016103447', 'ACTIVE', 18.17, 1, 6241, 1, 6408),
(6944, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'économie numérique', 25, '1312660156', 'ACTIVE', 12.5, 1, 6259, 1, 6408),
(6945, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Introduction à la sécurité informatique', 14, '-976183367', 'ACTIVE', 12.88, 1, 6240, 1, 6409),
(6937, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'Anglais Niveau pratique B2', 19, '-1181068069', 'ACTIVE', 12.5, 1, 6228, 1, 6404),
(6938, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'Anglais Niveau pratique B2', 9, '2025778216', 'ACTIVE', 15.2, 1, 6246, 1, 6404),
(6939, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'Ethique et Développement    ', 18, '-468081918', 'ACTIVE', 13.5, 1, 6230, 1, 6405),
(6940, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'Ethique et Développement    ', 7, '-334849862', 'ACTIVE', 17.5, 1, 6248, 1, 6405),
(6941, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 24, '-1582024002', 'ACTIVE', 14.33, 1, 6229, 1, 6407),
(6942, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 21, '-38323471', 'ACTIVE', 13, 1, 6247, 1, 6407),
(6936, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'TP', 'Programmation Web II', 10, '1659968000', 'ACTIVE', 14.5, 1, 6266, 1, 6403),
(6934, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Programmation Web II', 20, '1976585300', 'ACTIVE', 14, 1, 6239, 1, 6403),
(6935, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Programmation Web II', 25, '1976228664', 'ACTIVE', 16.5, 1, 6257, 1, 6403),
(6932, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Algèbre linéaire II', 21, '-957147805', 'ACTIVE', 16.25, 1, 6244, 1, 6413),
(6933, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Algèbre linéaire II', 3, '1534726705', 'ACTIVE', 14, 1, 6261, 1, 6413),
(6931, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'TP', 'Langage C++ et POO', 20, '-360426891', 'ACTIVE', 16, 1, 6265, 1, 6402),
(6926, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Anglais niveau pratique B1/B2', 15, '1055377856', 'ACTIVE', 13.4, 1, 6245, 1, 6833),
(6927, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Éthique et Philosophie', 3, '609071466', 'ACTIVE', 15.75, 1, 6231, 1, 6834),
(6928, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Éthique et Philosophie', 18, '1478671768', 'ACTIVE', 17.75, 1, 6249, 1, 6834),
(6930, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Langage C++ et POO', 1, '1679180139', 'ACTIVE', 16, 1, 6256, 1, 6402),
(6929, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Langage C++ et POO', 7, '-1720573449', 'ACTIVE', 15.33, 1, 6238, 1, 6402),
(6925, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Anglais niveau pratique B1/B2', 21, '-1642523596', 'ACTIVE', 16, 1, 6227, 1, 6833),
(6923, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Systèmes d\'exploitation', 20, '-150161336', 'ACTIVE', 15, 1, 6253, 1, 6832),
(6924, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'TP', 'Systèmes d\'exploitation', 20, '-1231845138', 'ACTIVE', 18.25, 1, 6263, 1, 6832),
(6922, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Systèmes d\'exploitation', 14, '1610009698', 'ACTIVE', 13.5, 1, 6235, 1, 6832),
(6921, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Introduction aux Réseaux informatiques', 12, '90117021', 'ACTIVE', 10.5, 1, 6255, 1, 6831),
(6920, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Introduction aux Réseaux informatiques', 22, '-1741159575', 'ACTIVE', 10, 1, 6237, 1, 6831),
(6919, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'TP', 'Introduction aux Base de données', 7, '1866204762', 'ACTIVE', 12, 1, 6264, 1, 6830),
(6918, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Introduction aux Base de données', 15, '951383112', 'ACTIVE', 9.25, 1, 6254, 1, 6830),
(6917, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'CC', 'Introduction aux Base de données', 18, '302525619', 'ACTIVE', 12.25, 1, 6236, 1, 6830),
(6916, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'TP', 'Programmation Orientée Objet II', 13, '-1704713044', 'ACTIVE', 17.75, 1, 6262, 1, 6829),
(6915, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Programmation Orientée Objet II', 9, '-253134957', 'ACTIVE', 12.5, 1, 6252, 1, 6829),
(6913, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Algèbre linaire I', 11, '50375616', 'ACTIVE', 11.5, 1, 6260, 1, 6828),
(6914, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'CC', 'Programmation Orientée Objet II', 11, '680584593', 'ACTIVE', 13.25, 1, 6234, 1, 6829),
(6912, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'CC', 'Algèbre linaire I', 20, '1761550046', 'ACTIVE', 14, 1, 6243, 1, 6828),
(6910, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'CC', 'modélisation des Systèmes d\'Information(UML)', 8, '-2103005851', 'ACTIVE', 12.75, 1, 6233, 1, 6826),
(6911, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 10, '-1238004792', 'ACTIVE', 12, 1, 6251, 1, 6826),
(6909, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'EXA', 'Algorithmique et Complexité', 13, '-417659134', 'ACTIVE', 15, 1, 6250, 1, 6825),
(6907, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'EXA', 'Introduction à la sécurité informatique', 11, '-1806584234', 'ACTIVE', 9.25, 1, 6258, 1, 6823),
(6908, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'CC', 'Algorithmique et Complexité', 14, '-1935899912', 'ACTIVE', 11.83, 1, 6232, 1, 6825),
(6904, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'CC', 'économie numérique', 5, '1667562774', 'ACTIVE', 16, 1, 6241, 1, 6822),
(6905, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'EXA', 'économie numérique', 5, '-1797732714', 'ACTIVE', 15, 1, 6259, 1, 6822),
(6906, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'CC', 'Introduction à la sécurité informatique', 16, '-1704626758', 'ACTIVE', 9.63, 1, 6240, 1, 6823),
(6903, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 9, '1421583147', 'ACTIVE', 16, 1, 6247, 1, 6821),
(6902, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 16, '-800246776', 'ACTIVE', 15, 1, 6229, 1, 6821),
(6883, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'CC', 'Ethique et Développement    ', 4, '1564787897', 'ACTIVE', 15.75, 1, 6230, 1, 6819),
(6901, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'EXA', 'Ethique et Développement    ', 16, '688467954', 'ACTIVE', 14.5, 1, 6248, 1, 6819),
(6882, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'EXA', 'Anglais Niveau pratique B2', 8, '-927086301', 'ACTIVE', 12.2, 1, 6246, 1, 6818),
(6881, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'CC', 'Anglais Niveau pratique B2', 3, '-1685393766', 'ACTIVE', 11.1, 1, 6228, 1, 6818),
(6878, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'CC', 'Programmation Web II', 1, '-1303699301', 'ACTIVE', 6.5, 1, 6239, 1, 6817),
(6879, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'EXA', 'Programmation Web II', 14, '-134661348', 'ACTIVE', 13, 1, 6257, 1, 6817),
(6880, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'TP', 'Programmation Web II', 5, '-424752414', 'ACTIVE', 14.5, 1, 6266, 1, 6817),
(6877, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'EXA', 'Algèbre linéaire II', 21, '408880529', 'ACTIVE', 12, 1, 6261, 1, 6827),
(6876, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'CC', 'Algèbre linéaire II', 14, '242371540', 'ACTIVE', 9.75, 1, 6244, 1, 6827),
(6875, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'TP', 'Langage C++ et POO', 23, '283402415', 'ACTIVE', 16, 1, 6265, 1, 6816),
(6874, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'EXA', 'Langage C++ et POO', 10, '-883604236', 'ACTIVE', 14.75, 1, 6256, 1, 6816),
(6873, '2019-08-12 14:12:18', '2019-08-12 14:12:18', 'CC', 'Langage C++ et POO', 4, '302848933', 'ACTIVE', 14.75, 1, 6238, 1, 6816);

--
-- Déclencheurs `note`
--
DROP TRIGGER IF EXISTS `After_InsertNote`;
DELIMITER $$
CREATE TRIGGER `After_InsertNote` AFTER INSERT ON `note` FOR EACH ROW INSERT INTO historique_note(date_creation,date_modification,libelle,signature,statut_vie,valeur_note,createur,modificateur,note)
VALUES (NEW.date_creation,NEW.date_modification,NEW.libelle,NEW.signature,NEW.statut_vie,NEW.valeur_note,NEW.createur,NEW.modificateur,NEW.code)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `After_UpdateNote`;
DELIMITER $$
CREATE TRIGGER `After_UpdateNote` AFTER UPDATE ON `note` FOR EACH ROW INSERT INTO historique_note(date_creation,date_modification,libelle,signature,statut_vie,valeur_note,createur,modificateur,note)
VALUES (NEW.date_creation,CURRENT_TIMESTAMP,NEW.libelle,NEW.signature,NEW.statut_vie,NEW.valeur_note,NEW.createur,NEW.modificateur,NEW.code)
$$
DELIMITER ;

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
) ENGINE=MyISAM AUTO_INCREMENT=709 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `semestre`
--

INSERT INTO `semestre` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `annee_academique`, `createur`, `modificateur`) VALUES
(552, '2017-01-30 23:00:00', '2019-08-02 11:49:24', '2016-08-31 22:00:00', '2019-08-02 11:49:24', 'Semestre 1 Année Académique 2016/2017', 'Semestre 1', '1700279277', 'ACTIVE', 206, 1, 1),
(702, '2017-08-30 22:00:00', '2019-08-02 12:00:08', '2017-01-31 23:00:00', '2019-08-02 12:00:08', 'Semestre 2 Année Académique 2016/2017', 'Semestre 2', '-1208243154', 'ACTIVE', 206, 1, 1),
(703, '2018-01-30 23:00:00', '2019-08-02 12:01:43', '2017-08-31 22:00:00', '2019-08-02 12:01:43', 'Semestre 1 Année Académique 2017/2018', 'Semestre 1', '-4118364', 'ACTIVE', 352, 1, 1),
(704, '2018-08-30 22:00:00', '2019-08-02 12:02:19', '2018-01-31 23:00:00', '2019-08-02 12:02:19', 'Semestre 2 Année Académique 2017/2018', 'Semestre 2', '-1246274931', 'ACTIVE', 352, 1, 1),
(705, '2019-01-30 23:00:00', '2019-08-02 12:03:11', '2018-08-31 22:00:00', '2019-08-02 12:03:11', 'Semestre 1 Année Académique 2018/2019', 'Semestre 1', '-83778770', 'ACTIVE', 353, 1, 1),
(706, '2019-08-30 22:00:00', '2019-08-02 12:03:35', '2019-01-31 23:00:00', '2019-08-02 12:03:35', 'Semestre 2 Année Académique 2018/2019', 'Semestre 2', '-1336497688', 'ACTIVE', 353, 1, 1),
(707, '2020-01-30 23:00:00', '2019-08-02 12:04:13', '2019-08-31 22:00:00', '2019-08-02 12:04:13', 'Semestre 1 Année Académique 2019/2020', 'Semestre 1', '-187611209', 'ACTIVE', 354, 1, 1),
(708, '2020-08-30 22:00:00', '2019-08-02 12:04:40', '2020-01-31 23:00:00', '2019-08-02 12:04:40', 'Semestre 2 Année Académique 2019/2020', 'Semestre 2', '-1350855887', 'ACTIVE', 354, 1, 1);

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
('SEQ_GEN', '7000');

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
) ENGINE=MyISAM AUTO_INCREMENT=5902 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`code`, `date_connection`, `date_creation`, `date_deconnection`, `date_modification`, `description`, `libelle`, `machine_cliente`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `utilisateur`) VALUES
(1, '2019-08-09 11:29:00', '2019-08-09 11:29:00', NULL, '2019-08-09 11:29:00', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1725601648', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(651, '2019-08-10 12:32:35', '2019-08-10 12:32:35', NULL, '2019-08-10 12:32:36', NULL, NULL, 'DESKTOP-7OQ9KG8', '2059049372', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(701, '2019-08-10 12:41:33', '2019-08-10 12:41:33', NULL, '2019-08-10 12:41:33', NULL, NULL, 'DESKTOP-7OQ9KG8', '1610255594', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(751, '2019-08-10 12:47:13', '2019-08-10 12:47:13', NULL, '2019-08-10 12:47:13', NULL, NULL, 'DESKTOP-7OQ9KG8', '-364273419', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(851, '2019-08-10 12:50:27', '2019-08-10 12:50:27', NULL, '2019-08-10 12:50:27', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1799416018', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(951, '2019-08-10 12:57:19', '2019-08-10 12:57:19', NULL, '2019-08-10 12:57:20', NULL, NULL, 'DESKTOP-7OQ9KG8', '-2084913704', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1051, '2019-08-10 13:33:45', '2019-08-10 13:33:45', NULL, '2019-08-10 13:33:45', NULL, NULL, 'DESKTOP-7OQ9KG8', '-487388409', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1501, '2019-08-10 13:56:17', '2019-08-10 13:56:17', NULL, '2019-08-10 13:56:18', NULL, NULL, 'DESKTOP-7OQ9KG8', '110638933', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1551, '2019-08-10 13:57:34', '2019-08-10 13:57:34', NULL, '2019-08-10 13:57:34', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1016877597', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2051, '2019-08-10 15:42:47', '2019-08-10 15:42:47', NULL, '2019-08-10 15:42:47', NULL, NULL, 'DESKTOP-7OQ9KG8', '-104066253', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2351, '2019-08-10 16:01:38', '2019-08-10 16:01:38', NULL, '2019-08-10 16:01:38', NULL, NULL, 'DESKTOP-7OQ9KG8', '1425931701', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2551, '2019-08-10 16:06:52', '2019-08-10 16:06:52', NULL, '2019-08-10 16:06:52', NULL, NULL, 'DESKTOP-7OQ9KG8', '847038573', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2751, '2019-08-10 16:13:04', '2019-08-10 16:13:04', NULL, '2019-08-10 16:13:04', NULL, NULL, 'DESKTOP-7OQ9KG8', '2042757575', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2801, '2019-08-10 16:27:41', '2019-08-10 16:27:41', NULL, '2019-08-10 16:27:41', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1104375566', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2851, '2019-08-10 17:10:37', '2019-08-10 17:10:37', NULL, '2019-08-10 17:10:37', NULL, NULL, 'DESKTOP-7OQ9KG8', '1382571134', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2901, '2019-08-10 17:21:49', '2019-08-10 17:21:49', NULL, '2019-08-10 17:21:49', NULL, NULL, 'DESKTOP-7OQ9KG8', '-480590968', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2951, '2019-08-10 17:29:25', '2019-08-10 17:29:25', NULL, '2019-08-10 17:29:25', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1739895765', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3051, '2019-08-10 17:34:25', '2019-08-10 17:34:25', NULL, '2019-08-10 17:34:25', NULL, NULL, 'DESKTOP-7OQ9KG8', '1345567361', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3701, '2019-08-10 17:43:42', '2019-08-10 17:43:42', NULL, '2019-08-10 17:43:42', NULL, NULL, 'DESKTOP-7OQ9KG8', '497754422', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3901, '2019-08-10 17:56:17', '2019-08-10 17:56:17', NULL, '2019-08-10 17:56:17', NULL, NULL, 'DESKTOP-7OQ9KG8', '-555093202', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3951, '2019-08-10 17:58:43', '2019-08-10 17:58:43', NULL, '2019-08-10 17:58:43', NULL, NULL, 'DESKTOP-7OQ9KG8', '1912942846', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4001, '2019-08-10 18:01:21', '2019-08-10 18:01:21', NULL, '2019-08-10 18:01:21', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1995219410', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4051, '2019-08-12 10:33:46', '2019-08-12 10:33:46', NULL, '2019-08-12 10:33:46', NULL, NULL, 'DESKTOP-7OQ9KG8', '1800415695', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4101, '2019-08-12 12:23:42', '2019-08-12 12:23:42', NULL, '2019-08-12 12:23:43', NULL, NULL, 'DESKTOP-7OQ9KG8', '-632048294', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4151, '2019-08-12 12:36:00', '2019-08-12 12:36:00', NULL, '2019-08-12 12:36:00', NULL, NULL, 'DESKTOP-7OQ9KG8', '633683585', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4201, '2019-08-12 12:53:01', '2019-08-12 12:53:01', NULL, '2019-08-12 12:53:01', NULL, NULL, 'DESKTOP-7OQ9KG8', '-752046661', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4351, '2019-08-12 13:04:26', '2019-08-12 13:04:26', NULL, '2019-08-12 13:04:26', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1394423371', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4401, '2019-08-12 13:08:01', '2019-08-12 13:08:01', NULL, '2019-08-12 13:08:01', NULL, NULL, 'DESKTOP-7OQ9KG8', '1015840962', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4451, '2019-08-12 13:31:54', '2019-08-12 13:31:54', NULL, '2019-08-12 13:31:54', NULL, NULL, 'DESKTOP-7OQ9KG8', '1814434432', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4801, '2019-08-12 13:35:59', '2019-08-12 13:35:59', NULL, '2019-08-12 13:35:59', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1073109206', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(5901, '2019-08-12 13:59:24', '2019-08-12 13:59:24', NULL, '2019-08-12 13:59:24', NULL, NULL, 'DESKTOP-7OQ9KG8', '-2036671878', 'ACTIF', 'ACTIVE', 1, 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sms`
--

DROP TABLE IF EXISTS `sms`;
CREATE TABLE IF NOT EXISTS `sms` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`code`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

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
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `specialite`
--

INSERT INTO `specialite` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `filiere`, `modificateur`) VALUES
(4, '2019-08-02 10:33:08', '2019-08-02 10:33:08', '', 'Génie logiciel', '-1352277424', 'ACTIVE', 1, 2, 1),
(5, '2019-08-02 10:33:48', '2019-08-02 10:33:48', '', 'Informatique et système d\'information', '-1350793609', 'ACTIVE', 1, 3, 1),
(6, '2019-08-02 10:34:32', '2019-08-02 10:34:32', '', 'Système réseau et télécommunication', '-1349389185', 'ACTIVE', 1, 3, 1),
(57, '2019-08-02 10:59:00', '2019-08-02 10:59:00', '', 'Tronc commun', '657213468', 'ACTIVE', 1, 3, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=6227 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `type_evaluation`
--

INSERT INTO `type_evaluation` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `pourcentage`, `signature`, `statut_vie`, `createur`, `enseignement`, `modificateur`) VALUES
(6225, '2019-08-12 14:05:39', '2019-08-12 14:05:39', 'Session normale', 'SN', 70, '-1478814358', 'ACTIVE', 1, 6115, 1),
(6224, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '-1787604862', 'ACTIVE', 1, 6115, 1),
(6223, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 70, '-1918548074', 'ACTIVE', 1, 6105, 1),
(6222, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 70, '-1916060045', 'ACTIVE', 1, 6105, 1),
(6218, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 20, '1399066508', 'ACTIVE', 1, 6104, 1),
(6219, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 50, '1727293981', 'ACTIVE', 1, 6104, 1),
(6220, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Travaux pratiques', 'TP', 30, '1553455157', 'ACTIVE', 1, 6104, 1),
(6221, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '2037048737', 'ACTIVE', 1, 6105, 1),
(6217, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 50, '1735185713', 'ACTIVE', 1, 6104, 1),
(6216, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 70, '1044860384', 'ACTIVE', 1, 6103, 1),
(6215, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 70, '1020076194', 'ACTIVE', 1, 6103, 1),
(6214, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '698911854', 'ACTIVE', 1, 6103, 1),
(6213, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 50, '1913154051', 'ACTIVE', 1, 6102, 1),
(6212, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Travaux pratiques', 'TP', 30, '1745678008', 'ACTIVE', 1, 6102, 1),
(6210, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 20, '1578737738', 'ACTIVE', 1, 6102, 1),
(6211, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 50, '1926983802', 'ACTIVE', 1, 6102, 1),
(6207, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 20, '612928894', 'ACTIVE', 1, 6101, 1),
(6209, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Travaux pratiques', 'TP', 30, '798821045', 'ACTIVE', 1, 6101, 1),
(6208, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 50, '952676835', 'ACTIVE', 1, 6101, 1),
(6204, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 30, '1695689673', 'ACTIVE', 1, 6069, 1),
(6206, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 70, '1997298624', 'ACTIVE', 1, 6069, 1),
(6205, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 70, '1999679982', 'ACTIVE', 1, 6069, 1),
(6203, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 70, '2028775677', 'ACTIVE', 1, 6108, 1),
(6201, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 30, '1681155968', 'ACTIVE', 1, 6108, 1),
(6166, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Session normale', 'SN', 70, '975489392', 'ACTIVE', 1, 6068, 1),
(6202, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 70, '2021698873', 'ACTIVE', 1, 6108, 1),
(6167, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Rattrapages ', 'RA', 70, '981463929', 'ACTIVE', 1, 6068, 1),
(6165, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Controle continu', 'CC', 30, '661258667', 'ACTIVE', 1, 6068, 1),
(6164, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Rattrapages ', 'RA', 70, '74472129', 'ACTIVE', 1, 6067, 1),
(6163, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Session normale', 'SN', 70, '69599859', 'ACTIVE', 1, 6067, 1),
(6162, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Controle continu', 'CC', 30, '-271156388', 'ACTIVE', 1, 6067, 1),
(6161, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '1819295856', 'ACTIVE', 1, 6113, 1),
(6160, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '1833197682', 'ACTIVE', 1, 6113, 1),
(6159, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '1520033667', 'ACTIVE', 1, 6113, 1),
(6158, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '1154192819', 'ACTIVE', 1, 6112, 1),
(6157, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '1129550857', 'ACTIVE', 1, 6112, 1),
(6156, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '806999794', 'ACTIVE', 1, 6112, 1),
(6153, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '-40126511', 'ACTIVE', 1, 6111, 1),
(6154, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '281037829', 'ACTIVE', 1, 6111, 1),
(6155, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '268202713', 'ACTIVE', 1, 6111, 1),
(6152, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '-977573508', 'ACTIVE', 1, 6110, 1),
(6151, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '-983156918', 'ACTIVE', 1, 6110, 1),
(6150, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Controle continu', 'CC', 30, '-1286400530', 'ACTIVE', 1, 6110, 1),
(6149, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 100, '1807274031', 'ACTIVE', 1, 6116, 1),
(6148, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '1536689863', 'ACTIVE', 1, 6106, 1),
(6147, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Rattrapages ', 'RA', 70, '1513932422', 'ACTIVE', 1, 6106, 1),
(6146, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Controle continu', 'CC', 30, '1192305841', 'ACTIVE', 1, 6106, 1),
(6145, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '-2056635918', 'ACTIVE', 1, 6114, 1),
(6142, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Travaux pratiques', 'TP', 30, '-1925473971', 'ACTIVE', 1, 6109, 1),
(6144, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Rattrapages ', 'RA', 70, '-2062503784', 'ACTIVE', 1, 6114, 1),
(6143, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Controle continu', 'CC', 30, '1894445154', 'ACTIVE', 1, 6114, 1),
(6141, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Rattrapages ', 'RA', 30, '-1928355049', 'ACTIVE', 1, 6109, 1),
(6138, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Rattrapages ', 'RA', 50, '722281355', 'ACTIVE', 1, 6107, 1),
(6140, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Session normale', 'SN', 50, '-1772294725', 'ACTIVE', 1, 6109, 1),
(6139, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Controle continu', 'CC', 20, '-2116842861', 'ACTIVE', 1, 6109, 1),
(6137, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Travaux pratiques', 'TP', 30, '521381732', 'ACTIVE', 1, 6107, 1),
(6136, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Session normale', 'SN', 50, '708945558', 'ACTIVE', 1, 6107, 1),
(6135, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Controle continu', 'CC', 20, '339827535', 'ACTIVE', 1, 6107, 1),
(6226, '2019-08-12 14:05:39', '2019-08-12 14:05:39', 'Rattrapages ', 'RA', 70, '-1467328486', 'ACTIVE', 1, 6115, 1);

-- --------------------------------------------------------

--
-- Structure de la table `ue`
--

DROP TABLE IF EXISTS `ue`;
CREATE TABLE IF NOT EXISTS `ue` (
  `code` bigint(20) NOT NULL AUTO_INCREMENT,
  `code_ue` varchar(255) DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
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
) ENGINE=MyISAM AUTO_INCREMENT=6048 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ue`
--

INSERT INTO `ue` (`code`, `code_ue`, `credits`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `module`, `niveau`, `specialite`) VALUES
(6047, 'SAS451', 1, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Sagesse et science2', '-1676602354', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(6043, 'INF362', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Enterprise Resource Planning (ERP)', '-610263718', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(6044, 'INF365', 3, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Projet Tutoré', '-2091968107', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(6045, 'INF364', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Conception et Développement d’applications pour mobiles', '885629586', 'ACTIVE', 'ACTIVE', 1, 1, 1125, 9, 4),
(6046, 'STG361', 10, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Stage Professionnel', '1936002499', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(6038, 'COM351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Fondamentaux de la communication', '1056905378', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6039, 'ANG351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Anglais pratique', '161649411', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6040, 'SAS351', 1, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Sagesse et science1', '-95474378', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6041, 'INF361', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'JEE(Programmation par Objets avancée)', '2128180871', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(6042, 'INF363', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Technologie.NET', '1006331350', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(6037, 'MKT351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Marketing Informatique', '1450441429', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6034, 'INF355', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Sécurité avancée des réseaux et systèmes', '-1855207364', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(6035, 'INF356', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Gestion des Projets informatique', '86779590', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(6036, 'ATE351', 2, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Ateliers de création d\'entreprise', '-1276758353', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6033, 'INF354', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Introduction au Big Data', '1120268651', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(6032, 'INF352', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Ingénierie du Génie Logiciel', '-2049089083', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(6031, 'MAT351', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Recherche opérationnelle et aide à la décision', '-1090962945', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(6029, 'STG241', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Stage Technique', '-112629072', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6030, 'INF351', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '1726451090', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(6028, 'ETH241', 1, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Éthique et Philosophie', '1489970125', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6027, 'ANG241', 2, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Anglais Niveau pratique B2', '2101404059', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6025, 'INF243', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction à la sécurité informatique', '1804389895', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(6026, 'INF245', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Projets tutorés', '-1830197205', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(6022, 'INF242', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Programmation Web II', '-1394241732', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6023, 'ENV241', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'L\'entreprise et la gestion, environnement comptable, financier', '-1996238929', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(6024, 'INF244', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'économie numérique', '1025392186', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(6020, 'INF241', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Langage C++ et POO', '-1967549909', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6021, 'MAT241', 2, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Algèbre linéaire II', '-415709806', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6019, 'ETH231', 1, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Ethique et Développement    ', '418557758', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(6015, 'INF235', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction aux Base de données', '1117098552', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6016, 'INF236', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction aux Réseaux informatiques', '1192377288', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(6018, 'ANG231', 2, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Anglais niveau pratique B1/B2', '43146116', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(6017, 'INF234', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Systèmes d\'exploitation', '-1538264342', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(6014, 'INF233', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Programmation Orientée Objet II', '283860640', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6012, 'INF232', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'modélisation des Systèmes d\'Information(UML)', '-341529405', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(6013, 'MAT231', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algèbre linaire I', '-16969748', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6010, 'STA121', 3, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Stage découverte de l’entreprise', '-492412225', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6011, 'INF231', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algorithmique et Complexité', '-713152904', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(6009, 'REF112', 1, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Réflexion Humaine 2', '-1574876759', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6007, 'EXP121', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Communication Orale, Ecrite et audio Visual', '-357196587', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6008, 'ANG121', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Anglais niveau pratique B1', '1728661700', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6006, 'INF125', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Logique pour l\'Informatique', '1717387095', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(5959, 'REF111', 2, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Réflexion Humaine1', '-470066443', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(6001, 'INF121', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Initiation Programmation orientée objet I', '1594107048', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(6002, 'INF124', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Initiation à la programmation C', '276007637', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(6003, 'INF123', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:50', '', 'Introduction à l\'Analyse Merise', '-1281114476', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(6004, 'INF122', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algorithmique et Structure de données I', '-1949933057', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(6005, 'MAT121', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Mathématiques discrètes II', '524905718', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(5958, 'ANG111', 2, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Anglais Remise à niveau A2', '-1935705414', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(5953, 'INF112', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Programmation Web I', '-577965367', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5957, 'MAT112', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Mathématiques discrètes I', '-1034700067', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(5956, 'MAT111', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Mathématiques pour l\'informatique', '901939799', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(5955, 'INF114', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Introduction aux algorithmes', '943922743', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5954, 'INF115', 2, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Enjeux de l’économie Numérique', '-1946344577', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5952, 'INF113', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Architecture des ordinateurs', '-1568829338', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4),
(5951, 'INF111', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Introduction aux systèmes d\'information', '-1260997468', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4);

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
(1, '2019-04-08 12:52:09', '2019-05-19 11:51:08', '1990-04-09 00:00:00', NULL, 'channeldonkeng@gmail.com', NULL, 'channel', 'BA-32-53-87-6A-ED-6B-C2-2D-4A-6F-F5-3D-84-6-C6-AD-86-41-95-ED-14-4A-B5-C8-76-21-B6-C2-33-B5-48-BA-EA-E6-95-6D-F3-46-EC-8C-17-F5-EA-10-F3-5E-E3-CB-C5-14-79-7E-D7-DD-D3-14-54-64-E2-A0-BA-B4-13', 'Donkeng', 'Channel', 'FEMININ', '853839448', 'ACTIVE', 'ACTIVE', 656307859, 1, 1);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  mar. 20 août 2019 à 17:05
-- Version du serveur :  10.1.31-MariaDB
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
-- Base de données :  `isj2`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `abs` (IN `niv` INT, IN `fil` VARCHAR(255), IN `ans` INT, IN `sem` VARCHAR(255))  BEGIN
SELECT distinct matricule,CONCAT(nom," ",prenom) as pers,MONTHNAME(date_retard) as mois,nb_heures_absences,heure_justifie,(nb_heures_absences-heure_justifie) as HNJ
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
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
#and classe.niveau=niveau.`code`
and semestre.libelle=sem
and filiere.libelle=fil;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_tmp` (IN `ue` VARCHAR(255))  BEGIN
	#Routine body goes here...
INSERT INTO tmp_ue(tmp_ue.codeue) values(ue);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AFFICHER_NOTE` (IN `eval` VARCHAR(255), IN `code_ue` VARCHAR(255), IN `code_authentification` VARCHAR(255))  BEGIN
	select DISTINCT valeur_note, ue.code_ue as code_ue, type_evaluation.libelle as examen
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite
where note.est_inscrit=est_inscrit.code
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
and ue.code_ue=code_ue
and type_evaluation.libelle=eval
and etudiant.code_authentification=code_authentification
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and niveau.`code`=ue.niveau
and ue.module=module.`code`;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cursus` (IN `mat` VARCHAR(255))  BEGIN
	#Routine body goes here...
	select matricule, CONCAT(filiere.libelle," ",niveau.numero) as niveau,ue.code_ue as codeue,
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
 END) as credits,(case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then CONCAT('Rattrapge',' ',extract(year from annee_academique.date_debut)) when COUNT(case when type_evaluation.libelle='Rattrapage' then 1 else NULL end )=0 then CONCAT('Normale',' ',extract(year from annee_academique.date_debut))end) as Session,semestre.libelle as Semestre,(case when (((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1))=0 then 0
	else CONCAT("-",((TRUNCATE(discipline.nb_heures_absences/5,0))*0.1) + (TRUNCATE(discipline.nb_retards/15,0)*0.1)) end) as penalites
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
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
and etudiant.matricule=`mat`
#and classe.niveau=niveau.`code`
group by ue.libelle
order by annee,semestre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `disci` (IN `an` INT, IN `clib` VARCHAR(255), IN `sem` VARCHAR(255))  NO SQL
BEGIN
	#Routine body goes here...
	SELECT matricule,CONCAT(nom," ",prenom),MONTHNAME(date_retard), SUM(nb_heures_absences)
	FROM candidat,etudiant,discipline,semestre,annee_academique,classe
	WHERE candidat.code=etudiant.code
    and candidat.classe=classe.code
	and etudiant.`code`=discipline.etudiant
	and discipline.semestre=semestre.`code`
	and semestre.annee_academique=annee_academique.`code`
	and EXTRACT(year from annee_academique.date_debut)=an
	and candidat.classe=classe.`code`
	and classe.libelle=clib
	and semestre.libelle=sem
    GROUP BY matricule,MONTHNAME(date_retard)
	order by CONCAT(nom," ",prenom),semestre.libelle asc;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `etud_class` (IN `class` VARCHAR(255), IN `fil` VARCHAR(255), IN `ans` INT)  BEGIN
	#Routine body goes here...
		select DISTINCT matricule, CONCAT(nom, " ", prenom)
from etudiant, filiere,candidat,niveau, classe, specialite, annee_academique, semestre
where extract(year from annee_academique.date_debut)=ans
and candidat.code=etudiant.code
and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and filiere.libelle=fil
and classe.libelle=class;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inf_etud` (IN `mat` VARCHAR(255))  SELECT nom,prenom,date_naissance,sexe,matricule,filiere.libelle as filiere,niveau.numero as niveau
from candidat,filiere,classe,niveau,specialite,etudiant
where candidat.code=etudiant.code
AND candidat.classe=classe.code
AND classe.specialite=specialite.code
AND specialite.filiere=filiere.code
AND classe.niveau=niveau.code
AND etudiant.matricule=mat$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_EnsUe` (IN `codeue` VARCHAR(255))  BEGIN
	#Routine body goes here...
	INSERT INTO EnsUe(ue) values (codeue);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pv` (IN `fil` VARCHAR(255), IN `niv` INT, IN `an` INT, IN `sem` VARCHAR(255))  BEGIN
select DISTINCT matricule,CONCAT(UPPER(nom)," ",UPPER(prenom)) as nom_prenom,module.libelle as module,module.code_module as codemo, ue.libelle as ue,( case when type_evaluation.libelle="Controle continu" then moy_ue_etud_typ_ev(matricule,enseignement.`code`)
else valeur_note END) as moyenne,type_evaluation.libelle as intitule,CONCAT(type_evaluation.pourcentage,"%") as pourcentage,
(case when type_evaluation.libelle="SN" then add_tmp2(ue.code_ue,credits) else 0 END)  as credit,(case when moyenne_ue_etudiant(matricule, enseignement.code)>=9 then credits else 0 END) as cred,(CASE when type_evaluation.libelle="SN" then credits else 0 END ) as cred3, (case when moyenne_ue_etudiant(matricule, enseignement.code)>=9 and type_evaluation.libelle="SN" then credits else 0 END) as cred2,penalites(matricule,an,sem) as penalites
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
and niveau.numero=niv
and filiere.libelle=fil
and semestre.libelle=sem
group by matricule,ue.libelle,type_evaluation.libelle
order by nom_prenom,codemo,ue;
delete FROM tmp_ue;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `releve_note` (IN `mat` VARCHAR(255), IN `niv` INT, IN `an` INT)  BEGIN
	#Routine body goes here...
	select DISTINCT matricule, niveau.description as niveau,ue.code_ue as codeue,module.code_module,
module.libelle as module, ue.libelle as ue, extract(year from annee_academique.date_debut) as annee, nom, moyenne_ue_etudiant(mat,enseignement.`code`) as moyenne,decision((moyenne_ue_etudiant(mat,enseignement.`code`))) as decision,grade(moyenne_ue_etudiant(mat,enseignement.`code`))as grade,(case when (moyenne_ue_etudiant(mat,enseignement.`code`) >=9) 
 THEN
     CONCAT(credits,"/",credits)
	when (moyenne_ue_etudiant(mat,enseignement.`code`)<9) THEN
      CONCAT("0/",credits)
 END) as credits,(case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then CONCAT('Rattrapge',' ',extract(year from annee_academique.date_debut)) when COUNT(case when type_evaluation.libelle='Rattrapage' then 1 else NULL end )=0 then CONCAT('Normale',' ',extract(year from annee_academique.date_debut))end) as Session,semestre.libelle as Semestre,penalites(mat,an,semestre.libelle) as penalites
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
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
group by module.libelle,ue.libelle,semestre
order by semestre,module.libelle asc;

END$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `add_tmp2` (`codeue` VARCHAR(255), `credits` INT(11)) RETURNS INT(11) BEGIN
	#Routine body goes here...
	DECLARE resultat int(11);
	
if (not EXISTS (select tmp_ue.codeue from tmp_ue
where codeue=tmp_ue.codeue)) then
SET resultat=credits;
	INSERT INTO tmp_ue(tmp_ue.codeue) values(codeue);
else	
SET resultat=0;
end if;

return resultat;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `decision` (`val` FLOAT) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
	#Routine body goes here...
	declare resultat varchar(255);
	select case when val >=10
 THEN
      "CA" 
	WHEN val>=9 THEN
      "CANT" 
	WHEN val <9 THEN
      "NC" 
 END into resultat;

	RETURN resultat;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `grade` (`val` FLOAT) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
	#Routine body goes here...
	declare resultat VARCHAR(255);
 select 
 case when val >=18 and val<=20 
 THEN
      "A+" 
	when val >=16 and val<18 THEN
      "A" 
	when val >=14 and val<16 THEN
      "B+" 
	when val >=13 and val<14 THEN
      "B" 
	when val >=12 and val<13 THEN
      "B-" 
	when val >=11 and val<12 THEN
      "C+" 
	when val >=10 and val<11 THEN
      "C" 
	when val >=9 and val<10 THEN
      "C-" 
	when val >=8 and val<9 THEN
      "D" 
	when val >=6 and val<8 THEN
      "E" 
	when val >=0 and val<6 THEN
      "F" 
 END as grade into resultat;
 
	RETURN resultat;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `mat_par` (`fil` VARCHAR(255), `niv` INT, `an` INT, `sem` VARCHAR(255)) RETURNS INT(11) BEGIN
	#Routine body goes here...
	DECLARE resultat int;
	SELECT COUNT(distinct enseignement.libelle) into resultat
	FROM enseignement,semestre,annee_academique,niveau,ue,specialite,classe,filiere
	where enseignement.ue=ue.`code`
	and ue.niveau=niveau.`code`
	AND enseignement.semestre=semestre.`code`
	and semestre.annee_academique=annee_academique.`code`
	and specialite.filiere=filiere.code
	and classe.niveau=niveau.`code`
	and classe.specialite=specialite.`code`
	and filiere.libelle=fil
	and niveau.numero=niv
	and EXTRACT(year from annee_academique.date_debut)=an
	and semestre.libelle=sem;
	

	RETURN resultat;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `mgp` (`val` FLOAT) RETURNS DECIMAL(10,1) BEGIN
	#Routine body goes here...
 declare resultat DECIMAL(10,1);
 select 
 (case when val >=18.0 and val<=20.0
 THEN 4.0 
 when val >=16.0 and val<18.0 THEN 3.7
      
	when val >=14.0 and val<16.0 THEN 3.3
	
	when val >=13.0 and val<14.0 THEN 3
	
	when val >=12.0 and val<13.0 THEN 2.7
	
	when val >=11.0 and val<12.0 THEN 2.3
      
	when val >=10.0 and val<11.0 THEN 2.0
   
	when val >=9.0 and val<10.0 THEN 1.7
      
	when val >=8.0 and val<9.0 THEN 1.3
       
	when val >=6.0 and val<8.0 THEN 1.0
      
	when val >=0.0 and val<6.0 THEN 0
      
 END ) into resultat;
 
	RETURN resultat ;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `mgp_sem` (`mat` VARCHAR(255), `niv` BIGINT(20), `ans` BIGINT(20), `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here...
	declare resultat float;
	select mgp((SUM(moyenne_ue_etudiant(matricule,enseignement.`code`)*credits)/SUM(credits))- penalites(mat,niv,ans,sem))into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
#and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=mat
and niveau.numero= niv
and classe.niveau=niveau.`code`
and semestre.libelle=sem;
return resultat;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `moyenne_ue_etudiant` (`matricule_etudiant` VARCHAR(255), `codeenseignement` BIGINT(20)) RETURNS FLOAT BEGIN

DECLARE resultat float;

select (case when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=1 then ROUND(SUM(case when type_evaluation.libelle='Session normale' then 0 ELSE (valeur_note*pourcentage)/100 END),2) when COUNT(case when type_evaluation.libelle='rattrapage' then 1 else NULL end )=0 then ROUND(SUM((valeur_note*pourcentage)/100 ),2)end) into resultat
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
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `moy_sem` (`mat` VARCHAR(255), `niv` BIGINT(20), `ans` BIGINT(20), `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here...
	declare resultat float;
	select ((SUM(moyenne_ue_etudiant(matricule,enseignement.`code`)*credits)/SUM(credits))- penalites(mat,niv,ans,sem))into resultat
from etudiant, filiere, note, type_evaluation, module, est_inscrit, candidat, evaluation, enseignement, ue, niveau, classe, specialite, annee_academique, semestre,discipline
where note.est_inscrit=est_inscrit.code
and discipline.etudiant=etudiant.`code`
and discipline.semestre=semestre.`code`
and est_inscrit.enseignement=enseignement.code
and enseignement.ue=ue.`code`
and enseignement.semestre=semestre.`code`
and semestre.annee_academique=annee_academique.`code`
and extract(year from annee_academique.date_debut)=ans
and est_inscrit.candidat_inscrit=candidat.`code`
and evaluation.type_evaluation=type_evaluation.`code`
and ue.module=module.`code`
and note.evaluation=evaluation.`code`
and candidat.code=etudiant.code
#and candidat.classe=classe.`code`
and classe.specialite=specialite.`code`
and specialite.filiere=filiere.`code`
and type_evaluation.enseignement=enseignement.`code`
and ue.module=module.`code`
and etudiant.matricule=mat
and niveau.numero= niv
and classe.niveau=niveau.`code`
and semestre.libelle=sem;
return resultat;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `moy_ue_etud_typ_ev` (`matricule_etudiant` VARCHAR(255), `codeenseignement` BIGINT(20)) RETURNS FLOAT BEGIN

DECLARE resultat float;

select ROUND(AVG(valeur_note),2) into resultat
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
and type_evaluation.libelle="Controle continu"
and etudiant.matricule=matricule_etudiant
and enseignement.`code`=codeenseignement
and classe.niveau=niveau.`code`;

	RETURN resultat;
	
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `penalites` (`mat` VARCHAR(255), `an` INT, `sem` VARCHAR(255)) RETURNS FLOAT BEGIN
	#Routine body goes here..
	DECLARE resultat float;
	SELECT ((((SUM(nbha)-SUM(hj)) div 5)*0.1)+((SUM(nbrt) div 15)*0.1)) into resultat from
(SELECT description,MONTHNAME(date_retard) as mois,nb_heures_absences as nbha,heure_justifie as hj,nb_retards as nbrt,etudiant,semestre as seme
from discipline) as disc,etudiant,semestre,annee_academique
WHERE etudiant=etudiant.`code`
and annee_academique.`code`=semestre.annee_academique
and semestre.`code`=seme
and matricule=mat
and semestre.libelle=sem
and EXTRACT(YEAR from annee_academique.date_debut)=an;
RETURN resultat;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `annee_academique`
--

CREATE TABLE `annee_academique` (
  `code` bigint(20) NOT NULL,
  `date_cloture` datetime DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_debut` datetime DEFAULT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `annee_academique`
--

INSERT INTO `annee_academique` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(206, '2017-08-30 22:00:00', '2019-08-02 11:18:09', '2016-08-31 22:00:00', '2019-08-02 11:18:09', 'Année Académique 2016/2017', '', '2122578073', 'ACTIVE', 1, 1),
(352, '2018-08-30 22:00:00', '2019-08-02 11:31:31', '2017-08-31 22:00:00', '2019-08-02 11:31:31', 'Année Académique 2017/2018', '', '-1199522912', 'ACTIVE', 1, 1),
(353, '2019-08-30 22:00:00', '2019-08-02 11:32:44', '2018-08-31 22:00:00', '2019-08-02 11:32:44', 'Année Académique 2018/2019', '', '-1294000977', 'ACTIVE', 1, 1),
(354, '2020-08-30 22:00:00', '2019-08-02 11:33:16', '2019-08-31 22:00:00', '2019-08-02 11:33:16', 'Année Académique 2019/2020', '', '-1341002424', 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `anonymat`
--

CREATE TABLE `anonymat` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `numero_anonymat` int(11) DEFAULT NULL,
  `numero_table` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `evaluation` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `est_inscrit` bigint(20) DEFAULT NULL,
  `note` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `candidat`
--

CREATE TABLE `candidat` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `candidat`
--

INSERT INTO `candidat` (`code`, `DTYPE`, `date_creation`, `date_modification`, `date_naissance`, `description`, `ecole_origine`, `email`, `libelle`, `nom`, `nom_de_la_mere`, `nom_du_pere`, `prenom`, `profession_de_la_mere`, `profession_du_pere`, `region_origine`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `telephone_de_la_mere`, `telephone_du_pere`, `classe`, `createur`, `modificateur`) VALUES
(3124, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1996-02-02 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'keisper99@gmail.com', NULL, 'TIYOUH  NGONGANG ', 'DOMCHE NGOGAING Carine', 'TIYOUH CHRISTOPHER NGOULAPPE', 'Keisper', '', '', 'OUEST', 'MASCULIN', '-1692746767', 'ACTIVE', 'ACTIVE', 690123155, 696664700, 0, 53, 1, 1),
(3125, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1999-01-31 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'touko.doline@yahoo.fr', NULL, 'TOUKO CHOKOUAFI ', 'CHEMALEU DJINE Fride', 'MOUKAM Timothé Jéhu', 'Doline', '', '', 'OUEST', 'FEMININ', '122886250', 'ACTIVE', 'ACTIVE', 697981605, 699816006, 699871636, 53, 1, 1),
(3122, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:46:27', '1994-01-29 23:00:00', '', 'LYCEE GENERAL LECLERC', 'lionneltemgoua18@gmail.com', '', 'TEMGOUA NJOUNANG ', 'DIFFO Odette', 'TEMGOUA Appolinaire', 'Cédric Lionnel', '', '', 'OUEST', 'MASCULIN', '1184911240', 'ACTIVE', 'ACTIVE', 683063752, 0, 696785339, 53, 1, 1),
(3123, 'Etudiant', '2019-08-07 14:43:44', '2019-08-12 12:25:24', '2001-04-25 22:00:00', '', 'LYCEE MGR BESSIEUX', 'timamomarion9@gmail.com', '', 'TIMAMO ', 'KANBOUM KAMBA Antoinette', 'TIMAMO SIMO Eugène', 'Viorika Shany Marion', '', '', 'OUEST', 'FEMININ', '3030994', 'ACTIVE', 'ACTIVE', 656499228, 2147483647, 2147483647, 53, 1, 1),
(3121, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:43:44', '1998-06-22 22:00:00', NULL, 'COLLEGE DE LA RETRAITE', 'divine_elvira@yahoo.com', NULL, 'TCHEUTCHOA TCHEUTCHOA ', 'MAYOUMO DEFFO NOEME Chantale', 'TCHEUTCHOA Jean Pierre', 'Divine Elvira', '', '', 'OUEST', 'FEMININ', '-1245198940', 'ACTIVE', 'ACTIVE', 698177440, 699569571, 699924195, 53, 1, 1),
(3120, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:44:21', '1997-07-03 22:00:00', '', 'COLLEGE VOGT', 'songcedriccena@yahoo.fr', '', 'SONG ', 'BAHANAG SONG Aimée Téclaire', 'ONANA ABENG Lazare', 'Cédric Junior', '', '', 'CENTRE', 'MASCULIN', '1916394346', 'ACTIVE', 'ACTIVE', 698786691, 698312070, 699808633, 53, 1, 1),
(3119, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:52:48', '1998-04-02 22:00:00', '', 'COLLEGE VOGT', 'georgesnyemb37@gmail.com', '', 'SALLA NYEMB ', 'SALLA BOUAMBO Josette', '', 'Georges Olivier', '', '', 'SUD', 'MASCULIN', '-569926006', 'ACTIVE', 'ACTIVE', 699849761, 699849761, 699849761, 53, 1, 1),
(3118, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1996-10-13 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'franckbryan0@gmail.com', NULL, 'ONANA TSOGO ', 'NDONGO Lucie', 'ONANA Barnabé Paul', 'Franck Bryan', '', '', 'SUD', 'MASCULIN', '743358084', 'ACTIVE', 'ACTIVE', 697628538, 677577751, 677785786, 53, 1, 1),
(3117, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-01-25 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'bricemichael808@gmail.com', NULL, 'NZOKOU FONGANG ', 'MAFOHK Régine', 'FONGANG', 'Brice Michael', '', '', 'OUEST', 'MASCULIN', '-1263493348', 'ACTIVE', 'ACTIVE', 695563032, 670601545, 677487105, 53, 1, 1),
(3116, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 15:05:07', '1997-05-10 22:00:00', '', 'COLLEGE MARIE ALBERT', '', '', 'NZIKO SIMO  ', '', 'MAKEMTA SIMO Odette', 'Yvan  Arthur', '', 'SIMO Gilles', 'OUEST', 'MASCULIN', '-223346564', 'ACTIVE', 'ACTIVE', 693222744, 699302414, 699302414, 53, 1, 1),
(3115, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-06-25 22:00:00', NULL, 'UNIVERSITE DE BUEA', 'oyanestahnn@gmail.com', NULL, 'NSOLA OYANE ', 'NYANGONO NKOULOU Ernestine Yvonne', 'OYANE NSOLA JOSUE', 'Rick Stahnn Lewis', '', '', 'SUD', 'MASCULIN', '1743636595', 'ACTIVE', 'ACTIVE', 694194638, 677589196, 677616535, 53, 1, 1),
(3114, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1997-06-06 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE 1 (ICT4D)', 'djeuchombrice13@gmail.com', NULL, 'NOUTCHEDJAM DJEUCHOM ', 'SIAKAM PEPOUBA MARLINNE', 'DJEUCHOM PASCAL', 'Thomas', '', '', 'OUEST', 'MASCULIN', '-387188878', 'ACTIVE', 'ACTIVE', 696899526, 677000375, 677792655, 53, 1, 1),
(3112, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1996-03-25 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'ndoumouandre@gmail.com', NULL, 'NDOUMOU FOUDA MBALLA ', 'BELOMO OBONO Joséphine', 'NDOUMOU André', 'André', '', '', 'CENTRE', 'MASCULIN', '-844093074', 'ACTIVE', 'ACTIVE', 651069554, 670094999, 670910402, 53, 1, 1),
(3113, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '1994-02-10 23:00:00', NULL, 'UNIVERSITE DE BUEA', 'nonoivan3@gmail.com', NULL, 'NGUEPNANG NONO ', 'DJAMPOU Madeleine', 'NGANYO Michel', 'Ivan-Dasny', '', '', 'OUEST', 'MASCULIN', '-1138459545', 'ACTIVE', 'ACTIVE', 690614621, 673793205, 242020471, 53, 1, 1),
(3111, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '2000-06-21 22:00:00', NULL, 'LYCEE BILINGUE DE MENDONG', 'momokarel2@gmail.com', NULL, 'MOMO KOUDJOU ', 'DONGMO MOMO MARIE MADOUCE', 'KOUDJOU TSAFACK Elie', 'Karel Orly', '', '', 'OUEST', 'FEMININ', '-1768818010', 'ACTIVE', 'ACTIVE', 655269592, 677810123, 677810123, 53, 1, 1),
(3110, 'Etudiant', '2019-08-07 14:43:43', '2019-08-07 14:43:43', '2000-01-13 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'mfomenndafeu@yahoo.fr', NULL, 'MFOMEN NDAFEU ', 'KOUAMOU TCHIENGUE', 'NDAFEU Célesstin', 'Elvira Ruth', '', '', 'OUEST', 'FEMININ', '2117244794', 'ACTIVE', 'ACTIVE', 690150916, 2147483647, 675946548, 53, 1, 1),
(3108, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1998-08-16 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'mbouendenorman@gmail.com', NULL, 'MBOUENDE TCHANDJA ', 'TCHANDJA TIAKO Chantal', 'MBOUENDE SIEWE André', 'Norman Frejus', '', '', 'OUEST', 'MASCULIN', '1578210021', 'ACTIVE', 'ACTIVE', 673391176, 699298367, 699879606, 53, 1, 1),
(3109, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:43', '1999-12-31 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE I FACULTE DES SCIENCES', 'jordanmelong@yahoo.com', NULL, 'MELONG FOUDJI ', 'TIOGONO Thérèse', 'MELONG Simon', 'Winnie Jordane', '', '', 'OUEST', 'FEMININ', '-1973141086', 'ACTIVE', 'ACTIVE', 691737831, 699008519, 696296021, 53, 1, 1),
(3107, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1997-01-19 23:00:00', NULL, 'UNIVERSITE DE YAOUNDE 1 (ICT4D)', 'francklowe547@gmail.com', NULL, 'LOWE NANMEGNE ', 'TCHONANG MBOUPDA RACHEL', 'NANMEGNE JEAN CLAUDE', 'Giresse Franck', '', '', 'OUEST', 'MASCULIN', '-480613223', 'ACTIVE', 'ACTIVE', 690582022, 699460982, 697768481, 53, 1, 1),
(3106, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '2000-04-20 22:00:00', NULL, 'LYCEE CLASSIQUE DE BAFOUSSAM', 'aclotchouang@gmail.com', NULL, 'LOTCHOUANG KOUSSEU ', 'NONO Marie Caroline', 'LOTCHOUANG Etienne', 'Ange Cécile', '', '', 'OUEST', 'FEMININ', '870569717', 'ACTIVE', 'ACTIVE', 677947592, 699848953, 677947592, 53, 1, 1),
(3105, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1997-04-29 22:00:00', NULL, 'COLLEGE FLEMING', 'lansivalerois@gmail.com', NULL, 'LANSI DJOUMALE  ', 'KWEMOU Yvonne', 'DJOUMALE TOWA Pierre Paul', 'Valère', '', '', 'Ouest', 'MASCULIN', '885977549', 'ACTIVE', 'ACTIVE', 695823451, 67762877, 677623877, 53, 1, 1),
(3102, 'Etudiant', '2019-08-07 14:43:41', '2019-08-07 14:44:48', '2000-01-27 23:00:00', '', 'NESCAS', 'channeldonkeng@gmail.com', '', 'DONKENG DONFACK', 'DJOUKAM Thérèse', 'DONKENG Augustin', 'Channel Laetitia', '', '', 'OUEST', 'FEMININ', '-26725379', 'ACTIVE', 'ACTIVE', 656307859, 677640961, 677607064, 53, 1, 1),
(3103, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1996-11-05 23:00:00', NULL, 'COLLEGE SAINT BENOIT', 'fodjomaximejr@gmail.com', NULL, 'FODJO ', 'KAMTCHUANT Clotilde', 'FUMTHUM', 'Maxime Junior', '', '', 'OUEST', 'MASCULIN', '288952523', 'ACTIVE', 'ACTIVE', 656531071, 677454346, 677882493, 53, 1, 1),
(3104, 'Etudiant', '2019-08-07 14:43:42', '2019-08-07 14:43:42', '1999-07-11 22:00:00', NULL, 'COLLEGE EXCELLENCE', 'anthonyfouda@gmail.com', NULL, 'FOUDA ', 'GOURIOU Irène Floberte', 'DABBAGH MAROUANE SALAH', 'Hyacinthe Anthony', '', '', 'BRETAGNE', 'MASCULIN', '-1717650719', 'ACTIVE', 'ACTIVE', 691063708, 699824737, 699934699, 53, 1, 1),
(3101, 'Etudiant', '2019-08-07 14:43:41', '2019-08-07 14:43:41', '1997-05-20 22:00:00', NULL, 'UNIVERSITE DE YAOUNDE (ICT4D)', 'constantinnitcheu6@gmail.com', NULL, 'CHEUTCHOUA NITCHEU ', 'TCHANGA JACQUELINE', 'NITCHEU JEAN BAPTISTE', 'Constantin', '', '', 'OUEST', 'MASCULIN', '-1152360690', 'ACTIVE', 'ACTIVE', 695585034, 674000847, 694160102, 53, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `classe`
--

CREATE TABLE `classe` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `niveau` bigint(20) DEFAULT NULL,
  `specialite` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `classe`
--

INSERT INTO `classe` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`, `niveau`, `specialite`) VALUES
(52, '2019-08-02 10:54:24', '2019-08-02 10:54:24', '', 'LIC 1', '-2062447409', 'ACTIVE', 1, 1, 7, 4),
(53, '2019-08-02 10:55:08', '2019-08-02 10:55:08', '', 'LIC 2', '-1690386618', 'ACTIVE', 1, 1, 8, 4),
(55, '2019-08-02 10:55:23', '2019-08-02 10:55:23', '', 'LIC 3', '-1528531123', 'ACTIVE', 1, 1, 9, 4),
(58, '2019-08-02 10:59:28', '2019-08-02 10:59:28', '', 'ING 1A', '-2012567747', 'ACTIVE', 1, 1, 7, 57),
(60, '2019-08-02 11:00:29', '2019-08-02 11:00:29', '', 'ING 2', '-1640506956', 'ACTIVE', 1, 1, 8, 57),
(202, '2019-08-02 11:14:10', '2019-08-02 11:14:10', '', 'ING 1B', '569441626', 'ACTIVE', 1, 1, 7, 57),
(203, '2019-08-02 11:14:42', '2019-08-02 11:14:42', '', 'ING 3', '1103357912', 'ACTIVE', 1, 1, 9, 57),
(204, '2019-08-02 11:14:55', '2019-08-02 11:14:55', '', 'ING 4', '2082411475', 'ACTIVE', 1, 1, 10, 5),
(205, '2019-08-02 11:14:59', '2019-08-02 11:14:59', '', 'ING 4', '2083807250', 'ACTIVE', 1, 1, 10, 6);

-- --------------------------------------------------------

--
-- Structure de la table `discipline`
--

CREATE TABLE `discipline` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `date_retard` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `heure_justifie` int(11) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `nb_heures_absences` int(11) DEFAULT NULL,
  `nb_retards` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `etudiant` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL,
  `semestre` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `discipline`
--

INSERT INTO `discipline` (`code`, `date_creation`, `date_modification`, `date_retard`, `description`, `heure_justifie`, `libelle`, `nb_heures_absences`, `nb_retards`, `signature`, `statut_vie`, `createur`, `etudiant`, `modificateur`, `semestre`) VALUES
(7301, '2019-08-14 12:58:43', '2019-08-14 12:58:43', '2018-10-04 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-10361948', 'ACTIVE', 1, 3123, 1, 705),
(7302, '2019-08-14 12:58:43', '2019-08-14 12:58:43', '2018-10-05 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-395600612', 'ACTIVE', 1, 3123, 1, 705),
(7303, '2019-08-14 12:58:43', '2019-08-14 12:58:43', '2018-10-06 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-806864834', 'ACTIVE', 1, 3123, 1, 705),
(7304, '2019-08-14 12:58:43', '2019-08-14 12:58:43', '2018-10-07 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1668091039', 'ACTIVE', 1, 3123, 1, 705),
(7305, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-08 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1595945881', 'ACTIVE', 1, 3123, 1, 705),
(7306, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-09 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-414453097', 'ACTIVE', 1, 3123, 1, 705),
(7307, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-10 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-885190274', 'ACTIVE', 1, 3123, 1, 705),
(7308, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-11 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 5, 0, '-1316740159', 'ACTIVE', 1, 3123, 1, 705),
(7309, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-14 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1472916444', 'ACTIVE', 1, 3123, 1, 705),
(7310, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-15 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '2020501503', 'ACTIVE', 1, 3123, 1, 705),
(7311, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-16 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1018656376', 'ACTIVE', 1, 3123, 1, 705),
(7312, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-17 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 1, 1, '1142290897', 'ACTIVE', 1, 3123, 1, 705),
(7313, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-18 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '2087692008', 'ACTIVE', 1, 3123, 1, 705),
(7314, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-19 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1824956477', 'ACTIVE', 1, 3123, 1, 705),
(7315, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-20 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-548712442', 'ACTIVE', 1, 3123, 1, 705),
(7316, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-21 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1277631866', 'ACTIVE', 1, 3123, 1, 705),
(7317, '2019-08-14 12:58:44', '2019-08-14 12:58:44', '2018-10-22 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 3, 0, '-549712023', 'ACTIVE', 1, 3123, 1, 705),
(7318, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-23 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1354619586', 'ACTIVE', 1, 3123, 1, 705),
(7351, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-24 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '820126809', 'ACTIVE', 1, 3123, 1, 705),
(7352, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-25 22:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '243455540', 'ACTIVE', 1, 3123, 1, 705),
(7353, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-28 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 1, 1, '1665448219', 'ACTIVE', 1, 3123, 1, 705),
(7354, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-29 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1796831679', 'ACTIVE', 1, 3123, 1, 705),
(7355, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-30 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '2132690314', 'ACTIVE', 1, 3123, 1, 705),
(7356, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-10-31 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 2, 0, '-1699991016', 'ACTIVE', 1, 3123, 1, 705),
(7357, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2018-11-01 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-250978638', 'ACTIVE', 1, 3123, 1, 705),
(7358, '2019-08-14 12:58:45', '2019-08-14 12:58:45', '2019-02-03 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1123481024', 'ACTIVE', 1, 3123, 1, 706),
(7359, '2019-08-14 12:58:45', '2019-08-14 12:58:46', '2019-02-04 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-495848554', 'ACTIVE', 1, 3123, 1, 706),
(7360, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-05 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1576158959', 'ACTIVE', 1, 3123, 1, 706),
(7361, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-06 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1599459595', 'ACTIVE', 1, 3123, 1, 706),
(7362, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-07 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '788657508', 'ACTIVE', 1, 3123, 1, 706),
(7363, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-08 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-607621391', 'ACTIVE', 1, 3123, 1, 706),
(7364, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-09 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '871236168', 'ACTIVE', 1, 3123, 1, 706),
(7365, '2019-08-14 12:58:46', '2019-08-14 12:58:46', '2019-02-10 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '2101020027', 'ACTIVE', 1, 3123, 1, 706),
(7366, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-11 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '1557797116', 'ACTIVE', 1, 3123, 1, 706),
(7367, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-12 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1734096261', 'ACTIVE', 1, 3123, 1, 706),
(7368, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-13 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-491299623', 'ACTIVE', 1, 3123, 1, 706),
(7369, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-14 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 4, 1, '-1577080843', 'ACTIVE', 1, 3123, 1, 706),
(7370, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-15 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '-1388143739', 'ACTIVE', 1, 3123, 1, 706),
(7371, '2019-08-14 12:58:47', '2019-08-14 12:58:47', '2019-02-16 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '-145347101', 'ACTIVE', 1, 3123, 1, 706),
(7372, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-17 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '939465290', 'ACTIVE', 1, 3123, 1, 706),
(7373, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-18 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '-1478937450', 'ACTIVE', 1, 3123, 1, 706),
(7374, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-19 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '908688050', 'ACTIVE', 1, 3123, 1, 706),
(7375, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-20 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1407541631', 'ACTIVE', 1, 3123, 1, 706),
(7376, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-21 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-919289689', 'ACTIVE', 1, 3123, 1, 706),
(7377, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-22 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '-174541247', 'ACTIVE', 1, 3123, 1, 706),
(7378, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-23 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 1, '-1102458345', 'ACTIVE', 1, 3123, 1, 706),
(7379, '2019-08-14 12:58:48', '2019-08-14 12:58:48', '2019-02-24 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-420944821', 'ACTIVE', 1, 3123, 1, 706),
(7380, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2019-02-25 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '465014087', 'ACTIVE', 1, 3123, 1, 706),
(7381, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2019-02-26 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '787859943', 'ACTIVE', 1, 3123, 1, 706),
(7382, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2019-02-27 23:00:00', '1718L031 TIMAMO Viorika Shany Marion', 0, 'Absences', 0, 0, '-1485571360', 'ACTIVE', 1, 3123, 1, 706),
(7383, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2018-10-03 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '959199423', 'ACTIVE', 1, 3104, 1, 705),
(7384, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2018-10-04 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1895949612', 'ACTIVE', 1, 3104, 1, 705),
(7385, '2019-08-14 12:58:49', '2019-08-14 12:58:49', '2018-10-05 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-4541409', 'ACTIVE', 1, 3104, 1, 705),
(7386, '2019-08-14 12:58:50', '2019-08-14 12:58:50', '2018-10-06 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '100847245', 'ACTIVE', 1, 3104, 1, 705),
(7387, '2019-08-14 12:58:50', '2019-08-14 12:58:50', '2018-10-07 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-630047269', 'ACTIVE', 1, 3104, 1, 705),
(7388, '2019-08-14 12:58:50', '2019-08-14 12:58:50', '2018-10-08 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '10597980', 'ACTIVE', 1, 3104, 1, 705),
(7389, '2019-08-14 12:58:50', '2019-08-14 12:58:50', '2018-10-09 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1571521623', 'ACTIVE', 1, 3104, 1, 705),
(7390, '2019-08-14 12:58:50', '2019-08-14 12:58:50', '2018-10-10 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1402899973', 'ACTIVE', 1, 3104, 1, 705),
(7391, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-11 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 5, 0, '-26164792', 'ACTIVE', 1, 3104, 1, 705),
(7392, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-14 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-600482661', 'ACTIVE', 1, 3104, 1, 705),
(7393, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-15 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-868606314', 'ACTIVE', 1, 3104, 1, 705),
(7394, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-16 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1285461476', 'ACTIVE', 1, 3104, 1, 705),
(7395, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-17 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 1, 1, '-1399330171', 'ACTIVE', 1, 3104, 1, 705),
(7396, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-18 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-171407963', 'ACTIVE', 1, 3104, 1, 705),
(7397, '2019-08-14 12:58:51', '2019-08-14 12:58:51', '2018-10-19 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '634643372', 'ACTIVE', 1, 3104, 1, 705),
(7398, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-20 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '1316157857', 'ACTIVE', 1, 3104, 1, 705),
(7399, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-21 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '1969815885', 'ACTIVE', 1, 3104, 1, 705),
(7400, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-22 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 3, 0, '-1593327336', 'ACTIVE', 1, 3104, 1, 705),
(7401, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-23 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '476410359', 'ACTIVE', 1, 3104, 1, 705),
(7402, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-24 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '-1449533234', 'ACTIVE', 1, 3104, 1, 705),
(7403, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-25 22:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-292236070', 'ACTIVE', 1, 3104, 1, 705),
(7404, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-28 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 1, 1, '-364489105', 'ACTIVE', 1, 3104, 1, 705),
(7405, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-29 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '426687800', 'ACTIVE', 1, 3104, 1, 705),
(7406, '2019-08-14 12:58:52', '2019-08-14 12:58:52', '2018-10-30 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1421180080', 'ACTIVE', 1, 3104, 1, 705),
(7407, '2019-08-14 12:58:53', '2019-08-14 12:58:53', '2018-10-31 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 2, 0, '167331990', 'ACTIVE', 1, 3104, 1, 705),
(7408, '2019-08-14 12:58:53', '2019-08-14 12:58:53', '2018-11-01 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-253244552', 'ACTIVE', 1, 3104, 1, 705),
(7409, '2019-08-14 12:58:53', '2019-08-14 12:58:53', '2019-02-03 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '1024532180', 'ACTIVE', 1, 3104, 1, 706),
(7410, '2019-08-14 12:58:53', '2019-08-14 12:58:53', '2019-02-04 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-431219674', 'ACTIVE', 1, 3104, 1, 706),
(7411, '2019-08-14 12:58:53', '2019-08-14 12:58:53', '2019-02-05 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-699343327', 'ACTIVE', 1, 3104, 1, 706),
(7412, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-06 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1249988077', 'ACTIVE', 1, 3104, 1, 706),
(7413, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-07 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '165636486', 'ACTIVE', 1, 3104, 1, 706),
(7414, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-08 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '1545982753', 'ACTIVE', 1, 3104, 1, 706),
(7415, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-09 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-149491820', 'ACTIVE', 1, 3104, 1, 706),
(7416, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-10 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1718598644', 'ACTIVE', 1, 3104, 1, 706),
(7417, '2019-08-14 12:58:54', '2019-08-14 12:58:54', '2019-02-11 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1648488286', 'ACTIVE', 1, 3104, 1, 706),
(7418, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-12 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1483626677', 'ACTIVE', 1, 3104, 1, 706),
(7419, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-13 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1822405165', 'ACTIVE', 1, 3104, 1, 706),
(7420, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-14 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 4, 1, '2013126959', 'ACTIVE', 1, 3104, 1, 706),
(7421, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-15 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '1462363045', 'ACTIVE', 1, 3104, 1, 706),
(7422, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-16 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '-378082996', 'ACTIVE', 1, 3104, 1, 706),
(7423, '2019-08-14 12:58:55', '2019-08-14 12:58:55', '2019-02-17 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '-1876534985', 'ACTIVE', 1, 3104, 1, 706),
(7424, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-18 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '-905077533', 'ACTIVE', 1, 3104, 1, 706),
(7425, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-19 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-634283754', 'ACTIVE', 1, 3104, 1, 706),
(7426, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-20 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '746062513', 'ACTIVE', 1, 3104, 1, 706),
(7427, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-21 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '195417763', 'ACTIVE', 1, 3104, 1, 706),
(7428, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-22 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '572146595', 'ACTIVE', 1, 3104, 1, 706),
(7429, '2019-08-14 12:58:56', '2019-08-14 12:58:56', '2019-02-23 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 1, '-1574916959', 'ACTIVE', 1, 3104, 1, 706),
(7430, '2019-08-14 12:58:57', '2019-08-14 12:58:57', '2019-02-24 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '2011420379', 'ACTIVE', 1, 3104, 1, 706),
(7431, '2019-08-14 12:58:57', '2019-08-14 12:58:57', '2019-02-25 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-1642901668', 'ACTIVE', 1, 3104, 1, 706),
(7432, '2019-08-14 12:58:57', '2019-08-14 12:58:57', '2019-02-26 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '716868336', 'ACTIVE', 1, 3104, 1, 706),
(7433, '2019-08-14 12:58:57', '2019-08-14 12:58:57', '2019-02-27 23:00:00', '1718L016 FOUDA Hyacinthe Anthony', 0, 'Absences', 0, 0, '-805778312', 'ACTIVE', 1, 3104, 1, 706);

-- --------------------------------------------------------

--
-- Structure de la table `droit`
--

CREATE TABLE `droit` (
  `code` bigint(20) NOT NULL,
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
  `role` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `email`
--

CREATE TABLE `email` (
  `code` bigint(20) NOT NULL,
  `objet` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `enseignant`
--

CREATE TABLE `enseignant` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `enseignement`
--

CREATE TABLE `enseignement` (
  `code` bigint(20) NOT NULL,
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
  `ue` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `enseignement`
--

INSERT INTO `enseignement` (`code`, `date_creation`, `date_modification`, `description`, `heures_de_cours`, `libelle`, `programme_de_cours`, `signature`, `statut_vie`, `createur`, `modificateur`, `semestre`, `ue`) VALUES
(6134, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Sagesse et science2', 40, 'Sagesse et science2', '', '-1326040992', 'ACTIVE', 1, 1, 706, 6047),
(6130, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Enterprise Resource Planning (ERP)', 120, 'Enterprise Resource Planning (ERP)', '', '956227343', 'ACTIVE', 1, 1, 706, 6043),
(6131, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Projet Tutoré', 120, 'Projet Tutoré', '', '-2131668215', 'ACTIVE', 1, 1, 706, 6044),
(6132, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Conception et Développement d’applications pour mobiles', 120, 'Conception et Développement d’applications pour mobiles', '', '-556229801', 'ACTIVE', 1, 1, 706, 6045),
(6133, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Stage Professionnel', 300, 'Stage Professionnel', '', '1838194151', 'ACTIVE', 1, 1, 706, 6046),
(6128, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'JEE(Programmation par Objets avancée)', 120, 'JEE(Programmation par Objets avancée)', '', '-387854165', 'ACTIVE', 1, 1, 706, 6041),
(6129, '2019-08-12 14:03:17', '2019-08-12 14:03:17', 'Technologie.NET', 120, 'Technologie.NET', '', '222950708', 'ACTIVE', 1, 1, 706, 6042),
(6127, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Sagesse et science1', 15, 'Sagesse et science1', '', '1946406185', 'ACTIVE', 1, 1, 705, 6040),
(6126, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Anglais pratique', 30, 'Anglais pratique', '', '841587639', 'ACTIVE', 1, 1, 705, 6039),
(6125, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Fondamentaux de la communication', 60, 'Fondamentaux de la communication', '', '1707381474', 'ACTIVE', 1, 1, 705, 6038),
(6124, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Marketing Informatique', 60, 'Marketing Informatique', '', '1163614031', 'ACTIVE', 1, 1, 705, 6037),
(6121, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Sécurité avancée des réseaux et systèmes', 120, 'Sécurité avancée des réseaux et systèmes', '', '-1853321984', 'ACTIVE', 1, 1, 705, 6034),
(6123, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Ateliers de création d\'entreprise', 60, 'Ateliers de création d\'entreprise', '', '-1668803468', 'ACTIVE', 1, 1, 705, 6036),
(6122, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Gestion des Projets informatique', 120, 'Gestion des Projets informatique', '', '-993404769', 'ACTIVE', 1, 1, 705, 6035),
(6120, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Apprendre a manipuler les grosses quantites de donnees', 120, 'Introduction au Big Data', '', '1327014086', 'ACTIVE', 1, 1, 705, 6033),
(6116, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Stage qui mettra en exergue nos competences techniques', 1056, 'Stage Technique', '', '-1495202281', 'ACTIVE', 1, 1, 706, 6029),
(6117, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Acquerir les notions avancees de bases des bases de donnees', 120, 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '', '2012622025', 'ACTIVE', 1, 1, 705, 6030),
(6118, '2019-08-12 14:03:16', '2019-08-12 14:03:16', '', 120, 'Recherche opérationnelle et aide à la décision', '', '-1076840889', 'ACTIVE', 1, 1, 705, 6031),
(6119, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'Avoir les notons de la notion de genie logiciel', 120, 'Ingénierie du Génie Logiciel', '', '505676216', 'ACTIVE', 1, 1, 705, 6032),
(6115, '2019-08-12 14:03:16', '2019-08-12 14:03:16', 'developper l\'ethique', 60, 'Éthique et Philosophie', '', '-169255963', 'ACTIVE', 1, 1, 706, 6028),
(6114, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'anglais niveau B2', 60, 'Anglais Niveau pratique B2', '', '361204376', 'ACTIVE', 1, 1, 706, 6027),
(6113, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'projet effectue en groupe pour la realisation d\'une application qui resous un probleme reel', 90, 'Projets tutorés', '', '-36618993', 'ACTIVE', 1, 1, 706, 6026),
(6112, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Avoir les notions de bases de ;a securite informatiques', 120, 'Introduction à la sécurité informatique', '', '-1437962389', 'ACTIVE', 1, 1, 706, 6025),
(6111, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser les ruages de l\'economie numerique', 90, 'économie numérique', '', '2045438485', 'ACTIVE', 1, 1, 706, 6024),
(6110, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'environnement comptable de l\'entreprise ', 120, 'L\'entreprise et la gestion, environnement comptable, financier', '', '620315639', 'ACTIVE', 1, 1, 706, 6023),
(6109, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser un langage sur web', 120, 'Programmation Web II', '', '415898654', 'ACTIVE', 1, 1, 706, 6022),
(6108, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'algebre 2', 120, 'Algèbre linéaire II', '', '-313492623', 'ACTIVE', 1, 1, 706, 6021),
(6107, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Appliquer la POO sur le c++', 120, 'Langage C++ et POO', '', '-1485899204', 'ACTIVE', 1, 1, 706, 6020),
(6106, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Developper l\'ethique de travail', 30, 'Ethique et Développement    ', '', '-821028434', 'ACTIVE', 1, 1, 705, 6019),
(6105, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Maitriser l\'anglais du niveau B1/B2', 60, 'Anglais niveau pratique B1/B2', '', '-844979566', 'ACTIVE', 1, 1, 705, 6018),
(6102, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Acquerir les notions en bases de donnees', 120, 'Introduction aux Base de données', '', '291698588', 'ACTIVE', 1, 1, 705, 6015),
(6103, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Acquerir les notions de bases de reseaux', 120, 'Introduction aux Réseaux informatiques', '', '2021365009', 'ACTIVE', 1, 1, 705, 6016),
(6104, '2019-08-12 14:03:15', '2019-08-12 14:03:15', 'Avoir les bases de Linux', 90, 'Systèmes d\'exploitation', '', '-1563532841', 'ACTIVE', 1, 1, 705, 6017),
(6101, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'notion avancee en Programmation Oriente Objet', 120, 'Programmation Orientée Objet II', '', '-804103765', 'ACTIVE', 1, 1, 705, 6014),
(6069, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Maitriser les bases de l\'algebre ', 120, 'Algèbre linaire I', '', '705344848', 'ACTIVE', 1, 1, 705, 6013),
(6068, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Maitriser la modelisation UML', 120, 'modélisation des Systèmes d\'Information(UML)', '', '465629959', 'ACTIVE', 1, 1, 705, 6012),
(6067, '2019-08-12 14:03:14', '2019-08-12 14:03:14', 'Rendre nos algorithmes efficient', 120, 'Algorithmique et Complexité', '', '-60340711', 'ACTIVE', 1, 1, 705, 6011),
(6066, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Se familiariser avec le monde de l\'emploi', 528, 'Stage découverte de l’entreprise', '', '617100803', 'ACTIVE', 1, 1, 706, 6010),
(6065, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Developper l\'ethique', 30, 'Réflexion Humaine 2', '', '-620189480', 'ACTIVE', 1, 1, 706, 6009),
(6064, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Pouvoir bien s\'exprimer dans differentes situations en anglais', 60, 'Anglais niveau pratique B1', '', '1938215526', 'ACTIVE', 1, 1, 706, 6008),
(6063, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Maitriser les ruage de la communication', 60, 'Communication Orale, Ecrite et audio Visual', '', '-294274063', 'ACTIVE', 1, 1, 706, 6007),
(6060, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Notions avancee d\'algorithmique', 120, 'Algorithmique et Structure de données I', '', '1993472658', 'ACTIVE', 1, 1, 706, 6004),
(6061, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'notions en logique mathematique', 120, 'Mathématiques discrètes II', '', '882131609', 'ACTIVE', 1, 1, 706, 6005),
(6062, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'maitriser l\'algebre de bool', 60, 'Logique pour l\'Informatique', '', '-2100235076', 'ACTIVE', 1, 1, 706, 6006),
(6059, '2019-08-12 14:03:13', '2019-08-12 14:03:13', 'Apprendre les bases de l\'analye Merise', 120, 'Introduction à l\'Analyse Merise', '', '-1772693757', 'ACTIVE', 1, 1, 706, 6003),
(6055, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Etre capable de parler et bien ecrire l\'Anglais', 60, 'Anglais Remise à niveau A2', '', '-463091889', 'ACTIVE', 1, 1, 705, 5958),
(6056, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Developper l\'ethique', 30, 'Réflexion Humaine1', '', '-1246344041', 'ACTIVE', 1, 1, 705, 5959),
(6058, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Apprendre les bases du langage C', 150, 'Initiation à la programmation C', '', '192266185', 'ACTIVE', 1, 1, 706, 6002),
(6057, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Apprendre les bases de l\'oriente objet', 180, 'Initiation Programmation orientée objet I', '', '1401240202', 'ACTIVE', 1, 1, 706, 6001),
(6053, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'familiariser avec les notions de maths propres a l\'informatique', 150, 'Mathématiques pour l\'informatique', '', '-1074589762', 'ACTIVE', 1, 1, 705, 5956),
(6054, '2019-08-12 14:03:12', '2019-08-12 14:03:12', 'Acquerir la bonne logique informatique', 120, 'Mathématiques discrètes I', '', '743198437', 'ACTIVE', 1, 1, 705, 5957),
(6051, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Connaitre les enjeux de l\'econoimie numerique ', 60, 'Enjeux de l’économie Numérique', '', '-148279227', 'ACTIVE', 1, 1, 705, 5954),
(6052, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Acquerir les notions de baeses de l\'algorithme', 120, 'Introduction aux algorithmes', '', '1598067271', 'ACTIVE', 1, 1, 705, 5955),
(6049, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Connaitre les composants de l\'ordinateur', 120, 'Architecture des ordinateurs', '', '1743475007', 'ACTIVE', 1, 1, 705, 5952),
(6050, '2019-08-12 14:03:11', '2019-08-12 14:03:11', 'Les bases du html,css et javascript', 120, 'Programmation Web I', '', '-1155753187', 'ACTIVE', 1, 1, 705, 5953),
(6048, '2019-08-12 14:03:10', '2019-08-12 14:03:10', 'Maitriser les bases du systeme d\'information', 120, 'Introduction aux systèmes d\'information', '', '1123851998', 'ACTIVE', 1, 1, 705, 5951);

-- --------------------------------------------------------

--
-- Structure de la table `enseignement_enseignant`
--

CREATE TABLE `enseignement_enseignant` (
  `code_enseignant` bigint(20) NOT NULL,
  `code_enseignement` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Structure de la table `envoi_message`
--

CREATE TABLE `envoi_message` (
  `code` bigint(20) NOT NULL,
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
  `message` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `est_inscrit`
--

CREATE TABLE `est_inscrit` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `est_inscrit`
--

INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(6867, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF233', '', '1121702569', 'VALIDE', 'ACTIVE', 3125, 1, 6101, 1),
(6869, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF236', '', '-914086682', 'VALIDE', 'ACTIVE', 3125, 1, 6103, 1),
(6868, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF235', '', '244098679', 'VALIDE', 'ACTIVE', 3125, 1, 6102, 1),
(6866, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'MAT231', '', '-894217291', 'VALIDE', 'ACTIVE', 3125, 1, 6069, 1),
(6865, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'MAT241', '', '-375810832', 'VALIDE', 'ACTIVE', 3125, 1, 6108, 1),
(6864, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF232', '', '-1005319155', 'VALIDE', 'ACTIVE', 3125, 1, 6068, 1),
(6863, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF231', '', '741049877', 'VALIDE', 'ACTIVE', 3125, 1, 6067, 1),
(6861, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF243', '', '451301122', 'VALIDE', 'ACTIVE', 3125, 1, 6112, 1),
(6862, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'IN245', '', '-111094543', 'VALIDE', 'ACTIVE', 3125, 1, 6113, 1),
(6860, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF244', '', '-1179496014', 'VALIDE', 'ACTIVE', 3125, 1, 6111, 1),
(6859, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ENV241', '', '-613604153', 'VALIDE', 'ACTIVE', 3125, 1, 6110, 1),
(6858, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'STG241', '', '46954373', 'VALIDE', 'ACTIVE', 3125, 1, 6116, 1),
(6857, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ETH231', '', '468141', 'VALIDE', 'ACTIVE', 3125, 1, 6106, 1),
(6856, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ANG241', '', '762676994', 'VALIDE', 'ACTIVE', 3125, 1, 6114, 1),
(6855, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF242', '', '-2048936625', 'VALIDE', 'ACTIVE', 3125, 1, 6109, 1),
(6854, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF241', '', '-2083778527', 'VALIDE', 'ACTIVE', 3125, 1, 6107, 1),
(6853, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ETH241', '', '-1760756715', 'VALIDE', 'ACTIVE', 3124, 1, 6115, 1),
(6852, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'ANG231', '', '1874475196', 'VALIDE', 'ACTIVE', 3124, 1, 6105, 1),
(6848, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF233', '', '-1751589750', 'VALIDE', 'ACTIVE', 3124, 1, 6101, 1),
(6849, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF235', '', '1968897081', 'VALIDE', 'ACTIVE', 3124, 1, 6102, 1),
(6850, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF236', '', '-390759310', 'VALIDE', 'ACTIVE', 3124, 1, 6103, 1),
(6851, '2019-08-12 14:11:08', '2019-08-12 14:11:08', 'INF234', '', '-500978005', 'VALIDE', 'ACTIVE', 3124, 1, 6104, 1),
(6847, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'MAT231', '', '787592698', 'VALIDE', 'ACTIVE', 3124, 1, 6069, 1),
(6846, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'MAT241', '', '502446514', 'VALIDE', 'ACTIVE', 3124, 1, 6108, 1),
(6845, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF232', '', '-364049214', 'VALIDE', 'ACTIVE', 3124, 1, 6068, 1),
(6844, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF231', '', '1068173723', 'VALIDE', 'ACTIVE', 3124, 1, 6067, 1),
(6843, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'IN245', '', '784799075', 'VALIDE', 'ACTIVE', 3124, 1, 6113, 1),
(6842, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF243', '', '1347194740', 'VALIDE', 'ACTIVE', 3124, 1, 6112, 1),
(6841, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF244', '', '248792565', 'VALIDE', 'ACTIVE', 3124, 1, 6111, 1),
(6840, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ENV241', '', '851059237', 'VALIDE', 'ACTIVE', 3124, 1, 6110, 1),
(6838, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ETH231', '', '602056470', 'VALIDE', 'ACTIVE', 3124, 1, 6106, 1),
(6839, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'STG241', '', '947257059', 'VALIDE', 'ACTIVE', 3124, 1, 6116, 1),
(6837, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'ANG241', '', '1129482452', 'VALIDE', 'ACTIVE', 3124, 1, 6114, 1),
(6836, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF242', '', '-1146429405', 'VALIDE', 'ACTIVE', 3124, 1, 6109, 1),
(6835, '2019-08-12 14:11:07', '2019-08-12 14:11:07', 'INF241', '', '-1152612365', 'VALIDE', 'ACTIVE', 3124, 1, 6107, 1),
(6832, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF234', '', '245785217', 'VALIDE', 'ACTIVE', 3123, 1, 6104, 1),
(6834, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'ETH241', '', '-458450925', 'VALIDE', 'ACTIVE', 3123, 1, 6115, 1),
(6833, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'ANG231', '', '-1122595378', 'VALIDE', 'ACTIVE', 3123, 1, 6105, 1),
(6831, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF236', '', '149879983', 'VALIDE', 'ACTIVE', 3123, 1, 6103, 1),
(6830, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF235', '', '-1820703466', 'VALIDE', 'ACTIVE', 3123, 1, 6102, 1),
(6829, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF233', '', '-929872372', 'VALIDE', 'ACTIVE', 3123, 1, 6101, 1),
(6828, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'MAT231', '', '1394368011', 'VALIDE', 'ACTIVE', 3123, 1, 6069, 1),
(6827, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'MAT241', '', '1089381021', 'VALIDE', 'ACTIVE', 3123, 1, 6108, 1),
(6826, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF232', '', '45420306', 'VALIDE', 'ACTIVE', 3123, 1, 6068, 1),
(6825, '2019-08-12 14:11:06', '2019-08-12 14:11:06', 'INF231', '', '2111446768', 'VALIDE', 'ACTIVE', 3123, 1, 6067, 1),
(6822, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF244', '', '254832363', 'VALIDE', 'ACTIVE', 3123, 1, 6111, 1),
(6824, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'IN245', '', '1230643406', 'VALIDE', 'ACTIVE', 3123, 1, 6113, 1),
(6823, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF243', '', '994997763', 'VALIDE', 'ACTIVE', 3123, 1, 6112, 1),
(6821, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ENV241', '', '655384174', 'VALIDE', 'ACTIVE', 3123, 1, 6110, 1),
(6820, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'STG241', '', '1638906931', 'VALIDE', 'ACTIVE', 3123, 1, 6116, 1),
(6819, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ETH231', '', '1340001556', 'VALIDE', 'ACTIVE', 3123, 1, 6106, 1),
(6818, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'ANG241', '', '1279919227', 'VALIDE', 'ACTIVE', 3123, 1, 6114, 1),
(6817, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF242', '', '-1497524115', 'VALIDE', 'ACTIVE', 3123, 1, 6109, 1),
(6815, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'ETH241', '', '-1871412776', 'VALIDE', 'ACTIVE', 3122, 1, 6115, 1),
(6816, '2019-08-12 14:11:05', '2019-08-12 14:11:05', 'INF241', '', '-1184049645', 'VALIDE', 'ACTIVE', 3123, 1, 6107, 1),
(6814, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'ANG231', '', '1456286642', 'VALIDE', 'ACTIVE', 3122, 1, 6105, 1),
(6813, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF234', '', '-1424004845', 'VALIDE', 'ACTIVE', 3122, 1, 6104, 1),
(6812, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF236', '', '-1567307560', 'VALIDE', 'ACTIVE', 3122, 1, 6103, 1),
(6811, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF235', '', '499145809', 'VALIDE', 'ACTIVE', 3122, 1, 6102, 1),
(6810, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF233', '', '1654520983', 'VALIDE', 'ACTIVE', 3122, 1, 6101, 1),
(6808, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'MAT241', '', '-580409041', 'VALIDE', 'ACTIVE', 3122, 1, 6108, 1),
(6809, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'MAT231', '', '-267706182', 'VALIDE', 'ACTIVE', 3122, 1, 6069, 1),
(6807, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF232', '', '-1701528446', 'VALIDE', 'ACTIVE', 3122, 1, 6068, 1),
(6806, '2019-08-12 14:11:04', '2019-08-12 14:11:04', 'INF231', '', '399770560', 'VALIDE', 'ACTIVE', 3122, 1, 6067, 1),
(6803, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF244', '', '-1451332510', 'VALIDE', 'ACTIVE', 3122, 1, 6111, 1),
(6805, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'IN245', '', '-207670586', 'VALIDE', 'ACTIVE', 3122, 1, 6113, 1),
(6804, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF243', '', '157419286', 'VALIDE', 'ACTIVE', 3122, 1, 6112, 1),
(6802, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ENV241', '', '-1048576165', 'VALIDE', 'ACTIVE', 3122, 1, 6110, 1),
(6801, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'STG241', '', '141070521', 'VALIDE', 'ACTIVE', 3122, 1, 6116, 1),
(6800, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ETH231', '', '-381595055', 'VALIDE', 'ACTIVE', 3122, 1, 6106, 1),
(6799, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'ANG241', '', '-398688971', 'VALIDE', 'ACTIVE', 3122, 1, 6114, 1),
(6798, '2019-08-12 14:11:03', '2019-08-12 14:11:03', 'INF242', '', '1141982590', 'VALIDE', 'ACTIVE', 3122, 1, 6109, 1),
(6797, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF241', '', '1492934138', 'VALIDE', 'ACTIVE', 3122, 1, 6107, 1),
(6796, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'ETH241', '', '1081331684', 'VALIDE', 'ACTIVE', 3121, 1, 6115, 1),
(6795, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'ANG231', '', '157052219', 'VALIDE', 'ACTIVE', 3121, 1, 6105, 1),
(6793, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF236', '', '-1413754077', 'VALIDE', 'ACTIVE', 3121, 1, 6103, 1),
(6794, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF234', '', '-1896539018', 'VALIDE', 'ACTIVE', 3121, 1, 6104, 1),
(6791, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF233', '', '467717794', 'VALIDE', 'ACTIVE', 3121, 1, 6101, 1),
(6792, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'INF235', '', '407996018', 'VALIDE', 'ACTIVE', 3121, 1, 6102, 1),
(6790, '2019-08-12 14:11:02', '2019-08-12 14:11:02', 'MAT231', '', '-1479861512', 'VALIDE', 'ACTIVE', 3121, 1, 6069, 1),
(6789, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'MAT241', '', '-854535154', 'VALIDE', 'ACTIVE', 3121, 1, 6108, 1),
(6787, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF231', '', '-971111218', 'VALIDE', 'ACTIVE', 3121, 1, 6067, 1),
(6788, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF232', '', '1772588305', 'VALIDE', 'ACTIVE', 3121, 1, 6068, 1),
(6786, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'IN245', '', '-1172918108', 'VALIDE', 'ACTIVE', 3121, 1, 6113, 1),
(6785, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF243', '', '-1606971811', 'VALIDE', 'ACTIVE', 3121, 1, 6112, 1),
(6784, '2019-08-12 14:11:01', '2019-08-12 14:11:01', 'INF244', '', '1665649733', 'VALIDE', 'ACTIVE', 3121, 1, 6111, 1),
(6783, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ENV241', '', '-1639052907', 'VALIDE', 'ACTIVE', 3121, 1, 6110, 1),
(6781, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ETH231', '', '2063004318', 'VALIDE', 'ACTIVE', 3121, 1, 6106, 1),
(6782, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'STG241', '', '-935505968', 'VALIDE', 'ACTIVE', 3121, 1, 6116, 1),
(6780, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'ANG241', '', '-1125846821', 'VALIDE', 'ACTIVE', 3121, 1, 6114, 1),
(6779, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'INF242', '', '458915420', 'VALIDE', 'ACTIVE', 3121, 1, 6109, 1),
(6778, '2019-08-12 14:11:00', '2019-08-12 14:11:00', 'INF241', '', '-292400032', 'VALIDE', 'ACTIVE', 3121, 1, 6107, 1),
(6777, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'ETH241', '', '1706023354', 'VALIDE', 'ACTIVE', 3120, 1, 6115, 1),
(6776, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'ANG231', '', '797175627', 'VALIDE', 'ACTIVE', 3120, 1, 6105, 1),
(6773, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF235', '', '91351670', 'VALIDE', 'ACTIVE', 3120, 1, 6102, 1),
(6775, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF234', '', '-1965173291', 'VALIDE', 'ACTIVE', 3120, 1, 6104, 1),
(6774, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF236', '', '-1755750566', 'VALIDE', 'ACTIVE', 3120, 1, 6103, 1),
(6772, '2019-08-12 14:10:59', '2019-08-12 14:10:59', 'INF233', '', '237050272', 'VALIDE', 'ACTIVE', 3120, 1, 6101, 1),
(6771, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'MAT231', '', '-1382053468', 'VALIDE', 'ACTIVE', 3120, 1, 6069, 1),
(6769, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'INF232', '', '1404137408', 'VALIDE', 'ACTIVE', 3120, 1, 6068, 1),
(6770, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'MAT241', '', '-1054339200', 'VALIDE', 'ACTIVE', 3120, 1, 6108, 1),
(6768, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'INF231', '', '-928416524', 'VALIDE', 'ACTIVE', 3120, 1, 6067, 1),
(6767, '2019-08-12 14:10:58', '2019-08-12 14:10:58', 'IN245', '', '2031613406', 'VALIDE', 'ACTIVE', 3120, 1, 6113, 1),
(6766, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'INF243', '', '-1541129510', 'VALIDE', 'ACTIVE', 3120, 1, 6112, 1),
(6765, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'INF244', '', '1018325285', 'VALIDE', 'ACTIVE', 3120, 1, 6111, 1),
(6764, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'ENV241', '', '1857579362', 'VALIDE', 'ACTIVE', 3120, 1, 6110, 1),
(6763, '2019-08-12 14:10:57', '2019-08-12 14:10:57', 'STG241', '', '1900868368', 'VALIDE', 'ACTIVE', 3120, 1, 6116, 1),
(6762, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ETH231', '', '1561179114', 'VALIDE', 'ACTIVE', 3120, 1, 6106, 1),
(6761, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ANG241', '', '1382051949', 'VALIDE', 'ACTIVE', 3120, 1, 6114, 1),
(6760, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF242', '', '-1129745046', 'VALIDE', 'ACTIVE', 3120, 1, 6109, 1),
(6758, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ETH241', '', '-366997058', 'VALIDE', 'ACTIVE', 3119, 1, 6115, 1),
(6759, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF241', '', '-850440853', 'VALIDE', 'ACTIVE', 3120, 1, 6107, 1),
(6756, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF234', '', '853100040', 'VALIDE', 'ACTIVE', 3119, 1, 6104, 1),
(6757, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'ANG231', '', '-1122629672', 'VALIDE', 'ACTIVE', 3119, 1, 6105, 1),
(6755, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF236', '', '109061810', 'VALIDE', 'ACTIVE', 3119, 1, 6103, 1),
(6754, '2019-08-12 14:10:56', '2019-08-12 14:10:56', 'INF235', '', '2101663290', 'VALIDE', 'ACTIVE', 3119, 1, 6102, 1),
(6753, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF233', '', '-1343256791', 'VALIDE', 'ACTIVE', 3119, 1, 6101, 1),
(6752, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'MAT231', '', '934688378', 'VALIDE', 'ACTIVE', 3119, 1, 6069, 1),
(6751, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'MAT241', '', '1453094837', 'VALIDE', 'ACTIVE', 3119, 1, 6108, 1),
(6750, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF232', '', '894131602', 'VALIDE', 'ACTIVE', 3119, 1, 6068, 1),
(6748, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'IN245', '', '1738754199', 'VALIDE', 'ACTIVE', 3119, 1, 6113, 1),
(6749, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF231', '', '-1949874218', 'VALIDE', 'ACTIVE', 3119, 1, 6067, 1),
(6747, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF243', '', '1447995206', 'VALIDE', 'ACTIVE', 3119, 1, 6112, 1),
(6746, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF244', '', '670352728', 'VALIDE', 'ACTIVE', 3119, 1, 6111, 1),
(6745, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ENV241', '', '984927713', 'VALIDE', 'ACTIVE', 3119, 1, 6110, 1),
(6744, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'STG241', '', '-2086222620', 'VALIDE', 'ACTIVE', 3119, 1, 6116, 1),
(6742, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ANG241', '', '-1926042567', 'VALIDE', 'ACTIVE', 3119, 1, 6114, 1),
(6743, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ETH231', '', '1892203029', 'VALIDE', 'ACTIVE', 3119, 1, 6106, 1),
(6741, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF242', '', '-160508538', 'VALIDE', 'ACTIVE', 3119, 1, 6109, 1),
(6739, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'ETH241', '', '-1025151613', 'VALIDE', 'ACTIVE', 3118, 1, 6115, 1),
(6740, '2019-08-12 14:10:55', '2019-08-12 14:10:55', 'INF241', '', '-1020948423', 'VALIDE', 'ACTIVE', 3119, 1, 6107, 1),
(6738, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ANG231', '', '-2024385234', 'VALIDE', 'ACTIVE', 3118, 1, 6105, 1),
(6737, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF234', '', '193843218', 'VALIDE', 'ACTIVE', 3118, 1, 6104, 1),
(6736, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF236', '', '575219595', 'VALIDE', 'ACTIVE', 3118, 1, 6103, 1),
(6735, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF235', '', '-1679748740', 'VALIDE', 'ACTIVE', 3118, 1, 6102, 1),
(6734, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF233', '', '-882610341', 'VALIDE', 'ACTIVE', 3118, 1, 6101, 1),
(6731, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF232', '', '180863697', 'VALIDE', 'ACTIVE', 3118, 1, 6068, 1),
(6733, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'MAT231', '', '1399743896', 'VALIDE', 'ACTIVE', 3118, 1, 6069, 1),
(6732, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'MAT241', '', '1902718617', 'VALIDE', 'ACTIVE', 3118, 1, 6108, 1),
(6730, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF231', '', '1923925928', 'VALIDE', 'ACTIVE', 3118, 1, 6067, 1),
(6729, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'IN245', '', '1075088309', 'VALIDE', 'ACTIVE', 3118, 1, 6113, 1),
(6728, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF243', '', '1908641656', 'VALIDE', 'ACTIVE', 3118, 1, 6112, 1),
(6727, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'INF244', '', '1103442503', 'VALIDE', 'ACTIVE', 3118, 1, 6111, 1),
(6726, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ENV241', '', '1421324289', 'VALIDE', 'ACTIVE', 3118, 1, 6110, 1),
(6725, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'STG241', '', '-1979403877', 'VALIDE', 'ACTIVE', 3118, 1, 6116, 1),
(6724, '2019-08-12 14:10:54', '2019-08-12 14:10:54', 'ETH231', '', '1185548726', 'VALIDE', 'ACTIVE', 3118, 1, 6106, 1),
(6722, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF242', '', '-861651506', 'VALIDE', 'ACTIVE', 3118, 1, 6109, 1),
(6723, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ANG241', '', '1949962113', 'VALIDE', 'ACTIVE', 3118, 1, 6114, 1),
(6720, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ETH241', '', '355213261', 'VALIDE', 'ACTIVE', 3117, 1, 6115, 1),
(6721, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF241', '', '-894288874', 'VALIDE', 'ACTIVE', 3118, 1, 6107, 1),
(6719, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'ANG231', '', '-347510537', 'VALIDE', 'ACTIVE', 3117, 1, 6105, 1),
(6718, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF234', '', '1589639830', 'VALIDE', 'ACTIVE', 3117, 1, 6104, 1),
(6717, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF236', '', '877567343', 'VALIDE', 'ACTIVE', 3117, 1, 6103, 1),
(6716, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF235', '', '-1377400992', 'VALIDE', 'ACTIVE', 3117, 1, 6102, 1),
(6714, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'MAT231', '', '1799091140', 'VALIDE', 'ACTIVE', 3117, 1, 6069, 1),
(6715, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF233', '', '-811738663', 'VALIDE', 'ACTIVE', 3117, 1, 6101, 1),
(6713, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'MAT241', '', '-1703005214', 'VALIDE', 'ACTIVE', 3117, 1, 6108, 1),
(6712, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF232', '', '1669250737', 'VALIDE', 'ACTIVE', 3117, 1, 6068, 1),
(6711, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF231', '', '-1133971204', 'VALIDE', 'ACTIVE', 3117, 1, 6067, 1),
(6709, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'INF243', '', '-2039887212', 'VALIDE', 'ACTIVE', 3117, 1, 6112, 1),
(6710, '2019-08-12 14:10:53', '2019-08-12 14:10:53', 'IN245', '', '-1794321166', 'VALIDE', 'ACTIVE', 3117, 1, 6113, 1),
(6706, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'STG241', '', '-1619738245', 'VALIDE', 'ACTIVE', 3117, 1, 6116, 1),
(6707, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ENV241', '', '1733592440', 'VALIDE', 'ACTIVE', 3117, 1, 6110, 1),
(6708, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF244', '', '1422324256', 'VALIDE', 'ACTIVE', 3117, 1, 6111, 1),
(6705, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ETH231', '', '-1710315157', 'VALIDE', 'ACTIVE', 3117, 1, 6106, 1),
(6704, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ANG241', '', '-954719906', 'VALIDE', 'ACTIVE', 3117, 1, 6114, 1),
(6702, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF241', '', '567643758', 'VALIDE', 'ACTIVE', 3117, 1, 6107, 1),
(6703, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'INF242', '', '571622184', 'VALIDE', 'ACTIVE', 3117, 1, 6109, 1),
(6701, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ETH241', '', '-744331904', 'VALIDE', 'ACTIVE', 3114, 1, 6115, 1),
(6698, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF234', '', '85531924', 'VALIDE', 'ACTIVE', 3114, 1, 6104, 1),
(6699, '2019-08-12 14:10:52', '2019-08-12 14:10:52', 'ANG231', '', '-1285053205', 'VALIDE', 'ACTIVE', 3114, 1, 6105, 1),
(6697, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF236', '', '158273541', 'VALIDE', 'ACTIVE', 3114, 1, 6103, 1),
(6696, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF235', '', '1920501218', 'VALIDE', 'ACTIVE', 3114, 1, 6102, 1),
(6695, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF233', '', '-1187125161', 'VALIDE', 'ACTIVE', 3114, 1, 6101, 1),
(6694, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'MAT231', '', '1346545952', 'VALIDE', 'ACTIVE', 3114, 1, 6069, 1),
(6692, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF232', '', '711867263', 'VALIDE', 'ACTIVE', 3114, 1, 6068, 1),
(6693, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'MAT241', '', '1589385661', 'VALIDE', 'ACTIVE', 3114, 1, 6108, 1),
(6691, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF231', '', '1591854433', 'VALIDE', 'ACTIVE', 3114, 1, 6067, 1),
(6690, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'IN245', '', '973390617', 'VALIDE', 'ACTIVE', 3114, 1, 6113, 1),
(6688, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF244', '', '486986122', 'VALIDE', 'ACTIVE', 3114, 1, 6111, 1),
(6689, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF243', '', '1248094595', 'VALIDE', 'ACTIVE', 3114, 1, 6112, 1),
(6687, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ENV241', '', '1359308209', 'VALIDE', 'ACTIVE', 3114, 1, 6110, 1),
(6686, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'STG241', '', '-2049135826', 'VALIDE', 'ACTIVE', 3114, 1, 6116, 1),
(6685, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ETH231', '', '1871971939', 'VALIDE', 'ACTIVE', 3114, 1, 6106, 1),
(6684, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'ANG241', '', '-1945171390', 'VALIDE', 'ACTIVE', 3114, 1, 6114, 1),
(6683, '2019-08-12 14:10:51', '2019-08-12 14:10:51', 'INF242', '', '-188455497', 'VALIDE', 'ACTIVE', 3114, 1, 6109, 1),
(6682, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF241', '', '-999293367', 'VALIDE', 'ACTIVE', 3114, 1, 6107, 1),
(6681, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ETH241', '', '1864260562', 'VALIDE', 'ACTIVE', 3116, 1, 6115, 1),
(6680, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ANG231', '', '1110832482', 'VALIDE', 'ACTIVE', 3116, 1, 6105, 1),
(6679, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF234', '', '-964804095', 'VALIDE', 'ACTIVE', 3116, 1, 6104, 1),
(6678, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF236', '', '-582325451', 'VALIDE', 'ACTIVE', 3116, 1, 6103, 1),
(6676, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF233', '', '2009006368', 'VALIDE', 'ACTIVE', 3116, 1, 6101, 1),
(6677, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF235', '', '1447753107', 'VALIDE', 'ACTIVE', 3116, 1, 6102, 1),
(6675, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'MAT231', '', '299516734', 'VALIDE', 'ACTIVE', 3116, 1, 6069, 1),
(6674, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'MAT241', '', '-29720130', 'VALIDE', 'ACTIVE', 3116, 1, 6108, 1),
(6673, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF232', '', '-907238528', 'VALIDE', 'ACTIVE', 3116, 1, 6068, 1),
(6672, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF231', '', '515064006', 'VALIDE', 'ACTIVE', 3116, 1, 6067, 1),
(6668, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'ENV241', '', '301256321', 'VALIDE', 'ACTIVE', 3116, 1, 6110, 1),
(6669, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF244', '', '-276760477', 'VALIDE', 'ACTIVE', 3116, 1, 6111, 1),
(6670, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'INF243', '', '749994343', 'VALIDE', 'ACTIVE', 3116, 1, 6112, 1),
(6671, '2019-08-12 14:10:50', '2019-08-12 14:10:50', 'IN245', '', '-96786208', 'VALIDE', 'ACTIVE', 3116, 1, 6113, 1),
(6667, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'STG241', '', '395249609', 'VALIDE', 'ACTIVE', 3116, 1, 6116, 1),
(6666, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ETH231', '', '64378491', 'VALIDE', 'ACTIVE', 3116, 1, 6106, 1),
(6665, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ANG241', '', '549918327', 'VALIDE', 'ACTIVE', 3116, 1, 6114, 1),
(6664, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF242', '', '-1980617207', 'VALIDE', 'ACTIVE', 3116, 1, 6109, 1),
(6663, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF241', '', '-1734381024', 'VALIDE', 'ACTIVE', 3116, 1, 6107, 1),
(6662, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ETH241', '', '-1993674200', 'VALIDE', 'ACTIVE', 3115, 1, 6106, 1),
(6661, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'ANG231', '', '-2076402897', 'VALIDE', 'ACTIVE', 3115, 1, 6105, 1),
(6660, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF234', '', '155052759', 'VALIDE', 'ACTIVE', 3115, 1, 6104, 1),
(6659, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF236', '', '-593394539', 'VALIDE', 'ACTIVE', 3115, 1, 6103, 1),
(6658, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF235', '', '1439990820', 'VALIDE', 'ACTIVE', 3115, 1, 6102, 1),
(6657, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'INF233', '', '2058561965', 'VALIDE', 'ACTIVE', 3115, 1, 6101, 1),
(6656, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'MAT231', '', '634559484', 'VALIDE', 'ACTIVE', 3115, 1, 6069, 1),
(6655, '2019-08-12 14:10:49', '2019-08-12 14:10:49', 'MAT241', '', '1141943273', 'VALIDE', 'ACTIVE', 3115, 1, 6108, 1),
(6654, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF232', '', '8698931', 'VALIDE', 'ACTIVE', 3115, 1, 6068, 1),
(6650, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF244', '', '205986051', 'VALIDE', 'ACTIVE', 3115, 1, 6111, 1),
(6651, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF243', '', '687118706', 'VALIDE', 'ACTIVE', 3115, 1, 6112, 1),
(6652, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'IN245', '', '87245963', 'VALIDE', 'ACTIVE', 3115, 1, 6113, 1),
(6653, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF231', '', '927265446', 'VALIDE', 'ACTIVE', 3115, 1, 6067, 1),
(6649, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ENV241', '', '562447182', 'VALIDE', 'ACTIVE', 3115, 1, 6110, 1),
(6648, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'STG241', '', '622270193', 'VALIDE', 'ACTIVE', 3115, 1, 6116, 1),
(6647, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ETH231', '', '101809151', 'VALIDE', 'ACTIVE', 3115, 1, 6106, 1),
(6646, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'ANG241', '', '880552009', 'VALIDE', 'ACTIVE', 3115, 1, 6114, 1),
(6643, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'ETH241', '', '1136477796', 'VALIDE', 'ACTIVE', 3113, 1, 6106, 1),
(6644, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF241', '', '-1555860188', 'VALIDE', 'ACTIVE', 3115, 1, 6107, 1),
(6645, '2019-08-12 14:10:48', '2019-08-12 14:10:48', 'INF242', '', '-1285133148', 'VALIDE', 'ACTIVE', 3115, 1, 6109, 1),
(6641, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF234', '', '-620662290', 'VALIDE', 'ACTIVE', 3113, 1, 6104, 1),
(6642, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'ANG231', '', '1140828192', 'VALIDE', 'ACTIVE', 3113, 1, 6105, 1),
(6640, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF236', '', '-741919665', 'VALIDE', 'ACTIVE', 3113, 1, 6103, 1),
(6639, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF235', '', '535310532', 'VALIDE', 'ACTIVE', 3113, 1, 6102, 1),
(6638, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'INF233', '', '1127427269', 'VALIDE', 'ACTIVE', 3113, 1, 6101, 1),
(6637, '2019-08-12 14:10:47', '2019-08-12 14:10:47', 'MAT231', '', '-202882517', 'VALIDE', 'ACTIVE', 3113, 1, 6069, 1),
(6636, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'MAT241', '', '103888678', 'VALIDE', 'ACTIVE', 3113, 1, 6108, 1),
(6635, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF232', '', '-1577182363', 'VALIDE', 'ACTIVE', 3113, 1, 6068, 1),
(6634, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF231', '', '-44653129', 'VALIDE', 'ACTIVE', 3113, 1, 6067, 1),
(6632, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF243', '', '109811717', 'VALIDE', 'ACTIVE', 3113, 1, 6112, 1),
(6633, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'IN245', '', '-258584956', 'VALIDE', 'ACTIVE', 3113, 1, 6113, 1),
(6631, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'INF244', '', '-1701757207', 'VALIDE', 'ACTIVE', 3113, 1, 6111, 1),
(6630, '2019-08-12 14:10:46', '2019-08-12 14:10:46', 'ENV241', '', '-699367614', 'VALIDE', 'ACTIVE', 3113, 1, 6110, 1),
(6629, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'STG241', '', '29531466', 'VALIDE', 'ACTIVE', 3113, 1, 6116, 1),
(6626, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'INF242', '', '538832453', 'VALIDE', 'ACTIVE', 3113, 1, 6109, 1),
(6627, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'ANG241', '', '-146479916', 'VALIDE', 'ACTIVE', 3113, 1, 6114, 1),
(6628, '2019-08-12 14:10:45', '2019-08-12 14:10:45', 'ETH231', '', '-1298891287', 'VALIDE', 'ACTIVE', 3113, 1, 6106, 1),
(6625, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'INF241', '', '933874681', 'VALIDE', 'ACTIVE', 3113, 1, 6107, 1),
(6624, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'ETH241', '', '-1255444614', 'VALIDE', 'ACTIVE', 3112, 1, 6115, 1),
(6623, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'ANG231', '', '-1684806196', 'VALIDE', 'ACTIVE', 3112, 1, 6105, 1),
(6622, '2019-08-12 14:10:44', '2019-08-12 14:10:44', 'INF234', '', '-29836181', 'VALIDE', 'ACTIVE', 3112, 1, 6104, 1),
(6621, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF236', '', '-781590280', 'VALIDE', 'ACTIVE', 3112, 1, 6103, 1),
(6620, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF235', '', '1475555280', 'VALIDE', 'ACTIVE', 3112, 1, 6102, 1),
(6619, '2019-08-12 14:10:43', '2019-08-12 14:10:43', 'INF233', '', '1459220633', 'VALIDE', 'ACTIVE', 3112, 1, 6101, 1),
(6618, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'MAT231', '', '-317507288', 'VALIDE', 'ACTIVE', 3112, 1, 6069, 1),
(6616, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF232', '', '-1481274137', 'VALIDE', 'ACTIVE', 3112, 1, 6068, 1),
(6617, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'MAT241', '', '250501186', 'VALIDE', 'ACTIVE', 3112, 1, 6108, 1),
(6613, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF243', '', '-87483079', 'VALIDE', 'ACTIVE', 3112, 1, 6112, 1),
(6614, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'IN245', '', '-639958341', 'VALIDE', 'ACTIVE', 3112, 1, 6113, 1),
(6615, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF231', '', '249663157', 'VALIDE', 'ACTIVE', 3112, 1, 6067, 1),
(6611, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ENV241', '', '-24769213', 'VALIDE', 'ACTIVE', 3112, 1, 6110, 1),
(6612, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF244', '', '-591763341', 'VALIDE', 'ACTIVE', 3112, 1, 6111, 1),
(6610, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'STG241', '', '585085031', 'VALIDE', 'ACTIVE', 3112, 1, 6116, 1),
(6609, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ETH231', '', '269645651', 'VALIDE', 'ACTIVE', 3112, 1, 6106, 1),
(6608, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'ANG241', '', '229404128', 'VALIDE', 'ACTIVE', 3112, 1, 6114, 1),
(6607, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF242', '', '1735905412', 'VALIDE', 'ACTIVE', 3112, 1, 6109, 1),
(6605, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'ETH241', '', '-202752737', 'VALIDE', 'ACTIVE', 3111, 1, 6115, 1),
(6606, '2019-08-12 14:10:42', '2019-08-12 14:10:42', 'INF241', '', '1715392981', 'VALIDE', 'ACTIVE', 3112, 1, 6107, 1),
(6604, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'ANG231', '', '-1119316333', 'VALIDE', 'ACTIVE', 3111, 1, 6105, 1),
(6603, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF234', '', '266700534', 'VALIDE', 'ACTIVE', 3111, 1, 6104, 1),
(6602, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF236', '', '389044166', 'VALIDE', 'ACTIVE', 3111, 1, 6103, 1),
(6601, '2019-08-12 14:10:41', '2019-08-12 14:10:41', 'INF235', '', '-2073150365', 'VALIDE', 'ACTIVE', 3111, 1, 6102, 1),
(6552, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF233', '', '-1492430127', 'VALIDE', 'ACTIVE', 3111, 1, 6101, 1),
(6551, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'MAT231', '', '826298921', 'VALIDE', 'ACTIVE', 3111, 1, 6069, 1),
(6550, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'MAT241', '', '529027800', 'VALIDE', 'ACTIVE', 3111, 1, 6108, 1),
(6549, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF232', '', '-312115787', 'VALIDE', 'ACTIVE', 3111, 1, 6068, 1),
(6548, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF231', '', '1199470374', 'VALIDE', 'ACTIVE', 3111, 1, 6067, 1),
(6547, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'IN245', '', '913891192', 'VALIDE', 'ACTIVE', 3111, 1, 6113, 1),
(6546, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF243', '', '1249219855', 'VALIDE', 'ACTIVE', 3111, 1, 6112, 1),
(6543, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'STG241', '', '1308927513', 'VALIDE', 'ACTIVE', 3111, 1, 6116, 1),
(6545, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'INF244', '', '-264736979', 'VALIDE', 'ACTIVE', 3111, 1, 6111, 1),
(6544, '2019-08-12 14:10:40', '2019-08-12 14:10:40', 'ENV241', '', '117076293', 'VALIDE', 'ACTIVE', 3111, 1, 6110, 1),
(6542, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ETH231', '', '738864456', 'VALIDE', 'ACTIVE', 3111, 1, 6106, 1),
(6540, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF242', '', '-2003866253', 'VALIDE', 'ACTIVE', 3111, 1, 6109, 1),
(6541, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ANG241', '', '715156938', 'VALIDE', 'ACTIVE', 3111, 1, 6114, 1),
(6539, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF241', '', '-1709130322', 'VALIDE', 'ACTIVE', 3111, 1, 6107, 1),
(6538, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ETH241', '', '641196336', 'VALIDE', 'ACTIVE', 3110, 1, 6115, 1),
(6535, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF236', '', '1612173087', 'VALIDE', 'ACTIVE', 3110, 1, 6103, 1),
(6536, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'INF234', '', '1164660690', 'VALIDE', 'ACTIVE', 3110, 1, 6104, 1),
(6537, '2019-08-12 14:10:39', '2019-08-12 14:10:39', 'ANG231', '', '-832012095', 'VALIDE', 'ACTIVE', 3110, 1, 6105, 1),
(6534, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF235', '', '-804828497', 'VALIDE', 'ACTIVE', 3110, 1, 6102, 1),
(6533, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF233', '', '-755027124', 'VALIDE', 'ACTIVE', 3110, 1, 6101, 1),
(6532, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'MAT231', '', '1602281269', 'VALIDE', 'ACTIVE', 3110, 1, 6069, 1),
(6529, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF231', '', '-1932618857', 'VALIDE', 'ACTIVE', 3110, 1, 6067, 1),
(6531, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'MAT241', '', '-1801713322', 'VALIDE', 'ACTIVE', 3110, 1, 6108, 1),
(6530, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'INF232', '', '1400793511', 'VALIDE', 'ACTIVE', 3110, 1, 6068, 1),
(6528, '2019-08-12 14:10:38', '2019-08-12 14:10:38', 'IN245', '', '1515715354', 'VALIDE', 'ACTIVE', 3110, 1, 6113, 1),
(6527, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF243', '', '-1883971643', 'VALIDE', 'ACTIVE', 3110, 1, 6112, 1),
(6526, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF244', '', '1448172319', 'VALIDE', 'ACTIVE', 3110, 1, 6111, 1),
(6525, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ENV241', '', '1287670227', 'VALIDE', 'ACTIVE', 3110, 1, 6110, 1),
(6524, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'STG241', '', '1964762758', 'VALIDE', 'ACTIVE', 3110, 1, 6116, 1),
(6523, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ETH231', '', '1949140002', 'VALIDE', 'ACTIVE', 3110, 1, 6106, 1),
(6522, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'ANG241', '', '-1754469826', 'VALIDE', 'ACTIVE', 3110, 1, 6114, 1),
(6521, '2019-08-12 14:10:37', '2019-08-12 14:10:37', 'INF242', '', '-814533780', 'VALIDE', 'ACTIVE', 3110, 1, 6109, 1),
(6519, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'ETH241', '', '-1735214544', 'VALIDE', 'ACTIVE', 3109, 1, 6115, 1),
(6520, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF241', '', '-1002590795', 'VALIDE', 'ACTIVE', 3110, 1, 6107, 1),
(6518, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'ANG231', '', '846250115', 'VALIDE', 'ACTIVE', 3109, 1, 6105, 1),
(6517, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF234', '', '-1407953716', 'VALIDE', 'ACTIVE', 3109, 1, 6104, 1),
(6516, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF236', '', '-967054921', 'VALIDE', 'ACTIVE', 3109, 1, 6103, 1),
(6515, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF235', '', '914217592', 'VALIDE', 'ACTIVE', 3109, 1, 6102, 1),
(6514, '2019-08-12 14:10:36', '2019-08-12 14:10:36', 'INF233', '', '1018030048', 'VALIDE', 'ACTIVE', 3109, 1, 6101, 1),
(6512, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'MAT241', '', '-1037230455', 'VALIDE', 'ACTIVE', 3109, 1, 6108, 1),
(6513, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'MAT231', '', '-939469661', 'VALIDE', 'ACTIVE', 3109, 1, 6069, 1),
(6509, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'IN245', '', '-1588191746', 'VALIDE', 'ACTIVE', 3109, 1, 6113, 1),
(6510, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'INF231', '', '-867217099', 'VALIDE', 'ACTIVE', 3109, 1, 6067, 1),
(6511, '2019-08-12 14:10:35', '2019-08-12 14:10:35', 'INF232', '', '-2011748349', 'VALIDE', 'ACTIVE', 3109, 1, 6068, 1),
(6508, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'INF243', '', '-875887769', 'VALIDE', 'ACTIVE', 3109, 1, 6112, 1),
(6506, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'ENV241', '', '1765563674', 'VALIDE', 'ACTIVE', 3109, 1, 6110, 1),
(6507, '2019-08-12 14:10:34', '2019-08-12 14:10:34', 'INF244', '', '1717737303', 'VALIDE', 'ACTIVE', 3109, 1, 6111, 1),
(6504, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ETH231', '', '-1955012940', 'VALIDE', 'ACTIVE', 3109, 1, 6106, 1),
(6505, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'STG241', '', '-1424631495', 'VALIDE', 'ACTIVE', 3109, 1, 6116, 1),
(6503, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ANG241', '', '-1978720458', 'VALIDE', 'ACTIVE', 3109, 1, 6114, 1),
(6502, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'INF242', '', '-436946630', 'VALIDE', 'ACTIVE', 3109, 1, 6109, 1),
(6501, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'INF241', '', '-78279213', 'VALIDE', 'ACTIVE', 3109, 1, 6107, 1),
(6500, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ETH241', '', '1967096957', 'VALIDE', 'ACTIVE', 3108, 1, 6115, 1),
(6499, '2019-08-12 14:10:33', '2019-08-12 14:10:33', 'ANG231', '', '436570642', 'VALIDE', 'ACTIVE', 3108, 1, 6105, 1),
(6498, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF234', '', '-1817633189', 'VALIDE', 'ACTIVE', 3108, 1, 6104, 1),
(6497, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF236', '', '-1331541447', 'VALIDE', 'ACTIVE', 3108, 1, 6103, 1),
(6496, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF235', '', '554140134', 'VALIDE', 'ACTIVE', 3108, 1, 6102, 1),
(6492, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF232', '', '2025652320', 'VALIDE', 'ACTIVE', 3108, 1, 6068, 1),
(6493, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'MAT241', '', '-633436882', 'VALIDE', 'ACTIVE', 3108, 1, 6108, 1),
(6494, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'MAT231', '', '-1023980369', 'VALIDE', 'ACTIVE', 3108, 1, 6069, 1),
(6495, '2019-08-12 14:10:32', '2019-08-12 14:10:32', 'INF233', '', '364749568', 'VALIDE', 'ACTIVE', 3108, 1, 6101, 1),
(6491, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF231', '', '-428150982', 'VALIDE', 'ACTIVE', 3108, 1, 6067, 1),
(6490, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'IN245', '', '-1165659634', 'VALIDE', 'ACTIVE', 3108, 1, 6113, 1),
(6489, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF243', '', '-1352805529', 'VALIDE', 'ACTIVE', 3108, 1, 6112, 1),
(6488, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'INF244', '', '-2011403171', 'VALIDE', 'ACTIVE', 3108, 1, 6111, 1),
(6487, '2019-08-12 14:10:31', '2019-08-12 14:10:31', 'ENV241', '', '-1581090151', 'VALIDE', 'ACTIVE', 3108, 1, 6110, 1),
(6486, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'STG241', '', '-1644721044', 'VALIDE', 'ACTIVE', 3108, 1, 6116, 1),
(6485, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'ETH231', '', '-1793718107', 'VALIDE', 'ACTIVE', 3108, 1, 6106, 1),
(6484, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'ANG241', '', '-1759005474', 'VALIDE', 'ACTIVE', 3108, 1, 6114, 1),
(6483, '2019-08-12 14:10:30', '2019-08-12 14:10:30', 'INF242', '', '230288756', 'VALIDE', 'ACTIVE', 3108, 1, 6109, 1),
(6482, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF241', '', '-871547602', 'VALIDE', 'ACTIVE', 3108, 1, 6107, 1),
(6481, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'ETH241', '', '328187255', 'VALIDE', 'ACTIVE', 3107, 1, 6115, 1),
(6480, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'ANG231', '', '-1189111856', 'VALIDE', 'ACTIVE', 3107, 1, 6105, 1),
(6476, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF233', '', '-416596408', 'VALIDE', 'ACTIVE', 3107, 1, 6101, 1),
(6477, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF235', '', '-1056110626', 'VALIDE', 'ACTIVE', 3107, 1, 6102, 1),
(6478, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF236', '', '856052672', 'VALIDE', 'ACTIVE', 3107, 1, 6103, 1),
(6479, '2019-08-12 14:10:29', '2019-08-12 14:10:29', 'INF234', '', '776697453', 'VALIDE', 'ACTIVE', 3107, 1, 6104, 1),
(6472, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF231', '', '-1519233985', 'VALIDE', 'ACTIVE', 3107, 1, 6067, 1),
(6473, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF232', '', '730649922', 'VALIDE', 'ACTIVE', 3107, 1, 6068, 1),
(6474, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'MAT241', '', '1623600058', 'VALIDE', 'ACTIVE', 3107, 1, 6108, 1),
(6475, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'MAT231', '', '1368635412', 'VALIDE', 'ACTIVE', 3107, 1, 6069, 1),
(6471, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'IN245', '', '1890520881', 'VALIDE', 'ACTIVE', 3107, 1, 6113, 1),
(6469, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF244', '', '920221173', 'VALIDE', 'ACTIVE', 3107, 1, 6111, 1),
(6470, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'INF243', '', '-1815596342', 'VALIDE', 'ACTIVE', 3107, 1, 6112, 1),
(6468, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'ENV241', '', '1227080289', 'VALIDE', 'ACTIVE', 3107, 1, 6110, 1),
(6466, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'ETH231', '', '-2131952749', 'VALIDE', 'ACTIVE', 3107, 1, 6106, 1),
(6467, '2019-08-12 14:10:28', '2019-08-12 14:10:28', 'STG241', '', '-1865013117', 'VALIDE', 'ACTIVE', 3107, 1, 6116, 1),
(6465, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ANG241', '', '-1600117699', 'VALIDE', 'ACTIVE', 3107, 1, 6114, 1),
(6463, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF241', '', '-891227081', 'VALIDE', 'ACTIVE', 3107, 1, 6107, 1),
(6464, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF242', '', '-643647648', 'VALIDE', 'ACTIVE', 3107, 1, 6109, 1),
(6462, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ETH241', '', '-555510263', 'VALIDE', 'ACTIVE', 3106, 1, 6115, 1),
(6460, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF234', '', '793552074', 'VALIDE', 'ACTIVE', 3106, 1, 6104, 1),
(6461, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'ANG231', '', '-1232881920', 'VALIDE', 'ACTIVE', 3106, 1, 6105, 1),
(6459, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF236', '', '61638781', 'VALIDE', 'ACTIVE', 3106, 1, 6103, 1),
(6458, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF235', '', '1894411546', 'VALIDE', 'ACTIVE', 3106, 1, 6102, 1),
(6457, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'INF233', '', '-1281555387', 'VALIDE', 'ACTIVE', 3106, 1, 6101, 1),
(6456, '2019-08-12 14:10:27', '2019-08-12 14:10:27', 'MAT231', '', '1322660814', 'VALIDE', 'ACTIVE', 3106, 1, 6069, 1),
(6455, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'MAT241', '', '1642659213', 'VALIDE', 'ACTIVE', 3106, 1, 6108, 1),
(6454, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF232', '', '-74786639', 'VALIDE', 'ACTIVE', 3106, 1, 6068, 1),
(6453, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF231', '', '1415856449', 'VALIDE', 'ACTIVE', 3106, 1, 6067, 1),
(6451, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'INF243', '', '1481037668', 'VALIDE', 'ACTIVE', 3106, 1, 6112, 1),
(6452, '2019-08-12 14:10:26', '2019-08-12 14:10:26', 'IN245', '', '1164447544', 'VALIDE', 'ACTIVE', 3106, 1, 6113, 1),
(6446, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF244', '', '141116012', 'VALIDE', 'ACTIVE', 3106, 1, 6111, 1),
(6445, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ENV241', '', '-32613284', 'VALIDE', 'ACTIVE', 3106, 1, 6110, 1),
(6442, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ANG241', '', '1171714211', 'VALIDE', 'ACTIVE', 3106, 1, 6114, 1),
(6443, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ETH231', '', '690583443', 'VALIDE', 'ACTIVE', 3106, 1, 6106, 1),
(6444, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'STG241', '', '644479247', 'VALIDE', 'ACTIVE', 3106, 1, 6116, 1),
(6441, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF242', '', '-2103953815', 'VALIDE', 'ACTIVE', 3106, 1, 6109, 1),
(6440, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'INF241', '', '1947843116', 'VALIDE', 'ACTIVE', 3106, 1, 6107, 1),
(6439, '2019-08-12 14:10:25', '2019-08-12 14:10:25', 'ETH241', '', '1043682055', 'VALIDE', 'ACTIVE', 3105, 1, 6115, 1),
(6436, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF236', '', '1440377699', 'VALIDE', 'ACTIVE', 3105, 1, 6103, 1),
(6437, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF234', '', '1559430540', 'VALIDE', 'ACTIVE', 3105, 1, 6104, 1),
(6438, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'ANG231', '', '103970852', 'VALIDE', 'ACTIVE', 3105, 1, 6105, 1),
(6434, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF233', '', '-591733344', 'VALIDE', 'ACTIVE', 3105, 1, 6101, 1),
(6435, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'INF235', '', '-456353861', 'VALIDE', 'ACTIVE', 3105, 1, 6102, 1),
(6433, '2019-08-12 14:10:24', '2019-08-12 14:10:24', 'MAT231', '', '1831711069', 'VALIDE', 'ACTIVE', 3105, 1, 6069, 1),
(6432, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'MAT241', '', '-1833520801', 'VALIDE', 'ACTIVE', 3105, 1, 6108, 1),
(6431, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF232', '', '814545731', 'VALIDE', 'ACTIVE', 3105, 1, 6068, 1),
(6430, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF231', '', '-1871835908', 'VALIDE', 'ACTIVE', 3105, 1, 6067, 1),
(6429, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'IN245', '', '1922610141', 'VALIDE', 'ACTIVE', 3105, 1, 6113, 1),
(6428, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF243', '', '1723339309', 'VALIDE', 'ACTIVE', 3105, 1, 6112, 1),
(6427, '2019-08-12 14:10:23', '2019-08-12 14:10:23', 'INF244', '', '806811189', 'VALIDE', 'ACTIVE', 3105, 1, 6111, 1),
(6426, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ENV241', '', '1486236551', 'VALIDE', 'ACTIVE', 3105, 1, 6110, 1),
(6423, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ANG241', '', '1422956996', 'VALIDE', 'ACTIVE', 3105, 1, 6114, 1),
(6424, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'ETH231', '', '1559095748', 'VALIDE', 'ACTIVE', 3105, 1, 6106, 1),
(6425, '2019-08-12 14:10:22', '2019-08-12 14:10:22', 'STG241', '', '1701479209', 'VALIDE', 'ACTIVE', 3105, 1, 6116, 1),
(6422, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'INF242', '', '-920193148', 'VALIDE', 'ACTIVE', 3105, 1, 6109, 1),
(6421, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'INF241', '', '-1788348902', 'VALIDE', 'ACTIVE', 3105, 1, 6107, 1),
(6419, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'ANG231', '', '1272785137', 'VALIDE', 'ACTIVE', 3104, 1, 6105, 1),
(6417, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF236', '', '-1490674053', 'VALIDE', 'ACTIVE', 3104, 1, 6103, 1),
(6420, '2019-08-12 14:10:21', '2019-08-12 14:10:21', 'ETH241', '', '-1469610504', 'VALIDE', 'ACTIVE', 3104, 1, 6115, 1),
(6418, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF234', '', '-549330030', 'VALIDE', 'ACTIVE', 3104, 1, 6104, 1),
(6416, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF235', '', '569165714', 'VALIDE', 'ACTIVE', 3104, 1, 6102, 1),
(6415, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF233', '', '1702495548', 'VALIDE', 'ACTIVE', 3104, 1, 6101, 1),
(6412, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF232', '', '-687967989', 'VALIDE', 'ACTIVE', 3104, 1, 6068, 1),
(6414, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'MAT231', '', '-43368897', 'VALIDE', 'ACTIVE', 3104, 1, 6069, 1),
(6413, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'MAT241', '', '193959477', 'VALIDE', 'ACTIVE', 3104, 1, 6108, 1),
(6411, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF231', '', '198632783', 'VALIDE', 'ACTIVE', 3104, 1, 6067, 1),
(6410, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'IN245', '', '-409910630', 'VALIDE', 'ACTIVE', 3104, 1, 6113, 1),
(6409, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF243', '', '-139615720', 'VALIDE', 'ACTIVE', 3104, 1, 6112, 1),
(6408, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'INF244', '', '-974576082', 'VALIDE', 'ACTIVE', 3104, 1, 6111, 1),
(6407, '2019-08-12 14:10:20', '2019-08-12 14:10:20', 'ENV241', '', '-377820745', 'VALIDE', 'ACTIVE', 3104, 1, 6110, 1),
(6406, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'STG241', '', '782064732', 'VALIDE', 'ACTIVE', 3104, 1, 6116, 1),
(6405, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ETH231', '', '466625352', 'VALIDE', 'ACTIVE', 3104, 1, 6106, 1),
(6403, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF242', '', '-1593802084', 'VALIDE', 'ACTIVE', 3104, 1, 6109, 1),
(6404, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ANG241', '', '938937984', 'VALIDE', 'ACTIVE', 3104, 1, 6114, 1),
(6402, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF241', '', '1847338929', 'VALIDE', 'ACTIVE', 3104, 1, 6107, 1),
(6401, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ETH241', '', '-1767330541', 'VALIDE', 'ACTIVE', 3103, 1, 6115, 1),
(6400, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'ANG231', '', '1547141673', 'VALIDE', 'ACTIVE', 3103, 1, 6105, 1),
(6399, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF234', '', '-201121605', 'VALIDE', 'ACTIVE', 3103, 1, 6104, 1),
(6396, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF233', '', '-1766981712', 'VALIDE', 'ACTIVE', 3103, 1, 6101, 1),
(6397, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF235', '', '1632745422', 'VALIDE', 'ACTIVE', 3103, 1, 6102, 1),
(6398, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF236', '', '-90902910', 'VALIDE', 'ACTIVE', 3103, 1, 6103, 1),
(6395, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'MAT231', '', '-64419917', 'VALIDE', 'ACTIVE', 3103, 1, 6069, 1);
INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(6393, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'INF232', '', '-656110193', 'VALIDE', 'ACTIVE', 3103, 1, 6068, 1),
(6394, '2019-08-12 14:10:19', '2019-08-12 14:10:19', 'MAT241', '', '455088809', 'VALIDE', 'ACTIVE', 3103, 1, 6108, 1),
(6392, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF231', '', '1369132390', 'VALIDE', 'ACTIVE', 3103, 1, 6067, 1),
(6391, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'IN245', '', '737441370', 'VALIDE', 'ACTIVE', 3103, 1, 6113, 1),
(6389, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF244', '', '270877681', 'VALIDE', 'ACTIVE', 3103, 1, 6111, 1),
(6390, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF243', '', '1048520159', 'VALIDE', 'ACTIVE', 3103, 1, 6112, 1),
(6388, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ENV241', '', '18887428', 'VALIDE', 'ACTIVE', 3103, 1, 6110, 1),
(6386, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ETH231', '', '273620680', 'VALIDE', 'ACTIVE', 3103, 1, 6106, 1),
(6387, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'STG241', '', '883365349', 'VALIDE', 'ACTIVE', 3103, 1, 6116, 1),
(6385, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ANG241', '', '1060079407', 'VALIDE', 'ACTIVE', 3103, 1, 6114, 1),
(6384, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF242', '', '-1210321115', 'VALIDE', 'ACTIVE', 3103, 1, 6109, 1),
(6383, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF241', '', '-1459002815', 'VALIDE', 'ACTIVE', 3103, 1, 6107, 1),
(6382, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ETH241', '', '1220435571', 'VALIDE', 'ACTIVE', 3102, 1, 6115, 1),
(6381, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'ANG231', '', '-340954220', 'VALIDE', 'ACTIVE', 3102, 1, 6105, 1),
(6380, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF234', '', '1857433426', 'VALIDE', 'ACTIVE', 3102, 1, 6104, 1),
(6379, '2019-08-12 14:10:18', '2019-08-12 14:10:18', 'INF236', '', '1731766983', 'VALIDE', 'ACTIVE', 3102, 1, 6103, 1),
(6378, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF235', '', '-552962561', 'VALIDE', 'ACTIVE', 3102, 1, 6102, 1),
(6377, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF233', '', '631071555', 'VALIDE', 'ACTIVE', 3102, 1, 6101, 1),
(6376, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'MAT231', '', '-1398075509', 'VALIDE', 'ACTIVE', 3102, 1, 6069, 1),
(6375, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'MAT241', '', '-832271569', 'VALIDE', 'ACTIVE', 3102, 1, 6108, 1),
(6374, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF232', '', '1723204535', 'VALIDE', 'ACTIVE', 3102, 1, 6068, 1),
(6373, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF231', '', '-1080017406', 'VALIDE', 'ACTIVE', 3102, 1, 6067, 1),
(6372, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'IN245', '', '-1338039913', 'VALIDE', 'ACTIVE', 3102, 1, 6113, 1),
(6371, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF243', '', '-739269437', 'VALIDE', 'ACTIVE', 3102, 1, 6112, 1),
(6370, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'INF244', '', '-1802399068', 'VALIDE', 'ACTIVE', 3102, 1, 6111, 1),
(6369, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'ENV241', '', '-2014707709', 'VALIDE', 'ACTIVE', 3102, 1, 6110, 1),
(6368, '2019-08-12 14:10:17', '2019-08-12 14:10:17', 'STG241', '', '-1318876639', 'VALIDE', 'ACTIVE', 3102, 1, 6116, 1),
(6367, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ETH231', '', '-1347726599', 'VALIDE', 'ACTIVE', 3102, 1, 6106, 1),
(6366, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ANG241', '', '-778414471', 'VALIDE', 'ACTIVE', 3102, 1, 6114, 1),
(6364, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF241', '', '235804106', 'VALIDE', 'ACTIVE', 3102, 1, 6107, 1),
(6365, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF242', '', '1006960364', 'VALIDE', 'ACTIVE', 3102, 1, 6109, 1),
(6363, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ETH241', '', '1833025134', 'VALIDE', 'ACTIVE', 3101, 1, 6115, 1),
(6362, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'ANG231', '', '1464288237', 'VALIDE', 'ACTIVE', 3101, 1, 6105, 1),
(6359, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF235', '', '270159999', 'VALIDE', 'ACTIVE', 3101, 1, 6102, 1),
(6361, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF234', '', '-807551866', 'VALIDE', 'ACTIVE', 3101, 1, 6104, 1),
(6360, '2019-08-12 14:10:16', '2019-08-12 14:10:16', 'INF236', '', '-1515215285', 'VALIDE', 'ACTIVE', 3101, 1, 6103, 1),
(6358, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF233', '', '1157684292', 'VALIDE', 'ACTIVE', 3101, 1, 6101, 1),
(6357, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'MAT231', '', '-212307106', 'VALIDE', 'ACTIVE', 3101, 1, 6069, 1),
(6356, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'MAT241', '', '-737747496', 'VALIDE', 'ACTIVE', 3101, 1, 6108, 1),
(6355, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF232', '', '-1818083022', 'VALIDE', 'ACTIVE', 3101, 1, 6068, 1),
(6354, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF231', '', '244636639', 'VALIDE', 'ACTIVE', 3101, 1, 6067, 1),
(6353, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'IN245', '', '-496178814', 'VALIDE', 'ACTIVE', 3101, 1, 6113, 1),
(6351, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'INF244', '', '-1692443257', 'VALIDE', 'ACTIVE', 3101, 1, 6111, 1),
(6352, '2019-08-12 14:10:15', '2019-08-12 14:10:15', 'INF243', '', '-682222442', 'VALIDE', 'ACTIVE', 3101, 1, 6112, 1),
(6350, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ENV241', '', '-994279356', 'VALIDE', 'ACTIVE', 3101, 1, 6110, 1),
(6349, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'STG241', '', '-786752567', 'VALIDE', 'ACTIVE', 3101, 1, 6116, 1),
(6348, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ETH231', '', '-998578849', 'VALIDE', 'ACTIVE', 3101, 1, 6106, 1),
(6347, '2019-08-12 14:10:14', '2019-08-12 14:10:14', 'ANG241', '', '-327858157', 'VALIDE', 'ACTIVE', 3101, 1, 6114, 1),
(6346, '2019-08-12 14:10:13', '2019-08-12 14:10:13', 'INF242', '', '518385194', 'VALIDE', 'ACTIVE', 3101, 1, 6109, 1),
(6345, '2019-08-12 14:10:13', '2019-08-12 14:10:13', 'INF241', '', '-90737815', 'VALIDE', 'ACTIVE', 3101, 1, 6107, 1),
(6870, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'INF234', '', '-1023203110', 'VALIDE', 'ACTIVE', 3125, 1, 6104, 1),
(6871, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'ANG231', '', '1330204751', 'VALIDE', 'ACTIVE', 3125, 1, 6105, 1),
(6872, '2019-08-12 14:11:09', '2019-08-12 14:11:09', 'ETH241', '', '1722089255', 'VALIDE', 'ACTIVE', 3125, 1, 6115, 1);

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

CREATE TABLE `etudiant` (
  `code` bigint(20) NOT NULL,
  `code_authentification` varchar(255) DEFAULT NULL,
  `matricule` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`code`, `code_authentification`, `matricule`) VALUES
(3121, '1624.387852054459', '1718L032'),
(3120, '1493.3914477525109', '1718L024'),
(3119, '2094.781637709097', '1617L25'),
(3118, '1625.5235243470318', '1718L005'),
(3117, '1691.914686872678', '1718L023'),
(3116, '1941.4693836637673', '1718L035'),
(3115, '1855.0011168175342', '1819L108'),
(3114, '1986.9911219545875', '1617L22'),
(3113, '1264.2535774992382', '1718L037'),
(3112, '1521.243114904074', '1718L033'),
(3111, '1669.7998154893905', '1718L021'),
(3110, '1775.1462261210345', '1718L030'),
(3109, '2041.0909754457984', '1718L020'),
(3108, '1268.1150037150248', '1718L003'),
(3107, '1728.5890374939938', '1819L107'),
(3106, '1477.9004699436466', '1718L019'),
(3105, '1631.2210634467656', '1617L13'),
(3104, '1381.651049770484', '1718L016'),
(3102, '1697.3237691072713', '1718L001'),
(3103, '1456.5303671938777', '1718L014'),
(3101, '1474.642074511742', '1819L106'),
(3122, '1648.9812499140207', '1718L025'),
(3123, '1760.329992808751', '1718L031'),
(3124, '1548.854377891203', '1718L006'),
(3125, '1858.271683706163', '1718L011');

-- --------------------------------------------------------

--
-- Structure de la table `evaluation`
--

CREATE TABLE `evaluation` (
  `code` bigint(20) NOT NULL,
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
  `type_evaluation` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `evaluation`
--

INSERT INTO `evaluation` (`code`, `date_creation`, `date_evaluation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `type_evaluation`) VALUES
(6266, '2019-08-12 14:07:29', '2019-02-11 23:00:00', '2019-08-12 14:07:30', 'TP INF242', 'Travaux pratiques', '-929581291', 'ACTIVE', 'ACTIVE', 1, 1, 6142),
(6264, '2019-08-12 14:07:29', '2019-02-13 23:00:00', '2019-08-12 14:07:29', 'TP INF235', 'Travaux pratiques', '531728743', 'ACTIVE', 'ACTIVE', 1, 1, 6212),
(6265, '2019-08-12 14:07:29', '2019-02-10 23:00:00', '2019-08-12 14:07:29', 'TP INF241', 'Travaux pratiques', '-698568839', 'ACTIVE', 'ACTIVE', 1, 1, 6137),
(6262, '2019-08-12 14:07:29', '2019-02-12 23:00:00', '2019-08-12 14:07:29', 'TP INF233', 'Travaux pratiques', '1604870300', 'ACTIVE', 'ACTIVE', 1, 1, 6209),
(6263, '2019-08-12 14:07:29', '2019-02-14 23:00:00', '2019-08-12 14:07:29', 'TP INF234', 'Travaux pratiques', '1124120311', 'ACTIVE', 'ACTIVE', 1, 1, 6220),
(6258, '2019-08-12 14:07:28', '2019-06-07 22:00:00', '2019-08-12 14:07:28', 'SN INF243', 'Session normale', '-1250693684', 'ACTIVE', 'ACTIVE', 1, 1, 6157),
(6259, '2019-08-12 14:07:28', '2019-06-08 22:00:00', '2019-08-12 14:07:28', 'SN INF244', 'Session normale', '-539212326', 'ACTIVE', 'ACTIVE', 1, 1, 6154),
(6260, '2019-08-12 14:07:28', '2018-02-04 23:00:00', '2019-08-12 14:07:28', 'SN MAT231', 'Session normale', '-498288759', 'ACTIVE', 'ACTIVE', 1, 1, 6205),
(6261, '2019-08-12 14:07:29', '2019-06-06 22:00:00', '2019-08-12 14:07:29', 'SN MAT241', 'Session normale', '-819851818', 'ACTIVE', 'ACTIVE', 1, 1, 6202),
(6256, '2019-08-12 14:07:28', '2019-02-09 23:00:00', '2019-08-12 14:07:28', 'SN INF241', 'Session normale', '1505655954', 'ACTIVE', 'ACTIVE', 1, 1, 6136),
(6257, '2019-08-12 14:07:28', '2019-02-10 23:00:00', '2019-08-12 14:07:28', 'SN INF242', 'Session normale', '380704004', 'ACTIVE', 'ACTIVE', 1, 1, 6140),
(6255, '2019-08-12 14:07:28', '2018-02-05 23:00:00', '2019-08-12 14:07:28', 'SN INF236', 'Session normale', '-1300639738', 'ACTIVE', 'ACTIVE', 1, 1, 6215),
(6254, '2019-08-12 14:07:28', '2019-06-04 22:00:00', '2019-08-12 14:07:28', 'SN INF235', 'Session normale', '-807087346', 'ACTIVE', 'ACTIVE', 1, 1, 6211),
(6253, '2019-08-12 14:07:27', '2018-02-04 23:00:00', '2019-08-12 14:07:27', 'SN INF234', 'Session normale', '-2078740871', 'ACTIVE', 'ACTIVE', 1, 1, 6219),
(6248, '2019-08-12 14:07:27', '2019-06-03 22:00:00', '2019-08-12 14:07:27', 'SN ETH231', 'Session normale', '1418682290', 'ACTIVE', 'ACTIVE', 1, 1, 6148),
(6249, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN ETH241', 'Session normale', '-581858834', 'ACTIVE', 'ACTIVE', 1, 1, 6225),
(6250, '2019-08-12 14:07:27', '2019-02-07 23:00:00', '2019-08-12 14:07:27', 'SN INF231', 'Session normale', '921799698', 'ACTIVE', 'ACTIVE', 1, 1, 6163),
(6251, '2019-08-12 14:07:27', '2018-02-05 23:00:00', '2019-08-12 14:07:27', 'SN INF232', 'Session normale', '-1910097535', 'ACTIVE', 'ACTIVE', 1, 1, 6166),
(6252, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN INF233', 'Session normale', '-1723651806', 'ACTIVE', 'ACTIVE', 1, 1, 6208),
(6247, '2019-08-12 14:07:27', '2019-06-07 22:00:00', '2019-08-12 14:07:27', 'SN ENV241', 'Session normale', '119649611', 'ACTIVE', 'ACTIVE', 1, 1, 6151),
(6246, '2019-08-12 14:07:27', '2018-02-07 23:00:00', '2019-08-12 14:07:27', 'SN ANG241', 'Session normale', '1689275090', 'ACTIVE', 'ACTIVE', 1, 1, 6145),
(6245, '2019-08-12 14:07:27', '2019-06-04 22:00:00', '2019-08-12 14:07:27', 'SN ANG231', 'Session normale', '-1646222230', 'ACTIVE', 'ACTIVE', 1, 1, 6222),
(6244, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC MAT241', 'Controle Continu', '-1592805083', 'ACTIVE', 'ACTIVE', 1, 1, 6201),
(6243, '2019-08-12 14:07:26', '2018-10-19 22:00:00', '2019-08-12 14:07:26', 'CC MAT231', 'Controle Continu', '-753082685', 'ACTIVE', 'ACTIVE', 1, 1, 6204),
(6242, '2019-08-12 14:07:26', '2019-04-19 22:00:00', '2019-08-12 14:07:26', 'CC INF245', 'Controle Continu', '191618888', 'ACTIVE', 'ACTIVE', 1, 1, 6159),
(6240, '2019-08-12 14:07:26', '2019-04-19 22:00:00', '2019-08-12 14:07:26', 'CC INF243', 'Controle Continu', '-202314935', 'ACTIVE', 'ACTIVE', 1, 1, 6156),
(6241, '2019-08-12 14:07:26', '2019-04-12 22:00:00', '2019-08-12 14:07:26', 'CC INF244', 'Controle Continu', '1424843400', 'ACTIVE', 'ACTIVE', 1, 1, 6153),
(6238, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC INF241', 'Controle Continu', '-8396137', 'ACTIVE', 'ACTIVE', 1, 1, 6135),
(6239, '2019-08-12 14:07:26', '2019-04-05 22:00:00', '2019-08-12 14:07:26', 'CC INF242', 'Controle Continu', '-1781168961', 'ACTIVE', 'ACTIVE', 1, 1, 6139),
(6237, '2019-08-12 14:07:25', '2018-11-16 23:00:00', '2019-08-12 14:07:25', 'CC INF236', 'Controle Continu', '1589975745', 'ACTIVE', 'ACTIVE', 1, 1, 6214),
(6235, '2019-08-12 14:07:25', '2018-10-26 22:00:00', '2019-08-12 14:07:25', 'CC INF234', 'Controle Continu', '-751889142', 'ACTIVE', 'ACTIVE', 1, 1, 6218),
(6236, '2019-08-12 14:07:25', '2018-11-09 23:00:00', '2019-08-12 14:07:25', 'CC INF235', 'Controle Continu', '1463135945', 'ACTIVE', 'ACTIVE', 1, 1, 6210),
(6233, '2019-08-12 14:07:25', '2018-10-19 22:00:00', '2019-08-12 14:07:25', 'CC INF232', 'Controle Continu', '895819126', 'ACTIVE', 'ACTIVE', 1, 1, 6165),
(6234, '2019-08-12 14:07:25', '2018-11-02 23:00:00', '2019-08-12 14:07:25', 'CC INF233', 'Controle Continu', '-1917780183', 'ACTIVE', 'ACTIVE', 1, 1, 6207),
(6231, '2019-08-12 14:07:25', '2019-04-26 22:00:00', '2019-08-12 14:07:25', 'CC ETH241', 'Controle Continu', '696056612', 'ACTIVE', 'ACTIVE', 1, 1, 6224),
(6232, '2019-08-12 14:07:25', '2018-10-26 22:00:00', '2019-08-12 14:07:25', 'CC INF231', 'Controle Continu', '1318930053', 'ACTIVE', 'ACTIVE', 1, 1, 6162),
(6230, '2019-08-12 14:07:24', '2018-11-02 23:00:00', '2019-08-12 14:07:24', 'CC ETH231', 'Controle Continu', '-1385599868', 'ACTIVE', 'ACTIVE', 1, 1, 6146),
(6227, '2019-08-12 14:07:23', '2018-11-02 23:00:00', '2019-08-12 14:07:24', 'CC ANG231', 'Controle Continu', '2101651604', 'ACTIVE', 'ACTIVE', 1, 1, 6221),
(6229, '2019-08-12 14:07:24', '2019-04-12 22:00:00', '2019-08-12 14:07:24', 'CC ENV241', 'Controle Continu', '-1929393729', 'ACTIVE', 'ACTIVE', 1, 1, 6150),
(6228, '2019-08-12 14:07:24', '2019-04-26 22:00:00', '2019-08-12 14:07:24', 'CC ANG241', 'Controle Continu', '8558044', 'ACTIVE', 'ACTIVE', 1, 1, 6143);

-- --------------------------------------------------------

--
-- Structure de la table `filiere`
--

CREATE TABLE `filiere` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `filiere`
--

INSERT INTO `filiere` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(2, '2019-08-02 10:25:34', '2019-08-02 10:31:03', 'Licence Informatique', 'Licence', '-848006121', 'ACTIVE', 1, 1),
(3, '2019-08-02 10:29:14', '2019-08-02 10:29:14', 'Ingénieur  Informatique', 'Ingénieur', '-847785401', 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `historique_note`
--

CREATE TABLE `historique_note` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `valeur_note` double NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL,
  `note` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `historique_note`
--

INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(1169, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Éthique et Philosophie', '2098908625', 'ACTIVE', 14, 1, 1, 6967),
(1168, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Éthique et Philosophie', '-40294886', 'ACTIVE', 14, 1, 1, 6967),
(1167, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Éthique et Philosophie', '-1516611805', 'ACTIVE', 16, 1, 1, 6966),
(1166, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Éthique et Philosophie', '640075501', 'ACTIVE', 16, 1, 1, 6966),
(1165, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Anglais niveau pratique B1/B2', '-1449729135', 'ACTIVE', 14, 1, 1, 6965),
(1164, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Anglais niveau pratique B1/B2', '707881692', 'ACTIVE', 14, 1, 1, 6965),
(1163, '2019-08-12 14:12:30', '2019-08-12 14:12:29', NULL, 'Anglais niveau pratique B1/B2', '1262754890', 'ACTIVE', 14.4, 1, 1, 6964),
(1162, '2019-08-12 14:12:30', '2019-08-12 14:12:30', NULL, 'Anglais niveau pratique B1/B2', '-873678058', 'ACTIVE', 14.4, 1, 1, 6964),
(1161, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '1739262478', 'ACTIVE', 17.5, 1, 1, 6963),
(1160, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-396246949', 'ACTIVE', 17.5, 1, 1, 6963),
(1159, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '1427585580', 'ACTIVE', 11, 1, 1, 6962),
(1158, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-707000326', 'ACTIVE', 11, 1, 1, 6962),
(1157, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '-1260486830', 'ACTIVE', 12.5, 1, 1, 6961),
(1156, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Systèmes d\'exploitation', '900818081', 'ACTIVE', 12.5, 1, 1, 6961),
(1155, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '63556781', 'ACTIVE', 10.75, 1, 1, 6960),
(1154, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '-2069182083', 'ACTIVE', 10.75, 1, 1, 6960),
(1153, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Réseaux informatiques', '878533126', 'ACTIVE', 9.5, 1, 1, 6959),
(1152, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Réseaux informatiques', '-1253282217', 'ACTIVE', 9.5, 1, 1, 6959),
(1151, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-368844606', 'ACTIVE', 16, 1, 1, 6958),
(1150, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '1795230868', 'ACTIVE', 16, 1, 1, 6958),
(1149, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-1250150641', 'ACTIVE', 17.25, 1, 1, 6957),
(1148, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '914848354', 'ACTIVE', 17.25, 1, 1, 6957),
(1147, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Introduction aux Base de données', '-1896186393', 'ACTIVE', 12.25, 1, 1, 6956),
(1146, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Introduction aux Base de données', '269736123', 'ACTIVE', 12.25, 1, 1, 6956),
(1145, '2019-08-12 14:12:29', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '1168142587', 'ACTIVE', 16.5, 1, 1, 6955),
(1144, '2019-08-12 14:12:29', '2019-08-12 14:12:29', NULL, 'Programmation Orientée Objet II', '-959978672', 'ACTIVE', 16.5, 1, 1, 6955),
(1143, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '1403736576', 'ACTIVE', 7, 1, 1, 6954),
(1142, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '-723461162', 'ACTIVE', 7, 1, 1, 6954),
(1141, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '209491517', 'ACTIVE', 14.75, 1, 1, 6953),
(1140, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Programmation Orientée Objet II', '-1916782700', 'ACTIVE', 14.75, 1, 1, 6953),
(1139, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '-360355024', 'ACTIVE', 19, 1, 1, 6952),
(1138, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '1809261576', 'ACTIVE', 19, 1, 1, 6952),
(1137, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '-968714662', 'ACTIVE', 18.33, 1, 1, 6951),
(1136, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algèbre linaire I', '1201825459', 'ACTIVE', 18.33, 1, 1, 6951),
(1135, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '-506194770', 'ACTIVE', 12, 1, 1, 6950),
(1134, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '1665268872', 'ACTIVE', 12, 1, 1, 6950),
(1133, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'modélisation des Systèmes d\'Information(UML)', '27078038', 'ACTIVE', 12.75, 1, 1, 6949),
(1132, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2095502095', 'ACTIVE', 12.75, 1, 1, 6949),
(1131, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Algorithmique et Complexité', '-1810460163', 'ACTIVE', 9, 1, 1, 6948),
(1130, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algorithmique et Complexité', '362850521', 'ACTIVE', 9, 1, 1, 6948),
(1129, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Algorithmique et Complexité', '-788473868', 'ACTIVE', 12, 1, 1, 6947),
(1128, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Algorithmique et Complexité', '1385760337', 'ACTIVE', 12, 1, 1, 6947),
(1127, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Introduction à la sécurité informatique', '1281425521', 'ACTIVE', 11.5, 1, 1, 6946),
(1126, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Introduction à la sécurité informatique', '-838384049', 'ACTIVE', 11.5, 1, 1, 6946),
(1125, '2019-08-12 14:12:28', '2019-08-12 14:12:27', NULL, 'Introduction à la sécurité informatique', '-976183367', 'ACTIVE', 12.88, 1, 1, 6945),
(1124, '2019-08-12 14:12:28', '2019-08-12 14:12:28', NULL, 'Introduction à la sécurité informatique', '1199897880', 'ACTIVE', 12.88, 1, 1, 6945),
(1123, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '1312660156', 'ACTIVE', 12.5, 1, 1, 6944),
(1122, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '-805302372', 'ACTIVE', 12.5, 1, 1, 6944),
(1121, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '1016103447', 'ACTIVE', 18.17, 1, 1, 6943),
(1120, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'économie numérique', '-1100935560', 'ACTIVE', 18.17, 1, 1, 6943),
(1119, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-38323471', 'ACTIVE', 13, 1, 1, 6942),
(1118, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '2140528339', 'ACTIVE', 13, 1, 1, 6942),
(1117, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1582024002', 'ACTIVE', 14.33, 1, 1, 6941),
(1116, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '597751329', 'ACTIVE', 14.33, 1, 1, 6941),
(1115, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '-334849862', 'ACTIVE', 17.5, 1, 1, 6940),
(1114, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '1845848990', 'ACTIVE', 17.5, 1, 1, 6940),
(1113, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Ethique et Développement    ', '-468081918', 'ACTIVE', 13.5, 1, 1, 6939),
(1112, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Ethique et Développement    ', '1713540455', 'ACTIVE', 13.5, 1, 1, 6939),
(1111, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Anglais Niveau pratique B2', '2025778216', 'ACTIVE', 15.2, 1, 1, 6938),
(1110, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Anglais Niveau pratique B2', '-86643186', 'ACTIVE', 15.2, 1, 1, 6938),
(1109, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Anglais Niveau pratique B2', '-1181068069', 'ACTIVE', 12.5, 1, 1, 6937),
(1108, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Anglais Niveau pratique B2', '1002401346', 'ACTIVE', 12.5, 1, 1, 6937),
(1107, '2019-08-12 14:12:27', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1659968000', 'ACTIVE', 14.5, 1, 1, 6936),
(1106, '2019-08-12 14:12:27', '2019-08-12 14:12:27', NULL, 'Programmation Web II', '-450606360', 'ACTIVE', 14.5, 1, 1, 6936),
(1105, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1976228664', 'ACTIVE', 16.5, 1, 1, 6935),
(1104, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '-133422175', 'ACTIVE', 16.5, 1, 1, 6935),
(1103, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '1976585300', 'ACTIVE', 14, 1, 1, 6934),
(1102, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Programmation Web II', '-132142018', 'ACTIVE', 14, 1, 1, 6934),
(1101, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '1534726705', 'ACTIVE', 14, 1, 1, 6933),
(1100, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '-573077092', 'ACTIVE', 14, 1, 1, 6933),
(1098, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '1230939215', 'ACTIVE', 16.25, 1, 1, 6932),
(1099, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Algèbre linéaire II', '-957147805', 'ACTIVE', 16.25, 1, 1, 6932),
(1097, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '-360426891', 'ACTIVE', 16, 1, 1, 6931),
(1096, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '1828583650', 'ACTIVE', 16, 1, 1, 6931),
(1095, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Langage C++ et POO', '1679180139', 'ACTIVE', 16, 1, 1, 6930),
(1094, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '-425853095', 'ACTIVE', 16, 1, 1, 6930),
(1093, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Langage C++ et POO', '-1720573449', 'ACTIVE', 15.33, 1, 1, 6929),
(1092, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Langage C++ et POO', '470284134', 'ACTIVE', 15.33, 1, 1, 6929),
(1091, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Éthique et Philosophie', '1478671768', 'ACTIVE', 17.75, 1, 1, 6928),
(1090, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Éthique et Philosophie', '-624514424', 'ACTIVE', 17.75, 1, 1, 6928),
(1089, '2019-08-12 14:12:26', '2019-08-12 14:12:25', NULL, 'Éthique et Philosophie', '609071466', 'ACTIVE', 15.75, 1, 1, 6927),
(1088, '2019-08-12 14:12:26', '2019-08-12 14:12:26', NULL, 'Éthique et Philosophie', '-1493191205', 'ACTIVE', 15.75, 1, 1, 6927),
(1087, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '1055377856', 'ACTIVE', 13.4, 1, 1, 6926),
(1086, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '-1045961294', 'ACTIVE', 13.4, 1, 1, 6926),
(1085, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '-1642523596', 'ACTIVE', 16, 1, 1, 6925),
(1084, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Anglais niveau pratique B1/B2', '552028071', 'ACTIVE', 16, 1, 1, 6925),
(1083, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-1231845138', 'ACTIVE', 18.25, 1, 1, 6924),
(1082, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '963630050', 'ACTIVE', 18.25, 1, 1, 6924),
(1081, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-150161336', 'ACTIVE', 15, 1, 1, 6923),
(1080, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '2046237373', 'ACTIVE', 15, 1, 1, 6923),
(1079, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Systèmes d\'exploitation', '1610009698', 'ACTIVE', 13.5, 1, 1, 6922),
(1078, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Systèmes d\'exploitation', '-487635368', 'ACTIVE', 13.5, 1, 1, 6922),
(1077, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Réseaux informatiques', '90117021', 'ACTIVE', 10.5, 1, 1, 6921),
(1076, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Réseaux informatiques', '-2006604524', 'ACTIVE', 10.5, 1, 1, 6921),
(1075, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Réseaux informatiques', '-1741159575', 'ACTIVE', 10, 1, 1, 6920),
(1074, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Réseaux informatiques', '458009697', 'ACTIVE', 10, 1, 1, 6920),
(1073, '2019-08-12 14:12:25', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '1866204762', 'ACTIVE', 12, 1, 1, 6919),
(1072, '2019-08-12 14:12:25', '2019-08-12 14:12:25', NULL, 'Introduction aux Base de données', '-228669741', 'ACTIVE', 12, 1, 1, 6919),
(1071, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '951383112', 'ACTIVE', 9.25, 1, 1, 6918),
(1070, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '-1142567870', 'ACTIVE', 9.25, 1, 1, 6918),
(1069, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '302525619', 'ACTIVE', 12.25, 1, 1, 6917),
(1068, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Introduction aux Base de données', '-1790501842', 'ACTIVE', 12.25, 1, 1, 6917),
(1067, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '-1704713044', 'ACTIVE', 17.75, 1, 1, 6916),
(1066, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '498150312', 'ACTIVE', 17.75, 1, 1, 6916),
(1065, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Programmation Orientée Objet II', '-253134957', 'ACTIVE', 12.5, 1, 1, 6915),
(1064, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '1950651920', 'ACTIVE', 12.5, 1, 1, 6915),
(1063, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Programmation Orientée Objet II', '680584593', 'ACTIVE', 13.25, 1, 1, 6914),
(1062, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Programmation Orientée Objet II', '-1409672305', 'ACTIVE', 13.25, 1, 1, 6914),
(1061, '2019-08-12 14:12:24', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '50375616', 'ACTIVE', 11.5, 1, 1, 6913),
(1060, '2019-08-12 14:12:24', '2019-08-12 14:12:24', NULL, 'Algèbre linaire I', '-2038957761', 'ACTIVE', 11.5, 1, 1, 6913),
(1059, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '1761550046', 'ACTIVE', 14, 1, 1, 6912),
(1058, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algèbre linaire I', '-326859810', 'ACTIVE', 14, 1, 1, 6912),
(1057, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1238004792', 'ACTIVE', 12, 1, 1, 6911),
(1056, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '969476169', 'ACTIVE', 12, 1, 1, 6911),
(1055, '2019-08-12 14:12:23', '2019-08-12 14:12:22', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2103005851', 'ACTIVE', 12.75, 1, 1, 6910),
(1054, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'modélisation des Systèmes d\'Information(UML)', '105398631', 'ACTIVE', 12.75, 1, 1, 6910),
(1053, '2019-08-12 14:12:23', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '-417659134', 'ACTIVE', 15, 1, 1, 6909),
(1052, '2019-08-12 14:12:23', '2019-08-12 14:12:23', NULL, 'Algorithmique et Complexité', '1791668869', 'ACTIVE', 15, 1, 1, 6909),
(1051, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '-1935899912', 'ACTIVE', 11.83, 1, 1, 6908),
(1050, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Algorithmique et Complexité', '274351612', 'ACTIVE', 11.83, 1, 1, 6908),
(1049, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '-1806584234', 'ACTIVE', 9.25, 1, 1, 6907),
(1048, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '404590811', 'ACTIVE', 9.25, 1, 1, 6907),
(1047, '2019-08-12 14:12:22', '2019-08-12 14:12:21', NULL, 'Introduction à la sécurité informatique', '-1704626758', 'ACTIVE', 9.63, 1, 1, 6906),
(1046, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'Introduction à la sécurité informatique', '507471808', 'ACTIVE', 9.63, 1, 1, 6906),
(1045, '2019-08-12 14:12:22', '2019-08-12 14:12:21', NULL, 'économie numérique', '-1797732714', 'ACTIVE', 15, 1, 1, 6905),
(1044, '2019-08-12 14:12:22', '2019-08-12 14:12:22', NULL, 'économie numérique', '415289373', 'ACTIVE', 15, 1, 1, 6905),
(1043, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'économie numérique', '1667562774', 'ACTIVE', 16, 1, 1, 6904),
(1042, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'économie numérique', '-413458914', 'ACTIVE', 16, 1, 1, 6904),
(1041, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1421583147', 'ACTIVE', 16, 1, 1, 6903),
(1040, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-658515020', 'ACTIVE', 16, 1, 1, 6903),
(1039, '2019-08-12 14:12:21', '2019-08-12 14:12:20', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-800246776', 'ACTIVE', 15, 1, 1, 6902),
(1038, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1415545874', 'ACTIVE', 15, 1, 1, 6902),
(1037, '2019-08-12 14:12:21', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '688467954', 'ACTIVE', 14.5, 1, 1, 6901),
(1036, '2019-08-12 14:12:21', '2019-08-12 14:12:21', NULL, 'Ethique et Développement    ', '-1389783171', 'ACTIVE', 14.5, 1, 1, 6901),
(1035, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '1564787897', 'ACTIVE', 15.75, 1, 1, 6883),
(1034, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Ethique et Développement    ', '-496839850', 'ACTIVE', 15.75, 1, 1, 6883),
(1033, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '-927086301', 'ACTIVE', 12.2, 1, 1, 6882),
(1032, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '1307176769', 'ACTIVE', 12.2, 1, 1, 6882),
(1031, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Anglais Niveau pratique B2', '-1685393766', 'ACTIVE', 11.1, 1, 1, 6881),
(1030, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Anglais Niveau pratique B2', '549792825', 'ACTIVE', 11.1, 1, 1, 6881),
(1029, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-424752414', 'ACTIVE', 14.5, 1, 1, 6880),
(1028, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Programmation Web II', '1811357698', 'ACTIVE', 14.5, 1, 1, 6880),
(1027, '2019-08-12 14:12:20', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-134661348', 'ACTIVE', 13, 1, 1, 6879),
(1026, '2019-08-12 14:12:20', '2019-08-12 14:12:20', NULL, 'Programmation Web II', '2102372285', 'ACTIVE', 13, 1, 1, 6879),
(1025, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '-1303699301', 'ACTIVE', 6.5, 1, 1, 6878),
(1024, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Programmation Web II', '934257853', 'ACTIVE', 6.5, 1, 1, 6878),
(1023, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '408880529', 'ACTIVE', 12, 1, 1, 6877),
(1022, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '-1647206092', 'ACTIVE', 12, 1, 1, 6877),
(1021, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '242371540', 'ACTIVE', 9.75, 1, 1, 6876),
(1020, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Algèbre linéaire II', '-1812791560', 'ACTIVE', 9.75, 1, 1, 6876),
(1019, '2019-08-12 14:12:19', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '283402415', 'ACTIVE', 16, 1, 1, 6875),
(1018, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Langage C++ et POO', '-1770837164', 'ACTIVE', 16, 1, 1, 6875),
(1017, '2019-08-12 14:12:19', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '-883604236', 'ACTIVE', 14.75, 1, 1, 6874),
(1016, '2019-08-12 14:12:19', '2019-08-12 14:12:19', NULL, 'Langage C++ et POO', '1358047002', 'ACTIVE', 14.75, 1, 1, 6874),
(1015, '2019-08-12 14:12:18', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '302848933', 'ACTIVE', 14.75, 1, 1, 6873),
(1014, '2019-08-12 14:12:18', '2019-08-12 14:12:18', NULL, 'Langage C++ et POO', '-1749543604', 'ACTIVE', 14.75, 1, 1, 6873),
(1013, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-1815756469', 'ACTIVE', 14, 1, 1, 6344),
(1012, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '915360899', 'ACTIVE', 14, 1, 1, 6344),
(1011, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-65828569', 'ACTIVE', 16, 1, 1, 6343),
(1010, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Éthique et Philosophie', '-1628754976', 'ACTIVE', 16, 1, 1, 6343),
(1009, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Anglais niveau pratique B1/B2', '259938667', 'ACTIVE', 14, 1, 1, 6342),
(1008, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Anglais niveau pratique B1/B2', '-1302064219', 'ACTIVE', 14, 1, 1, 6342),
(1007, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Anglais niveau pratique B1/B2', '1041554974', 'ACTIVE', 14.4, 1, 1, 6341),
(1006, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Anglais niveau pratique B1/B2', '-519524391', 'ACTIVE', 14.4, 1, 1, 6341),
(1005, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '719077946', 'ACTIVE', 17.5, 1, 1, 6340),
(1004, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-841077898', 'ACTIVE', 17.5, 1, 1, 6340),
(1003, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '199580784', 'ACTIVE', 11, 1, 1, 6339),
(1002, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-1359651539', 'ACTIVE', 11, 1, 1, 6339),
(1001, '2019-08-12 14:08:43', '2019-08-12 14:08:42', NULL, 'Systèmes d\'exploitation', '1044553819', 'ACTIVE', 12.5, 1, 1, 6338),
(1000, '2019-08-12 14:08:43', '2019-08-12 14:08:43', NULL, 'Systèmes d\'exploitation', '-513754983', 'ACTIVE', 12.5, 1, 1, 6338),
(999, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '2073438418', 'ACTIVE', 10.75, 1, 1, 6337),
(998, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '516053137', 'ACTIVE', 10.75, 1, 1, 6337),
(997, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '35291796', 'ACTIVE', 9.5, 1, 1, 6336),
(996, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Réseaux informatiques', '-1521169964', 'ACTIVE', 9.5, 1, 1, 6336),
(995, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-1393965043', 'ACTIVE', 16, 1, 1, 6335),
(994, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '1345464014', 'ACTIVE', 16, 1, 1, 6335),
(993, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '812252608', 'ACTIVE', 17.25, 1, 1, 6334),
(992, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-742362110', 'ACTIVE', 17.25, 1, 1, 6334),
(991, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '-1290685593', 'ACTIVE', 12.25, 1, 1, 6333),
(990, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Introduction aux Base de données', '1450590506', 'ACTIVE', 12.25, 1, 1, 6333),
(989, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '-2123751767', 'ACTIVE', 16.5, 1, 1, 6332),
(988, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '618447853', 'ACTIVE', 16.5, 1, 1, 6332),
(987, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Programmation Orientée Objet II', '-949437069', 'ACTIVE', 7, 1, 1, 6331),
(986, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '1793686072', 'ACTIVE', 7, 1, 1, 6331),
(985, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Programmation Orientée Objet II', '302759053', 'ACTIVE', 14.75, 1, 1, 6330),
(984, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Programmation Orientée Objet II', '-1248161581', 'ACTIVE', 14.75, 1, 1, 6330),
(983, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algèbre linaire I', '-1928273845', 'ACTIVE', 19, 1, 1, 6329),
(982, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algèbre linaire I', '816696338', 'ACTIVE', 19, 1, 1, 6329),
(981, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algèbre linaire I', '-607879907', 'ACTIVE', 18.33, 1, 1, 6328),
(980, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algèbre linaire I', '2138013797', 'ACTIVE', 18.33, 1, 1, 6328),
(979, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'modélisation des Systèmes d\'Information(UML)', '-174302555', 'ACTIVE', 12, 1, 1, 6327),
(978, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1722452626', 'ACTIVE', 12, 1, 1, 6327),
(977, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'modélisation des Systèmes d\'Information(UML)', '1545096421', 'ACTIVE', 12.75, 1, 1, 6326),
(976, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2130129', 'ACTIVE', 12.75, 1, 1, 6326),
(975, '2019-08-12 14:08:42', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '658071709', 'ACTIVE', 9, 1, 1, 6325),
(974, '2019-08-12 14:08:42', '2019-08-12 14:08:42', NULL, 'Algorithmique et Complexité', '-888231320', 'ACTIVE', 9, 1, 1, 6325),
(973, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '1957466218', 'ACTIVE', 12, 1, 1, 6324),
(972, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Algorithmique et Complexité', '412086710', 'ACTIVE', 12, 1, 1, 6324),
(971, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '-1598593690', 'ACTIVE', 11.5, 1, 1, 6323),
(970, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '1151917619', 'ACTIVE', 11.5, 1, 1, 6323),
(969, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '1524060824', 'ACTIVE', 12.88, 1, 1, 6322),
(968, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Introduction à la sécurité informatique', '-19471642', 'ACTIVE', 12.88, 1, 1, 6322),
(967, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '-838836507', 'ACTIVE', 12.5, 1, 1, 6321),
(966, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '1913521844', 'ACTIVE', 12.5, 1, 1, 6321),
(965, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '1267356010', 'ACTIVE', 18.17, 1, 1, 6320),
(964, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'économie numérique', '-274329414', 'ACTIVE', 18.17, 1, 1, 6320),
(963, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '150035811', 'ACTIVE', 13, 1, 1, 6319),
(962, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1390726092', 'ACTIVE', 13, 1, 1, 6319),
(961, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-66438835', 'ACTIVE', 14.33, 1, 1, 6318),
(960, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1606277217', 'ACTIVE', 14.33, 1, 1, 6318),
(959, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Ethique et Développement    ', '-533955359', 'ACTIVE', 17.5, 1, 1, 6317),
(958, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Ethique et Développement    ', '-2072870220', 'ACTIVE', 17.5, 1, 1, 6317),
(957, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Ethique et Développement    ', '1563311125', 'ACTIVE', 13.5, 1, 1, 6316),
(956, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Ethique et Développement    ', '25319785', 'ACTIVE', 13.5, 1, 1, 6316),
(955, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Anglais Niveau pratique B2', '1219409211', 'ACTIVE', 15.2, 1, 1, 6315),
(954, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Anglais Niveau pratique B2', '-317658608', 'ACTIVE', 15.2, 1, 1, 6315),
(953, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Anglais Niveau pratique B2', '-1189070860', 'ACTIVE', 12.5, 1, 1, 6314),
(952, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Anglais Niveau pratique B2', '1569752138', 'ACTIVE', 12.5, 1, 1, 6314),
(951, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-75673935', 'ACTIVE', 14.5, 1, 1, 6313),
(950, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Programmation Web II', '-1610894712', 'ACTIVE', 14.5, 1, 1, 6313),
(949, '2019-08-12 14:08:41', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-1768333546', 'ACTIVE', 16.5, 1, 1, 6312),
(948, '2019-08-12 14:08:41', '2019-08-12 14:08:41', NULL, 'Programmation Web II', '992336494', 'ACTIVE', 16.5, 1, 1, 6312),
(947, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '543091321', 'ACTIVE', 14, 1, 1, 6311),
(946, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Programmation Web II', '-990282414', 'ACTIVE', 14, 1, 1, 6311),
(945, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '-1123926235', 'ACTIVE', 14, 1, 1, 6310),
(944, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '1638590847', 'ACTIVE', 14, 1, 1, 6310),
(943, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '-2060646130', 'ACTIVE', 16.25, 1, 1, 6309),
(942, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Algèbre linéaire II', '702794473', 'ACTIVE', 16.25, 1, 1, 6309),
(941, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-507750569', 'ACTIVE', 16, 1, 1, 6308),
(940, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-2038353741', 'ACTIVE', 16, 1, 1, 6308),
(939, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-1686279336', 'ACTIVE', 16, 1, 1, 6307),
(938, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '1079008309', 'ACTIVE', 16, 1, 1, 6307),
(937, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '-1235560697', 'ACTIVE', 15.33, 1, 1, 6306),
(936, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Langage C++ et POO', '1530650469', 'ACTIVE', 15.33, 1, 1, 6306),
(935, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Éthique et Philosophie', '-1801275440', 'ACTIVE', 17.75, 1, 1, 6305),
(934, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Éthique et Philosophie', '965859247', 'ACTIVE', 17.75, 1, 1, 6305),
(933, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Éthique et Philosophie', '520869925', 'ACTIVE', 15.75, 1, 1, 6304),
(932, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Éthique et Philosophie', '-1006039163', 'ACTIVE', 15.75, 1, 1, 6304),
(931, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Anglais niveau pratique B1/B2', '-776790397', 'ACTIVE', 13.4, 1, 1, 6303),
(930, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Anglais niveau pratique B1/B2', '1992191332', 'ACTIVE', 13.4, 1, 1, 6303),
(929, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Anglais niveau pratique B1/B2', '440265259', 'ACTIVE', 16, 1, 1, 6302),
(928, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Anglais niveau pratique B1/B2', '-1084796787', 'ACTIVE', 16, 1, 1, 6302),
(927, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '-154571336', 'ACTIVE', 18.25, 1, 1, 6301),
(926, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-1678709861', 'ACTIVE', 18.25, 1, 1, 6301),
(925, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '-53429104', 'ACTIVE', 15, 1, 1, 6300),
(924, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-1576644108', 'ACTIVE', 15, 1, 1, 6300),
(923, '2019-08-12 14:08:40', '2019-08-12 14:08:39', NULL, 'Systèmes d\'exploitation', '1312912979', 'ACTIVE', 13.5, 1, 1, 6299),
(922, '2019-08-12 14:08:40', '2019-08-12 14:08:40', NULL, 'Systèmes d\'exploitation', '-209378504', 'ACTIVE', 13.5, 1, 1, 6299),
(921, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '520262141', 'ACTIVE', 10.5, 1, 1, 6298),
(920, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '-1001105821', 'ACTIVE', 10.5, 1, 1, 6298),
(919, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '1027037223', 'ACTIVE', 10, 1, 1, 6297),
(918, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Réseaux informatiques', '-493407218', 'ACTIVE', 10, 1, 1, 6297),
(917, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '278675971', 'ACTIVE', 12, 1, 1, 6296),
(916, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-1240844949', 'ACTIVE', 12, 1, 1, 6296),
(915, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-1010307576', 'ACTIVE', 9.25, 1, 1, 6295),
(914, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '1766062321', 'ACTIVE', 9.25, 1, 1, 6295),
(913, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-597954626', 'ACTIVE', 12.25, 1, 1, 6294),
(912, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Introduction aux Base de données', '-2115628504', 'ACTIVE', 12.25, 1, 1, 6294),
(911, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '1932055058', 'ACTIVE', 17.75, 1, 1, 6293),
(910, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '415304701', 'ACTIVE', 17.75, 1, 1, 6293),
(909, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '1580951547', 'ACTIVE', 12.5, 1, 1, 6292),
(908, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '65124711', 'ACTIVE', 12.5, 1, 1, 6292),
(907, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Programmation Orientée Objet II', '-1991356477', 'ACTIVE', 13.25, 1, 1, 6291),
(906, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Programmation Orientée Objet II', '788707504', 'ACTIVE', 13.25, 1, 1, 6291),
(905, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Algèbre linaire I', '1252833063', 'ACTIVE', 11.5, 1, 1, 6290),
(904, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Algèbre linaire I', '-261146731', 'ACTIVE', 11.5, 1, 1, 6290),
(902, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'Algèbre linaire I', '146723546', 'ACTIVE', 14, 1, 1, 6289),
(903, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'Algèbre linaire I', '1659779819', 'ACTIVE', 14, 1, 1, 6289),
(901, '2019-08-12 14:08:39', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '255553213', 'ACTIVE', 12, 1, 1, 6288),
(900, '2019-08-12 14:08:39', '2019-08-12 14:08:39', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1256579539', 'ACTIVE', 12, 1, 1, 6288),
(899, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '1428227788', 'ACTIVE', 12.75, 1, 1, 6287),
(898, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '-82981443', 'ACTIVE', 12.75, 1, 1, 6287),
(897, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '-906162465', 'ACTIVE', 15, 1, 1, 6286),
(896, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '1878519121', 'ACTIVE', 15, 1, 1, 6286),
(895, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '126511006', 'ACTIVE', 11.83, 1, 1, 6285),
(894, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Algorithmique et Complexité', '-1382851183', 'ACTIVE', 11.83, 1, 1, 6285),
(893, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '-602292774', 'ACTIVE', 9.25, 1, 1, 6284),
(892, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '-2110731442', 'ACTIVE', 9.25, 1, 1, 6284),
(891, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'Introduction à la sécurité informatique', '-1118480354', 'ACTIVE', 9.63, 1, 1, 6283),
(890, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'Introduction à la sécurité informatique', '1668971795', 'ACTIVE', 9.63, 1, 1, 6283),
(889, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'économie numérique', '665903202', 'ACTIVE', 15, 1, 1, 6282),
(888, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'économie numérique', '-840688424', 'ACTIVE', 15, 1, 1, 6282),
(887, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'économie numérique', '1411113825', 'ACTIVE', 16, 1, 1, 6281),
(886, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'économie numérique', '-94554280', 'ACTIVE', 16, 1, 1, 6281),
(885, '2019-08-12 14:08:38', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-85938631', 'ACTIVE', 16, 1, 1, 6280),
(884, '2019-08-12 14:08:38', '2019-08-12 14:08:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1590683215', 'ACTIVE', 16, 1, 1, 6280),
(883, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '2039636772', 'ACTIVE', 15, 1, 1, 6279),
(882, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '535815709', 'ACTIVE', 15, 1, 1, 6279),
(881, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '1082825678', 'ACTIVE', 14.5, 1, 1, 6278),
(880, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '-420071864', 'ACTIVE', 14.5, 1, 1, 6278),
(879, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '-1864112453', 'ACTIVE', 15.75, 1, 1, 6277),
(878, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Ethique et Développement    ', '928880822', 'ACTIVE', 15.75, 1, 1, 6277),
(877, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '-520057078', 'ACTIVE', 12.2, 1, 1, 6276),
(876, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '-2021107578', 'ACTIVE', 12.2, 1, 1, 6276),
(875, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '2132845247', 'ACTIVE', 11.1, 1, 1, 6275),
(874, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Anglais Niveau pratique B2', '632718268', 'ACTIVE', 11.1, 1, 1, 6275),
(873, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '1726407862', 'ACTIVE', 14.5, 1, 1, 6274),
(872, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '227204404', 'ACTIVE', 14.5, 1, 1, 6274),
(871, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '1532046053', 'ACTIVE', 13, 1, 1, 6273),
(870, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '33766116', 'ACTIVE', 13, 1, 1, 6273),
(869, '2019-08-12 14:08:37', '2019-08-12 14:08:36', NULL, 'Programmation Web II', '-719610928', 'ACTIVE', 6.5, 1, 1, 6272),
(868, '2019-08-12 14:08:37', '2019-08-12 14:08:37', NULL, 'Programmation Web II', '2077999952', 'ACTIVE', 6.5, 1, 1, 6272),
(867, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '522766419', 'ACTIVE', 12, 1, 1, 6271),
(866, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '-973666476', 'ACTIVE', 12, 1, 1, 6271),
(865, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '1827511197', 'ACTIVE', 9.75, 1, 1, 6270),
(864, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Algèbre linéaire II', '332001823', 'ACTIVE', 9.75, 1, 1, 6270),
(863, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '-2075330882', 'ACTIVE', 16, 1, 1, 6269),
(862, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '725050561', 'ACTIVE', 16, 1, 1, 6269),
(861, '2019-08-12 14:08:36', '2019-08-12 14:08:35', NULL, 'Langage C++ et POO', '-1571416260', 'ACTIVE', 14.75, 1, 1, 6268),
(860, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '1229888704', 'ACTIVE', 14.75, 1, 1, 6268),
(859, '2019-08-12 14:08:36', '2019-08-12 14:08:35', NULL, 'Langage C++ et POO', '1141930300', 'ACTIVE', 14.75, 1, 1, 6267),
(858, '2019-08-12 14:08:36', '2019-08-12 14:08:36', NULL, 'Langage C++ et POO', '-350808511', 'ACTIVE', 14.75, 1, 1, 6267);

-- --------------------------------------------------------

--
-- Structure de la table `message`
--

CREATE TABLE `message` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

CREATE TABLE `module` (
  `code` bigint(20) NOT NULL,
  `code_module` varchar(255) DEFAULT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `module`
--

INSERT INTO `module` (`code`, `code_module`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(1801, 'LP001', '2019-08-05 17:55:23', '2019-08-05 17:55:23', '', 'Stage', '1519622815', 'ACTIVE', 1, 1),
(1126, 'LP324', '2019-08-02 16:05:36', '2019-08-02 16:05:36', 'L3 Semestre 6', 'Stage et Ethique', '41851139', 'ACTIVE', 1, 1),
(1125, 'LP323', '2019-08-02 16:05:35', '2019-08-02 16:05:36', 'L3 Semestre 6', 'Applications pour mobiles', '41850516', 'ACTIVE', 1, 1),
(1124, 'LP322', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 6', 'ERP et Projet', '41848743', 'ACTIVE', 1, 1),
(1123, 'LP321', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 6', 'Java EE et Technologie.NET', '41848028', 'ACTIVE', 1, 1),
(1122, 'LP000', '2019-08-02 16:05:35', '2019-08-05 17:53:39', 'L3 Semestre 5', 'Expression Anglaise, Sagesse et Science', '1253183312', 'ACTIVE', 1, 1),
(1121, 'LP314', '2019-08-02 16:05:35', '2019-08-02 16:05:35', 'L3 Semestre 5', 'Outils de management', '41845369', 'ACTIVE', 1, 1),
(1120, 'LP313', '2019-08-02 16:05:34', '2019-08-02 16:05:35', 'L3 Semestre 5', 'Administration système et Gestion des projets', '41844614', 'ACTIVE', 1, 1),
(1119, 'LP312', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L3 Semestre 5', 'Ingénierie du Logiciel et Big Data', '41843003', 'ACTIVE', 1, 1),
(1118, 'LP311', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L3 Semestre 5', 'Administration de Base de données et R.O.', '41841963', 'ACTIVE', 1, 1),
(1117, 'LP224', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Communication et Stage', '41841355', 'ACTIVE', 1, 1),
(1116, 'LP223', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'sécurité informatique et Projet d\'équipe', '41840233', 'ACTIVE', 1, 1),
(1115, 'LP222', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Culture de l’entreprise', '41839357', 'ACTIVE', 1, 1),
(1114, 'LP221', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 4', 'Langage C++ et Programmation Web2', '41837746', 'ACTIVE', 1, 1),
(1113, 'LP214', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Communication et Ethique', '41836652', 'ACTIVE', 1, 1),
(1112, 'LP213', '2019-08-02 16:05:34', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Réseaux et Système d’exploitation', '41836040', 'ACTIVE', 1, 1),
(1111, 'LP212', '2019-08-02 16:05:33', '2019-08-02 16:05:34', 'L2 Semestre 3', 'Algèbre, POO et Base de données', '41834922', 'ACTIVE', 1, 1),
(1110, 'LP211', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L2 Semestre 3', 'Complexité et modélisation UML', '41834043', 'ACTIVE', 1, 1),
(1109, 'LP124', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Communication et Réflexion Humaine2', '41832450', 'ACTIVE', 1, 1),
(1108, 'LP123', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Mathématiques et Logique', '41831321', 'ACTIVE', 1, 1),
(1107, 'LP122', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Analyse et Algorithmique Structuré', '41830783', 'ACTIVE', 1, 1),
(1106, 'LP121', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 2', 'Java1 et Programmation en C', '41829673', 'ACTIVE', 1, 1),
(1105, 'LP114', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Communication Bilingue et Réflexion Humaine', '41827866', 'ACTIVE', 1, 1),
(1104, 'LP113', '2019-08-02 16:05:33', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Mathématiques appliquées pour l’informatique', '41827300', 'ACTIVE', 1, 1),
(1103, 'LP112', '2019-08-02 16:05:32', '2019-08-02 16:05:33', 'L1 Semestre 1', 'Economie Numérique, Algorithmique et Programmation Web1', '41826263', 'ACTIVE', 1, 1),
(1102, 'LP111', '2019-08-02 16:05:32', '2019-08-02 16:05:32', 'L1 Semestre 1', 'systèmes d\'information et Architecture', '41825336', 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `niveau`
--

CREATE TABLE `niveau` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `numero` int(11) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `niveau`
--

INSERT INTO `niveau` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero`, `signature`, `statut_vie`, `createur`, `modificateur`) VALUES
(7, '2019-08-02 10:37:15', '2019-08-05 09:19:56', 'Premiere Année', 'Niveau 1', 1, '-124548899', 'ACTIVE', 1, 1),
(8, '2019-08-02 10:37:26', '2019-08-05 09:21:20', 'Deuxieme Année', 'Niveau 2', 2, '-112546938', 'ACTIVE', 1, 1),
(9, '2019-08-02 10:37:31', '2019-08-05 09:21:53', 'Troisième Année', 'Niveau 3', 3, '-107325793', 'ACTIVE', 1, 1),
(10, '2019-08-02 10:38:04', '2019-08-05 09:22:56', 'Quatrième Année', 'Niveau 4', 4, '-74181832', 'ACTIVE', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `note`
--

CREATE TABLE `note` (
  `code` bigint(20) NOT NULL,
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
  `est_inscrit` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `note`
--

INSERT INTO `note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero_table`, `signature`, `statut_vie`, `valeur_note`, `createur`, `evaluation`, `modificateur`, `est_inscrit`) VALUES
(6967, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'EXA', 'Éthique et Philosophie', 24, '2098908625', 'ACTIVE', 14, 1, 6249, 1, 6420),
(6966, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'CC', 'Éthique et Philosophie', 4, '-1516611805', 'ACTIVE', 16, 1, 6231, 1, 6420),
(6965, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'EXA', 'Anglais niveau pratique B1/B2', 18, '-1449729135', 'ACTIVE', 14, 1, 6245, 1, 6419),
(6964, '2019-08-12 14:12:30', '2019-08-12 14:12:30', 'CC', 'Anglais niveau pratique B1/B2', 3, '1262754890', 'ACTIVE', 14.4, 1, 6227, 1, 6419),
(6963, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Systèmes d\'exploitation', 21, '1739262478', 'ACTIVE', 17.5, 1, 6263, 1, 6418),
(6962, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Systèmes d\'exploitation', 22, '1427585580', 'ACTIVE', 11, 1, 6253, 1, 6418),
(6961, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Systèmes d\'exploitation', 7, '-1260486830', 'ACTIVE', 12.5, 1, 6235, 1, 6418),
(6960, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Introduction aux Réseaux informatiques', 18, '63556781', 'ACTIVE', 10.75, 1, 6255, 1, 6417),
(6959, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Introduction aux Réseaux informatiques', 14, '878533126', 'ACTIVE', 9.5, 1, 6237, 1, 6417),
(6951, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Algèbre linaire I', 24, '-968714662', 'ACTIVE', 18.33, 1, 6243, 1, 6414),
(6952, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Algèbre linaire I', 25, '-360355024', 'ACTIVE', 19, 1, 6260, 1, 6414),
(6953, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Programmation Orientée Objet II', 25, '209491517', 'ACTIVE', 14.75, 1, 6234, 1, 6415),
(6954, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Programmation Orientée Objet II', 2, '1403736576', 'ACTIVE', 7, 1, 6252, 1, 6415),
(6955, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Programmation Orientée Objet II', 11, '1168142587', 'ACTIVE', 16.5, 1, 6262, 1, 6415),
(6956, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'CC', 'Introduction aux Base de données', 5, '-1896186393', 'ACTIVE', 12.25, 1, 6236, 1, 6416),
(6957, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'EXA', 'Introduction aux Base de données', 8, '-1250150641', 'ACTIVE', 17.25, 1, 6254, 1, 6416),
(6958, '2019-08-12 14:12:29', '2019-08-12 14:12:29', 'TP', 'Introduction aux Base de données', 14, '-368844606', 'ACTIVE', 16, 1, 6264, 1, 6416),
(6950, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 16, '-506194770', 'ACTIVE', 12, 1, 6251, 1, 6412),
(6946, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Introduction à la sécurité informatique', 9, '1281425521', 'ACTIVE', 11.5, 1, 6258, 1, 6409),
(6947, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Algorithmique et Complexité', 18, '-788473868', 'ACTIVE', 12, 1, 6232, 1, 6411),
(6948, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'EXA', 'Algorithmique et Complexité', 5, '-1810460163', 'ACTIVE', 9, 1, 6250, 1, 6411),
(6949, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'modélisation des Systèmes d\'Information(UML)', 13, '27078038', 'ACTIVE', 12.75, 1, 6233, 1, 6412),
(6943, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'économie numérique', 10, '1016103447', 'ACTIVE', 18.17, 1, 6241, 1, 6408),
(6944, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'économie numérique', 25, '1312660156', 'ACTIVE', 12.5, 1, 6259, 1, 6408),
(6945, '2019-08-12 14:12:28', '2019-08-12 14:12:28', 'CC', 'Introduction à la sécurité informatique', 14, '-976183367', 'ACTIVE', 12.88, 1, 6240, 1, 6409),
(6937, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'Anglais Niveau pratique B2', 19, '-1181068069', 'ACTIVE', 12.5, 1, 6228, 1, 6404),
(6938, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'Anglais Niveau pratique B2', 9, '2025778216', 'ACTIVE', 15.2, 1, 6246, 1, 6404),
(6939, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'Ethique et Développement    ', 18, '-468081918', 'ACTIVE', 13.5, 1, 6230, 1, 6405),
(6940, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'Ethique et Développement    ', 7, '-334849862', 'ACTIVE', 17.5, 1, 6248, 1, 6405),
(6941, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 24, '-1582024002', 'ACTIVE', 14.33, 1, 6229, 1, 6407),
(6942, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 21, '-38323471', 'ACTIVE', 13, 1, 6247, 1, 6407),
(6936, '2019-08-12 14:12:27', '2019-08-12 14:12:27', 'TP', 'Programmation Web II', 10, '1659968000', 'ACTIVE', 14.5, 1, 6266, 1, 6403),
(6934, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Programmation Web II', 20, '1976585300', 'ACTIVE', 14, 1, 6239, 1, 6403),
(6935, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Programmation Web II', 25, '1976228664', 'ACTIVE', 16.5, 1, 6257, 1, 6403),
(6932, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Algèbre linéaire II', 21, '-957147805', 'ACTIVE', 16.25, 1, 6244, 1, 6413),
(6933, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Algèbre linéaire II', 3, '1534726705', 'ACTIVE', 14, 1, 6261, 1, 6413),
(6931, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'TP', 'Langage C++ et POO', 20, '-360426891', 'ACTIVE', 16, 1, 6265, 1, 6402),
(6926, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Anglais niveau pratique B1/B2', 15, '1055377856', 'ACTIVE', 13.4, 1, 6245, 1, 6833),
(6927, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Éthique et Philosophie', 3, '609071466', 'ACTIVE', 15.75, 1, 6231, 1, 6834),
(6928, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Éthique et Philosophie', 18, '1478671768', 'ACTIVE', 17.75, 1, 6249, 1, 6834),
(6930, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'EXA', 'Langage C++ et POO', 1, '1679180139', 'ACTIVE', 16, 1, 6256, 1, 6402),
(6929, '2019-08-12 14:12:26', '2019-08-12 14:12:26', 'CC', 'Langage C++ et POO', 7, '-1720573449', 'ACTIVE', 15.33, 1, 6238, 1, 6402),
(6925, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Anglais niveau pratique B1/B2', 21, '-1642523596', 'ACTIVE', 16, 1, 6227, 1, 6833),
(6923, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Systèmes d\'exploitation', 20, '-150161336', 'ACTIVE', 15, 1, 6253, 1, 6832),
(6924, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'TP', 'Systèmes d\'exploitation', 20, '-1231845138', 'ACTIVE', 18.25, 1, 6263, 1, 6832),
(6922, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Systèmes d\'exploitation', 14, '1610009698', 'ACTIVE', 13.5, 1, 6235, 1, 6832),
(6921, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'EXA', 'Introduction aux Réseaux informatiques', 12, '90117021', 'ACTIVE', 10.5, 1, 6255, 1, 6831),
(6920, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'CC', 'Introduction aux Réseaux informatiques', 22, '-1741159575', 'ACTIVE', 10, 1, 6237, 1, 6831),
(6919, '2019-08-12 14:12:25', '2019-08-12 14:12:25', 'TP', 'Introduction aux Base de données', 7, '1866204762', 'ACTIVE', 12, 1, 6264, 1, 6830),
(6918, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Introduction aux Base de données', 15, '951383112', 'ACTIVE', 9.25, 1, 6254, 1, 6830),
(6917, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'CC', 'Introduction aux Base de données', 18, '302525619', 'ACTIVE', 12.25, 1, 6236, 1, 6830),
(6916, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'TP', 'Programmation Orientée Objet II', 13, '-1704713044', 'ACTIVE', 17.75, 1, 6262, 1, 6829),
(6915, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Programmation Orientée Objet II', 9, '-253134957', 'ACTIVE', 12.5, 1, 6252, 1, 6829),
(6913, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'EXA', 'Algèbre linaire I', 11, '50375616', 'ACTIVE', 11.5, 1, 6260, 1, 6828),
(6914, '2019-08-12 14:12:24', '2019-08-12 14:12:24', 'CC', 'Programmation Orientée Objet II', 11, '680584593', 'ACTIVE', 13.25, 1, 6234, 1, 6829),
(6912, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'CC', 'Algèbre linaire I', 20, '1761550046', 'ACTIVE', 14, 1, 6243, 1, 6828),
(6910, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'CC', 'modélisation des Systèmes d\'Information(UML)', 8, '-2103005851', 'ACTIVE', 12.75, 1, 6233, 1, 6826),
(6911, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 10, '-1238004792', 'ACTIVE', 12, 1, 6251, 1, 6826),
(6909, '2019-08-12 14:12:23', '2019-08-12 14:12:23', 'EXA', 'Algorithmique et Complexité', 13, '-417659134', 'ACTIVE', 15, 1, 6250, 1, 6825),
(6907, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'EXA', 'Introduction à la sécurité informatique', 11, '-1806584234', 'ACTIVE', 9.25, 1, 6258, 1, 6823),
(6908, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'CC', 'Algorithmique et Complexité', 14, '-1935899912', 'ACTIVE', 11.83, 1, 6232, 1, 6825),
(6904, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'CC', 'économie numérique', 5, '1667562774', 'ACTIVE', 16, 1, 6241, 1, 6822),
(6905, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'EXA', 'économie numérique', 5, '-1797732714', 'ACTIVE', 15, 1, 6259, 1, 6822),
(6906, '2019-08-12 14:12:22', '2019-08-12 14:12:22', 'CC', 'Introduction à la sécurité informatique', 16, '-1704626758', 'ACTIVE', 9.63, 1, 6240, 1, 6823),
(6903, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 9, '1421583147', 'ACTIVE', 16, 1, 6247, 1, 6821),
(6902, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 16, '-800246776', 'ACTIVE', 15, 1, 6229, 1, 6821),
(6883, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'CC', 'Ethique et Développement    ', 4, '1564787897', 'ACTIVE', 15.75, 1, 6230, 1, 6819),
(6901, '2019-08-12 14:12:21', '2019-08-12 14:12:21', 'EXA', 'Ethique et Développement    ', 16, '688467954', 'ACTIVE', 14.5, 1, 6248, 1, 6819),
(6882, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'EXA', 'Anglais Niveau pratique B2', 8, '-927086301', 'ACTIVE', 12.2, 1, 6246, 1, 6818),
(6881, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'CC', 'Anglais Niveau pratique B2', 3, '-1685393766', 'ACTIVE', 11.1, 1, 6228, 1, 6818),
(6878, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'CC', 'Programmation Web II', 1, '-1303699301', 'ACTIVE', 6.5, 1, 6239, 1, 6817),
(6879, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'EXA', 'Programmation Web II', 14, '-134661348', 'ACTIVE', 13, 1, 6257, 1, 6817),
(6880, '2019-08-12 14:12:20', '2019-08-12 14:12:20', 'TP', 'Programmation Web II', 5, '-424752414', 'ACTIVE', 14.5, 1, 6266, 1, 6817),
(6877, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'EXA', 'Algèbre linéaire II', 21, '408880529', 'ACTIVE', 12, 1, 6261, 1, 6827),
(6876, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'CC', 'Algèbre linéaire II', 14, '242371540', 'ACTIVE', 9.75, 1, 6244, 1, 6827),
(6875, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'TP', 'Langage C++ et POO', 23, '283402415', 'ACTIVE', 16, 1, 6265, 1, 6816),
(6874, '2019-08-12 14:12:19', '2019-08-12 14:12:19', 'EXA', 'Langage C++ et POO', 10, '-883604236', 'ACTIVE', 14.75, 1, 6256, 1, 6816),
(6873, '2019-08-12 14:12:18', '2019-08-12 14:12:18', 'CC', 'Langage C++ et POO', 4, '302848933', 'ACTIVE', 14.75, 1, 6238, 1, 6816);

--
-- Déclencheurs `note`
--
DELIMITER $$
CREATE TRIGGER `After_InsertNote` AFTER INSERT ON `note` FOR EACH ROW INSERT INTO historique_note(date_creation,date_modification,libelle,signature,statut_vie,valeur_note,createur,modificateur,note)
VALUES (NEW.date_creation,NEW.date_modification,NEW.libelle,NEW.signature,NEW.statut_vie,NEW.valeur_note,NEW.createur,NEW.modificateur,NEW.code)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `After_UpdateNote` AFTER UPDATE ON `note` FOR EACH ROW INSERT INTO historique_note(date_creation,date_modification,libelle,signature,statut_vie,valeur_note,createur,modificateur,note)
VALUES (NEW.date_creation,CURRENT_TIMESTAMP,NEW.libelle,NEW.signature,NEW.statut_vie,NEW.valeur_note,NEW.createur,NEW.modificateur,NEW.code)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `role`
--

CREATE TABLE `role` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `semestre`
--

CREATE TABLE `semestre` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `semestre`
--

INSERT INTO `semestre` (`code`, `date_cloture`, `date_creation`, `date_debut`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `annee_academique`, `createur`, `modificateur`) VALUES
(552, '2017-01-30 23:00:00', '2019-08-02 11:49:24', '2016-08-31 22:00:00', '2019-08-02 11:49:24', 'Semestre 1 Année Académique 2016/2017', 'Semestre 1', '1700279277', 'ACTIVE', 206, 1, 1),
(702, '2017-08-30 22:00:00', '2019-08-02 12:00:08', '2017-01-31 23:00:00', '2019-08-02 12:00:08', 'Semestre 2 Année Académique 2016/2017', 'Semestre 2', '-1208243154', 'ACTIVE', 206, 1, 1),
(703, '2018-01-30 23:00:00', '2019-08-02 12:01:43', '2017-08-31 22:00:00', '2019-08-02 12:01:43', 'Semestre 1 Année Académique 2017/2018', 'Semestre 1', '-4118364', 'ACTIVE', 352, 1, 1),
(704, '2018-08-30 22:00:00', '2019-08-02 12:02:19', '2018-01-31 23:00:00', '2019-08-02 12:02:19', 'Semestre 2 Année Académique 2017/2018', 'Semestre 2', '-1246274931', 'ACTIVE', 352, 1, 1),
(705, '2019-01-30 23:00:00', '2019-08-02 12:03:11', '2018-08-31 22:00:00', '2019-08-02 12:03:11', 'Semestre 1 Année Académique 2018/2019', 'Semestre 1', '-83778770', 'ACTIVE', 353, 1, 1),
(706, '2019-08-30 22:00:00', '2019-08-02 12:03:35', '2019-01-31 23:00:00', '2019-08-02 12:03:35', 'Semestre 2 Année Académique 2018/2019', 'Semestre 2', '-1336497688', 'ACTIVE', 353, 1, 1),
(707, '2020-01-30 23:00:00', '2019-08-02 12:04:13', '2019-08-31 22:00:00', '2019-08-02 12:04:13', 'Semestre 1 Année Académique 2019/2020', 'Semestre 1', '-187611209', 'ACTIVE', 354, 1, 1),
(708, '2020-08-30 22:00:00', '2019-08-02 12:04:40', '2020-01-31 23:00:00', '2019-08-02 12:04:40', 'Semestre 2 Année Académique 2019/2020', 'Semestre 2', '-1350855887', 'ACTIVE', 354, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `sequence`
--

CREATE TABLE `sequence` (
  `SEQ_NAME` varchar(50) NOT NULL,
  `SEQ_COUNT` decimal(38,0) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `sequence`
--

INSERT INTO `sequence` (`SEQ_NAME`, `SEQ_COUNT`) VALUES
('SEQ_GEN', '7450');

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

CREATE TABLE `session` (
  `code` bigint(20) NOT NULL,
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
  `utilisateur` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `session`
--

INSERT INTO `session` (`code`, `date_connection`, `date_creation`, `date_deconnection`, `date_modification`, `description`, `libelle`, `machine_cliente`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `utilisateur`) VALUES
(1, '2019-08-09 11:29:00', '2019-08-09 11:29:00', NULL, '2019-08-09 11:29:00', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1725601648', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(651, '2019-08-10 12:32:35', '2019-08-10 12:32:35', NULL, '2019-08-10 12:32:36', NULL, NULL, 'DESKTOP-7OQ9KG8', '2059049372', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(701, '2019-08-10 12:41:33', '2019-08-10 12:41:33', NULL, '2019-08-10 12:41:33', NULL, NULL, 'DESKTOP-7OQ9KG8', '1610255594', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(751, '2019-08-10 12:47:13', '2019-08-10 12:47:13', NULL, '2019-08-10 12:47:13', NULL, NULL, 'DESKTOP-7OQ9KG8', '-364273419', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(851, '2019-08-10 12:50:27', '2019-08-10 12:50:27', NULL, '2019-08-10 12:50:27', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1799416018', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(951, '2019-08-10 12:57:19', '2019-08-10 12:57:19', NULL, '2019-08-10 12:57:20', NULL, NULL, 'DESKTOP-7OQ9KG8', '-2084913704', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1051, '2019-08-10 13:33:45', '2019-08-10 13:33:45', NULL, '2019-08-10 13:33:45', NULL, NULL, 'DESKTOP-7OQ9KG8', '-487388409', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1501, '2019-08-10 13:56:17', '2019-08-10 13:56:17', NULL, '2019-08-10 13:56:18', NULL, NULL, 'DESKTOP-7OQ9KG8', '110638933', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(1551, '2019-08-10 13:57:34', '2019-08-10 13:57:34', NULL, '2019-08-10 13:57:34', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1016877597', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2051, '2019-08-10 15:42:47', '2019-08-10 15:42:47', NULL, '2019-08-10 15:42:47', NULL, NULL, 'DESKTOP-7OQ9KG8', '-104066253', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2351, '2019-08-10 16:01:38', '2019-08-10 16:01:38', NULL, '2019-08-10 16:01:38', NULL, NULL, 'DESKTOP-7OQ9KG8', '1425931701', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2551, '2019-08-10 16:06:52', '2019-08-10 16:06:52', NULL, '2019-08-10 16:06:52', NULL, NULL, 'DESKTOP-7OQ9KG8', '847038573', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2751, '2019-08-10 16:13:04', '2019-08-10 16:13:04', NULL, '2019-08-10 16:13:04', NULL, NULL, 'DESKTOP-7OQ9KG8', '2042757575', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2801, '2019-08-10 16:27:41', '2019-08-10 16:27:41', NULL, '2019-08-10 16:27:41', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1104375566', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2851, '2019-08-10 17:10:37', '2019-08-10 17:10:37', NULL, '2019-08-10 17:10:37', NULL, NULL, 'DESKTOP-7OQ9KG8', '1382571134', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2901, '2019-08-10 17:21:49', '2019-08-10 17:21:49', NULL, '2019-08-10 17:21:49', NULL, NULL, 'DESKTOP-7OQ9KG8', '-480590968', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(2951, '2019-08-10 17:29:25', '2019-08-10 17:29:25', NULL, '2019-08-10 17:29:25', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1739895765', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3051, '2019-08-10 17:34:25', '2019-08-10 17:34:25', NULL, '2019-08-10 17:34:25', NULL, NULL, 'DESKTOP-7OQ9KG8', '1345567361', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3701, '2019-08-10 17:43:42', '2019-08-10 17:43:42', NULL, '2019-08-10 17:43:42', NULL, NULL, 'DESKTOP-7OQ9KG8', '497754422', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3901, '2019-08-10 17:56:17', '2019-08-10 17:56:17', NULL, '2019-08-10 17:56:17', NULL, NULL, 'DESKTOP-7OQ9KG8', '-555093202', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(3951, '2019-08-10 17:58:43', '2019-08-10 17:58:43', NULL, '2019-08-10 17:58:43', NULL, NULL, 'DESKTOP-7OQ9KG8', '1912942846', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4001, '2019-08-10 18:01:21', '2019-08-10 18:01:21', NULL, '2019-08-10 18:01:21', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1995219410', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4051, '2019-08-12 10:33:46', '2019-08-12 10:33:46', NULL, '2019-08-12 10:33:46', NULL, NULL, 'DESKTOP-7OQ9KG8', '1800415695', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4101, '2019-08-12 12:23:42', '2019-08-12 12:23:42', NULL, '2019-08-12 12:23:43', NULL, NULL, 'DESKTOP-7OQ9KG8', '-632048294', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4151, '2019-08-12 12:36:00', '2019-08-12 12:36:00', NULL, '2019-08-12 12:36:00', NULL, NULL, 'DESKTOP-7OQ9KG8', '633683585', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4201, '2019-08-12 12:53:01', '2019-08-12 12:53:01', NULL, '2019-08-12 12:53:01', NULL, NULL, 'DESKTOP-7OQ9KG8', '-752046661', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4351, '2019-08-12 13:04:26', '2019-08-12 13:04:26', NULL, '2019-08-12 13:04:26', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1394423371', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4401, '2019-08-12 13:08:01', '2019-08-12 13:08:01', NULL, '2019-08-12 13:08:01', NULL, NULL, 'DESKTOP-7OQ9KG8', '1015840962', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4451, '2019-08-12 13:31:54', '2019-08-12 13:31:54', NULL, '2019-08-12 13:31:54', NULL, NULL, 'DESKTOP-7OQ9KG8', '1814434432', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(4801, '2019-08-12 13:35:59', '2019-08-12 13:35:59', NULL, '2019-08-12 13:35:59', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1073109206', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(5901, '2019-08-12 13:59:24', '2019-08-12 13:59:24', NULL, '2019-08-12 13:59:24', NULL, NULL, 'DESKTOP-7OQ9KG8', '-2036671878', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7001, '2019-08-13 16:48:21', '2019-08-13 16:48:21', NULL, '2019-08-13 16:48:22', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1138754520', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7051, '2019-08-13 16:53:26', '2019-08-13 16:53:26', NULL, '2019-08-13 16:53:26', NULL, NULL, 'DESKTOP-7OQ9KG8', '1268261459', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7101, '2019-08-13 17:35:10', '2019-08-13 17:35:10', NULL, '2019-08-13 17:35:10', NULL, NULL, 'DESKTOP-7OQ9KG8', '1625260589', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7151, '2019-08-14 12:46:58', '2019-08-14 12:46:58', NULL, '2019-08-14 12:46:58', NULL, NULL, 'DESKTOP-7OQ9KG8', '1384381757', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7201, '2019-08-14 12:54:21', '2019-08-14 12:54:21', NULL, '2019-08-14 12:54:21', NULL, NULL, 'DESKTOP-7OQ9KG8', '191068842', 'ACTIF', 'ACTIVE', 1, 1, NULL),
(7251, '2019-08-14 12:58:11', '2019-08-14 12:58:11', NULL, '2019-08-14 12:58:11', NULL, NULL, 'DESKTOP-7OQ9KG8', '-1281598149', 'ACTIF', 'ACTIVE', 1, 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sms`
--

CREATE TABLE `sms` (
  `code` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Structure de la table `specialite`
--

CREATE TABLE `specialite` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `filiere` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `specialite`
--

INSERT INTO `specialite` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `createur`, `filiere`, `modificateur`) VALUES
(4, '2019-08-02 10:33:08', '2019-08-02 10:33:08', '', 'Génie logiciel', '-1352277424', 'ACTIVE', 1, 2, 1),
(5, '2019-08-02 10:33:48', '2019-08-02 10:33:48', '', 'Informatique et système d\'information', '-1350793609', 'ACTIVE', 1, 3, 1),
(6, '2019-08-02 10:34:32', '2019-08-02 10:34:32', '', 'Système réseau et télécommunication', '-1349389185', 'ACTIVE', 1, 3, 1),
(57, '2019-08-02 10:59:00', '2019-08-02 10:59:00', '', 'Tronc commun', '657213468', 'ACTIVE', 1, 3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `tmp_ue`
--

CREATE TABLE `tmp_ue` (
  `id` int(11) NOT NULL,
  `codeue` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Structure de la table `type_evaluation`
--

CREATE TABLE `type_evaluation` (
  `code` bigint(20) NOT NULL,
  `date_creation` datetime NOT NULL,
  `date_modification` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `pourcentage` float DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `statut_vie` varchar(255) NOT NULL,
  `createur` bigint(20) NOT NULL,
  `enseignement` bigint(20) DEFAULT NULL,
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `type_evaluation`
--

INSERT INTO `type_evaluation` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `pourcentage`, `signature`, `statut_vie`, `createur`, `enseignement`, `modificateur`) VALUES
(6225, '2019-08-12 14:05:39', '2019-08-12 14:05:39', 'Session normale', 'SN', 70, '-1478814358', 'ACTIVE', 1, 6115, 1),
(6224, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '-1787604862', 'ACTIVE', 1, 6115, 1),
(6223, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 70, '-1918548074', 'ACTIVE', 1, 6105, 1),
(6222, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 70, '-1916060045', 'ACTIVE', 1, 6105, 1),
(6218, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 20, '1399066508', 'ACTIVE', 1, 6104, 1),
(6219, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 50, '1727293981', 'ACTIVE', 1, 6104, 1),
(6220, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Travaux pratiques', 'TP', 30, '1553455157', 'ACTIVE', 1, 6104, 1),
(6221, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '2037048737', 'ACTIVE', 1, 6105, 1),
(6217, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 50, '1735185713', 'ACTIVE', 1, 6104, 1),
(6216, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Rattrapages ', 'RA', 70, '1044860384', 'ACTIVE', 1, 6103, 1),
(6215, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Session normale', 'SN', 70, '1020076194', 'ACTIVE', 1, 6103, 1),
(6214, '2019-08-12 14:05:38', '2019-08-12 14:05:38', 'Controle continu', 'CC', 30, '698911854', 'ACTIVE', 1, 6103, 1),
(6213, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 50, '1913154051', 'ACTIVE', 1, 6102, 1),
(6212, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Travaux pratiques', 'TP', 30, '1745678008', 'ACTIVE', 1, 6102, 1),
(6210, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 20, '1578737738', 'ACTIVE', 1, 6102, 1),
(6211, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 50, '1926983802', 'ACTIVE', 1, 6102, 1),
(6207, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 20, '612928894', 'ACTIVE', 1, 6101, 1),
(6209, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Travaux pratiques', 'TP', 30, '798821045', 'ACTIVE', 1, 6101, 1),
(6208, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 50, '952676835', 'ACTIVE', 1, 6101, 1),
(6204, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 30, '1695689673', 'ACTIVE', 1, 6069, 1),
(6206, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 70, '1997298624', 'ACTIVE', 1, 6069, 1),
(6205, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 70, '1999679982', 'ACTIVE', 1, 6069, 1),
(6203, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Rattrapages ', 'RA', 70, '2028775677', 'ACTIVE', 1, 6108, 1),
(6201, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Controle continu', 'CC', 30, '1681155968', 'ACTIVE', 1, 6108, 1),
(6166, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Session normale', 'SN', 70, '975489392', 'ACTIVE', 1, 6068, 1),
(6202, '2019-08-12 14:05:37', '2019-08-12 14:05:37', 'Session normale', 'SN', 70, '2021698873', 'ACTIVE', 1, 6108, 1),
(6167, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Rattrapages ', 'RA', 70, '981463929', 'ACTIVE', 1, 6068, 1),
(6165, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Controle continu', 'CC', 30, '661258667', 'ACTIVE', 1, 6068, 1),
(6164, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Rattrapages ', 'RA', 70, '74472129', 'ACTIVE', 1, 6067, 1),
(6163, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Session normale', 'SN', 70, '69599859', 'ACTIVE', 1, 6067, 1),
(6162, '2019-08-12 14:05:36', '2019-08-12 14:05:36', 'Controle continu', 'CC', 30, '-271156388', 'ACTIVE', 1, 6067, 1),
(6161, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '1819295856', 'ACTIVE', 1, 6113, 1),
(6160, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '1833197682', 'ACTIVE', 1, 6113, 1),
(6159, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '1520033667', 'ACTIVE', 1, 6113, 1),
(6158, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '1154192819', 'ACTIVE', 1, 6112, 1),
(6157, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '1129550857', 'ACTIVE', 1, 6112, 1),
(6156, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '806999794', 'ACTIVE', 1, 6112, 1),
(6153, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Controle continu', 'CC', 30, '-40126511', 'ACTIVE', 1, 6111, 1),
(6154, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Session normale', 'SN', 70, '281037829', 'ACTIVE', 1, 6111, 1),
(6155, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '268202713', 'ACTIVE', 1, 6111, 1),
(6152, '2019-08-12 14:05:35', '2019-08-12 14:05:35', 'Rattrapages ', 'RA', 70, '-977573508', 'ACTIVE', 1, 6110, 1),
(6151, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '-983156918', 'ACTIVE', 1, 6110, 1),
(6150, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Controle continu', 'CC', 30, '-1286400530', 'ACTIVE', 1, 6110, 1),
(6149, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 100, '1807274031', 'ACTIVE', 1, 6116, 1),
(6148, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '1536689863', 'ACTIVE', 1, 6106, 1),
(6147, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Rattrapages ', 'RA', 70, '1513932422', 'ACTIVE', 1, 6106, 1),
(6146, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Controle continu', 'CC', 30, '1192305841', 'ACTIVE', 1, 6106, 1),
(6145, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Session normale', 'SN', 70, '-2056635918', 'ACTIVE', 1, 6114, 1),
(6142, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Travaux pratiques', 'TP', 30, '-1925473971', 'ACTIVE', 1, 6109, 1),
(6144, '2019-08-12 14:05:34', '2019-08-12 14:05:34', 'Rattrapages ', 'RA', 70, '-2062503784', 'ACTIVE', 1, 6114, 1),
(6143, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Controle continu', 'CC', 30, '1894445154', 'ACTIVE', 1, 6114, 1),
(6141, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Rattrapages ', 'RA', 30, '-1928355049', 'ACTIVE', 1, 6109, 1),
(6138, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Rattrapages ', 'RA', 50, '722281355', 'ACTIVE', 1, 6107, 1),
(6140, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Session normale', 'SN', 50, '-1772294725', 'ACTIVE', 1, 6109, 1),
(6139, '2019-08-12 14:05:33', '2019-08-12 14:05:33', 'Controle continu', 'CC', 20, '-2116842861', 'ACTIVE', 1, 6109, 1),
(6137, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Travaux pratiques', 'TP', 30, '521381732', 'ACTIVE', 1, 6107, 1),
(6136, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Session normale', 'SN', 50, '708945558', 'ACTIVE', 1, 6107, 1),
(6135, '2019-08-12 14:05:32', '2019-08-12 14:05:32', 'Controle continu', 'CC', 20, '339827535', 'ACTIVE', 1, 6107, 1),
(6226, '2019-08-12 14:05:39', '2019-08-12 14:05:39', 'Rattrapages ', 'RA', 70, '-1467328486', 'ACTIVE', 1, 6115, 1);

-- --------------------------------------------------------

--
-- Structure de la table `ue`
--

CREATE TABLE `ue` (
  `code` bigint(20) NOT NULL,
  `code_ue` varchar(255) DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
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
  `specialite` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ue`
--

INSERT INTO `ue` (`code`, `code_ue`, `credits`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `module`, `niveau`, `specialite`) VALUES
(6047, 'SAS451', 1, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Sagesse et science2', '-1676602354', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(6043, 'INF362', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Enterprise Resource Planning (ERP)', '-610263718', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(6044, 'INF365', 3, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Projet Tutoré', '-2091968107', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(6045, 'INF364', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Conception et Développement d’applications pour mobiles', '885629586', 'ACTIVE', 'ACTIVE', 1, 1, 1125, 9, 4),
(6046, 'STG361', 10, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Stage Professionnel', '1936002499', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(6038, 'COM351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Fondamentaux de la communication', '1056905378', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6039, 'ANG351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Anglais pratique', '161649411', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6040, 'SAS351', 1, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Sagesse et science1', '-95474378', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6041, 'INF361', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'JEE(Programmation par Objets avancée)', '2128180871', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(6042, 'INF363', 4, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Technologie.NET', '1006331350', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(6037, 'MKT351', 2, '2019-08-12 14:01:53', '2019-08-12 14:01:53', '', 'Marketing Informatique', '1450441429', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6034, 'INF355', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Sécurité avancée des réseaux et systèmes', '-1855207364', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(6035, 'INF356', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Gestion des Projets informatique', '86779590', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(6036, 'ATE351', 2, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Ateliers de création d\'entreprise', '-1276758353', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(6033, 'INF354', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Introduction au Big Data', '1120268651', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(6032, 'INF352', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Ingénierie du Génie Logiciel', '-2049089083', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(6031, 'MAT351', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Recherche opérationnelle et aide à la décision', '-1090962945', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(6029, 'STG241', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Stage Technique', '-112629072', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6030, 'INF351', 4, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '1726451090', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(6028, 'ETH241', 1, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Éthique et Philosophie', '1489970125', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6027, 'ANG241', 2, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Anglais Niveau pratique B2', '2101404059', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(6025, 'INF243', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction à la sécurité informatique', '1804389895', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(6026, 'INF245', 3, '2019-08-12 14:01:52', '2019-08-12 14:01:52', '', 'Projets tutorés', '-1830197205', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(6022, 'INF242', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Programmation Web II', '-1394241732', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6023, 'ENV241', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'L\'entreprise et la gestion, environnement comptable, financier', '-1996238929', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(6024, 'INF244', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'économie numérique', '1025392186', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(6020, 'INF241', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Langage C++ et POO', '-1967549909', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6021, 'MAT241', 2, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Algèbre linéaire II', '-415709806', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(6019, 'ETH231', 1, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Ethique et Développement    ', '418557758', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(6015, 'INF235', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction aux Base de données', '1117098552', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6016, 'INF236', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Introduction aux Réseaux informatiques', '1192377288', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(6018, 'ANG231', 2, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Anglais niveau pratique B1/B2', '43146116', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(6017, 'INF234', 3, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Systèmes d\'exploitation', '-1538264342', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(6014, 'INF233', 4, '2019-08-12 14:01:51', '2019-08-12 14:01:51', '', 'Programmation Orientée Objet II', '283860640', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6012, 'INF232', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'modélisation des Systèmes d\'Information(UML)', '-341529405', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(6013, 'MAT231', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algèbre linaire I', '-16969748', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(6010, 'STA121', 3, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Stage découverte de l’entreprise', '-492412225', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6011, 'INF231', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algorithmique et Complexité', '-713152904', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(6009, 'REF112', 1, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Réflexion Humaine 2', '-1574876759', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6007, 'EXP121', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Communication Orale, Ecrite et audio Visual', '-357196587', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6008, 'ANG121', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Anglais niveau pratique B1', '1728661700', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(6006, 'INF125', 2, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Logique pour l\'Informatique', '1717387095', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(5959, 'REF111', 2, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Réflexion Humaine1', '-470066443', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(6001, 'INF121', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Initiation Programmation orientée objet I', '1594107048', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(6002, 'INF124', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Initiation à la programmation C', '276007637', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(6003, 'INF123', 4, '2019-08-12 14:01:49', '2019-08-12 14:01:50', '', 'Introduction à l\'Analyse Merise', '-1281114476', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(6004, 'INF122', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Algorithmique et Structure de données I', '-1949933057', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(6005, 'MAT121', 4, '2019-08-12 14:01:50', '2019-08-12 14:01:50', '', 'Mathématiques discrètes II', '524905718', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(5958, 'ANG111', 2, '2019-08-12 14:01:49', '2019-08-12 14:01:49', '', 'Anglais Remise à niveau A2', '-1935705414', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(5953, 'INF112', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Programmation Web I', '-577965367', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5957, 'MAT112', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Mathématiques discrètes I', '-1034700067', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(5956, 'MAT111', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Mathématiques pour l\'informatique', '901939799', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(5955, 'INF114', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Introduction aux algorithmes', '943922743', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5954, 'INF115', 2, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Enjeux de l’économie Numérique', '-1946344577', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(5952, 'INF113', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Architecture des ordinateurs', '-1568829338', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4),
(5951, 'INF111', 4, '2019-08-12 14:01:48', '2019-08-12 14:01:48', '', 'Introduction aux systèmes d\'information', '-1260997468', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `code` bigint(20) NOT NULL,
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
  `modificateur` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`code`, `date_creation`, `date_modification`, `date_naissance`, `description`, `email`, `libelle`, `login`, `mot_de_passe`, `nom`, `prenom`, `sexe`, `signature`, `statut`, `statut_vie`, `telephone`, `createur`, `modificateur`) VALUES
(1, '2019-04-08 12:52:09', '2019-05-19 11:51:08', '1990-04-09 00:00:00', NULL, 'channeldonkeng@gmail.com', NULL, 'channel', 'BA-32-53-87-6A-ED-6B-C2-2D-4A-6F-F5-3D-84-6-C6-AD-86-41-95-ED-14-4A-B5-C8-76-21-B6-C2-33-B5-48-BA-EA-E6-95-6D-F3-46-EC-8C-17-F5-EA-10-F3-5E-E3-CB-C5-14-79-7E-D7-DD-D3-14-54-64-E2-A0-BA-B4-13', 'Donkeng', 'Channel', 'FEMININ', '853839448', 'ACTIVE', 'ACTIVE', 656307859, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur_role`
--

CREATE TABLE `utilisateur_role` (
  `code_utilisateur` bigint(20) NOT NULL,
  `code_role` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `annee_academique`
--
ALTER TABLE `annee_academique`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_annee_academique_createur` (`createur`) USING BTREE,
  ADD KEY `FK_annee_academique_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `anonymat`
--
ALTER TABLE `anonymat`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_anonymat_createur` (`createur`) USING BTREE,
  ADD KEY `FK_anonymat_note` (`note`) USING BTREE,
  ADD KEY `FK_anonymat_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_anonymat_est_inscrit` (`est_inscrit`) USING BTREE,
  ADD KEY `FK_anonymat_evaluation` (`evaluation`) USING BTREE;

--
-- Index pour la table `candidat`
--
ALTER TABLE `candidat`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `email` (`email`) USING BTREE,
  ADD UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_candidat_classe` (`classe`) USING BTREE,
  ADD KEY `FK_candidat_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_candidat_createur` (`createur`) USING BTREE;

--
-- Index pour la table `classe`
--
ALTER TABLE `classe`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_classe_createur` (`createur`) USING BTREE,
  ADD KEY `FK_classe_niveau` (`niveau`) USING BTREE,
  ADD KEY `FK_classe_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_classe_specialite` (`specialite`) USING BTREE;

--
-- Index pour la table `discipline`
--
ALTER TABLE `discipline`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_discipline_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_discipline_createur` (`createur`) USING BTREE,
  ADD KEY `FK_discipline_semestre` (`semestre`) USING BTREE,
  ADD KEY `FK_discipline_etudiant` (`etudiant`) USING BTREE;

--
-- Index pour la table `droit`
--
ALTER TABLE `droit`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_droit_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_droit_role` (`role`) USING BTREE,
  ADD KEY `FK_droit_createur` (`createur`) USING BTREE;

--
-- Index pour la table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`code`) USING BTREE;

--
-- Index pour la table `enseignant`
--
ALTER TABLE `enseignant`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `email` (`email`) USING BTREE,
  ADD UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_enseignant_createur` (`createur`) USING BTREE,
  ADD KEY `FK_enseignant_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `enseignement`
--
ALTER TABLE `enseignement`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_enseignement_ue` (`ue`) USING BTREE,
  ADD KEY `FK_enseignement_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_enseignement_createur` (`createur`) USING BTREE,
  ADD KEY `FK_enseignement_semestre` (`semestre`) USING BTREE;

--
-- Index pour la table `enseignement_enseignant`
--
ALTER TABLE `enseignement_enseignant`
  ADD PRIMARY KEY (`code_enseignant`,`code_enseignement`) USING BTREE,
  ADD KEY `FK_enseignement_enseignant_code_enseignement` (`code_enseignement`) USING BTREE;

--
-- Index pour la table `envoi_message`
--
ALTER TABLE `envoi_message`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_envoi_message_createur` (`createur`) USING BTREE,
  ADD KEY `FK_envoi_message_candidat` (`candidat`) USING BTREE,
  ADD KEY `FK_envoi_message_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_envoi_message_message` (`message`) USING BTREE;

--
-- Index pour la table `est_inscrit`
--
ALTER TABLE `est_inscrit`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_est_inscrit_candidat_inscrit` (`candidat_inscrit`) USING BTREE,
  ADD KEY `FK_est_inscrit_createur` (`createur`) USING BTREE,
  ADD KEY `FK_est_inscrit_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_est_inscrit_enseignement` (`enseignement`) USING BTREE;

--
-- Index pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `matricule` (`matricule`) USING BTREE,
  ADD UNIQUE KEY `code_authentification` (`code_authentification`,`matricule`) USING BTREE;

--
-- Index pour la table `evaluation`
--
ALTER TABLE `evaluation`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_evaluation_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_evaluation_type_evaluation` (`type_evaluation`) USING BTREE,
  ADD KEY `FK_evaluation_createur` (`createur`) USING BTREE;

--
-- Index pour la table `filiere`
--
ALTER TABLE `filiere`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_filiere_createur` (`createur`) USING BTREE,
  ADD KEY `FK_filiere_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `historique_note`
--
ALTER TABLE `historique_note`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_historique_note_note` (`note`) USING BTREE,
  ADD KEY `FK_historique_note_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_historique_note_createur` (`createur`) USING BTREE;

--
-- Index pour la table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_message_createur` (`createur`) USING BTREE,
  ADD KEY `FK_message_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_Module_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_Module_createur` (`createur`) USING BTREE;

--
-- Index pour la table `niveau`
--
ALTER TABLE `niveau`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_Niveau_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_Niveau_createur` (`createur`) USING BTREE;

--
-- Index pour la table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_note_est_inscrit` (`est_inscrit`) USING BTREE,
  ADD KEY `FK_note_createur` (`createur`) USING BTREE,
  ADD KEY `FK_note_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_note_evaluation` (`evaluation`) USING BTREE;

--
-- Index pour la table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_role_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_role_createur` (`createur`) USING BTREE;

--
-- Index pour la table `semestre`
--
ALTER TABLE `semestre`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_semestre_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_semestre_createur` (`createur`) USING BTREE,
  ADD KEY `FK_semestre_annee_academique` (`annee_academique`) USING BTREE;

--
-- Index pour la table `sequence`
--
ALTER TABLE `sequence`
  ADD PRIMARY KEY (`SEQ_NAME`) USING BTREE;

--
-- Index pour la table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_Session_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_Session_utilisateur` (`utilisateur`) USING BTREE,
  ADD KEY `FK_Session_createur` (`createur`) USING BTREE;

--
-- Index pour la table `sms`
--
ALTER TABLE `sms`
  ADD PRIMARY KEY (`code`) USING BTREE;

--
-- Index pour la table `specialite`
--
ALTER TABLE `specialite`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_specialite_filiere` (`filiere`) USING BTREE,
  ADD KEY `FK_specialite_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_specialite_createur` (`createur`) USING BTREE;

--
-- Index pour la table `tmp_ue`
--
ALTER TABLE `tmp_ue`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Index pour la table `type_evaluation`
--
ALTER TABLE `type_evaluation`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_type_evaluation_enseignement` (`enseignement`) USING BTREE,
  ADD KEY `FK_type_evaluation_createur` (`createur`) USING BTREE,
  ADD KEY `FK_type_evaluation_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `ue`
--
ALTER TABLE `ue`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_UE_niveau` (`niveau`) USING BTREE,
  ADD KEY `FK_UE_modificateur` (`modificateur`) USING BTREE,
  ADD KEY `FK_UE_specialite` (`specialite`) USING BTREE,
  ADD KEY `FK_UE_module` (`module`) USING BTREE,
  ADD KEY `FK_UE_createur` (`createur`) USING BTREE;

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`code`) USING BTREE,
  ADD UNIQUE KEY `email` (`email`) USING BTREE,
  ADD UNIQUE KEY `login` (`login`) USING BTREE,
  ADD UNIQUE KEY `telephone` (`telephone`) USING BTREE,
  ADD UNIQUE KEY `signature` (`signature`) USING BTREE,
  ADD KEY `FK_utilisateur_createur` (`createur`) USING BTREE,
  ADD KEY `FK_utilisateur_modificateur` (`modificateur`) USING BTREE;

--
-- Index pour la table `utilisateur_role`
--
ALTER TABLE `utilisateur_role`
  ADD PRIMARY KEY (`code_utilisateur`,`code_role`) USING BTREE,
  ADD KEY `FK_utilisateur_role_code_role` (`code_role`) USING BTREE;

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `annee_academique`
--
ALTER TABLE `annee_academique`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=355;

--
-- AUTO_INCREMENT pour la table `anonymat`
--
ALTER TABLE `anonymat`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `candidat`
--
ALTER TABLE `candidat`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3126;

--
-- AUTO_INCREMENT pour la table `classe`
--
ALTER TABLE `classe`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=206;

--
-- AUTO_INCREMENT pour la table `discipline`
--
ALTER TABLE `discipline`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7434;

--
-- AUTO_INCREMENT pour la table `droit`
--
ALTER TABLE `droit`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=580;

--
-- AUTO_INCREMENT pour la table `email`
--
ALTER TABLE `email`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT pour la table `enseignant`
--
ALTER TABLE `enseignant`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `enseignement`
--
ALTER TABLE `enseignement`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6135;

--
-- AUTO_INCREMENT pour la table `envoi_message`
--
ALTER TABLE `envoi_message`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=402;

--
-- AUTO_INCREMENT pour la table `est_inscrit`
--
ALTER TABLE `est_inscrit`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6873;

--
-- AUTO_INCREMENT pour la table `etudiant`
--
ALTER TABLE `etudiant`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3126;

--
-- AUTO_INCREMENT pour la table `evaluation`
--
ALTER TABLE `evaluation`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6267;

--
-- AUTO_INCREMENT pour la table `filiere`
--
ALTER TABLE `filiere`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `historique_note`
--
ALTER TABLE `historique_note`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1170;

--
-- AUTO_INCREMENT pour la table `message`
--
ALTER TABLE `message`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT pour la table `niveau`
--
ALTER TABLE `niveau`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `note`
--
ALTER TABLE `note`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6968;

--
-- AUTO_INCREMENT pour la table `role`
--
ALTER TABLE `role`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=552;

--
-- AUTO_INCREMENT pour la table `semestre`
--
ALTER TABLE `semestre`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=709;

--
-- AUTO_INCREMENT pour la table `session`
--
ALTER TABLE `session`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7252;

--
-- AUTO_INCREMENT pour la table `sms`
--
ALTER TABLE `sms`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `specialite`
--
ALTER TABLE `specialite`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT pour la table `tmp_ue`
--
ALTER TABLE `tmp_ue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=272;

--
-- AUTO_INCREMENT pour la table `type_evaluation`
--
ALTER TABLE `type_evaluation`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6227;

--
-- AUTO_INCREMENT pour la table `ue`
--
ALTER TABLE `ue`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6048;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `code` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

