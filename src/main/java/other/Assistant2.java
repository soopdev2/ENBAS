
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package other;

/**
 *
 * @author Salvatore
 */
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;

@SystemMessage("Sei un esperto sul DigComp. Analizza e classifica le domande usando SOLO il documento fornito (syllabus).")
public interface Assistant2 {

    @UserMessage("{{query}}")
    String classificaDomanda(String query);
}