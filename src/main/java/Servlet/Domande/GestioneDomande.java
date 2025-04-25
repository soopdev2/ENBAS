/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Domande;

import Entity.Categoria;
import Entity.Competenza;
import Entity.Domanda;
import Enum.Visibilità_domanda;
import Utils.JPAUtil;
import Utils.Utils;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class GestioneDomande extends HttpServlet {

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
        boolean isCreate = Boolean.parseBoolean(request.getParameter("isCreate"));
        boolean isEdit = Boolean.parseBoolean(request.getParameter("isEdit"));
        final Logger LOGGER = LoggerFactory.getLogger(GestioneDomande.class.getName());

        if (isSearch) {
            RicercaDomandeServlet(request, response, LOGGER);
        } else if (isCreate) {
            CreaDomandeServlet(request, response, LOGGER);
        } else if (isEdit) {
            ModificaDomandeServlet(request, response, LOGGER);
        }
    }

    public static void RicercaDomandeServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {
        try {

            int start = Utils.tryParseInt(request.getParameter("start"));
            int pageSize = Utils.tryParseInt(request.getParameter("pageSize"));
            String area = request.getParameter("area");
            String area_competenza = request.getParameter("area_competenza");
            String competenza = request.getParameter("competenza");
            String stato = request.getParameter("stato");
            JPAUtil jpaUtil = new JPAUtil();

            long totalRecords = jpaUtil.countDomande(area, area_competenza, competenza, stato, logger);

            List<Domanda> domande = jpaUtil.RicercaDomande(start, pageSize, area, area_competenza, competenza, stato, logger);

            JsonObject jsonResponse = new JsonObject();
            JsonArray jsonData = new JsonArray();

            jsonResponse.addProperty("iTotalRecords", totalRecords);
            jsonResponse.addProperty("iTotalDisplayRecords", totalRecords);
            int sEchoValue = sEchoCounter.incrementAndGet();
            jsonResponse.addProperty("sEcho", sEchoValue);

            for (Domanda domanda : domande) {
                JsonObject jsonDomande = new JsonObject();
                jsonDomande.addProperty("id", domanda.getId());
                if (domanda.getTitolo() != null) {
                    String titoloTesto = Utils.escapeHtmlAttribute(domanda.getTitolo());
                    String titolo = "<span data-bs-toggle='tooltip' title='" + titoloTesto + "'>" + titoloTesto + "</span>";
                    jsonDomande.addProperty("titolo", titolo);

                } else {
                    jsonDomande.addProperty("titolo", "non disponibile");
                }
                if (domanda.getNome_domanda() != null) {
                    jsonDomande.addProperty("nome", domanda.getNome_domanda());
                } else {
                    jsonDomande.addProperty("nome", "non disponibile");
                }

                String codiceArea = (domanda.getCategoria() != null) ? String.valueOf(Utils.estraiMNumero(domanda.getCategoria().getNome())) : " - ";
                String testoArea = (domanda.getCategoria() != null) ? Utils.escapeHtmlAttribute(domanda.getCategoria().getNome()) : " - ";

                String codiceAreaComp = " - ";
                String testoAreaComp = " - ";
                if (domanda.getCompetenza() != null && domanda.getCompetenza().getAreeCompetenze() != null) {
                    String nomeArea = domanda.getCompetenza().getAreeCompetenze().getNome();
                    codiceAreaComp = Utils.estraiNumeriIniziali(nomeArea);
                    testoAreaComp = nomeArea;
                }

                String codiceComp = " - ";
                String testoComp = " - ";
                if (domanda.getCompetenza() != null && domanda.getCompetenza().getDescrizione() != null) {
                    String descrizione = domanda.getCompetenza().getDescrizione();
                    codiceComp = Utils.estraiNumeriIniziali(descrizione);
                    testoComp = descrizione;
                }

                String testiComposti = Utils.escapeHtmlAttribute(testoArea) + "\n" + Utils.escapeHtmlAttribute(testoAreaComp) + "\n" + Utils.escapeHtmlAttribute(testoComp);
                String codiciComposti = "<span data-bs-toggle='tooltip' title='" + testiComposti + "'>"
                        + Utils.escapeHtmlAttribute(codiceArea) + "-" + Utils.escapeHtmlAttribute(codiceAreaComp) + "-" + Utils.escapeHtmlAttribute(codiceComp) + "</span>";

                jsonDomande.addProperty("info", codiciComposti);

                if (domanda.getVisibilità_domanda() != null) {
                    if (domanda.getVisibilità_domanda().toString().equals(Visibilità_domanda.VISIBILE.toString())) {
                        jsonDomande.addProperty("stato", "<svg class='icon icon-success ms-1' style='margin-right:5px'><use href='dist/svg/sprites.svg#it-check-circle'></use></svg><span>Attiva</span>");
                    } else {
                        jsonDomande.addProperty("stato", "<svg class='icon icon-danger ms-1' style='margin-right:5px'><use href='dist/svg/sprites.svg#it-close-circle'></use></svg><span>Non attiva</span>");
                    }
                } else {
                    jsonDomande.addProperty("stato", "non disponibile");
                }

                String azione = "<div class='container-fluid'>"
                        + "<form method='POST' action='AD_modifica_domanda.jsp' style='margin: 0;'>"
                        + "<button type='submit' class='btn btn-primary btn-sm text-center' style='height:50%'>"
                        + "<svg class='icon icon-white ms-1'><use href='dist/svg/sprites.svg#it-pencil'></use></svg>"
                        + "</button>"
                        + "<input type='hidden' name='domanda_id' value='" + domanda.getId() + "' />"
                        + "</form>"
                        + "</div>";

                jsonDomande.addProperty("azione", azione);

                jsonData.add(jsonDomande);
            }

            jsonResponse.add("aaData", jsonData);

            response.setContentType("application/json");
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"))) {
                out.print(jsonResponse.toString());
            } catch (IOException e) {
                logger.error("Errore durante la scrittura della risposta JSON", e);
            }

        } catch (Exception e) {
            logger.error("Non è stato possibile effettuare la ricerca dei questionari (ADMIN)" + "\n" + Utils.estraiEccezione(e));
        }
    }

    public static void CreaDomandeServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {

        try {
            JPAUtil jpaUtil = new JPAUtil();

            String area_id_param = request.getParameter("area");
            Long areaId = Utils.tryParseLong(area_id_param);
            Categoria categoria = jpaUtil.findCategoriaById(areaId);

            String abilità_competenza_param = request.getParameter("abilità_competenza");
            Long abilità_competenza_id = Utils.tryParseLong(abilità_competenza_param);
            Competenza competenza = jpaUtil.findCompetenzaById(abilità_competenza_id);

            String stato = request.getParameter("stato");

            String titolo = request.getParameter("titolo");

            String nome_domanda = request.getParameter("nome_domanda");

            String[] risposta_text = request.getParameterValues("risposta_text");

            String[] si_no_select = request.getParameterValues("si_no_select");

            jpaUtil.creaDomanda(categoria, competenza, stato, titolo, nome_domanda, risposta_text, si_no_select, logger);
            response.sendRedirect("AD_crea_domanda.jsp?esito=OK&codice=005");

        } catch (Exception e) {
            logger.error("Non è stato possibile creare la domanda." + "\n" + Utils.estraiEccezione(e));
            response.sendRedirect("AD_crea_domanda.jsp?esito=KO&codice=005");
        }
    }

    public static void ModificaDomandeServlet(HttpServletRequest request, HttpServletResponse response, Logger logger)
            throws ServletException, IOException {
        try {
            JPAUtil jpaUtil = new JPAUtil();

            String domanda_id_param = request.getParameter("domanda_id");
            Long domanda_id = Utils.tryParseLong(domanda_id_param);

            String area_id_param = request.getParameter("area");
            Long areaId = Utils.tryParseLong(area_id_param);
            Categoria categoria = jpaUtil.findCategoriaById(areaId);

            String abilità_competenza_param = request.getParameter("competenza");
            Long abilità_competenza_id = Utils.tryParseLong(abilità_competenza_param);
            Competenza competenza = jpaUtil.findCompetenzaById(abilità_competenza_id);

            String stato = request.getParameter("stato");

            String titolo = request.getParameter("titolo");

            String nome_domanda = request.getParameter("nome_domanda");

            String[] risposta_text = request.getParameterValues("risposta_text[]");

            String[] si_no_select = request.getParameterValues("si_no_select[]");

            String[] idRisposte = request.getParameterValues("id_risposta[]");

            jpaUtil.modificaDomanda(domanda_id, categoria, competenza, stato, titolo, nome_domanda, risposta_text, idRisposte, si_no_select, logger);
            response.sendRedirect("AD_gestione_domande.jsp?esito=OK&codice=006");

        } catch (Exception e) {
            logger.error("Non è stato possibile creare la domanda." + "\n" + Utils.estraiEccezione(e));
            response.sendRedirect("AD_gestione_domande.jsp?esito=KO&codice=006");
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
