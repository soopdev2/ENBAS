/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Statistiche;

import Entity.Digicomp;
import Entity.InfoTrack;
import Entity.Questionario;
import Entity.Utente;
import Utils.JPAUtil;
import Utils.Utils;
import static Utils.Utils.estraiEccezione;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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
import jakarta.servlet.http.HttpSession;
import java.io.OutputStreamWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
    public static JPAUtil jpaUtil;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean isSearch = Boolean.parseBoolean(request.getParameter("isSearch"));
        boolean isGeneraExcel = Boolean.parseBoolean(request.getParameter("isGeneraExcel"));
        boolean isControllaDigicomp = Boolean.parseBoolean(request.getParameter("isControllaDigicomp"));
        final Logger LOGGER = LoggerFactory.getLogger(StatisticheServlet.class.getName());
        HttpSession session = request.getSession();
        String userId = Utils.checkAttribute(session, "userId");
        if (isSearch) {
            RicercaUtentiServlet(request, response, LOGGER);
        } else if (isGeneraExcel) {
            EstraiExcelUtenteServlet(request, response, LOGGER, userId);
        } else if (isControllaDigicomp) {
            ControllaDigicompServlet(request, response, LOGGER, userId);
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
                    Questionario ultimoQuestionario = jpaUtil.findUltimoQuestionarioCompletatoPerUtente(utente);

                    if (ultimoQuestionario != null) {
                        jsonUtente.addProperty("azione",
                                "<form method='POST' action='StatisticheServlet?isGeneraExcel=true'>"
                                + "<button type='submit' class='btn btn-success'>Genera excel</button>"
                                + "<input type='hidden' name='utente_id' value='" + utente.getId() + "' />"
                                + "</form>"
                        );
                    } else {
                        jsonUtente.addProperty("azione", "non disponibile");
                    }

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
        EntityManager em = jpaUtil.getEm();
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
        EntityManager em = jpaUtil.getEm();
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

    public static void EstraiExcelUtenteServlet(HttpServletRequest request, HttpServletResponse response, Logger logger, String userId)
            throws ServletException, IOException {
        Utente utente = new Utente();

        try {
            String utenteIdStr = request.getParameter("utente_id");

            if (utenteIdStr == null) {
                logger.warn("ID utente non valido o mancante.");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID utente non valido.");
                return;
            }

            utente = jpaUtil.findUserByUserId(utenteIdStr);

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

            Utente utente_sessione = jpaUtil.findUserByUserId(userId);

            jpaUtil.createExcel(ultimoQuestionario, response);
            InfoTrack infoTrack = new InfoTrack("READ",
                    "StatisticheServlet - Servlet - EstraiExcelUtenteServlet",
                    200,
                    "Excel dell'utenza con id " + utente_sessione.getId() + " generato.",
                    "Servlet chiamata dall'utente con id " + utente_sessione.getId() + ".",
                    null,
                    Utils.formatLocalDateTime(LocalDateTime.now()));

            jpaUtil.SalvaInfoTrack(infoTrack, logger);

        } catch (IOException e) {
            logger.error("Errore durante l'estrazione dell'Excel per l'utente:\n" + Utils.estraiEccezione(e));
            InfoTrack infoTrack = new InfoTrack("READ",
                    "StatisticheServlet - Servlet - EstraiExcelUtenteServlet",
                    500,
                    "Errore - Excel dell'utenza con id " + utente.getId() + " non generato.",
                    "Servlet chiamata dall'utente con id " + userId + ".",
                    Utils.estraiEccezione(e),
                    Utils.formatLocalDateTime(LocalDateTime.now()));
            jpaUtil.SalvaInfoTrack(infoTrack, logger);

            response.sendRedirect("AD_statistiche.jsp?esito=KO3&codice=007");
        }
    }

    public static void ControllaDigicompServlet(HttpServletRequest request, HttpServletResponse response, Logger logger, String userId)
            throws ServletException, IOException {

        try {
            List<Utente> utenti = jpaUtil.findAllUtenti();
            ObjectMapper objectMapper = new ObjectMapper();

            for (Utente utente : utenti) {
                Questionario ultimoQuestionario = jpaUtil.findUltimoQuestionarioCompletatoPerUtente(utente);

                if (ultimoQuestionario == null) {
                    logger.info("Nessun questionario completato trovato per l'utente " + utente.getId());
                    continue;
                }

                if (ultimoQuestionario.getDigicomp_questionario() == null || ultimoQuestionario.getDigicomp_questionario().isEmpty()) {
                    logger.info("Il questionario con ID " + ultimoQuestionario.getId() + " non ha un Digicomp associato per l'utente " + utente.getId());
                    continue;
                }

                Digicomp digicompAttuale = ultimoQuestionario.getDigicomp_questionario().get(0);
                int livelloCorrente = Utils.tryParseInt(digicompAttuale.getId().toString());

                if (livelloCorrente >= 5) {
                    logger.info("L'utente con ID " + utente.getId() + " ha già completato il livello massimo.");
                    //jpaUtil.createExcel(ultimoQuestionario);
                    continue;
                }

                String jsonRisposte = ultimoQuestionario.getRisposte();
                if (jsonRisposte == null || jsonRisposte.isEmpty()) {
                    logger.info("Nessuna risposta trovata per l'utente " + utente.getId() + ".");
                    continue;
                }

                JsonNode rootNode = objectMapper.readTree(jsonRisposte);
                JsonNode risposteNode = rootNode.path("risposte");

                if (risposteNode.isMissingNode()) {
                    logger.info("Formato JSON non valido per l'utente " + utente.getId() + ".");
                    continue;
                }

                Map<Long, Integer> risposteCorrettePerCategoria = new HashMap<>();
                List<String> domandeSbagliate = new ArrayList<>();
                int risposteCorretteTotali = 0;

                for (Iterator<Map.Entry<String, JsonNode>> it = risposteNode.fields(); it.hasNext();) {
                    Map.Entry<String, JsonNode> entry = it.next();
                    JsonNode rispostaUtente = entry.getValue();
                    Long domandaId = Utils.tryParseLong(entry.getKey());

                    //DOMANDE MANUALI
                    if (rispostaUtente.has("risposta") && rispostaUtente.has("risposta corretta")) {
                        String rispostaData = rispostaUtente.path("risposta").asText();
                        String rispostaCorretta = rispostaUtente.path("risposta corretta").asText();

                        if (rispostaData.equalsIgnoreCase(rispostaCorretta)) {
                            Long categoriaId = jpaUtil.getCategoriaIdByDomandaId(domandaId);
                            risposteCorrettePerCategoria.put(categoriaId, risposteCorrettePerCategoria.getOrDefault(categoriaId, 0) + 1);
                            risposteCorretteTotali++;
                        } else {
                            domandeSbagliate.add("Domanda ID: " + domandaId + " - Risposta sbagliata.");
                        }
                    } //DOMANDE AUTOMATICHE
                    else if (rispostaUtente.has("risposta_id") && rispostaUtente.has("risposte_corrette")) {
                        Set<String> risposteDate = new HashSet<>();
                        for (JsonNode id : rispostaUtente.withArray("risposta_id")) {
                            risposteDate.add(id.asText());
                        }

                        Set<String> risposteCorrette = new HashSet<>();
                        for (JsonNode id : rispostaUtente.withArray("risposte_corrette")) {
                            risposteCorrette.add(id.asText());
                        }

                        if (risposteDate.equals(risposteCorrette)) {
                            Long categoriaId = jpaUtil.getCategoriaIdByDomandaId(domandaId);
                            risposteCorrettePerCategoria.put(categoriaId, risposteCorrettePerCategoria.getOrDefault(categoriaId, 0) + 1);
                            risposteCorretteTotali++;
                        } else {
                            domandeSbagliate.add("Domanda ID: " + domandaId + " - Risposte multiple sbagliate.");
                        }
                    } else {
                        domandeSbagliate.add("Domanda ID: " + domandaId + " - Formato risposta non riconosciuto.");
                    }
                }

                logger.info("Totale risposte corrette per l'utente " + utente.getId() + ": " + risposteCorretteTotali + " su " + risposteNode.size() + " risposte.");
                logger.info("Risposte corrette per categoria per l'utente " + utente.getId() + ": " + risposteCorrettePerCategoria);
                if (!domandeSbagliate.isEmpty()) {
                    logger.info("Domande sbagliate per l'utente " + utente.getId() + ": " + domandeSbagliate);
                }

                Map<Integer, Integer> sogliaMinima = Map.of(
                        1, 2,
                        2, 4,
                        3, 3,
                        4, 3,
                        5, 3
                );

                boolean avanzare = true;
                for (Map.Entry<Integer, Integer> entry : sogliaMinima.entrySet()) {
                    int categoriaId = entry.getKey();
                    int minimoRichiesto = entry.getValue();
                    int corrette = risposteCorrettePerCategoria.getOrDefault((long) categoriaId, 0);

                    if (corrette < minimoRichiesto) {
                        avanzare = false;
                        domandeSbagliate.add("Categoria ID: " + categoriaId + " - Numero di risposte corrette insufficienti.");
                        break;
                    }
                }

                if (avanzare) {
                    jpaUtil.assegnaNuovoQuestionario(ultimoQuestionario, livelloCorrente);

                    Utente utente_sessione = jpaUtil.findUserByUserId(userId);

                    InfoTrack infoTrack = new InfoTrack("READ,CREATE",
                            "StatisticheServlet - Servlet - ControllaDigicompServlet",
                            200,
                            "Controllo effettuato con successo.",
                            "Servlet chiamata dall'utente con id " + utente_sessione.getId() + ".",
                            null,
                            Utils.formatLocalDateTime(LocalDateTime.now()));

                    jpaUtil.SalvaInfoTrack(infoTrack, logger);
                    response.sendRedirect("AD_statistiche.jsp?esito=OK&codice=007");
                } else {
                    logger.info("Il questionario con ID " + ultimoQuestionario.getId() + " per l'utente " + utente.getId() + " non ha superato il livello " + livelloCorrente);
                    //jpaUtil.createExcel(ultimoQuestionario); // puoi sbloccarlo se vuoi generare Excel anche in caso di fallimento
                    for (String errore : domandeSbagliate) {
                        logger.info(errore);
                    }
                }
            }
        } catch (JsonProcessingException e) {
            logger.error("Non è stato possibile effettuare il controllo sui questionari di tipo Digicomp" + "\n" + estraiEccezione(e));
            InfoTrack infoTrack = new InfoTrack("READ,CREATE",
                    "StatisticheServlet - Servlet - ControllaDigicompServlet",
                    500,
                    "Errore - Controllo non effettuato con successo.",
                    "Servlet chiamata dall'utente con id " + userId + ".",
                    Utils.estraiEccezione(e),
                    Utils.formatLocalDateTime(LocalDateTime.now()));
            jpaUtil.SalvaInfoTrack(infoTrack, logger);
            response.sendRedirect("AD_statistiche.jsp?esito=KO5&codice=007");
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
