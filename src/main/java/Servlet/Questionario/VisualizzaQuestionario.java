/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet.Questionario;

import Entity.Categoria;
import Entity.Digicomp;
import Entity.InfoTrack;
import Entity.ModelloPredefinito;
import Entity.Questionario;
import Entity.Utente;
import Utils.JPAUtil;
import Utils.Utils;
import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.text.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class VisualizzaQuestionario extends HttpServlet {

    public static JPAUtil jPAUtil;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String utenteQuestionarioIdParam = request.getParameter("questionario_id");
        final Logger LOGGER = LoggerFactory.getLogger(VisualizzaQuestionario.class.getName());
        HttpSession session = request.getSession();
        String userId = Utils.checkAttribute(session, "userId");

        if (utenteQuestionarioIdParam != null && !utenteQuestionarioIdParam.isEmpty()) {
            try {
                Long utenteQuestionarioId = Utils.tryParseLong((utenteQuestionarioIdParam));
                gestisciVisualizzazioneQuestionario(utenteQuestionarioId, response, LOGGER, userId);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID del questionario non valido.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametro questionario_id mancante.");
        }
    }

    private void gestisciVisualizzazioneQuestionario(Long utenteQuestionarioId,
            HttpServletResponse response, Logger logger, String userId) {
        generaPdfQuestionario(utenteQuestionarioId, response, logger, userId);
    }

    private static void generaPdfQuestionario(Long utenteQuestionarioId, HttpServletResponse response, Logger logger, String userId_sessione) {
        try {
            Questionario questionario = jPAUtil.findUtenteQuestionarioByUtenteQuestionarioId(utenteQuestionarioId);
            Utente utente = jPAUtil.findUserByUtenteQuestionario(utenteQuestionarioId);

            JSONObject jsonRisposte = new JSONObject(questionario.getRisposte());
            JSONObject risposte2 = jsonRisposte.getJSONObject("risposte");

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"questionario_" + utente.getNome() + ".pdf\"");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            BaseColor green = new BaseColor(0, 128, 85);
            Font fontBoldGreen = FontFactory.getFont(FontFactory.TIMES_ROMAN, 14, green);
            BaseColor red = new BaseColor(204, 51, 77);
            Font fontBoldRed = FontFactory.getFont(FontFactory.TIMES_ROMAN, 14, red);
            BaseColor blue = new BaseColor(0, 102, 204);
            Font fontBoldBlue = FontFactory.getFont(FontFactory.TIMES_ROMAN, 14, blue);

            int risposteDate = 0;
            int risposteCorrette = 0;
            int numero_domanda = 0;

            for (String key : risposte2.keySet()) {
                JSONObject risposta = risposte2.getJSONObject(key);

                numero_domanda++;
                String domanda = risposta.getString("domanda");
                boolean corretta = false;

                List<String> risposteUtente = new ArrayList<>();
                List<String> risposteGiuste = new ArrayList<>();

                if (risposta.has("risposta")) {
                    String rispostaTesto = risposta.getString("risposta");
                    String rispostaCorretta = risposta.getString("risposta corretta");
                    risposteUtente.add(rispostaTesto);
                    risposteGiuste.add(rispostaCorretta);
                    corretta = rispostaTesto.equals(rispostaCorretta);
                } else if (risposta.has("risposta_id") && risposta.has("risposte_corrette")) {
                    JSONArray idDate = risposta.getJSONArray("risposta_id");
                    JSONArray idCorrette = risposta.getJSONArray("risposte_corrette");

                    JSONArray testoDate = risposta.optJSONArray("risposta_testuale");
                    JSONArray testiCorrette = risposta.optJSONArray("testi_risposte_corrette");

                    Set<String> idDateSet = new HashSet<>();
                    for (int i = 0; i < idDate.length(); i++) {
                        idDateSet.add(idDate.getString(i));
                        if (testoDate != null && testoDate.length() > i) {
                            risposteUtente.add(testoDate.getString(i));
                        }
                    }

                    for (int i = 0; testiCorrette != null && i < testiCorrette.length(); i++) {
                        risposteGiuste.add(testiCorrette.getString(i));
                    }

                    Set<String> idCorretteSet = new HashSet<>();
                    for (int i = 0; i < idCorrette.length(); i++) {
                        idCorretteSet.add(idCorrette.getString(i));
                    }

                    corretta = idDateSet.equals(idCorretteSet);
                }

                risposteDate++;
                if (corretta) {
                    risposteCorrette++;
                }

                document.add(new Paragraph("\n"));
                PdfPTable table = new PdfPTable(2);

                try {
                    PdfPCell titleCell = new PdfPCell(new Phrase("Domanda - " + numero_domanda + "\n" + extractTextAfterBase64(domanda.trim())));
                    titleCell.setColspan(2);
                    titleCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(titleCell);

                    Image img = extractImageAfterBase64(domanda, logger);
                    if (img != null) {
                        PdfPCell imageCell = new PdfPCell(img, true);
                        imageCell.setColspan(2);
                        table.addCell(imageCell);
                    }
                } catch (Exception e) {
                    logger.error("Errore nel parsing della domanda o immagine base64: \n" + Utils.estraiEccezione(e));
                }

                if (!corretta) {
                    List<String> risposteUtentePulite = cleanHtmlFromList(risposteUtente);
                    List<String> risposteGiustePulite = cleanHtmlFromList(risposteGiuste);

                    table.addCell(new PdfPCell(new Phrase("Risposta data:")));
                    table.addCell(new PdfPCell(new Phrase(String.join(", ", risposteUtentePulite), fontBoldRed)));

                    table.addCell(new PdfPCell(new Phrase("Risposta corretta:")));
                    table.addCell(new PdfPCell(new Phrase(String.join(", ", risposteGiustePulite), fontBoldGreen)));
                } else {
                    List<String> risposteUtentePulite = cleanHtmlFromList(risposteUtente);
                    List<String> risposteGiustePulite = cleanHtmlFromList(risposteGiuste);

                    if (risposteGiustePulite.size() > 1) {
                        table.addCell(new PdfPCell(new Phrase("Risposte date (corrette):")));
                        table.addCell(new PdfPCell(new Phrase(String.join(", ", risposteUtentePulite), fontBoldGreen)));

                        table.addCell(new PdfPCell(new Phrase("Risposte corrette :")));
                        table.addCell(new PdfPCell(new Phrase(String.join(", ", risposteGiustePulite), fontBoldGreen)));
                    } else {
                        table.addCell(new PdfPCell(new Phrase("Risposta corretta:")));
                        table.addCell(new PdfPCell(new Phrase(String.join(", ", risposteGiustePulite), fontBoldGreen)));
                    }

                }
                document.add(table);
            }

            int risposteErrate = risposteDate - risposteCorrette;
            int percentuale = risposteDate > 0 ? (risposteCorrette * 100 / risposteDate) : 0;

            String livello = "Generico";
            if (questionario.getDigicomp_questionario().isEmpty() && questionario.getCategoria().isEmpty()) {
                for (ModelloPredefinito md : questionario.getModelliPredefiniti()) {
                    livello = "Modello Predefinito (" + md.getDescrizione() + ")";
                }
            } else if (!questionario.getCategoria().isEmpty()) {
                for (Categoria c : questionario.getCategoria()) {
                    livello = "Categoria (" + c.getNome() + ")";
                }
            } else {
                for (Digicomp dg : questionario.getDigicomp_questionario()) {
                    livello = dg.getDescrizione();
                }
            }

            document.add(new Paragraph("\n"));
            document.add(new Paragraph("Questionario Completato (" + percentuale + "%)"));
            document.add(new Paragraph("Tipo di questionario - " + livello));
            document.add(new Paragraph("\n"));
            document.add(new Paragraph("Dati personali", fontBoldBlue));
            document.add(new Paragraph("Nome completo: " + utente.getNome() + " " + utente.getCognome()));
            document.add(new Paragraph("Età: " + jsonRisposte.optInt("età", utente.getEtà())));
            document.add(new Paragraph("Indirizzo: " + jsonRisposte.optString("indirizzo", utente.getIndirizzo())));
            document.add(new Paragraph("Assegnato in data: " + jsonRisposte.optString("data_assegnazione", questionario.getDataDiAssegnazione().toString())));
            document.add(new Paragraph("Completato in data: " + jsonRisposte.optString("data_completamento", questionario.getDataCompletamento().toString())));
            document.add(new Paragraph("\n"));

            document.add(new Paragraph("Totale domande: " + risposteDate, fontBoldBlue));
            document.add(new Paragraph("Risposte corrette: " + risposteCorrette, fontBoldGreen));
            document.add(new Paragraph("Risposte errate: " + risposteErrate, fontBoldRed));

            document.close();
            InfoTrack infoTrack = new InfoTrack("READ,CREATE",
                    "VisualizzaQuestionario - Servlet - generaPdfQuestionario",
                    200,
                    "Il questionario con id " + questionario.getId() + " per il seguente utente con id : " + utente.getId() + " in formato PDF è stato generato con successo.",
                    "Servlet chiamata dall'utente con id " + userId_sessione + ".",
                    null,
                    Utils.formatLocalDateTime(LocalDateTime.now()));

            jPAUtil.SalvaInfoTrack(infoTrack, logger);
        } catch (Exception e) {
            Utente utente = jPAUtil.findUserByUtenteQuestionario(utenteQuestionarioId);
            InfoTrack infoTrack = new InfoTrack("READ,CREATE",
                    "Questionario controller - API - (/visualizzaPdf)",
                    500,
                    "Errore - Il questionario con id " + utenteQuestionarioId + " dell'utente " + utente.getId() + " non è stato generato.",
                    "API chiamata dall'utente con id " + userId_sessione + ".",
                    Utils.estraiEccezione(e),
                    Utils.formatLocalDateTime(LocalDateTime.now()));

            jPAUtil.SalvaInfoTrack(infoTrack, logger);
            logger.error("Non è stato possibile generare il pdf del questionario\n" + Utils.estraiEccezione(e));
        }
    }

    private static String extractTextAfterBase64(String input) {
        Pattern pattern = Pattern.compile("<br/><img src='data:image/[^;]+;base64,[^']*'[^>]* />");
        Matcher matcher = pattern.matcher(input);

        if (matcher.find()) {
            String textAfterBase64 = input.substring(matcher.end()).trim();
            return textAfterBase64;
        }
        return input;
    }

    private static Image extractImageAfterBase64(String input, Logger logger) {
        Pattern pattern = Pattern.compile("<br/><img src='data:image/[^;]+;base64,([^']+)'[^>]* />");
        Matcher matcher = pattern.matcher(input);

        if (matcher.find()) {
            String base64String = matcher.group(1);

            base64String = base64String.replaceAll("[^A-Za-z0-9+/=]", "");

            try {
                byte[] decodedBytes = Base64.decodeBase64(base64String);
                Image img = Image.getInstance(decodedBytes);
                return img;
            } catch (BadElementException | IOException e) {
                logger.error("Non è stato possibile estrarre l'immagine dal base64String" + "\n" + Utils.estraiEccezione(e));
            }
        }
        return null;
    }

    public static List<String> cleanHtmlFromList(List<String> lista) {
        List<String> pulita = new ArrayList<>();
        for (String s : lista) {
            String cleaned = s.replaceAll("<[^>]*>", "").trim();
            cleaned = StringEscapeUtils.unescapeHtml4(cleaned);
            pulita.add(cleaned);
        }
        return pulita;
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
