package Procedures;

import Entity.Digicomp;
import Entity.Questionario;
import Entity.Utente;
import Utils.JPAUtil;
import Utils.Utils;
import static Utils.Utils.estraiEccezione;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Controlla se l'utente può avanzare al livello successivo del Digicomp.
 */
public class ControllaDigicomp {

    private static final Logger LOGGER = LoggerFactory.getLogger(ControllaDigicomp.class.getName());

    public static void main(String[] args) {
        JPAUtil jpaUtil = new JPAUtil();
        try {
            List<Utente> utenti = jpaUtil.findAllUtenti();
            ObjectMapper objectMapper = new ObjectMapper();

            for (Utente utente : utenti) {
                Questionario ultimoQuestionario = jpaUtil.findUltimoQuestionarioCompletatoPerUtente(utente);

                if (ultimoQuestionario == null) {
                    LOGGER.info("Nessun questionario completato trovato per l'utente " + utente.getId());
                    continue;
                }

                if (ultimoQuestionario.getDigicomp_questionario() == null || ultimoQuestionario.getDigicomp_questionario().isEmpty()) {
                    LOGGER.info("Il questionario con ID " + ultimoQuestionario.getId() + " non ha un Digicomp associato per l'utente " + utente.getId());
                    continue;
                }

                Digicomp digicompAttuale = ultimoQuestionario.getDigicomp_questionario().get(0);
                int livelloCorrente = Utils.tryParseInt(digicompAttuale.getId().toString());

                if (livelloCorrente >= 5) {
                    LOGGER.info("L'utente con ID " + utente.getId() + " ha già completato il livello massimo.");
                    //jpaUtil.createExcel(ultimoQuestionario);
                    continue;
                }

                String jsonRisposte = ultimoQuestionario.getRisposte();
                if (jsonRisposte == null || jsonRisposte.isEmpty()) {
                    LOGGER.info("Nessuna risposta trovata per l'utente " + utente.getId() + ".");
                    continue;
                }

                JsonNode rootNode = objectMapper.readTree(jsonRisposte);
                JsonNode risposteNode = rootNode.path("risposte");

                if (risposteNode.isMissingNode()) {
                    LOGGER.info("Formato JSON non valido per l'utente " + utente.getId() + ".");
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

                LOGGER.info("Totale risposte corrette per l'utente " + utente.getId() + ": " + risposteCorretteTotali + " su " + risposteNode.size() + " risposte.");
                LOGGER.info("Risposte corrette per categoria per l'utente " + utente.getId() + ": " + risposteCorrettePerCategoria);
                if (!domandeSbagliate.isEmpty()) {
                    LOGGER.info("Domande sbagliate per l'utente " + utente.getId() + ": " + domandeSbagliate);
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
                } else {
                    LOGGER.info("Il questionario con ID " + ultimoQuestionario.getId() + " per l'utente " + utente.getId() + " non ha superato il livello " + livelloCorrente);
                    //jpaUtil.createExcel(ultimoQuestionario); // puoi sbloccarlo se vuoi generare Excel anche in caso di fallimento
                    for (String errore : domandeSbagliate) {
                        LOGGER.info(errore);
                    }
                }
            }
        } catch (JsonProcessingException e) {
            LOGGER.error("Non è stato possibile effettuare il controllo sui questionari di tipo Digicomp" + "\n" + estraiEccezione(e));
        }
    }

}
