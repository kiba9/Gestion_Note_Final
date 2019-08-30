-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  lun. 12 août 2019 à 10:37
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
(3123, 'Etudiant', '2019-08-07 14:43:44', '2019-08-07 14:47:16', '2001-04-26 22:00:00', '', 'LYCEE MGR BESSIEUX', 'timamomarion9@gmail.com', '', 'TIMAMO ', 'KANBOUM KAMBA Antoinette', 'TIMAMO SIMO Eugène', 'Viorika Shany Marion', '', '', 'OUEST', 'FEMININ', '598877771', 'ACTIVE', 'ACTIVE', 656499228, 2147483647, 2147483647, 53, 1, 1),
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
) ENGINE=MyISAM AUTO_INCREMENT=1997 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `enseignement`
--

INSERT INTO `enseignement` (`code`, `date_creation`, `date_modification`, `description`, `heures_de_cours`, `libelle`, `programme_de_cours`, `signature`, `statut_vie`, `createur`, `modificateur`, `semestre`, `ue`) VALUES
(1363, '2019-08-10 13:48:01', '2019-08-10 13:48:01', 'Fondamentaux de la communication', 60, 'Fondamentaux de la communication', '', '-2028810160', 'ACTIVE', 1, 1, 705, 1281),
(1362, '2019-08-10 13:48:01', '2019-08-10 13:48:01', 'Marketing Informatique', 60, 'Marketing Informatique', '', '2056376594', 'ACTIVE', 1, 1, 705, 1280),
(1361, '2019-08-10 13:48:00', '2019-08-10 13:48:00', 'Ateliers de création d\'entreprise', 60, 'Ateliers de création d\'entreprise', '', '-47692225', 'ACTIVE', 1, 1, 705, 1279),
(1360, '2019-08-10 13:48:00', '2019-08-10 13:48:00', 'Gestion des Projets informatique', 120, 'Gestion des Projets informatique', '', '415799505', 'ACTIVE', 1, 1, 705, 1278),
(1359, '2019-08-10 13:48:00', '2019-08-10 13:48:00', 'Sécurité avancée des réseaux et systèmes', 120, 'Sécurité avancée des réseaux et systèmes', '', '-247914184', 'ACTIVE', 1, 1, 705, 1277),
(1358, '2019-08-10 13:48:00', '2019-08-10 13:48:00', 'Apprendre a manipuler les grosses quantites de donnees', 120, 'Introduction au Big Data', '', '-2053666819', 'ACTIVE', 1, 1, 705, 1276),
(1357, '2019-08-10 13:47:59', '2019-08-10 13:48:00', 'Avoir les notons de la notion de genie logiciel', 120, 'Ingénierie du Génie Logiciel', '', '1794733387', 'ACTIVE', 1, 1, 705, 1275),
(1356, '2019-08-10 13:47:59', '2019-08-10 13:47:59', '', 120, 'Recherche opérationnelle et aide à la décision', '', '84353310', 'ACTIVE', 1, 1, 705, 1274),
(1355, '2019-08-10 13:47:59', '2019-08-10 13:47:59', 'Acquerir les notions avancees de bases des bases de donnees', 120, 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '', '-18567461', 'ACTIVE', 1, 1, 705, 1273),
(1354, '2019-08-10 13:47:59', '2019-08-10 13:47:59', 'Stage qui mettra en exergue nos competences techniques', 1056, 'Stage Technique', '', '871086360', 'ACTIVE', 1, 1, 706, 1272),
(1353, '2019-08-10 13:47:59', '2019-08-10 13:47:59', 'developper l\'ethique', 60, 'Éthique et Philosophie', '', '1187356106', 'ACTIVE', 1, 1, 706, 1271),
(1352, '2019-08-10 13:47:59', '2019-08-10 13:47:59', 'Maitriser l\'anglais niveau B2', 60, 'Anglais Niveau pratique B2', '', '1763009392', 'ACTIVE', 1, 1, 706, 1270),
(1351, '2019-08-10 13:47:58', '2019-08-10 13:47:58', 'projet effectue en groupe pour la realisation d\'une application qui resous un probleme reel', 90, 'Projets tutorés', '', '1575719020', 'ACTIVE', 1, 1, 706, 1269),
(1324, '2019-08-10 13:47:57', '2019-08-10 13:47:57', 'Avoir les notions de bases de ;a securite informatiques', 120, 'Introduction à la sécurité informatique', '', '-1274414966', 'ACTIVE', 1, 1, 706, 1268),
(1323, '2019-08-10 13:47:57', '2019-08-10 13:47:57', 'Maitriser les ruages de l\'economie numerique', 90, 'économie numérique', '', '945438169', 'ACTIVE', 1, 1, 706, 1267),
(1322, '2019-08-10 13:47:57', '2019-08-10 13:47:57', 'Maitriser l\'environnement comptable de l\'entreprise ', 120, 'L\'entreprise et la gestion, environnement comptable, financier', '', '599146950', 'ACTIVE', 1, 1, 706, 1266),
(1320, '2019-08-10 13:47:56', '2019-08-10 13:47:56', 'algebre 2', 120, 'Algèbre linéaire II', '', '-688274594', 'ACTIVE', 1, 1, 706, 1264),
(1321, '2019-08-10 13:47:57', '2019-08-10 13:47:57', 'Maitriser un langage sur web', 120, 'Programmation Web II', '', '-427416183', 'ACTIVE', 1, 1, 706, 1265),
(1319, '2019-08-10 13:47:56', '2019-08-10 13:47:56', 'Appliquer la POO sur le c++', 120, 'Langage C++ et POO', '', '356060788', 'ACTIVE', 1, 1, 706, 1263),
(1318, '2019-08-10 13:47:56', '2019-08-10 13:47:56', 'Developper l\'ethique de travail', 30, 'Ethique et Développement    ', '', '-1779398526', 'ACTIVE', 1, 1, 705, 1262),
(1317, '2019-08-10 13:47:56', '2019-08-10 13:47:56', 'Maitriser l\'anglais du niveau B1/B2', 60, 'Anglais niveau pratique B1/B2', '', '-2105602070', 'ACTIVE', 1, 1, 705, 1261),
(1316, '2019-08-10 13:47:55', '2019-08-10 13:47:55', 'Avoir les bases de Linux', 90, 'Systèmes d\'exploitation', '', '1287436665', 'ACTIVE', 1, 1, 705, 1260),
(1315, '2019-08-10 13:47:55', '2019-08-10 13:47:55', 'Acquerir les notions de bases de reseaux', 120, 'Introduction aux Réseaux informatiques', '', '-2126233360', 'ACTIVE', 1, 1, 705, 1259),
(1314, '2019-08-10 13:47:55', '2019-08-10 13:47:55', 'Acquerir les notions en bases de donnees', 120, 'Introduction aux Base de données', '', '-174370432', 'ACTIVE', 1, 1, 705, 1258),
(1313, '2019-08-10 13:47:55', '2019-08-10 13:47:55', 'notion avancee en Programmation Oriente Objet', 120, 'Programmation Orientée Objet II', '', '796359370', 'ACTIVE', 1, 1, 705, 1257),
(1312, '2019-08-10 13:47:55', '2019-08-10 13:47:55', 'Maitriser les bases de l\'algebre ', 120, 'Algèbre linaire I', '', '640421196', 'ACTIVE', 1, 1, 705, 1256),
(1311, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Maitriser la modelisation UML', 120, 'modélisation des Systèmes d\'Information(UML)', '', '1971437294', 'ACTIVE', 1, 1, 705, 1255),
(1310, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Rendre nos algorithmes efficient', 120, 'Algorithmique et Complexité', '', '-322768008', 'ACTIVE', 1, 1, 705, 1254),
(1309, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Se familiariser avec le monde de l\'emploi', 528, 'Stage découverte de l’entreprise', '', '1763225859', 'ACTIVE', 1, 1, 706, 1253),
(1308, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Developper l\'ethique', 30, 'Réflexion Humaine 2', '', '-907724351', 'ACTIVE', 1, 1, 706, 1252),
(1307, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Pouvoir bien s\'exprimer dans differentes situations en anglais', 60, 'Anglais niveau pratique B1', '', '999509986', 'ACTIVE', 1, 1, 706, 1251),
(1305, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'maitriser l\'algebre de bool', 60, 'Logique pour l\'Informatique', '', '1010683432', 'ACTIVE', 1, 1, 706, 1248),
(1306, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'Maitriser les ruage de la communication', 60, 'Communication Orale, Ecrite et audio Visual', '', '-1782678123', 'ACTIVE', 1, 1, 706, 1249),
(1304, '2019-08-10 13:47:54', '2019-08-10 13:47:54', 'notions en logique mathematique', 120, 'Mathématiques discrètes II', '', '-29310733', 'ACTIVE', 1, 1, 706, 1247),
(1303, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Notions avancee d\'algorithmique', 120, 'Algorithmique et Structure de données I', '', '-593356264', 'ACTIVE', 1, 1, 706, 1246),
(1302, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Apprendre les bases de l\'analye Merise', 120, 'Introduction à l\'Analyse Merise', '', '-1545782566', 'ACTIVE', 1, 1, 706, 1245),
(1301, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Apprendre les bases du langage C', 150, 'Initiation à la programmation C', '', '1178214005', 'ACTIVE', 1, 1, 706, 1244),
(1300, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Apprendre les bases de l\'oriente objet', 180, 'Initiation Programmation orientée objet I', '', '298514605', 'ACTIVE', 1, 1, 706, 1243),
(1299, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Developper l\'ethique', 30, 'Réflexion Humaine1', '', '1159157610', 'ACTIVE', 1, 1, 705, 1242),
(1298, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Etre capable de parler et bien ecrire l\'Anglais', 60, 'Anglais Remise à niveau A2', '', '1899421349', 'ACTIVE', 1, 1, 705, 1241),
(1297, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'Acquerir la bonne logique informatique', 120, 'Mathématiques discrètes I', '', '519041824', 'ACTIVE', 1, 1, 705, 1240),
(1296, '2019-08-10 13:47:53', '2019-08-10 13:47:53', 'familiariser avec les notions de maths propres a l\'informatique', 150, 'Mathématiques pour l\'informatique', '', '-501807334', 'ACTIVE', 1, 1, 705, 1239),
(1295, '2019-08-10 13:47:52', '2019-08-10 13:47:52', 'Acquerir les notions de baeses de l\'algorithme', 120, 'Introduction aux algorithmes', '', '-331079986', 'ACTIVE', 1, 1, 705, 1238),
(1294, '2019-08-10 13:47:52', '2019-08-10 13:47:52', 'Connaitre les enjeux de l\'econoimie numerique ', 60, 'Enjeux de l’économie Numérique', '', '-2132539834', 'ACTIVE', 1, 1, 705, 1237),
(1293, '2019-08-10 13:47:52', '2019-08-10 13:47:52', 'Les bases du html,css et javascript', 120, 'Programmation Web I', '', '1127396827', 'ACTIVE', 1, 1, 705, 1236),
(1292, '2019-08-10 13:47:52', '2019-08-10 13:47:52', 'Connaitre les composants de l\'ordinateur', 120, 'Architecture des ordinateurs', '', '509858227', 'ACTIVE', 1, 1, 705, 1235),
(1291, '2019-08-10 13:47:51', '2019-08-10 13:47:51', 'Maitriser les bases du systeme d\'information', 120, 'Introduction aux systèmes d\'information', '', '-1277065535', 'ACTIVE', 1, 1, 705, 1234),
(1364, '2019-08-10 13:48:01', '2019-08-10 13:48:01', 'Anglais pratique', 30, 'Anglais pratique', '', '1620816701', 'ACTIVE', 1, 1, 705, 1282),
(1365, '2019-08-10 13:48:01', '2019-08-10 13:48:01', 'Sagesse et science1', 15, 'Sagesse et science1', '', '-1962841368', 'ACTIVE', 1, 1, 705, 1283),
(1366, '2019-08-10 13:48:01', '2019-08-10 13:48:01', 'JEE(Programmation par Objets avancée)', 120, 'JEE(Programmation par Objets avancée)', '', '-1014766997', 'ACTIVE', 1, 1, 706, 1284),
(1367, '2019-08-10 13:48:02', '2019-08-10 13:48:02', 'Technologie.NET', 120, 'Technologie.NET', '', '-284917288', 'ACTIVE', 1, 1, 706, 1285),
(1368, '2019-08-10 13:48:02', '2019-08-10 13:48:02', 'Enterprise Resource Planning (ERP)', 120, 'Enterprise Resource Planning (ERP)', '', '619210732', 'ACTIVE', 1, 1, 706, 1286),
(1369, '2019-08-10 13:48:02', '2019-08-10 13:48:02', 'Projet Tutoré', 120, 'Projet Tutoré', '', '-1786381553', 'ACTIVE', 1, 1, 706, 1287),
(1370, '2019-08-10 13:48:02', '2019-08-10 13:48:02', 'Conception et Développement d’applications pour mobiles', 120, 'Conception et Développement d’applications pour mobiles', '', '-1212903842', 'ACTIVE', 1, 1, 706, 1288),
(1371, '2019-08-10 13:48:02', '2019-08-10 13:48:03', 'Stage Professionnel', 300, 'Stage Professionnel', '', '-1315787021', 'ACTIVE', 1, 1, 706, 1289),
(1372, '2019-08-10 13:48:03', '2019-08-10 13:48:03', 'Sagesse et science2', 40, 'Sagesse et science2', '', '-566439250', 'ACTIVE', 1, 1, 706, 1290);

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
) ENGINE=MyISAM AUTO_INCREMENT=3682 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `est_inscrit`
--

INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(3579, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'ETH231', '', '734242017', 'VALIDE', 'ACTIVE', 3121, 1, 1353, 1),
(3578, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'ANG231', '', '1712582745', 'VALIDE', 'ACTIVE', 3121, 1, 1317, 1),
(3577, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF234', '', '-776893849', 'VALIDE', 'ACTIVE', 3121, 1, 1316, 1),
(3576, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF236', '', '-740212796', 'VALIDE', 'ACTIVE', 3121, 1, 1315, 1),
(3575, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF235', '', '-1626078284', 'VALIDE', 'ACTIVE', 3121, 1, 1314, 1),
(3574, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF233', '', '-873463015', 'VALIDE', 'ACTIVE', 3121, 1, 1313, 1),
(3573, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'MAT231', '', '-450831745', 'VALIDE', 'ACTIVE', 3121, 1, 1312, 1),
(3572, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'MAT241', '', '-1125267497', 'VALIDE', 'ACTIVE', 3121, 1, 1320, 1),
(3571, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF232', '', '1712441606', 'VALIDE', 'ACTIVE', 3121, 1, 1311, 1),
(3570, '2019-08-10 17:36:31', '2019-08-10 17:36:31', 'INF231', '', '-1216977158', 'VALIDE', 'ACTIVE', 3121, 1, 1310, 1),
(3569, '2019-08-10 17:36:30', '2019-08-10 17:36:30', 'IN245', '', '-1871297481', 'VALIDE', 'ACTIVE', 3121, 1, 1351, 1),
(3568, '2019-08-10 17:36:30', '2019-08-10 17:36:30', 'INF243', '', '796678865', 'VALIDE', 'ACTIVE', 3121, 1, 1324, 1),
(3567, '2019-08-10 17:36:30', '2019-08-10 17:36:30', 'INF244', '', '-62963821', 'VALIDE', 'ACTIVE', 3121, 1, 1323, 1),
(3566, '2019-08-10 17:36:30', '2019-08-10 17:36:30', 'ENV241', '', '475258928', 'VALIDE', 'ACTIVE', 3121, 1, 1322, 1),
(3565, '2019-08-10 17:36:30', '2019-08-10 17:36:30', 'STG241', '', '147710637', 'VALIDE', 'ACTIVE', 3121, 1, 1354, 1),
(3564, '2019-08-10 17:36:29', '2019-08-10 17:36:29', 'ETH241', '', '1523362857', 'VALIDE', 'ACTIVE', 3121, 1, 1318, 1),
(3563, '2019-08-10 17:36:29', '2019-08-10 17:36:29', 'ANG241', '', '771386538', 'VALIDE', 'ACTIVE', 3121, 1, 1352, 1),
(3562, '2019-08-10 17:36:29', '2019-08-10 17:36:29', 'INF242', '', '-1054608075', 'VALIDE', 'ACTIVE', 3121, 1, 1321, 1),
(3561, '2019-08-10 17:36:29', '2019-08-10 17:36:29', 'INF241', '', '1681694433', 'VALIDE', 'ACTIVE', 3121, 1, 1319, 1),
(3560, '2019-08-10 17:36:28', '2019-08-10 17:36:28', 'ETH231', '', '-510835750', 'VALIDE', 'ACTIVE', 3120, 1, 1353, 1),
(3559, '2019-08-10 17:36:28', '2019-08-10 17:36:28', 'ANG231', '', '480127713', 'VALIDE', 'ACTIVE', 3120, 1, 1317, 1),
(3558, '2019-08-10 17:36:28', '2019-08-10 17:36:28', 'INF234', '', '-2044016956', 'VALIDE', 'ACTIVE', 3120, 1, 1316, 1),
(3557, '2019-08-10 17:36:28', '2019-08-10 17:36:28', 'INF236', '', '-2002037910', 'VALIDE', 'ACTIVE', 3120, 1, 1315, 1),
(3556, '2019-08-10 17:36:28', '2019-08-10 17:36:28', 'INF235', '', '1382600682', 'VALIDE', 'ACTIVE', 3120, 1, 1314, 1),
(3555, '2019-08-10 17:36:27', '2019-08-10 17:36:27', 'INF233', '', '-2139590526', 'VALIDE', 'ACTIVE', 3120, 1, 1313, 1),
(3554, '2019-08-10 17:36:27', '2019-08-10 17:36:27', 'MAT231', '', '-1705367674', 'VALIDE', 'ACTIVE', 3120, 1, 1312, 1),
(3553, '2019-08-10 17:36:27', '2019-08-10 17:36:27', 'MAT241', '', '1887927208', 'VALIDE', 'ACTIVE', 3120, 1, 1320, 1),
(3552, '2019-08-10 17:36:27', '2019-08-10 17:36:27', 'INF232', '', '460430224', 'VALIDE', 'ACTIVE', 3120, 1, 1311, 1),
(3551, '2019-08-10 17:36:27', '2019-08-10 17:36:27', 'INF231', '', '1802120009', 'VALIDE', 'ACTIVE', 3120, 1, 1310, 1),
(3550, '2019-08-10 17:36:26', '2019-08-10 17:36:26', 'IN245', '', '1142146123', 'VALIDE', 'ACTIVE', 3120, 1, 1351, 1),
(3549, '2019-08-10 17:36:26', '2019-08-10 17:36:26', 'INF243', '', '-458283748', 'VALIDE', 'ACTIVE', 3120, 1, 1324, 1),
(3548, '2019-08-10 17:36:26', '2019-08-10 17:36:26', 'INF244', '', '-1337162771', 'VALIDE', 'ACTIVE', 3120, 1, 1323, 1),
(3547, '2019-08-10 17:36:26', '2019-08-10 17:36:26', 'ENV241', '', '-805589181', 'VALIDE', 'ACTIVE', 3120, 1, 1322, 1),
(3546, '2019-08-10 17:36:26', '2019-08-10 17:36:26', 'STG241', '', '-1133244143', 'VALIDE', 'ACTIVE', 3120, 1, 1354, 1),
(3545, '2019-08-10 17:36:25', '2019-08-10 17:36:25', 'ETH241', '', '234016625', 'VALIDE', 'ACTIVE', 3120, 1, 1318, 1),
(3544, '2019-08-10 17:36:25', '2019-08-10 17:36:25', 'ANG241', '', '-507185923', 'VALIDE', 'ACTIVE', 3120, 1, 1352, 1),
(3543, '2019-08-10 17:36:25', '2019-08-10 17:36:25', 'INF242', '', '1950195178', 'VALIDE', 'ACTIVE', 3120, 1, 1321, 1),
(3542, '2019-08-10 17:36:25', '2019-08-10 17:36:25', 'INF241', '', '426411807', 'VALIDE', 'ACTIVE', 3120, 1, 1319, 1),
(3541, '2019-08-10 17:36:24', '2019-08-10 17:36:24', 'ETH231', '', '1156595127', 'VALIDE', 'ACTIVE', 3119, 1, 1353, 1),
(3540, '2019-08-10 17:36:24', '2019-08-10 17:36:24', 'ANG231', '', '-2147159807', 'VALIDE', 'ACTIVE', 3119, 1, 1317, 1),
(3539, '2019-08-10 17:36:24', '2019-08-10 17:36:24', 'INF234', '', '-384444176', 'VALIDE', 'ACTIVE', 3119, 1, 1316, 1),
(3538, '2019-08-10 17:36:24', '2019-08-10 17:36:24', 'INF236', '', '-352705546', 'VALIDE', 'ACTIVE', 3119, 1, 1315, 1),
(3537, '2019-08-10 17:36:24', '2019-08-10 17:36:24', 'INF235', '', '-1227441693', 'VALIDE', 'ACTIVE', 3119, 1, 1314, 1),
(3536, '2019-08-10 17:36:23', '2019-08-10 17:36:24', 'INF233', '', '-473581929', 'VALIDE', 'ACTIVE', 3119, 1, 1313, 1),
(3535, '2019-08-10 17:36:23', '2019-08-10 17:36:23', 'MAT231', '', '-48283884', 'VALIDE', 'ACTIVE', 3119, 1, 1312, 1),
(3534, '2019-08-10 17:36:23', '2019-08-10 17:36:23', 'MAT241', '', '-724070802', 'VALIDE', 'ACTIVE', 3119, 1, 1320, 1),
(3533, '2019-08-10 17:36:23', '2019-08-10 17:36:23', 'INF232', '', '2115985063', 'VALIDE', 'ACTIVE', 3119, 1, 1311, 1),
(3532, '2019-08-10 17:36:23', '2019-08-10 17:36:23', 'INF231', '', '-800775409', 'VALIDE', 'ACTIVE', 3119, 1, 1310, 1),
(3531, '2019-08-10 17:36:22', '2019-08-10 17:36:22', 'IN245', '', '-1498261930', 'VALIDE', 'ACTIVE', 3119, 1, 1351, 1),
(3530, '2019-08-10 17:36:22', '2019-08-10 17:36:22', 'INF243', '', '1198551143', 'VALIDE', 'ACTIVE', 3119, 1, 1324, 1),
(3529, '2019-08-10 17:36:22', '2019-08-10 17:36:22', 'INF244', '', '346802111', 'VALIDE', 'ACTIVE', 3119, 1, 1323, 1),
(3528, '2019-08-10 17:36:22', '2019-08-10 17:36:22', 'ENV241', '', '848863391', 'VALIDE', 'ACTIVE', 3119, 1, 1322, 1),
(3527, '2019-08-10 17:36:22', '2019-08-10 17:36:22', 'STG241', '', '559325533', 'VALIDE', 'ACTIVE', 3119, 1, 1354, 1),
(3526, '2019-08-10 17:36:21', '2019-08-10 17:36:22', 'ETH241', '', '1898674056', 'VALIDE', 'ACTIVE', 3119, 1, 1318, 1),
(3525, '2019-08-10 17:36:21', '2019-08-10 17:36:21', 'ANG241', '', '1171552080', 'VALIDE', 'ACTIVE', 3119, 1, 1352, 1),
(3524, '2019-08-10 17:36:21', '2019-08-10 17:36:21', 'INF242', '', '-657784891', 'VALIDE', 'ACTIVE', 3119, 1, 1321, 1),
(3523, '2019-08-10 17:36:21', '2019-08-10 17:36:21', 'INF241', '', '2078695402', 'VALIDE', 'ACTIVE', 3119, 1, 1319, 1),
(3522, '2019-08-10 17:36:21', '2019-08-10 17:36:21', 'ETH231', '', '-1942409842', 'VALIDE', 'ACTIVE', 3118, 1, 1353, 1),
(3521, '2019-08-10 17:36:20', '2019-08-10 17:36:20', 'ANG231', '', '-987003379', 'VALIDE', 'ACTIVE', 3118, 1, 1317, 1),
(3520, '2019-08-10 17:36:20', '2019-08-10 17:36:20', 'INF234', '', '811269252', 'VALIDE', 'ACTIVE', 3118, 1, 1316, 1),
(3519, '2019-08-10 17:36:20', '2019-08-10 17:36:20', 'INF236', '', '840376664', 'VALIDE', 'ACTIVE', 3118, 1, 1315, 1),
(3518, '2019-08-10 17:36:20', '2019-08-10 17:36:20', 'INF235', '', '-67889734', 'VALIDE', 'ACTIVE', 3118, 1, 1314, 1),
(3517, '2019-08-10 17:36:20', '2019-08-10 17:36:20', 'INF233', '', '715553454', 'VALIDE', 'ACTIVE', 3118, 1, 1313, 1),
(3516, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'MAT231', '', '1122112960', 'VALIDE', 'ACTIVE', 3118, 1, 1312, 1),
(3515, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'MAT241', '', '448601690', 'VALIDE', 'ACTIVE', 3118, 1, 1320, 1),
(3514, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'INF232', '', '-983695489', 'VALIDE', 'ACTIVE', 3118, 1, 1311, 1),
(3513, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'INF231', '', '354829723', 'VALIDE', 'ACTIVE', 3118, 1, 1310, 1),
(3512, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'IN245', '', '-317411328', 'VALIDE', 'ACTIVE', 3118, 1, 1351, 1),
(3511, '2019-08-10 17:36:19', '2019-08-10 17:36:19', 'INF243', '', '-1899991585', 'VALIDE', 'ACTIVE', 3118, 1, 1324, 1),
(3510, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'INF244', '', '1533590732', 'VALIDE', 'ACTIVE', 3118, 1, 1323, 1),
(3509, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'ENV241', '', '2036505380', 'VALIDE', 'ACTIVE', 3118, 1, 1322, 1),
(3508, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'STG241', '', '1731998025', 'VALIDE', 'ACTIVE', 3118, 1, 1354, 1),
(3507, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'ETH241', '', '-1185716986', 'VALIDE', 'ACTIVE', 3118, 1, 1318, 1),
(3506, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'ANG241', '', '-1932821996', 'VALIDE', 'ACTIVE', 3118, 1, 1352, 1),
(3505, '2019-08-10 17:36:18', '2019-08-10 17:36:18', 'INF242', '', '521999001', 'VALIDE', 'ACTIVE', 3118, 1, 1321, 1),
(3504, '2019-08-10 17:36:17', '2019-08-10 17:36:17', 'INF241', '', '-1001713256', 'VALIDE', 'ACTIVE', 3118, 1, 1319, 1),
(3503, '2019-08-10 17:36:17', '2019-08-10 17:36:17', 'ETH231', '', '207298958', 'VALIDE', 'ACTIVE', 3117, 1, 1353, 1),
(3502, '2019-08-10 17:36:17', '2019-08-10 17:36:17', 'ANG231', '', '1198511320', 'VALIDE', 'ACTIVE', 3117, 1, 1317, 1),
(3501, '2019-08-10 17:36:17', '2019-08-10 17:36:17', 'INF234', '', '-1305792543', 'VALIDE', 'ACTIVE', 3117, 1, 1316, 1),
(3463, '2019-08-10 17:36:16', '2019-08-10 17:36:16', 'INF236', '', '-1339301008', 'VALIDE', 'ACTIVE', 3117, 1, 1315, 1),
(3462, '2019-08-10 17:36:16', '2019-08-10 17:36:16', 'INF235', '', '2089357150', 'VALIDE', 'ACTIVE', 3117, 1, 1314, 1),
(3461, '2019-08-10 17:36:15', '2019-08-10 17:36:15', 'INF233', '', '-1433829654', 'VALIDE', 'ACTIVE', 3117, 1, 1313, 1),
(3460, '2019-08-10 17:36:15', '2019-08-10 17:36:15', 'MAT231', '', '-1029688024', 'VALIDE', 'ACTIVE', 3117, 1, 1312, 1),
(3459, '2019-08-10 17:36:15', '2019-08-10 17:36:15', 'MAT241', '', '-1714826433', 'VALIDE', 'ACTIVE', 3117, 1, 1320, 1),
(3458, '2019-08-10 17:36:15', '2019-08-10 17:36:15', 'INF232', '', '1153817260', 'VALIDE', 'ACTIVE', 3117, 1, 1311, 1),
(3457, '2019-08-10 17:36:15', '2019-08-10 17:36:15', 'INF231', '', '-1800206948', 'VALIDE', 'ACTIVE', 3117, 1, 1310, 1),
(3456, '2019-08-10 17:36:14', '2019-08-10 17:36:14', 'IN245', '', '1810358803', 'VALIDE', 'ACTIVE', 3117, 1, 1351, 1),
(3455, '2019-08-10 17:36:14', '2019-08-10 17:36:14', 'INF243', '', '191901533', 'VALIDE', 'ACTIVE', 3117, 1, 1324, 1),
(3454, '2019-08-10 17:36:13', '2019-08-10 17:36:13', 'INF244', '', '-657180724', 'VALIDE', 'ACTIVE', 3117, 1, 1323, 1),
(3453, '2019-08-10 17:36:13', '2019-08-10 17:36:13', 'ENV241', '', '-153910506', 'VALIDE', 'ACTIVE', 3117, 1, 1322, 1),
(3452, '2019-08-10 17:36:13', '2019-08-10 17:36:13', 'STG241', '', '-451235347', 'VALIDE', 'ACTIVE', 3117, 1, 1354, 1),
(3451, '2019-08-10 17:36:13', '2019-08-10 17:36:13', 'ETH241', '', '897037983', 'VALIDE', 'ACTIVE', 3117, 1, 1318, 1),
(3450, '2019-08-10 17:36:13', '2019-08-10 17:36:13', 'ANG241', '', '169702665', 'VALIDE', 'ACTIVE', 3117, 1, 1352, 1),
(3449, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'INF242', '', '-1653589616', 'VALIDE', 'ACTIVE', 3117, 1, 1321, 1),
(3448, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'INF241', '', '1080472801', 'VALIDE', 'ACTIVE', 3117, 1, 1319, 1),
(3447, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'ETH231', '', '895770212', 'VALIDE', 'ACTIVE', 3114, 1, 1353, 1),
(3446, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'ANG231', '', '1894165088', 'VALIDE', 'ACTIVE', 3114, 1, 1317, 1),
(3445, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'INF234', '', '-612521094', 'VALIDE', 'ACTIVE', 3114, 1, 1316, 1),
(3444, '2019-08-10 17:36:12', '2019-08-10 17:36:12', 'INF236', '', '-608623595', 'VALIDE', 'ACTIVE', 3114, 1, 1315, 1),
(3443, '2019-08-10 17:36:11', '2019-08-10 17:36:11', 'INF235', '', '-1474683834', 'VALIDE', 'ACTIVE', 3114, 1, 1314, 1),
(3442, '2019-08-10 17:36:11', '2019-08-10 17:36:11', 'INF233', '', '-702654443', 'VALIDE', 'ACTIVE', 3114, 1, 1313, 1),
(3441, '2019-08-10 17:36:11', '2019-08-10 17:36:11', 'MAT231', '', '-305055301', 'VALIDE', 'ACTIVE', 3114, 1, 1312, 1),
(3440, '2019-08-10 17:36:11', '2019-08-10 17:36:11', 'MAT241', '', '-1001216380', 'VALIDE', 'ACTIVE', 3114, 1, 1320, 1),
(3439, '2019-08-10 17:36:11', '2019-08-10 17:36:11', 'INF232', '', '1858253607', 'VALIDE', 'ACTIVE', 3114, 1, 1311, 1),
(3438, '2019-08-10 17:36:10', '2019-08-10 17:36:10', 'INF231', '', '-1062987047', 'VALIDE', 'ACTIVE', 3114, 1, 1310, 1),
(3437, '2019-08-10 17:36:10', '2019-08-10 17:36:10', 'IN245', '', '-1750802064', 'VALIDE', 'ACTIVE', 3114, 1, 1351, 1),
(3436, '2019-08-10 17:36:10', '2019-08-10 17:36:10', 'INF243', '', '955575842', 'VALIDE', 'ACTIVE', 3114, 1, 1324, 1),
(3435, '2019-08-10 17:36:10', '2019-08-10 17:36:10', 'INF244', '', '68980950', 'VALIDE', 'ACTIVE', 3114, 1, 1323, 1),
(3434, '2019-08-10 17:36:10', '2019-08-10 17:36:10', 'ENV241', '', '589887440', 'VALIDE', 'ACTIVE', 3114, 1, 1322, 1),
(3433, '2019-08-10 17:36:09', '2019-08-10 17:36:09', 'STG241', '', '298713960', 'VALIDE', 'ACTIVE', 3114, 1, 1354, 1),
(3432, '2019-08-10 17:36:09', '2019-08-10 17:36:09', 'ETH241', '', '1647805101', 'VALIDE', 'ACTIVE', 3114, 1, 1318, 1),
(3431, '2019-08-10 17:36:09', '2019-08-10 17:36:09', 'ANG241', '', '929536818', 'VALIDE', 'ACTIVE', 3114, 1, 1352, 1),
(3430, '2019-08-10 17:36:09', '2019-08-10 17:36:09', 'INF242', '', '-910751709', 'VALIDE', 'ACTIVE', 3114, 1, 1321, 1),
(3429, '2019-08-10 17:36:09', '2019-08-10 17:36:09', 'INF241', '', '1824021848', 'VALIDE', 'ACTIVE', 3114, 1, 1319, 1),
(3428, '2019-08-10 17:36:08', '2019-08-10 17:36:08', 'ETH231', '', '947093841', 'VALIDE', 'ACTIVE', 3116, 1, 1353, 1),
(3427, '2019-08-10 17:36:08', '2019-08-10 17:36:08', 'ANG231', '', '1901433594', 'VALIDE', 'ACTIVE', 3116, 1, 1317, 1),
(3426, '2019-08-10 17:36:08', '2019-08-10 17:36:08', 'INF234', '', '-603830308', 'VALIDE', 'ACTIVE', 3116, 1, 1316, 1),
(3425, '2019-08-10 17:36:08', '2019-08-10 17:36:08', 'INF236', '', '-564162467', 'VALIDE', 'ACTIVE', 3116, 1, 1315, 1),
(3424, '2019-08-10 17:36:08', '2019-08-10 17:36:08', 'INF235', '', '-1467664227', 'VALIDE', 'ACTIVE', 3116, 1, 1314, 1),
(3423, '2019-08-10 17:36:07', '2019-08-10 17:36:07', 'INF233', '', '-692861390', 'VALIDE', 'ACTIVE', 3116, 1, 1313, 1),
(3422, '2019-08-10 17:36:07', '2019-08-10 17:36:07', 'MAT231', '', '-260843072', 'VALIDE', 'ACTIVE', 3116, 1, 1312, 1),
(3421, '2019-08-10 17:36:07', '2019-08-10 17:36:07', 'MAT241', '', '-960453180', 'VALIDE', 'ACTIVE', 3116, 1, 1320, 1),
(3420, '2019-08-10 17:36:07', '2019-08-10 17:36:07', 'INF232', '', '1900083517', 'VALIDE', 'ACTIVE', 3116, 1, 1311, 1),
(3419, '2019-08-10 17:36:07', '2019-08-10 17:36:07', 'INF231', '', '-1046473721', 'VALIDE', 'ACTIVE', 3116, 1, 1310, 1),
(3418, '2019-08-10 17:36:06', '2019-08-10 17:36:06', 'IN245', '', '-1707976558', 'VALIDE', 'ACTIVE', 3116, 1, 1351, 1),
(3417, '2019-08-10 17:36:06', '2019-08-10 17:36:06', 'INF243', '', '986596424', 'VALIDE', 'ACTIVE', 3116, 1, 1324, 1),
(3416, '2019-08-10 17:36:06', '2019-08-10 17:36:06', 'INF244', '', '99965975', 'VALIDE', 'ACTIVE', 3116, 1, 1323, 1),
(3415, '2019-08-10 17:36:06', '2019-08-10 17:36:06', 'ENV241', '', '641637753', 'VALIDE', 'ACTIVE', 3116, 1, 1322, 1),
(3414, '2019-08-10 17:36:06', '2019-08-10 17:36:06', 'STG241', '', '312809410', 'VALIDE', 'ACTIVE', 3116, 1, 1354, 1),
(3413, '2019-08-10 17:36:05', '2019-08-10 17:36:05', 'ETH241', '', '1689777239', 'VALIDE', 'ACTIVE', 3116, 1, 1318, 1),
(3412, '2019-08-10 17:36:05', '2019-08-10 17:36:05', 'ANG241', '', '960166273', 'VALIDE', 'ACTIVE', 3116, 1, 1352, 1),
(3411, '2019-08-10 17:36:05', '2019-08-10 17:36:05', 'INF242', '', '-897687412', 'VALIDE', 'ACTIVE', 3116, 1, 1321, 1),
(3410, '2019-08-10 17:36:05', '2019-08-10 17:36:05', 'INF241', '', '1862047159', 'VALIDE', 'ACTIVE', 3116, 1, 1319, 1),
(3409, '2019-08-10 17:36:05', '2019-08-10 17:36:05', 'ETH231', '', '-659759245', 'VALIDE', 'ACTIVE', 3115, 1, 1318, 1),
(3408, '2019-08-10 17:36:04', '2019-08-10 17:36:04', 'ANG231', '', '-558201777', 'VALIDE', 'ACTIVE', 3115, 1, 1317, 1),
(3407, '2019-08-10 17:36:04', '2019-08-10 17:36:04', 'INF234', '', '1247288925', 'VALIDE', 'ACTIVE', 3115, 1, 1316, 1),
(3406, '2019-08-10 17:36:04', '2019-08-10 17:36:04', 'INF236', '', '1278067516', 'VALIDE', 'ACTIVE', 3115, 1, 1315, 1),
(3405, '2019-08-10 17:36:04', '2019-08-10 17:36:04', 'INF235', '', '377765886', 'VALIDE', 'ACTIVE', 3115, 1, 1314, 1),
(3404, '2019-08-10 17:36:03', '2019-08-10 17:36:03', 'INF233', '', '1137919239', 'VALIDE', 'ACTIVE', 3115, 1, 1313, 1),
(3403, '2019-08-10 17:36:03', '2019-08-10 17:36:03', 'MAT231', '', '1563750639', 'VALIDE', 'ACTIVE', 3115, 1, 1312, 1),
(3402, '2019-08-10 17:36:03', '2019-08-10 17:36:03', 'MAT241', '', '855002382', 'VALIDE', 'ACTIVE', 3115, 1, 1320, 1),
(3401, '2019-08-10 17:36:03', '2019-08-10 17:36:03', 'INF232', '', '-569970055', 'VALIDE', 'ACTIVE', 3115, 1, 1311, 1),
(3400, '2019-08-10 17:36:02', '2019-08-10 17:36:02', 'INF231', '', '768306258', 'VALIDE', 'ACTIVE', 3115, 1, 1310, 1),
(3399, '2019-08-10 17:36:02', '2019-08-10 17:36:02', 'IN245', '', '116368254', 'VALIDE', 'ACTIVE', 3115, 1, 1351, 1),
(3398, '2019-08-10 17:36:02', '2019-08-10 17:36:02', 'INF243', '', '-1509129302', 'VALIDE', 'ACTIVE', 3115, 1, 1324, 1),
(3397, '2019-08-10 17:36:02', '2019-08-10 17:36:02', 'INF244', '', '1925021927', 'VALIDE', 'ACTIVE', 3115, 1, 1323, 1),
(3396, '2019-08-10 17:36:02', '2019-08-10 17:36:02', 'ENV241', '', '-1839438489', 'VALIDE', 'ACTIVE', 3115, 1, 1322, 1),
(3395, '2019-08-10 17:36:01', '2019-08-10 17:36:01', 'STG241', '', '2135340815', 'VALIDE', 'ACTIVE', 3115, 1, 1354, 1),
(3394, '2019-08-10 17:36:01', '2019-08-10 17:36:01', 'ETH241', '', '-794036892', 'VALIDE', 'ACTIVE', 3115, 1, 1318, 1),
(3393, '2019-08-10 17:36:01', '2019-08-10 17:36:01', 'ANG241', '', '-1511771820', 'VALIDE', 'ACTIVE', 3115, 1, 1352, 1),
(3392, '2019-08-10 17:36:01', '2019-08-10 17:36:01', 'INF242', '', '925946260', 'VALIDE', 'ACTIVE', 3115, 1, 1321, 1),
(3391, '2019-08-10 17:36:01', '2019-08-10 17:36:01', 'INF241', '', '-602495078', 'VALIDE', 'ACTIVE', 3115, 1, 1319, 1),
(3390, '2019-08-10 17:36:00', '2019-08-10 17:36:00', 'ETH231', '', '581102521', 'VALIDE', 'ACTIVE', 3113, 1, 1318, 1),
(3389, '2019-08-10 17:36:00', '2019-08-10 17:36:00', 'ANG231', '', '724261679', 'VALIDE', 'ACTIVE', 3113, 1, 1317, 1),
(3388, '2019-08-10 17:36:00', '2019-08-10 17:36:00', 'INF234', '', '-1804718742', 'VALIDE', 'ACTIVE', 3113, 1, 1316, 1),
(3387, '2019-08-10 17:36:00', '2019-08-10 17:36:00', 'INF236', '', '-1767113207', 'VALIDE', 'ACTIVE', 3113, 1, 1315, 1),
(3386, '2019-08-10 17:35:59', '2019-08-10 17:35:59', 'INF235', '', '1630112563', 'VALIDE', 'ACTIVE', 3113, 1, 1314, 1),
(3385, '2019-08-10 17:35:59', '2019-08-10 17:35:59', 'INF233', '', '-1917004102', 'VALIDE', 'ACTIVE', 3113, 1, 1313, 1),
(3384, '2019-08-10 17:35:59', '2019-08-10 17:35:59', 'MAT231', '', '-1491314930', 'VALIDE', 'ACTIVE', 3113, 1, 1312, 1),
(3383, '2019-08-10 17:35:59', '2019-08-10 17:35:59', 'MAT241', '', '2129429956', 'VALIDE', 'ACTIVE', 3113, 1, 1320, 1),
(3382, '2019-08-10 17:35:58', '2019-08-10 17:35:58', 'INF232', '', '666198187', 'VALIDE', 'ACTIVE', 3113, 1, 1311, 1),
(3381, '2019-08-10 17:35:58', '2019-08-10 17:35:58', 'INF231', '', '2050556372', 'VALIDE', 'ACTIVE', 3113, 1, 1310, 1),
(3380, '2019-08-10 17:35:58', '2019-08-10 17:35:58', 'IN245', '', '1352500939', 'VALIDE', 'ACTIVE', 3113, 1, 1351, 1),
(3379, '2019-08-10 17:35:58', '2019-08-10 17:35:58', 'INF243', '', '-244871030', 'VALIDE', 'ACTIVE', 3113, 1, 1324, 1),
(3378, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'INF244', '', '-1094913326', 'VALIDE', 'ACTIVE', 3113, 1, 1323, 1),
(3377, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'ENV241', '', '-600319016', 'VALIDE', 'ACTIVE', 3113, 1, 1322, 1),
(3376, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'STG241', '', '-883243272', 'VALIDE', 'ACTIVE', 3113, 1, 1354, 1),
(3375, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'ETH241', '', '455322997', 'VALIDE', 'ACTIVE', 3113, 1, 1318, 1),
(3374, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'ANG241', '', '-271265624', 'VALIDE', 'ACTIVE', 3113, 1, 1352, 1),
(3373, '2019-08-10 17:35:57', '2019-08-10 17:35:57', 'INF242', '', '-2092957840', 'VALIDE', 'ACTIVE', 3113, 1, 1321, 1),
(3372, '2019-08-10 17:35:56', '2019-08-10 17:35:56', 'INF241', '', '641886831', 'VALIDE', 'ACTIVE', 3113, 1, 1319, 1),
(3371, '2019-08-10 17:35:56', '2019-08-10 17:35:56', 'ETH231', '', '-123791796', 'VALIDE', 'ACTIVE', 3112, 1, 1353, 1),
(3370, '2019-08-10 17:35:56', '2019-08-10 17:35:56', 'ANG231', '', '866638312', 'VALIDE', 'ACTIVE', 3112, 1, 1317, 1),
(3369, '2019-08-10 17:35:56', '2019-08-10 17:35:56', 'INF234', '', '-1656439647', 'VALIDE', 'ACTIVE', 3112, 1, 1316, 1),
(3368, '2019-08-10 17:35:56', '2019-08-10 17:35:56', 'INF236', '', '-1616558464', 'VALIDE', 'ACTIVE', 3112, 1, 1315, 1),
(3367, '2019-08-10 17:35:55', '2019-08-10 17:35:55', 'INF235', '', '1794498979', 'VALIDE', 'ACTIVE', 3112, 1, 1314, 1),
(3366, '2019-08-10 17:35:55', '2019-08-10 17:35:55', 'INF233', '', '-1751906546', 'VALIDE', 'ACTIVE', 3112, 1, 1313, 1),
(3365, '2019-08-10 17:35:55', '2019-08-10 17:35:55', 'MAT231', '', '-1318608176', 'VALIDE', 'ACTIVE', 3112, 1, 1312, 1),
(3364, '2019-08-10 17:35:55', '2019-08-10 17:35:55', 'MAT241', '', '-2026325280', 'VALIDE', 'ACTIVE', 3112, 1, 1320, 1),
(3363, '2019-08-10 17:35:55', '2019-08-10 17:35:55', 'INF232', '', '848540888', 'VALIDE', 'ACTIVE', 3112, 1, 1311, 1),
(3362, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'INF231', '', '-2106372245', 'VALIDE', 'ACTIVE', 3112, 1, 1310, 1),
(3361, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'IN245', '', '1515073948', 'VALIDE', 'ACTIVE', 3112, 1, 1351, 1),
(3360, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'INF243', '', '-78137852', 'VALIDE', 'ACTIVE', 3112, 1, 1324, 1),
(3359, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'INF244', '', '-923451067', 'VALIDE', 'ACTIVE', 3112, 1, 1323, 1),
(3358, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'ENV241', '', '-404357984', 'VALIDE', 'ACTIVE', 3112, 1, 1322, 1),
(3357, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'STG241', '', '-727923891', 'VALIDE', 'ACTIVE', 3112, 1, 1354, 1),
(3356, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'ETH241', '', '643034805', 'VALIDE', 'ACTIVE', 3112, 1, 1318, 1),
(3355, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'ANG241', '', '-86433933', 'VALIDE', 'ACTIVE', 3112, 1, 1352, 1),
(3354, '2019-08-10 17:35:54', '2019-08-10 17:35:54', 'INF242', '', '-1909335087', 'VALIDE', 'ACTIVE', 3112, 1, 1321, 1),
(3353, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'INF241', '', '851181738', 'VALIDE', 'ACTIVE', 3112, 1, 1319, 1),
(3352, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'ETH231', '', '-1160007147', 'VALIDE', 'ACTIVE', 3111, 1, 1353, 1),
(3351, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'ANG231', '', '-160901131', 'VALIDE', 'ACTIVE', 3111, 1, 1317, 1),
(3350, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'INF234', '', '1627557768', 'VALIDE', 'ACTIVE', 3111, 1, 1316, 1),
(3349, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'INF236', '', '1637926641', 'VALIDE', 'ACTIVE', 3111, 1, 1315, 1),
(3348, '2019-08-10 17:35:53', '2019-08-10 17:35:53', 'INF235', '', '750745544', 'VALIDE', 'ACTIVE', 3111, 1, 1314, 1),
(3347, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'INF233', '', '1540588992', 'VALIDE', 'ACTIVE', 3111, 1, 1313, 1),
(3346, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'MAT231', '', '1962580236', 'VALIDE', 'ACTIVE', 3111, 1, 1312, 1),
(3345, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'MAT241', '', '1259165529', 'VALIDE', 'ACTIVE', 3111, 1, 1320, 1),
(3344, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'INF232', '', '-179211897', 'VALIDE', 'ACTIVE', 3111, 1, 1311, 1),
(3343, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'INF231', '', '1202728412', 'VALIDE', 'ACTIVE', 3111, 1, 1310, 1),
(3342, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'IN245', '', '530060677', 'VALIDE', 'ACTIVE', 3111, 1, 1351, 1),
(3341, '2019-08-10 17:35:52', '2019-08-10 17:35:52', 'INF243', '', '-1089356632', 'VALIDE', 'ACTIVE', 3111, 1, 1324, 1),
(3340, '2019-08-10 17:35:51', '2019-08-10 17:35:51', 'INF244', '', '-1940287853', 'VALIDE', 'ACTIVE', 3111, 1, 1323, 1),
(3339, '2019-08-10 17:35:51', '2019-08-10 17:35:51', 'ENV241', '', '-1442031172', 'VALIDE', 'ACTIVE', 3111, 1, 1322, 1),
(3338, '2019-08-10 17:35:51', '2019-08-10 17:35:51', 'STG241', '', '-1734769160', 'VALIDE', 'ACTIVE', 3111, 1, 1354, 1),
(3337, '2019-08-10 17:35:51', '2019-08-10 17:35:51', 'ETH241', '', '-367828405', 'VALIDE', 'ACTIVE', 3111, 1, 1318, 1),
(3336, '2019-08-10 17:35:50', '2019-08-10 17:35:50', 'ANG241', '', '-1105013012', 'VALIDE', 'ACTIVE', 3111, 1, 1352, 1),
(3335, '2019-08-10 17:35:50', '2019-08-10 17:35:50', 'INF242', '', '1322144639', 'VALIDE', 'ACTIVE', 3111, 1, 1321, 1),
(3334, '2019-08-10 17:35:50', '2019-08-10 17:35:50', 'INF241', '', '-211488021', 'VALIDE', 'ACTIVE', 3111, 1, 1319, 1),
(3333, '2019-08-10 17:35:50', '2019-08-10 17:35:50', 'ETH231', '', '-1662836896', 'VALIDE', 'ACTIVE', 3110, 1, 1353, 1),
(3332, '2019-08-10 17:35:50', '2019-08-10 17:35:50', 'ANG231', '', '-708283801', 'VALIDE', 'ACTIVE', 3110, 1, 1317, 1),
(3331, '2019-08-10 17:35:49', '2019-08-10 17:35:49', 'INF234', '', '1095180152', 'VALIDE', 'ACTIVE', 3110, 1, 1316, 1),
(3330, '2019-08-10 17:35:49', '2019-08-10 17:35:49', 'INF236', '', '1101388856', 'VALIDE', 'ACTIVE', 3110, 1, 1315, 1),
(3329, '2019-08-10 17:35:49', '2019-08-10 17:35:49', 'INF235', '', '227790533', 'VALIDE', 'ACTIVE', 3110, 1, 1314, 1),
(3328, '2019-08-10 17:35:49', '2019-08-10 17:35:49', 'INF233', '', '974574454', 'VALIDE', 'ACTIVE', 3110, 1, 1313, 1),
(3327, '2019-08-10 17:35:49', '2019-08-10 17:35:49', 'MAT231', '', '1398912460', 'VALIDE', 'ACTIVE', 3110, 1, 1312, 1),
(3326, '2019-08-10 17:35:48', '2019-08-10 17:35:48', 'MAT241', '', '725650089', 'VALIDE', 'ACTIVE', 3110, 1, 1320, 1),
(3325, '2019-08-10 17:35:48', '2019-08-10 17:35:48', 'INF232', '', '-730150267', 'VALIDE', 'ACTIVE', 3110, 1, 1311, 1),
(3324, '2019-08-10 17:35:48', '2019-08-10 17:35:48', 'INF231', '', '634758239', 'VALIDE', 'ACTIVE', 3110, 1, 1310, 1),
(3323, '2019-08-10 17:35:48', '2019-08-10 17:35:48', 'IN245', '', '-25073419', 'VALIDE', 'ACTIVE', 3110, 1, 1351, 1),
(3322, '2019-08-10 17:35:48', '2019-08-10 17:35:48', 'INF243', '', '-1651033216', 'VALIDE', 'ACTIVE', 3110, 1, 1324, 1),
(3321, '2019-08-10 17:35:47', '2019-08-10 17:35:47', 'INF244', '', '1801109855', 'VALIDE', 'ACTIVE', 3110, 1, 1323, 1),
(3320, '2019-08-10 17:35:47', '2019-08-10 17:35:47', 'ENV241', '', '-1998089750', 'VALIDE', 'ACTIVE', 3110, 1, 1322, 1),
(3319, '2019-08-10 17:35:47', '2019-08-10 17:35:47', 'STG241', '', '2005632952', 'VALIDE', 'ACTIVE', 3110, 1, 1354, 1),
(3318, '2019-08-10 17:35:47', '2019-08-10 17:35:47', 'ETH241', '', '-923815869', 'VALIDE', 'ACTIVE', 3110, 1, 1318, 1),
(3317, '2019-08-10 17:35:47', '2019-08-10 17:35:47', 'ANG241', '', '-1676681113', 'VALIDE', 'ACTIVE', 3110, 1, 1352, 1),
(3316, '2019-08-10 17:35:46', '2019-08-10 17:35:46', 'INF242', '', '796025055', 'VALIDE', 'ACTIVE', 3110, 1, 1321, 1),
(3315, '2019-08-10 17:35:46', '2019-08-10 17:35:46', 'INF241', '', '-736291996', 'VALIDE', 'ACTIVE', 3110, 1, 1319, 1),
(3314, '2019-08-10 17:35:46', '2019-08-10 17:35:46', 'ETH231', '', '-1618458985', 'VALIDE', 'ACTIVE', 3109, 1, 1353, 1),
(3313, '2019-08-10 17:35:46', '2019-08-10 17:35:46', 'ANG231', '', '-626677711', 'VALIDE', 'ACTIVE', 3109, 1, 1317, 1),
(3312, '2019-08-10 17:35:46', '2019-08-10 17:35:46', 'INF234', '', '1144820499', 'VALIDE', 'ACTIVE', 3109, 1, 1316, 1),
(3311, '2019-08-10 17:35:45', '2019-08-10 17:35:45', 'INF236', '', '1173999025', 'VALIDE', 'ACTIVE', 3109, 1, 1315, 1),
(3310, '2019-08-10 17:35:45', '2019-08-10 17:35:45', 'INF235', '', '299405106', 'VALIDE', 'ACTIVE', 3109, 1, 1314, 1),
(3309, '2019-08-10 17:35:45', '2019-08-10 17:35:45', 'INF233', '', '1054864935', 'VALIDE', 'ACTIVE', 3109, 1, 1313, 1),
(3308, '2019-08-10 17:35:45', '2019-08-10 17:35:45', 'MAT231', '', '1490118940', 'VALIDE', 'ACTIVE', 3109, 1, 1312, 1),
(3307, '2019-08-10 17:35:45', '2019-08-10 17:35:45', 'MAT241', '', '781370683', 'VALIDE', 'ACTIVE', 3109, 1, 1320, 1),
(3306, '2019-08-10 17:35:44', '2019-08-10 17:35:44', 'INF232', '', '-656757844', 'VALIDE', 'ACTIVE', 3109, 1, 1311, 1),
(3305, '2019-08-10 17:35:44', '2019-08-10 17:35:44', 'INF231', '', '717395482', 'VALIDE', 'ACTIVE', 3109, 1, 1310, 1),
(3304, '2019-08-10 17:35:44', '2019-08-10 17:35:44', 'IN245', '', '29580465', 'VALIDE', 'ACTIVE', 3109, 1, 1351, 1),
(3303, '2019-08-10 17:35:44', '2019-08-10 17:35:44', 'INF243', '', '-1561106788', 'VALIDE', 'ACTIVE', 3109, 1, 1324, 1),
(3302, '2019-08-10 17:35:44', '2019-08-10 17:35:44', 'INF244', '', '1873791138', 'VALIDE', 'ACTIVE', 3109, 1, 1323, 1),
(3301, '2019-08-10 17:35:43', '2019-08-10 17:35:43', 'ENV241', '', '-1924768441', 'VALIDE', 'ACTIVE', 3109, 1, 1322, 1),
(3300, '2019-08-10 17:35:43', '2019-08-10 17:35:43', 'STG241', '', '2086527902', 'VALIDE', 'ACTIVE', 3109, 1, 1354, 1),
(3299, '2019-08-10 17:35:43', '2019-08-10 17:35:43', 'ETH241', '', '-869268656', 'VALIDE', 'ACTIVE', 3109, 1, 1318, 1),
(3298, '2019-08-10 17:35:43', '2019-08-10 17:35:43', 'ANG241', '', '-1595999505', 'VALIDE', 'ACTIVE', 3109, 1, 1352, 1),
(3297, '2019-08-10 17:35:43', '2019-08-10 17:35:43', 'INF242', '', '869417478', 'VALIDE', 'ACTIVE', 3109, 1, 1321, 1),
(3296, '2019-08-10 17:35:42', '2019-08-10 17:35:42', 'INF241', '', '-681851454', 'VALIDE', 'ACTIVE', 3109, 1, 1319, 1),
(3295, '2019-08-10 17:35:42', '2019-08-10 17:35:42', 'ETH231', '', '1818628261', 'VALIDE', 'ACTIVE', 3108, 1, 1353, 1),
(3294, '2019-08-10 17:35:42', '2019-08-10 17:35:42', 'ANG231', '', '-1520861458', 'VALIDE', 'ACTIVE', 3108, 1, 1317, 1),
(3293, '2019-08-10 17:35:42', '2019-08-10 17:35:42', 'INF234', '', '268486366', 'VALIDE', 'ACTIVE', 3108, 1, 1316, 1),
(3292, '2019-08-10 17:35:42', '2019-08-10 17:35:42', 'INF236', '', '308296435', 'VALIDE', 'ACTIVE', 3108, 1, 1315, 1),
(3291, '2019-08-10 17:35:41', '2019-08-10 17:35:41', 'INF235', '', '-592680778', 'VALIDE', 'ACTIVE', 3108, 1, 1314, 1),
(3290, '2019-08-10 17:35:41', '2019-08-10 17:35:41', 'INF233', '', '190406840', 'VALIDE', 'ACTIVE', 3108, 1, 1313, 1),
(3289, '2019-08-10 17:35:41', '2019-08-10 17:35:41', 'MAT231', '', '616024898', 'VALIDE', 'ACTIVE', 3108, 1, 1312, 1),
(3288, '2019-08-10 17:35:41', '2019-08-10 17:35:41', 'MAT241', '', '-94145639', 'VALIDE', 'ACTIVE', 3108, 1, 1320, 1),
(3287, '2019-08-10 17:35:41', '2019-08-10 17:35:41', 'INF232', '', '-1520967040', 'VALIDE', 'ACTIVE', 3108, 1, 1311, 1),
(3286, '2019-08-10 17:35:40', '2019-08-10 17:35:40', 'INF231', '', '-174334832', 'VALIDE', 'ACTIVE', 3108, 1, 1310, 1),
(3285, '2019-08-10 17:35:40', '2019-08-10 17:35:40', 'IN245', '', '-835553213', 'VALIDE', 'ACTIVE', 3108, 1, 1351, 1),
(3284, '2019-08-10 17:35:40', '2019-08-10 17:35:40', 'INF243', '', '1861828772', 'VALIDE', 'ACTIVE', 3108, 1, 1324, 1),
(3283, '2019-08-10 17:35:40', '2019-08-10 17:35:40', 'INF244', '', '974309398', 'VALIDE', 'ACTIVE', 3108, 1, 1323, 1),
(3282, '2019-08-10 17:35:40', '2019-08-10 17:35:40', 'ENV241', '', '1514309997', 'VALIDE', 'ACTIVE', 3108, 1, 1322, 1),
(3281, '2019-08-10 17:35:39', '2019-08-10 17:35:39', 'STG241', '', '1185126084', 'VALIDE', 'ACTIVE', 3108, 1, 1354, 1),
(3280, '2019-08-10 17:35:39', '2019-08-10 17:35:39', 'ETH241', '', '-1742438216', 'VALIDE', 'ACTIVE', 3108, 1, 1318, 1),
(3279, '2019-08-10 17:35:39', '2019-08-10 17:35:39', 'ANG241', '', '1836607559', 'VALIDE', 'ACTIVE', 3108, 1, 1352, 1),
(3278, '2019-08-10 17:35:39', '2019-08-10 17:35:39', 'INF242', '', '-26615233', 'VALIDE', 'ACTIVE', 3108, 1, 1321, 1),
(3277, '2019-08-10 17:35:39', '2019-08-10 17:35:39', 'INF241', '', '-1548656311', 'VALIDE', 'ACTIVE', 3108, 1, 1319, 1),
(3276, '2019-08-10 17:35:38', '2019-08-10 17:35:38', 'ETH231', '', '-399153993', 'VALIDE', 'ACTIVE', 3107, 1, 1353, 1),
(3275, '2019-08-10 17:35:38', '2019-08-10 17:35:38', 'ANG231', '', '599845352', 'VALIDE', 'ACTIVE', 3107, 1, 1317, 1),
(3274, '2019-08-10 17:35:38', '2019-08-10 17:35:38', 'INF234', '', '-1907765312', 'VALIDE', 'ACTIVE', 3107, 1, 1316, 1),
(3273, '2019-08-10 17:35:38', '2019-08-10 17:35:38', 'INF236', '', '-1904934523', 'VALIDE', 'ACTIVE', 3107, 1, 1315, 1),
(3272, '2019-08-10 17:35:38', '2019-08-10 17:35:38', 'INF235', '', '1525821498', 'VALIDE', 'ACTIVE', 3107, 1, 1314, 1),
(3271, '2019-08-10 17:35:37', '2019-08-10 17:35:37', 'INF233', '', '-2024104170', 'VALIDE', 'ACTIVE', 3107, 1, 1313, 1),
(3270, '2019-08-10 17:35:37', '2019-08-10 17:35:37', 'MAT231', '', '-1598912796', 'VALIDE', 'ACTIVE', 3107, 1, 1312, 1),
(3269, '2019-08-10 17:35:37', '2019-08-10 17:35:37', 'MAT241', '', '2030187985', 'VALIDE', 'ACTIVE', 3107, 1, 1320, 1),
(3268, '2019-08-10 17:35:37', '2019-08-10 17:35:37', 'INF232', '', '565747278', 'VALIDE', 'ACTIVE', 3107, 1, 1311, 1),
(3267, '2019-08-10 17:35:37', '2019-08-10 17:35:37', 'INF231', '', '1945483053', 'VALIDE', 'ACTIVE', 3107, 1, 1310, 1),
(3266, '2019-08-10 17:35:36', '2019-08-10 17:35:36', 'IN245', '', '1249809939', 'VALIDE', 'ACTIVE', 3107, 1, 1351, 1),
(3265, '2019-08-10 17:35:36', '2019-08-10 17:35:36', 'INF243', '', '-340486187', 'VALIDE', 'ACTIVE', 3107, 1, 1324, 1),
(3264, '2019-08-10 17:35:36', '2019-08-10 17:35:36', 'INF244', '', '-1226085483', 'VALIDE', 'ACTIVE', 3107, 1, 1323, 1),
(3263, '2019-08-10 17:35:36', '2019-08-10 17:35:36', 'ENV241', '', '-693480740', 'VALIDE', 'ACTIVE', 3107, 1, 1322, 1),
(3262, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'STG241', '', '-996245802', 'VALIDE', 'ACTIVE', 3107, 1, 1354, 1),
(3261, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'ETH241', '', '351031932', 'VALIDE', 'ACTIVE', 3107, 1, 1318, 1),
(3260, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'ANG241', '', '-366205198', 'VALIDE', 'ACTIVE', 3107, 1, 1352, 1),
(3259, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'INF242', '', '2087869102', 'VALIDE', 'ACTIVE', 3107, 1, 1321, 1),
(3258, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'INF241', '', '535995701', 'VALIDE', 'ACTIVE', 3107, 1, 1319, 1),
(3257, '2019-08-10 17:35:35', '2019-08-10 17:35:35', 'ETH231', '', '837765086', 'VALIDE', 'ACTIVE', 3106, 1, 1353, 1),
(3256, '2019-08-10 17:35:34', '2019-08-10 17:35:34', 'ANG231', '', '1818488133', 'VALIDE', 'ACTIVE', 3106, 1, 1317, 1),
(3255, '2019-08-10 17:35:34', '2019-08-10 17:35:34', 'INF234', '', '-714759128', 'VALIDE', 'ACTIVE', 3106, 1, 1316, 1),
(3254, '2019-08-10 17:35:34', '2019-08-10 17:35:34', 'INF236', '', '-666948734', 'VALIDE', 'ACTIVE', 3106, 1, 1315, 1),
(3253, '2019-08-10 17:35:34', '2019-08-10 17:35:34', 'INF235', '', '-1550467460', 'VALIDE', 'ACTIVE', 3106, 1, 1314, 1),
(3252, '2019-08-10 17:35:34', '2019-08-10 17:35:34', 'INF233', '', '-803434640', 'VALIDE', 'ACTIVE', 3106, 1, 1313, 1),
(3251, '2019-08-10 17:35:33', '2019-08-10 17:35:34', 'MAT231', '', '-369105117', 'VALIDE', 'ACTIVE', 3106, 1, 1312, 1),
(3243, '2019-08-10 17:35:32', '2019-08-10 17:35:32', 'MAT241', '', '-1106874613', 'VALIDE', 'ACTIVE', 3106, 1, 1320, 1),
(3242, '2019-08-10 17:35:32', '2019-08-10 17:35:32', 'INF232', '', '1750070827', 'VALIDE', 'ACTIVE', 3106, 1, 1311, 1),
(3241, '2019-08-10 17:35:32', '2019-08-10 17:35:32', 'INF231', '', '-1169214192', 'VALIDE', 'ACTIVE', 3106, 1, 1310, 1),
(3240, '2019-08-10 17:35:32', '2019-08-10 17:35:32', 'IN245', '', '-1866522928', 'VALIDE', 'ACTIVE', 3106, 1, 1351, 1),
(3239, '2019-08-10 17:35:31', '2019-08-10 17:35:31', 'INF243', '', '849526482', 'VALIDE', 'ACTIVE', 3106, 1, 1324, 1),
(3238, '2019-08-10 17:35:31', '2019-08-10 17:35:31', 'INF244', '', '-38490690', 'VALIDE', 'ACTIVE', 3106, 1, 1323, 1),
(3237, '2019-08-10 17:35:31', '2019-08-10 17:35:31', 'ENV241', '', '483304725', 'VALIDE', 'ACTIVE', 3106, 1, 1322, 1),
(3236, '2019-08-10 17:35:31', '2019-08-10 17:35:31', 'STG241', '', '192202359', 'VALIDE', 'ACTIVE', 3106, 1, 1354, 1),
(3235, '2019-08-10 17:35:31', '2019-08-10 17:35:31', 'ETH241', '', '1532866491', 'VALIDE', 'ACTIVE', 3106, 1, 1318, 1),
(3234, '2019-08-10 17:35:30', '2019-08-10 17:35:30', 'ANG241', '', '823594129', 'VALIDE', 'ACTIVE', 3106, 1, 1352, 1),
(3233, '2019-08-10 17:35:30', '2019-08-10 17:35:30', 'INF242', '', '-1041619855', 'VALIDE', 'ACTIVE', 3106, 1, 1321, 1),
(3232, '2019-08-10 17:35:30', '2019-08-10 17:35:30', 'INF241', '', '1720248136', 'VALIDE', 'ACTIVE', 3106, 1, 1319, 1),
(3231, '2019-08-10 17:35:30', '2019-08-10 17:35:30', 'ETH231', '', '685353488', 'VALIDE', 'ACTIVE', 3105, 1, 1353, 1),
(3230, '2019-08-10 17:35:30', '2019-08-10 17:35:30', 'ANG231', '', '1648369149', 'VALIDE', 'ACTIVE', 3105, 1, 1317, 1),
(3229, '2019-08-10 17:35:29', '2019-08-10 17:35:29', 'INF234', '', '-845552070', 'VALIDE', 'ACTIVE', 3105, 1, 1316, 1),
(3228, '2019-08-10 17:35:29', '2019-08-10 17:35:29', 'INF236', '', '-840694532', 'VALIDE', 'ACTIVE', 3105, 1, 1315, 1),
(3227, '2019-08-10 17:35:29', '2019-08-10 17:35:29', 'INF235', '', '-1713510601', 'VALIDE', 'ACTIVE', 3105, 1, 1314, 1),
(3226, '2019-08-10 17:35:29', '2019-08-10 17:35:29', 'INF233', '', '-965304400', 'VALIDE', 'ACTIVE', 3105, 1, 1313, 1),
(3225, '2019-08-10 17:35:29', '2019-08-10 17:35:29', 'MAT231', '', '-541997547', 'VALIDE', 'ACTIVE', 3105, 1, 1312, 1),
(3224, '2019-08-10 17:35:28', '2019-08-10 17:35:28', 'MAT241', '', '-1207721834', 'VALIDE', 'ACTIVE', 3105, 1, 1320, 1),
(3223, '2019-08-10 17:35:28', '2019-08-10 17:35:28', 'INF232', '', '1621666931', 'VALIDE', 'ACTIVE', 3105, 1, 1311, 1),
(3222, '2019-08-10 17:35:28', '2019-08-10 17:35:28', 'INF231', '', '-1293422362', 'VALIDE', 'ACTIVE', 3105, 1, 1310, 1),
(3221, '2019-08-10 17:35:28', '2019-08-10 17:35:28', 'IN245', '', '-1988633235', 'VALIDE', 'ACTIVE', 3105, 1, 1351, 1),
(3220, '2019-08-10 17:35:27', '2019-08-10 17:35:27', 'INF243', '', '717851342', 'VALIDE', 'ACTIVE', 3105, 1, 1324, 1),
(3219, '2019-08-10 17:35:27', '2019-08-10 17:35:27', 'INF244', '', '-169810260', 'VALIDE', 'ACTIVE', 3105, 1, 1323, 1),
(3218, '2019-08-10 17:35:27', '2019-08-10 17:35:27', 'ENV241', '', '351878484', 'VALIDE', 'ACTIVE', 3105, 1, 1322, 1),
(3217, '2019-08-10 17:35:27', '2019-08-10 17:35:27', 'STG241', '', '61273916', 'VALIDE', 'ACTIVE', 3105, 1, 1354, 1),
(3216, '2019-08-10 17:35:27', '2019-08-10 17:35:27', 'ETH241', '', '1408800549', 'VALIDE', 'ACTIVE', 3105, 1, 1318, 1),
(3215, '2019-08-10 17:35:26', '2019-08-10 17:35:26', 'ANG241', '', '691812318', 'VALIDE', 'ACTIVE', 3105, 1, 1352, 1),
(3214, '2019-08-10 17:35:26', '2019-08-10 17:35:26', 'INF242', '', '-1147409499', 'VALIDE', 'ACTIVE', 3105, 1, 1321, 1),
(3213, '2019-08-10 17:35:26', '2019-08-10 17:35:26', 'INF241', '', '1587008488', 'VALIDE', 'ACTIVE', 3105, 1, 1319, 1),
(3212, '2019-08-10 17:35:26', '2019-08-10 17:35:26', 'ETH231', '', '-2064646612', 'VALIDE', 'ACTIVE', 3104, 1, 1353, 1),
(3211, '2019-08-10 17:35:26', '2019-08-10 17:35:26', 'ANG231', '', '-1108173439', 'VALIDE', 'ACTIVE', 3104, 1, 1317, 1),
(3210, '2019-08-10 17:35:25', '2019-08-10 17:35:25', 'INF234', '', '699628468', 'VALIDE', 'ACTIVE', 3104, 1, 1316, 1),
(3209, '2019-08-10 17:35:25', '2019-08-10 17:35:25', 'INF236', '', '703063726', 'VALIDE', 'ACTIVE', 3104, 1, 1315, 1),
(3208, '2019-08-10 17:35:25', '2019-08-10 17:35:25', 'INF235', '', '-180597228', 'VALIDE', 'ACTIVE', 3104, 1, 1314, 1),
(3207, '2019-08-10 17:35:25', '2019-08-10 17:35:25', 'INF233', '', '602525947', 'VALIDE', 'ACTIVE', 3104, 1, 1313, 1),
(3206, '2019-08-10 17:35:25', '2019-08-10 17:35:25', 'MAT231', '', '1001689597', 'VALIDE', 'ACTIVE', 3104, 1, 1312, 1),
(3205, '2019-08-10 17:35:24', '2019-08-10 17:35:24', 'MAT241', '', '336712007', 'VALIDE', 'ACTIVE', 3104, 1, 1320, 1),
(3204, '2019-08-10 17:35:24', '2019-08-10 17:35:24', 'INF232', '', '-1128155384', 'VALIDE', 'ACTIVE', 3104, 1, 1311, 1),
(3203, '2019-08-10 17:35:24', '2019-08-10 17:35:24', 'INF231', '', '236788679', 'VALIDE', 'ACTIVE', 3104, 1, 1310, 1),
(3202, '2019-08-10 17:35:24', '2019-08-10 17:35:24', 'IN245', '', '-422687409', 'VALIDE', 'ACTIVE', 3104, 1, 1351, 1),
(3201, '2019-08-10 17:35:24', '2019-08-10 17:35:24', 'INF243', '', '-2039580171', 'VALIDE', 'ACTIVE', 3104, 1, 1324, 1),
(3200, '2019-08-10 17:35:23', '2019-08-10 17:35:23', 'INF244', '', '1406269311', 'VALIDE', 'ACTIVE', 3104, 1, 1323, 1),
(3199, '2019-08-10 17:35:23', '2019-08-10 17:35:23', 'ENV241', '', '1899832468', 'VALIDE', 'ACTIVE', 3104, 1, 1322, 1),
(3198, '2019-08-10 17:35:23', '2019-08-10 17:35:23', 'STG241', '', '1600018637', 'VALIDE', 'ACTIVE', 3104, 1, 1354, 1),
(3197, '2019-08-10 17:35:23', '2019-08-10 17:35:23', 'ETH241', '', '-1319829794', 'VALIDE', 'ACTIVE', 3104, 1, 1318, 1),
(3196, '2019-08-10 17:35:23', '2019-08-10 17:35:23', 'ANG241', '', '-2065156954', 'VALIDE', 'ACTIVE', 3104, 1, 1352, 1),
(3195, '2019-08-10 17:35:22', '2019-08-10 17:35:22', 'INF242', '', '401682309', 'VALIDE', 'ACTIVE', 3104, 1, 1321, 1),
(3194, '2019-08-10 17:35:22', '2019-08-10 17:35:22', 'INF241', '', '-1155560199', 'VALIDE', 'ACTIVE', 3104, 1, 1319, 1),
(3193, '2019-08-10 17:35:22', '2019-08-10 17:35:22', 'ETH231', '', '-197126017', 'VALIDE', 'ACTIVE', 3103, 1, 1353, 1),
(3192, '2019-08-10 17:35:22', '2019-08-10 17:35:22', 'ANG231', '', '758102661', 'VALIDE', 'ACTIVE', 3103, 1, 1317, 1),
(3191, '2019-08-10 17:35:21', '2019-08-10 17:35:21', 'INF234', '', '-1749187990', 'VALIDE', 'ACTIVE', 3103, 1, 1316, 1),
(3190, '2019-08-10 17:35:21', '2019-08-10 17:35:21', 'INF236', '', '-1700950912', 'VALIDE', 'ACTIVE', 3103, 1, 1315, 1),
(3189, '2019-08-10 17:35:21', '2019-08-10 17:35:21', 'INF235', '', '1684398820', 'VALIDE', 'ACTIVE', 3103, 1, 1314, 1),
(3188, '2019-08-10 17:35:21', '2019-08-10 17:35:21', 'INF233', '', '-1825276324', 'VALIDE', 'ACTIVE', 3103, 1, 1313, 1),
(3187, '2019-08-10 17:35:20', '2019-08-10 17:35:21', 'MAT231', '', '-1425294863', 'VALIDE', 'ACTIVE', 3103, 1, 1312, 1),
(3186, '2019-08-10 17:35:20', '2019-08-10 17:35:20', 'MAT241', '', '-2098735019', 'VALIDE', 'ACTIVE', 3103, 1, 1320, 1),
(3185, '2019-08-10 17:35:20', '2019-08-10 17:35:20', 'INF232', '', '733604977', 'VALIDE', 'ACTIVE', 3103, 1, 1311, 1),
(3184, '2019-08-10 17:35:20', '2019-08-10 17:35:20', 'INF231', '', '2112131814', 'VALIDE', 'ACTIVE', 3103, 1, 1310, 1),
(3183, '2019-08-10 17:35:20', '2019-08-10 17:35:20', 'IN245', '', '1414574179', 'VALIDE', 'ACTIVE', 3103, 1, 1351, 1),
(3182, '2019-08-10 17:35:19', '2019-08-10 17:35:19', 'INF243', '', '-184220070', 'VALIDE', 'ACTIVE', 3103, 1, 1324, 1),
(3181, '2019-08-10 17:35:19', '2019-08-10 17:35:19', 'INF244', '', '-1035471304', 'VALIDE', 'ACTIVE', 3103, 1, 1323, 1),
(3180, '2019-08-10 17:35:19', '2019-08-10 17:35:19', 'ENV241', '', '-530245451', 'VALIDE', 'ACTIVE', 3103, 1, 1322, 1),
(3179, '2019-08-10 17:35:19', '2019-08-10 17:35:19', 'STG241', '', '-822485641', 'VALIDE', 'ACTIVE', 3103, 1, 1354, 1),
(3178, '2019-08-10 17:35:19', '2019-08-10 17:35:19', 'ETH241', '', '518071820', 'VALIDE', 'ACTIVE', 3103, 1, 1318, 1),
(3177, '2019-08-10 17:35:18', '2019-08-10 17:35:18', 'ANG241', '', '-208090117', 'VALIDE', 'ACTIVE', 3103, 1, 1352, 1),
(3176, '2019-08-10 17:35:18', '2019-08-10 17:35:18', 'INF242', '', '-2036573720', 'VALIDE', 'ACTIVE', 3103, 1, 1321, 1),
(3175, '2019-08-10 17:35:18', '2019-08-10 17:35:18', 'INF241', '', '699373218', 'VALIDE', 'ACTIVE', 3103, 1, 1319, 1),
(3174, '2019-08-10 17:35:18', '2019-08-10 17:35:18', 'ETH231', '', '-664651529', 'VALIDE', 'ACTIVE', 3102, 1, 1353, 1),
(3173, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'ANG231', '', '293741722', 'VALIDE', 'ACTIVE', 3102, 1, 1317, 1),
(3172, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF234', '', '2092867721', 'VALIDE', 'ACTIVE', 3102, 1, 1316, 1),
(3171, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF236', '', '2105938926', 'VALIDE', 'ACTIVE', 3102, 1, 1315, 1),
(3170, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF235', '', '1217406663', 'VALIDE', 'ACTIVE', 3102, 1, 1314, 1),
(3169, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF233', '', '1994307363', 'VALIDE', 'ACTIVE', 3102, 1, 1313, 1),
(3168, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'MAT231', '', '-1862383583', 'VALIDE', 'ACTIVE', 3102, 1, 1312, 1),
(3167, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'MAT241', '', '1753774450', 'VALIDE', 'ACTIVE', 3102, 1, 1320, 1),
(3166, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF232', '', '312481350', 'VALIDE', 'ACTIVE', 3102, 1, 1311, 1),
(3165, '2019-08-10 17:35:17', '2019-08-10 17:35:17', 'INF231', '', '1683363432', 'VALIDE', 'ACTIVE', 3102, 1, 1310, 1),
(3164, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'IN245', '', '989574839', 'VALIDE', 'ACTIVE', 3102, 1, 1351, 1),
(3163, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'INF243', '', '-604276987', 'VALIDE', 'ACTIVE', 3102, 1, 1324, 1),
(3162, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'INF244', '', '-1467759829', 'VALIDE', 'ACTIVE', 3102, 1, 1323, 1),
(3161, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'ENV241', '', '-941910916', 'VALIDE', 'ACTIVE', 3102, 1, 1322, 1),
(3160, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'STG241', '', '-1228070859', 'VALIDE', 'ACTIVE', 3102, 1, 1354, 1),
(3159, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'ETH241', '', '133394118', 'VALIDE', 'ACTIVE', 3102, 1, 1318, 1),
(3158, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'ANG241', '', '-588856549', 'VALIDE', 'ACTIVE', 3102, 1, 1352, 1),
(3157, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'INF242', '', '1846052528', 'VALIDE', 'ACTIVE', 3102, 1, 1321, 1),
(3156, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'INF241', '', '316900050', 'VALIDE', 'ACTIVE', 3102, 1, 1319, 1),
(3155, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'ETH231', '', '-1016531429', 'VALIDE', 'ACTIVE', 3101, 1, 1318, 1),
(3154, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'ANG231', '', '-874545652', 'VALIDE', 'ACTIVE', 3101, 1, 1317, 1),
(3153, '2019-08-10 17:35:16', '2019-08-10 17:35:16', 'INF234', '', '912846537', 'VALIDE', 'ACTIVE', 3101, 1, 1316, 1),
(3152, '2019-08-10 17:35:15', '2019-08-10 17:35:15', 'INF236', '', '922077586', 'VALIDE', 'ACTIVE', 3101, 1, 1315, 1),
(3151, '2019-08-10 17:35:15', '2019-08-10 17:35:15', 'INF235', '', '36283212', 'VALIDE', 'ACTIVE', 3101, 1, 1314, 1),
(3114, '2019-08-10 17:35:15', '2019-08-10 17:35:15', 'INF233', '', '1960888557', 'VALIDE', 'ACTIVE', 3101, 1, 1313, 1),
(3113, '2019-08-10 17:35:15', '2019-08-10 17:35:15', 'MAT231', '', '-1911660811', 'VALIDE', 'ACTIVE', 3101, 1, 1312, 1),
(3112, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'MAT241', '', '1679073967', 'VALIDE', 'ACTIVE', 3101, 1, 1320, 1),
(3111, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'INF232', '', '238100880', 'VALIDE', 'ACTIVE', 3101, 1, 1311, 1),
(3110, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'INF231', '', '1621072342', 'VALIDE', 'ACTIVE', 3101, 1, 1310, 1),
(3109, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'IN245', '', '956618274', 'VALIDE', 'ACTIVE', 3101, 1, 1351, 1),
(3108, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'INF243', '', '-644558294', 'VALIDE', 'ACTIVE', 3101, 1, 1324, 1),
(3107, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'INF244', '', '-1525499623', 'VALIDE', 'ACTIVE', 3101, 1, 1323, 1),
(3106, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'ENV241', '', '-994601616', 'VALIDE', 'ACTIVE', 3101, 1, 1322, 1),
(3105, '2019-08-10 17:35:14', '2019-08-10 17:35:14', 'STG241', '', '-1299926782', 'VALIDE', 'ACTIVE', 3101, 1, 1354, 1),
(3104, '2019-08-10 17:35:13', '2019-08-10 17:35:13', 'ETH241', '', '46390913', 'VALIDE', 'ACTIVE', 3101, 1, 1318, 1),
(3103, '2019-08-10 17:35:13', '2019-08-10 17:35:13', 'ANG241', '', '-681619988', 'VALIDE', 'ACTIVE', 3101, 1, 1352, 1),
(3102, '2019-08-10 17:35:13', '2019-08-10 17:35:13', 'INF242', '', '1791086180', 'VALIDE', 'ACTIVE', 3101, 1, 1321, 1),
(3101, '2019-08-10 17:35:13', '2019-08-10 17:35:13', 'INF241', '', '256031240', 'VALIDE', 'ACTIVE', 3101, 1, 1319, 1),
(3580, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'INF241', '', '-49164687', 'VALIDE', 'ACTIVE', 3122, 1, 1319, 1),
(3581, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'INF242', '', '1486885849', 'VALIDE', 'ACTIVE', 3122, 1, 1321, 1),
(3582, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'ANG241', '', '-985749205', 'VALIDE', 'ACTIVE', 3122, 1, 1352, 1),
(3583, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'ETH241', '', '-256173796', 'VALIDE', 'ACTIVE', 3122, 1, 1318, 1),
(3584, '2019-08-10 17:36:32', '2019-08-10 17:36:32', 'STG241', '', '-1603913771', 'VALIDE', 'ACTIVE', 3122, 1, 1354, 1),
(3585, '2019-08-10 17:36:32', '2019-08-10 17:36:33', 'ENV241', '', '-1302179862', 'VALIDE', 'ACTIVE', 3122, 1, 1322, 1),
(3586, '2019-08-10 17:36:33', '2019-08-10 17:36:33', 'INF244', '', '-1832437843', 'VALIDE', 'ACTIVE', 3122, 1, 1323, 1),
(3587, '2019-08-10 17:36:33', '2019-08-10 17:36:33', 'INF243', '', '-947265231', 'VALIDE', 'ACTIVE', 3122, 1, 1324, 1),
(3588, '2019-08-10 17:36:33', '2019-08-10 17:36:33', 'IN245', '', '633323834', 'VALIDE', 'ACTIVE', 3122, 1, 1351, 1),
(3589, '2019-08-10 17:36:33', '2019-08-10 17:36:33', 'INF231', '', '1330312557', 'VALIDE', 'ACTIVE', 3122, 1, 1310, 1),
(3590, '2019-08-10 17:36:34', '2019-08-10 17:36:34', 'INF232', '', '-47609811', 'VALIDE', 'ACTIVE', 3122, 1, 1311, 1),
(3591, '2019-08-10 17:36:34', '2019-08-10 17:36:34', 'MAT241', '', '1416653111', 'VALIDE', 'ACTIVE', 3122, 1, 1320, 1),
(3592, '2019-08-10 17:36:34', '2019-08-10 17:36:34', 'MAT231', '', '2099906999', 'VALIDE', 'ACTIVE', 3122, 1, 1312, 1),
(3593, '2019-08-10 17:36:34', '2019-08-10 17:36:34', 'INF233', '', '1657968278', 'VALIDE', 'ACTIVE', 3122, 1, 1313, 1),
(3594, '2019-08-10 17:36:34', '2019-08-10 17:36:34', 'INF235', '', '912962207', 'VALIDE', 'ACTIVE', 3122, 1, 1314, 1),
(3595, '2019-08-10 17:36:35', '2019-08-10 17:36:35', 'INF236', '', '1795556451', 'VALIDE', 'ACTIVE', 3122, 1, 1315, 1),
(3596, '2019-08-10 17:36:35', '2019-08-10 17:36:35', 'INF234', '', '1778111735', 'VALIDE', 'ACTIVE', 3122, 1, 1316, 1),
(3597, '2019-08-10 17:36:35', '2019-08-10 17:36:35', 'ANG231', '', '-9387125', 'VALIDE', 'ACTIVE', 3122, 1, 1317, 1),
(3598, '2019-08-10 17:36:35', '2019-08-10 17:36:35', 'ETH231', '', '-1000706158', 'VALIDE', 'ACTIVE', 3122, 1, 1353, 1),
(3599, '2019-08-10 17:36:35', '2019-08-10 17:36:35', 'INF241', '', '-509342713', 'VALIDE', 'ACTIVE', 3123, 1, 1319, 1),
(3600, '2019-08-10 17:36:36', '2019-08-10 17:36:36', 'INF242', '', '1014227316', 'VALIDE', 'ACTIVE', 3123, 1, 1321, 1),
(3601, '2019-08-10 17:36:36', '2019-08-10 17:36:36', 'ANG241', '', '-1443189342', 'VALIDE', 'ACTIVE', 3123, 1, 1352, 1),
(3602, '2019-08-10 17:36:36', '2019-08-10 17:36:36', 'ETH241', '', '-690893010', 'VALIDE', 'ACTIVE', 3123, 1, 1318, 1);
INSERT INTO `est_inscrit` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `candidat_inscrit`, `createur`, `enseignement`, `modificateur`) VALUES
(3603, '2019-08-10 17:36:36', '2019-08-10 17:36:36', 'STG241', '', '-2066936357', 'VALIDE', 'ACTIVE', 3123, 1, 1354, 1),
(3604, '2019-08-10 17:36:36', '2019-08-10 17:36:36', 'ENV241', '', '-1746108339', 'VALIDE', 'ACTIVE', 3123, 1, 1322, 1),
(3605, '2019-08-10 17:36:37', '2019-08-10 17:36:37', 'INF244', '', '2015756416', 'VALIDE', 'ACTIVE', 3123, 1, 1323, 1),
(3606, '2019-08-10 17:36:37', '2019-08-10 17:36:37', 'INF243', '', '-1390838138', 'VALIDE', 'ACTIVE', 3123, 1, 1324, 1),
(3607, '2019-08-10 17:36:37', '2019-08-10 17:36:37', 'IN245', '', '196577871', 'VALIDE', 'ACTIVE', 3123, 1, 1351, 1),
(3608, '2019-08-10 17:36:37', '2019-08-10 17:36:37', 'INF231', '', '865689906', 'VALIDE', 'ACTIVE', 3123, 1, 1310, 1),
(3609, '2019-08-10 17:36:38', '2019-08-10 17:36:38', 'INF232', '', '-473866459', 'VALIDE', 'ACTIVE', 3123, 1, 1311, 1),
(3610, '2019-08-10 17:36:38', '2019-08-10 17:36:38', 'MAT241', '', '946163555', 'VALIDE', 'ACTIVE', 3123, 1, 1320, 1),
(3611, '2019-08-10 17:36:38', '2019-08-10 17:36:38', 'MAT231', '', '1656760776', 'VALIDE', 'ACTIVE', 3123, 1, 1312, 1),
(3612, '2019-08-10 17:36:38', '2019-08-10 17:36:38', 'INF233', '', '1231356060', 'VALIDE', 'ACTIVE', 3123, 1, 1313, 1),
(3613, '2019-08-10 17:36:38', '2019-08-10 17:36:38', 'INF235', '', '449904064', 'VALIDE', 'ACTIVE', 3123, 1, 1314, 1),
(3614, '2019-08-10 17:36:39', '2019-08-10 17:36:39', 'INF236', '', '1350739049', 'VALIDE', 'ACTIVE', 3123, 1, 1315, 1),
(3615, '2019-08-10 17:36:39', '2019-08-10 17:36:39', 'INF234', '', '1316298087', 'VALIDE', 'ACTIVE', 3123, 1, 1316, 1),
(3616, '2019-08-10 17:36:39', '2019-08-10 17:36:39', 'ANG231', '', '-447484254', 'VALIDE', 'ACTIVE', 3123, 1, 1317, 1),
(3617, '2019-08-10 17:36:39', '2019-08-10 17:36:39', 'ETH231', '', '-1448937032', 'VALIDE', 'ACTIVE', 3123, 1, 1353, 1),
(3618, '2019-08-10 17:36:40', '2019-08-10 17:36:40', 'INF241', '', '1638096229', 'VALIDE', 'ACTIVE', 3124, 1, 1319, 1),
(3619, '2019-08-10 17:36:40', '2019-08-10 17:36:40', 'INF242', '', '-1129674224', 'VALIDE', 'ACTIVE', 3124, 1, 1321, 1),
(3620, '2019-08-10 17:36:40', '2019-08-10 17:36:40', 'ANG241', '', '736144229', 'VALIDE', 'ACTIVE', 3124, 1, 1352, 1),
(3621, '2019-08-10 17:36:40', '2019-08-10 17:36:40', 'ETH241', '', '1444954350', 'VALIDE', 'ACTIVE', 3124, 1, 1318, 1),
(3622, '2019-08-10 17:36:40', '2019-08-10 17:36:40', 'STG241', '', '106601423', 'VALIDE', 'ACTIVE', 3124, 1, 1354, 1),
(3623, '2019-08-10 17:36:41', '2019-08-10 17:36:41', 'ENV241', '', '407588635', 'VALIDE', 'ACTIVE', 3124, 1, 1322, 1),
(3624, '2019-08-10 17:36:41', '2019-08-10 17:36:41', 'INF244', '', '-122633789', 'VALIDE', 'ACTIVE', 3124, 1, 1323, 1),
(3651, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'INF243', '', '780271195', 'VALIDE', 'ACTIVE', 3124, 1, 1324, 1),
(3652, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'IN245', '', '-1934924847', 'VALIDE', 'ACTIVE', 3124, 1, 1351, 1),
(3653, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'INF231', '', '-1261368187', 'VALIDE', 'ACTIVE', 3124, 1, 1310, 1),
(3654, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'INF232', '', '1689242549', 'VALIDE', 'ACTIVE', 3124, 1, 1311, 1),
(3655, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'MAT241', '', '-1166102826', 'VALIDE', 'ACTIVE', 3124, 1, 1320, 1),
(3656, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'MAT231', '', '-497142852', 'VALIDE', 'ACTIVE', 3124, 1, 1312, 1),
(3657, '2019-08-10 17:36:42', '2019-08-10 17:36:42', 'INF233', '', '-920556376', 'VALIDE', 'ACTIVE', 3124, 1, 1313, 1),
(3658, '2019-08-10 17:36:42', '2019-08-10 17:36:43', 'INF235', '', '-1673491658', 'VALIDE', 'ACTIVE', 3124, 1, 1314, 1),
(3659, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'INF236', '', '-795982065', 'VALIDE', 'ACTIVE', 3124, 1, 1315, 1),
(3660, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'INF234', '', '-822707158', 'VALIDE', 'ACTIVE', 3124, 1, 1316, 1),
(3661, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'ANG231', '', '1668049488', 'VALIDE', 'ACTIVE', 3124, 1, 1317, 1),
(3662, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'ETH231', '', '689850988', 'VALIDE', 'ACTIVE', 3124, 1, 1353, 1),
(3663, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'INF241', '', '-710415198', 'VALIDE', 'ACTIVE', 3125, 1, 1319, 1),
(3664, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'INF242', '', '817883912', 'VALIDE', 'ACTIVE', 3125, 1, 1321, 1),
(3665, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'ANG241', '', '-1636972642', 'VALIDE', 'ACTIVE', 3125, 1, 1352, 1),
(3666, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'ETH241', '', '-923895681', 'VALIDE', 'ACTIVE', 3125, 1, 1318, 1),
(3667, '2019-08-10 17:36:43', '2019-08-10 17:36:43', 'STG241', '', '2007402104', 'VALIDE', 'ACTIVE', 3125, 1, 1354, 1),
(3668, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'ENV241', '', '-1963821500', 'VALIDE', 'ACTIVE', 3125, 1, 1322, 1),
(3669, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF244', '', '1802772336', 'VALIDE', 'ACTIVE', 3125, 1, 1323, 1),
(3670, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF243', '', '-1628320991', 'VALIDE', 'ACTIVE', 3125, 1, 1324, 1),
(3671, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'IN245', '', '-43571757', 'VALIDE', 'ACTIVE', 3125, 1, 1351, 1),
(3672, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF231', '', '630162688', 'VALIDE', 'ACTIVE', 3125, 1, 1310, 1),
(3673, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF232', '', '-742035003', 'VALIDE', 'ACTIVE', 3125, 1, 1311, 1),
(3674, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'MAT241', '', '716432128', 'VALIDE', 'ACTIVE', 3125, 1, 1320, 1),
(3675, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'MAT231', '', '1402957260', 'VALIDE', 'ACTIVE', 3125, 1, 1312, 1),
(3676, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF233', '', '964396454', 'VALIDE', 'ACTIVE', 3125, 1, 1313, 1),
(3677, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF235', '', '184224510', 'VALIDE', 'ACTIVE', 3125, 1, 1314, 1),
(3678, '2019-08-10 17:36:44', '2019-08-10 17:36:44', 'INF236', '', '1072045633', 'VALIDE', 'ACTIVE', 3125, 1, 1315, 1),
(3679, '2019-08-10 17:36:45', '2019-08-10 17:36:45', 'INF234', '', '1063170154', 'VALIDE', 'ACTIVE', 3125, 1, 1316, 1),
(3680, '2019-08-10 17:36:45', '2019-08-10 17:36:45', 'ANG231', '', '-731795676', 'VALIDE', 'ACTIVE', 3125, 1, 1317, 1),
(3681, '2019-08-10 17:36:45', '2019-08-10 17:36:45', 'ETH231', '', '-1710065290', 'VALIDE', 'ACTIVE', 3125, 1, 1353, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=3863 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `evaluation`
--

INSERT INTO `evaluation` (`code`, `date_creation`, `date_evaluation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `type_evaluation`) VALUES
(2225, '2019-08-10 15:57:38', '2019-02-11 23:00:00', '2019-08-10 15:57:38', 'TP INF242', 'Travaux pratiques', '-997965270', 'ACTIVE', 'ACTIVE', 1, 1, 2134),
(2224, '2019-08-10 15:57:38', '2019-02-10 23:00:00', '2019-08-10 15:57:38', 'TP INF241', 'Travaux pratiques', '-2067627878', 'ACTIVE', 'ACTIVE', 1, 1, 2129),
(2221, '2019-08-10 15:57:37', '2019-02-12 23:00:00', '2019-08-10 15:57:37', 'TP INF233', 'Travaux pratiques', '-1936922108', 'ACTIVE', 'ACTIVE', 1, 1, 2168),
(2223, '2019-08-10 15:57:37', '2019-02-13 23:00:00', '2019-08-10 15:57:37', 'TP INF235', 'Travaux pratiques', '805417486', 'ACTIVE', 'ACTIVE', 1, 1, 2171),
(2222, '2019-08-10 15:57:37', '2019-02-14 23:00:00', '2019-08-10 15:57:37', 'TP INF234', 'Travaux pratiques', '1176217830', 'ACTIVE', 'ACTIVE', 1, 1, 2179),
(2220, '2019-08-10 15:57:37', '2019-06-06 22:00:00', '2019-08-10 15:57:37', 'SN MAT241', 'Session normale', '-2098657581', 'ACTIVE', 'ACTIVE', 1, 1, 2161),
(2215, '2019-08-10 15:57:36', '2019-02-09 23:00:00', '2019-08-10 15:57:36', 'SN INF241', 'Session normale', '-545706358', 'ACTIVE', 'ACTIVE', 1, 1, 2128),
(2216, '2019-08-10 15:57:36', '2019-02-10 23:00:00', '2019-08-10 15:57:36', 'SN INF242', 'Session normale', '-631007185', 'ACTIVE', 'ACTIVE', 1, 1, 2132),
(2217, '2019-08-10 15:57:36', '2019-06-07 22:00:00', '2019-08-10 15:57:36', 'SN INF243', 'Session normale', '-1785153053', 'ACTIVE', 'ACTIVE', 1, 1, 2149),
(2219, '2019-08-10 15:57:37', '2018-02-04 23:00:00', '2019-08-10 15:57:37', 'SN MAT231', 'Session normale', '1864903065', 'ACTIVE', 'ACTIVE', 1, 1, 2164),
(2218, '2019-08-10 15:57:36', '2019-06-08 22:00:00', '2019-08-10 15:57:36', 'SN INF244', 'Session normale', '-377038951', 'ACTIVE', 'ACTIVE', 1, 1, 2146),
(2214, '2019-08-10 15:57:36', '2018-02-05 23:00:00', '2019-08-10 15:57:36', 'SN INF236', 'Session normale', '1737145223', 'ACTIVE', 'ACTIVE', 1, 1, 2174),
(2213, '2019-08-10 15:57:35', '2019-06-04 22:00:00', '2019-08-10 15:57:35', 'SN INF235', 'Session normale', '-1138543186', 'ACTIVE', 'ACTIVE', 1, 1, 2170),
(2212, '2019-08-10 15:57:35', '2018-02-04 23:00:00', '2019-08-10 15:57:35', 'SN INF234', 'Session normale', '1297226717', 'ACTIVE', 'ACTIVE', 1, 1, 2178),
(2207, '2019-08-10 15:57:34', '2019-06-03 22:00:00', '2019-08-10 15:57:34', 'SN ETH231', 'Session normale', '689837574', 'ACTIVE', 'ACTIVE', 1, 1, 2140),
(2208, '2019-08-10 15:57:35', '2019-06-07 22:00:00', '2019-08-10 15:57:35', 'SN ETH241', 'Session normale', '836877187', 'ACTIVE', 'ACTIVE', 1, 1, 2184),
(2209, '2019-08-10 15:57:35', '2019-02-07 23:00:00', '2019-08-10 15:57:35', 'SN INF231', 'Session normale', '-2014629902', 'ACTIVE', 'ACTIVE', 1, 1, 2155),
(2210, '2019-08-10 15:57:35', '2018-02-05 23:00:00', '2019-08-10 15:57:35', 'SN INF232', 'Session normale', '-793786874', 'ACTIVE', 'ACTIVE', 1, 1, 2158),
(2211, '2019-08-10 15:57:35', '2019-06-07 22:00:00', '2019-08-10 15:57:35', 'SN INF233', 'Session normale', '-1783949964', 'ACTIVE', 'ACTIVE', 1, 1, 2167),
(2206, '2019-08-10 15:57:34', '2019-06-07 22:00:00', '2019-08-10 15:57:34', 'SN ENV241', 'Session normale', '-1820413525', 'ACTIVE', 'ACTIVE', 1, 1, 2143),
(2205, '2019-08-10 15:57:34', '2018-02-07 23:00:00', '2019-08-10 15:57:34', 'SN ANG241', 'Session normale', '121786470', 'ACTIVE', 'ACTIVE', 1, 1, 2137),
(2204, '2019-08-10 15:57:34', '2019-06-04 22:00:00', '2019-08-10 15:57:34', 'SN ANG231', 'Session normale', '1478428482', 'ACTIVE', 'ACTIVE', 1, 1, 2181),
(2203, '2019-08-10 15:57:33', '2019-04-05 22:00:00', '2019-08-10 15:57:33', 'CC MAT241', 'Controle Continu', '-687484855', 'ACTIVE', 'ACTIVE', 1, 1, 2160),
(2202, '2019-08-10 15:57:33', '2018-10-19 22:00:00', '2019-08-10 15:57:33', 'CC MAT231', 'Controle Continu', '661057252', 'ACTIVE', 'ACTIVE', 1, 1, 2163),
(2201, '2019-08-10 15:57:33', '2019-04-19 22:00:00', '2019-08-10 15:57:33', 'CC INF245', 'Controle Continu', '732235393', 'ACTIVE', 'ACTIVE', 1, 1, 2151),
(2200, '2019-08-10 15:57:33', '2019-04-12 22:00:00', '2019-08-10 15:57:33', 'CC INF244', 'Controle Continu', '-56463322', 'ACTIVE', 'ACTIVE', 1, 1, 2145),
(2197, '2019-08-10 15:57:32', '2019-04-05 22:00:00', '2019-08-10 15:57:32', 'CC INF241', 'Controle Continu', '1252235582', 'ACTIVE', 'ACTIVE', 1, 1, 2127),
(2199, '2019-08-10 15:57:33', '2019-04-19 22:00:00', '2019-08-10 15:57:33', 'CC INF243', 'Controle Continu', '-2040756165', 'ACTIVE', 'ACTIVE', 1, 1, 2148),
(2198, '2019-08-10 15:57:33', '2019-04-05 22:00:00', '2019-08-10 15:57:33', 'CC INF242', 'Controle Continu', '659955158', 'ACTIVE', 'ACTIVE', 1, 1, 2131),
(2196, '2019-08-10 15:57:32', '2018-11-16 23:00:00', '2019-08-10 15:57:32', 'CC INF236', 'Controle Continu', '-810257469', 'ACTIVE', 'ACTIVE', 1, 1, 2173),
(2195, '2019-08-10 15:57:32', '2018-11-09 23:00:00', '2019-08-10 15:57:32', 'CC INF235', 'Controle Continu', '203571291', 'ACTIVE', 'ACTIVE', 1, 1, 2169),
(2194, '2019-08-10 15:57:32', '2018-10-26 22:00:00', '2019-08-10 15:57:32', 'CC INF234', 'Controle Continu', '1320096585', 'ACTIVE', 'ACTIVE', 1, 1, 2177),
(2191, '2019-08-10 15:57:32', '2018-10-26 22:00:00', '2019-08-10 15:57:32', 'CC INF231', 'Controle Continu', '1209248105', 'ACTIVE', 'ACTIVE', 1, 1, 2154),
(2192, '2019-08-10 15:57:32', '2018-10-19 22:00:00', '2019-08-10 15:57:32', 'CC INF232', 'Controle Continu', '625477901', 'ACTIVE', 'ACTIVE', 1, 1, 2157),
(2193, '2019-08-10 15:57:32', '2018-11-02 23:00:00', '2019-08-10 15:57:32', 'CC INF233', 'Controle Continu', '2077697016', 'ACTIVE', 'ACTIVE', 1, 1, 2166),
(2190, '2019-08-10 15:57:32', '2019-04-26 22:00:00', '2019-08-10 15:57:32', 'CC ETH241', 'Controle Continu', '-1742788006', 'ACTIVE', 'ACTIVE', 1, 1, 2183),
(2189, '2019-08-10 15:57:32', '2018-11-02 23:00:00', '2019-08-10 15:57:32', 'CC ETH231', 'Controle Continu', '1283277374', 'ACTIVE', 'ACTIVE', 1, 1, 2138),
(2188, '2019-08-10 15:57:31', '2019-04-12 22:00:00', '2019-08-10 15:57:31', 'CC ENV241', 'Controle Continu', '923735115', 'ACTIVE', 'ACTIVE', 1, 1, 2142),
(2186, '2019-08-10 15:57:31', '2018-11-02 23:00:00', '2019-08-10 15:57:31', 'CC ANG231', 'Controle Continu', '1596002021', 'ACTIVE', 'ACTIVE', 1, 1, 2180),
(2187, '2019-08-10 15:57:31', '2019-04-26 22:00:00', '2019-08-10 15:57:31', 'CC ANG241', 'Controle Continu', '-1826959242', 'ACTIVE', 'ACTIVE', 1, 1, 2135);

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
) ENGINE=MyISAM AUTO_INCREMENT=858 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `historique_note`
--

INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(10, '2019-08-10 12:48:17', '2019-08-10 12:48:17', NULL, 'Langage C++ et POO', '-1464056310', 'ACTIVE', 14.75, 1, 1, 801),
(11, '2019-08-10 12:48:17', '2019-08-10 12:48:16', NULL, 'Langage C++ et POO', '-724315989', 'ACTIVE', 14.75, 1, 1, 801),
(12, '2019-08-10 12:52:28', '2019-08-10 12:52:28', NULL, 'Langage C++ et POO', '-278376008', 'ACTIVE', 14.75, 1, 1, 901),
(13, '2019-08-10 12:52:28', '2019-08-10 12:52:27', NULL, 'Langage C++ et POO', '553716413', 'ACTIVE', 14.75, 1, 1, 901),
(14, '2019-08-10 12:58:50', '2019-08-10 12:58:50', NULL, 'Langage C++ et POO', '1545344855', 'ACTIVE', 14.75, 1, 1, 1001),
(15, '2019-08-10 12:58:50', '2019-08-10 12:58:50', NULL, 'Langage C++ et POO', '-1825177920', 'ACTIVE', 14.75, 1, 1, 1001),
(16, '2019-08-10 13:59:29', '2019-08-10 13:59:29', NULL, 'Langage C++ et POO', '-1686102067', 'ACTIVE', 14.75, 1, 1, 1601),
(17, '2019-08-10 13:59:29', '2019-08-10 13:59:28', NULL, 'Langage C++ et POO', '-207544946', 'ACTIVE', 14.75, 1, 1, 1601),
(18, '2019-08-10 13:59:29', '2019-08-10 13:59:29', NULL, 'Langage C++ et POO', '-530481027', 'ACTIVE', 14.75, 1, 1, 1602),
(19, '2019-08-10 13:59:29', '2019-08-10 13:59:29', NULL, 'Langage C++ et POO', '948999615', 'ACTIVE', 14.75, 1, 1, 1602),
(20, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Langage C++ et POO', '1542250933', 'ACTIVE', 14.75, 1, 1, 1645),
(21, '2019-08-10 14:06:19', '2019-08-10 14:06:18', NULL, 'Langage C++ et POO', '-1233524318', 'ACTIVE', 14.75, 1, 1, 1645),
(22, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Langage C++ et POO', '1302966955', 'ACTIVE', 14.75, 1, 1, 1646),
(23, '2019-08-10 14:06:19', '2019-08-10 14:06:18', NULL, 'Langage C++ et POO', '-1471884775', 'ACTIVE', 14.75, 1, 1, 1646),
(24, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Langage C++ et POO', '809344397', 'ACTIVE', 16, 1, 1, 1647),
(25, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Langage C++ et POO', '-1964583812', 'ACTIVE', 16, 1, 1, 1647),
(26, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Algèbre linéaire II', '369947131', 'ACTIVE', 9.75, 1, 1, 1648),
(27, '2019-08-10 14:06:19', '2019-08-10 14:06:19', NULL, 'Algèbre linéaire II', '1891909739', 'ACTIVE', 9.75, 1, 1, 1648),
(28, '2019-08-10 14:06:20', '2019-08-10 14:06:20', NULL, 'Algèbre linéaire II', '1145690095', 'ACTIVE', 12, 1, 1, 1649),
(29, '2019-08-10 14:06:20', '2019-08-10 14:06:19', NULL, 'Algèbre linéaire II', '-1626391072', 'ACTIVE', 12, 1, 1, 1649),
(30, '2019-08-10 14:06:20', '2019-08-10 14:06:20', NULL, 'Programmation Web II', '-711109850', 'ACTIVE', 6.5, 1, 1, 1650),
(31, '2019-08-10 14:06:20', '2019-08-10 14:06:19', NULL, 'Programmation Web II', '812699800', 'ACTIVE', 6.5, 1, 1, 1650),
(32, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Langage C++ et POO', '1591055733', 'ACTIVE', 14.75, 1, 1, 1694),
(33, '2019-08-10 14:09:09', '2019-08-10 14:09:08', NULL, 'Langage C++ et POO', '-1139466989', 'ACTIVE', 14.75, 1, 1, 1694),
(34, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Langage C++ et POO', '1642250155', 'ACTIVE', 14.75, 1, 1, 1695),
(35, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Langage C++ et POO', '-1087349046', 'ACTIVE', 14.75, 1, 1, 1695),
(36, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Langage C++ et POO', '461361700', 'ACTIVE', 16, 1, 1, 1696),
(37, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Langage C++ et POO', '2027653316', 'ACTIVE', 16, 1, 1, 1696),
(38, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Algèbre linéaire II', '354426994', 'ACTIVE', 9.75, 1, 1, 1697),
(39, '2019-08-10 14:09:09', '2019-08-10 14:09:09', NULL, 'Algèbre linéaire II', '1921642131', 'ACTIVE', 9.75, 1, 1, 1697),
(40, '2019-08-10 14:09:10', '2019-08-10 14:09:10', NULL, 'Algèbre linéaire II', '839505917', 'ACTIVE', 12, 1, 1, 1698),
(41, '2019-08-10 14:09:10', '2019-08-10 14:09:09', NULL, 'Algèbre linéaire II', '-1887322721', 'ACTIVE', 12, 1, 1, 1698),
(42, '2019-08-10 14:09:10', '2019-08-10 14:09:10', NULL, 'Programmation Web II', '994394468', 'ACTIVE', 6.5, 1, 1, 1701),
(43, '2019-08-10 14:09:10', '2019-08-10 14:09:10', NULL, 'Programmation Web II', '-1729663607', 'ACTIVE', 6.5, 1, 1, 1701),
(44, '2019-08-10 14:09:11', '2019-08-10 14:09:11', NULL, 'Programmation Web II', '733620395', 'ACTIVE', 13, 1, 1, 1702),
(45, '2019-08-10 14:09:11', '2019-08-10 14:09:10', NULL, 'Programmation Web II', '-1989514159', 'ACTIVE', 13, 1, 1, 1702),
(46, '2019-08-10 14:15:09', '2019-08-10 14:15:09', NULL, 'Langage C++ et POO', '-1497974412', 'ACTIVE', 14.75, 1, 1, 1805),
(47, '2019-08-10 14:15:09', '2019-08-10 14:15:09', NULL, 'Langage C++ et POO', '168980993', 'ACTIVE', 14.75, 1, 1, 1805),
(48, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Langage C++ et POO', '-1127763582', 'ACTIVE', 14.75, 1, 1, 1806),
(49, '2019-08-10 14:15:10', '2019-08-10 14:15:09', NULL, 'Langage C++ et POO', '540115344', 'ACTIVE', 14.75, 1, 1, 1806),
(50, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Langage C++ et POO', '1675702696', 'ACTIVE', 16, 1, 1, 1807),
(51, '2019-08-10 14:15:10', '2019-08-10 14:15:09', NULL, 'Langage C++ et POO', '-950462153', 'ACTIVE', 16, 1, 1, 1807),
(52, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Algèbre linéaire II', '1875634378', 'ACTIVE', 9.75, 1, 1, 1808),
(53, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Algèbre linéaire II', '-749606950', 'ACTIVE', 9.75, 1, 1, 1808),
(54, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Algèbre linéaire II', '-1935531772', 'ACTIVE', 12, 1, 1, 1809),
(55, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Algèbre linéaire II', '-264882283', 'ACTIVE', 12, 1, 1, 1809),
(56, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Programmation Web II', '201929331', 'ACTIVE', 6.5, 1, 1, 1810),
(57, '2019-08-10 14:15:10', '2019-08-10 14:15:10', NULL, 'Programmation Web II', '1873502341', 'ACTIVE', 6.5, 1, 1, 1810),
(58, '2019-08-10 14:15:11', '2019-08-10 14:15:11', NULL, 'Programmation Web II', '-883752991', 'ACTIVE', 13, 1, 1, 1811),
(59, '2019-08-10 14:15:11', '2019-08-10 14:15:10', NULL, 'Programmation Web II', '788743540', 'ACTIVE', 13, 1, 1, 1811),
(60, '2019-08-10 14:15:11', '2019-08-10 14:15:11', NULL, 'Programmation Web II', '-147033692', 'ACTIVE', 14.5, 1, 1, 1812),
(61, '2019-08-10 14:15:11', '2019-08-10 14:15:10', NULL, 'Programmation Web II', '1526386360', 'ACTIVE', 14.5, 1, 1, 1812),
(62, '2019-08-10 14:15:11', '2019-08-10 14:15:11', NULL, 'Anglais Niveau pratique B2', '2116963695', 'ACTIVE', 11.1, 1, 1, 1813),
(63, '2019-08-10 14:15:11', '2019-08-10 14:15:10', NULL, 'Anglais Niveau pratique B2', '-503660028', 'ACTIVE', 11.1, 1, 1, 1813),
(64, '2019-08-10 14:22:19', '2019-08-10 14:22:19', NULL, 'Langage C++ et POO', '-502037510', 'ACTIVE', 14.75, 1, 1, 1859),
(65, '2019-08-10 14:22:19', '2019-08-10 14:22:18', NULL, 'Langage C++ et POO', '1214788029', 'ACTIVE', 14.75, 1, 1, 1859),
(66, '2019-08-10 14:22:19', '2019-08-10 14:22:19', NULL, 'Langage C++ et POO', '738957521', 'ACTIVE', 14.75, 1, 1, 1860),
(67, '2019-08-10 14:22:19', '2019-08-10 14:22:19', NULL, 'Langage C++ et POO', '-1838260715', 'ACTIVE', 14.75, 1, 1, 1860),
(68, '2019-08-10 14:22:19', '2019-08-10 14:22:19', NULL, 'Langage C++ et POO', '-1484592869', 'ACTIVE', 16, 1, 1, 1861),
(69, '2019-08-10 14:22:19', '2019-08-10 14:22:19', NULL, 'Langage C++ et POO', '234079712', 'ACTIVE', 16, 1, 1, 1861),
(70, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Algèbre linéaire II', '1419803056', 'ACTIVE', 9.75, 1, 1, 1862),
(71, '2019-08-10 14:22:20', '2019-08-10 14:22:19', NULL, 'Algèbre linéaire II', '-1155568138', 'ACTIVE', 9.75, 1, 1, 1862),
(72, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Algèbre linéaire II', '-482588638', 'ACTIVE', 12, 1, 1, 1863),
(73, '2019-08-10 14:22:20', '2019-08-10 14:22:19', NULL, 'Algèbre linéaire II', '1237930985', 'ACTIVE', 12, 1, 1, 1863),
(74, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '764079972', 'ACTIVE', 6.5, 1, 1, 1864),
(75, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '-1809444180', 'ACTIVE', 6.5, 1, 1, 1864),
(76, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '761701386', 'ACTIVE', 13, 1, 1, 1865),
(77, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '-1810899245', 'ACTIVE', 13, 1, 1, 1865),
(78, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '-2109004550', 'ACTIVE', 14.5, 1, 1, 1866),
(79, '2019-08-10 14:22:20', '2019-08-10 14:22:20', NULL, 'Programmation Web II', '-385714364', 'ACTIVE', 14.5, 1, 1, 1866),
(80, '2019-08-10 14:22:21', '2019-08-10 14:22:21', NULL, 'Anglais Niveau pratique B2', '-616107749', 'ACTIVE', 11.1, 1, 1, 1867),
(81, '2019-08-10 14:22:21', '2019-08-10 14:22:20', NULL, 'Anglais Niveau pratique B2', '1108105958', 'ACTIVE', 11.1, 1, 1, 1867),
(82, '2019-08-10 14:22:21', '2019-08-10 14:22:21', NULL, 'Anglais Niveau pratique B2', '2107644318', 'ACTIVE', 12.2, 1, 1, 1868),
(83, '2019-08-10 14:22:21', '2019-08-10 14:22:20', NULL, 'Anglais Niveau pratique B2', '-462185750', 'ACTIVE', 12.2, 1, 1, 1868),
(84, '2019-08-10 14:22:21', '2019-08-10 14:22:21', NULL, 'Ethique et Développement    ', '-2059655019', 'ACTIVE', 15.75, 1, 1, 1869),
(85, '2019-08-10 14:22:21', '2019-08-10 14:22:20', NULL, 'Ethique et Développement    ', '-333594270', 'ACTIVE', 15.75, 1, 1, 1869),
(86, '2019-08-10 14:22:21', '2019-08-10 14:22:21', NULL, 'Ethique et Développement    ', '-396215417', 'ACTIVE', 14.5, 1, 1, 1870),
(87, '2019-08-10 14:22:21', '2019-08-10 14:22:20', NULL, 'Ethique et Développement    ', '1330768853', 'ACTIVE', 14.5, 1, 1, 1870),
(88, '2019-08-10 15:24:16', '2019-08-10 15:24:16', NULL, 'Langage C++ et POO', '-2045417997', 'ACTIVE', 14.75, 1, 1, 1915),
(89, '2019-08-10 15:24:16', '2019-08-10 15:24:16', NULL, 'Langage C++ et POO', '-276875282', 'ACTIVE', 14.75, 1, 1, 1915),
(90, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Langage C++ et POO', '-449092223', 'ACTIVE', 14.75, 1, 1, 1916),
(91, '2019-08-10 15:24:17', '2019-08-10 15:24:16', NULL, 'Langage C++ et POO', '1320374013', 'ACTIVE', 14.75, 1, 1, 1916),
(92, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Langage C++ et POO', '1372303590', 'ACTIVE', 16, 1, 1, 1917),
(93, '2019-08-10 15:24:17', '2019-08-10 15:24:16', NULL, 'Langage C++ et POO', '-1152273949', 'ACTIVE', 16, 1, 1, 1917),
(94, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Algèbre linéaire II', '-634763131', 'ACTIVE', 9.75, 1, 1, 1918),
(95, '2019-08-10 15:24:17', '2019-08-10 15:24:16', NULL, 'Algèbre linéaire II', '1136550147', 'ACTIVE', 9.75, 1, 1, 1918),
(96, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Algèbre linéaire II', '654842053', 'ACTIVE', 12, 1, 1, 1919),
(97, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Algèbre linéaire II', '-1867888444', 'ACTIVE', 12, 1, 1, 1919),
(98, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Programmation Web II', '-451759141', 'ACTIVE', 6.5, 1, 1, 1920),
(99, '2019-08-10 15:24:17', '2019-08-10 15:24:17', NULL, 'Programmation Web II', '1321401179', 'ACTIVE', 6.5, 1, 1, 1920),
(100, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Programmation Web II', '828179467', 'ACTIVE', 13, 1, 1, 1921),
(101, '2019-08-10 15:24:18', '2019-08-10 15:24:17', NULL, 'Programmation Web II', '-1692703988', 'ACTIVE', 13, 1, 1, 1921),
(102, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Programmation Web II', '1372447913', 'ACTIVE', 14.5, 1, 1, 1922),
(103, '2019-08-10 15:24:18', '2019-08-10 15:24:17', NULL, 'Programmation Web II', '-1147512021', 'ACTIVE', 14.5, 1, 1, 1922),
(104, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Anglais Niveau pratique B2', '1166885314', 'ACTIVE', 11.1, 1, 1, 1923),
(105, '2019-08-10 15:24:18', '2019-08-10 15:24:17', NULL, 'Anglais Niveau pratique B2', '-1352151099', 'ACTIVE', 11.1, 1, 1, 1923),
(106, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Anglais Niveau pratique B2', '1645137109', 'ACTIVE', 12.2, 1, 1, 1924),
(107, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Anglais Niveau pratique B2', '-872975783', 'ACTIVE', 12.2, 1, 1, 1924),
(108, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Ethique et Développement    ', '688437141', 'ACTIVE', 15.75, 1, 1, 1925),
(109, '2019-08-10 15:24:18', '2019-08-10 15:24:18', NULL, 'Ethique et Développement    ', '-1828752230', 'ACTIVE', 15.75, 1, 1, 1925),
(110, '2019-08-10 15:30:11', '2019-08-10 15:30:11', NULL, 'Langage C++ et POO', '-955383842', 'ACTIVE', 14.75, 1, 1, 1966),
(111, '2019-08-10 15:30:11', '2019-08-10 15:30:10', NULL, 'Langage C++ et POO', '860258444', 'ACTIVE', 14.75, 1, 1, 1966),
(112, '2019-08-10 15:30:11', '2019-08-10 15:30:11', NULL, 'Langage C++ et POO', '-691828053', 'ACTIVE', 14.75, 1, 1, 1967),
(113, '2019-08-10 15:30:11', '2019-08-10 15:30:11', NULL, 'Langage C++ et POO', '1124737754', 'ACTIVE', 14.75, 1, 1, 1967),
(114, '2019-08-10 15:30:11', '2019-08-10 15:30:11', NULL, 'Langage C++ et POO', '-1032629278', 'ACTIVE', 16, 1, 1, 1968),
(115, '2019-08-10 15:30:11', '2019-08-10 15:30:11', NULL, 'Langage C++ et POO', '784860050', 'ACTIVE', 16, 1, 1, 1968),
(116, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Algèbre linéaire II', '977620983', 'ACTIVE', 9.75, 1, 1, 1969),
(117, '2019-08-10 15:30:12', '2019-08-10 15:30:11', NULL, 'Algèbre linéaire II', '-1498933464', 'ACTIVE', 9.75, 1, 1, 1969),
(118, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Algèbre linéaire II', '1809401154', 'ACTIVE', 12, 1, 1, 1970),
(119, '2019-08-10 15:30:12', '2019-08-10 15:30:11', NULL, 'Algèbre linéaire II', '-666229772', 'ACTIVE', 12, 1, 1, 1970),
(120, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Programmation Web II', '-835962996', 'ACTIVE', 6.5, 1, 1, 1971),
(121, '2019-08-10 15:30:12', '2019-08-10 15:30:11', NULL, 'Programmation Web II', '984296895', 'ACTIVE', 6.5, 1, 1, 1971),
(122, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Programmation Web II', '-1903602047', 'ACTIVE', 13, 1, 1, 1972),
(123, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Programmation Web II', '-82418635', 'ACTIVE', 13, 1, 1, 1972),
(124, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Programmation Web II', '1077889080', 'ACTIVE', 14.5, 1, 1, 1973),
(125, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Programmation Web II', '-1394971283', 'ACTIVE', 14.5, 1, 1, 1973),
(126, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Anglais Niveau pratique B2', '-786546677', 'ACTIVE', 11.1, 1, 1, 1974),
(127, '2019-08-10 15:30:12', '2019-08-10 15:30:12', NULL, 'Anglais Niveau pratique B2', '1036483777', 'ACTIVE', 11.1, 1, 1, 1974),
(128, '2019-08-10 15:30:13', '2019-08-10 15:30:13', NULL, 'Anglais Niveau pratique B2', '-1486688942', 'ACTIVE', 12.2, 1, 1, 1975),
(129, '2019-08-10 15:30:13', '2019-08-10 15:30:12', NULL, 'Anglais Niveau pratique B2', '337265033', 'ACTIVE', 12.2, 1, 1, 1975),
(130, '2019-08-10 15:30:13', '2019-08-10 15:30:13', NULL, 'Ethique et Développement    ', '1529335319', 'ACTIVE', 15.75, 1, 1, 1976),
(131, '2019-08-10 15:30:13', '2019-08-10 15:30:12', NULL, 'Ethique et Développement    ', '-940754481', 'ACTIVE', 15.75, 1, 1, 1976),
(132, '2019-08-10 15:30:13', '2019-08-10 15:30:13', NULL, 'Ethique et Développement    ', '1524476567', 'ACTIVE', 14.5, 1, 1, 1977),
(133, '2019-08-10 15:30:13', '2019-08-10 15:30:12', NULL, 'Ethique et Développement    ', '-944689712', 'ACTIVE', 14.5, 1, 1, 1977),
(134, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Langage C++ et POO', '-256371549', 'ACTIVE', 14.75, 1, 1, 1978),
(135, '2019-08-10 15:34:36', '2019-08-10 15:34:35', NULL, 'Langage C++ et POO', '1570352989', 'ACTIVE', 14.75, 1, 1, 1978),
(136, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Langage C++ et POO', '1326629978', 'ACTIVE', 14.75, 1, 1, 1979),
(137, '2019-08-10 15:34:36', '2019-08-10 15:34:35', NULL, 'Langage C++ et POO', '-1140689259', 'ACTIVE', 14.75, 1, 1, 1979),
(138, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Langage C++ et POO', '691491325', 'ACTIVE', 16, 1, 1, 1980),
(139, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Langage C++ et POO', '-1774904391', 'ACTIVE', 16, 1, 1, 1980),
(140, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Algèbre linéaire II', '1263882493', 'ACTIVE', 9.75, 1, 1, 1981),
(141, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Algèbre linéaire II', '-1201589702', 'ACTIVE', 9.75, 1, 1, 1981),
(142, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Algèbre linéaire II', '613145688', 'ACTIVE', 12, 1, 1, 1982),
(143, '2019-08-10 15:34:36', '2019-08-10 15:34:36', NULL, 'Algèbre linéaire II', '-1851402986', 'ACTIVE', 12, 1, 1, 1982),
(144, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Programmation Web II', '1626708636', 'ACTIVE', 6.5, 1, 1, 1983),
(145, '2019-08-10 15:34:37', '2019-08-10 15:34:36', NULL, 'Programmation Web II', '-836916517', 'ACTIVE', 6.5, 1, 1, 1983),
(146, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Programmation Web II', '729920970', 'ACTIVE', 13, 1, 1, 1984),
(147, '2019-08-10 15:34:37', '2019-08-10 15:34:36', NULL, 'Programmation Web II', '-1732780662', 'ACTIVE', 13, 1, 1, 1984),
(148, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Programmation Web II', '1261639759', 'ACTIVE', 14.5, 1, 1, 1985),
(149, '2019-08-10 15:34:37', '2019-08-10 15:34:36', NULL, 'Programmation Web II', '-1200138352', 'ACTIVE', 14.5, 1, 1, 1985),
(150, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Anglais Niveau pratique B2', '-841987937', 'ACTIVE', 11.1, 1, 1, 1986),
(151, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Anglais Niveau pratique B2', '992124769', 'ACTIVE', 11.1, 1, 1, 1986),
(152, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Anglais Niveau pratique B2', '-743018766', 'ACTIVE', 12.2, 1, 1, 1987),
(153, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Anglais Niveau pratique B2', '1092017461', 'ACTIVE', 12.2, 1, 1, 1987),
(154, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Ethique et Développement    ', '-1585528347', 'ACTIVE', 15.75, 1, 1, 1988),
(155, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Ethique et Développement    ', '250431401', 'ACTIVE', 15.75, 1, 1, 1988),
(156, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Ethique et Développement    ', '-1787628614', 'ACTIVE', 14.5, 1, 1, 1989),
(157, '2019-08-10 15:34:37', '2019-08-10 15:34:37', NULL, 'Ethique et Développement    ', '49254655', 'ACTIVE', 14.5, 1, 1, 1989),
(158, '2019-08-10 15:38:43', '2019-08-10 15:38:43', NULL, 'Langage C++ et POO', '1508049090', 'ACTIVE', 14.75, 1, 1, 1990),
(159, '2019-08-10 15:38:43', '2019-08-10 15:38:42', NULL, 'Langage C++ et POO', '-949111416', 'ACTIVE', 14.75, 1, 1, 1990),
(160, '2019-08-10 15:38:43', '2019-08-10 15:38:43', NULL, 'Langage C++ et POO', '1590265888', 'ACTIVE', 14.75, 1, 1, 1991),
(161, '2019-08-10 15:38:43', '2019-08-10 15:38:43', NULL, 'Langage C++ et POO', '-865971097', 'ACTIVE', 14.75, 1, 1, 1991),
(162, '2019-08-10 15:38:43', '2019-08-10 15:38:43', NULL, 'Langage C++ et POO', '-1528815380', 'ACTIVE', 16, 1, 1, 1992),
(163, '2019-08-10 15:38:43', '2019-08-10 15:38:43', NULL, 'Langage C++ et POO', '310838452', 'ACTIVE', 16, 1, 1, 1992),
(164, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Algèbre linéaire II', '1112060161', 'ACTIVE', 9.75, 1, 1, 1993),
(165, '2019-08-10 15:38:44', '2019-08-10 15:38:43', NULL, 'Algèbre linéaire II', '-1342329782', 'ACTIVE', 9.75, 1, 1, 1993),
(166, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Algèbre linéaire II', '1526016861', 'ACTIVE', 12, 1, 1, 1994),
(167, '2019-08-10 15:38:44', '2019-08-10 15:38:43', NULL, 'Algèbre linéaire II', '-927449561', 'ACTIVE', 12, 1, 1, 1994),
(168, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Programmation Web II', '-1003641393', 'ACTIVE', 6.5, 1, 1, 1995),
(169, '2019-08-10 15:38:44', '2019-08-10 15:38:43', NULL, 'Programmation Web II', '838783002', 'ACTIVE', 6.5, 1, 1, 1995),
(170, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Programmation Web II', '-1974184531', 'ACTIVE', 13, 1, 1, 1996),
(171, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Programmation Web II', '-130836615', 'ACTIVE', 13, 1, 1, 1996),
(172, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Programmation Web II', '1067867003', 'ACTIVE', 14.5, 1, 1, 1997),
(173, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Programmation Web II', '-1382828856', 'ACTIVE', 14.5, 1, 1, 1997),
(174, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Anglais Niveau pratique B2', '-2013503661', 'ACTIVE', 11.1, 1, 1, 1998),
(175, '2019-08-10 15:38:44', '2019-08-10 15:38:44', NULL, 'Anglais Niveau pratique B2', '-168308703', 'ACTIVE', 11.1, 1, 1, 1998),
(176, '2019-08-10 15:38:45', '2019-08-10 15:38:45', NULL, 'Anglais Niveau pratique B2', '-1893559278', 'ACTIVE', 12.2, 1, 1, 1999),
(177, '2019-08-10 15:38:45', '2019-08-10 15:38:44', NULL, 'Anglais Niveau pratique B2', '-47440799', 'ACTIVE', 12.2, 1, 1, 1999),
(178, '2019-08-10 15:38:45', '2019-08-10 15:38:45', NULL, 'Ethique et Développement    ', '-2044883172', 'ACTIVE', 15.75, 1, 1, 2000),
(179, '2019-08-10 15:38:45', '2019-08-10 15:38:44', NULL, 'Ethique et Développement    ', '-197841172', 'ACTIVE', 15.75, 1, 1, 2000),
(180, '2019-08-10 15:38:45', '2019-08-10 15:38:45', NULL, 'Ethique et Développement    ', '1698500940', 'ACTIVE', 14.5, 1, 1, 2001),
(181, '2019-08-10 15:38:45', '2019-08-10 15:38:44', NULL, 'Ethique et Développement    ', '-748500835', 'ACTIVE', 14.5, 1, 1, 2001),
(182, '2019-08-10 15:43:50', '2019-08-10 15:43:50', NULL, 'Langage C++ et POO', '543999285', 'ACTIVE', 14.75, 1, 1, 2101),
(183, '2019-08-10 15:43:50', '2019-08-10 15:43:49', NULL, 'Langage C++ et POO', '-1810650390', 'ACTIVE', 14.75, 1, 1, 2101),
(184, '2019-08-10 15:43:50', '2019-08-10 15:43:50', NULL, 'Langage C++ et POO', '1430027596', 'ACTIVE', 14.75, 1, 1, 2102),
(185, '2019-08-10 15:43:50', '2019-08-10 15:43:50', NULL, 'Langage C++ et POO', '-923698558', 'ACTIVE', 14.75, 1, 1, 2102),
(186, '2019-08-10 15:43:50', '2019-08-10 15:43:50', NULL, 'Langage C++ et POO', '-1568989929', 'ACTIVE', 16, 1, 1, 2103),
(187, '2019-08-10 15:43:50', '2019-08-10 15:43:50', NULL, 'Langage C++ et POO', '373174734', 'ACTIVE', 16, 1, 1, 2103),
(188, '2019-08-10 15:43:51', '2019-08-10 15:43:51', NULL, 'Algèbre linéaire II', '1389654624', 'ACTIVE', 9.75, 1, 1, 2104),
(189, '2019-08-10 15:43:51', '2019-08-10 15:43:50', NULL, 'Algèbre linéaire II', '-962224488', 'ACTIVE', 9.75, 1, 1, 2104),
(190, '2019-08-10 15:43:51', '2019-08-10 15:43:51', NULL, 'Algèbre linéaire II', '-1731578644', 'ACTIVE', 12, 1, 1, 2105),
(191, '2019-08-10 15:43:51', '2019-08-10 15:43:50', NULL, 'Algèbre linéaire II', '212433061', 'ACTIVE', 12, 1, 1, 2105),
(192, '2019-08-10 15:43:51', '2019-08-10 15:43:51', NULL, 'Programmation Web II', '-498802660', 'ACTIVE', 6.5, 1, 1, 2106),
(193, '2019-08-10 15:43:51', '2019-08-10 15:43:51', NULL, 'Programmation Web II', '1446132566', 'ACTIVE', 6.5, 1, 1, 2106),
(194, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Programmation Web II', '-302080700', 'ACTIVE', 13, 1, 1, 2107),
(195, '2019-08-10 15:43:52', '2019-08-10 15:43:51', NULL, 'Programmation Web II', '1643778047', 'ACTIVE', 13, 1, 1, 2107),
(196, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Programmation Web II', '191764044', 'ACTIVE', 14.5, 1, 1, 2108),
(197, '2019-08-10 15:43:52', '2019-08-10 15:43:51', NULL, 'Programmation Web II', '2138546312', 'ACTIVE', 14.5, 1, 1, 2108),
(198, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Anglais Niveau pratique B2', '1482447305', 'ACTIVE', 11.1, 1, 1, 2109),
(199, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Anglais Niveau pratique B2', '-864814202', 'ACTIVE', 11.1, 1, 1, 2109),
(200, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Anglais Niveau pratique B2', '590166594', 'ACTIVE', 12.2, 1, 1, 2110),
(201, '2019-08-10 15:43:52', '2019-08-10 15:43:52', NULL, 'Anglais Niveau pratique B2', '-1756171392', 'ACTIVE', 12.2, 1, 1, 2110),
(202, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'Ethique et Développement    ', '2110821044', 'ACTIVE', 15.75, 1, 1, 2111),
(203, '2019-08-10 15:43:53', '2019-08-10 15:43:52', NULL, 'Ethique et Développement    ', '-234593421', 'ACTIVE', 15.75, 1, 1, 2111),
(204, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'Ethique et Développement    ', '1213800941', 'ACTIVE', 14.5, 1, 1, 2112),
(205, '2019-08-10 15:43:53', '2019-08-10 15:43:52', NULL, 'Ethique et Développement    ', '-1130690003', 'ACTIVE', 14.5, 1, 1, 2112),
(206, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1617070001', 'ACTIVE', 15, 1, 1, 2113),
(207, '2019-08-10 15:43:53', '2019-08-10 15:43:52', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-726497422', 'ACTIVE', 15, 1, 1, 2113),
(208, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-634968098', 'ACTIVE', 16, 1, 1, 2114),
(209, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1317355296', 'ACTIVE', 16, 1, 1, 2114),
(210, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'économie numérique', '878401900', 'ACTIVE', 16, 1, 1, 2115),
(211, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'économie numérique', '-1463318481', 'ACTIVE', 16, 1, 1, 2115),
(212, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'économie numérique', '-1022829091', 'ACTIVE', 15, 1, 1, 2116),
(213, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'économie numérique', '931341345', 'ACTIVE', 15, 1, 1, 2116),
(214, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'Introduction à la sécurité informatique', '-1080236608', 'ACTIVE', 9.63, 1, 1, 2117),
(215, '2019-08-10 15:43:53', '2019-08-10 15:43:53', NULL, 'Introduction à la sécurité informatique', '874857349', 'ACTIVE', 9.63, 1, 1, 2117),
(216, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Introduction à la sécurité informatique', '-1636541128', 'ACTIVE', 9.25, 1, 1, 2118),
(217, '2019-08-10 15:43:54', '2019-08-10 15:43:53', NULL, 'Introduction à la sécurité informatique', '319476350', 'ACTIVE', 9.25, 1, 1, 2118),
(218, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algorithmique et Complexité', '1489195763', 'ACTIVE', 11.83, 1, 1, 2119),
(219, '2019-08-10 15:43:54', '2019-08-10 15:43:53', NULL, 'Algorithmique et Complexité', '-848830534', 'ACTIVE', 11.83, 1, 1, 2119),
(220, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algorithmique et Complexité', '-785885150', 'ACTIVE', 15, 1, 1, 2120),
(221, '2019-08-10 15:43:54', '2019-08-10 15:43:53', NULL, 'Algorithmique et Complexité', '1171979370', 'ACTIVE', 15, 1, 1, 2120),
(222, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'modélisation des Systèmes d\'Information(UML)', '254562534', 'ACTIVE', 12.75, 1, 1, 2121),
(223, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2081616721', 'ACTIVE', 12.75, 1, 1, 2121),
(224, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'modélisation des Systèmes d\'Information(UML)', '2068905148', 'ACTIVE', 12, 1, 1, 2122),
(225, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'modélisation des Systèmes d\'Information(UML)', '-266350586', 'ACTIVE', 12, 1, 1, 2122),
(226, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algèbre linaire I', '-1333954323', 'ACTIVE', 14, 1, 1, 2123),
(227, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algèbre linaire I', '626680760', 'ACTIVE', 14, 1, 1, 2123),
(228, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algèbre linaire I', '-1260542380', 'ACTIVE', 11.5, 1, 1, 2124),
(229, '2019-08-10 15:43:54', '2019-08-10 15:43:54', NULL, 'Algèbre linaire I', '701016224', 'ACTIVE', 11.5, 1, 1, 2124),
(230, '2019-08-10 15:43:55', '2019-08-10 15:43:55', NULL, 'Programmation Orientée Objet II', '-1553410520', 'ACTIVE', 13.25, 1, 1, 2125),
(231, '2019-08-10 15:43:55', '2019-08-10 15:43:54', NULL, 'Programmation Orientée Objet II', '409071605', 'ACTIVE', 13.25, 1, 1, 2125),
(232, '2019-08-10 15:43:55', '2019-08-10 15:43:55', NULL, 'Programmation Orientée Objet II', '1613315165', 'ACTIVE', 12.5, 1, 1, 2126),
(233, '2019-08-10 15:43:55', '2019-08-10 15:43:54', NULL, 'Programmation Orientée Objet II', '-718246485', 'ACTIVE', 12.5, 1, 1, 2126),
(234, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Langage C++ et POO', '-1428734387', 'ACTIVE', 14.75, 1, 1, 2226),
(235, '2019-08-10 15:58:37', '2019-08-10 15:58:36', NULL, 'Langage C++ et POO', '627023359', 'ACTIVE', 14.75, 1, 1, 2226),
(236, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Langage C++ et POO', '2143923353', 'ACTIVE', 14.75, 1, 1, 2227),
(237, '2019-08-10 15:58:37', '2019-08-10 15:58:36', NULL, 'Langage C++ et POO', '-94362676', 'ACTIVE', 14.75, 1, 1, 2227),
(238, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Langage C++ et POO', '454921031', 'ACTIVE', 16, 1, 1, 2228),
(239, '2019-08-10 15:58:37', '2019-08-10 15:58:36', NULL, 'Langage C++ et POO', '-1782441477', 'ACTIVE', 16, 1, 1, 2228),
(240, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Algèbre linéaire II', '490421294', 'ACTIVE', 9.75, 1, 1, 2229),
(241, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Algèbre linéaire II', '-1746017693', 'ACTIVE', 9.75, 1, 1, 2229),
(242, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Algèbre linéaire II', '-1868578274', 'ACTIVE', 12, 1, 1, 2230),
(243, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Algèbre linéaire II', '190873556', 'ACTIVE', 12, 1, 1, 2230),
(244, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '-1022817022', 'ACTIVE', 6.5, 1, 1, 2231),
(245, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '1037558329', 'ACTIVE', 6.5, 1, 1, 2231),
(246, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '100578796', 'ACTIVE', 13, 1, 1, 2232),
(247, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '-2133089628', 'ACTIVE', 13, 1, 1, 2232),
(248, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '-2021842336', 'ACTIVE', 14.5, 1, 1, 2233),
(249, '2019-08-10 15:58:37', '2019-08-10 15:58:37', NULL, 'Programmation Web II', '40380057', 'ACTIVE', 14.5, 1, 1, 2233),
(250, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Anglais Niveau pratique B2', '-1910592548', 'ACTIVE', 11.1, 1, 1, 2234),
(251, '2019-08-10 15:58:38', '2019-08-10 15:58:37', NULL, 'Anglais Niveau pratique B2', '152553366', 'ACTIVE', 11.1, 1, 1, 2234),
(252, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Anglais Niveau pratique B2', '414950689', 'ACTIVE', 12.2, 1, 1, 2235),
(253, '2019-08-10 15:58:38', '2019-08-10 15:58:37', NULL, 'Anglais Niveau pratique B2', '-1815947172', 'ACTIVE', 12.2, 1, 1, 2235),
(254, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Ethique et Développement    ', '-1138069403', 'ACTIVE', 15.75, 1, 1, 2236),
(255, '2019-08-10 15:58:38', '2019-08-10 15:58:37', NULL, 'Ethique et Développement    ', '926923553', 'ACTIVE', 15.75, 1, 1, 2236),
(256, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Ethique et Développement    ', '682972360', 'ACTIVE', 14.5, 1, 1, 2237),
(257, '2019-08-10 15:58:38', '2019-08-10 15:58:37', NULL, 'Ethique et Développement    ', '-1546078459', 'ACTIVE', 14.5, 1, 1, 2237),
(258, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '813221434', 'ACTIVE', 15, 1, 1, 2238),
(259, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1414905864', 'ACTIVE', 15, 1, 1, 2238),
(260, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1962027043', 'ACTIVE', 16, 1, 1, 2239),
(261, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-265176734', 'ACTIVE', 16, 1, 1, 2239),
(262, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'économie numérique', '834794415', 'ACTIVE', 16, 1, 1, 2240),
(263, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'économie numérique', '-1391485841', 'ACTIVE', 16, 1, 1, 2240),
(264, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'économie numérique', '-733228794', 'ACTIVE', 15, 1, 1, 2241),
(265, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'économie numérique', '1336381767', 'ACTIVE', 15, 1, 1, 2241),
(266, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Introduction à la sécurité informatique', '-740190899', 'ACTIVE', 9.63, 1, 1, 2242),
(267, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Introduction à la sécurité informatique', '1330343183', 'ACTIVE', 9.63, 1, 1, 2242),
(268, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Introduction à la sécurité informatique', '172172413', 'ACTIVE', 9.25, 1, 1, 2243),
(269, '2019-08-10 15:58:38', '2019-08-10 15:58:38', NULL, 'Introduction à la sécurité informatique', '-2051337280', 'ACTIVE', 9.25, 1, 1, 2243),
(270, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algorithmique et Complexité', '-246087501', 'ACTIVE', 11.83, 1, 1, 2244),
(271, '2019-08-10 15:58:39', '2019-08-10 15:58:38', NULL, 'Algorithmique et Complexité', '1826293623', 'ACTIVE', 11.83, 1, 1, 2244),
(272, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algorithmique et Complexité', '-418422621', 'ACTIVE', 15, 1, 1, 2245),
(273, '2019-08-10 15:58:39', '2019-08-10 15:58:38', NULL, 'Algorithmique et Complexité', '1654882024', 'ACTIVE', 15, 1, 1, 2245),
(274, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'modélisation des Systèmes d\'Information(UML)', '1828472364', 'ACTIVE', 12.75, 1, 1, 2246),
(275, '2019-08-10 15:58:39', '2019-08-10 15:58:38', NULL, 'modélisation des Systèmes d\'Information(UML)', '-392266766', 'ACTIVE', 12.75, 1, 1, 2246),
(276, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'modélisation des Systèmes d\'Information(UML)', '2044934336', 'ACTIVE', 12, 1, 1, 2247),
(277, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'modélisation des Systèmes d\'Information(UML)', '-174881273', 'ACTIVE', 12, 1, 1, 2247),
(278, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algèbre linaire I', '-468874235', 'ACTIVE', 14, 1, 1, 2248),
(279, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algèbre linaire I', '1607200973', 'ACTIVE', 14, 1, 1, 2248),
(280, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algèbre linaire I', '718368467', 'ACTIVE', 11.5, 1, 1, 2249),
(281, '2019-08-10 15:58:39', '2019-08-10 15:58:39', NULL, 'Algèbre linaire I', '-1499600100', 'ACTIVE', 11.5, 1, 1, 2249),
(282, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Programmation Orientée Objet II', '-640965090', 'ACTIVE', 13.25, 1, 1, 2250),
(283, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Programmation Orientée Objet II', '1436957160', 'ACTIVE', 13.25, 1, 1, 2250),
(284, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Programmation Orientée Objet II', '1338607737', 'ACTIVE', 12.5, 1, 1, 2251),
(285, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Programmation Orientée Objet II', '-877513788', 'ACTIVE', 12.5, 1, 1, 2251),
(286, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Programmation Orientée Objet II', '992810727', 'ACTIVE', 17.75, 1, 1, 2252),
(287, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Programmation Orientée Objet II', '-1222387277', 'ACTIVE', 17.75, 1, 1, 2252),
(288, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Base de données', '-1836384318', 'ACTIVE', 12.25, 1, 1, 2253),
(289, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Introduction aux Base de données', '244308495', 'ACTIVE', 12.25, 1, 1, 2253),
(290, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Base de données', '-1364001498', 'ACTIVE', 9.25, 1, 1, 2254),
(291, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Introduction aux Base de données', '717614836', 'ACTIVE', 9.25, 1, 1, 2254),
(292, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Base de données', '-1806487357', 'ACTIVE', 12, 1, 1, 2255),
(293, '2019-08-10 15:58:40', '2019-08-10 15:58:39', NULL, 'Introduction aux Base de données', '276052498', 'ACTIVE', 12, 1, 1, 2255),
(294, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Réseaux informatiques', '-257391512', 'ACTIVE', 10, 1, 1, 2256),
(295, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Réseaux informatiques', '1826071864', 'ACTIVE', 10, 1, 1, 2256),
(296, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Réseaux informatiques', '-740129388', 'ACTIVE', 10.5, 1, 1, 2257),
(297, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Introduction aux Réseaux informatiques', '1344257509', 'ACTIVE', 10.5, 1, 1, 2257),
(298, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '-1877437363', 'ACTIVE', 13.5, 1, 1, 2258),
(299, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '207873055', 'ACTIVE', 13.5, 1, 1, 2258),
(300, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '1344852751', 'ACTIVE', 15, 1, 1, 2259),
(301, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '-863880606', 'ACTIVE', 15, 1, 1, 2259),
(302, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '-195475273', 'ACTIVE', 18.25, 1, 1, 2260),
(303, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Systèmes d\'exploitation', '1891682187', 'ACTIVE', 18.25, 1, 1, 2260),
(304, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Anglais niveau pratique B1/B2', '1876254793', 'ACTIVE', 16, 1, 1, 2261),
(305, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Anglais niveau pratique B1/B2', '-330631522', 'ACTIVE', 16, 1, 1, 2261),
(306, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Anglais niveau pratique B1/B2', '-2131799540', 'ACTIVE', 13.4, 1, 1, 2262),
(307, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Anglais niveau pratique B1/B2', '-42795038', 'ACTIVE', 13.4, 1, 1, 2262),
(308, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Éthique et Philosophie', '-1813140437', 'ACTIVE', 16.5, 1, 1, 2263),
(309, '2019-08-10 15:58:40', '2019-08-10 15:58:40', NULL, 'Éthique et Philosophie', '276787586', 'ACTIVE', 16.5, 1, 1, 2263),
(310, '2019-08-10 15:58:41', '2019-08-10 15:58:41', NULL, 'Éthique et Philosophie', '-443880736', 'ACTIVE', 16.5, 1, 1, 2264),
(311, '2019-08-10 15:58:41', '2019-08-10 15:58:40', NULL, 'Éthique et Philosophie', '1646970808', 'ACTIVE', 16.5, 1, 1, 2264),
(312, '2019-08-10 15:58:41', '2019-08-10 15:58:41', NULL, 'Langage C++ et POO', '2121995695', 'ACTIVE', 15.33, 1, 1, 2265),
(313, '2019-08-10 15:58:41', '2019-08-10 15:58:41', NULL, 'Langage C++ et POO', '-81196536', 'ACTIVE', 15.33, 1, 1, 2265),
(314, '2019-08-10 15:58:41', '2019-08-10 15:58:41', NULL, 'Langage C++ et POO', '-937820686', 'ACTIVE', 16, 1, 1, 2266),
(315, '2019-08-10 15:58:41', '2019-08-10 15:58:41', NULL, 'Langage C++ et POO', '1154877900', 'ACTIVE', 16, 1, 1, 2266),
(316, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Langage C++ et POO', '-274169516', 'ACTIVE', 16, 1, 1, 2267),
(317, '2019-08-10 15:58:42', '2019-08-10 15:58:41', NULL, 'Langage C++ et POO', '1819452591', 'ACTIVE', 16, 1, 1, 2267),
(318, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Algèbre linéaire II', '884554695', 'ACTIVE', 16.25, 1, 1, 2268),
(319, '2019-08-10 15:58:42', '2019-08-10 15:58:41', NULL, 'Algèbre linéaire II', '-1315866973', 'ACTIVE', 16.25, 1, 1, 2268),
(320, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Algèbre linéaire II', '-460401969', 'ACTIVE', 14, 1, 1, 2269),
(321, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Algèbre linéaire II', '1635067180', 'ACTIVE', 14, 1, 1, 2269),
(322, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Programmation Web II', '1672847713', 'ACTIVE', 14, 1, 1, 2270),
(323, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Programmation Web II', '-525726913', 'ACTIVE', 14, 1, 1, 2270),
(324, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Programmation Web II', '1429607024', 'ACTIVE', 16.5, 1, 1, 2271),
(325, '2019-08-10 15:58:42', '2019-08-10 15:58:42', NULL, 'Programmation Web II', '-768044081', 'ACTIVE', 16.5, 1, 1, 2271),
(326, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Programmation Web II', '1643838126', 'ACTIVE', 14.5, 1, 1, 2272),
(327, '2019-08-10 15:58:43', '2019-08-10 15:58:42', NULL, 'Programmation Web II', '-552889458', 'ACTIVE', 14.5, 1, 1, 2272),
(328, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Anglais Niveau pratique B2', '-61791624', 'ACTIVE', 12.5, 1, 1, 2273),
(329, '2019-08-10 15:58:43', '2019-08-10 15:58:42', NULL, 'Anglais Niveau pratique B2', '2037371609', 'ACTIVE', 12.5, 1, 1, 2273),
(330, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Anglais Niveau pratique B2', '1718501463', 'ACTIVE', 15.2, 1, 1, 2274),
(331, '2019-08-10 15:58:43', '2019-08-10 15:58:42', NULL, 'Anglais Niveau pratique B2', '-476379079', 'ACTIVE', 15.2, 1, 1, 2274),
(332, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Ethique et Développement    ', '-1379542807', 'ACTIVE', 13.5, 1, 1, 2275),
(333, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Ethique et Développement    ', '721467468', 'ACTIVE', 13.5, 1, 1, 2275),
(334, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Ethique et Développement    ', '-150081609', 'ACTIVE', 17.5, 1, 1, 2276),
(335, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'Ethique et Développement    ', '1951852187', 'ACTIVE', 17.5, 1, 1, 2276),
(336, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1972107741', 'ACTIVE', 14.33, 1, 1, 2277),
(337, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-220002238', 'ACTIVE', 14.33, 1, 1, 2277),
(338, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1279068962', 'ACTIVE', 13, 1, 1, 2278),
(339, '2019-08-10 15:58:43', '2019-08-10 15:58:43', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '824711876', 'ACTIVE', 13, 1, 1, 2278),
(340, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'économie numérique', '1275156707', 'ACTIVE', 18.17, 1, 1, 2279),
(341, '2019-08-10 15:58:44', '2019-08-10 15:58:43', NULL, 'économie numérique', '-915106230', 'ACTIVE', 18.17, 1, 1, 2279),
(342, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'économie numérique', '885239646', 'ACTIVE', 12.5, 1, 1, 2280),
(343, '2019-08-10 15:58:44', '2019-08-10 15:58:43', NULL, 'économie numérique', '-1304099770', 'ACTIVE', 12.5, 1, 1, 2280),
(344, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Introduction à la sécurité informatique', '-2040250746', 'ACTIVE', 12.88, 1, 1, 2281),
(345, '2019-08-10 15:58:44', '2019-08-10 15:58:43', NULL, 'Introduction à la sécurité informatique', '66300655', 'ACTIVE', 12.88, 1, 1, 2281),
(346, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Introduction à la sécurité informatique', '1328775122', 'ACTIVE', 11.5, 1, 1, 2282),
(347, '2019-08-10 15:58:44', '2019-08-10 15:58:43', NULL, 'Introduction à la sécurité informatique', '-858717252', 'ACTIVE', 11.5, 1, 1, 2282),
(348, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Algorithmique et Complexité', '-1976445194', 'ACTIVE', 12, 1, 1, 2283),
(349, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Algorithmique et Complexité', '131953249', 'ACTIVE', 12, 1, 1, 2283),
(350, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Algorithmique et Complexité', '1779662603', 'ACTIVE', 9, 1, 1, 2284),
(351, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'Algorithmique et Complexité', '-405982729', 'ACTIVE', 9, 1, 1, 2284),
(352, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'modélisation des Systèmes d\'Information(UML)', '-719765365', 'ACTIVE', 12.75, 1, 1, 2285),
(353, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'modélisation des Systèmes d\'Information(UML)', '1390480120', 'ACTIVE', 12.75, 1, 1, 2285),
(354, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2127573297', 'ACTIVE', 12, 1, 1, 2286),
(355, '2019-08-10 15:58:44', '2019-08-10 15:58:44', NULL, 'modélisation des Systèmes d\'Information(UML)', '-16404291', 'ACTIVE', 12, 1, 1, 2286),
(356, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Algèbre linaire I', '-738579693', 'ACTIVE', 18.33, 1, 1, 2287),
(357, '2019-08-10 15:58:45', '2019-08-10 15:58:44', NULL, 'Algèbre linaire I', '1373512834', 'ACTIVE', 18.33, 1, 1, 2287),
(358, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Algèbre linaire I', '-1524063225', 'ACTIVE', 19, 1, 1, 2288),
(359, '2019-08-10 15:58:45', '2019-08-10 15:58:44', NULL, 'Algèbre linaire I', '588952823', 'ACTIVE', 19, 1, 1, 2288),
(360, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Programmation Orientée Objet II', '617730264', 'ACTIVE', 14.75, 1, 1, 2289),
(361, '2019-08-10 15:58:45', '2019-08-10 15:58:44', NULL, 'Programmation Orientée Objet II', '-1563297463', 'ACTIVE', 14.75, 1, 1, 2289),
(362, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Programmation Orientée Objet II', '-565709976', 'ACTIVE', 7, 1, 1, 2290),
(363, '2019-08-10 15:58:45', '2019-08-10 15:58:44', NULL, 'Programmation Orientée Objet II', '1549153114', 'ACTIVE', 7, 1, 1, 2290),
(364, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Programmation Orientée Objet II', '-342050568', 'ACTIVE', 16.5, 1, 1, 2291),
(365, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Programmation Orientée Objet II', '1773736043', 'ACTIVE', 16.5, 1, 1, 2291),
(366, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Introduction aux Base de données', '2081683334', 'ACTIVE', 12.25, 1, 1, 2292),
(367, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Introduction aux Base de données', '-96573830', 'ACTIVE', 12.25, 1, 1, 2292),
(368, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Introduction aux Base de données', '-1346874934', 'ACTIVE', 17.25, 1, 1, 2293),
(369, '2019-08-10 15:58:45', '2019-08-10 15:58:45', NULL, 'Introduction aux Base de données', '770758719', 'ACTIVE', 17.25, 1, 1, 2293),
(370, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Base de données', '-118721087', 'ACTIVE', 16, 1, 1, 2301),
(371, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Base de données', '2006300734', 'ACTIVE', 16, 1, 1, 2301),
(372, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Réseaux informatiques', '-1735094099', 'ACTIVE', 9.5, 1, 1, 2302),
(373, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Réseaux informatiques', '390851243', 'ACTIVE', 9.5, 1, 1, 2302),
(374, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Réseaux informatiques', '-349965904', 'ACTIVE', 10.75, 1, 1, 2303),
(375, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Introduction aux Réseaux informatiques', '1776902959', 'ACTIVE', 10.75, 1, 1, 2303),
(376, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Systèmes d\'exploitation', '-1351520870', 'ACTIVE', 12.5, 1, 1, 2304),
(377, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Systèmes d\'exploitation', '776271514', 'ACTIVE', 12.5, 1, 1, 2304),
(378, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Systèmes d\'exploitation', '-1583470273', 'ACTIVE', 11, 1, 1, 2305),
(379, '2019-08-10 15:58:46', '2019-08-10 15:58:46', NULL, 'Systèmes d\'exploitation', '545245632', 'ACTIVE', 11, 1, 1, 2305),
(380, '2019-08-10 15:58:47', '2019-08-10 15:58:47', NULL, 'Systèmes d\'exploitation', '483877261', 'ACTIVE', 17.5, 1, 1, 2306),
(381, '2019-08-10 15:58:47', '2019-08-10 15:58:46', NULL, 'Systèmes d\'exploitation', '-1681450609', 'ACTIVE', 17.5, 1, 1, 2306),
(382, '2019-08-10 15:58:47', '2019-08-10 15:58:47', NULL, 'Anglais niveau pratique B1/B2', '1639366777', 'ACTIVE', 14.4, 1, 1, 2307),
(383, '2019-08-10 15:58:47', '2019-08-10 15:58:46', NULL, 'Anglais niveau pratique B1/B2', '-525037572', 'ACTIVE', 14.4, 1, 1, 2307),
(384, '2019-08-10 15:58:47', '2019-08-10 15:58:47', NULL, 'Anglais niveau pratique B1/B2', '-499497269', 'ACTIVE', 14, 1, 1, 2308),
(385, '2019-08-10 15:58:47', '2019-08-10 15:58:46', NULL, 'Anglais niveau pratique B1/B2', '1631989199', 'ACTIVE', 14, 1, 1, 2308),
(386, '2019-08-10 15:58:47', '2019-08-10 15:58:47', NULL, 'Éthique et Philosophie', '758293139', 'ACTIVE', 16, 1, 1, 2309),
(387, '2019-08-10 15:58:47', '2019-08-10 15:58:46', NULL, 'Éthique et Philosophie', '-1404264168', 'ACTIVE', 16, 1, 1, 2309),
(388, '2019-08-10 15:58:47', '2019-08-10 15:58:47', NULL, 'Éthique et Philosophie', '1601264860', 'ACTIVE', 14, 1, 1, 2310),
(389, '2019-08-10 15:58:47', '2019-08-10 15:58:46', NULL, 'Éthique et Philosophie', '-560368926', 'ACTIVE', 14, 1, 1, 2310),
(390, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Langage C++ et POO', '1154534471', 'ACTIVE', 14.75, 1, 1, 2401),
(391, '2019-08-10 16:02:17', '2019-08-10 16:02:16', NULL, 'Langage C++ et POO', '-923058904', 'ACTIVE', 14.75, 1, 1, 2401),
(392, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Langage C++ et POO', '-133482111', 'ACTIVE', 14.75, 1, 1, 2402),
(393, '2019-08-10 16:02:17', '2019-08-10 16:02:16', NULL, 'Langage C++ et POO', '2084815331', 'ACTIVE', 14.75, 1, 1, 2402),
(394, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Langage C++ et POO', '1896288231', 'ACTIVE', 16, 1, 1, 2403),
(395, '2019-08-10 16:02:17', '2019-08-10 16:02:16', NULL, 'Langage C++ et POO', '-179458102', 'ACTIVE', 16, 1, 1, 2403),
(396, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Algèbre linéaire II', '825547557', 'ACTIVE', 9.75, 1, 1, 2404),
(397, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Algèbre linéaire II', '-1249275255', 'ACTIVE', 9.75, 1, 1, 2404),
(398, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Algèbre linéaire II', '180476757', 'ACTIVE', 12, 1, 1, 2405),
(399, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Algèbre linéaire II', '-1893422534', 'ACTIVE', 12, 1, 1, 2405),
(400, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '632751288', 'ACTIVE', 6.5, 1, 1, 2406);
INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(401, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '-1440224482', 'ACTIVE', 6.5, 1, 1, 2406),
(402, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '-892577897', 'ACTIVE', 13, 1, 1, 2407),
(403, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '1330337150', 'ACTIVE', 13, 1, 1, 2407),
(404, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '-298929781', 'ACTIVE', 14.5, 1, 1, 2408),
(405, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Programmation Web II', '1924908787', 'ACTIVE', 14.5, 1, 1, 2408),
(406, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Anglais Niveau pratique B2', '1752276030', 'ACTIVE', 11.1, 1, 1, 2409),
(407, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Anglais Niveau pratique B2', '-317929177', 'ACTIVE', 11.1, 1, 1, 2409),
(408, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Anglais Niveau pratique B2', '-846465151', 'ACTIVE', 12.2, 1, 1, 2410),
(409, '2019-08-10 16:02:17', '2019-08-10 16:02:17', NULL, 'Anglais Niveau pratique B2', '1379220459', 'ACTIVE', 12.2, 1, 1, 2410),
(410, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Ethique et Développement    ', '-661592336', 'ACTIVE', 15.75, 1, 1, 2411),
(411, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'Ethique et Développement    ', '1565016795', 'ACTIVE', 15.75, 1, 1, 2411),
(412, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Ethique et Développement    ', '2090260426', 'ACTIVE', 14.5, 1, 1, 2412),
(413, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'Ethique et Développement    ', '22825782', 'ACTIVE', 14.5, 1, 1, 2412),
(414, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-512800811', 'ACTIVE', 15, 1, 1, 2413),
(415, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1715655362', 'ACTIVE', 15, 1, 1, 2413),
(416, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-744031728', 'ACTIVE', 16, 1, 1, 2414),
(417, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1485347966', 'ACTIVE', 16, 1, 1, 2414),
(418, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'économie numérique', '1189869200', 'ACTIVE', 16, 1, 1, 2415),
(419, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'économie numérique', '-874794881', 'ACTIVE', 16, 1, 1, 2415),
(420, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'économie numérique', '-1697227136', 'ACTIVE', 15, 1, 1, 2416),
(421, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'économie numérique', '533999600', 'ACTIVE', 15, 1, 1, 2416),
(422, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Introduction à la sécurité informatique', '1276374624', 'ACTIVE', 9.63, 1, 1, 2417),
(423, '2019-08-10 16:02:18', '2019-08-10 16:02:17', NULL, 'Introduction à la sécurité informatique', '-786442415', 'ACTIVE', 9.63, 1, 1, 2417),
(424, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Introduction à la sécurité informatique', '428097905', 'ACTIVE', 9.25, 1, 1, 2418),
(425, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Introduction à la sécurité informatique', '-1633795613', 'ACTIVE', 9.25, 1, 1, 2418),
(426, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Algorithmique et Complexité', '-755103168', 'ACTIVE', 11.83, 1, 1, 2419),
(427, '2019-08-10 16:02:18', '2019-08-10 16:02:18', NULL, 'Algorithmique et Complexité', '1478894131', 'ACTIVE', 11.83, 1, 1, 2419),
(428, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Algorithmique et Complexité', '-1326309546', 'ACTIVE', 15, 1, 1, 2451),
(429, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'Algorithmique et Complexité', '937240425', 'ACTIVE', 15, 1, 1, 2451),
(430, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1794426738', 'ACTIVE', 12.75, 1, 1, 2452),
(431, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'modélisation des Systèmes d\'Information(UML)', '470046754', 'ACTIVE', 12.75, 1, 1, 2452),
(432, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'modélisation des Systèmes d\'Information(UML)', '-866146097', 'ACTIVE', 12, 1, 1, 2453),
(433, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'modélisation des Systèmes d\'Information(UML)', '1399250916', 'ACTIVE', 12, 1, 1, 2453),
(434, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Algèbre linaire I', '2113056084', 'ACTIVE', 14, 1, 1, 2454),
(435, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'Algèbre linaire I', '84409322', 'ACTIVE', 14, 1, 1, 2454),
(436, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Algèbre linaire I', '-872954379', 'ACTIVE', 11.5, 1, 1, 2455),
(437, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'Algèbre linaire I', '1394289676', 'ACTIVE', 11.5, 1, 1, 2455),
(438, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Programmation Orientée Objet II', '-640415529', 'ACTIVE', 13.25, 1, 1, 2456),
(439, '2019-08-10 16:02:19', '2019-08-10 16:02:18', NULL, 'Programmation Orientée Objet II', '1627752047', 'ACTIVE', 13.25, 1, 1, 2456),
(440, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Programmation Orientée Objet II', '662847445', 'ACTIVE', 12.5, 1, 1, 2457),
(441, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Programmation Orientée Objet II', '-1363028754', 'ACTIVE', 12.5, 1, 1, 2457),
(442, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Programmation Orientée Objet II', '1195644110', 'ACTIVE', 17.75, 1, 1, 2458),
(443, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Programmation Orientée Objet II', '-829308568', 'ACTIVE', 17.75, 1, 1, 2458),
(444, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '512111210', 'ACTIVE', 12.25, 1, 1, 2459),
(445, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '-1511917947', 'ACTIVE', 12.25, 1, 1, 2459),
(446, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '-1481895673', 'ACTIVE', 9.25, 1, 1, 2460),
(447, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '789965987', 'ACTIVE', 9.25, 1, 1, 2460),
(448, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '1765354305', 'ACTIVE', 12, 1, 1, 2461),
(449, '2019-08-10 16:02:19', '2019-08-10 16:02:19', NULL, 'Introduction aux Base de données', '-256827810', 'ACTIVE', 12, 1, 1, 2461),
(450, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Introduction aux Réseaux informatiques', '-1512365744', 'ACTIVE', 10, 1, 1, 2462),
(451, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Introduction aux Réseaux informatiques', '761342958', 'ACTIVE', 10, 1, 1, 2462),
(452, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Introduction aux Réseaux informatiques', '1914780800', 'ACTIVE', 10.5, 1, 1, 2463),
(453, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Introduction aux Réseaux informatiques', '-105554273', 'ACTIVE', 10.5, 1, 1, 2463),
(454, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Systèmes d\'exploitation', '1559776571', 'ACTIVE', 13.5, 1, 1, 2464),
(455, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Systèmes d\'exploitation', '-459634981', 'ACTIVE', 13.5, 1, 1, 2464),
(456, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Systèmes d\'exploitation', '-342136326', 'ACTIVE', 15, 1, 1, 2465),
(457, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Systèmes d\'exploitation', '1934342939', 'ACTIVE', 15, 1, 1, 2465),
(458, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Systèmes d\'exploitation', '-1658148245', 'ACTIVE', 18.25, 1, 1, 2466),
(459, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Systèmes d\'exploitation', '619254541', 'ACTIVE', 18.25, 1, 1, 2466),
(460, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Anglais niveau pratique B1/B2', '-1166091830', 'ACTIVE', 16, 1, 1, 2467),
(461, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Anglais niveau pratique B1/B2', '1112234477', 'ACTIVE', 16, 1, 1, 2467),
(462, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Anglais niveau pratique B1/B2', '-333853736', 'ACTIVE', 13.4, 1, 1, 2468),
(463, '2019-08-10 16:02:20', '2019-08-10 16:02:19', NULL, 'Anglais niveau pratique B1/B2', '1945396092', 'ACTIVE', 13.4, 1, 1, 2468),
(464, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Éthique et Philosophie', '-371712475', 'ACTIVE', 16.5, 1, 1, 2469),
(465, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Éthique et Philosophie', '1908460874', 'ACTIVE', 16.5, 1, 1, 2469),
(466, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Éthique et Philosophie', '-1076755057', 'ACTIVE', 16.5, 1, 1, 2470),
(467, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Éthique et Philosophie', '1204341813', 'ACTIVE', 16.5, 1, 1, 2470),
(468, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '168740089', 'ACTIVE', 15.33, 1, 1, 2471),
(469, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '-1844206816', 'ACTIVE', 15.33, 1, 1, 2471),
(470, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '1913365089', 'ACTIVE', 16, 1, 1, 2472),
(471, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '-98658295', 'ACTIVE', 16, 1, 1, 2472),
(472, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '335578', 'ACTIVE', 16, 1, 1, 2473),
(473, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Langage C++ et POO', '-2010764285', 'ACTIVE', 16, 1, 1, 2473),
(474, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Algèbre linéaire II', '-2049835798', 'ACTIVE', 16.25, 1, 1, 2474),
(475, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Algèbre linéaire II', '234955156', 'ACTIVE', 16.25, 1, 1, 2474),
(476, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Algèbre linéaire II', '1696578811', 'ACTIVE', 14, 1, 1, 2475),
(477, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Algèbre linéaire II', '-312674010', 'ACTIVE', 14, 1, 1, 2475),
(478, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Programmation Web II', '-70001694', 'ACTIVE', 14, 1, 1, 2476),
(479, '2019-08-10 16:02:20', '2019-08-10 16:02:20', NULL, 'Programmation Web II', '-2078330994', 'ACTIVE', 14, 1, 1, 2476),
(480, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Programmation Web II', '-2144245967', 'ACTIVE', 16.5, 1, 1, 2477),
(481, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Programmation Web II', '143315550', 'ACTIVE', 16.5, 1, 1, 2477),
(482, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Programmation Web II', '-1834569340', 'ACTIVE', 14.5, 1, 1, 2478),
(483, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Programmation Web II', '453915698', 'ACTIVE', 14.5, 1, 1, 2478),
(484, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Anglais Niveau pratique B2', '1748444079', 'ACTIVE', 12.5, 1, 1, 2479),
(485, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Anglais Niveau pratique B2', '-257114658', 'ACTIVE', 12.5, 1, 1, 2479),
(486, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Anglais Niveau pratique B2', '-1382352187', 'ACTIVE', 15.2, 1, 1, 2480),
(487, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Anglais Niveau pratique B2', '907979893', 'ACTIVE', 15.2, 1, 1, 2480),
(488, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Ethique et Développement    ', '960739201', 'ACTIVE', 13.5, 1, 1, 2481),
(489, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Ethique et Développement    ', '-1042972494', 'ACTIVE', 13.5, 1, 1, 2481),
(490, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Ethique et Développement    ', '-395819674', 'ACTIVE', 17.5, 1, 1, 2482),
(491, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'Ethique et Développement    ', '1896359448', 'ACTIVE', 17.5, 1, 1, 2482),
(492, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1106744007', 'ACTIVE', 14.33, 1, 1, 2483),
(493, '2019-08-10 16:02:21', '2019-08-10 16:02:20', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1186358636', 'ACTIVE', 14.33, 1, 1, 2483),
(494, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-956825915', 'ACTIVE', 13, 1, 1, 2484),
(495, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1337200249', 'ACTIVE', 13, 1, 1, 2484),
(496, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'économie numérique', '-348594885', 'ACTIVE', 18.17, 1, 1, 2485),
(497, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'économie numérique', '1946354800', 'ACTIVE', 18.17, 1, 1, 2485),
(498, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'économie numérique', '-1750052580', 'ACTIVE', 12.5, 1, 1, 2486),
(499, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'économie numérique', '545820626', 'ACTIVE', 12.5, 1, 1, 2486),
(500, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Introduction à la sécurité informatique', '-856282476', 'ACTIVE', 12.88, 1, 1, 2487),
(501, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Introduction à la sécurité informatique', '1440514251', 'ACTIVE', 12.88, 1, 1, 2487),
(502, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Introduction à la sécurité informatique', '-754096286', 'ACTIVE', 11.5, 1, 1, 2488),
(503, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Introduction à la sécurité informatique', '1543623962', 'ACTIVE', 11.5, 1, 1, 2488),
(504, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Algorithmique et Complexité', '579718693', 'ACTIVE', 12, 1, 1, 2489),
(505, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Algorithmique et Complexité', '-1416604834', 'ACTIVE', 12, 1, 1, 2489),
(506, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Algorithmique et Complexité', '-536643596', 'ACTIVE', 9, 1, 1, 2490),
(507, '2019-08-10 16:02:21', '2019-08-10 16:02:21', NULL, 'Algorithmique et Complexité', '1762923694', 'ACTIVE', 9, 1, 1, 2490),
(508, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'modélisation des Systèmes d\'Information(UML)', '1782279723', 'ACTIVE', 12.75, 1, 1, 2491),
(509, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'modélisation des Systèmes d\'Information(UML)', '-212196762', 'ACTIVE', 12.75, 1, 1, 2491),
(510, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'modélisation des Systèmes d\'Information(UML)', '239813682', 'ACTIVE', 12, 1, 1, 2492),
(511, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1753739282', 'ACTIVE', 12, 1, 1, 2492),
(512, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Algèbre linaire I', '245812214', 'ACTIVE', 18.33, 1, 1, 2493),
(513, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Algèbre linaire I', '-1746817229', 'ACTIVE', 18.33, 1, 1, 2493),
(514, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Algèbre linaire I', '-1795255873', 'ACTIVE', 19, 1, 1, 2494),
(515, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Algèbre linaire I', '508005501', 'ACTIVE', 19, 1, 1, 2494),
(516, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Programmation Orientée Objet II', '-1646761603', 'ACTIVE', 14.75, 1, 1, 2495),
(517, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Programmation Orientée Objet II', '657423292', 'ACTIVE', 14.75, 1, 1, 2495),
(518, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Programmation Orientée Objet II', '-1619366314', 'ACTIVE', 7, 1, 1, 2496),
(519, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Programmation Orientée Objet II', '685742102', 'ACTIVE', 7, 1, 1, 2496),
(520, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Programmation Orientée Objet II', '1180570783', 'ACTIVE', 16.5, 1, 1, 2497),
(521, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Programmation Orientée Objet II', '-808364576', 'ACTIVE', 16.5, 1, 1, 2497),
(522, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Base de données', '-729190735', 'ACTIVE', 12.25, 1, 1, 2498),
(523, '2019-08-10 16:02:22', '2019-08-10 16:02:21', NULL, 'Introduction aux Base de données', '1577764723', 'ACTIVE', 12.25, 1, 1, 2498),
(524, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Base de données', '580717053', 'ACTIVE', 17.25, 1, 1, 2499),
(525, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Base de données', '-1406371264', 'ACTIVE', 17.25, 1, 1, 2499),
(526, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Base de données', '-747488648', 'ACTIVE', 16, 1, 1, 2500),
(527, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Base de données', '1561313852', 'ACTIVE', 16, 1, 1, 2500),
(528, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Réseaux informatiques', '-587007256', 'ACTIVE', 9.5, 1, 1, 2501),
(529, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Réseaux informatiques', '1722718765', 'ACTIVE', 9.5, 1, 1, 2501),
(530, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Réseaux informatiques', '-818369686', 'ACTIVE', 10.75, 1, 1, 2502),
(531, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Introduction aux Réseaux informatiques', '1492279856', 'ACTIVE', 10.75, 1, 1, 2502),
(532, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '-1041788428', 'ACTIVE', 12.5, 1, 1, 2503),
(533, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '1269784635', 'ACTIVE', 12.5, 1, 1, 2503),
(534, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '-1499734705', 'ACTIVE', 11, 1, 1, 2504),
(535, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '812761879', 'ACTIVE', 11, 1, 1, 2504),
(536, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '196812470', 'ACTIVE', 17.5, 1, 1, 2505),
(537, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Systèmes d\'exploitation', '-1784734721', 'ACTIVE', 17.5, 1, 1, 2505),
(538, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Anglais niveau pratique B1/B2', '-1862411511', 'ACTIVE', 14.4, 1, 1, 2506),
(539, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Anglais niveau pratique B1/B2', '451932115', 'ACTIVE', 14.4, 1, 1, 2506),
(540, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Anglais niveau pratique B1/B2', '-902267956', 'ACTIVE', 14, 1, 1, 2507),
(541, '2019-08-10 16:02:22', '2019-08-10 16:02:22', NULL, 'Anglais niveau pratique B1/B2', '1412999191', 'ACTIVE', 14, 1, 1, 2507),
(542, '2019-08-10 16:02:23', '2019-08-10 16:02:23', NULL, 'Éthique et Philosophie', '-795779360', 'ACTIVE', 16, 1, 1, 2508),
(543, '2019-08-10 16:02:23', '2019-08-10 16:02:22', NULL, 'Éthique et Philosophie', '1520411308', 'ACTIVE', 16, 1, 1, 2508),
(544, '2019-08-10 16:02:23', '2019-08-10 16:02:23', NULL, 'Éthique et Philosophie', '-938330754', 'ACTIVE', 14, 1, 1, 2509),
(545, '2019-08-10 16:02:23', '2019-08-10 16:02:22', NULL, 'Éthique et Philosophie', '1378783435', 'ACTIVE', 14, 1, 1, 2509),
(546, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Langage C++ et POO', '-1037019604', 'ACTIVE', 14.75, 1, 1, 2601),
(547, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Langage C++ et POO', '1365058517', 'ACTIVE', 14.75, 1, 1, 2601),
(548, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Langage C++ et POO', '-1497169391', 'ACTIVE', 14.75, 1, 1, 2602),
(549, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Langage C++ et POO', '905832251', 'ACTIVE', 14.75, 1, 1, 2602),
(550, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Langage C++ et POO', '246043670', 'ACTIVE', 16, 1, 1, 2603),
(551, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Langage C++ et POO', '-1644998463', 'ACTIVE', 16, 1, 1, 2603),
(552, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Algèbre linéaire II', '-735381238', 'ACTIVE', 9.75, 1, 1, 2604),
(553, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Algèbre linéaire II', '1669467446', 'ACTIVE', 9.75, 1, 1, 2604),
(554, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Algèbre linéaire II', '-1469767804', 'ACTIVE', 12, 1, 1, 2605),
(555, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Algèbre linéaire II', '936004401', 'ACTIVE', 12, 1, 1, 2605),
(556, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Programmation Web II', '1445474130', 'ACTIVE', 6.5, 1, 1, 2606),
(557, '2019-08-10 16:08:16', '2019-08-10 16:08:15', NULL, 'Programmation Web II', '-442797440', 'ACTIVE', 6.5, 1, 1, 2606),
(558, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Programmation Web II', '1381686709', 'ACTIVE', 13, 1, 1, 2607),
(559, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Programmation Web II', '-505661340', 'ACTIVE', 13, 1, 1, 2607),
(560, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Programmation Web II', '95969590', 'ACTIVE', 14.5, 1, 1, 2608),
(561, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Programmation Web II', '-1790454938', 'ACTIVE', 14.5, 1, 1, 2608),
(562, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Anglais Niveau pratique B2', '-944052053', 'ACTIVE', 11.1, 1, 1, 2609),
(563, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Anglais Niveau pratique B2', '1465414236', 'ACTIVE', 11.1, 1, 1, 2609),
(564, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Anglais Niveau pratique B2', '427968', 'ACTIVE', 12.2, 1, 1, 2610),
(565, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Anglais Niveau pratique B2', '-1884149518', 'ACTIVE', 12.2, 1, 1, 2610),
(566, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Ethique et Développement    ', '1935765057', 'ACTIVE', 15.75, 1, 1, 2611),
(567, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Ethique et Développement    ', '52111092', 'ACTIVE', 15.75, 1, 1, 2611),
(568, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Ethique et Développement    ', '221799138', 'ACTIVE', 14.5, 1, 1, 2612),
(569, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'Ethique et Développement    ', '-1660931306', 'ACTIVE', 14.5, 1, 1, 2612),
(570, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1393370895', 'ACTIVE', 15, 1, 1, 2613),
(571, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-488436028', 'ACTIVE', 15, 1, 1, 2613),
(572, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '649585823', 'ACTIVE', 16, 1, 1, 2614),
(573, '2019-08-10 16:08:16', '2019-08-10 16:08:16', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1231297579', 'ACTIVE', 16, 1, 1, 2614),
(574, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'économie numérique', '-1992622908', 'ACTIVE', 16, 1, 1, 2615),
(575, '2019-08-10 16:08:17', '2019-08-10 16:08:16', NULL, 'économie numérique', '422384507', 'ACTIVE', 16, 1, 1, 2615),
(576, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'économie numérique', '-823943887', 'ACTIVE', 15, 1, 1, 2616),
(577, '2019-08-10 16:08:17', '2019-08-10 16:08:16', NULL, 'économie numérique', '1591987049', 'ACTIVE', 15, 1, 1, 2616),
(578, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Introduction à la sécurité informatique', '961478325', 'ACTIVE', 9.63, 1, 1, 2617),
(579, '2019-08-10 16:08:17', '2019-08-10 16:08:16', NULL, 'Introduction à la sécurité informatique', '-916634514', 'ACTIVE', 9.63, 1, 1, 2617),
(580, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Introduction à la sécurité informatique', '-1508703937', 'ACTIVE', 9.25, 1, 1, 2618),
(581, '2019-08-10 16:08:17', '2019-08-10 16:08:16', NULL, 'Introduction à la sécurité informatique', '909074041', 'ACTIVE', 9.25, 1, 1, 2618),
(582, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Algorithmique et Complexité', '543783699', 'ACTIVE', 11.83, 1, 1, 2619),
(583, '2019-08-10 16:08:17', '2019-08-10 16:08:16', NULL, 'Algorithmique et Complexité', '-1332482098', 'ACTIVE', 11.83, 1, 1, 2619),
(584, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Algorithmique et Complexité', '-721315825', 'ACTIVE', 15, 1, 1, 2651),
(585, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Algorithmique et Complexité', '1726938346', 'ACTIVE', 15, 1, 1, 2651),
(586, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1121092463', 'ACTIVE', 12.75, 1, 1, 2652),
(587, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'modélisation des Systèmes d\'Information(UML)', '1328085229', 'ACTIVE', 12.75, 1, 1, 2652),
(588, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'modélisation des Systèmes d\'Information(UML)', '-282127588', 'ACTIVE', 12, 1, 1, 2653),
(589, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'modélisation des Systèmes d\'Information(UML)', '-2126993671', 'ACTIVE', 12, 1, 1, 2653),
(590, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Algèbre linaire I', '1198997323', 'ACTIVE', 14, 1, 1, 2654),
(591, '2019-08-10 16:08:17', '2019-08-10 16:08:17', NULL, 'Algèbre linaire I', '-644945239', 'ACTIVE', 14, 1, 1, 2654),
(592, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Algèbre linaire I', '-1185143219', 'ACTIVE', 11.5, 1, 1, 2655),
(593, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Algèbre linaire I', '1266805036', 'ACTIVE', 11.5, 1, 1, 2655),
(594, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Programmation Orientée Objet II', '-358514595', 'ACTIVE', 13.25, 1, 1, 2656),
(595, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Programmation Orientée Objet II', '2094357181', 'ACTIVE', 13.25, 1, 1, 2656),
(596, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Programmation Orientée Objet II', '905163184', 'ACTIVE', 12.5, 1, 1, 2657),
(597, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Programmation Orientée Objet II', '-936008815', 'ACTIVE', 12.5, 1, 1, 2657),
(598, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Programmation Orientée Objet II', '1834808108', 'ACTIVE', 17.75, 1, 1, 2658),
(599, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Programmation Orientée Objet II', '-5440370', 'ACTIVE', 17.75, 1, 1, 2658),
(600, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Base de données', '1937191579', 'ACTIVE', 12.25, 1, 1, 2659),
(601, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Introduction aux Base de données', '97866622', 'ACTIVE', 12.25, 1, 1, 2659),
(602, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Base de données', '-1373553583', 'ACTIVE', 9.25, 1, 1, 2660),
(603, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Introduction aux Base de données', '1083012277', 'ACTIVE', 9.25, 1, 1, 2660),
(604, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Base de données', '-242153320', 'ACTIVE', 12, 1, 1, 2661),
(605, '2019-08-10 16:08:18', '2019-08-10 16:08:17', NULL, 'Introduction aux Base de données', '-2079631235', 'ACTIVE', 12, 1, 1, 2661),
(606, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Réseaux informatiques', '399220880', 'ACTIVE', 10, 1, 1, 2662),
(607, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Réseaux informatiques', '-1437333514', 'ACTIVE', 10, 1, 1, 2662),
(608, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Réseaux informatiques', '-84946678', 'ACTIVE', 10.5, 1, 1, 2663),
(609, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Introduction aux Réseaux informatiques', '-1920577551', 'ACTIVE', 10.5, 1, 1, 2663),
(610, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '154138867', 'ACTIVE', 13.5, 1, 1, 2664),
(611, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '-1680568485', 'ACTIVE', 13.5, 1, 1, 2664),
(612, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '-1206464516', 'ACTIVE', 15, 1, 1, 2665),
(613, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '1254718949', 'ACTIVE', 15, 1, 1, 2665),
(614, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '-1936166808', 'ACTIVE', 18.25, 1, 1, 2666),
(615, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Systèmes d\'exploitation', '525940178', 'ACTIVE', 18.25, 1, 1, 2666),
(616, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Anglais niveau pratique B1/B2', '1402510204', 'ACTIVE', 16, 1, 1, 2667),
(617, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Anglais niveau pratique B1/B2', '-429426585', 'ACTIVE', 16, 1, 1, 2667),
(618, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Anglais niveau pratique B1/B2', '-1431958947', 'ACTIVE', 13.4, 1, 1, 2668),
(619, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Anglais niveau pratique B1/B2', '1031995081', 'ACTIVE', 13.4, 1, 1, 2668),
(620, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Éthique et Philosophie', '-1354111790', 'ACTIVE', 16.5, 1, 1, 2669),
(621, '2019-08-10 16:08:18', '2019-08-10 16:08:18', NULL, 'Éthique et Philosophie', '1110765759', 'ACTIVE', 16.5, 1, 1, 2669),
(622, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Éthique et Philosophie', '-1764816944', 'ACTIVE', 16.5, 1, 1, 2670),
(623, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Éthique et Philosophie', '700984126', 'ACTIVE', 16.5, 1, 1, 2670),
(624, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Langage C++ et POO', '-1352603511', 'ACTIVE', 15.33, 1, 1, 2671),
(625, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Langage C++ et POO', '1114121080', 'ACTIVE', 15.33, 1, 1, 2671),
(626, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Langage C++ et POO', '1806197911', 'ACTIVE', 16, 1, 1, 2672),
(627, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Langage C++ et POO', '-21121273', 'ACTIVE', 16, 1, 1, 2672),
(628, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Langage C++ et POO', '-619385755', 'ACTIVE', 16, 1, 1, 2673),
(629, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Langage C++ et POO', '1849185878', 'ACTIVE', 16, 1, 1, 2673),
(630, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Algèbre linéaire II', '2103794043', 'ACTIVE', 16.25, 1, 1, 2674),
(631, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Algèbre linéaire II', '278321901', 'ACTIVE', 16.25, 1, 1, 2674),
(632, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Algèbre linéaire II', '-1372914860', 'ACTIVE', 14, 1, 1, 2675),
(633, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Algèbre linéaire II', '1097503815', 'ACTIVE', 14, 1, 1, 2675),
(634, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Programmation Web II', '711258330', 'ACTIVE', 14, 1, 1, 2676),
(635, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Programmation Web II', '-1112366770', 'ACTIVE', 14, 1, 1, 2676),
(636, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Programmation Web II', '-816261511', 'ACTIVE', 16.5, 1, 1, 2677),
(637, '2019-08-10 16:08:19', '2019-08-10 16:08:18', NULL, 'Programmation Web II', '1656004206', 'ACTIVE', 16.5, 1, 1, 2677),
(638, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Programmation Web II', '-1429182363', 'ACTIVE', 14.5, 1, 1, 2678),
(639, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Programmation Web II', '1044006875', 'ACTIVE', 14.5, 1, 1, 2678),
(640, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Anglais Niveau pratique B2', '-692789541', 'ACTIVE', 12.5, 1, 1, 2679),
(641, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Anglais Niveau pratique B2', '1781323218', 'ACTIVE', 12.5, 1, 1, 2679),
(642, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Anglais Niveau pratique B2', '-737773271', 'ACTIVE', 15.2, 1, 1, 2680),
(643, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Anglais Niveau pratique B2', '1737263009', 'ACTIVE', 15.2, 1, 1, 2680),
(644, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Ethique et Développement    ', '-1391178653', 'ACTIVE', 13.5, 1, 1, 2681),
(645, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Ethique et Développement    ', '1084781148', 'ACTIVE', 13.5, 1, 1, 2681),
(646, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Ethique et Développement    ', '1854762261', 'ACTIVE', 17.5, 1, 1, 2682),
(647, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'Ethique et Développement    ', '36678287', 'ACTIVE', 17.5, 1, 1, 2682),
(648, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1212178482', 'ACTIVE', 14.33, 1, 1, 2683),
(649, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-604981971', 'ACTIVE', 14.33, 1, 1, 2683),
(650, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1293756020', 'ACTIVE', 13, 1, 1, 2684),
(651, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-522480912', 'ACTIVE', 13, 1, 1, 2684),
(652, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'économie numérique', '-1812085537', 'ACTIVE', 18.17, 1, 1, 2685),
(653, '2019-08-10 16:08:19', '2019-08-10 16:08:19', NULL, 'économie numérique', '667568348', 'ACTIVE', 18.17, 1, 1, 2685),
(654, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'économie numérique', '329677970', 'ACTIVE', 12.5, 1, 1, 2686),
(655, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'économie numérique', '-1484711920', 'ACTIVE', 12.5, 1, 1, 2686),
(656, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction à la sécurité informatique', '1120937243', 'ACTIVE', 12.88, 1, 1, 2687),
(657, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Introduction à la sécurité informatique', '-692529126', 'ACTIVE', 12.88, 1, 1, 2687),
(658, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction à la sécurité informatique', '1325634264', 'ACTIVE', 11.5, 1, 1, 2688),
(659, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Introduction à la sécurité informatique', '-486908584', 'ACTIVE', 11.5, 1, 1, 2688),
(660, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Algorithmique et Complexité', '454283762', 'ACTIVE', 12, 1, 1, 2689),
(661, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Algorithmique et Complexité', '-1357335565', 'ACTIVE', 12, 1, 1, 2689),
(662, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Algorithmique et Complexité', '29107160', 'ACTIVE', 9, 1, 1, 2690),
(663, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Algorithmique et Complexité', '-1781588646', 'ACTIVE', 9, 1, 1, 2690),
(664, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'modélisation des Systèmes d\'Information(UML)', '1698795216', 'ACTIVE', 12.75, 1, 1, 2691),
(665, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'modélisation des Systèmes d\'Information(UML)', '-110977069', 'ACTIVE', 12.75, 1, 1, 2691),
(666, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'modélisation des Systèmes d\'Information(UML)', '608322923', 'ACTIVE', 12, 1, 1, 2692),
(667, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1200525841', 'ACTIVE', 12, 1, 1, 2692),
(668, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Algèbre linaire I', '1741940596', 'ACTIVE', 18.33, 1, 1, 2693),
(669, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Algèbre linaire I', '-65984647', 'ACTIVE', 18.33, 1, 1, 2693),
(670, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Algèbre linaire I', '-1174359628', 'ACTIVE', 19, 1, 1, 2694),
(671, '2019-08-10 16:08:20', '2019-08-10 16:08:19', NULL, 'Algèbre linaire I', '1313605946', 'ACTIVE', 19, 1, 1, 2694),
(672, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '1983826477', 'ACTIVE', 14.75, 1, 1, 2695),
(673, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '177748276', 'ACTIVE', 14.75, 1, 1, 2695),
(674, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '-2023578379', 'ACTIVE', 7, 1, 1, 2696),
(675, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '466234237', 'ACTIVE', 7, 1, 1, 2696),
(676, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '64197819', 'ACTIVE', 16.5, 1, 1, 2697),
(677, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Programmation Orientée Objet II', '-1740033340', 'ACTIVE', 16.5, 1, 1, 2697),
(678, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '-689189199', 'ACTIVE', 12.25, 1, 1, 2698),
(679, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '1802470459', 'ACTIVE', 12.25, 1, 1, 2698),
(680, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '-1211281304', 'ACTIVE', 17.25, 1, 1, 2699),
(681, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '1281301875', 'ACTIVE', 17.25, 1, 1, 2699),
(682, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '-1185870990', 'ACTIVE', 16, 1, 1, 2700),
(683, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Base de données', '1307635710', 'ACTIVE', 16, 1, 1, 2700),
(684, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Réseaux informatiques', '2005277449', 'ACTIVE', 9.5, 1, 1, 2701),
(685, '2019-08-10 16:08:20', '2019-08-10 16:08:20', NULL, 'Introduction aux Réseaux informatiques', '204740374', 'ACTIVE', 9.5, 1, 1, 2701),
(686, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Introduction aux Réseaux informatiques', '2115617789', 'ACTIVE', 10.75, 1, 1, 2702),
(687, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Introduction aux Réseaux informatiques', '316004235', 'ACTIVE', 10.75, 1, 1, 2702),
(688, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Systèmes d\'exploitation', '1789688216', 'ACTIVE', 12.5, 1, 1, 2703),
(689, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Systèmes d\'exploitation', '-9001817', 'ACTIVE', 12.5, 1, 1, 2703),
(690, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Systèmes d\'exploitation', '819187784', 'ACTIVE', 11, 1, 1, 2704),
(691, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Systèmes d\'exploitation', '-978578728', 'ACTIVE', 11, 1, 1, 2704),
(692, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Systèmes d\'exploitation', '1388115818', 'ACTIVE', 17.5, 1, 1, 2705),
(693, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Systèmes d\'exploitation', '-408727173', 'ACTIVE', 17.5, 1, 1, 2705),
(694, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Anglais niveau pratique B1/B2', '-841959548', 'ACTIVE', 14.4, 1, 1, 2706),
(695, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Anglais niveau pratique B1/B2', '1657088278', 'ACTIVE', 14.4, 1, 1, 2706),
(696, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Anglais niveau pratique B1/B2', '869930101', 'ACTIVE', 14, 1, 1, 2707),
(697, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Anglais niveau pratique B1/B2', '-925065848', 'ACTIVE', 14, 1, 1, 2707),
(698, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Éthique et Philosophie', '-1244649308', 'ACTIVE', 16, 1, 1, 2708),
(699, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Éthique et Philosophie', '1256245560', 'ACTIVE', 16, 1, 1, 2708),
(700, '2019-08-10 16:08:21', '2019-08-10 16:08:21', NULL, 'Éthique et Philosophie', '-54559899', 'ACTIVE', 14, 1, 1, 2709),
(701, '2019-08-10 16:08:21', '2019-08-10 16:08:20', NULL, 'Éthique et Philosophie', '-1847708806', 'ACTIVE', 14, 1, 1, 2709),
(702, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Langage C++ et POO', '-1282806546', 'ACTIVE', 14.75, 1, 1, 3751),
(703, '2019-08-10 17:44:23', '2019-08-10 17:44:22', NULL, 'Langage C++ et POO', '-2113646571', 'ACTIVE', 14.75, 1, 1, 3751),
(704, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Langage C++ et POO', '-1658713255', 'ACTIVE', 14.75, 1, 1, 3752),
(705, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Langage C++ et POO', '1806337537', 'ACTIVE', 14.75, 1, 1, 3752),
(706, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Langage C++ et POO', '484055524', 'ACTIVE', 16, 1, 1, 3753),
(707, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Langage C++ et POO', '-344937459', 'ACTIVE', 16, 1, 1, 3753),
(708, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Algèbre linéaire II', '-1557101018', 'ACTIVE', 9.75, 1, 1, 3754),
(709, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Algèbre linéaire II', '1909796816', 'ACTIVE', 9.75, 1, 1, 3754),
(710, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Algèbre linéaire II', '1580241323', 'ACTIVE', 12, 1, 1, 3755),
(711, '2019-08-10 17:44:23', '2019-08-10 17:44:23', NULL, 'Algèbre linéaire II', '753095382', 'ACTIVE', 12, 1, 1, 3755),
(712, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '1822329513', 'ACTIVE', 6.5, 1, 1, 3801),
(713, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '1037665538', 'ACTIVE', 6.5, 1, 1, 3801),
(714, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '-94433013', 'ACTIVE', 13, 1, 1, 3802),
(715, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '-878173467', 'ACTIVE', 13, 1, 1, 3802),
(716, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '1671492127', 'ACTIVE', 14.5, 1, 1, 3803),
(717, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Programmation Web II', '888675194', 'ACTIVE', 14.5, 1, 1, 3803),
(718, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Anglais Niveau pratique B2', '1408640268', 'ACTIVE', 11.1, 1, 1, 3804),
(719, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Anglais Niveau pratique B2', '626746856', 'ACTIVE', 11.1, 1, 1, 3804),
(720, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Anglais Niveau pratique B2', '1519838576', 'ACTIVE', 12.2, 1, 1, 3805),
(721, '2019-08-10 17:44:24', '2019-08-10 17:44:24', NULL, 'Anglais Niveau pratique B2', '738868685', 'ACTIVE', 12.2, 1, 1, 3805),
(722, '2019-08-10 17:44:25', '2019-08-10 17:44:25', NULL, 'Ethique et Développement    ', '-304171112', 'ACTIVE', 15.75, 1, 1, 3806),
(723, '2019-08-10 17:44:25', '2019-08-10 17:44:24', NULL, 'Ethique et Développement    ', '-1084217482', 'ACTIVE', 15.75, 1, 1, 3806),
(724, '2019-08-10 17:44:25', '2019-08-10 17:44:25', NULL, 'Ethique et Développement    ', '-1705531850', 'ACTIVE', 14.5, 1, 1, 3807),
(725, '2019-08-10 17:44:25', '2019-08-10 17:44:25', NULL, 'Ethique et Développement    ', '1810312597', 'ACTIVE', 14.5, 1, 1, 3807),
(726, '2019-08-10 17:44:25', '2019-08-10 17:44:25', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-310484842', 'ACTIVE', 15, 1, 1, 3808),
(727, '2019-08-10 17:44:25', '2019-08-10 17:44:25', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '-1088684170', 'ACTIVE', 15, 1, 1, 3808),
(728, '2019-08-10 17:44:26', '2019-08-10 17:44:26', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '872460663', 'ACTIVE', 16, 1, 1, 3809),
(729, '2019-08-10 17:44:26', '2019-08-10 17:44:25', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '95184856', 'ACTIVE', 16, 1, 1, 3809),
(730, '2019-08-10 17:44:26', '2019-08-10 17:44:26', NULL, 'économie numérique', '-1394482766', 'ACTIVE', 16, 1, 1, 3810),
(731, '2019-08-10 17:44:26', '2019-08-10 17:44:25', NULL, 'économie numérique', '2124132244', 'ACTIVE', 16, 1, 1, 3810),
(732, '2019-08-10 17:44:26', '2019-08-10 17:44:26', NULL, 'économie numérique', '-1592614825', 'ACTIVE', 15, 1, 1, 3811),
(733, '2019-08-10 17:44:26', '2019-08-10 17:44:26', NULL, 'économie numérique', '1926923706', 'ACTIVE', 15, 1, 1, 3811),
(734, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Introduction à la sécurité informatique', '548819016', 'ACTIVE', 9.63, 1, 1, 3812),
(735, '2019-08-10 17:44:27', '2019-08-10 17:44:26', NULL, 'Introduction à la sécurité informatique', '-225686228', 'ACTIVE', 9.63, 1, 1, 3812),
(736, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Introduction à la sécurité informatique', '1813684553', 'ACTIVE', 9.25, 1, 1, 3813),
(737, '2019-08-10 17:44:27', '2019-08-10 17:44:26', NULL, 'Introduction à la sécurité informatique', '1040102830', 'ACTIVE', 9.25, 1, 1, 3813),
(738, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Algorithmique et Complexité', '1675333926', 'ACTIVE', 11.83, 1, 1, 3814),
(739, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Algorithmique et Complexité', '902675724', 'ACTIVE', 11.83, 1, 1, 3814),
(740, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Algorithmique et Complexité', '-1306059595', 'ACTIVE', 15, 1, 1, 3815),
(741, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'Algorithmique et Complexité', '-2077794276', 'ACTIVE', 15, 1, 1, 3815),
(742, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'modélisation des Systèmes d\'Information(UML)', '-929436212', 'ACTIVE', 12.75, 1, 1, 3816),
(743, '2019-08-10 17:44:27', '2019-08-10 17:44:27', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1700247372', 'ACTIVE', 12.75, 1, 1, 3816),
(744, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'modélisation des Systèmes d\'Information(UML)', '966099791', 'ACTIVE', 12, 1, 1, 3817),
(745, '2019-08-10 17:44:28', '2019-08-10 17:44:27', NULL, 'modélisation des Systèmes d\'Information(UML)', '196212152', 'ACTIVE', 12, 1, 1, 3817),
(746, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Algèbre linaire I', '736380328', 'ACTIVE', 14, 1, 1, 3818),
(747, '2019-08-10 17:44:28', '2019-08-10 17:44:27', NULL, 'Algèbre linaire I', '-32583790', 'ACTIVE', 14, 1, 1, 3818),
(748, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Algèbre linaire I', '-1868684400', 'ACTIVE', 11.5, 1, 1, 3819),
(749, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Algèbre linaire I', '1658242299', 'ACTIVE', 11.5, 1, 1, 3819),
(750, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '-2047141136', 'ACTIVE', 13.25, 1, 1, 3820),
(751, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '1480709084', 'ACTIVE', 13.25, 1, 1, 3820),
(752, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '257547477', 'ACTIVE', 12.5, 1, 1, 3821),
(753, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '-508646078', 'ACTIVE', 12.5, 1, 1, 3821),
(754, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '156669173', 'ACTIVE', 17.75, 1, 1, 3822),
(755, '2019-08-10 17:44:28', '2019-08-10 17:44:28', NULL, 'Programmation Orientée Objet II', '-608600861', 'ACTIVE', 17.75, 1, 1, 3822),
(756, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Base de données', '-220127586', 'ACTIVE', 12.25, 1, 1, 3823),
(757, '2019-08-10 17:44:29', '2019-08-10 17:44:28', NULL, 'Introduction aux Base de données', '-984474099', 'ACTIVE', 12.25, 1, 1, 3823),
(758, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Base de données', '-397694870', 'ACTIVE', 9.25, 1, 1, 3824),
(759, '2019-08-10 17:44:29', '2019-08-10 17:44:28', NULL, 'Introduction aux Base de données', '-1161117862', 'ACTIVE', 9.25, 1, 1, 3824),
(760, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Base de données', '55372541', 'ACTIVE', 12, 1, 1, 3825),
(761, '2019-08-10 17:44:29', '2019-08-10 17:44:28', NULL, 'Introduction aux Base de données', '-707126930', 'ACTIVE', 12, 1, 1, 3825),
(762, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Réseaux informatiques', '-618867287', 'ACTIVE', 10, 1, 1, 3826),
(763, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Réseaux informatiques', '-1380443237', 'ACTIVE', 10, 1, 1, 3826),
(764, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Réseaux informatiques', '2101191046', 'ACTIVE', 10.5, 1, 1, 3827),
(765, '2019-08-10 17:44:29', '2019-08-10 17:44:29', NULL, 'Introduction aux Réseaux informatiques', '1340538617', 'ACTIVE', 10.5, 1, 1, 3827),
(766, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Systèmes d\'exploitation', '-1230961719', 'ACTIVE', 13.5, 1, 1, 3828),
(767, '2019-08-10 17:44:30', '2019-08-10 17:44:29', NULL, 'Systèmes d\'exploitation', '-1990690627', 'ACTIVE', 13.5, 1, 1, 3828),
(768, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Systèmes d\'exploitation', '-270351495', 'ACTIVE', 15, 1, 1, 3829),
(769, '2019-08-10 17:44:30', '2019-08-10 17:44:29', NULL, 'Systèmes d\'exploitation', '-1029156882', 'ACTIVE', 15, 1, 1, 3829),
(770, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Systèmes d\'exploitation', '1899004840', 'ACTIVE', 18.25, 1, 1, 3830),
(771, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Systèmes d\'exploitation', '1141122974', 'ACTIVE', 18.25, 1, 1, 3830),
(772, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Anglais niveau pratique B1/B2', '441852577', 'ACTIVE', 16, 1, 1, 3831),
(773, '2019-08-10 17:44:30', '2019-08-10 17:44:30', NULL, 'Anglais niveau pratique B1/B2', '-315105768', 'ACTIVE', 16, 1, 1, 3831),
(774, '2019-08-10 17:44:31', '2019-08-10 17:44:31', NULL, 'Anglais niveau pratique B1/B2', '-1430776130', 'ACTIVE', 13.4, 1, 1, 3832),
(775, '2019-08-10 17:44:31', '2019-08-10 17:44:30', NULL, 'Anglais niveau pratique B1/B2', '2108156342', 'ACTIVE', 13.4, 1, 1, 3832),
(776, '2019-08-10 17:44:31', '2019-08-10 17:44:31', NULL, 'Éthique et Philosophie', '1080175550', 'ACTIVE', 16.5, 1, 1, 3833),
(777, '2019-08-10 17:44:31', '2019-08-10 17:44:30', NULL, 'Éthique et Philosophie', '325064247', 'ACTIVE', 16.5, 1, 1, 3833),
(778, '2019-08-10 17:44:31', '2019-08-10 17:44:31', NULL, 'Éthique et Philosophie', '-1854057414', 'ACTIVE', 16.5, 1, 1, 3834),
(779, '2019-08-10 17:44:31', '2019-08-10 17:44:30', NULL, 'Éthique et Philosophie', '1686722100', 'ACTIVE', 16.5, 1, 1, 3834);
INSERT INTO `historique_note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut_vie`, `valeur_note`, `createur`, `modificateur`, `note`) VALUES
(780, '2019-08-10 17:44:31', '2019-08-10 17:44:31', NULL, 'Langage C++ et POO', '2067346907', 'ACTIVE', 15.33, 1, 1, 3835),
(781, '2019-08-10 17:44:31', '2019-08-10 17:44:31', NULL, 'Langage C++ et POO', '1314082646', 'ACTIVE', 15.33, 1, 1, 3835),
(782, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Langage C++ et POO', '1519855889', 'ACTIVE', 16, 1, 1, 3836),
(783, '2019-08-10 17:44:32', '2019-08-10 17:44:31', NULL, 'Langage C++ et POO', '767515149', 'ACTIVE', 16, 1, 1, 3836),
(784, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Langage C++ et POO', '1436461042', 'ACTIVE', 16, 1, 1, 3837),
(785, '2019-08-10 17:44:32', '2019-08-10 17:44:31', NULL, 'Langage C++ et POO', '685043823', 'ACTIVE', 16, 1, 1, 3837),
(786, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Algèbre linéaire II', '-416080461', 'ACTIVE', 16.25, 1, 1, 3838),
(787, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Algèbre linéaire II', '-1166574159', 'ACTIVE', 16.25, 1, 1, 3838),
(788, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Algèbre linéaire II', '-291715214', 'ACTIVE', 14, 1, 1, 3839),
(789, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Algèbre linéaire II', '-1041285391', 'ACTIVE', 14, 1, 1, 3839),
(790, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Programmation Web II', '557359396', 'ACTIVE', 14, 1, 1, 3840),
(791, '2019-08-10 17:44:32', '2019-08-10 17:44:32', NULL, 'Programmation Web II', '-191287260', 'ACTIVE', 14, 1, 1, 3840),
(792, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Programmation Web II', '-1935050578', 'ACTIVE', 16.5, 1, 1, 3841),
(793, '2019-08-10 17:44:33', '2019-08-10 17:44:32', NULL, 'Programmation Web II', '1612193583', 'ACTIVE', 16.5, 1, 1, 3841),
(794, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Programmation Web II', '-734239290', 'ACTIVE', 14.5, 1, 1, 3842),
(795, '2019-08-10 17:44:33', '2019-08-10 17:44:32', NULL, 'Programmation Web II', '-1481038904', 'ACTIVE', 14.5, 1, 1, 3842),
(796, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Anglais Niveau pratique B2', '1843080376', 'ACTIVE', 12.5, 1, 1, 3843),
(797, '2019-08-10 17:44:33', '2019-08-10 17:44:32', NULL, 'Anglais Niveau pratique B2', '1097204283', 'ACTIVE', 12.5, 1, 1, 3843),
(798, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Anglais Niveau pratique B2', '-551872320', 'ACTIVE', 15.2, 1, 1, 3844),
(799, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Anglais Niveau pratique B2', '-1296824892', 'ACTIVE', 15.2, 1, 1, 3844),
(800, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Ethique et Développement    ', '481644629', 'ACTIVE', 13.5, 1, 1, 3845),
(801, '2019-08-10 17:44:33', '2019-08-10 17:44:33', NULL, 'Ethique et Développement    ', '-262384422', 'ACTIVE', 13.5, 1, 1, 3845),
(802, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'Ethique et Développement    ', '-1745073695', 'ACTIVE', 17.5, 1, 1, 3846),
(803, '2019-08-10 17:44:34', '2019-08-10 17:44:33', NULL, 'Ethique et Développement    ', '1806788071', 'ACTIVE', 17.5, 1, 1, 3846),
(804, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1705181455', 'ACTIVE', 14.33, 1, 1, 3847),
(805, '2019-08-10 17:44:34', '2019-08-10 17:44:33', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '962999446', 'ACTIVE', 14.33, 1, 1, 3847),
(806, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '2078388962', 'ACTIVE', 13, 1, 1, 3848),
(807, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'L\'entreprise et la gestion, environnement comptable, financier', '1337130474', 'ACTIVE', 13, 1, 1, 3848),
(808, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'économie numérique', '-1267638279', 'ACTIVE', 18.17, 1, 1, 3849),
(809, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'économie numérique', '-2007973246', 'ACTIVE', 18.17, 1, 1, 3849),
(810, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'économie numérique', '-1667670335', 'ACTIVE', 12.5, 1, 1, 3850),
(811, '2019-08-10 17:44:34', '2019-08-10 17:44:34', NULL, 'économie numérique', '1887885515', 'ACTIVE', 12.5, 1, 1, 3850),
(812, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Introduction à la sécurité informatique', '-1159898914', 'ACTIVE', 12.88, 1, 1, 3851),
(813, '2019-08-10 17:44:35', '2019-08-10 17:44:34', NULL, 'Introduction à la sécurité informatique', '-1898386839', 'ACTIVE', 12.88, 1, 1, 3851),
(814, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Introduction à la sécurité informatique', '732336745', 'ACTIVE', 11.5, 1, 1, 3852),
(815, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Introduction à la sécurité informatique', '-5227659', 'ACTIVE', 11.5, 1, 1, 3852),
(816, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Algorithmique et Complexité', '-329708201', 'ACTIVE', 12, 1, 1, 3853),
(817, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Algorithmique et Complexité', '-1066349084', 'ACTIVE', 12, 1, 1, 3853),
(818, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Algorithmique et Complexité', '1361307142', 'ACTIVE', 9, 1, 1, 3854),
(819, '2019-08-10 17:44:35', '2019-08-10 17:44:35', NULL, 'Algorithmique et Complexité', '625589780', 'ACTIVE', 9, 1, 1, 3854),
(820, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'modélisation des Systèmes d\'Information(UML)', '-953304499', 'ACTIVE', 12.75, 1, 1, 3855),
(821, '2019-08-10 17:44:36', '2019-08-10 17:44:35', NULL, 'modélisation des Systèmes d\'Information(UML)', '-1688098340', 'ACTIVE', 12.75, 1, 1, 3855),
(822, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'modélisation des Systèmes d\'Information(UML)', '750405775', 'ACTIVE', 12, 1, 1, 3856),
(823, '2019-08-10 17:44:36', '2019-08-10 17:44:35', NULL, 'modélisation des Systèmes d\'Information(UML)', '16535455', 'ACTIVE', 12, 1, 1, 3856),
(824, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'Algèbre linaire I', '454707437', 'ACTIVE', 18.33, 1, 1, 3857),
(825, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'Algèbre linaire I', '-278239362', 'ACTIVE', 18.33, 1, 1, 3857),
(826, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'Algèbre linaire I', '532196524', 'ACTIVE', 19, 1, 1, 3858),
(827, '2019-08-10 17:44:36', '2019-08-10 17:44:36', NULL, 'Algèbre linaire I', '-199826754', 'ACTIVE', 19, 1, 1, 3858),
(828, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Programmation Orientée Objet II', '188159589', 'ACTIVE', 14.75, 1, 1, 3859),
(829, '2019-08-10 17:44:37', '2019-08-10 17:44:36', NULL, 'Programmation Orientée Objet II', '-542940168', 'ACTIVE', 14.75, 1, 1, 3859),
(830, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Programmation Orientée Objet II', '-872821298', 'ACTIVE', 7, 1, 1, 3860),
(831, '2019-08-10 17:44:37', '2019-08-10 17:44:36', NULL, 'Programmation Orientée Objet II', '-1602997534', 'ACTIVE', 7, 1, 1, 3860),
(832, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Programmation Orientée Objet II', '1764386791', 'ACTIVE', 16.5, 1, 1, 3861),
(833, '2019-08-10 17:44:37', '2019-08-10 17:44:36', NULL, 'Programmation Orientée Objet II', '1035134076', 'ACTIVE', 16.5, 1, 1, 3861),
(834, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Introduction aux Base de données', '-1087378541', 'ACTIVE', 12.25, 1, 1, 3862),
(835, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Introduction aux Base de données', '-1815707735', 'ACTIVE', 12.25, 1, 1, 3862),
(836, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Introduction aux Base de données', '1581560180', 'ACTIVE', 17.25, 1, 1, 3863),
(837, '2019-08-10 17:44:37', '2019-08-10 17:44:37', NULL, 'Introduction aux Base de données', '854154507', 'ACTIVE', 17.25, 1, 1, 3863),
(838, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Introduction aux Base de données', '155916336', 'ACTIVE', 16, 1, 1, 3864),
(839, '2019-08-10 17:44:38', '2019-08-10 17:44:37', NULL, 'Introduction aux Base de données', '-570565816', 'ACTIVE', 16, 1, 1, 3864),
(840, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Introduction aux Réseaux informatiques', '1195075575', 'ACTIVE', 9.5, 1, 1, 3865),
(841, '2019-08-10 17:44:38', '2019-08-10 17:44:37', NULL, 'Introduction aux Réseaux informatiques', '469516944', 'ACTIVE', 9.5, 1, 1, 3865),
(842, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Introduction aux Réseaux informatiques', '-994480250', 'ACTIVE', 10.75, 1, 1, 3866),
(843, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Introduction aux Réseaux informatiques', '-1719115360', 'ACTIVE', 10.75, 1, 1, 3866),
(844, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Systèmes d\'exploitation', '-275953279', 'ACTIVE', 12.5, 1, 1, 3867),
(845, '2019-08-10 17:44:38', '2019-08-10 17:44:38', NULL, 'Systèmes d\'exploitation', '-999664868', 'ACTIVE', 12.5, 1, 1, 3867),
(846, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Systèmes d\'exploitation', '1069344978', 'ACTIVE', 11, 1, 1, 3868),
(847, '2019-08-10 17:44:39', '2019-08-10 17:44:38', NULL, 'Systèmes d\'exploitation', '346556910', 'ACTIVE', 11, 1, 1, 3868),
(848, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Systèmes d\'exploitation', '521141477', 'ACTIVE', 17.5, 1, 1, 3869),
(849, '2019-08-10 17:44:39', '2019-08-10 17:44:38', NULL, 'Systèmes d\'exploitation', '-200723070', 'ACTIVE', 17.5, 1, 1, 3869),
(850, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Anglais niveau pratique B1/B2', '-168543030', 'ACTIVE', 14.4, 1, 1, 3870),
(851, '2019-08-10 17:44:39', '2019-08-10 17:44:38', NULL, 'Anglais niveau pratique B1/B2', '-889484056', 'ACTIVE', 14.4, 1, 1, 3870),
(852, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Anglais niveau pratique B1/B2', '1117400771', 'ACTIVE', 14, 1, 1, 3871),
(853, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Anglais niveau pratique B1/B2', '397383266', 'ACTIVE', 14, 1, 1, 3871),
(854, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Éthique et Philosophie', '-2107295317', 'ACTIVE', 16, 1, 1, 3872),
(855, '2019-08-10 17:44:39', '2019-08-10 17:44:39', NULL, 'Éthique et Philosophie', '1468577995', 'ACTIVE', 16, 1, 1, 3872),
(856, '2019-08-10 17:44:40', '2019-08-10 17:44:40', NULL, 'Éthique et Philosophie', '-323116134', 'ACTIVE', 14, 1, 1, 3873),
(857, '2019-08-10 17:44:40', '2019-08-10 17:44:39', NULL, 'Éthique et Philosophie', '-1041286597', 'ACTIVE', 14, 1, 1, 3873);

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
) ENGINE=MyISAM AUTO_INCREMENT=3874 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `note`
--

INSERT INTO `note` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `numero_table`, `signature`, `statut_vie`, `valeur_note`, `createur`, `evaluation`, `modificateur`, `est_inscrit`) VALUES
(3868, '2019-08-10 17:44:39', '2019-08-10 17:44:39', 'EXA', 'Systèmes d\'exploitation', 20, '346556910', 'ACTIVE', 11, 1, 2212, 1, 3210),
(3867, '2019-08-10 17:44:38', '2019-08-10 17:44:38', 'CC', 'Systèmes d\'exploitation', 5, '-999664868', 'ACTIVE', 12.5, 1, 2194, 1, 3210),
(3864, '2019-08-10 17:44:38', '2019-08-10 17:44:38', 'TP', 'Introduction aux Base de données', 16, '-570565816', 'ACTIVE', 16, 1, 2223, 1, 3208),
(3865, '2019-08-10 17:44:38', '2019-08-10 17:44:38', 'CC', 'Introduction aux Réseaux informatiques', 22, '469516944', 'ACTIVE', 9.5, 1, 2196, 1, 3209),
(3866, '2019-08-10 17:44:38', '2019-08-10 17:44:38', 'EXA', 'Introduction aux Réseaux informatiques', 17, '-1719115360', 'ACTIVE', 10.75, 1, 2214, 1, 3209),
(3861, '2019-08-10 17:44:37', '2019-08-10 17:44:37', 'TP', 'Programmation Orientée Objet II', 17, '1035134076', 'ACTIVE', 16.5, 1, 2221, 1, 3207),
(3862, '2019-08-10 17:44:37', '2019-08-10 17:44:37', 'CC', 'Introduction aux Base de données', 21, '-1815707735', 'ACTIVE', 12.25, 1, 2195, 1, 3208),
(3863, '2019-08-10 17:44:37', '2019-08-10 17:44:37', 'EXA', 'Introduction aux Base de données', 24, '854154507', 'ACTIVE', 17.25, 1, 2213, 1, 3208),
(3860, '2019-08-10 17:44:37', '2019-08-10 17:44:37', 'EXA', 'Programmation Orientée Objet II', 7, '-1602997534', 'ACTIVE', 7, 1, 2211, 1, 3207),
(3855, '2019-08-10 17:44:36', '2019-08-10 17:44:36', 'CC', 'modélisation des Systèmes d\'Information(UML)', 5, '-1688098340', 'ACTIVE', 12.75, 1, 2192, 1, 3204),
(3856, '2019-08-10 17:44:36', '2019-08-10 17:44:36', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 25, '16535455', 'ACTIVE', 12, 1, 2210, 1, 3204),
(3857, '2019-08-10 17:44:36', '2019-08-10 17:44:36', 'CC', 'Algèbre linaire I', 9, '-278239362', 'ACTIVE', 18.33, 1, 2202, 1, 3206),
(3858, '2019-08-10 17:44:36', '2019-08-10 17:44:36', 'EXA', 'Algèbre linaire I', 13, '-199826754', 'ACTIVE', 19, 1, 2219, 1, 3206),
(3859, '2019-08-10 17:44:37', '2019-08-10 17:44:37', 'CC', 'Programmation Orientée Objet II', 20, '-542940168', 'ACTIVE', 14.75, 1, 2193, 1, 3207),
(3852, '2019-08-10 17:44:35', '2019-08-10 17:44:35', 'EXA', 'Introduction à la sécurité informatique', 18, '-5227659', 'ACTIVE', 11.5, 1, 2217, 1, 3201),
(3853, '2019-08-10 17:44:35', '2019-08-10 17:44:35', 'CC', 'Algorithmique et Complexité', 11, '-1066349084', 'ACTIVE', 12, 1, 2191, 1, 3203),
(3854, '2019-08-10 17:44:35', '2019-08-10 17:44:35', 'EXA', 'Algorithmique et Complexité', 12, '625589780', 'ACTIVE', 9, 1, 2209, 1, 3203),
(3851, '2019-08-10 17:44:35', '2019-08-10 17:44:35', 'CC', 'Introduction à la sécurité informatique', 17, '-1898386839', 'ACTIVE', 12.88, 1, 2199, 1, 3201),
(3850, '2019-08-10 17:44:34', '2019-08-10 17:44:34', 'EXA', 'économie numérique', 16, '1887885515', 'ACTIVE', 12.5, 1, 2218, 1, 3200),
(3847, '2019-08-10 17:44:34', '2019-08-10 17:44:34', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 10, '962999446', 'ACTIVE', 14.33, 1, 2188, 1, 3199),
(3848, '2019-08-10 17:44:34', '2019-08-10 17:44:34', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 9, '1337130474', 'ACTIVE', 13, 1, 2206, 1, 3199),
(3849, '2019-08-10 17:44:34', '2019-08-10 17:44:34', 'CC', 'économie numérique', 7, '-2007973246', 'ACTIVE', 18.17, 1, 2200, 1, 3200),
(3846, '2019-08-10 17:44:34', '2019-08-10 17:44:34', 'EXA', 'Ethique et Développement    ', 4, '1806788071', 'ACTIVE', 17.5, 1, 2207, 1, 3197),
(3845, '2019-08-10 17:44:33', '2019-08-10 17:44:33', 'CC', 'Ethique et Développement    ', 14, '-262384422', 'ACTIVE', 13.5, 1, 2189, 1, 3197),
(3844, '2019-08-10 17:44:33', '2019-08-10 17:44:33', 'EXA', 'Anglais Niveau pratique B2', 18, '-1296824892', 'ACTIVE', 15.2, 1, 2205, 1, 3196),
(3842, '2019-08-10 17:44:33', '2019-08-10 17:44:33', 'TP', 'Programmation Web II', 4, '-1481038904', 'ACTIVE', 14.5, 1, 2225, 1, 3195),
(3843, '2019-08-10 17:44:33', '2019-08-10 17:44:33', 'CC', 'Anglais Niveau pratique B2', 19, '1097204283', 'ACTIVE', 12.5, 1, 2187, 1, 3196),
(3840, '2019-08-10 17:44:32', '2019-08-10 17:44:32', 'CC', 'Programmation Web II', 24, '-191287260', 'ACTIVE', 14, 1, 2198, 1, 3195),
(3841, '2019-08-10 17:44:33', '2019-08-10 17:44:33', 'EXA', 'Programmation Web II', 17, '1612193583', 'ACTIVE', 16.5, 1, 2216, 1, 3195),
(3839, '2019-08-10 17:44:32', '2019-08-10 17:44:32', 'EXA', 'Algèbre linéaire II', 20, '-1041285391', 'ACTIVE', 14, 1, 2220, 1, 3205),
(3837, '2019-08-10 17:44:32', '2019-08-10 17:44:32', 'TP', 'Langage C++ et POO', 1, '685043823', 'ACTIVE', 16, 1, 2224, 1, 3194),
(3838, '2019-08-10 17:44:32', '2019-08-10 17:44:32', 'CC', 'Algèbre linéaire II', 19, '-1166574159', 'ACTIVE', 16.25, 1, 2203, 1, 3205),
(3836, '2019-08-10 17:44:32', '2019-08-10 17:44:32', 'EXA', 'Langage C++ et POO', 2, '767515149', 'ACTIVE', 16, 1, 2215, 1, 3194),
(3835, '2019-08-10 17:44:31', '2019-08-10 17:44:31', 'CC', 'Langage C++ et POO', 19, '1314082646', 'ACTIVE', 15.33, 1, 2197, 1, 3194),
(3834, '2019-08-10 17:44:31', '2019-08-10 17:44:31', 'EXA', 'Éthique et Philosophie', 2, '1686722100', 'ACTIVE', 16.5, 1, 2208, 1, 3617),
(3832, '2019-08-10 17:44:31', '2019-08-10 17:44:31', 'EXA', 'Anglais niveau pratique B1/B2', 22, '2108156342', 'ACTIVE', 13.4, 1, 2204, 1, 3616),
(3833, '2019-08-10 17:44:31', '2019-08-10 17:44:31', 'CC', 'Éthique et Philosophie', 9, '325064247', 'ACTIVE', 16.5, 1, 2190, 1, 3617),
(3831, '2019-08-10 17:44:30', '2019-08-10 17:44:30', 'CC', 'Anglais niveau pratique B1/B2', 7, '-315105768', 'ACTIVE', 16, 1, 2186, 1, 3616),
(3830, '2019-08-10 17:44:30', '2019-08-10 17:44:30', 'TP', 'Systèmes d\'exploitation', 3, '1141122974', 'ACTIVE', 18.25, 1, 2222, 1, 3615),
(3828, '2019-08-10 17:44:30', '2019-08-10 17:44:30', 'CC', 'Systèmes d\'exploitation', 6, '-1990690627', 'ACTIVE', 13.5, 1, 2194, 1, 3615),
(3829, '2019-08-10 17:44:30', '2019-08-10 17:44:30', 'EXA', 'Systèmes d\'exploitation', 9, '-1029156882', 'ACTIVE', 15, 1, 2212, 1, 3615),
(3826, '2019-08-10 17:44:29', '2019-08-10 17:44:29', 'CC', 'Introduction aux Réseaux informatiques', 13, '-1380443237', 'ACTIVE', 10, 1, 2196, 1, 3614),
(3827, '2019-08-10 17:44:29', '2019-08-10 17:44:29', 'EXA', 'Introduction aux Réseaux informatiques', 12, '1340538617', 'ACTIVE', 10.5, 1, 2214, 1, 3614),
(3825, '2019-08-10 17:44:29', '2019-08-10 17:44:29', 'TP', 'Introduction aux Base de données', 25, '-707126930', 'ACTIVE', 12, 1, 2223, 1, 3613),
(3824, '2019-08-10 17:44:29', '2019-08-10 17:44:29', 'EXA', 'Introduction aux Base de données', 25, '-1161117862', 'ACTIVE', 9.25, 1, 2213, 1, 3613),
(3823, '2019-08-10 17:44:29', '2019-08-10 17:44:29', 'CC', 'Introduction aux Base de données', 18, '-984474099', 'ACTIVE', 12.25, 1, 2195, 1, 3613),
(3821, '2019-08-10 17:44:28', '2019-08-10 17:44:28', 'EXA', 'Programmation Orientée Objet II', 10, '-508646078', 'ACTIVE', 12.5, 1, 2211, 1, 3612),
(3822, '2019-08-10 17:44:28', '2019-08-10 17:44:29', 'TP', 'Programmation Orientée Objet II', 11, '-608600861', 'ACTIVE', 17.75, 1, 2221, 1, 3612),
(3819, '2019-08-10 17:44:28', '2019-08-10 17:44:28', 'EXA', 'Algèbre linaire I', 23, '1658242299', 'ACTIVE', 11.5, 1, 2219, 1, 3611),
(3820, '2019-08-10 17:44:28', '2019-08-10 17:44:28', 'CC', 'Programmation Orientée Objet II', 13, '1480709084', 'ACTIVE', 13.25, 1, 2193, 1, 3612),
(3818, '2019-08-10 17:44:28', '2019-08-10 17:44:28', 'CC', 'Algèbre linaire I', 14, '-32583790', 'ACTIVE', 14, 1, 2202, 1, 3611),
(3817, '2019-08-10 17:44:28', '2019-08-10 17:44:28', 'EXA', 'modélisation des Systèmes d\'Information(UML)', 15, '196212152', 'ACTIVE', 12, 1, 2210, 1, 3609),
(3816, '2019-08-10 17:44:27', '2019-08-10 17:44:27', 'CC', 'modélisation des Systèmes d\'Information(UML)', 23, '-1700247372', 'ACTIVE', 12.75, 1, 2192, 1, 3609),
(3815, '2019-08-10 17:44:27', '2019-08-10 17:44:27', 'EXA', 'Algorithmique et Complexité', 16, '-2077794276', 'ACTIVE', 15, 1, 2209, 1, 3608),
(3814, '2019-08-10 17:44:27', '2019-08-10 17:44:27', 'CC', 'Algorithmique et Complexité', 4, '902675724', 'ACTIVE', 11.83, 1, 2191, 1, 3608),
(3813, '2019-08-10 17:44:27', '2019-08-10 17:44:27', 'EXA', 'Introduction à la sécurité informatique', 13, '1040102830', 'ACTIVE', 9.25, 1, 2217, 1, 3606),
(3812, '2019-08-10 17:44:27', '2019-08-10 17:44:27', 'CC', 'Introduction à la sécurité informatique', 21, '-225686228', 'ACTIVE', 9.63, 1, 2199, 1, 3606),
(3810, '2019-08-10 17:44:26', '2019-08-10 17:44:26', 'CC', 'économie numérique', 10, '2124132244', 'ACTIVE', 16, 1, 2200, 1, 3605),
(3811, '2019-08-10 17:44:26', '2019-08-10 17:44:26', 'EXA', 'économie numérique', 6, '1926923706', 'ACTIVE', 15, 1, 2218, 1, 3605),
(3809, '2019-08-10 17:44:26', '2019-08-10 17:44:26', 'EXA', 'L\'entreprise et la gestion, environnement comptable, financier', 14, '95184856', 'ACTIVE', 16, 1, 2206, 1, 3604),
(3808, '2019-08-10 17:44:25', '2019-08-10 17:44:25', 'CC', 'L\'entreprise et la gestion, environnement comptable, financier', 13, '-1088684170', 'ACTIVE', 15, 1, 2188, 1, 3604),
(3807, '2019-08-10 17:44:25', '2019-08-10 17:44:25', 'EXA', 'Ethique et Développement    ', 14, '1810312597', 'ACTIVE', 14.5, 1, 2207, 1, 3602),
(3805, '2019-08-10 17:44:24', '2019-08-10 17:44:24', 'EXA', 'Anglais Niveau pratique B2', 25, '738868685', 'ACTIVE', 12.2, 1, 2205, 1, 3601),
(3806, '2019-08-10 17:44:25', '2019-08-10 17:44:25', 'CC', 'Ethique et Développement    ', 15, '-1084217482', 'ACTIVE', 15.75, 1, 2189, 1, 3602),
(3804, '2019-08-10 17:44:24', '2019-08-10 17:44:24', 'CC', 'Anglais Niveau pratique B2', 22, '626746856', 'ACTIVE', 11.1, 1, 2187, 1, 3601),
(3803, '2019-08-10 17:44:24', '2019-08-10 17:44:24', 'TP', 'Programmation Web II', 7, '888675194', 'ACTIVE', 14.5, 1, 2225, 1, 3600),
(3802, '2019-08-10 17:44:24', '2019-08-10 17:44:24', 'EXA', 'Programmation Web II', 15, '-878173467', 'ACTIVE', 13, 1, 2216, 1, 3600),
(3801, '2019-08-10 17:44:24', '2019-08-10 17:44:24', 'CC', 'Programmation Web II', 1, '1037665538', 'ACTIVE', 6.5, 1, 2198, 1, 3600),
(3755, '2019-08-10 17:44:23', '2019-08-10 17:44:23', 'EXA', 'Algèbre linéaire II', 4, '753095382', 'ACTIVE', 12, 1, 2220, 1, 3610),
(3754, '2019-08-10 17:44:23', '2019-08-10 17:44:23', 'CC', 'Algèbre linéaire II', 2, '1909796816', 'ACTIVE', 9.75, 1, 2203, 1, 3610),
(3753, '2019-08-10 17:44:23', '2019-08-10 17:44:23', 'TP', 'Langage C++ et POO', 15, '-344937459', 'ACTIVE', 16, 1, 2224, 1, 3599),
(3752, '2019-08-10 17:44:23', '2019-08-10 17:44:23', 'EXA', 'Langage C++ et POO', 10, '1806337537', 'ACTIVE', 14.75, 1, 2215, 1, 3599),
(3751, '2019-08-10 17:44:23', '2019-08-10 17:44:23', 'CC', 'Langage C++ et POO', 9, '-2113646571', 'ACTIVE', 14.75, 1, 2197, 1, 3599),
(3869, '2019-08-10 17:44:39', '2019-08-10 17:44:39', 'TP', 'Systèmes d\'exploitation', 23, '-200723070', 'ACTIVE', 17.5, 1, 2222, 1, 3210),
(3870, '2019-08-10 17:44:39', '2019-08-10 17:44:39', 'CC', 'Anglais niveau pratique B1/B2', 12, '-889484056', 'ACTIVE', 14.4, 1, 2186, 1, 3211),
(3871, '2019-08-10 17:44:39', '2019-08-10 17:44:39', 'EXA', 'Anglais niveau pratique B1/B2', 3, '397383266', 'ACTIVE', 14, 1, 2204, 1, 3211),
(3872, '2019-08-10 17:44:39', '2019-08-10 17:44:39', 'CC', 'Éthique et Philosophie', 1, '1468577995', 'ACTIVE', 16, 1, 2189, 1, 3212),
(3873, '2019-08-10 17:44:40', '2019-08-10 17:44:40', 'EXA', 'Éthique et Philosophie', 1, '-1041286597', 'ACTIVE', 14, 1, 2207, 1, 3212);

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
('SEQ_GEN', '4100');

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
) ENGINE=MyISAM AUTO_INCREMENT=4052 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
(4051, '2019-08-12 10:33:46', '2019-08-12 10:33:46', NULL, '2019-08-12 10:33:46', NULL, NULL, 'DESKTOP-7OQ9KG8', '1800415695', 'ACTIF', 'ACTIVE', 1, 1, NULL);

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
) ENGINE=MyISAM AUTO_INCREMENT=3829 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `type_evaluation`
--

INSERT INTO `type_evaluation` (`code`, `date_creation`, `date_modification`, `description`, `libelle`, `pourcentage`, `signature`, `statut_vie`, `createur`, `enseignement`, `modificateur`) VALUES
(2185, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Rattrapages ', 'RA', 70, '-2090466147', 'ACTIVE', 1, 1353, 1),
(2184, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Session normale', 'SN', 70, '-2088582587', 'ACTIVE', 1, 1353, 1),
(2183, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Controle continu', 'CC', 30, '1883086949', 'ACTIVE', 1, 1353, 1),
(2182, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Rattrapages ', 'RA', 70, '-261383266', 'ACTIVE', 1, 1317, 1),
(2180, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Controle continu', 'CC', 30, '-600362624', 'ACTIVE', 1, 1317, 1),
(2181, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Session normale', 'SN', 70, '-259215250', 'ACTIVE', 1, 1317, 1),
(2179, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Travaux pratiques', 'TP', 30, '2092103416', 'ACTIVE', 1, 1316, 1),
(2178, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Session normale', 'SN', 50, '-2030802906', 'ACTIVE', 1, 1316, 1),
(2175, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Rattrapages ', 'RA', 70, '1587988825', 'ACTIVE', 1, 1315, 1),
(2177, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Controle continu', 'CC', 20, '1924843133', 'ACTIVE', 1, 1316, 1),
(2176, '2019-08-10 15:55:57', '2019-08-10 15:55:57', 'Rattrapages ', 'RA', 50, '-2017435396', 'ACTIVE', 1, 1316, 1),
(2174, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Session normale', 'SN', 70, '1580912021', 'ACTIVE', 1, 1315, 1),
(2173, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Controle continu', 'CC', 30, '1266254612', 'ACTIVE', 1, 1315, 1),
(2172, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Rattrapages ', 'RA', 50, '-686673561', 'ACTIVE', 1, 1314, 1),
(2171, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Travaux pratiques', 'TP', 30, '-863465538', 'ACTIVE', 1, 1314, 1),
(2170, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Session normale', 'SN', 50, '-691582349', 'ACTIVE', 1, 1314, 1),
(2168, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Travaux pratiques', 'TP', 30, '-1799548730', 'ACTIVE', 1, 1313, 1),
(2169, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Controle continu', 'CC', 20, '-1019738708', 'ACTIVE', 1, 1314, 1),
(2167, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Session normale', 'SN', 50, '-1628483352', 'ACTIVE', 1, 1313, 1),
(2165, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Rattrapages ', 'RA', 70, '1965962440', 'ACTIVE', 1, 1312, 1),
(2166, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Controle continu', 'CC', 20, '-1967377925', 'ACTIVE', 1, 1313, 1),
(2164, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Session normale', 'SN', 70, '1968166013', 'ACTIVE', 1, 1312, 1),
(2161, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Session normale', 'SN', 70, '1953846611', 'ACTIVE', 1, 1320, 1),
(2162, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Rattrapages ', 'RA', 70, '1952354178', 'ACTIVE', 1, 1320, 1),
(2163, '2019-08-10 15:55:56', '2019-08-10 15:55:56', 'Controle continu', 'CC', 30, '1643872657', 'ACTIVE', 1, 1312, 1),
(2160, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Controle continu', 'CC', 30, '1631011092', 'ACTIVE', 1, 1320, 1),
(2159, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Rattrapages ', 'RA', 70, '-475818470', 'ACTIVE', 1, 1311, 1),
(2158, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Session normale', 'SN', 70, '-481579665', 'ACTIVE', 1, 1311, 1),
(2157, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Controle continu', 'CC', 30, '-794601452', 'ACTIVE', 1, 1311, 1),
(2156, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Rattrapages ', 'RA', 70, '-1114057713', 'ACTIVE', 1, 1310, 1),
(2155, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Session normale', 'SN', 70, '-1121205631', 'ACTIVE', 1, 1310, 1),
(2154, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Controle continu', 'CC', 30, '-1434156304', 'ACTIVE', 1, 1310, 1),
(2153, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Rattrapages ', 'RA', 70, '1190891915', 'ACTIVE', 1, 1351, 1),
(2152, '2019-08-10 15:55:55', '2019-08-10 15:55:55', 'Session normale', 'SN', 70, '1185272948', 'ACTIVE', 1, 1351, 1),
(2151, '2019-08-10 15:55:54', '2019-08-10 15:55:55', 'Controle continu', 'CC', 30, '882100450', 'ACTIVE', 1, 1351, 1),
(2150, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Rattrapages ', 'RA', 70, '-2037205218', 'ACTIVE', 1, 1324, 1),
(2149, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Session normale', 'SN', 70, '-2042859742', 'ACTIVE', 1, 1324, 1),
(2147, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Rattrapages ', 'RA', 70, '1365193927', 'ACTIVE', 1, 1323, 1),
(2148, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Controle continu', 'CC', 30, '1911386864', 'ACTIVE', 1, 1324, 1),
(2146, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Session normale', 'SN', 70, '1368606438', 'ACTIVE', 1, 1323, 1),
(2145, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Controle continu', 'CC', 30, '1062873836', 'ACTIVE', 1, 1323, 1),
(2144, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Rattrapages ', 'RA', 70, '143845365', 'ACTIVE', 1, 1322, 1),
(2143, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Session normale', 'SN', 70, '121870178', 'ACTIVE', 1, 1322, 1),
(2142, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Controle continu', 'CC', 30, '-192609446', 'ACTIVE', 1, 1322, 1),
(2141, '2019-08-10 15:55:54', '2019-08-10 15:55:54', 'Session normale', 'SN', 100, '1200630974', 'ACTIVE', 1, 1354, 1),
(2138, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Controle continu', 'CC', 30, '-1426690838', 'ACTIVE', 1, 1318, 1),
(2140, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Session normale', 'SN', 70, '-1080280067', 'ACTIVE', 1, 1318, 1),
(2139, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Rattrapages ', 'RA', 70, '-1087036858', 'ACTIVE', 1, 1318, 1),
(2137, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Session normale', 'SN', 70, '-1553402777', 'ACTIVE', 1, 1352, 1),
(2136, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Rattrapages ', 'RA', 70, '-1539500951', 'ACTIVE', 1, 1352, 1),
(2134, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Travaux pratiques', 'TP', 30, '-831937552', 'ACTIVE', 1, 1321, 1),
(2135, '2019-08-10 15:55:53', '2019-08-10 15:55:53', 'Controle continu', 'CC', 30, '-1860700848', 'ACTIVE', 1, 1352, 1),
(2133, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Rattrapages ', 'RA', 30, '-836774265', 'ACTIVE', 1, 1321, 1),
(2132, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Session normale', 'SN', 50, '-650668276', 'ACTIVE', 1, 1321, 1),
(2130, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Rattrapages ', 'RA', 50, '660961971', 'ACTIVE', 1, 1319, 1),
(2131, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Controle continu', 'CC', 20, '-1014274964', 'ACTIVE', 1, 1321, 1),
(2129, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Travaux pratiques', 'TP', 30, '490463583', 'ACTIVE', 1, 1319, 1),
(2128, '2019-08-10 15:55:52', '2019-08-10 15:55:52', 'Session normale', 'SN', 50, '639981419', 'ACTIVE', 1, 1319, 1),
(2127, '2019-08-10 15:55:51', '2019-08-10 15:55:51', 'Controle continu', 'CC', 20, '306953751', 'ACTIVE', 1, 1319, 1);

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
) ENGINE=MyISAM AUTO_INCREMENT=1742 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Déchargement des données de la table `ue`
--

INSERT INTO `ue` (`code`, `code_ue`, `credits`, `date_creation`, `date_modification`, `description`, `libelle`, `signature`, `statut`, `statut_vie`, `createur`, `modificateur`, `module`, `niveau`, `specialite`) VALUES
(1290, 'SAS451', 1, '2019-08-10 13:43:10', '2019-08-10 13:43:10', '', 'Sagesse et science2', '-125409050', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(1289, 'STG361', 10, '2019-08-10 13:43:10', '2019-08-10 13:43:10', '', 'Stage Professionnel', '1879595119', 'ACTIVE', 'ACTIVE', 1, 1, 1126, 9, 4),
(1288, 'INF364', 4, '2019-08-10 13:43:09', '2019-08-10 13:43:09', '', 'Conception et Développement d’applications pour mobiles', '1208325453', 'ACTIVE', 'ACTIVE', 1, 1, 1125, 9, 4),
(1286, 'INF362', 4, '2019-08-10 13:43:09', '2019-08-10 13:43:09', '', 'Enterprise Resource Planning (ERP)', '-794967989', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(1284, 'INF361', 4, '2019-08-10 13:43:09', '2019-08-10 13:43:09', '', 'JEE(Programmation par Objets avancée)', '1768817776', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(1287, 'INF365', 3, '2019-08-10 13:43:09', '2019-08-10 13:43:09', '', 'Projet Tutoré', '1618757053', 'ACTIVE', 'ACTIVE', 1, 1, 1124, 9, 4),
(1285, 'INF363', 4, '2019-08-10 13:43:09', '2019-08-10 13:43:09', '', 'Technologie.NET', '1105979075', 'ACTIVE', 'ACTIVE', 1, 1, 1123, 9, 4),
(1280, 'MKT351', 2, '2019-08-10 13:43:08', '2019-08-10 13:43:08', '', 'Marketing Informatique', '2081585708', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(1281, 'COM351', 2, '2019-08-10 13:43:08', '2019-08-10 13:43:08', '', 'Fondamentaux de la communication', '-610862727', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(1282, 'ANG351', 2, '2019-08-10 13:43:08', '2019-08-10 13:43:08', '', 'Anglais pratique', '1391283281', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(1283, 'SAS351', 1, '2019-08-10 13:43:08', '2019-08-10 13:43:08', '', 'Sagesse et science1', '1379473151', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(1279, 'ATE351', 2, '2019-08-10 13:43:08', '2019-08-10 13:43:08', '', 'Ateliers de création d\'entreprise', '-898349572', 'ACTIVE', 'ACTIVE', 1, 1, 1121, 9, 4),
(1278, 'INF356', 3, '2019-08-10 13:43:07', '2019-08-10 13:43:07', '', 'Gestion des Projets informatique', '-2082797713', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(1276, 'INF354', 3, '2019-08-10 13:43:07', '2019-08-10 13:43:07', '', 'Introduction au Big Data', '1597188724', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(1277, 'INF355', 4, '2019-08-10 13:43:07', '2019-08-10 13:43:07', '', 'Sécurité avancée des réseaux et systèmes', '1448459849', 'ACTIVE', 'ACTIVE', 1, 1, 1120, 9, 4),
(1275, 'INF352', 3, '2019-08-10 13:43:07', '2019-08-10 13:43:07', '', 'Ingénierie du Génie Logiciel', '-126312614', 'ACTIVE', 'ACTIVE', 1, 1, 1119, 9, 4),
(1273, 'INF351', 4, '2019-08-10 13:43:06', '2019-08-10 13:43:06', '', 'Programmation et administration des bases de Données (Oracle ou SQLServer)', '731390966', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(1274, 'MAT351', 4, '2019-08-10 13:43:07', '2019-08-10 13:43:07', '', 'Recherche opérationnelle et aide à la décision', '917312037', 'ACTIVE', 'ACTIVE', 1, 1, 1118, 9, 4),
(1272, 'STG241', 4, '2019-08-10 13:43:06', '2019-08-10 13:43:06', '', 'Stage Technique', '-1724684263', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(1271, 'ETH241', 1, '2019-08-10 13:43:06', '2019-08-10 13:43:06', '', 'Éthique et Philosophie', '-486344635', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(1270, 'ANG241', 2, '2019-08-10 13:43:06', '2019-08-10 13:43:06', '', 'Anglais Niveau pratique B2', '1582127575', 'ACTIVE', 'ACTIVE', 1, 1, 1117, 8, 4),
(1269, 'INF245', 3, '2019-08-10 13:43:06', '2019-08-10 13:43:06', '', 'Projets tutorés', '1661141611', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(1267, 'INF244', 4, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'économie numérique', '-352531226', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(1268, 'INF243', 4, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'Introduction à la sécurité informatique', '1942977714', 'ACTIVE', 'ACTIVE', 1, 1, 1116, 8, 4),
(1265, 'INF242', 4, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'Programmation Web II', '-1302084298', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(1266, 'ENV241', 4, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'L\'entreprise et la gestion, environnement comptable, financier', '-71631561', 'ACTIVE', 'ACTIVE', 1, 1, 1115, 8, 4),
(1264, 'MAT241', 2, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'Algèbre linéaire II', '-1475833825', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(1263, 'INF241', 4, '2019-08-10 13:43:05', '2019-08-10 13:43:05', '', 'Langage C++ et POO', '36994823', 'ACTIVE', 'ACTIVE', 1, 1, 1114, 8, 4),
(1262, 'ETH231', 1, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Ethique et Développement    ', '-1241886751', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(1261, 'ANG231', 2, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Anglais niveau pratique B1/B2', '-1490930644', 'ACTIVE', 'ACTIVE', 1, 1, 1113, 8, 4),
(1260, 'INF234', 3, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Systèmes d\'exploitation', '1676144317', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(1258, 'INF235', 4, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Introduction aux Base de données', '579218349', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(1259, 'INF236', 4, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Introduction aux Réseaux informatiques', '-1079471348', 'ACTIVE', 'ACTIVE', 1, 1, 1112, 8, 4),
(1257, 'INF233', 4, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Programmation Orientée Objet II', '-1865380288', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(1256, 'MAT231', 4, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'Algèbre linaire I', '-1961766253', 'ACTIVE', 'ACTIVE', 1, 1, 1111, 8, 4),
(1255, 'INF232', 4, '2019-08-10 13:43:04', '2019-08-10 13:43:04', '', 'modélisation des Systèmes d\'Information(UML)', '-818105754', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(1252, 'REF112', 1, '2019-08-10 13:43:03', '2019-08-10 13:43:03', '', 'Réflexion Humaine 2', '1065236968', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(1254, 'INF231', 4, '2019-08-10 13:43:03', '2019-08-10 13:43:03', '', 'Algorithmique et Complexité', '1874909707', 'ACTIVE', 'ACTIVE', 1, 1, 1110, 8, 4),
(1253, 'STA121', 3, '2019-08-10 13:43:03', '2019-08-10 13:43:03', '', 'Stage découverte de l’entreprise', '-167983702', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(1251, 'ANG121', 2, '2019-08-10 13:43:03', '2019-08-10 13:43:03', '', 'Anglais niveau pratique B1', '-1431619463', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(1249, 'EXP121', 2, '2019-08-10 13:43:02', '2019-08-10 13:43:02', '', 'Communication Orale, Ecrite et audio Visual', '-1749231317', 'ACTIVE', 'ACTIVE', 1, 1, 1109, 7, 4),
(1248, 'INF125', 2, '2019-08-10 13:43:02', '2019-08-10 13:43:02', '', 'Logique pour l\'Informatique', '-1767284697', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(1247, 'MAT121', 4, '2019-08-10 13:43:02', '2019-08-10 13:43:02', '', 'Mathématiques discrètes II', '-729579383', 'ACTIVE', 'ACTIVE', 1, 1, 1108, 7, 4),
(1244, 'INF124', 4, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Initiation à la programmation C', '1127172377', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(1246, 'INF122', 4, '2019-08-10 13:43:02', '2019-08-10 13:43:02', '', 'Algorithmique et Structure de données I', '-1379360272', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(1245, 'INF123', 4, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Introduction à l\'Analyse Merise', '2090179891', 'ACTIVE', 'ACTIVE', 1, 1, 1107, 7, 4),
(1241, 'ANG111', 2, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Anglais Remise à niveau A2', '-357513049', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(1242, 'REF111', 2, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Réflexion Humaine1', '-1354361649', 'ACTIVE', 'ACTIVE', 1, 1, 1105, 7, 4),
(1243, 'INF121', 4, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Initiation Programmation orientée objet I', '-1063534314', 'ACTIVE', 'ACTIVE', 1, 1, 1106, 7, 4),
(1240, 'MAT112', 4, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Mathématiques discrètes I', '-2127199737', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(1239, 'MAT111', 4, '2019-08-10 13:43:01', '2019-08-10 13:43:01', '', 'Mathématiques pour l\'informatique', '-350375017', 'ACTIVE', 'ACTIVE', 1, 1, 1104, 7, 4),
(1238, 'INF114', 4, '2019-08-10 13:43:00', '2019-08-10 13:43:00', '', 'Introduction aux algorithmes', '702648162', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(1235, 'INF113', 4, '2019-08-10 13:43:00', '2019-08-10 13:43:00', '', 'Architecture des ordinateurs', '44641323', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4),
(1236, 'INF112', 4, '2019-08-10 13:43:00', '2019-08-10 13:43:00', '', 'Programmation Web I', '-1246732513', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(1237, 'INF115', 2, '2019-08-10 13:43:00', '2019-08-10 13:43:00', '', 'Enjeux de l’économie Numérique', '1698459292', 'ACTIVE', 'ACTIVE', 1, 1, 1103, 7, 4),
(1234, 'INF111', 4, '2019-08-10 13:43:00', '2019-08-10 13:43:00', '', 'Introduction aux systèmes d\'information', '-156757844', 'ACTIVE', 'ACTIVE', 1, 1, 1102, 7, 4);

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
