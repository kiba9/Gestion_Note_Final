package org.isj.metier;

/**
 * importation des classes
 */

import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;
import org.isj.gestionutilisateurs.Connexion;
import org.isj.gestionutilisateurs.Eleve;
import org.isj.messagerie.mail.SendEmail;
import org.isj.metier.entites.*;
import org.isj.metier.facade.*;

import javax.mail.MessagingException;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.swing.text.DateFormatter;
import java.io.*;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.*;

import static java.util.stream.Collectors.toMap;
import static org.isj.gestionutilisateurs.Connexion.utilisateurCourant;

/**
 * cette classe contient toutes les fonctions demandées par les autres modules
 *
 * @auteur traitement metier
 */

public class Isj {

    public static final String SAMPLE_XLSX_FILE_PATH = "C:\\Users\\cena\\Downloads\\cena\\cena\\Anonymat_Matricule 6.xlsx";
    public static final String PATH_OUT_XLSX = "C:\\Users\\cena\\Downloads\\cena\\cena\\";
    public static final String SAMPLE_XLSX_FILE_NOTE_PATH = "C:\\Users\\cena\\Downloads\\cena\\cena\\Anonymat_Note2.xlsx";
    public static final String MAIL_RECEVER = " ";
    public static final String FILE_OUT ="";

    public static void main(String[] args) throws Exception {

       /*Securite secu = new Securite();


       //utilisateurCourant = new UtilisateurFacade().find(new Long(1));
        // new ModuleFacade().lister();
        secu.setCode((long)9);
        secu.setCreateur(utilisateurCourant);
        for (int i = 0; i < 60; i++) {

            Date d = new Date();
            secu.setDateCreation(d);
            System.out.println(d);
            System.out.println(secu.hashCode());
        }
*/
        Properties properties = new Isj().readSettingApplication();
        new UtilisateurFacade().setProperties((Map)properties);

       //new Isj().setNewClasse(2, 50, 2018, "LIC 2");

       // System.out.println(new Isj().rangEtudiant(2018, "LIC 2", "Semestre 1", "Licence"));

       // new EstInscritFacade().findAll();

       // System.out.println( new EtudiantFacade().find((long)3124).getMatricule());

                //System.out.println(new Isj().retrouverModule("LP324"));
        //new Isj().retrouverUe("INF111");

        //new Isj().sauvegarderEnseignement("C:\\Users\\cena\\Downloads\\Enseignements_Licence_ISJ (2).xlsx");
        //new Isj().importerTypeEvaluation("C:\\Users\\cena\\Downloads\\TypeEva_L2_18_19.xlsx");
       // new Isj().sauvegarderUe("C:\\Users\\cena\\Downloads\\ue licence.xlsx");
//        new Isj().saveModule("C:\\Users\\cena\\Downloads\\module licence.xlsx");
       // new Isj().importerCandidat("C:\\Users\\cena\\Downloads\\cand_Lic2_18-19.xlsx");
        //new Isj().retrouverTypeEvaluation("CC","INF231",2018);


        //new Isj().enregistrerNoteExcel(SAMPLE_XLSX_FILE_PATH);

        //new Isj().saveMatriculeAnonyma(SAMPLE_XLSX_FILE_PATH);

        //new Isj().saveNoteAnonymat(SAMPLE_XLSX_FILE_NOTE_PATH);

        //new Isj().MeilleureNoteEvalution(9);
      // new Isj().createExcelNoteFile(2852 , PATH_OUT_XLSX + "fiche de note.xlsx");

        // new Isj().createExcelAnonymatFile(15 , PATH_OUT_XLSX + "Sortie_ANO.xlsx");

        //new Isj().createExcelAnonymatNoteFile(9, MAIL_RECEVER, PATH_OUT_XLSX  + "Sortie_ANO_Note.xlsx");

        // new Isj().rangEtudiant(2019, 1, "semestre 1", "Licence");
        // new Isj().creerFichePresence(1,"Licence", "semestre 1", 2019, PATH_OUT_XLSX+"ImgOut.xlsx");
        //new Isj().saveAbscence(PATH_OUT_XLSX + "ImgOut.xlsx");
        /*
        Securite user = new Securite();

        new Isj().persist(user);
        Date date = new Date();
       /* Filiere filiere= new Filiere("Licence Professionnelle","Concepteur/Développeur d'applications pour l'économie numérique") ;
        Utilisateur utilisateur = new Utilisateur("second utilisateur","pourra jouer des roles","NDOUMOU","Andre","ndoumouandre@gmail.com",655841232,date, Personne.Sexe.MASCULIN, Personne.Statut.ACTIVE,"andre","1234");
        UtilisateurFacade uf = new UtilisateurFacade();
        Role role = new Role("Enregistreur","pourra lire et ecrire les données");
        RoleFacade rf = new RoleFacade();
        rf.create(role);
        new Isj().insert(utilisateur,role);
        uf.create(utilisateur);
        rf.create(role);
        FiliereFacade ff=new FiliereFacade();
        ff.create(filiere);*/
       /*UtilisateurFacade uf = new UtilisateurFacade();
       utilisateurCourant = uf.find(new Long(1));
        Role role=new RoleFacade().find(new Long(551));

        Utilisateur utilisateur = uf.find(new Long(2));
        //Pour affecter un utilisateur à un role
        new Isj().affecterUtilisateurRole(utilisateur,role);
        System.out.println(utilisateur.getRoles().get(1).getLibelle());
        System.out.println(role.getUtilisateurs().get(0).getNom());*/

       /* UtilisateurFacade uf = new UtilisateurFacade();
        Utilisateur utilisateur = uf.find(new Long(1));
        List<Role> roles = utilisateur.getRoles();
        for (int i = 0; i < roles.size(); i++) {
            System.out.println(roles.get(i).getLibelle());
            List<Droit> droits = roles.get(i).getDroits();
            for (int j = 0; j < droits.size(); j++) {
                System.out.println(droits.get(j).toString());
            }

        }*/

        //test renvoyer login en fonction du numero
        /*
        try {
            Utilisateur u = new Isj().renvoyerLoginTelephone(691063708);
            System.out.println(u.getNom());
        }catch (NoResultException n){
            System.out.println(n.getMessage());
        }*/

        //test renvoyer login en fonction du mail
        /*
        try {
            Utilisateur u = new Isj().renvoyerLoginEmail("ongono@gmail.com");
            System.out.println(u.getNom());
        }catch (NoResultException n){
            System.out.println(n.getMessage());
        }*/

        //test affichage des champs

       /* Utilisateur u = new Utilisateur();
        List <String> champ = new Isj().renvoyerChamp(Utilisateur.class);
        System.out.println(champ.get(0));*/

        //test authentification
        /*
        try {
            Utilisateur utilisateur = new Isj().authentification("yannick", "123456");
            System.out.println(utilisateur.getDateCreation());
        }catch (NoResultException n){
            System.out.println(n.getMessage());
        }*/

        //test isTelephone in BD
        /*
        Boolean u = new Isj().isTelephoneInBD(691063708);
        System.out.println(u);*/

        //test isEmail in BD
        /*
        Boolean u = new Isj().isEmailInBD("tapigue@gmail.com");
        System.out.println(u);*/

        //test sauvegarder email recu en bd

        //Email email = new EmailFacade().find(new Long(151));
        /*
        try {
            CandidatController candidat = new Isj().retrouverCandidatEmail("anthonyfouda@gmai.com");
            Email email = new Email("test","test","Ceci est u test","isj@gmail.com","anthonyfouda@gmail.com","test");
            new EmailFacade().create(email);
            String u = new Isj().sauvegarderEmailSucces(email, candidat);
            System.out.println(u);
        }catch (NoResultException n){
            n.printStackTrace();
        }*/


        /*utilisateurCourant=new UtilisateurFacade().find(new Long(1));
        Role role=new RoleFacade().find(new Long(551));
        //new Isj().creerDroitRole(role);
        new Isj().affecterUtilisateurRole(utilisateurCourant,role);*/
       /* new UtilisateurFacade().merge(utilisateurCourant);
        new RoleFacade().merge(role);*/

        /*
        String s = "test237";
        String q = s.substring(3);
        System.out.println(q);*/

        //test sauvegarder sms
        /*
        try {
            CandidatController candidat = new Isj().retrouverCandidatSms(691063708);
            SmsFacade smsFacade = new SmsFacade();
            Sms sms = new Sms("", "", "Bon", String.valueOf(candidat.getTelephone()), "isj@gmail.com");
            smsFacade.create(sms);
            String result = new Isj().sauvegarderSmsEchec(sms, candidat);
        }catch (NoResultException n){
            n.printStackTrace();
        }*/
        //test de la bd

        /*
        EtudiantFacade etudiantFacade = new EtudiantFacade();
        List <Etudiant> etudiants = etudiantFacade.findAll();
        System.out.println(etudiants.get(0).getNom());*/

    }
    /*public void persist(Object object) {

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("ISJPU");
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            em.persist(object);
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
    }*/

    /**
     * fonction qui affecte un role à un utilisateur
     *
     * @param user c'est un utilisateur
     * @param role c'est le role d'un utilisateur
     */
    public void affecterUtilisateurRole(Utilisateur user, Role role) {
        role.getUtilisateurs().add(user);
        user.getRoles().add(role);
        new RoleFacade().merge(role);
        new UtilisateurFacade().merge(user);
    }

    /**
     * fonction qui crée 27 droits en bd et l'affecte à un role
     *
     * @param role c'est le role d'un utilisateur
     */
    public void creerDroitRole(Role role) {
        Droit tabDroit[] = new Droit[28];
        Class tabClass[] = {
                AnneeAcademique.class, Anonymat.class, Candidat.class, Classe.class, Discipline.class, Droit.class,
                Email.class, Enseignant.class, Enseignement.class, EnvoiMessage.class, EstInscrit.class, Etudiant.class,
                Evaluation.class, Filiere.class, HistoriqueNote.class, Message.class, Module.class, Niveau.class, Note.class,
                Personne.class, Role.class, Securite.class, Semestre.class, Session.class, Specialite.class, TypeEvaluation.class,
                UE.class, Utilisateur.class
        };

        DroitFacade df = new DroitFacade();


        for (int i = 0; i < 10; i++) {
            tabDroit[i] = new Droit("", "", tabClass[i].getSimpleName(), true, true, true, true, role);
            df.create(tabDroit[i]);
        }

    }

    /**
     * fonction qui retourne l'utilisateur par rapport au numéro de téléphone
     *
     * @param numero le numéro de l'utilisateur
     * @return l'utilisateur possédant le téléphone numero
     * @throws NoResultException c'est l'erreur produit
     */
    public Utilisateur renvoyerLoginTelephone(int numero) throws NoResultException {
        String sql = "SELECT u FROM Utilisateur u WHERE u.telephone=:telephone";
        UtilisateurFacade uf = new UtilisateurFacade();
        Query query = uf.getEntityManager().createQuery(sql);
        query.setParameter("telephone", numero);
        return (Utilisateur) query.getSingleResult();
    }

    /**
     * fonction qui vérifie si l'utilisateur possédant le numéro de téléphone est en bd
     *
     * @param numero c'est le numéro de telephone dans la bd
     * @return true si l'utilisateur possédant le numéro de telephone est en bd et false sinon
     */
    public Boolean isTelephoneInBD(int numero) {
        Utilisateur utilisateur = new Utilisateur();
        try {
            utilisateur = renvoyerLoginTelephone(numero);
            return true;
        } catch (NoResultException n) {
            return false;
        }
    }

