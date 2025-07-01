/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Questionario;

import Entity.AreeCompetenze;
import Entity.Categoria;
import Entity.Digicomp;
import Entity.Domanda;
import Entity.ModelloPredefinito;
import Entity.Questionario;
import Entity.Utente;
import Enum.Stato_questionario;
import Enum.Tipo_inserimento;
import Enum.Visibilità_domanda;
import Utils.JPAUtil;
import Utils.Utils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class QuestionarioServlet extends HttpServlet {

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
    public static final SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isContinueLater = Boolean.parseBoolean(request.getParameter("isContinueLater"));
        boolean isIniziaQuestionario = Boolean.parseBoolean(request.getParameter("iniziaQuestionario"));
        boolean isSet = Boolean.parseBoolean(request.getParameter("isSet"));
        boolean isSearch = Boolean.parseBoolean(request.getParameter("isSearch"));
        boolean isUser = Boolean.parseBoolean(request.getParameter("isUser"));
        final Logger LOGGER = LoggerFactory.getLogger(QuestionarioServlet.class.getName());

        if (isContinueLater) {
            SalvaProgressi(request, response, LOGGER);
        } else if (isIniziaQuestionario) {
            SalvaStatoQuestionarioPresoInCarico(request, LOGGER);
        } else if (isSet) {
            AssegnaQuestionario(request, response, LOGGER);
        } else if (isSearch && isUser) {
            RicercaArchiviUtentiServlet(request, response, LOGGER);
        } else if (isSearch) {
            RicercaArchiviServlet(request, response, LOGGER);
        } else {
            SalvaQuestionario(request, response, LOGGER);
        }

    }

    private void AssegnaQuestionario(HttpServletRequest request, HttpServletResponse response, Logger logger) throws IOException {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();

        try {
            em.getTransaction().begin();

            String[] assegna_questionario_select_utente = request.getParameterValues("assegna_questionario_select_utente");
            String assegna_questionario_select_questionario = request.getParameter("assegna_questionario_select_questionario");
            String assegna_questionario_select_categoria = request.getParameter("assegna_questionario_select_categoria");
            String assegna_questionario_select_digicomp = request.getParameter("assegna_questionario_select_digicomp");
            String numero_domande = request.getParameter("numero_domande");

            if (assegna_questionario_select_categoria != null && numero_domande != null && assegna_questionario_select_utente != null) {
                assegnaQuestionarioCategoria(assegna_questionario_select_categoria, numero_domande, assegna_questionario_select_utente, response, logger);
            } else if (assegna_questionario_select_digicomp != null) {
                assegnaQuestionarioDigicomp(assegna_questionario_select_digicomp, assegna_questionario_select_utente, response, logger);
            } else {
                if (assegna_questionario_select_utente != null && assegna_questionario_select_questionario != null) {
                    Long questionarioId = Utils.tryParseLong(assegna_questionario_select_questionario);
                    ModelloPredefinito modelloPredefinito = em.find(ModelloPredefinito.class, questionarioId);

                    if (modelloPredefinito != null) {
                        for (String userIdStr : assegna_questionario_select_utente) {
                            try {
                                Long userId = Utils.tryParseLong(userIdStr);
                                Utente utente = em.find(Utente.class, userId);

                                if (utente != null) {
                                    Questionario questionario = jPAUtil.findUtenteQuestionarioIdByUserId(userId);
                                    if (questionario != null && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)
                                            && questionario.getStatus() == 3 || questionario == null) {

                                        Questionario utenteQuestionario = new Questionario();
                                        utenteQuestionario.setUtenti(List.of(utente));
                                        utenteQuestionario.setModelliPredefiniti(List.of(modelloPredefinito));
                                        utenteQuestionario.setStatus(0);
                                        utenteQuestionario.setDescrizione(Stato_questionario.ASSEGNATO);

                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                        Date date = new Date();
                                        String formattedDate = sdf.format(date);
                                        utenteQuestionario.setDataDiAssegnazione(formattedDate);

                                        em.persist(utenteQuestionario);
                                        logger.info("Questionario assegnato con successo all'utente con id " + userId + " in data " + sdf.format(new Date()));
                                    } else {
                                        if (!response.isCommitted()) {
                                            response.sendRedirect("AD_assegna_questionario.jsp?esito=KO3&codice=004");
                                            return;
                                        }
                                    }
                                } else {
                                    if (!response.isCommitted()) {
                                        response.sendRedirect("AD_assegna_questionario.jsp?esito=KO4&codice=004");
                                        return;
                                    }
                                }
                            } catch (IOException e) {
                                logger.error("Non è stato possibile assegnare un nuovo questionario" + "\n" + Utils.estraiEccezione(e));
                            }
                        }

                        em.getTransaction().commit();
                        if (!response.isCommitted()) {
                            response.sendRedirect("AD_assegna_questionario.jsp?esito=OK&codice=004");
                        }
                    } else {
                        if (!response.isCommitted()) {
                            response.sendRedirect("AD_assegna_questionario.jsp?esito=KO&codice=004");
                        }
                    }
                }
            }
        } catch (IOException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Non è stato possibile assegnare un nuovo questionario" + "\n" + Utils.estraiEccezione(e));
            if (!response.isCommitted()) {
                response.sendRedirect("AD_assegna_questionario.jsp?esito=KO2&codice=004");
            }
        } finally {
            if (em != null) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                em.close();
            }
        }
    }

    private void assegnaQuestionarioCategoria(String categoriaSelect, String numeroDomande, String[] assegna_questionario_select_utente, HttpServletResponse response, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();

        try {
            em.getTransaction().begin();

            Long categoria_id = Utils.tryParseLong(categoriaSelect);
            Categoria categoria = em.find(Categoria.class, categoria_id);

            TypedQuery<Domanda> query = em.createQuery("SELECT d FROM Domanda d WHERE d.categoria.id = :categoriaId AND d.visibilità_domanda = :visibilità", Domanda.class)
                    .setParameter("categoriaId", categoria.getId())
                    .setParameter("visibilità", Visibilità_domanda.VISIBILE);

            List<Domanda> domande = query.getResultList();

            Collections.shuffle(domande);

            int numero = Utils.tryParseInt(numeroDomande);
            List<Domanda> domandeSelezionate = domande.subList(0, Math.min(numero, domande.size()));

            for (String userIdStr : assegna_questionario_select_utente) {
                Long userId = Utils.tryParseLong(userIdStr);
                Utente utente = em.find(Utente.class, userId);

                if (utente != null) {
                    Questionario ultimo_questionario = jPAUtil.findUtenteQuestionarioIdByUserId(userId);
                    if (ultimo_questionario != null && ultimo_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)
                            && ultimo_questionario.getStatus() == 3 || ultimo_questionario == null) {

                        Questionario questionario = new Questionario();
                        questionario.setUtenti(List.of(utente));

                        questionario.setCategoria(List.of(categoria));
                        questionario.setStatus(0);
                        questionario.setDescrizione(Stato_questionario.ASSEGNATO);

                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                        Date date = new Date();
                        String formattedDate = sdf.format(date);
                        questionario.setDataDiAssegnazione(formattedDate);
                        questionario.setDomande(domandeSelezionate);

                        em.persist(questionario);
                    } else {
                        if (!response.isCommitted()) {
                            response.sendRedirect("AD_assegna_questionario.jsp?esito=KO3&codice=004");
                            return;
                        }
                    }
                } else {
                    if (!response.isCommitted()) {
                        response.sendRedirect("AD_assegna_questionario.jsp?esito=KO4&codice=004");
                        return;
                    }
                }
            }

            em.getTransaction().commit();
            if (!response.isCommitted()) {
                response.sendRedirect("AD_assegna_questionario.jsp?esito=OK&codice=004");
            }

        } catch (IOException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Non è stato possibile assegnare un nuovo questionario di tipo Categoria" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                em.close();
            }
        }
    }

    private void assegnaQuestionarioDigicomp(String digicompSelect, String[] assegna_questionario_select_utente, HttpServletResponse response, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();

        try {
            em.getTransaction().begin();

            Long digicomp_id = Utils.tryParseLong(digicompSelect);
            Digicomp digicomp = em.find(Digicomp.class, digicomp_id);

            TypedQuery<Domanda> query = em.createQuery(
                    "SELECT d FROM Domanda d WHERE d.visibilità_domanda = :visibilità AND d.competenza.livello = :livello", Domanda.class)
                    .setParameter("visibilità", Visibilità_domanda.VISIBILE)
                    .setParameter("livello", "1");

            List<Domanda> domande = query.getResultList();

            Map<Long, Map<Long, List<Domanda>>> domandePerCategoriaEArea = new HashMap<>();
            for (Domanda domanda : domande) {
                if (domanda.getCategoria() != null && domanda.getCompetenza() != null) {
                    Long categoriaId = domanda.getCategoria().getId();

                    AreeCompetenze area = domanda.getCompetenza().getAreeCompetenze();
                    Long areaId = area.getId();

                    domandePerCategoriaEArea
                            .computeIfAbsent(categoriaId, k -> new HashMap<>())
                            .computeIfAbsent(areaId, k -> new ArrayList<>())
                            .add(domanda);
                }
            }

            Map<Long, Integer> distribuzione = Map.of(
                    1L, 3,
                    2L, 6,
                    3L, 4,
                    4L, 4,
                    5L, 4
            );

            List<Domanda> domandeSelezionate = new ArrayList<>();

            for (Map.Entry<Long, Map<Long, List<Domanda>>> categoriaEntry : domandePerCategoriaEArea.entrySet()) {
                Long categoriaId = categoriaEntry.getKey();
                Map<Long, List<Domanda>> domandePerArea = categoriaEntry.getValue();

                if (distribuzione.containsKey(categoriaId)) {
                    for (Map.Entry<Long, List<Domanda>> areaEntry : domandePerArea.entrySet()) {
                        List<Domanda> domandeArea = areaEntry.getValue();

                        if (!domandeArea.isEmpty()) {
                            Collections.shuffle(domandeArea);
                            domandeSelezionate.add(domandeArea.get(0));
                        }
                    }
                }
            }

            for (String userIdStr : assegna_questionario_select_utente) {
                Long userId = Utils.tryParseLong(userIdStr);
                Utente utente = em.find(Utente.class, userId);

                if (utente != null) {
                    Questionario ultimo_questionario = jPAUtil.findUtenteQuestionarioIdByUserId(userId);
                    if (ultimo_questionario != null && ultimo_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)
                            && ultimo_questionario.getStatus() == 3 || ultimo_questionario == null) {

                        Questionario questionario = new Questionario();
                        questionario.setUtenti(List.of(utente));
                        questionario.setDigicomp_questionario(List.of(digicomp));
                        questionario.setStatus(0);
                        questionario.setDescrizione(Stato_questionario.ASSEGNATO);

                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                        Date date = new Date();
                        String formattedDate = sdf.format(date);
                        questionario.setDataDiAssegnazione(formattedDate);
                        questionario.setDomande(domandeSelezionate);

                        em.persist(questionario);
                    } else {
                        if (!response.isCommitted()) {
                            response.sendRedirect("AD_assegna_questionario.jsp?esito=KO3&codice=004");
                            return;
                        }
                    }
                } else {
                    if (!response.isCommitted()) {
                        response.sendRedirect("AD_assegna_questionario.jsp?esito=KO4&codice=004");
                        return;
                    }
                }
            }

            em.getTransaction().commit();
            if (!response.isCommitted()) {
                response.sendRedirect("AD_assegna_questionario.jsp?esito=OK&codice=004");
            }

        } catch (IOException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Non è stato possibile assegnare un nuovo questionario di tipo Digicomp" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                em.close();
            }
        }
    }

    private void SalvaStatoQuestionarioPresoInCarico(HttpServletRequest request, Logger logger) throws IOException {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();

        try {
            em.getTransaction().begin();

            HttpSession session = request.getSession();
            String userIdParam = Utils.checkAttribute(session, "userId");
            Long userId = Utils.tryParseLong(userIdParam);
            Questionario questionario = jPAUtil.findUtenteQuestionarioIdByUserId(userId);

            if (questionario.getStatus() == 0 && questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {
                questionario.setStatus(1);
                questionario.setDescrizione(Stato_questionario.PRESO_IN_CARICO);
                em.merge(questionario);
                em.getTransaction().commit();
                logger.info("Questionario con id " + questionario.getId() + "  è stato preso in carico con successo dall'utente con id " + userId + " in data " + sdf.format(new Date()));
            }
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Non è stato possibile cambiare lo stato (PRESO_IN CARICO)" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void SalvaProgressi(HttpServletRequest request, HttpServletResponse response, Logger logger) throws IOException {
        StringBuilder jsonInput = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonInput.append(line);
            }
        }

        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> formData = objectMapper.readValue(jsonInput.toString(), Map.class);
        
        String userIdParam = (String) formData.get("userId");
        Long userId = Utils.tryParseLong(userIdParam);

        if (userId != null) {
            Map<String, Object> progressData = new HashMap<>();
            progressData.put("userId", userId);

            formData.forEach((key, value) -> {
                if (!key.equals("userId")) {
                    if (value instanceof List) {
                        progressData.put(key, value);
                    } else {
                        progressData.put(key, value);
                    }
                }
            });

            progressData.put("data_salvataggio", new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));

            String progressJson = objectMapper.writeValueAsString(progressData);

            JPAUtil jPAUtil = new JPAUtil();
            EntityManager em = jPAUtil.getEm();

            try {
                em.getTransaction().begin();

                Utente utente = em.find(Utente.class, userId);
                if (utente != null) {
                    Questionario questionario = jPAUtil.findUtenteQuestionarioIdByUserId(utente.getId());
                    questionario.setProgressi(progressJson);
                    jPAUtil.salvaStatoQuestionario(questionario);
                    em.merge(questionario);
                }

                em.getTransaction().commit();
                logger.info("Progressi questionario salvati con successo dall'utente con id " + userId + " in data " + sdf.format(new Date()));
                response.setStatus(HttpServletResponse.SC_OK);
                response.sendRedirect("US_questionario.jsp?esito=OK&codice=002");
            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                logger.error("Non è stato possibile effettuare il merge dell'utente con id " + userId + "\n" + Utils.estraiEccezione(e));
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.sendRedirect("US_questionario.jsp?esito=KO&codice=002");
            } finally {
                if (em != null && em.isOpen()) {
                    em.close();
                }
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.sendRedirect("US_questionario.jsp?esito=KO&codice=002");
        }
    }

    public static void SalvaQuestionario(HttpServletRequest request, HttpServletResponse response, Logger logger) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdParam = Utils.checkAttribute(session, "userId");
        String questionarioIdParam = Utils.checkAttribute(session, "questionarioId");

        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        Utente utente = jPAUtil.findUserByUserId(userIdParam);

        try {
            em.getTransaction().begin();

            logger.info("Inizio salvataggio questionario - userId: " + userIdParam + ", questionarioId: " + questionarioIdParam);

            Questionario questionario = jPAUtil.findUtenteQuestionarioIdByUserId(utente.getId());

            String nome = utente.getNome();
            String cognome = utente.getCognome();
            int eta = utente.getEtà();
            String indirizzo = utente.getIndirizzo();

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            String formattedDate = sdf.format(new Date());

            Map<String, Object> informazioniGenerali = new HashMap<>();
            informazioniGenerali.put("nome", nome);
            informazioniGenerali.put("cognome", cognome);
            informazioniGenerali.put("età", eta);
            informazioniGenerali.put("indirizzo", indirizzo);
            informazioniGenerali.put("data_completamento", formattedDate);
            informazioniGenerali.put("data_assegnazione", questionario.getDataDiAssegnazione());

            List<Domanda> domande = questionario.getDomande();
            logger.info("Numero domande caricate: " + domande.size());

            Map<String, Object> risposteCompletate = new HashMap<>();

            StringBuilder jsonBuilder = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }

            String jsonData = jsonBuilder.toString();

            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> surveyMap = objectMapper.readValue(jsonData, new TypeReference<Map<String, Object>>() {
            });

            for (Domanda domanda : domande) {
                String parametroRisposta = "risposta_" + domanda.getId();
                Map<String, Object> rispostaDetails = new LinkedHashMap<>();
                rispostaDetails.put("domanda", domanda.getTitolo());

                logger.info("Elaboro domanda ID: " + domanda.getId() + " - Tipo inserimento: " + domanda.getTipo_inserimento());

                if (domanda.getTipo_inserimento() == Tipo_inserimento.AUTOMATICO) {
                    try {
                        ObjectNode jsonDomanda = (ObjectNode) objectMapper.readTree(domanda.getRisposte());
                        String tipoDomanda = jsonDomanda.get("tipo_domanda").asText();

                        ArrayNode risposteCorretteArray = (ArrayNode) jsonDomanda.get("risposte_corrette");
                        ArrayNode risposteArray = (ArrayNode) jsonDomanda.get("risposte");

                        List<String> risposteCorrette = new ArrayList<>();
                        risposteCorretteArray.forEach(rc -> risposteCorrette.add(rc.asText()));

                        if (tipoDomanda.equalsIgnoreCase("domanda_scelta_multipla")) {
                            Object rispostaObj = surveyMap.get(parametroRisposta);
                            List<String> risposteUtente = new ArrayList<>();

                            if (rispostaObj instanceof List<?>) {
                                for (Object item : (List<?>) rispostaObj) {
                                    risposteUtente.add(item.toString());
                                }
                            } else if (rispostaObj instanceof String) {
                                risposteUtente.add((String) rispostaObj);
                            }

                            Map<String, String> testoToIdMap = new HashMap<>();
                            Map<String, String> idToTestoMap = new HashMap<>();
                            for (JsonNode r : risposteArray) {
                                String id = r.get("id").asText();
                                String testo = r.get("testo").asText().replaceAll("<[^>]*>", "").trim();
                                testoToIdMap.put(testo, id);
                                idToTestoMap.put(id, testo);
                            }

                            List<String> idRisposteUtente = new ArrayList<>();
                            for (String testoRisposta : risposteUtente) {
                                String testoPulito = testoRisposta.replaceAll("<[^>]*>", "").trim();
                                String idRisposta = testoToIdMap.get(testoPulito);
                                if (idRisposta != null) {
                                    idRisposteUtente.add(idRisposta);
                                }
                            }

                            List<String> testiRisposteCorrette = new ArrayList<>();
                            for (String idCorretto : risposteCorrette) {
                                String testo = idToTestoMap.get(idCorretto);
                                if (testo != null) {
                                    testiRisposteCorrette.add(testo);
                                }
                            }

                            rispostaDetails.put("risposta_testuale", risposteUtente);
                            rispostaDetails.put("risposta_id", idRisposteUtente);
                            rispostaDetails.put("risposte_corrette", risposteCorrette);
                            rispostaDetails.put("testi_risposte_corrette", testiRisposteCorrette);

                            risposteCompletate.put(domanda.getId().toString(), rispostaDetails);
                        }

                    } catch (JsonProcessingException e) {
                        logger.error("Errore parsing json DOMANDA_AUTOMATICA id " + domanda.getId(), e);
                    }

                } else {
                    String tipo = domanda.getTipo_domanda().toString();
                    switch (tipo) {
                        case "DOMANDA_APERTA":
                            String rispostaAperta = (String) surveyMap.get(parametroRisposta);
                            if (rispostaAperta != null && !rispostaAperta.isEmpty()) {
                                rispostaDetails.put("risposta", rispostaAperta);
                                risposteCompletate.put(domanda.getId().toString(), rispostaDetails);
                            }
                            break;
                        case "DOMANDA_SCELTA_MULTIPLA":
                            String rispostaMultipla = (String) surveyMap.get(parametroRisposta);
                            if (rispostaMultipla != null && !rispostaMultipla.isEmpty()) {
                                rispostaDetails.put("risposta", rispostaMultipla);
                                String opzioni = domanda.getOpzioni();
                                String[] opzioniArray = opzioni.split(",");
                                rispostaDetails.put("risposta corretta", opzioniArray[0]);
                                risposteCompletate.put(domanda.getId().toString(), rispostaDetails);
                            }
                            break;
                        case "DOMANDA_SCALA_VALUTAZIONE":
                            Integer scalaRisposta = (Integer) surveyMap.get(parametroRisposta);
                            if (scalaRisposta != null) {
                                rispostaDetails.put("risposta", scalaRisposta.toString());
                                risposteCompletate.put(domanda.getId().toString(), rispostaDetails);
                            }
                            break;
                        case "DOMANDA_SELECT":
                            String rispostaSelect = (String) surveyMap.get(parametroRisposta);
                            if (rispostaSelect != null && !rispostaSelect.isEmpty()) {
                                rispostaDetails.put("risposta", rispostaSelect);
                                risposteCompletate.put(domanda.getId().toString(), rispostaDetails);
                            }
                            break;
                        default:
                            break;
                    }
                }
            }

            String jsonRisposte = objectMapper.writeValueAsString(risposteCompletate);
            Map<String, Object> risposteFinali = new HashMap<>(informazioniGenerali);
            risposteFinali.put("risposte", objectMapper.readTree(jsonRisposte));

            questionario.setRisposte(objectMapper.writeValueAsString(risposteFinali));
            salvaStatoQuestionarioCompletato(questionario, logger);

            em.merge(questionario);
            em.getTransaction().commit();

        } catch (IOException | NumberFormatException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Errore nel salvataggio del questionario ID: " + questionarioIdParam + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public static Questionario salvaStatoQuestionarioCompletato(Questionario questionario, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();

        try {
            em.getTransaction().begin();

            if ((questionario.getStatus() == 1 && questionario.getDescrizione().equals(Stato_questionario.PRESO_IN_CARICO))
                    || (questionario.getStatus() == 2 && questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE))) {

                questionario.setStatus(3);
                questionario.setDescrizione(Stato_questionario.COMPLETATO);
                questionario.setDataCompletamento(LocalDateTime.now());

                em.merge(questionario);
                em.getTransaction().commit();
            }
            logger.info("Questionario con id " + questionario.getId() + " salvato con successo " + " in data " + sdf.format(new Date()));

            return questionario;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.error("Non è stato possibile salvare il questionario (Stato Completato)" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }

        return null;
    }

    public static void RicercaArchiviServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {

        try {

            JPAUtil jPAUtil = new JPAUtil();
            int start = Utils.tryParseInt(request.getParameter("start"));
            int pageSize = Utils.tryParseInt(request.getParameter("pageSize"));
            String stato_questionario_select = request.getParameter("stato_questionario_select");
            String data_inizio = request.getParameter("data_inizio");
            String data_fine = request.getParameter("data_fine");
            String utente_select = request.getParameter("utente_select");
            String tipo_questionario = request.getParameter("tipo_questionario");
            long totalRecords = countUtenteQuestionari(utente_select, stato_questionario_select, data_inizio,
                    data_fine, tipo_questionario, logger);

            List<Questionario> questionari = RicercaArchivi(start, pageSize, stato_questionario_select,
                    data_inizio, data_fine, utente_select, tipo_questionario, logger);

            JsonObject jsonResponse = new JsonObject();
            JsonArray jsonData = new JsonArray();

            jsonResponse.addProperty("iTotalRecords", totalRecords);
            jsonResponse.addProperty("iTotalDisplayRecords", totalRecords);
            int sEchoValue = sEchoCounter.incrementAndGet();
            jsonResponse.addProperty("sEcho", sEchoValue);

            for (Questionario questionario : questionari) {
                JsonObject jsonQuestionario = new JsonObject();
                jsonQuestionario.addProperty("id", questionario.getId());
                jsonQuestionario.addProperty("data_di_assegnazione", questionario.getDataDiAssegnazione());
                if (questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("descrizione", "COMPLETATO");
                } else {
                    jsonQuestionario.addProperty("descrizione", questionario.getDescrizione().toString());
                }

                if (!questionario.getCategoria().isEmpty() && questionario.getDigicomp_questionario().isEmpty()) {
                    jsonQuestionario.addProperty("tipo", "Categoria");
                    List<Categoria> categoria_list = questionario.getCategoria();
                    for (Categoria categoria : categoria_list) {
                        jsonQuestionario.addProperty("livello", categoria.getNome());
                    }
                } else if (!questionario.getDigicomp_questionario().isEmpty() && questionario.getCategoria().isEmpty()) {
                    jsonQuestionario.addProperty("tipo", "DIGICOMP");
                    List<Digicomp> digicomp_list = questionario.getDigicomp_questionario();
                    for (Digicomp digicomp : digicomp_list) {
                        jsonQuestionario.addProperty("livello", digicomp.getDescrizione());
                    }
                } else {
                    jsonQuestionario.addProperty("tipo", "Modello Predefinito");
                    List<ModelloPredefinito> modello_predefinito_list = questionario.getModelliPredefiniti();
                    for (ModelloPredefinito modelloPredefinito : modello_predefinito_list) {
                        jsonQuestionario.addProperty("livello", modelloPredefinito.getDescrizione());
                    }
                }

                if (questionario.getStatus() == 3
                        && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO) || questionario.getStatus() == 4 && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("data_di_completamento", Utils.getparsedDate(questionario.getDataCompletamento().toString()));
                } else {
                    jsonQuestionario.addProperty("data_di_completamento", "non ancora completato");
                }

                Utente utente = jPAUtil.findUserByUtenteQuestionario(questionario.getId());
                if (utente != null) {
                    jsonQuestionario.addProperty("utente", utente.getNome() + " " + utente.getCognome());
                } else {
                    jsonQuestionario.addProperty("utente", "Utente non trovato");
                }

                if (questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)
                        && questionario.getStatus() == 3 || questionario.getStatus() == 4 && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("azione",
                            "<form method='POST' action='VisualizzaQuestionario'>"
                            + "<button type='submit' class='btn btn-primary'>Visualizza</button>"
                            + "<input type='hidden' name='questionario_id' value='" + questionario.getId() + "' />"
                            + "</form>"
                    );
                } else {
                    jsonQuestionario.addProperty("azione", "non disponibile");
                }

                jsonData.add(jsonQuestionario);
            }

            jsonResponse.add("aaData", jsonData);

            response.setContentType("application/json");
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"))) {
                out.print(jsonResponse.toString());
            }

        } catch (Exception e) {
            logger.error("Non è stato possibile effettuare la ricerca dei questionari (ADMIN)" + "\n" + Utils.estraiEccezione(e));
        }
    }

    public static void RicercaArchiviUtentiServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {

        try {
            int start = Utils.tryParseInt(request.getParameter("start"));
            int pageSize = Utils.tryParseInt(request.getParameter("pageSize"));
            String stato_questionario_select = request.getParameter("stato_questionario_select");
            String data_inizio = request.getParameter("data_inizio");
            String data_fine = request.getParameter("data_fine");
            String tipo_questionario = request.getParameter("tipo_questionario");
            HttpSession session = request.getSession();
            String userIdParam = Utils.checkAttribute(session, "userId");
            Long userId = Utils.tryParseLong(userIdParam);

            long totalRecords = countUtenteQuestionariUser(userId, stato_questionario_select, data_inizio, data_fine, tipo_questionario, logger);

            List<Questionario> questionari = RicercaArchiviUtente(start, pageSize, userId,
                    stato_questionario_select, data_inizio, data_fine, tipo_questionario, logger);

            JsonObject jsonResponse = new JsonObject();
            JsonArray jsonData = new JsonArray();

            jsonResponse.addProperty("iTotalRecords", totalRecords);
            jsonResponse.addProperty("iTotalDisplayRecords", totalRecords);
            int sEchoValue = sEchoCounter.incrementAndGet();
            jsonResponse.addProperty("sEcho", sEchoValue);

            for (Questionario questionario : questionari) {
                JsonObject jsonQuestionario = new JsonObject();
                jsonQuestionario.addProperty("id", questionario.getId());
                jsonQuestionario.addProperty("data_di_assegnazione", questionario.getDataDiAssegnazione());
                if (questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("descrizione", "COMPLETATO");
                } else {
                    jsonQuestionario.addProperty("descrizione", questionario.getDescrizione().toString());
                }
                if (!questionario.getCategoria().isEmpty() && questionario.getDigicomp_questionario().isEmpty()) {
                    jsonQuestionario.addProperty("tipo", "Categoria");
                    List<Categoria> categoria_list = questionario.getCategoria();
                    for (Categoria categoria : categoria_list) {
                        jsonQuestionario.addProperty("livello", categoria.getNome());
                    }
                } else if (!questionario.getDigicomp_questionario().isEmpty() && questionario.getCategoria().isEmpty()) {
                    jsonQuestionario.addProperty("tipo", "DIGICOMP");
                    List<Digicomp> digicomp_list = questionario.getDigicomp_questionario();
                    for (Digicomp digicomp : digicomp_list) {
                        jsonQuestionario.addProperty("livello", digicomp.getDescrizione());
                    }
                } else {
                    jsonQuestionario.addProperty("tipo", "Modello Predefinito");
                    List<ModelloPredefinito> modello_predefinito_list = questionario.getModelliPredefiniti();
                    for (ModelloPredefinito modelloPredefinito : modello_predefinito_list) {
                        jsonQuestionario.addProperty("livello", modelloPredefinito.getDescrizione());
                    }
                }

                if (questionario.getStatus() == 3
                        && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO) || questionario.getStatus() == 4 && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("data_di_completamento", Utils.getparsedDate(questionario.getDataCompletamento().toString()));
                } else {
                    jsonQuestionario.addProperty("data_di_completamento", "non ancora completato");
                }

                JPAUtil jPAUtil = new JPAUtil();
                Utente utente = jPAUtil.findUserByUtenteQuestionario(questionario.getId());
                if (utente != null) {
                    jsonQuestionario.addProperty("utente", utente.getNome() + " " + utente.getCognome());
                } else {
                    jsonQuestionario.addProperty("utente", "Utente non trovato");
                }

                if (questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)
                        && questionario.getStatus() == 3 || questionario.getStatus() == 4 && questionario.getDescrizione().equals(Stato_questionario.COMPLETATO2)) {
                    jsonQuestionario.addProperty("azione",
                            "<form method='POST' action='VisualizzaQuestionario'>"
                            + "<button type='submit' class='btn btn-primary'>Visualizza</button>"
                            + "<input type='hidden' name='questionario_id' value='" + questionario.getId() + "' />"
                            + "</form>"
                    );

                } else {
                    jsonQuestionario.addProperty("azione", "non disponibile");
                }
                jsonData.add(jsonQuestionario);
            }

            jsonResponse.add("aaData", jsonData);

            response.setContentType("application/json");
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"))) {
                out.print(jsonResponse.toString());
            }

        } catch (Exception e) {
            logger.error("Non è stato possibile effettuare la ricerca dei questionari (USER)" + "\n" + Utils.estraiEccezione(e));
        }
    }

    public static long countUtenteQuestionariUser(Long userId, String stato_questionario_select, String data_inizio,
            String data_fine, String tipo_questionario, Logger logger) {

        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        long totalRecords = 0;

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");

        try {

            StringBuilder query = new StringBuilder(
                    "SELECT COUNT(q) FROM Questionario q JOIN q.utenti u WHERE u.id = :userId");

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                query.append(" AND q.descrizione = :stato_questionario_select");
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione >= :data_inizio");
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione <= :data_fine");
            }

            if (tipo_questionario != null && !tipo_questionario.equals("Tutti")) {
                if (tipo_questionario.equals("Modello_predefinito")) {
                    query.append(" AND SIZE(q.modelliPredefiniti) > 0");
                } else if (tipo_questionario.equals("Categoria")) {
                    query.append(" AND SIZE(q.categoria) > 0");
                } else if (tipo_questionario.equals("DIGICOMP")) {
                    query.append(" AND SIZE(q.digicomp_questionario) > 0");
                }
            }

            Query countQuery = em.createQuery(query.toString())
                    .setParameter("userId", userId);

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                countQuery.setParameter("stato_questionario_select",
                        Stato_questionario.valueOf(stato_questionario_select));
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                Date dateInizio = inputFormat.parse(data_inizio);
                String formattedDataInizio = outputFormat.format(dateInizio);
                countQuery.setParameter("data_inizio", formattedDataInizio);
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                Date dateFine = inputFormat.parse(data_fine);
                String formattedDataFine = outputFormat.format(dateFine) + " 23:59:59";
                countQuery.setParameter("data_fine", formattedDataFine);
            }

            List<Long> countList = countQuery.getResultList();
            if (!countList.isEmpty()) {
                totalRecords = countList.get(0);
            } else {
                return 0;
            }

        } catch (ParseException e) {
            logger.error("Non è stato possibile effettuare il conteggio dei questionari (User)" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null) {
                em.close();
            }
        }

        return totalRecords;
    }

    public static long countUtenteQuestionari(String utenteIdParam, String stato_questionario_select,
            String data_inizio, String data_fine, String tipo_questionario, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        long totalRecords = 0;

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");

        try {

            StringBuilder query = new StringBuilder(
                    "SELECT COUNT(q) FROM Questionario q JOIN q.utenti ut WHERE 1=1");

            if (utenteIdParam != null && !utenteIdParam.equals("Tutti")) {
                query.append(" AND ut.id = :utenteId");
            }

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                query.append(" AND q.descrizione = :stato_questionario_select");
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione >= :data_inizio");
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione <= :data_fine");
            }

            if (tipo_questionario != null && !tipo_questionario.equals("Tutti")) {
                if (tipo_questionario.equals("Modello_predefinito")) {
                    query.append(" AND SIZE(q.modelliPredefiniti) > 0");
                } else if (tipo_questionario.equals("Categoria")) {
                    query.append(" AND SIZE(q.categoria) > 0");
                } else if (tipo_questionario.equals("DIGICOMP")) {
                    query.append(" AND SIZE(q.digicomp_questionario) > 0");
                }
            }

            Query countQuery = em.createQuery(query.toString());

            if (utenteIdParam != null && !utenteIdParam.equals("Tutti")) {
                Long utenteId = Utils.tryParseLong(utenteIdParam);
                countQuery.setParameter("utenteId", utenteId);
            }

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                countQuery.setParameter("stato_questionario_select",
                        Stato_questionario.valueOf(stato_questionario_select));
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                Date dateInizio = inputFormat.parse(data_inizio);
                String formattedDataInizio = outputFormat.format(dateInizio);
                countQuery.setParameter("data_inizio", formattedDataInizio);
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                Date dateFine = inputFormat.parse(data_fine);
                String formattedDataFine = outputFormat.format(dateFine) + " 23:59:59";
                countQuery.setParameter("data_fine", formattedDataFine);
            }

            List<Long> countList = countQuery.getResultList();
            if (!countList.isEmpty()) {
                totalRecords = countList.get(0);
            } else {
                return 0;
            }

        } catch (ParseException e) {
            logger.error("Non è stato possibile effettuare il conteggio dei questionari (ADMIN)" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null) {
                em.close();
            }
        }

        return totalRecords;
    }

    public static List<Questionario> RicercaArchivi(int start, int pageSize, String stato_questionario_select,
            String data_inizio, String data_fine, String utenteIdParam, String tipo_questionario, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        List<Questionario> resultList = new ArrayList<>();

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");

        try {
            em.getTransaction().begin();

            StringBuilder query = new StringBuilder("SELECT u FROM Questionario u JOIN u.utenti ut WHERE 1=1");

            if (utenteIdParam != null && !utenteIdParam.equals("Tutti")) {
                query.append(" AND ut.id = :utenteId");
            }

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                if (stato_questionario_select.equals("COMPLETATO")) {
                    query.append(" AND u.descrizione IN :stati_questionario_select");
                } else {
                    query.append(" AND u.descrizione = :stato_questionario_select");
                }
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                query.append(" AND u.dataDiAssegnazione >= :data_inizio");
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                query.append(" AND u.dataDiAssegnazione <= :data_fine");
            }

            if (tipo_questionario != null && !tipo_questionario.equals("Tutti")) {
                if (tipo_questionario.equals("Modello_predefinito")) {
                    query.append(" AND SIZE(u.modelliPredefiniti) > 0");
                } else if (tipo_questionario.equals("Categoria")) {
                    query.append(" AND SIZE(u.categoria) > 0");
                } else if (tipo_questionario.equals("DIGICOMP")) {
                    query.append(" AND SIZE(u.digicomp_questionario) > 0");

                }
            }

            Query jpqlQuery = em.createQuery(query.toString(), Questionario.class
            )
                    .setFirstResult(start)
                    .setMaxResults(pageSize);

            if (utenteIdParam != null && !utenteIdParam.equals("Tutti")) {
                Long utenteId = Utils.tryParseLong(utenteIdParam);
                jpqlQuery.setParameter("utenteId", utenteId);
            }

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                if (stato_questionario_select.equals("COMPLETATO")) {
                    jpqlQuery.setParameter("stati_questionario_select",
                            Arrays.asList(Stato_questionario.COMPLETATO, Stato_questionario.COMPLETATO2));
                } else {
                    jpqlQuery.setParameter("stato_questionario_select",
                            Stato_questionario.valueOf(stato_questionario_select));
                }
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                Date dateInizio = inputFormat.parse(data_inizio);
                String formattedDataInizio = outputFormat.format(dateInizio);
                jpqlQuery.setParameter("data_inizio", formattedDataInizio);
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                Date dateFine = inputFormat.parse(data_fine);
                String formattedDataFine = outputFormat.format(dateFine) + " 23:59:59";
                jpqlQuery.setParameter("data_fine", formattedDataFine);
            }

            resultList = jpqlQuery.getResultList();

            em.getTransaction().commit();
        } catch (ParseException e) {
            logger.error("Non è stato possibile effettuare la ricerca dei questionari (ARCHIVIO ADMIN)" + "\n" + Utils.estraiEccezione(e));
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
        } finally {
            if (em != null) {
                em.close();
            }
        }

        return resultList;
    }

    public static List<Questionario> RicercaArchiviUtente(int start, int pageSize, Long userId,
            String stato_questionario_select, String data_inizio, String data_fine, String tipo_questionario, Logger logger) {
        JPAUtil jPAUtil = new JPAUtil();
        EntityManager em = jPAUtil.getEm();
        List<Questionario> resultList = new ArrayList<>();

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");

        try {

            StringBuilder query = new StringBuilder(
                    "SELECT q FROM Questionario q JOIN q.utenti u WHERE u.id = :userId");

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                if (stato_questionario_select.equals("COMPLETATO")) {
                    query.append(" AND q.descrizione IN :stati_questionario_select");
                } else {
                    query.append(" AND q.descrizione = :stato_questionario_select");
                }
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione >= :data_inizio");
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                query.append(" AND q.dataDiAssegnazione <= :data_fine");
            }

            // Add tipo_questionario filter
            if (tipo_questionario != null && !tipo_questionario.equals("Tutti")) {
                if (tipo_questionario.equals("Modello_predefinito")) {
                    query.append(" AND SIZE(q.modelliPredefiniti) > 0");
                } else if (tipo_questionario.equals("Categoria")) {
                    query.append(" AND SIZE(q.categoria) > 0");
                } else if (tipo_questionario.equals("DIGICOMP")) {
                    query.append(" AND SIZE(q.digicomp_questionario) > 0");

                }
            }

            Query jpqlQuery = em.createQuery(query.toString(), Questionario.class
            )
                    .setFirstResult(start)
                    .setMaxResults(pageSize)
                    .setParameter("userId", userId);

            if (stato_questionario_select != null && !stato_questionario_select.equals("Tutti")) {
                if (stato_questionario_select.equals("COMPLETATO")) {
                    jpqlQuery.setParameter("stati_questionario_select",
                            Arrays.asList(Stato_questionario.COMPLETATO, Stato_questionario.COMPLETATO2));
                } else {
                    jpqlQuery.setParameter("stato_questionario_select",
                            Stato_questionario.valueOf(stato_questionario_select));
                }
            }

            if (data_inizio != null && !data_inizio.isEmpty()) {
                Date dateInizio = inputFormat.parse(data_inizio);
                String formattedDataInizio = outputFormat.format(dateInizio);
                jpqlQuery.setParameter("data_inizio", formattedDataInizio);
            }

            if (data_fine != null && !data_fine.isEmpty()) {
                Date dateFine = inputFormat.parse(data_fine);
                String formattedDataFine = outputFormat.format(dateFine) + " 23:59:59";
                jpqlQuery.setParameter("data_fine", formattedDataFine);
            }

            resultList = jpqlQuery.getResultList();

        } catch (ParseException e) {
            logger.error("Non è stato possibile effettuare la ricerca dei questionari (ARCHIVIO USER)" + "\n" + Utils.estraiEccezione(e));
        } finally {
            if (em != null) {
                em.close();
            }
        }

        return resultList;
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
