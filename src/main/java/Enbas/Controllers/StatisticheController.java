/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Enbas.Controllers;

import Enbas.Services.StatisticheService;
import Services.Filter.RolesAllowedCustom;
import Services.Filter.Secured;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Salvatore
 */
public class StatisticheController {

    private final Logger LOGGER = LoggerFactory.getLogger(StatisticheController.class);
    private final StatisticheService statisticheService = new StatisticheService();

    @GET
    @Path("/utente/{userId}")
    @Produces("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    @Secured
    @RolesAllowedCustom({1})
    public Response estraiExcelPerUtente(@PathParam("userId") Long utenteId) {
        try {
            byte[] excelData = statisticheService.estraiExcelPerUtente(utenteId, LOGGER);

            return Response.ok(excelData)
                    .header("Content-Disposition", "attachment; filename=\"statistiche_utente_" + utenteId + ".xlsx\"")
                    .build();
        } catch (Exception e) {
            LOGGER.error("Errore nell'estrazione dell'Excel per l'utente " + utenteId, e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Errore durante l'estrazione dell'Excel.")
                    .build();
        }
    }

    @GET
    @Path("/digicomp/controlla")
    @Secured
    @RolesAllowedCustom({1})
    @Produces(MediaType.APPLICATION_JSON)
    public Response controllaDigicomp() {
        try {
            statisticheService.controllaDigicompPerUtenti(LOGGER);

            return Response.status(Response.Status.OK)
                    .entity("{\"message\": \"Controllo completato con successo\"}")
                    .build();
        } catch (Exception e) {
            LOGGER.error("Errore durante il controllo dei questionari Digicomp.", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"message\": \"Errore durante il controllo dei questionari Digicomp.\"}")
                    .build();
        }
    }
}