    /**
     * fonction qui cree un fichier Excel pour enregistrer les notes d'une evaluation (evaluation sans anonymat) specifique
     *
     * @param code_evaluation code de l'evaluation en bd
     * @param pathOut         chemin d'acces vers le repertoire de sauvegarde du fichier.
     * @throws IOException en cas de erreur lors de l'enregistrement du fichier
     */
    public void createExcelNoteFile(long code_evaluation, String pathOut) throws IOException, MessagingException {


        Evaluation evaluation = new EvaluationFacade().find(code_evaluation);
        Enseignement enseignement = evaluation.getTypeEvaluation().getEnseignement();
        UE ue = enseignement.getUe();

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet();

        List<Enseignant> listEnseignant = enseignement.getEnseignants();
        String maillist = "";
        for (Enseignant e : listEnseignant) {
            maillist = e.getEmail()+",";
        }
        if(maillist.isEmpty()) maillist = MAIL_RECEVER;

        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

        //Create Cell Style
        CellStyle cellBold = workbook.createCellStyle();
        CellStyle cellBold_U = workbook.createCellStyle();
        CellStyle cellLight = workbook.createCellStyle();

        Font font = workbook.createFont(); //create a personal font
        font.setFontName("Times New Roman");//set times new roman font type to our cell
        font.setFontHeightInPoints((short) 11);//set font height
        font.setBold(true);

        Font font2 = workbook.createFont();
        font2.setFontName("Times New Roman");//set times new roman font type to our cell
        font2.setFontHeightInPoints((short) 11);//set font height


        Font font3 = workbook.createFont();
        font3.setFontName("Times New Roman");//set times new roman font type to our cell
        font3.setFontHeightInPoints((short) 11);//set font height
        font3.setUnderline(Font.U_SINGLE);
        font3.setBold(true);

        //we set font, horizontal and vertical aligment to our style
        cellBold.setFont(font);
        cellLight.setFont(font2);
        cellBold_U.setFont(font3);

        cellBold.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold.setWrapText(true);

        cellLight.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellLight.setVerticalAlignment(VerticalAlignment.CENTER);
        cellLight.setWrapText(true);

        cellBold_U.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold_U.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold_U.setWrapText(true);


        //we set colum width
        sheet.setColumnWidth(0, 3000);
        sheet.setColumnWidth(1, 3500);
        sheet.setColumnWidth(2, 10000);
        sheet.setColumnWidth(3, 3500);
        sheet.setColumnWidth(4, 4500);
        sheet.setColumnWidth(5, 6500);

        Row row = sheet.createRow(0);
        row.setHeight((short) 600); //set row height
        row.createCell(0).setCellValue("Etudiant");
        row.getCell(0).setCellStyle(cellLight);
        row.createCell(1).setCellValue("");
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(evaluation.getTypeEvaluation().getLibelle());
        row.getCell(2).setCellStyle(cellBold);
        row.createCell(3).setCellValue(ue.getLibelle());
        row.getCell(3).setCellStyle(cellBold_U);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 5)); //MERGE CELL 4 to 8 at ligne 0

        row = sheet.createRow(1);
        row.setHeight((short) 600); //set row height
        row.createCell(0).setCellValue("Evaluation");
        row.getCell(0).setCellStyle(cellLight);
        row.createCell(1).setCellValue(evaluation.getCode());
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(formatter.format(evaluation.getDateEval()));
        row.getCell(2).setCellStyle(cellBold);
        row.createCell(3).setCellValue(ue.getCodeUE());
        row.getCell(3).setCellStyle(cellLight);
        row.createCell(4).setCellValue(ue.getNiveau().toString());
        row.getCell(4).setCellStyle(cellLight);
        String filiereSpecialite = ue.getSpecialite().getLibelle();
        row.createCell(5).setCellValue(filiereSpecialite);
        row.getCell(5).setCellStyle(cellLight);

        row = sheet.createRow(4);
        row.createCell(0).setCellValue("N°");
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue("matricule");
        row.getCell(1).setCellStyle(cellBold);
        row.createCell(2).setCellValue("Nom et Prenom");
        row.getCell(2).setCellStyle(cellBold);
        row.createCell(3).setCellValue("valeur Note");
        row.getCell(3).setCellStyle(cellBold);
        row.createCell(4).setCellValue("Numero de table");
        row.getCell(4).setCellStyle(cellBold);

        List<EstInscrit> listDesEstInscrit = enseignement.getEstInscrits();//retrouverListeEstInscrit(enseignement);


        for (int i = 0; i < listDesEstInscrit.size(); i++) {
            Candidat candidat = null;
            EstInscrit estInscrit = listDesEstInscrit.get(i);

            if( estInscrit.getStatutVie() != EstInscrit.StatutVie.CLOTUREE )
                candidat = estInscrit.getCandidatInscrit();

            long codeEtudiant = candidat.getCode();
            row = sheet.createRow(5 + i);
            row.setHeight((short) 400);
            row.createCell(0).setCellValue(i + 1);
            row.getCell(0).setCellStyle(cellLight);
            row.createCell(1).setCellValue(retrouverEtudiant(codeEtudiant));
            row.getCell(1).setCellStyle(cellLight);
            row.createCell(2).setCellValue(candidat.getNom() + " " + candidat.getPrenom());
            row.getCell(2).setCellStyle(cellLight);

        }

        //
        //Save Excel file
        FileOutputStream fout = new FileOutputStream(new File(pathOut));
        workbook.write(fout);
        fout.close();
        workbook.close();

        String titre = evaluation.getTypeEvaluation().getLibelle() + " " + ue.getCodeUE() + " " + ue.getLibelle() + " du " + formatter.format(evaluation.getDateEval()) + " " + ue.getNiveau().toString();
        SendEmail sendEmail = new SendEmail();
        System.out.println(maillist);
        try {
            sendEmail.sendAttachFile(maillist, "Fiche de Note " + evaluation.getTypeEvaluation().getLibelle() + " " + ue.getCodeUE(), "<h3>" + titre + "</h3>", pathOut);
        }catch (Exception e){
            e.getMessage();
        }
    }

    /**
     * FONCTION QUI CREE LE FICHIER EXCEL DE CORRESPONDANCE ANONYMAT - MATRICULE
     *
     * @param code_evaluation code de l'evalution
     * @param pathOut         repertoire de sortie du fichier
     * @throws IOException en cas d'erreur de sauvegarde du fichier
     */
    public void createExcelAnonymatFile(long code_evaluation, String pathOut) throws IOException {

        Evaluation evaluation = new EvaluationFacade().find(code_evaluation);
        Enseignement enseignement = evaluation.getTypeEvaluation().getEnseignement();
        UE ue = enseignement.getUe();

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet();

        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

        //Create Cell Style
        CellStyle cellBold = workbook.createCellStyle();
        CellStyle cellBold_U = workbook.createCellStyle();
        CellStyle cellLight = workbook.createCellStyle();

        Font font = workbook.createFont(); //create a personal font
        font.setFontName("Times New Roman");//set times new roman font type to our cell
        font.setFontHeightInPoints((short) 11);//set font height
        font.setBold(true);

        Font font2 = workbook.createFont();
        font2.setFontName("Times New Roman");//set times new roman font type to our cell
        font2.setFontHeightInPoints((short) 11);//set font height


        Font font3 = workbook.createFont();
        font3.setFontName("Times New Roman");//set times new roman font type to our cell
        font3.setFontHeightInPoints((short) 11);//set font height
        font3.setUnderline(Font.U_SINGLE);
        font3.setBold(true);

        //we set font, horizontal and vertical aligment to our style
        cellBold.setFont(font);
        cellLight.setFont(font2);
        cellBold_U.setFont(font3);

        cellBold.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold.setWrapText(true);

        cellLight.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellLight.setVerticalAlignment(VerticalAlignment.CENTER);
        cellLight.setWrapText(true);

        cellBold_U.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold_U.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold_U.setWrapText(true);


        sheet.setColumnWidth(0, 3500);
        sheet.setColumnWidth(1, 3500);
        sheet.setColumnWidth(2, 6000);
        sheet.setColumnWidth(3, 3500);
        sheet.setColumnWidth(4, 4500);
        sheet.setColumnWidth(5, 6500);

        Row row = sheet.createRow(0);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue("Etudiant");
        row.getCell(0).setCellStyle(cellLight);
        row.createCell(1).setCellValue("");
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(evaluation.getTypeEvaluation().getLibelle());
        row.getCell(2).setCellStyle(cellBold);
        row.createCell(3).setCellValue(ue.getLibelle());
        row.getCell(3).setCellStyle(cellBold_U);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 5)); //MERGE CELL 4 to 8 at ligne 0

        row = sheet.createRow(1);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue("Evaluation");
        row.getCell(0).setCellStyle(cellLight);
        row.createCell(1).setCellValue(evaluation.getCode());
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(formatter.format(evaluation.getDateEval()));
        row.getCell(2).setCellStyle(cellBold);
        row.createCell(3).setCellValue(ue.getCodeUE());
        row.getCell(3).setCellStyle(cellLight);
        row.createCell(4).setCellValue(ue.getNiveau().toString());
        row.getCell(4).setCellStyle(cellLight);
        String filiereSpecialite = ue.getSpecialite().getLibelle();
        row.createCell(5).setCellValue(filiereSpecialite);
        row.getCell(5).setCellStyle(cellLight);

        row = sheet.createRow(2);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue("numero de table");
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue("numero anonymat");
        row.getCell(1).setCellStyle(cellBold);
        row.createCell(2).setCellValue("matricule");
        row.getCell(2).setCellStyle(cellBold);

        List<EstInscrit> listDesEstInscrit = enseignement.getEstInscrits();//retrouverListeEstInscrit(enseignement);


        for (int i = 0; i < listDesEstInscrit.size(); i++) {
            Candidat candidat = null;
            EstInscrit estInscrit = listDesEstInscrit.get(i);

            if( estInscrit.getStatutVie() != EstInscrit.StatutVie.CLOTUREE )
                candidat = estInscrit.getCandidatInscrit();

            long codeEtudiant = candidat.getCode();
            row = sheet.createRow(3 + i);
            row.setHeight((short) 400);
            row.createCell(2).setCellValue(retrouverEtudiant(codeEtudiant));
            row.getCell(2).setCellStyle(cellLight);

        }

        //Save Excel file
        FileOutputStream fout = new FileOutputStream(new File(pathOut));
        workbook.write(fout);
        fout.close();
        workbook.close();
    }

    /**
     * Fonction qui creer un fichier excel pour l'enregistrement des abscences
     *
     * @param classe     le niveau pour lequelle ont veut generer la liste
     * @param filiere la filiere presice
     * @param annee   l'annee correspondante
     * @throws Exception en cas d'erreur
     */
    public void creerFichePresence(String classe, String filiere, String semestre, int annee, String pathOut) throws Exception {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet();

        String sql = "{CALL etud_class(?,?,?)}";
        CallableStatement procEtudClass = new EtudiantFacade().getConnection().prepareCall(sql);
        procEtudClass.setString(1, classe);
        procEtudClass.setString(2, filiere);
        procEtudClass.setInt(3, annee);
        procEtudClass.execute();
        ResultSet rs = procEtudClass.getResultSet();

        //Create Cell Style
        CellStyle cellBold = workbook.createCellStyle();
        CellStyle cellBold_U = workbook.createCellStyle();
        CellStyle cellLight = workbook.createCellStyle();

        Font font = workbook.createFont(); //create a personal font
        font.setFontName("Times New Roman");//set times new roman font type to our cell
        font.setFontHeightInPoints((short) 11);//set font height
        font.setBold(true);

        Font font2 = workbook.createFont();
        font2.setFontName("Times New Roman");//set times new roman font type to our cell
        font2.setFontHeightInPoints((short) 11);//set font height


        Font font3 = workbook.createFont();
        font3.setFontName("Times New Roman");//set times new roman font type to our cell
        font3.setFontHeightInPoints((short) 11);//set font height
        font3.setUnderline(Font.U_SINGLE);
        font3.setBold(true);

        //we set font, horizontal and vertical aligment to our style
        cellBold.setFont(font);
        cellLight.setFont(font2);
        cellBold_U.setFont(font3);

        cellBold.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold.setWrapText(true);

        cellLight.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellLight.setVerticalAlignment(VerticalAlignment.CENTER);
        cellLight.setWrapText(true);

        cellBold_U.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold_U.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold_U.setWrapText(true);

        sheet.setColumnWidth(0, 1000);
        sheet.setColumnWidth(1, 2700);
        sheet.setColumnWidth(2, 3500);
        sheet.setColumnWidth(3, 3500);
        sheet.setColumnWidth(4, 3500);

        InputStream imageStream = new FileInputStream( "src/main/java/org/isj/metier/input.jpg");

        XSSFDrawing drawing = sheet.createDrawingPatriarch();
        XSSFClientAnchor anchor = new XSSFClientAnchor();
        anchor.setCol1(1);
        anchor.setRow1(2);
        XSSFPicture picture = drawing.createPicture(anchor, workbook.addPicture(imageStream, Workbook.PICTURE_TYPE_JPEG));

        picture.resize(1.5, 5);

        Row row = sheet.createRow(3);
        row.createCell(2).setCellValue("INSTITUT SAINT JEAN");
        row.getCell(2).setCellStyle(cellBold);
        sheet.addMergedRegion(new CellRangeAddress(3, 4, 2, 5));
        row.createCell(8).setCellValue("Tel: (+237) 657 07 98 07");
        row.getCell(8).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(3, 3, 8, 11));

        row = sheet.createRow(4);
        row.createCell(8).setCellValue("(+237) 657 07 98 07");
        row.getCell(8).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(4, 4, 8, 11));

        row = sheet.createRow(5);
        row.createCell(8).setCellValue("B.P: 749 Yaoundé, Cameroun");
        row.getCell(8).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(5, 5, 8, 11));

        row = sheet.createRow(6);
        row.createCell(8).setCellValue("Email: info@institutsaintjean.org");
        row.getCell(8).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(6, 6, 8, 11));

        row = sheet.createRow(7);
        row.createCell(8).setCellValue("www.institutsaintjean.org");
        row.getCell(8).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(7, 7, 8, 11));

        row = sheet.createRow(9);
        row.createCell(3).setCellValue("FICHE DE PRESENCE");
        row.getCell(3).setCellStyle(cellBold);
        sheet.addMergedRegion(new CellRangeAddress(9, 9, 3, 6));

        row = sheet.createRow(10);
        row.createCell(1).setCellValue(semestre);
        row.getCell(1).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(10, 10, 1, 2));
        row = sheet.createRow(11);
        row.createCell(1).setCellValue("Classe:");
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(classe);
        row.getCell(2).setCellStyle(cellBold);
        sheet.addMergedRegion(new CellRangeAddress(11, 11, 2, 3));
        row = sheet.createRow(12);
        row.createCell(1).setCellValue("Date:");
        row.getCell(1).setCellStyle(cellLight);
        sheet.addMergedRegion(new CellRangeAddress(12, 12, 2, 3));

        row = sheet.createRow(14);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue("N°");
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue("Matricule");
        row.getCell(1).setCellStyle(cellBold);
        row.createCell(2).setCellValue("Noms et prenoms");
        row.getCell(2).setCellStyle(cellBold);
        sheet.addMergedRegion(new CellRangeAddress(14, 14, 2, 4));
        row.createCell(5).setCellValue("7h30-8h30");
        row.getCell(5).setCellStyle(cellBold);
        row.createCell(6).setCellValue("8h30-9h30");
        row.getCell(6).setCellStyle(cellBold);
        row.createCell(7).setCellValue("9h30-10h30");
        row.getCell(7).setCellStyle(cellBold);
        row.createCell(8).setCellValue("10h30-11h30");
        row.getCell(8).setCellStyle(cellBold);
        row.createCell(9).setCellValue("12h30-13h30");
        row.getCell(9).setCellStyle(cellBold);
        row.createCell(10).setCellValue("13h30-14h30");
        row.getCell(10).setCellStyle(cellBold);
        row.createCell(11).setCellValue("14h30-15h30");
        row.getCell(11).setCellStyle(cellBold);
        row.createCell(12).setCellValue("15h30-16h30");
        row.getCell(12).setCellStyle(cellBold);
        row.createCell(13).setCellValue("16h30-17h30");
        row.getCell(13).setCellStyle(cellBold);


        int r = 15, i = 0;
        row = sheet.createRow(15);
        while (rs.next()) {
            row.setHeight((short) 400);
            row.createCell(0).setCellValue(i + 1);
            row.getCell(0).setCellStyle(cellLight);
            row.createCell(1).setCellValue(rs.getString(1));
            row.getCell(1).setCellStyle(cellLight);
            row.createCell(2).setCellValue(rs.getString(2));
            row.getCell(2).setCellStyle(cellLight);
            sheet.addMergedRegion(new CellRangeAddress(r, r, 2, 4));

            i += 1;
            r += 1;
            row = sheet.createRow(r);
        }

        FileOutputStream fos = new FileOutputStream(new File(pathOut));
        workbook.write(fos);
        imageStream.close();
        fos.close();
        workbook.close();
    }

    /**
     * Fonction qui creer le fichier excel de correspondance anonymat - valeur note
     *
     * @param code_evaluation code de l'evaluation
     * @param pathOut         repertoire de sortie du fichier
     * @throws IOException en cas d'erreur lors de la sauvegarde du fichier
     */
    public void createExcelAnonymatNoteFile(long code_evaluation, String pathOut) throws IOException, MessagingException {

        Evaluation evaluation = new EvaluationFacade().find(code_evaluation);
        Enseignement enseignement = evaluation.getTypeEvaluation().getEnseignement();
        UE ue = enseignement.getUe();

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet();

        List<Enseignant> listEnseignant = enseignement.getEnseignants();
        String maillist = "";
        for (Enseignant e : listEnseignant) {
            maillist = e.getEmail()+",";
        }
        if(maillist.isEmpty())maillist = MAIL_RECEVER ;

        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");


        //Create Cell Style
        CellStyle cellBold = workbook.createCellStyle();
        CellStyle cellBold_U = workbook.createCellStyle();
        CellStyle cellLight = workbook.createCellStyle();

        Font font = workbook.createFont(); //create a personal font
        font.setFontName("Times New Roman");//set times new roman font type to our cell
        font.setFontHeightInPoints((short) 11);//set font height
        font.setBold(true);

        Font font2 = workbook.createFont();
        font2.setFontName("Times New Roman");//set times new roman font type to our cell
        font2.setFontHeightInPoints((short) 11);//set font height


        Font font3 = workbook.createFont();
        font3.setFontName("Times New Roman");//set times new roman font type to our cell
        font3.setFontHeightInPoints((short) 11);//set font height
        font3.setUnderline(Font.U_SINGLE);
        font3.setBold(true);

        //we set font, horizontal and vertical aligment to our style
        cellBold.setFont(font);
        cellLight.setFont(font2);
        cellBold_U.setFont(font3);

        cellBold.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold.setWrapText(true);

        cellLight.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellLight.setVerticalAlignment(VerticalAlignment.CENTER);
        cellLight.setWrapText(true);

        cellBold_U.setAlignment(HorizontalAlignment.CENTER_SELECTION);
        cellBold_U.setVerticalAlignment(VerticalAlignment.CENTER);
        cellBold_U.setWrapText(true);


        sheet.setColumnWidth(0, 4000);
        sheet.setColumnWidth(1, 3500);
        sheet.setColumnWidth(2, 3500);
        sheet.setColumnWidth(3, 5500);

        Row row = sheet.createRow(0);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue(evaluation.getTypeEvaluation().getLibelle());
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue(ue.getLibelle());
        row.getCell(1).setCellStyle(cellBold_U);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 1, 4)); //MERGE CELL 4 to 8 at ligne 0


        row = sheet.createRow(1);
        row.createCell(0).setCellValue(formatter.format(evaluation.getDateEval()));
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue(ue.getCodeUE());
        row.getCell(1).setCellStyle(cellLight);
        row.createCell(2).setCellValue(ue.getNiveau().toString());
        row.getCell(2).setCellStyle(cellLight);
        String filiereSpecialite = ue.getSpecialite().getLibelle();
        row.createCell(3).setCellValue(filiereSpecialite);
        row.getCell(3).setCellStyle(cellLight);

        List<Anonymat> listeAnonymat = retrouverListeAnonymat(evaluation);

        for (int i = 0; i < listeAnonymat.size(); i++) {
            Anonymat anonymat = listeAnonymat.get(i);
            row = sheet.createRow(5 + i);
            row.setHeight((short) 600);
            row.createCell(0).setCellValue(anonymat.getNumeroAnonymat());
            row.getCell(0).setCellStyle(cellLight);
        }

        row = sheet.createRow(4);
        row.setHeight((short) 600);
        row.createCell(0).setCellValue("numero anonymat");
        row.getCell(0).setCellStyle(cellBold);
        row.createCell(1).setCellValue("valeur note");
        row.getCell(1).setCellStyle(cellBold);

        //Save Excel file
        FileOutputStream fout = new FileOutputStream(new File(pathOut));
        workbook.write(fout);
        fout.close();
        workbook.close();

        String titre = evaluation.getTypeEvaluation().getLibelle() + " " + ue.getLibelle() + " du " + formatter.format(evaluation.getDateEval()) + " " + ue.getNiveau().toString();
        SendEmail sendEmail = new SendEmail();
        try {
            sendEmail.sendAttachFile(maillist, "Fiche de Note ", "<h3>" + titre + "</h3>", pathOut);
        }catch (Exception e){
            e.getMessage();
        }

    }



    /**
     * fonction qui renvoie la meilleure note et la pire note a une evaluation specifique
     *
     * @param codeEvaluation code de l'evaluation en bd
     * @return tableau ave la premiere valeur etant la premiere
     */
    public double[] MeilleureNoteEvalution(long codeEvaluation) {
        Evaluation evaluation = new EvaluationFacade().find(codeEvaluation);
        double noteMax = -1, noteMin = 21; //si note Max vaut 21 alors aucun resultat si note min vaut -1 alors aucun resultat
        double moyenneMax = -1, moyenneMin = -1;
        List<Note> listeNote = retrouverListeNote(evaluation);

        for (Note n : listeNote) {
            if (n.getValeurNote() < noteMin) noteMin = n.getValeurNote();

            if (n.getValeurNote() >= noteMax)
                noteMax = n.getValeurNote();
        }
        String libelle = evaluation.getTypeEvaluation().getLibelle() + "\t" + evaluation.getTypeEvaluation().getEnseignement().getUe().getLibelle();
        System.out.println(libelle);
        System.out.println("noteMin: " + noteMin);
        System.out.println("noteMax: " + noteMax);
        double minMax[] = {noteMax, noteMin};

        return minMax;
    }

    public void sauvegarderUe(String pathOut) throws IOException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        //création d'un classeuR
        XSSFWorkbook wb = new XSSFWorkbook(fis);
        Iterator<Sheet> sheetIterator = wb.sheetIterator();

        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            DataFormatter dataFormatter = new DataFormatter();
            //on itère sur les lignes
            Iterator<Row> rowIt = sheet.rowIterator();
            String odlMod = sheet.getRow(1).getCell(3).getStringCellValue();
            String niv = String.valueOf(sheet.getRow(1).getCell(4).getNumericCellValue());
            String spe = sheet.getRow(1).getCell(5).getStringCellValue();
            while (rowIt.hasNext()) {
                Row row = rowIt.next();
                int numRow = row.getRowNum();
                if (numRow > 0) {
                    String codeUe, libelle, mod, cred, niveau, specialite;

                    codeUe = dataFormatter.formatCellValue(row.getCell(0));
                    libelle = dataFormatter.formatCellValue(row.getCell(1));
                    cred = dataFormatter.formatCellValue(row.getCell(2));
                    mod = dataFormatter.formatCellValue(row.getCell(3));
                    niveau = dataFormatter.formatCellValue(row.getCell(4));
                    specialite = dataFormatter.formatCellValue(row.getCell(5));
                    if (!libelle.isEmpty()|| !codeUe.isEmpty() || !cred.isEmpty()) {

                        if (mod.isEmpty()) mod = odlMod;
                        else odlMod = dataFormatter.formatCellValue(row.getCell(3));

                        if (niveau.isEmpty()) niveau = niv;
                        else niv = dataFormatter.formatCellValue(row.getCell(4));

                        if (specialite.isEmpty()) specialite = spe;
                        else spe = dataFormatter.formatCellValue(row.getCell(5));

                        UE ue = new UE(libelle, "", codeUe, UE.Statut.ACTIVE, Integer.valueOf(cred), retrouverModule(mod), retrouverNiveau(Long.valueOf(niveau)), retrouverSpecialite(specialite));
                       new UEFacade().create(ue);
                        //System.out.println(codeUe+" "+libelle+" "+" "+cred+" "+retrouverModule(mod)+" "+retrouverNiveau(Long.valueOf(niveau))+" "+retrouverSpecialite(specialite));

                    }

                }
            }
        }
        fis.close();
        wb.close();
    }

    public void sauvegarderEnseignement(String pathOut) throws IOException, SQLException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook wb = new XSSFWorkbook(fis);
        Iterator<Sheet> sheetIterator = wb.sheetIterator();

        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();

            DataFormatter dataFormatter = new DataFormatter();
            //on itère sur les lignes
            Iterator<Row> rowIt = sheet.rowIterator();
            while (rowIt.hasNext()) {
                Row row = rowIt.next();
                int numRow = row.getRowNum();
                if (numRow > 0) {
                    String description, libelle, prog, codeUe;
                    int heure;
                    long anDeb, numSemestre;

                    description = dataFormatter.formatCellValue(row.getCell(0)).trim();
                    heure = Integer.valueOf(dataFormatter.formatCellValue(row.getCell(1)));
                    libelle = dataFormatter.formatCellValue(row.getCell(2)).trim();
                    prog = dataFormatter.formatCellValue(row.getCell(3));
                    numSemestre = Long.valueOf(dataFormatter.formatCellValue(row.getCell(4)));
                    anDeb = (long) row.getCell(5).getNumericCellValue();
                    codeUe = dataFormatter.formatCellValue(row.getCell(6));
                   // System.out.println(codeUe);

                    Semestre semestre = new SemestreFacade().find(retrouverCodeSemestre(numSemestre, anDeb));
                    Enseignement En = new Enseignement(libelle, description, heure, prog, semestre, retrouverUe(codeUe));
//                    System.out.println(description + " - " + heure + " - " + libelle + " - " + prog + " - " + semestre.getCode() + " - " + anDeb + " - " + codeUe);
                    new EnseignementFacade().create(En);
                }
            }

        }
        fis.close();
        wb.close();
    }

    public void saveModule(String pathOut) throws IOException {

        FileInputStream fis = new FileInputStream(new File(pathOut));
        //création d'un classeuR
        XSSFWorkbook wb = new XSSFWorkbook(fis);
        Iterator<Sheet> sheetIterator = wb.sheetIterator();

        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();

            DataFormatter dataFormatter = new DataFormatter();
            //on itère sur les lignes
            Iterator<Row> rowIt = sheet.rowIterator();
            while (rowIt.hasNext()) {
                Row row = rowIt.next();
                Iterator<Cell> cellIt = row.cellIterator();
                int numRow = row.getRowNum();
                if (numRow > 0) {
                    String codeModule, libelle, description;
                    codeModule = dataFormatter.formatCellValue(row.getCell(0));
                    libelle = dataFormatter.formatCellValue(row.getCell(1));
                    description = dataFormatter.formatCellValue(row.getCell(2));
                    if (!libelle.isEmpty() && !codeModule.isEmpty() || !description.isEmpty()) {
                        Module module = new Module(libelle, description, codeModule);
//                        System.out.println(module);
                        new ModuleFacade().create(module);
                    }
                }
            }
        }
        fis.close();
        wb.close();
    }

    public void importerTypeEvaluation(String pathOut) throws IOException, SQLException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            String oldLibEns = sheet.getRow(4).getCell(3).getStringCellValue();
            String tmpAnne = sheet.getRow(0).getCell(1).getStringCellValue();
            int anneDebut = Integer.valueOf(tmpAnne.substring(0, tmpAnne.indexOf("/")));

            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();

                if (numrow > 3) {
                    Enseignement enseignement = null;
                    String libelle, description, libEns, resultat;
                    float pourcentage = 0;

                    libelle = row.getCell(0).getStringCellValue().toUpperCase();
                    description = row.getCell(1).getStringCellValue();
                    pourcentage = ((float) row.getCell(2).getNumericCellValue());
                    libEns = row.getCell(3).getStringCellValue();

                    if(libEns.isEmpty()) libEns = oldLibEns;
                    else oldLibEns =row.getCell(3).getStringCellValue();

                    //System.out.println(libEns);
                    enseignement = new EnseignementFacade().find(retrouverEnseignement(libEns.trim(), anneDebut));
                    //System.out.println(enseignement);
                    TypeEvaluation typeEvaluation = new TypeEvaluation(libelle,description,pourcentage, enseignement);
                    resultat = new TypeEvaluationFacade().create(typeEvaluation);
                   //System.out.println(libelle+" - "+description+" - "+pourcentage+" - "+enseignement);


                }
            }
        }
        workbook.close();
        fis.close();
    }


    public void importerCandidat(String pathOut) throws IOException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();

            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();

                if (numrow > 0) {
                    String matricule ="", nom = "", prenom = "", lieuNaiss = "", sexe = "", ecoleOrigine = "", email = "", nomPere = "";
                    String professionPere = "", professionMere = "", regionOrigin = "", Dtype = "", nomMere = "", codeAuth ="";
                    Classe classe = null;
                    Date dateNaiss;
                    int telpPere, telpMere, telpEtud;

                    matricule = row.getCell(0).getStringCellValue();
                    nom = row.getCell(1).getStringCellValue();
                    prenom = row.getCell(2).getStringCellValue();
                    classe = retrouverClasse(row.getCell(3).getStringCellValue());
                    telpEtud = (int) row.getCell(4).getNumericCellValue();
                    dateNaiss = row.getCell(5).getDateCellValue();

                    sexe = row.getCell(7).getStringCellValue();
                    ecoleOrigine = row.getCell(8).getStringCellValue();
                    email = row.getCell(9).getStringCellValue();
                    nomPere = row.getCell(11).getStringCellValue();
                    professionPere = row.getCell(12).getStringCellValue();
                    nomMere = row.getCell(13).getStringCellValue();
                    professionMere = row.getCell(14).getStringCellValue();
                    regionOrigin = row.getCell(15).getStringCellValue();
                    Dtype = row.getCell(16).getStringCellValue();
                    telpMere = (int) row.getCell(17).getNumericCellValue();
                    telpPere = (int) row.getCell(18).getNumericCellValue();

                    codeAuth = String.valueOf(new Eleve().code(matricule));

                    if(Dtype.equalsIgnoreCase("Etudiant"))
                        new EtudiantFacade().enregistrer(null, null, nom, prenom, email, telpEtud, dateNaiss, Personne.Sexe.valueOf(sexe), Candidat.Statut.ACTIVE, nomMere, nomPere, telpMere, telpPere, professionPere, professionMere, regionOrigin, ecoleOrigine, matricule, codeAuth,classe);
                    else
                        new CandidatFacade().enregistrer(null, null, nom, prenom, email, telpEtud, dateNaiss, Personne.Sexe.valueOf(sexe), Candidat.Statut.ACTIVE, nomMere, nomPere, telpMere, telpPere, professionPere, professionMere, regionOrigin, ecoleOrigine, classe);
                    //System.out.println(candidat);



                }

            }
        }
        fis.close();
        workbook.close();
    }

    public void importerEvaluation(String pathOut)throws IOException, SQLException, MessagingException {
        File file = new File(pathOut);
        FileInputStream fis = new FileInputStream(file);
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            String tmpAnne = sheet.getRow(0).getCell(1).getStringCellValue();
            int anneDebut = Integer.valueOf(tmpAnne.substring(0, tmpAnne.indexOf("/")));

            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();

                if (numrow > 3) {
                    String libelle, description, typeEval, codeUE;
                    Date date;

                    date = row.getCell(0).getDateCellValue();
                    description = row.getCell(1).getStringCellValue().toUpperCase().trim();
                    libelle = row.getCell(2).getStringCellValue();

                    typeEval = description.substring(0,description.indexOf(" ")).trim();
                    codeUE = description.substring(description.indexOf(" ")).trim();


                    TypeEvaluation typeEvaluation = new TypeEvaluationFacade().find(retrouverTypeEvaluation(typeEval, codeUE, anneDebut));
                    //System.out.println(retrouverTypeEvaluation(typeEval, codeUE, anneDebut));
                    //System.out.println(typeEval+" "+codeUE+" "+anneDebut+" "+typeEvaluation);
                    Evaluation evaluation = new Evaluation(libelle,description, date,Evaluation.Statut.ACTIVE,typeEvaluation);
                    new EvaluationFacade().create(evaluation);

                   long id = retrouverLast();
                    SimpleDateFormat formatter = new SimpleDateFormat("dd_MM_yyyy");
                    String tpyEv = description.trim().substring(0, 2), libEval = evaluation.getTypeEvaluation().getEnseignement().getUe().getLibelle(),
                            filier =evaluation.getTypeEvaluation().getEnseignement().getUe().getSpecialite().getFiliere().getLibelle();
                    int niv = evaluation.getTypeEvaluation().getEnseignement().getUe().getNiveau().getNumero();
                    libEval = libEval.replaceAll(" ","_");
                    libEval = libEval.replaceAll("/","_");

                    String anonymat =  file.getParent() +File.separator+ "Fiche_de_Note_"+tpyEv+"_"+formatter.format(date)+"_"+libEval+"_"+filier+"_"+niv+".xlsx";

                    //System.out.println(anonymat+"-"+tpyEv);
                    if(tpyEv.equalsIgnoreCase("CC") || (tpyEv.equalsIgnoreCase("TP"))){
                        createExcelNoteFile(id, anonymat);
                    }else if (tpyEv.equalsIgnoreCase("SN") || (tpyEv.equalsIgnoreCase("RA"))){
                        createExcelAnonymatFile(id, anonymat);
                    }

                }
            }
        }
        workbook.close();
        fis.close();
    }

    public void importerEstInscrit(String pathOut) throws IOException, SQLException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook workbook = new XSSFWorkbook(fis);
        Candidat candidat = null;
        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            String tmpAnne = sheet.getRow(0).getCell(1).getStringCellValue();

            int anneDebut = Integer.valueOf(tmpAnne.substring(0, tmpAnne.indexOf("/")));

            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();
                String libelle, description, libEns, matricule = null;

                if (numrow >= 3) {
                    System.out.println(row.getRowNum());
                    Iterator<Cell> cellIterator = row.cellIterator();

                    while(cellIterator.hasNext()){
                        Cell cell = cellIterator.next();

                        if(cell.getColumnIndex() == 0) {
                            matricule = cell.getStringCellValue().trim();
                            candidat = retrouverEtudiantMatricule(matricule);
                        }
                        if(cell.getColumnIndex() >= 2 && cell.getStringCellValue().equalsIgnoreCase("oui"))  {
                            description = sheet.getRow(1).getCell(cell.getColumnIndex()).getStringCellValue().toUpperCase().trim();
                            libEns = sheet.getRow(2).getCell(cell.getColumnIndex()).getStringCellValue().trim();
                            long id = retrouverEnseignement(libEns, anneDebut);
                            Enseignement enseignement = new EnseignementFacade().find(id);
                            if(id != -1) {
                               new EstInscritFacade().enregistrer("", description, EstInscrit.Statut.VALIDE, candidat, enseignement);
                               //System.out.println(description + " " + matricule + " " + " " + libEns + " " + candidat+ " " + retrouverEnseignement(libEns, anneDebut));
                            }
                        }

                    }

                }
            }
        }
        workbook.close();
        fis.close();
    }

    public void importerListeNote(String pathOut) throws SQLException, IOException {
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        double valeurNote = 0;
        int numeroTable = 0;

        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            String tmpAnne = sheet.getRow(0).getCell(1).getStringCellValue();

            int anneDebut = Integer.valueOf(tmpAnne.substring(0, tmpAnne.indexOf("/")));

            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();
                String libelle, libelleEval, matricule = null, codeUE, typeEval, description, oldLibelle, oldCode;

                oldLibelle = sheet.getRow(2).getCell(1).getStringCellValue().trim();
                oldCode = sheet.getRow(1).getCell(1).getStringCellValue().toUpperCase().trim();

                if (numrow >= 4) {

                    System.out.println(row.getRowNum());
                    Iterator<Cell> cellIterator = row.cellIterator();

                    while (cellIterator.hasNext()) {
                        Cell cell = cellIterator.next();

                        if (cell.getColumnIndex() == 0) {
                            matricule = cell.getStringCellValue().trim();
                        }
                        if (cell.getColumnIndex() > 0) {
                            libelleEval = sheet.getRow(2).getCell(cell.getColumnIndex()).getStringCellValue().toUpperCase().trim();
                            codeUE = sheet.getRow(1).getCell(cell.getColumnIndex()).getStringCellValue().toUpperCase().trim();

                            if (libelleEval.isEmpty() || codeUE.isEmpty()) {
                                libelleEval = oldLibelle;
                                codeUE = oldCode;
                            } else {
                                oldLibelle = libelleEval;
                                oldCode = codeUE;
                            }

                            typeEval = sheet.getRow(3).getCell(cell.getColumnIndex()).getStringCellValue().toUpperCase().trim();
                            //System.out.println(cell.getColumnIndex());
                            try {
                                valeurNote = cell.getNumericCellValue();
                                //numeroTable = (int) cell.getNumericCellValue();

                                long id_estInscrit = retrouverCodeEstInscrit(matricule, libelleEval, anneDebut);
                                //
                                long id_typEvalation = retrouverTypeEvaluation(typeEval, codeUE, anneDebut);
                                System.out.println(id_typEvalation);
                                TypeEvaluation typeEvaluation = new TypeEvaluationFacade().find(id_typEvalation);
                                //System.out.println(codeUE+" - "+typeEval+" - "+anneDebut);
                                if(valeurNote == 0){ valeurNote = 0.001;}
                                Note note = new Note(libelleEval, typeEval, valeurNote, numeroTable, null, new EstInscritFacade().find(id_estInscrit), retrouverEvaluation(typeEvaluation));
                                new NoteFacade().create(note);

                            } catch (Exception e) {
                                e.getMessage();
                            }
                            //System.out.println(libelleEval+" "+typeEval+" "+valeurNote+" "+new EstInscritFacade().find(id_estInscrit)+" "+typeEvaluation);

                        }
                    }

                }
            }
        }
        workbook.close();
        fis.close();
    }

    public void importerDiscipline(String pathOut)throws IOException{
        FileInputStream fis = new FileInputStream(new File(pathOut));
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        Iterator<Sheet> sheetIterator = workbook.sheetIterator();
        while (sheetIterator.hasNext()) {
            Sheet sheet = sheetIterator.next();
            String tmpAnne = sheet.getRow(0).getCell(1).getStringCellValue();
            String oldMat = sheet.getRow(2).getCell(1).getStringCellValue();
            String oldLibelle = sheet.getRow(2).getCell(1).getStringCellValue();

            int anneDebut = Integer.valueOf(tmpAnne.substring(0, tmpAnne.indexOf("/")));
            Iterator<Row> rowIterator = sheet.iterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                int numrow = row.getRowNum();

                if (numrow > 1 ){
                    String libelle="", libSemestre = null, matricule ="", description = "", nomEtud;
                    Date Date_Displine = null;
                    int Nbheure = 0, NbRetard = 0, heureJustifier = 0;

                    try {
                        description = row.getCell(0).getStringCellValue().trim();
                        libelle = row.getCell(1).getStringCellValue();
                        Date_Displine = row.getCell(2).getDateCellValue();
                        Nbheure = (int) row.getCell(3).getNumericCellValue();
                        NbRetard = (int) row.getCell(4).getNumericCellValue();
                        libSemestre = row.getCell(5).getStringCellValue().toUpperCase().trim();

                        matricule = description.substring(0,description.indexOf(" ")).trim();

                        AnneeAcademique anneeAcademique = retrouverAnneeAcademique(Date_Displine);
                        Semestre semestre = retrouverSemestre(libSemestre, anneeAcademique);
                        Etudiant etudiant = retrouverEtudiantMatricule(matricule);

                        if(etudiant != null) {
                            Discipline discipline = new Discipline(libelle, description, etudiant, semestre, Nbheure, NbRetard, Date_Displine, 0);
                            new DisciplineFacade().create(discipline);
                        }
                    }catch (Exception e){
                        e.getMessage();
                    }

                }
            }
        }
        workbook.close();
        fis.close();
    }

    public void enregistrerNoteExcel(String cheminAcces) throws IOException, InvalidFormatException {
        Workbook workbook = new WorkbookFactory().create(new File(cheminAcces));

        Sheet sheet = workbook.getSheetAt(0);

        DataFormatter dataFormatter = new DataFormatter();
        Iterator<Row> rowIterator = sheet.rowIterator();
        String matricule = null;
        String reponse = null;
        Evaluation evaluation = null;
        int numeroTable = 0;
        double valeurNote = -1;//si note non definit alors note vaut -1 et on ne l'afficheras pas.
        Etudiant etudiant = null;
        Candidat candidat = null;
        TypeEvaluation typeEvaluation = null;
        Enseignement enseignement = null;
        EstInscrit estInscrit = null;
        String resultat = null, code = null;
        int numeroLigne = -1;
        while (rowIterator.hasNext()) {

            Row row = rowIterator.next();
            numeroLigne = row.getRowNum();
            if (numeroLigne == 0) {
                reponse = dataFormatter.formatCellValue(row.getCell(1));
            } else if (numeroLigne == 1) {
                evaluation = new EvaluationFacade().find(Long.valueOf(dataFormatter.formatCellValue(row.getCell(1))));
                typeEvaluation = evaluation.getTypeEvaluation();
                enseignement = typeEvaluation.getEnseignement();
            } else if (numeroLigne >= 5) {
                try {
                    valeurNote = Double.valueOf(dataFormatter.formatCellValue(row.getCell(3)));
                    numeroTable = Integer.valueOf(dataFormatter.formatCellValue(row.getCell(4)));

                    if (reponse.equals("oui")) {
                        matricule = dataFormatter.formatCellValue(row.getCell(1));
                        etudiant = new Isj().retrouverEtudiantMatricule(matricule);
                        estInscrit = new Isj().retrouverEstInscrit(etudiant, enseignement);

                        //resultat = new NoteFacade().enregistrer("", "", valeurNote, numeroTable, null, estInscrit, evaluation);
                    } else if (reponse.equals("non")) {
                        code = dataFormatter.formatCellValue(row.getCell(1));
                        candidat = new CandidatFacade().find(Long.valueOf(code));
                        estInscrit = new Isj().retrouverEstInscrit(candidat, enseignement);
                        //resultat = new NoteFacade().enregistrer("", "", valeurNote, numeroTable, null, estInscrit, evaluation);
                    }
                } catch (Exception e) {
                    resultat = e.getMessage();
                }
            }
        }
    }

    public void setNewClasse(double mgpMin, int creditMin, int annee, String libelleClasse) throws SQLException {
        Classe classe = retrouverClasse(libelleClasse);
        List<Candidat> ListCandidats = classe.getCandidats();
        List<UE> ListUes = classe.getNiveau().getUes();

        UE ue = null;

        double moyenne, mgp_ann = 0, creditAn = 0, moyenneUe;

        int niv = classe.getNiveau().getNumero(), creditMax =0;

        String sql = "{? = CALL moy_sem(?,?,?,?)}", sql3 = "{ CALL enseignement_Etudiant(?,?)}",
                sql4 ="{? = CALL moyenne_ue_etudiant(?,?,?)}", sql2 = "{ ? = CALL ens_exist(?,?,?)}";
        Connection con = new ClasseFacade().getConnection();

        CallableStatement funCredAn = null, funcMoySem = null, funcListEns = null, funcMoyEns = null, funcEnsExist = null;

        funcMoySem = con.prepareCall(sql);
        funcMoySem.registerOutParameter(1, java.sql.Types.FLOAT);
        funcMoySem.setInt(3, niv);
        funcMoySem.setInt(4, annee);

        funcListEns = con.prepareCall(sql3);
        funcListEns.setInt(2, annee);

        funcMoyEns = con.prepareCall(sql4);
        funcMoyEns.registerOutParameter(1, java.sql.Types.FLOAT);
        funcMoyEns.setInt(4, annee);

        funcEnsExist = con.prepareCall(sql2);
        funcEnsExist.registerOutParameter(1, java.sql.Types.FLOAT);
        funcEnsExist.setInt(3, annee+1);
        funcEnsExist.setInt(4, niv);

        for(Candidat candidat: ListCandidats){
            moyenne = 0; creditMax =0; creditAn = 0; mgp_ann = 0;
            String matricule = null;
            Etudiant etudiant = new EtudiantFacade().find(candidat.getCode());
            matricule = etudiant.getMatricule();

            funcMoySem.setString(2,matricule);
            funcMoySem.setString(5, "Semestre 1");
            funcMoySem.execute();
            moyenne += funcMoySem.getFloat(1);
           // System.out.println(moyenne);
            funcMoySem.setString(5, "Semestre 2");
            funcMoySem.execute();
            moyenne += funcMoySem.getFloat(1);

            //System.out.println(matricule+" "+moyenne/2);
            mgp_ann = retournerMgp(moyenne/2);

            //System.out.println(mgp_ann);
            funcListEns.setString(1, matricule);
            funcListEns.execute();
            ResultSet rs = funcListEns.getResultSet();

                while(rs.next()){
                    moyenneUe = 0;
                    int codeEns = rs.getInt(2), codeEstInscrit = rs.getInt(1);
                    funcMoyEns.setString(2, matricule);
                    funcMoyEns.setInt(3, codeEns);
                    funcMoyEns.execute();

                    try{
                        moyenneUe = funcMoyEns.getFloat(1);
                        //System.out.println(codeEns+" "+matricule+" "+moyenneUe);

                    }catch (Exception e){
                        moyenneUe = 0;
                        //System.out.println(moyenneUe);
                    }

                    Enseignement enseignement = new EnseignementFacade().find((long)codeEns);
                    //System.out.println(enseignement);
                    creditMax +=enseignement.getUe().getCredits();
                    if(moyenneUe>=9){

                        creditAn +=enseignement.getUe().getCredits();
                        System.out.println("validé");
                        //System.out.println("CREDIT ANNUEL"+" - "+ creditAn+" - "+ creditMax +" - "+ enseignement);
                    } else {
                        funcEnsExist.setString(2, enseignement.getLibelle());
                        funcEnsExist.execute();
                        long idEns = funcEnsExist.getInt(1);
                        System.out.println("non validé");
                        if(idEns != -1) {
                            System.out.println("reprendre la matiere non validé");
                            //new EstInscritFacade().enregistrer(enseignement.getUe().getCodeUE(),"",EstInscrit.Statut.VALIDE, candidat, enseignement);
                            System.out.println("reprendre la matiere "+enseignement.getUe().getCodeUE()+" "+EstInscrit.Statut.VALIDE+" "+candidat+" "+enseignement);
                        }
                    }
                    //EstInscrit estInscrit = new EstInscritFacade().find((long)codeEstInscrit);
                    //estInscrit.setStatutVie(EstInscrit.StatutVie.CLOTUREE);
                }

            System.out.println("CREDIT ANNUEL"+" - "+ creditAn+" - "+ creditMax+" - "+ mgp_ann);
            if((creditAn >= creditMin) && (mgp_ann >= mgpMin)){
                //candidat.setClasse();
               // classe.setSpecialite().;
                System.out.println(candidat+"ADMIS"+"\n\n\n");
               // candidat.setClasse(retrouverClasse("LIC 2"));
            }else{
                System.out.println(candidat + "ECHEC"+"\n\n\n");
            }

        }
    }

    /**
     * Associe un matricule a un anonymat a partir d'un fichier Excel et le sauvegarde en base de donnees
     *
     * @param cheminAcces chemin d'acces vers le ficier
     * @throws IOException en coas d'erreur lors de l'ouverture du fichier
     */
    public void saveMatriculeAnonyma(String cheminAcces) throws IOException {
        File file = new File(cheminAcces);
        Workbook workbook = new WorkbookFactory().create(file);

        //ON RECUPERE LA FEUILLE
        Sheet sheet = workbook.getSheetAt(0);

        DataFormatter dataFormatter = new DataFormatter();

        //ON ITERER SUR LES LIGNES DU FICHIER XML
        Iterator<Row> rowIterator = sheet.rowIterator();
        String matricule = null;
        String reponse = null, rowName = null;
        Evaluation evaluation = null;
        int numeroTable = 0;
        double valeurNote = -1; //si note non definit alors note vaut -1 et on ne l'afficheras pas.
        int num_anonymat = 0;
        long id = 0;
        Etudiant etudiant = null;
        Candidat candidat = null;
        TypeEvaluation typeEvaluation = null;
        Enseignement enseignement = null;
        EstInscrit estInscrit = null;
        String resultat = null;
        int numeroLigne = -1;

        //on parcours le fichier tant que la ligne suivante est definie
        while (rowIterator.hasNext()) {
            numeroLigne++;
            Row row = rowIterator.next();
            if (numeroLigne == 0) {
                reponse = dataFormatter.formatCellValue(row.getCell(1));
            } else if (numeroLigne == 1) {
                id = Long.valueOf(dataFormatter.formatCellValue(row.getCell(1)));
                evaluation = new EvaluationFacade().find(id);
                typeEvaluation = evaluation.getTypeEvaluation();
                enseignement = typeEvaluation.getEnseignement();

            } else if (numeroLigne >= 3) {
                numeroTable = Integer.valueOf(dataFormatter.formatCellValue(row.getCell(0)));
                matricule = dataFormatter.formatCellValue(row.getCell(2));
                num_anonymat = Integer.parseInt(dataFormatter.formatCellValue(row.getCell(1)));
                if (reponse.equals("oui")) {
                    etudiant = new Isj().retrouverEtudiantMatricule(matricule);
                    estInscrit = new Isj().retrouverEstInscrit(etudiant, enseignement);

                } else if (reponse.equals("non")) {
                    candidat = new CandidatFacade().find(Long.valueOf(matricule));
                    estInscrit = new Isj().retrouverEstInscrit(candidat, enseignement);

                }
                //une fois les données recuperé on creer l'anonymat
                Anonymat anonymat = new Anonymat("", "", num_anonymat, null, evaluation, estInscrit, numeroTable);
                new AnonymatFacade().create(anonymat);


                //une fois les données recuperé on creer l'anonymat
                Note note = new Note("", "", valeurNote, numeroTable, anonymat, estInscrit, evaluation);
                anonymat.setNote(note);
                new NoteFacade().create(note);

            }
        }
        String anonymatfile =  file.getParent() +File.separator+ "Anonymat_"+file.getName();
        try {
            createExcelAnonymatNoteFile(id, cheminAcces);
        }catch (Exception e){
            resultat = e.getMessage();
        }
        workbook.close();
    }

    /**
     * fonction qui enregistre les notes anonymé a partir du fichier excel
     *
     * @param cheminAcces chemein d'acces vers le fichier
     * @throws IOException en coas d'erreur lors de l'ouverture du fichier
     */
    public void saveNoteAnonymat(String cheminAcces) throws IOException {

        File excelFile = new File(cheminAcces);
        FileInputStream fis = new FileInputStream(excelFile);
        int key = 0;
        double value = 0;
        Anonymat anonymat = null;
        Note note = null;
        //creation d'un Objet XSSFWorkbook pour la lecture d'un fichier excel
        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        DataFormatter dataFormatter = new DataFormatter();

        //Recuperation de la premiere feuille
        XSSFSheet sheet = workbook.getSheetAt(0);

        //On itere sur les ligne
        Iterator<Row> rowIt = sheet.iterator();
        int NumeroLigne = -1;

        //ArrayList listNoteAnonym = new ArrayList();
        while (rowIt.hasNext()) {

            Row row = rowIt.next();
            NumeroLigne = row.getRowNum();
            if (NumeroLigne >= 5) {
                key = Integer.parseInt(dataFormatter.formatCellValue(row.getCell(0)));
                value = Double.valueOf(dataFormatter.formatCellValue(row.getCell(1)));

                anonymat = new Isj().retrouverAnonymatNote(key);
                note = anonymat.getNote();

                note.setValeurNote(value);
                new NoteFacade().merge(note);
            }
        }
        workbook.close();
        fis.close();
    }

    /**
     * fonction qui enregistre les heures d'abscence a partie d'un fichier excel
     *
     * @param pathfile fichier de sortie
     * @throws IOException en cas d'erreur d'ouverture
     */
    public void saveAbscence(String pathfile) throws IOException {
        File excelFile = new File(pathfile);
        FileInputStream fis = new FileInputStream(excelFile);


        AnneeAcademique anneeAcademique = null;
        Date date = null;
        String matricule, semstr = "";
        int nb_heure, NumeroCell = -1;
        Semestre semestre = null;
        Etudiant etudiant;


        XSSFWorkbook workbook = new XSSFWorkbook(fis);

        DataFormatter dataFormatter = new DataFormatter();

        XSSFSheet sheet = workbook.getSheetAt(0);

        //On itere sur les ligne
        Iterator<Row> rowIt = sheet.iterator();
        int NumeroLigne = -1;

        while (rowIt.hasNext()) {

            nb_heure = 0;

            Row row = rowIt.next();
            NumeroLigne = row.getRowNum();
            if (NumeroLigne == 10) {
                semstr = dataFormatter.formatCellValue(row.getCell(1));
            } else if (NumeroLigne == 12) {
                date = row.getCell(2).getDateCellValue();
                anneeAcademique = retrouverAnneeAcademique(date);
                semestre = retrouverSemestre(semstr, anneeAcademique);
            } else if (NumeroLigne >= 15) {
                matricule = dataFormatter.formatCellValue(row.getCell(1));
                etudiant = retrouverEtudiantMatricule(matricule);
                for (int i = 5; i < 14; i++) {
                    nb_heure += Integer.valueOf(dataFormatter.formatCellValue(row.getCell(i)));
                }
                Discipline discipline = new Discipline("", "", etudiant, semestre, nb_heure, 0, date, 0);
                new DisciplineFacade().create(discipline);
            }
        }
        workbook.close();
        fis.close();
    }

    /**
     * fonction qui enregistre les abscence a partie du fichier texte généré par la badgeuse
     *
     * @param pathfile fichier d'acces vers le fichier
     * @throws IOException en cas d'erreur d'ouverture du fichier
     */
    public void enregistrerRetard(String pathfile, String lib_semestre) throws IOException, ParseException {
        BufferedReader br = new BufferedReader(new FileReader(new File("Agl nov.TXT")));
        Date date = null, dateCompar;
        int numL = -1;
        String l, mat = "", strdate = "";

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", Locale.getDefault());
        Calendar calendar = Calendar.getInstance();

        Map<String, Integer> listRetard = new HashMap<>();

        while ((l = br.readLine()) != null) {
            numL++;
            if (numL >= 1) {
                strdate = l.substring(l.lastIndexOf("\t") + 1);
                // System.out.println(date);
                date = formatter.parse(strdate);
                calendar.setTime(date);
                calendar.set(Calendar.HOUR_OF_DAY, 7);
                calendar.set(Calendar.MINUTE, 20);
                calendar.set(Calendar.SECOND, 00);
                dateCompar = calendar.getTime();

                l = l.substring(l.indexOf("\t") + 1, l.lastIndexOf("\t"));
                l = l.substring(l.indexOf("\t") + 1, l.lastIndexOf("\t"));
                mat = l.substring(l.indexOf("\t") + 1, l.lastIndexOf("\t"));

//                System.out.println(date);
//                System.out.println(dateCompar);
                mat = mat.replace("   ", "");

                if (date.before(dateCompar)) {
                    listRetard.merge(mat, 1, Integer::sum);
                }
            }
        }

        for (Map.Entry<String, Integer> rtd : listRetard.entrySet()) {
            Etudiant etudiant = retrouverEtudiantMatricule(rtd.getKey());
            AnneeAcademique anneeAcademique = retrouverAnneeAcademique(date);
            Semestre semestre = retrouverSemestre(lib_semestre, anneeAcademique);
            Discipline discipline = new Discipline("", "", etudiant, semestre, 0, rtd.getValue(), date, 0);
            new DisciplineFacade().create(discipline);
        }
    }

    /**
     * fonction qui renvoie une liste d'etudiant d'un niveau, d'une filiere et d'un semestre precis rangé par l'ordre de merite suivant
     *
     * @param annee    date de l'annee a la quelle nous voulons les rangs
     * @param classe      niveau des etudiant que l'on veut ranger
     * @param semestre libelle du semestre correspondant au rangement
     * @param filiere  libelle de la filiere requise
     * @return ArrayList de matricule rangé dans l'odre
     * @throws SQLException en cas d'erreur de coomunication avec la base de donnée
     */
    public ArrayList rangEtudiant(int annee, String classe, String semestre, String filiere) throws SQLException {
        int niv = retrouverClasse(classe).getNiveau().getNumero();
        String matricule = "", sql = "{? = CALL mgp_sem(?,?,?,?)}", sql2 = "{CALL etud_class(?,?,?)}";
        Connection con = new ClasseFacade().getConnection();

        HashMap<String, Float> listEtudMoy = new HashMap<>();

        CallableStatement procEtudClass = null;
        procEtudClass = con.prepareCall(sql2);
        procEtudClass.setString(1, classe);
        procEtudClass.setString(2, filiere);
        procEtudClass.setInt(3, annee);
        procEtudClass.execute();
        ResultSet rs = procEtudClass.getResultSet();

        while (rs.next()) {
            matricule = rs.getString(1);
            float mgp = mgpEtudaint(matricule,annee,semestre,niv,con);
            listEtudMoy.put(matricule, mgp);
        }
        //System.out.println(listEtudMoy);
        return trierListe(listEtudMoy);
    }

    public float mgpEtudaint(String matricule, int annee, String semestre, int niv, Connection con){
        float moyenne = 0;
        String sql = "{? = CALL mgp_sem(?,?,?,?)}";

        try {
            CallableStatement funcMgpSem = null;
            funcMgpSem = con.prepareCall(sql);
            funcMgpSem.registerOutParameter(1, java.sql.Types.FLOAT);
            funcMgpSem.setString(2, matricule);
            funcMgpSem.setInt(3, niv);
            funcMgpSem.setInt(4, annee);
            funcMgpSem.setString(5, semestre);
            funcMgpSem.execute();
            moyenne = funcMgpSem.getFloat(1);
        }catch (Exception e){
            e.printStackTrace();
        }
        return moyenne;
    }


   /*public ArrayList rangAnnuel(int annee, String classe, String filiere) throws SQLException{
        int niv = retrouverClasse(classe).getNiveau().getNumero();
        String matricule = "", sql = "{? = CALL mgp_sem(?,?,?,?)}", sql2 = "{CALL etud_class(?,?,?)}";
        Connection con = new ClasseFacade().getConnection();

        HashMap<String, Float> listEtudMoy = new HashMap<>();

        CallableStatement procEtudClass = null;
        procEtudClass = con.prepareCall(sql2);
        procEtudClass.setString(1, classe);
        procEtudClass.setString(2, filiere);
        procEtudClass.setInt(3, annee);
        procEtudClass.execute();
        ResultSet rs = procEtudClass.getResultSet();

        while (rs.next()) {
            float moyenne = 0;
            matricule = rs.getString(1);
            for(int i=1; i<=2; i++) {
                moyenne += mgpEtudaint(matricule,annee,"Semestre "+i,niv,con);
            }
            listEtudMoy.put(matricule, moyenne);
        }
        return trierListe(listEtudMoy);
    }*/


    public ArrayList trierListe(HashMap<String, Float> list){
        list = list.entrySet().stream().sorted(Collections.reverseOrder(Map.Entry.comparingByValue()))
                .collect(toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e2, LinkedHashMap::new));
        ArrayList listRang = new ArrayList();
        listRang.addAll(list.keySet());
        return listRang;
    }


    public Utilisateur renvoyerLoginEmail(String email) throws NoResultException {
        String sql = "SELECT u FROM Utilisateur u WHERE u.email=:email";
        UtilisateurFacade uf = new UtilisateurFacade();
        Query query = uf.getEntityManager().createQuery(sql);
        query.setParameter("email", email);
        return (Utilisateur) query.getSingleResult();
    }



    /**
     * fonction qui vérifie si un email est en BD
     *
     * @param email l'adresse email en bd
     * @return true si l'utilisateur possédant le numéro de telephone est en bd et false sinon
     */
    public Boolean isEmailInBD(String email) {
        Utilisateur utilisateur = new Utilisateur();
        try {
            utilisateur = renvoyerLoginEmail(email);
            return true;
        } catch (NoResultException n) {
            return false;
        }
    }

    /**
     * fonction qui permet d'authentifier un utilisateur
     *
     * @param login    l'identifiant de l'utilisateur
     * @param password code secret
     * @return l'utilisateur possédant ces données ou l'utilisateur null si l'utilisateur n'existe pas en base de données
     * @throws NoResultException erreur produite
     */
    public Utilisateur authentification(String login, String password) throws NoResultException {
        try {
            UtilisateurFacade utilisateurFacade = new UtilisateurFacade();
            String sql = "SELECT u FROM Utilisateur u WHERE u.login=:login AND u.motDePasse=:mot_de_passe AND u.statut=:statut";
            Query query = utilisateurFacade.getEntityManager().createQuery(sql);
            query.setParameter("login", login);
            query.setParameter("mot_de_passe", password);
            query.setParameter("statut", Personne.Statut.ACTIVE);
            return (Utilisateur) query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * fonction qui permet de récupérer les champs d'une table en BD
     *
     * @param entity entité
     * @return un objet de type ResultSetMetaData qui contient les données sur une table de la BD
     */
    public ResultSetMetaData renvoyerChamp(Class entity) {
        return renvoyerChamp(entity.getSimpleName());
    }

    public ResultSetMetaData renvoyerChamp(String table) {
        UtilisateurFacade uf = new UtilisateurFacade();
        List<String> champs = new ArrayList<>();
        String query = "SELECT * FROM " + table;
        try {
            Statement statement = uf.getConnection().createStatement();
            ResultSet resultSet = statement.executeQuery(query);
            ResultSetMetaData champ = resultSet.getMetaData();
            return champ;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /**
     * fonction qui permet de sauveagarder un email qui interfaces été envoyé
     *
     * @param email    le mail de l'utilisateur sauvegardé en bd
     * @param candidat c'est la personne sauvegardée en bd
     * @return "succes" la chaine de caractère succes
     */
    public String sauvegarderEmailSucces(Email email, Candidat candidat) {
        EnvoiMessage envoiMessage = new EnvoiMessage();
        Date dateEnvoi = new Date();
        EnvoiMessageFacade envoiMessageFacade = new EnvoiMessageFacade();
        EmailFacade emailFacade = new EmailFacade();
        envoiMessage.setLibelle("");
        envoiMessage.setDescription("");
        envoiMessage.setDateEnvoi(dateEnvoi);
        envoiMessage.setStatut(EnvoiMessage.Statut.SUCCES);
        envoiMessage.setMessage(email);
        envoiMessage.setCandidat(candidat);
        envoiMessageFacade.create(envoiMessage);
        return "succes";
    }

    /**
     * fonction qui permet de sauvegarder un email qui n'interfaces pas été envoyé
     *
     * @param email    l'email de l'utilisateur en bd
     * @param candidat le nom du candidat en bd
     * @return "echec" la chaine de caractère echec
     */
    public String sauvegarderEmailEchec(Email email, Candidat candidat) {
        EnvoiMessage envoiMessage = new EnvoiMessage();
        Date dateEnvoi = new Date();
        EnvoiMessageFacade envoiMessageFacade = new EnvoiMessageFacade();
        EmailFacade emailFacade = new EmailFacade();

        envoiMessage.setLibelle("");
        envoiMessage.setDescription("");
        envoiMessage.setDateEnvoi(dateEnvoi);
        envoiMessage.setStatut(EnvoiMessage.Statut.ECHEC);
        envoiMessage.setMessage(email);
        envoiMessage.setCandidat(candidat);

        envoiMessageFacade.create(envoiMessage);

        return "echec";
    }

    /**
     * fonction qui permet de sauvegarder un sms qui interfaces été envoyé
     *
     * @param sms      les message sauvegardés en bd
     * @param candidat c'est le nom du candidat dans la bd
     * @return la chaine de caractère succès
     */
    public String sauvegarderSmsSucces(Sms sms, Candidat candidat) {
        EnvoiMessage envoiMessage = new EnvoiMessage();
        Date dateEnvoi = new Date();
        EnvoiMessageFacade envoiMessageFacade = new EnvoiMessageFacade();
        SmsFacade smsFacade = new SmsFacade();

        envoiMessage.setLibelle("");
        envoiMessage.setDescription("");
        envoiMessage.setDateEnvoi(dateEnvoi);
        envoiMessage.setStatut(EnvoiMessage.Statut.SUCCES);
        envoiMessage.setMessage(sms);
        envoiMessage.setCandidat(candidat);

        envoiMessageFacade.create(envoiMessage);

        return "succes";
    }

    /**
     * fonction qui permet de sauvegarder un sms qui n'interfaces pas été envoyé
     *
     * @param sms      message sauvegarder en bqse de donnee
     * @param candidat le nom du candidat en bd
     * @return "echec" la chaine de caractère echec
     */
    public String sauvegarderSmsEchec(Sms sms, Candidat candidat) {
        EnvoiMessage envoiMessage = new EnvoiMessage();
        Date dateEnvoi = new Date();
        EnvoiMessageFacade envoiMessageFacade = new EnvoiMessageFacade();
        SmsFacade smsFacade = new SmsFacade();

        envoiMessage.setLibelle("");
        envoiMessage.setDescription("");
        envoiMessage.setDateEnvoi(dateEnvoi);
        envoiMessage.setStatut(EnvoiMessage.Statut.ECHEC);
        envoiMessage.setMessage(sms);
        envoiMessage.setCandidat(candidat);

        envoiMessageFacade.create(envoiMessage);

        return "echec";
    }

    /**
     * fonction qui retourne le candidat possédant l'email passé en paramètre
     *
     * @param email mail de l'utilisateur
     * @return (Candidat) query.getSingleResult() un objet candidat null s'il n'existe en bd et l'objet candidat en question sinon
     * @throws NoResultException erreur produite
     */
    public Candidat retrouverCandidatEmail(String email) throws NoResultException {
        String sql = "SELECT c FROM Candidat c WHERE c.email=:email";
        CandidatFacade cf = new CandidatFacade();
        Query query = cf.getEntityManager().createQuery(sql);
        query.setParameter("email", email);
        return (Candidat) query.getSingleResult();
    }

    public Etudiant retrouverEtudiantMatricule(String matricule) throws NoResultException {
        String sql = "SELECT e FROM Etudiant e WHERE e.matricule=:matricule";
        EtudiantFacade ef = new EtudiantFacade();
        Query query = ef.getEntityManager().createQuery(sql);
        query.setParameter("matricule", matricule);
        return (Etudiant) query.getSingleResult();
    }

    /**
     * fonction qui retourne le candidat possédant le sms passé en paramètre
     *
     * @param telephone
     * @return un objet candidat null s'il n'existe en bd et l'objet candidat sinon
     * @throws NoResultException
     */
    public Candidat retrouverCandidatSms(int telephone) throws NoResultException {
        String sql = "SELECT c FROM Candidat c WHERE c.telephone=:telephone";
        CandidatFacade cf = new CandidatFacade();
        Query query = cf.getEntityManager().createQuery(sql);
        query.setParameter("telephone", telephone);
        return (Candidat) query.getSingleResult();
    }

    public EstInscrit retrouverEstInscrit(Candidat candidatInscrit, Enseignement enseignement) throws NoResultException {
        String sql = "SELECT est FROM EstInscrit est WHERE est.candidatInscrit=:candidatInscrit AND est.enseignement=:enseignement";
        CandidatFacade cf = new CandidatFacade();
        Query query = cf.getEntityManager().createQuery(sql);
        query.setParameter("candidatInscrit", candidatInscrit);
        query.setParameter("enseignement", enseignement);
        return (EstInscrit) query.getSingleResult();
    }

    /**
     * fonction qui retourne l'anonymat possédant le numero d'anonymat passée en parametre
     *
     * @param num_anonymat objet anonymat
     * @return Entity (Anonymat)
     * @throws NoResultException si aucun resultat n'est pas retourné
     */
    public Anonymat retrouverAnonymatNote(int num_anonymat) throws NoResultException {
        String sql = "SELECT a FROM Anonymat a WHERE a.numeroAnonymat=:num_anonymat";
        AnonymatFacade af = new AnonymatFacade();
        Query query = af.getEntityManager().createQuery(sql);
        query.setParameter("num_anonymat", num_anonymat);
        return (Anonymat) query.getSingleResult();
    }

    /**
     * fonction qui retourne la note de l'evaluation passé en parametre
     *
     * @param evaluation objet de type evaluation
     * @return List
     * @throws NoResultException si aucun resultat n'est retourné
     */
    public List<Note> retrouverListeNote(Evaluation evaluation) throws NoResultException {
        String sql = "SELECT n FROM Note n WHERE n.evaluation=:evaluation";
        NoteFacade nf = new NoteFacade();
        Query query = nf.getEntityManager().createQuery(sql);
        query.setParameter("evaluation", evaluation);
        return query.getResultList();
    }

    /**
     * fonction qui retourne la liste des des est_inscrit par rapport a un enseigment specifique passé en parametre
     *
     * @param enseignement objet de type enseignant
     * @return List
     * @throws NoResultException lorsque aucun resultat n'est retourné
     */
    public List<EstInscrit> retrouverListeEstInscrit(Enseignement enseignement) throws NoResultException {
        String sql = "SELECT est FROM EstInscrit est WHERE est.enseignement=:enseignement GROUP BY est.candidatInscrit";
        EstInscritFacade ef = new EstInscritFacade();
        Query query = ef.getEntityManager().createQuery(sql);
        query.setParameter("enseignement", enseignement);
        return query.getResultList();
    }

    /**
     * fonction qui retourne la liste des Anonymat pour une evaluation presise
     *
     * @param evaluation objet evaluation
     * @return list
     * @throws NoResultException si aucune reponse
     */
    public List<Anonymat> retrouverListeAnonymat(Evaluation evaluation) throws NoResultException {
        String sql = "SELECT ano FROM Anonymat ano WHERE ano.evaluation=:evaluation";
        AnonymatFacade af = new AnonymatFacade();
        Query query = af.getEntityManager().createQuery(sql);
        query.setParameter("evaluation", evaluation);
        return query.getResultList();
    }

    public Module retrouverModule(String codeModule) {
        String sql = "SELECT mo FROM Module mo WHERE mo.codeModule=:codeModule";
        ModuleFacade mf = new ModuleFacade();
        Query query = mf.getEntityManager().createQuery(sql);
        query.setParameter("codeModule", codeModule);
        return (Module) query.getSingleResult();

    }

    public String retrouverEtudiant(long codeEtudiant) throws NoResultException {
        String sql = "SELECT e.matricule FROM Etudiant e WHERE e.code=:codeEtudiant";
        EtudiantFacade ef = new EtudiantFacade();
        Query query = ef.getEntityManager().createQuery(sql);
        query.setParameter("codeEtudiant", codeEtudiant);
        return (String) query.getSingleResult();
    }

    public Semestre retrouverSemestre(String libelle, AnneeAcademique anneeAcademique) throws NoResultException {
        String sql = "SELECT s FROM Semestre s WHERE s.libelle=:libelle AND s.anneeAcademique=:anneeAcademique";
        EtudiantFacade ef = new EtudiantFacade();
        Query query = ef.getEntityManager().createQuery(sql);
        query.setParameter("libelle", libelle);
        query.setParameter("anneeAcademique", anneeAcademique);
        return (Semestre) query.getSingleResult();
    }

    public AnneeAcademique retrouverAnneeAcademique(Date date) throws NoResultException {
        String sql = "SELECT anne_ac FROM AnneeAcademique anne_ac WHERE :date BETWEEN anne_ac.dateDebut AND anne_ac.dateCloture";
        AnneeAcademiqueFacade af = new AnneeAcademiqueFacade();
        Query query = af.getEntityManager().createQuery(sql);
        query.setParameter("date", date);
        return (AnneeAcademique) query.getSingleResult();
    }

    public long retrouverLast() throws SQLException {

        int lastInsertedId = -1;

        ResultSet getKeyRs = new EvaluationFacade().getConnection().createStatement().executeQuery("SELECT * FROM evaluation ORDER BY date_creation DESC LIMIT 1");
        if (getKeyRs != null) {
            if (getKeyRs.next()) {
                lastInsertedId = getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }
        return lastInsertedId;
    }

    public Niveau retrouverNiveau(long niveau) throws NoResultException{
        String sql = "SELECT ni FROM Niveau ni WHERE ni.numero=:niveau";
        NiveauFacade nf = new NiveauFacade();
        Query query = nf.getEntityManager().createQuery(sql);
        query.setParameter("niveau", niveau);
        return (Niveau) query.getSingleResult();

    }

    public Specialite retrouverSpecialite(String specialite) throws NoResultException {
        String sql = "SELECT sp FROM Specialite sp WHERE sp.libelle=:specialite";
        SpecialiteFacade sf = new SpecialiteFacade();
        Query query = sf.getEntityManager().createQuery(sql);
        query.setParameter("specialite", specialite);
        return (Specialite) query.getSingleResult();

    }

    public long retrouverCodeSemestre(long numSem, long anDebut) throws SQLException {
        long tmp, code = -1;

        if (numSem % 2 == 0) tmp = 2;
        else tmp = 1;

        String smt = "Semestre" + " " + tmp;
        String sql = "SELECT semestre.code FROM semestre,annee_academique WHERE semestre.annee_academique=annee_academique.code and semestre.libelle='" + smt + "' and extract(year from annee_academique.date_debut)=" + anDebut;
        ResultSet getKeyRs = new SemestreFacade().getConnection().createStatement().executeQuery(sql);
        if (getKeyRs != null) {
            if (getKeyRs.next()) {
                code = getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }
        return code;
    }

    public UE retrouverUe(String codeUe) throws NoResultException {
        String sql = "SELECT Ue FROM UE Ue WHERE Ue.codeUE=:codeUe";
        UEFacade uf = new UEFacade();
        Query query = uf.getEntityManager().createQuery(sql);
        query.setParameter("codeUe", codeUe);
        return (UE) query.getSingleResult();
    }

    public long retrouverEnseignement(String libEns,long anDebut) throws SQLException{
        long code = -1;
        String sql="SELECT enseignement.`code`\n" +
                "from enseignement,semestre,annee_academique\n" +
                "where enseignement.semestre=semestre.code\n" +
                "and annee_academique.code=semestre.annee_academique\n" +
                "and enseignement.libelle=\""+libEns+"\"\n" +
                "and EXTRACT(year from annee_academique.date_debut)="+anDebut;
        ResultSet getKeyRs= new EnseignementFacade().getConnection().createStatement().executeQuery(sql);
        if (getKeyRs!=null){
            if (getKeyRs.next()){
                code=getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }
        return code;
    }

    public Classe retrouverClasse (String libClasse) throws NoResultException{
        String sql="SELECT cl from Classe cl where cl.libelle=:libClasse";
        ClasseFacade cf = new ClasseFacade();
        Query query = cf.getEntityManager().createQuery(sql);
        query.setParameter("libClasse",libClasse);
        return (Classe) query.getSingleResult();
    }

    public long retrouverTypeEvaluation (String TypeEv,String codeUe,long an) throws SQLException{
        long code =-1;
        String sql="SELECT type_evaluation.`code`\n" +
                "FROM type_evaluation,enseignement,ue,semestre,annee_academique\n" +
                "WHERE type_evaluation.enseignement=enseignement.code\n" +
                "and enseignement.ue=ue.code\n" +
                "and enseignement.semestre=semestre.code\n" +
                "and semestre.annee_academique=annee_academique.code\n" +
                "and extract(year from annee_academique.date_debut)="+ an +
                " and type_evaluation.libelle=\""+TypeEv+"\"\n" +
                " and ue.code_ue=\""+codeUe+"\"";
       ResultSet getKeyRs= new TypeEvaluationFacade().getConnection().createStatement().executeQuery(sql);
        if (getKeyRs!=null){
            if (getKeyRs.next()){
                code=getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }

        return code;
    }

    public Evaluation retrouverEvaluation (TypeEvaluation typeEvaluation) throws NoResultException{
        String sql="SELECT eva from Evaluation eva where eva.typeEvaluation=:typeEvaluation";
        EvaluationFacade ef = new EvaluationFacade();
        Query query = ef.getEntityManager().createQuery(sql);
        query.setParameter("typeEvaluation",typeEvaluation);
        return (Evaluation) query.getSingleResult();
    }


   /* public long retrouverEvaluation (String TypeEv,String codeUe,long an) throws SQLException{
        long code =-1;
        String sql="SELECT evaluation.`code`\n" +
                "FROM evaluation\n" +
                "WHERE evaluation.type_evaluation =" +retrouverTypeEvaluation(TypeEv, codeUe, an);

        ResultSet getKeyRs= new TypeEvaluationFacade().getConnection().createStatement().executeQuery(sql);
        if (getKeyRs!=null){
            if (getKeyRs.next()){
                code=getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }

        return code;
    }*/

    public long retrouverCodeEstInscrit(String matricule,String libEns,long an)throws SQLException{
        long code =-1;
        String sql="select est_inscrit.`code`\n" +
                "FROM est_inscrit,candidat,enseignement,semestre,annee_academique,etudiant\n" +
                "where est_inscrit.candidat_inscrit=candidat.code\n" +
                "and est_inscrit.enseignement=enseignement.`code`\n" +
                "and enseignement.semestre=semestre.`code`\n" +
                "and semestre.annee_academique=annee_academique.`code`\n" +
                "and candidat.code=etudiant.code"+
                " and EXTRACT(year from annee_academique.date_debut)=" + an+
                " and enseignement.libelle=\""+libEns+"\"\n" +
                "and etudiant.matricule='"+matricule+"'";
        ResultSet getKeyRs= new EstInscritFacade().getConnection().createStatement().executeQuery(sql);
        if (getKeyRs!=null){
            if (getKeyRs.next()){
                code=getKeyRs.getInt(1);
            }
            getKeyRs.close();
        }
        return code;

    }

    public Properties writeSettingApplication(String url, String user, String password){
        Properties properties = new Properties();
        try(Writer inputStream = new FileWriter("config.properties")){

            //setting the properties
            properties.setProperty("javax.persistence.jdbc.url", "jdbc:mysql://"+url+"/isj2?zeroDateTimeBehavior=convertToNull");
            properties.setProperty("javax.persistence.jdbc.user", user);
            properties.setProperty("javax.persistence.jdbc.password", password);

            //storing the properties in the file with a heading comment
            properties.store(inputStream, "Database Information");

        }catch(IOException e){
            e.printStackTrace();
        }
        return properties;
    }

    public Properties readSettingApplication() {
        Properties properties = new Properties();
        try(InputStream inputStream = new FileInputStream("config.properties")){
            //load properties
            properties.load(inputStream);


        }catch(IOException e){
            e.printStackTrace();
        }
        return properties;
    }

    public double retournerMgp(double moyenne){
        return ((moyenne >= 18) && (moyenne <= 20)) ? 4.00 : ((moyenne >= 16) && (moyenne < 18)) ? 3.70
    : ((moyenne >= 14) && ((moyenne < 16))) ? 3.30 : ((moyenne >= 13) && (moyenne < 14)) ? 3.00
    : ((moyenne >= 12) && (moyenne < 13)) ? 2.70 : ((moyenne >= 11) && (moyenne < 12)) ? 2.30
    : ((moyenne >= 10) && (moyenne < 11)) ? 2.00 : ((moyenne >= 9) && (moyenne < 10)) ? 1.70
    : ((moyenne >= 8) && (moyenne < 9)) ? 1.30 : ((moyenne >= 6) && (moyenne < 8)) ? 1.00
    : ((moyenne >= 0) && (moyenne < 6)) ? 0.00 : null;
    }



}