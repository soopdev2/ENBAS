///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package Procedures;
//
///**
// *
// * @author Salvatore
// */
//
//import other.Assistant;
//import other.PdfGenerator;
//import dev.langchain4j.data.document.Document;
//import dev.langchain4j.data.segment.TextSegment;
//import dev.langchain4j.memory.chat.MessageWindowChatMemory;
//import dev.langchain4j.model.chat.ChatModel;
//import dev.langchain4j.model.openai.OpenAiChatModel;
//import dev.langchain4j.rag.content.retriever.ContentRetriever;
//import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
//import dev.langchain4j.service.AiServices;
//import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
//import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
//
//import java.nio.file.*;
//import java.util.*;
//
//import static dev.langchain4j.data.document.loader.FileSystemDocumentLoader.loadDocuments;
//import java.io.PrintStream;
//import java.io.UnsupportedEncodingException;
//import other.Assistant2;
//import static other.Utils.*;
//
//public class testLangChain {
//
//    private static final ChatModel CHAT_MODEL = OpenAiChatModel.builder()
//            //.apiKey(OPENAI_API_KEY)
//            .baseUrl("http://langchain4j.dev/demo/openai/v1")
//            .apiKey("demo")
//            .modelName("gpt-4o-mini")
//            .maxTokens(MAX_TOKENS)
//            .maxRetries(MAX_RETRIES)
//            .logResponses(true)
//            .build();
//
//    public static void main(String[] args) throws UnsupportedEncodingException  {
//
//        //ValutaEsame();
//        ClassificaDomande();
//
//    }
//
//    private static void ValutaEsame() {
//        String desktopPath = System.getProperty("user.home") + "\\Desktop\\digicomp";
//        Path path = Paths.get(desktopPath);
//        List<Document> documents = Files.exists(path) ? loadDocuments(path, glob("*.pdf")) : List.of();
//
//        if (documents.isEmpty()) {
//            System.out.println("Nessun documento trovato in: " + path);
//            return;
//        }
//
//        Assistant assistant = AiServices.builder(Assistant.class)
//                .chatModel(CHAT_MODEL)
//                .chatMemory(MessageWindowChatMemory.withMaxMessages(10))
//                .contentRetriever(createContentRetriever(documents))
//                .build();
//
//        String valutazione = assistant.valutaEsame("""
//        Fornisci solo la valutazione oggettiva e definitiva del livello DigComp dell'utente, per ogni area di competenza, 
//        utilizzando esclusivamente i contenuti dei documenti 'statistiche.pdf', '675aae5c13b6833848d54f78_syllabus.pdf' e 'DigComp2-1_ITA.pdf'. 
//        Aggiungi dettagli sulle varie abilità essendo il digicomp basato sui vari livelli tipo base,intermedio, avanzato.
//        Analizza il tutto in modo ordinato e pulito.
//        """);
//
//        String outputPath = desktopPath + "\\valutazione_digicomp.pdf";
//        PdfGenerator.generaPdf(outputPath, "Risultato valutazione DigComp", valutazione);
//        System.out.println("PDF salvato in: " + outputPath);
//    }
//
//    private static void ClassificaDomande() throws UnsupportedEncodingException  {
//        System.setOut(new PrintStream(System.out, true, "UTF-8"));
//        String desktopPath = System.getProperty("user.home") + "\\Desktop\\digicomp";
//        Path path = Paths.get(desktopPath);
//        List<Document> documents = Files.exists(path) ? loadDocuments(path, glob("*.pdf")) : List.of();
//
//        if (documents.isEmpty()) {
//            System.out.println("Nessun documento trovato in: " + path);
//            return;
//        }
//
//        Scanner scanner = new Scanner(System.in);
//        System.out.println("Inserisci la domanda da classificare:");
//        String domandaUtente = scanner.nextLine();
//
//        Assistant2 assistant2 = AiServices.builder(Assistant2.class)
//                .chatModel(CHAT_MODEL)
//                .chatMemory(MessageWindowChatMemory.withMaxMessages(10))
//                .contentRetriever(createContentRetriever(documents))
//                .build();
//
//        String classificazione = assistant2.classificaDomanda("""
//    Classifica la seguente **domanda** in base al **quadro di riferimento europeo DigComp**, seguendo in modo rigoroso e oggettivo le seguenti istruzioni:
//
//    1. Analizza la domanda confrontandola con le **5 aree di competenza DigComp** e le relative **competenze specifiche**, come descritto nel documento '675aae5c13b6833 848d54f78_syllabus.pdf'.
//    2. Per ciascuna area DigComp, indica se esiste una corrispondenza tra la domanda e una delle **competenze previste**.
//    3. Riporta la classificazione nel formato:  
//        **Area → Competenza → Motivazione sintetica**  
//        (la motivazione deve essere breve, oggettiva e riferita solo al contenuto del documento).
//    4. Non includere interpretazioni soggettive, risultati dell’apprendimento, o generalizzazioni: **segui solo ciò che è presente nel documento PDF**.
//    5. La risposta deve essere ordinata, schematica e concentrata solo sulla classificazione DigComp.
//    6. Se esistono più possibili classificazioni, valuta quale sia la più coerente con la domanda:
//        - Se una classificazione è **chiaramente dominante (oltre il 50%% di coerenza)** rispetto alle altre, **riporta solo quella**.
//        - In caso contrario, indica anche le alternative, **con una stima percentuale di coerenza** per ciascuna.
//
//    Domanda da classificare:  
//        **"%s"**
//
//    Fornisci la classificazione in modo preciso, strutturato e pulito.
//""".formatted(domandaUtente));
//
//        System.out.println("Classificazione domanda: " + classificazione);
//    }
//
//    private static ContentRetriever createContentRetriever(List<Document> documents) {
//        InMemoryEmbeddingStore<TextSegment> store = new InMemoryEmbeddingStore<>();
//        EmbeddingStoreIngestor.ingest(documents, store);
//        return EmbeddingStoreContentRetriever.from(store);
//    }
//}
//
//
