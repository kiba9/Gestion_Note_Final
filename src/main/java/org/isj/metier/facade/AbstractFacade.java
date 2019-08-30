/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isj.metier.facade;
/**
 * cette classe créer, lire, supprimer et mettre à jour un objet Abstract  dans la base de données
 *
 * @ créee par traitement metier
 */

/**
 * importation des packages et librarie
 */

import java.lang.reflect.Method;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;
import org.isj.metier.entites.Securite;
import org.isj.metier.entites.Utilisateur;

import static org.isj.gestionutilisateurs.Connexion.utilisateurCourant;

//import static org.isj.metier.Isj.utilisateurCourant;

public abstract class AbstractFacade<T> {

    public static Map<String, String> properties = null;

    public static Map<String, String> getProperties() {
        return properties;
    }

    public static void setProperties(Map<String, String> properties) {
        AbstractFacade.properties = properties;
    }

    private Class<T> entityClass;

    Method methodeSetCreateur;
    Method methodeSetModificateur;
    Method methodeSetDateCreation;
    Method methodeSetDateModification;
    Method methodeSetSignature;
    Method methodeSetStatutVie;


    public AbstractFacade(Class<T> entityClass) {

        this.entityClass = entityClass;
        try {
            methodeSetCreateur = entityClass.getMethod("setCreateur", new Class[]{Utilisateur.class});
            methodeSetCreateur.setAccessible(true);
            methodeSetDateCreation = entityClass.getMethod("setDateCreation", new Class[]{Date.class});
            methodeSetDateCreation.setAccessible(true);
            methodeSetModificateur = entityClass.getMethod("setModificateur", new Class[]{Utilisateur.class});
            methodeSetModificateur.setAccessible(true);
            methodeSetDateModification = entityClass.getMethod("setDateModification", new Class[]{Date.class});
            methodeSetDateModification.setAccessible(true);
            methodeSetSignature = entityClass.getMethod("setSignature", new Class[]{String.class});
            methodeSetSignature.setAccessible(true);
            methodeSetStatutVie = entityClass.getMethod("setStatutVie", new Class[]{Securite.StatutVie.class});
            methodeSetStatutVie.setAccessible(true);
        } catch (NoSuchMethodException | SecurityException ex) {
            Logger.getLogger(AbstractFacade.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    static EntityManager em;
    static EntityManagerFactory emf;

    public static EntityManager getEntityManager() {
        em = (em == null || !em.isOpen()) ? (emf == null ? Persistence.createEntityManagerFactory("NewPersistenceUnit", properties).createEntityManager() : emf.createEntityManager()) : em;
        return em;
    }


    public String create(T entity) {
        
        String result;
        try {
            Date dateCourante = new Date();
            methodeSetCreateur.invoke(entity, utilisateurCourant);
            methodeSetDateCreation.invoke(entity, dateCourante);
            methodeSetModificateur.invoke(entity, utilisateurCourant);
            methodeSetDateModification.invoke(entity, dateCourante);
            methodeSetSignature.invoke(entity, "");
            methodeSetStatutVie.invoke(entity, Securite.StatutVie.ACTIVE);
            
            getEntityManager().getTransaction().begin();
            getEntityManager().persist(entity);
            getEntityManager().getTransaction().commit();
            
            //Après l'enregistrement de l'entité, la fonction de mise à jour de l'entité permettra de recalculer sa signature avec la valeur de son code
            getEntityManager().merge(entity);
            merge(entity);
            
            result = "succes";
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            getEntityManager().getTransaction().rollback();
            result = "echec";
        } finally {
//            getEntityManager().close();
        }
        return result;
    }

    public String merge(T entity) {
        String result;
        try {
            
            Date dateCourante = new Date();
            methodeSetModificateur.invoke(entity, utilisateurCourant);
            methodeSetDateModification.invoke(entity, dateCourante);
            methodeSetSignature.invoke(entity, "");
            
            getEntityManager().getTransaction().begin();
            getEntityManager().merge(entity);
            getEntityManager().getTransaction().commit();
            result = "succes";
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            getEntityManager().getTransaction().rollback();
            result = "echec";
        } finally {
            getEntityManager().close();
        }
        return result;
    }
    /**
     *fonction qui permet de modifier  les objets AbstractFacade selon la requete passée en paramètre
     * @param entity
     * @return
     */
    public String remove(T entity) {
        String result;
        try {
            getEntityManager().getTransaction().begin();
            getEntityManager().remove(getEntityManager().merge(entity));
            getEntityManager().getTransaction().commit();
            result = "succes";
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", e);
            getEntityManager().getTransaction().rollback();
            result = "echec";
        } finally {
            //getEntityManager().close();
//            getEntityManager().flush();
        }
        return result;

    }

    /**
     *fonction qui permet de rechercher les objets anneeAcademique selon la requete passée en paramètre
     * @param id
     * @return
     */

    public T find(Object id) {
        T objet = getEntityManager().find(entityClass, id);
        if (objet != null) {
            getEntityManager().refresh(objet);
            getEntityManager().merge(objet);
        }
        return objet;
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @return
     */
    public List<T> findAll() {
        javax.persistence.criteria.CriteriaQuery cq = getEntityManager().getCriteriaBuilder().createQuery();
        cq.select(cq.from(entityClass));
        return getEntityManager().createQuery(cq).getResultList();
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @param query
     * @return
     */

    public List<T> findAllNative(String query) {
        return getEntityManager().createNativeQuery(query, entityClass).getResultList();
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @param request
     * @return
     */

    public List<T> findAllJPQL(String request) {
        Query query = getEntityManager().createQuery(request, entityClass);
        System.out.println("requete = " + query.toString());
        return query.getResultList();
    }
    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @param request
     * @return
     */

    public List<T> findAllJPQL(Query request) {
        System.out.println("requete = " + request.toString());
        return request.getResultList();
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     * @param range
     * @return
     */

    public List<T> findRange(int[] range) {
        javax.persistence.criteria.CriteriaQuery cq = getEntityManager().getCriteriaBuilder().createQuery();
        cq.select(cq.from(entityClass));
        javax.persistence.Query q = getEntityManager().createQuery(cq);
        q.setMaxResults(range[1] - range[0] + 1);
        q.setFirstResult(range[0]);
        return q.getResultList();
    }

    /**
     *fonction qui permet de lister les objets anneeAcademique selon la requete passée en paramètre
     *
     * @return
     */
    public int count() {
        javax.persistence.criteria.CriteriaQuery cq = getEntityManager().getCriteriaBuilder().createQuery();
        javax.persistence.criteria.Root<T> rt = cq.from(entityClass);
        cq.select(getEntityManager().getCriteriaBuilder().count(rt));
        javax.persistence.Query q = getEntityManager().createQuery(cq);
        return ((Long) q.getSingleResult()).intValue();
    }

    /**
     *fonction qui permet se connecter interfaces la base de donée
     * @param requete
     * @return
     */

    static java.sql.Connection con;

    public static java.sql.Connection getConnection() throws SQLException {

        if (con == null || con.isClosed()) {
            try {
                getEntityManager().getTransaction().begin();
                con = getEntityManager().unwrap(java.sql.Connection.class);
                System.out.println(con.toString());
                getEntityManager().getTransaction().commit();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return con;
    }

    public static String getMatricule(long codeEtudiant){

        String requete="select matricule from etudiant where code="+codeEtudiant;
        try {
            Statement st = getConnection().createStatement();
            ResultSet rs=st.executeQuery(requete);
            while(rs.next())
                return rs.getString("matricule");
        }catch(Exception e){
            e.printStackTrace();
        }
        return "";
    }

    public static String getCodeAuthentification(long codeEtudiant){

        String requete="select code_authentification from etudiant where code="+codeEtudiant;
        try {
            Statement st = getConnection().createStatement();
            ResultSet rs=st.executeQuery(requete);
            while(rs.next())
                return rs.getString("code_authentification");
        }catch(Exception e){
            e.printStackTrace();
        }
        return "";
    }

}
