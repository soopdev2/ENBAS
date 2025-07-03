///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package other;
//
//import com.itextpdf.text.*;
//import com.itextpdf.text.pdf.*;
//import Utils.Utils;
//import java.io.FileNotFoundException;
//
//import java.io.FileOutputStream;
//
///**
// *
// * @author Salvatore
// */
//public class PdfGenerator {
//
//    public static void generaPdf(String outputPath, String titolo, String contenuto) {
//        Document document = new Document();
//
//        try {
//            PdfWriter.getInstance(document, new FileOutputStream(outputPath));
//            document.open();
//
//            Font titoloFont = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);
//            Font corpoFont = new Font(Font.FontFamily.TIMES_ROMAN, 10);
//
//            document.add(new Paragraph(titolo, titoloFont));
//            document.add(Chunk.NEWLINE);
//
//            for (String riga : contenuto.split("\n")) {
//                document.add(new Paragraph(riga, corpoFont));
//            }
//
//        } catch (DocumentException | FileNotFoundException e) {
//            System.out.println(Utils.estraiEccezione(e));
//        } finally {
//            document.close();
//        }
//    }
//}
