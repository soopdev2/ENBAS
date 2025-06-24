/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Enbas.Controllers;

import Entity.ModelloPredefinito;
import Entity.Questionario;
import Entity.Utente;
import Enum.Stato_questionario;
import Enbas.Services.QuestionarioService;
import Services.Filter.RolesAllowedCustom;
import Services.Filter.Secured;
import Utils.JPAUtil;
import Utils.Utils;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
@Path("/questionario")
public class QuestionarioController {

    private static final Logger LOGGER = LoggerFactory.getLogger(DomandaController.class.getName());
    QuestionarioService questionarioService = new QuestionarioService();

    @POST
    @Path("/assegna/{userId}")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    @Secured
    @RolesAllowedCustom({1})
    public Response assegnaQuestionario(
            @PathParam("userId") Long userId,
            @FormParam("assegna_questionario_select_utente") String[] assegnatiUtenti,
            @FormParam("assegna_questionario_select_questionario") String questionarioIdStr,
            @FormParam("assegna_questionario_select_categoria") String categoria,
            @FormParam("assegna_questionario_select_digicomp") String digicomp,
            @FormParam("numero_domande") String numeroDomandeStr) {

        EntityManager em = null;
        try {
            JPAUtil jpaUtil = new JPAUtil();
            em = jpaUtil.getEm();
            em.getTransaction().begin();

            if (categoria != null && numeroDomandeStr != null && assegnatiUtenti != null) {
                questionarioService.assegnaQuestionarioCategoria(categoria, numeroDomandeStr, assegnatiUtenti, LOGGER);
            } else if (digicomp != null) {
                questionarioService.assegnaQuestionarioDigicomp(digicomp, assegnatiUtenti, LOGGER);
            } else if (assegnatiUtenti != null && questionarioIdStr != null) {
                Long questionarioId = Utils.tryParseLong(questionarioIdStr);
                ModelloPredefinito modello = em.find(ModelloPredefinito.class, questionarioId);

                if (modello != null) {
                    for (String utenteIdStr : assegnatiUtenti) {
                        Long utenteId = Utils.tryParseLong(utenteIdStr);
                        Utente utente = em.find(Utente.class, utenteId);

                        if (utente != null) {
                            Questionario esistente = jpaUtil.findUtenteQuestionarioIdByUserId(utenteId);

                            if (esistente == null
                                    || (Stato_questionario.COMPLETATO.equals(esistente.getDescrizione()) && esistente.getStatus() == 3)) {

                                Questionario nuovo = new Questionario();
                                nuovo.setUtenti(List.of(utente));
                                nuovo.setModelliPredefiniti(List.of(modello));
                                nuovo.setStatus(0);
                                nuovo.setDescrizione(Stato_questionario.ASSEGNATO);

                                String data = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date());
                                nuovo.setDataDiAssegnazione(data);

                                em.persist(nuovo);
                                LOGGER.info("Questionario assegnato a utente ID: " + utenteId + " in data: " + data);
                            }
                        }
                    }
                }
            }

            em.getTransaction().commit();
            return Response.ok("{\"status\":\"successo\"}").build();

        } catch (Exception e) {
            if (em.getTransaction() != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.error("Errore durante l'assegnazione del questionario: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"Errore durante l'assegnazione\"}")
                    .build();
        }
    }

    @POST
    @Path("/inizia/{userId}")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    @Secured
    @RolesAllowedCustom({2})
    public Response salvaStatoQuestionarioPresoInCarico(
            @PathParam("userId") Long userId) {
        try {
            questionarioService.SalvaStatoQuestionarioPresoInCarico(userId, LOGGER);
            return Response.ok("{\"status\":\"successo\"}").build();
        } catch (IOException e) {
            LOGGER.error("Errore durante l'assegnazione del questionario: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"Errore durante l'assegnazione\"}")
                    .build();
        }
    }

    @POST
    @Path("/salvaQuestionario/{userId}/{questionarioId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Secured
    @RolesAllowedCustom({2})
    public Response salvaQuestionario(
            @PathParam("userId") Long userId,
            @PathParam("questionarioId") Long questionarioId,
            String jsonInput) {

        try {
            questionarioService.salvaQuestionario(userId, questionarioId, jsonInput, LOGGER);
            return Response.ok("{\"status\":\"successo\"}").build();
        } catch (IOException e) {
            LOGGER.error("Errore durante il salvataggio del questionario: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"Errore durante il salvataggio del questionario\"}")
                    .build();
        }
    }

    @POST
    @Path("/salvaProgressi")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Secured
    @RolesAllowedCustom({2})
    public Response salvaProgressi(String jsonInput) {
        try {
            questionarioService.salvaProgressi(jsonInput, LOGGER);
            return Response.ok("{\"status\":\"successo\"}").build();
        } catch (IOException e) {
            LOGGER.error("Errore durante il salvataggio dei progressi: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\":\"Errore durante il salvataggio dei progressi\"}")
                    .build();
        }
    }

    @GET
    @Path("/visualizzaAdmin/{id_utente}/{id_questionario}")
    @Produces("application/pdf")
    @Secured
    @RolesAllowedCustom({1})
    public Response visualizzaQuestionarioAdmin(@PathParam("id_utente") Long id_utente,
            @PathParam("id_questionario") Long id_questionario) {
        try {
            byte[] pdfBytes = questionarioService.generaPdfQuestionario(id_utente, id_questionario, LOGGER);
            return Response.ok(pdfBytes, MediaType.APPLICATION_OCTET_STREAM)
                    .header("Content-Disposition", "attachment; filename=\"questionario_" + id_utente + ".pdf\"")
                    .build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND).entity(e.getMessage()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Errore durante la generazione del PDF: " + e.getMessage()).build();
        }
    }

    @GET
    @Path("/visualizzaUser/{id_utente}/{id_questionario}")
    @Produces("application/pdf")
    @Secured
    @RolesAllowedCustom({2})
    public Response visualizzaQuestionarioUser(@PathParam("id_utente") Long id_utente,
            @PathParam("id_questionario") Long id_questionario) {
        try {
            JPAUtil jpaUtil = new JPAUtil();
            Utente utente = jpaUtil.findUserByUtenteQuestionario(id_questionario);
            if (!utente.getId().equals(id_utente)) {
                return Response.status(Response.Status.FORBIDDEN).entity("Accesso negato").build();
            }

            byte[] pdfBytes = questionarioService.generaPdfQuestionario(id_utente, id_questionario, LOGGER);
            return Response.ok(pdfBytes, MediaType.APPLICATION_OCTET_STREAM)
                    .header("Content-Disposition", "attachment; filename=\"questionario_" + id_utente + ".pdf\"")
                    .build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND).entity(e.getMessage()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Errore durante la generazione del PDF: " + e.getMessage()).build();
        }
    }

}
