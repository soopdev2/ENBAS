/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Statistiche;

import Entity.Questionario;
import Entity.Utente;
import Utils.JPAUtil;
import Utils.Utils;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class StatisticheServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final AtomicInteger sEchoCounter = new AtomicInteger(0);

    public static final String ITOTALRECORDS = "iTotalRecords";
    public static final String ITOTALDISPLAY = "iTotalDisplayRecords";
    public static final String SECHO = "sEcho";
    public static final String SCOLUMS = "sColumns";
    public static final String APPJSON = "application/json";
    public static final String CONTENTTYPE = "Content-Type";
    public static final String AADATA = "aaData";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean isSearch = Boolean.parseBoolean(request.getParameter("isSearch"));
        boolean isGeneraExcel = Boolean.parseBoolean(request.getParameter("isGeneraExcel"));
        final Logger LOGGER = LoggerFactory.getLogger(StatisticheServlet.class.getName());
        if (isSearch) {
            RicercaUtentiServlet(request, response, LOGGER);
        } else if (isGeneraExcel) {
            EstraiExcelUtenteServlet(request, response, LOGGER);
        }
    }

    public static void RicercaUtentiServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {

        try {
            int start = Utils.tryParseInt(request.getParameter("start"));
            int pageSize = Utils.tryParseInt(request.getParameter("pageSize"));
            String utenteIdParam = request.getParameter("utente_id");

            Long utenteId = null;
            if (utenteIdParam != null && !utenteIdParam.equals("Tutti")) {
                try {
                    utenteId = Utils.tryParseLong(utenteIdParam);
                } catch (NumberFormatException e) {
                    logger.warn("Parametro utente_id non valido: " + utenteIdParam);
                }
            }

            long totalRecords = countUtenti(utenteId, logger);
            List<Utente> utenti = ricercaUtenti(start, pageSize, utenteId, logger);

            JsonObject jsonResponse = new JsonObject();
            JsonArray jsonData = new JsonArray();

            jsonResponse.addProperty("iTotalRecords", totalRecords);
            jsonResponse.addProperty("iTotalDisplayRecords", totalRecords);
            jsonResponse.addProperty("sEcho", sEchoCounter.incrementAndGet());

            for (Utente utente : utenti) {
                if (utente.getRuolo().getId() == 2) {
                    JsonObject jsonUtente = new JsonObject();
                    jsonUtente.addProperty("id", utente.getId());
                    if (utente.getNome() != null) {
                        jsonUtente.addProperty("nome", utente.getNome());
                    } else {
                        jsonUtente.addProperty("nome", "non disponibile");
                    }

                    if (utente.getCognome() != null) {
                        jsonUtente.addProperty("cognome", utente.getCognome());
                    } else {
                        jsonUtente.addProperty("cognome", "non disponibile");
                    }
                    if (utente.getEtà() != 0) {
                        jsonUtente.addProperty("età", utente.getEtà());
                    } else {
                        jsonUtente.addProperty("età", "non disponibile");
                    }
                    if (utente.getIndirizzo() != null) {
                        jsonUtente.addProperty("indirizzo", utente.getIndirizzo());
                    } else {
                        jsonUtente.addProperty("indirizzo", "non disponibile");
                    }
                    if (utente.getRuolo() != null && utente.getRuolo().getNome() != null) {
                        jsonUtente.addProperty("ruolo", utente.getRuolo().getNome());
                    } else {
                        jsonUtente.addProperty("ruolo", "non disponibile");
                    }

                    jsonUtente.addProperty("azione",
                            "<form method='POST' action='StatisticheServlet?isGeneraExcel=true'>"
                            + "<button type='submit' class='btn btn-success'>Genera excel</button>"
                            + "<input type='hidden' name='utente_id' value='" + utente.getId() + "' />"
                            + "</form>"
                    );

                    jsonData.add(jsonUtente);
                }
            }

            jsonResponse.add("aaData", jsonData);

            response.setContentType("application/json");
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"))) {
                out.print(jsonResponse.toString());
            }

        } catch (Exception e) {
            logger.error("Errore nella ricerca degli utenti:\n" + Utils.estraiEccezione(e));
        }
    }

    public static List<Utente> ricercaUtenti(int start, int pageSize, Long utenteId, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        List<Utente> resultList = new ArrayList<>();

        try {
            em.getTransaction().begin();
            String jpql = "SELECT u FROM Utente u WHERE u.ruolo.id = 2";
            if (utenteId != null) {
                jpql += " AND u.id = :utenteId";
            }
            jpql += " ORDER BY u.id";

            TypedQuery<Utente> query = em.createQuery(jpql, Utente.class)
                    .setFirstResult(start)
                    .setMaxResults(pageSize);

            if (utenteId != null) {
                query.setParameter("utenteId", utenteId);
            }

            resultList = query.getResultList();
            em.getTransaction().commit();
        } catch (Exception e) {
            logger.error("Errore durante il recupero degli utenti:\n" + Utils.estraiEccezione(e));
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
        } finally {
            em.close();
        }

        return resultList;
    }

    public static long countUtenti(Long utenteId, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        long totalRecords = 0;

        try {
            String jpql = "SELECT COUNT(u) FROM Utente u WHERE u.ruolo.id = 2";
            if (utenteId != null) {
                jpql += " AND u.id = :utenteId";
            }

            TypedQuery<Long> query = em.createQuery(jpql, Long.class);

            if (utenteId != null) {
                query.setParameter("utenteId", utenteId);
            }

            totalRecords = query.getSingleResult();
        } catch (Exception e) {
            logger.error("Errore durante il conteggio degli utenti:\n" + Utils.estraiEccezione(e));
        } finally {
            em.close();
        }

        return totalRecords;
    }

    public static void EstraiExcelUtenteServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {

        try {
            String utenteIdStr = request.getParameter("utente_id");

            if (utenteIdStr == null) {
                logger.warn("ID utente non valido o mancante.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID utente non valido.");
                return;
            }

            JPAUtil jpaUtil = new JPAUtil();
            Utente utente = jpaUtil.findUserByUserId(utenteIdStr);

            if (utente == null) {
                logger.warn("Utente non trovato per ID: " + utenteIdStr);
                response.sendRedirect("AD_statistiche.jsp?esito=KO2&codice=007");
                return;
            }

            Questionario ultimoQuestionario = jpaUtil.findUltimoQuestionarioCompletatoPerUtente(utente);
            if (ultimoQuestionario == null) {
                logger.warn("Nessun questionario completato trovato per l'utente con ID: " + utente.getId());
                response.sendRedirect("AD_statistiche.jsp?esito=KO&codice=007");
                return;
            }

            if (ultimoQuestionario.getDigicomp_questionario() == null) {
                logger.warn("Nessun questionario DIGICOMP 2.2 trovato per l'utente con ID: " + utente.getId());
                response.sendRedirect("AD_statistiche.jsp?esito=KO4&codice=007");
                return;
            }

            jpaUtil.createExcel(ultimoQuestionario, response);

        } catch (IOException e) {
            logger.error("Errore durante l'estrazione dell'Excel per l'utente:\n" + Utils.estraiEccezione(e));
            response.sendRedirect("AD_statistiche.jsp?esito=KO3&codice=007");
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
