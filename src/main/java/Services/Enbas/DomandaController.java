/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services.Enbas;

import Utils.JPAUtil;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;
import Entity.Domanda;
import Services.Filter.RolesAllowedCustom;
import Services.Filter.Secured;
import com.google.gson.JsonObject;
import jakarta.ws.rs.HeaderParam;

/**
 *
 * @author Salvatore
 */
@Path("/domanda")
public class DomandaController {

    @GET
    @Path("/findById/{id}")
    @Secured
    @RolesAllowedCustom({1, 2})
    public Response findById(@PathParam("id") Long id, @HeaderParam("Authorization") String authorizationHeader) {
        try {
            JPAUtil jpaUtil = new JPAUtil();
            Domanda domanda = jpaUtil.findDomandaById(id);

            if (domanda == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\":\"Domanda non trovata\"}")
                        .build();
            }
            JsonObject json = new JsonObject();
            json.addProperty("id", domanda.getId());
            if (domanda.getTitolo() != null) {
                json.addProperty("titolo", domanda.getTitolo());
            }
            if (domanda.getNome_domanda() != null) {
                json.addProperty("nome", domanda.getNome_domanda());
            }
            if (domanda.getDescrizione() != null) {
                json.addProperty("descrizione", domanda.getDescrizione());
            }
            if (domanda.getOpzioni() != null) {
                json.addProperty("opzioni", domanda.getOpzioni());
            }
            if (domanda.getCategoria() != null && domanda.getCategoria().getNome() != null) {
                json.addProperty("area", domanda.getCategoria().getNome());
            }
            if (domanda.getCompetenza() != null
                    && domanda.getCompetenza().getAreeCompetenze() != null
                    && domanda.getCompetenza().getAreeCompetenze().getNome() != null) {
                json.addProperty("competenza", "area competenza " + domanda.getCompetenza().getAreeCompetenze().getNome() + " - "
                        + "descrizione competenza " + domanda.getCompetenza().getDescrizione()
                        + "\n - livello - "
                        + domanda.getCompetenza().getLivello());
            }

            return Response.ok(json.toString()).build();

        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().entity("{\"error\": \"Errore interno\"}").build();
        }
    }

//    @GET
//    @Path("/findAll")
//    public Response getAllDomande();
//
//    @POST
//    @Path("/create")
//    public Response createDomanda();
//
//    @PATCH
//    @Path("/update")
//    public Response updateDomanda();
    @DELETE
    @Path("/delete/{id}")
    @Secured
    @RolesAllowedCustom({1})
    public Response delete(@PathParam("id") Long id, @HeaderParam("Authorization") String authorizationHeader) {
        try {
            JPAUtil jpaUtil = new JPAUtil();
            boolean deleted = jpaUtil.deleteDomandaById(id);

            if (!deleted) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\":\"Domanda non trovata\"}")
                        .build();
            }

            return Response.ok("{\"message\":\"Domanda eliminata con successo\"}").build();

        } catch (Exception e) {
            return Response.serverError().entity("{\"error\":\"Errore eliminazione domanda\"}").build();
        }
    }

}
