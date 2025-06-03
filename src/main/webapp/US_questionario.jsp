<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="Enum.Tipo_inserimento"%>
<%@page import="Entity.Digicomp"%>
<%@page import="Entity.Categoria"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Utils.JPAUtil"%>
<%@page import="Entity.ModelloPredefinito"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
<%@page import="Enum.Stato_questionario"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Enum.Tipo_domanda"%>
<%@page import="Utils.Utils"%>
<%@page import="Entity.Utente"%>
<%@page import="java.util.List"%>
<%@page import="Entity.Domanda"%>
<%@page import="Entity.Questionario"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ruolo = null;
    String pageName = null;

    Utente utenteSessione = (Utente) session.getAttribute("user");
    if (utenteSessione == null) {
        response.sendRedirect("index.jsp");
    } else {
        String uri = request.getRequestURI();
        pageName = uri.substring(uri.lastIndexOf("/") + 1);
        ruolo = String.valueOf(utenteSessione.getRuolo().getId());
        JPAUtil jpaUtil = new JPAUtil();
        if (!jpaUtil.isVisible(ruolo, pageName)) {
            response.sendRedirect(request.getContextPath() + "/403.jsp");
        } else {
            String src = Utils.checkAttribute(session, ("src"));
        }
    }

%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Questionario</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="dist/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="dist/assets/css/custom/global.css"/>
        <link rel="icon" type="image/png" href="dist/img/favicon/favicon-96x96.png" sizes="96x96" />
        <link rel="icon" type="image/svg+xml" href="dist/img/favicon/favicon.svg" />
        <link rel="shortcut icon" href="dist/img/favicon/favicon.ico" />
        <link rel="apple-touch-icon" sizes="180x180" href="dist/img/favicon/apple-touch-icon.png" />
        <link href='https://fonts.googleapis.com/css?family=Titillium Web' rel='stylesheet'>
        <script src="dist/assets/js/external/jquery-3.7.1.js"></script>
        <script src="dist/assets/js/external/survey/markdown-it.min.js"></script>

        <script src="dist/assets/js/external/survey/survey.jquery.min.js"></script>
        <link href="dist/assets/css/external/survey/survey.css" rel="stylesheet"/>
        <script src="dist/assets/js/external/babel.min.js"></script>

        <script src="dist/assets/js/external/survey/survey.core.min.js"></script>
        <script src="dist/assets/js/external/survey/survey.i18n.min.js"></script>
        <script src="dist/assets/js/external/survey/themes.index.min.js"></script>
        <script src="dist/assets/js/external/survey/survey-js-ui.js"></script>


        <link rel="stylesheet" href="dist/assets/css/external/survey/defaultV2.min.css" />
        <link rel="stylesheet" href="dist/assets/css/custom/survey.css"/>


    </head>
    <body>
        <%            String userIdParam = Utils.checkAttribute(session, "userId");
            JPAUtil jPAUtil = new JPAUtil();
            Utente utente = jPAUtil.findUserByUserId(userIdParam);
            Long userId = utente.getId();

            Questionario utenteQuestionario = jPAUtil.findUtenteQuestionarioIdByUserId(utente.getId());
            if (utenteQuestionario != null) {
                Long questionarioId;
                List<ModelloPredefinito> questionariAssociati = null;
                ModelloPredefinito ultimoQuestionario = null;

                if (!utenteQuestionario.getCategoria().isEmpty() || !utenteQuestionario.getDigicomp_questionario().isEmpty()) {
                    questionarioId = utenteQuestionario.getId();
                } else {
                    questionariAssociati = utenteQuestionario.getQuestionari();
                    ultimoQuestionario = questionariAssociati.get(questionariAssociati.size() - 1);
                    questionarioId = ultimoQuestionario.getId();
                }

                session.setAttribute("questionarioId", questionarioId);
                String progressi = new ObjectMapper().writeValueAsString(utenteQuestionario.getProgressi());

                String risposte = null;
                List<Domanda> domande = new ArrayList<>();
                String livello = "Generico";
                if (utenteQuestionario.getDigicomp_questionario().isEmpty() && utenteQuestionario.getCategoria().isEmpty()) {
                    List<ModelloPredefinito> modelliPredefiniti = utenteQuestionario.getModelliPredefiniti();
                    for (ModelloPredefinito md : modelliPredefiniti) {
                        livello = "Modello Predefinito " + "(" + md.getDescrizione() + ")";
                    }
                } else if (utenteQuestionario.getDigicomp_questionario().isEmpty() && !utenteQuestionario.getCategoria().isEmpty()) {
                    List<Categoria> categoria_list = utenteQuestionario.getCategoria();
                    for (Categoria c : categoria_list) {
                        livello = "Categoria" + "(" + c.getNome() + ")";
                    }

                } else {
                    List<Digicomp> digicomp_list = utenteQuestionario.getDigicomp_questionario();
                    for (Digicomp dg : digicomp_list) {
                        livello = dg.getDescrizione();
                    }
                }

                if (utenteQuestionario.getDescrizione() == null) {
                    out.print("Non hai nessun questionario assegnato");
                } else if (utenteQuestionario.getStatus() == 3) {
                    risposte = utenteQuestionario.getRisposte();
                } else if (utenteQuestionario.getDigicomp_questionario().isEmpty() && utenteQuestionario.getCategoria().isEmpty()) {
                    domande = jPAUtil.findQuestions(ultimoQuestionario.getId());
                } else {
                    domande = utenteQuestionario.getDomande();
                }


        %>


        <header class="it-header-wrapper">
            <div class="it-header-slim-wrapper">
                <div class="container-xxl">
                    <div class="row">
                        <div class="col-12">
                            <div class="it-header-slim-wrapper-content">
                                <a class="d-none d-lg-block navbar-brand" href="#">Ente appartenenza</a>
                                <div class="nav-mobile">
                                    <nav aria-label="Navigazione secondaria">
                                        <a class="it-opener d-lg-none" data-bs-toggle="collapse" href="#menuC1" role="button" aria-expanded="false" aria-controls="menuC1">
                                            <span>Ente appartenenza</span>
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-expand"></use></svg>
                                        </a>

                                    </nav>
                                </div>
                                <div class="it-header-slim-right-zone">
                                    <div class="it-access-top-wrapper">
                                        <a class="btn btn-primary btn-sm" onclick="logout()">ESCI</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="it-nav-wrapper">
                <div class="it-header-center-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <div class="it-header-center-content-wrapper">
                                    <div class="it-brand-wrapper">
                                        <a href="#">
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                            <div class="it-brand-text">
                                                <div class="it-brand-title">ENBAS</div>
                                                <div class="it-brand-tagline d-none d-md-block">QUESTIONARI DIGICOMP 2.2</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="it-right-zone">
                                        <div class="it-socials d-none d-md-flex">
                                            <span>Seguici su</span>
                                            <ul>
                                                <li>
                                                    <a href="#" aria-label="Facebook" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-facebook"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Github" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-github"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Twitter" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-twitter"></use></svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="it-header-navbar-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <!--start nav-->
                                <nav class="navbar navbar-expand-lg has-megamenu" aria-label="Navigazione principale">
                                    <button class="custom-navbar-toggler" type="button" aria-controls="navC1" aria-expanded="false" aria-label="Mostra/Nascondi la navigazione" data-bs-toggle="navbarcollapsible" data-bs-target="#navC1">
                                        <svg class="icon">
                                        <use href="dist/svg/sprites.svg#it-burger"></use>
                                        </svg>
                                    </button>
                                    <div class="navbar-collapsable" id="navC1" style="display: none;">
                                        <div class="overlay" style="display: none;"></div>
                                        <div class="close-div">
                                            <button class="btn close-menu" type="button">
                                                <span class="visually-hidden">Nascondi la navigazione</span>
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-close-big"></use>
                                                </svg>
                                            </button>
                                        </div>
                                        <div class="menu-wrapper">
                                            <ul class="navbar-nav">
                                                <li class="nav-item"><a class="nav-link" href="US_homepage.jsp" aria-current="page">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                                            Homepage
                                                        </span>
                                                    </a></li>
                                                <li class="nav-item active">
                                                    <a class="nav-link active" href="US_questionario.jsp">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-file"></use></svg>
                                                            Nuovo questionario
                                                        </span>
                                                        <span class="badge">
                                                            <%                                                                Questionario utente_questionario = jPAUtil.findUtenteQuestionarioIdByUserId(utente.getId());
                                                            %>

                                                            <% if (utente_questionario
                                                                        == null || utente_questionario.getStatus()
                                                                        == 0 && utente_questionario.getDescrizione() == null) {%>
                                                            <span class="badge bg" style="display: none">

                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 0 && utente_questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {%>
                                                            <span class="badge bg-danger">
                                                                Nuovo
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 1 && utente_questionario.getDescrizione().equals(Stato_questionario.PRESO_IN_CARICO) || utente_questionario.getStatus() == 2 && utente_questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE)) {%>
                                                            <span class="badge bg-warning">
                                                                Continua
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 3 && utente_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)) {%>
                                                            <span class="badge bg-success">
                                                                Completato
                                                            </span>
                                                            <% }%>
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item"><a class="nav-link" href="US_archivio.jsp"> <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-box"></use></svg>
                                                            Archivio
                                                        </span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>


        <% if (risposte
                    != null) {%>

        <div class="container">
            <br>
            <h3 class="text-success text-center">Questionario completato! </h3>
            <br>


            <div class="row">
                <div class="col-12 col-lg-6">

                    <div class="container-fluid">
                        <div class="card-wrapper">
                            <div class="card card-bg mb-6">
                                <div class="card-body">
                                    <div class="card-header text-center">
                                        <h3 class="card-title text-primary">
                                            Dati personali
                                        </h3>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover table-responsive table-bordered">
                                            <thead>
                                                <tr class="table-primary">
                                                    <th>Campo</th>
                                                    <th>Valore</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Nome : </td>
                                                    <td><%= utente.getNome()%></td>
                                                </tr>
                                                <tr>
                                                    <td>Cognome : </td>
                                                    <td><%= utente.getCognome()%></td>
                                                </tr>
                                                <tr>
                                                    <td>Età : </td>
                                                    <td><%= utente.getEtà()%></td>
                                                </tr>
                                                <tr>
                                                    <td>Indirizzo : </td>
                                                    <td><%= utente.getIndirizzo()%></td>
                                                </tr>
                                                <tr>
                                                    <td>Assegnato in data : </td>
                                                    <td><%= utente_questionario.getDataDiAssegnazione()%></td>
                                                </tr>
                                                <tr>
                                                    <td>Completato in data : </td>
                                                    <td><%= Utils.getparsedDate(utente_questionario.getDataCompletamento().toString())%></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <br>

                <div class="col-12 col-lg-6">
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <div class="card-header text-center">
                                    <h3 class="card-title text-primary">
                                        Domande e risposte
                                    </h3>
                                </div>

                                <%
                                    String risposteTabella = utente_questionario.getRisposte();
                                    JSONObject jsonRisposte = new JSONObject(risposteTabella);
                                    JSONObject risposte2 = jsonRisposte.getJSONObject("risposte");

                                    int risposteDate = 0;
                                    int risposteCorrette = 0;
                                    int risposteErrate = 0;
                                    int percentuale = 0;

                                    List<Map<String, Object>> risposteList = new ArrayList<>();

                                    for (String key : risposte2.keySet()) {
                                        JSONObject risposta = risposte2.getJSONObject(key);
                                        String domanda = risposta.getString("domanda");

                                        List<String> risposteUtente = new ArrayList<>();
                                        List<String> risposteGiuste = new ArrayList<>();
                                        boolean corretta = false;

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
                                        risposteErrate = risposteDate - risposteCorrette;
                                        percentuale = (risposteCorrette * 100) / risposteDate;

                                        Map<String, Object> rispostaData = new HashMap<>();
                                        rispostaData.put("domanda", domanda);
                                        rispostaData.put("corretta", corretta);
                                        rispostaData.put("risposteUtente", risposteUtente);
                                        rispostaData.put("risposteGiuste", risposteGiuste);
                                        risposteList.add(rispostaData);
                                    }


                                %>

                                <br>

                                <div class="container-fluid" style="display: flex; justify-content: center; white-space: nowrap">
                                    <div class="row">
                                        <div class="col">
                                            <h6 class="text-primary">Totale domande: <%= risposteDate%></h6>
                                        </div>
                                        <div class="col">
                                            <h6 class="text-success">Risposte corrette: <%= risposteCorrette%> (<%= percentuale%>%)</h6>
                                        </div>
                                        <div class="col">
                                            <h6 class="text-danger">Risposte errate: <%= risposteErrate%></h6>
                                        </div>
                                    </div>
                                </div>

                                <br>

                                <table class="table table-hover table-striped-columns table-bordered">
                                    <thead>
                                        <tr class="table-primary">
                                            <th>Domanda</th>
                                            <th>Risposta</th>
                                            <th style="white-space: nowrap">Risposta corretta</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Map<String, Object> rispostaData : risposteList) {
                                                String domanda = (String) rispostaData.get("domanda");
                                                boolean corretta = (Boolean) rispostaData.get("corretta");
                                                List<String> risposteUtente = (List<String>) rispostaData.get("risposteUtente");
                                                List<String> risposteGiuste = (List<String>) rispostaData.get("risposteGiuste");

                                                List<String> risposteUtentePulite = new ArrayList<>();
                                                for (String r : risposteUtente) {
                                                    risposteUtentePulite.add(r.replaceAll("<[^>]*>", "").trim());
                                                }

                                                List<String> risposteGiustePulite = new ArrayList<>();
                                                for (String r : risposteGiuste) {
                                                    risposteGiustePulite.add(r.replaceAll("<[^>]*>", "").trim());
                                                }
                                        %>
                                        <tr>
                                            <td><%= domanda%></td>

                                            <td class="<%= corretta ? "text-success" : "text-danger"%>" style="font-weight: bold;">
                                                <%= String.join(", ", risposteUtentePulite)%>
                                            </td>

                                            <% if (!corretta) {%>
                                            <td class="text-success" style="font-weight: bold;">
                                                ❌ <%= String.join(", ", risposteGiustePulite)%>
                                            </td>
                                            <% } else { %>
                                            <td class="text-success" style="font-weight: bold;">✅</td>
                                            <% } %>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <% } else if (utente_questionario
                == null || utente_questionario.getStatus()
                == 0 && utente_questionario.getDescrizione() == null) {%>


        <header class="it-header-wrapper">
            <div class="it-header-slim-wrapper">
                <div class="container-xxl">
                    <div class="row">
                        <div class="col-12">
                            <div class="it-header-slim-wrapper-content">
                                <a class="d-none d-lg-block navbar-brand" href="#">Ente appartenenza</a>
                                <div class="nav-mobile">
                                    <nav aria-label="Navigazione secondaria">
                                        <a class="it-opener d-lg-none" data-bs-toggle="collapse" href="#menuC1" role="button" aria-expanded="false" aria-controls="menuC1">
                                            <span>Ente appartenenza</span>
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-expand"></use></svg>
                                        </a>

                                    </nav>
                                </div>
                                <div class="it-header-slim-right-zone">
                                    <div class="it-access-top-wrapper">
                                        <a class="btn btn-primary btn-sm" onclick="logout()">ESCI</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="it-nav-wrapper">
                <div class="it-header-center-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <div class="it-header-center-content-wrapper">
                                    <div class="it-brand-wrapper">
                                        <a href="#">
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                            <div class="it-brand-text">
                                                <div class="it-brand-title">ENBAS</div>
                                                <div class="it-brand-tagline d-none d-md-block">QUESTIONARI DIGICOMP 2.2</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="it-right-zone">
                                        <div class="it-socials d-none d-md-flex">
                                            <span>Seguici su</span>
                                            <ul>
                                                <li>
                                                    <a href="#" aria-label="Facebook" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-facebook"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Github" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-github"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Twitter" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-twitter"></use></svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="it-header-navbar-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <!--start nav-->
                                <nav class="navbar navbar-expand-lg has-megamenu" aria-label="Navigazione principale">
                                    <button class="custom-navbar-toggler" type="button" aria-controls="navC1" aria-expanded="false" aria-label="Mostra/Nascondi la navigazione" data-bs-toggle="navbarcollapsible" data-bs-target="#navC1">
                                        <svg class="icon">
                                        <use href="dist/svg/sprites.svg#it-burger"></use>
                                        </svg>
                                    </button>
                                    <div class="navbar-collapsable" id="navC1" style="display: none;">
                                        <div class="overlay" style="display: none;"></div>
                                        <div class="close-div">
                                            <button class="btn close-menu" type="button">
                                                <span class="visually-hidden">Nascondi la navigazione</span>
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-close-big"></use>
                                                </svg>
                                            </button>
                                        </div>
                                        <div class="menu-wrapper">
                                            <ul class="navbar-nav">
                                                <li class="nav-item"><a class="nav-link" href="US_homepage.jsp" aria-current="page">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                                            Homepage
                                                        </span>
                                                    </a></li>
                                                <li class="nav-item active">
                                                    <a class="nav-link active" href="US_questionario.jsp">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-file"></use></svg>
                                                            Nuovo questionario
                                                        </span>
                                                        <span class="badge">

                                                            <% if (utente_questionario
                                                                        == null || utente_questionario.getStatus()
                                                                        == 0 && utente_questionario.getDescrizione() == null) {%>
                                                            <span class="badge bg" style="display: none">

                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 0 && utente_questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {%>
                                                            <span class="badge bg-danger">
                                                                Nuovo
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 1 && utente_questionario.getDescrizione().equals(Stato_questionario.PRESO_IN_CARICO) || utente_questionario.getStatus() == 2 && utente_questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE)) {%>
                                                            <span class="badge bg-warning">
                                                                Continua
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 3 && utente_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)) {%>
                                                            <span class="badge bg-success">
                                                                Completato
                                                            </span>
                                                            <% }%>
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item"><a class="nav-link" href="US_archivio.jsp"> <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-box"></use></svg>
                                                            Archivio
                                                        </span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <br>

        <div class="container">
            <h4 class="text-center">Questionario non trovato</h4>
            <br>

            <div class="row">
                <div class="col-12 col-lg-12">
                    <!--start card-->
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <h5 class="card-title h5 text-center">  Ciao <%= utente.getNome()%>!</h5>
                                <p class="card-text font-serif text-center">Questionario non trovato</p>
                                <hr>

                                <div class="container">

                                    <h5 class="text-danger text-center">Non è stato trovato un questionario a te assegnato. Torna indietro</h5>
                                    <br>

                                    <hr>
                                    <div class="container text-center">
                                        <button class="btn btn-primary" id="torna_homepage">
                                            Homepage
                                            <svg class="icon icon-white"> <use xlink:href="dist/svg/sprites.svg#it-pa"></use></svg>
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var button = document.getElementById('torna_homepage');
            button.addEventListener('click', function () {
            window.location.href = "US_homepage.jsp";
            });
        </script>

        <% } else if (utente_questionario.getStatus()
                == 0 && utente_questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {%>

        <br>

        <div class="container">
            <h4 class="text-center">Questionario trovato</h4>
            <br>

            <div class="row">
                <div class="col-12 col-lg-12">
                    <!--start card-->
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <h5 class="card-title h5 text-center">  Ciao <%= utente.getNome()%>!</h5>
                                <p class="card-text font-serif text-center">Questionario trovato</p>
                                <hr>

                                <div class="container">

                                    <h5 class="text-success text-center">E' stato trovato un questionario a te assegnato. Vuoi procedere con la compilazione?</h5>
                                    <br>

                                    <hr>
                                    <div class="container text-center">
                                        <button class="btn btn-primary" id="iniziaCompilazione">
                                            Inizia
                                            <svg class="icon icon-white"> <use xlink:href="dist/svg/sprites.svg#it-arrow-right-circle"></use></svg>
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script>
            var iniziaCompilazione = document.getElementById('iniziaCompilazione');
            iniziaCompilazione.addEventListener('click', function () {
            $.ajax({
            url: "QuestionarioServlet?iniziaQuestionario=true",
                    type: "POST",
                    success: function (response) {
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=001';
                    },
                    error: function (xhr, status, error) {
                    console.error(error);
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=001';
                    }
            });
            });
        </script>

        <% } else if (utente_questionario.getStatus()
                == 2 && utente_questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE)) {%>

        <div class="container-fluid text-center">
            <div id="surveyContainer"></div>

            <form action="QuestionarioServlet" method="POST" id="questionarioForm">
                <input type="hidden" name="userId" value="<%= userId%>">
                <input type="hidden" name="questionarioId" value="<%= questionarioId%>">
            </form>
        </div>

        <script type="text/babel">
            var surveyJSON = {
            "progressTitle": "Progressi questionario",
                    "progressBarType": "questions",
                    "showProgressBar": "top",
                    "title": "Questionario di tipo - " + "<%= livello%>",
                    "pages": [
            <% int pageIndex = 0;
                for (Domanda domanda : domande) {
                    String titolo = domanda.getTitolo().trim();
                    Tipo_domanda tipo_domanda = domanda.getTipo_domanda();
                    StringBuilder pageJSON = new StringBuilder();
                    pageJSON.append("{");
                    pageJSON.append("\"title\": \"Domanda " + (pageIndex + 1) + "\",");

                    pageJSON.append("\"questions\": [");
                    StringBuilder questionJSON = new StringBuilder();
                    questionJSON.append("{");
                    questionJSON.append("\"title\": \"" + titolo + "\",");

                    questionJSON.append("\"isRequired\": true,");

                    if (domanda.getTipo_inserimento() != null && !domanda.getTipo_inserimento().equals(Tipo_inserimento.MANUALE)) {
                        String jsonDomanda = domanda.getRisposte();
                        JSONObject jsonObj = new JSONObject(jsonDomanda);

                        String tipo = jsonObj.getString("tipo_domanda").toLowerCase();
                        JSONArray risposteAutomatiche = jsonObj.getJSONArray("risposte");
                        JSONArray risposteCorrette = jsonObj.optJSONArray("risposte_corrette");

                        if (tipo.equals("domanda_scelta_multipla")) {
                            if (risposteCorrette != null && risposteCorrette.length() > 1) {
                                questionJSON.append("\"type\": \"checkbox\",");
                            } else {
                                questionJSON.append("\"type\": \"radiogroup\",");
                            }

                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [");

                            for (int i = 0; i < risposteAutomatiche.length(); i++) {
                                JSONObject r = risposteAutomatiche.getJSONObject(i);
                                String testo = r.getString("testo");
                                questionJSON.append("\"" + testo + "\"");
                                if (i != risposteAutomatiche.length() - 1) {
                                    questionJSON.append(",");
                                }
                            }

                            questionJSON.append("]");

                        } else if (tipo.equals("domanda_scala_valutazione")) {
                            questionJSON.append("\"type\": \"rating\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"minRateDescription\": \"Bassa\",");
                            questionJSON.append("\"maxRateDescription\": \"Alta\",");
                            questionJSON.append("\"rateValues\": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]");

                        } else if (tipo.equals("domanda_select")) {
                            questionJSON.append("\"type\": \"dropdown\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [");

                            for (int i = 0; i < risposteAutomatiche.length(); i++) {
                                JSONObject r = risposteAutomatiche.getJSONObject(i);
                                String testo = r.getString("testo").replace("\"", "\\\"").replaceAll("<[^>]*>", "");
                                questionJSON.append("\"" + testo + "\"");
                                if (i != risposteAutomatiche.length() - 1) {
                                    questionJSON.append(",");
                                }
                            }

                            questionJSON.append("]");

                        } else {
                            questionJSON.append("\"type\": \"text\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\"");
                        }

                    } else {
                        String opzioni = null;
                        if (domanda.getOpzioni() != null) {
                            opzioni = domanda.getOpzioni().trim();
                        }

                        if (tipo_domanda == Tipo_domanda.DOMANDA_APERTA) {
                            questionJSON.append("\"type\": \"text\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\"");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SCELTA_MULTIPLA) {
                            String[] listaOpzioni = opzioni.split(",");
                            Arrays.sort(listaOpzioni);
                            questionJSON.append("\"type\": \"radiogroup\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [\"" + String.join("\",\"", listaOpzioni) + "\"]");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SCALA_VALUTAZIONE) {
                            questionJSON.append("\"type\": \"rating\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"minRateDescription\": \"Bassa\",");
                            questionJSON.append("\"maxRateDescription\": \"Alta\",");
                            questionJSON.append("\"rateValues\": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SELECT) {
                            String[] listaOpzioni = opzioni.split(",");
                            Arrays.sort(listaOpzioni);
                            questionJSON.append("\"type\": \"dropdown\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [\"" + String.join("\",\"", listaOpzioni) + "\"]");
                        }
                    }

                    questionJSON.append("}");
                    pageJSON.append(questionJSON.toString());
                    pageJSON.append("]}");

                    if (domanda != domande.get(domande.size() - 1)) {
                        out.print(pageJSON.toString() + ",");
                    } else {
                        out.print(pageJSON.toString());
                    }

                    pageIndex++;
                }
            %>
                    ]
            };
            var progressiJSON = <%= progressi%>;
            var progressi = progressiJSON ? JSON.parse(progressiJSON) : null;
            var currentPageIndex = progressi ? parseInt(progressi.currentPage) : 0;
            var savedAnswers = progressi ? progressi.risposte : {};
            Survey.surveyLocalization.defaultLocale = "it";
            var survey = new Survey.Model(surveyJSON);
            if (currentPageIndex > 0) {
            survey.currentPageNo = currentPageIndex;
            }

            Object.keys(savedAnswers).forEach(function (questionName) {
            if (questionName !== 'currentPage' && questionName !== 'questionarioId' && questionName !== 'userId') {
            var question = survey.getQuestionByName(questionName);
            if (question) {
            question.value = savedAnswers[questionName];
            }
            }
            });
            Survey.Serializer.addProperty("survey", "progressTitle");
            class PercentageProgressBar extends SurveyUI.ReactSurveyElement {
            render() {
            return (
            <div className="sv-progressbar-percentage">
                <div className="sv-progressbar-percentage__title">
                    <span>{this.props.model.progressTitle}</span>
        </div>
        <div className="sv-progressbar-percentage__indicator">
        <div className="sv-progressbar-percentage__value-bar" style={{width: this.props.model.progressValue + "%"}}></div>
        </div>
        <div className="sv-progressbar-percentage__value">
        <span>{this.props.model.progressValue + "%"}</span>
    </div>
        </div>
                    );
            }
            }
            window.React = {createElement: SurveyUI.createElement};
            SurveyUI.ReactElementFactory.Instance.registerElement("sv-progressbar-percentage", props => {
            return React.createElement(PercentageProgressBar, props);
            });
            survey.addLayoutElement({
            id: "progressbar-percentage",
                    component: "sv-progressbar-percentage",
                    container: "contentTop",
                    data: survey
            });
            const Theme = {
            "themeName": "plain",
                    "colorPalette": "light",
                    "isPanelless": false,
                    "cssVariables": {
                    "--sjs-general-backcolor": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dark": "rgba(248, 248, 248, 1)",
                            "--sjs-general-backcolor-dim": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dim-light": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dim-dark": "rgba(243, 243, 243, 1)",
                            "--sjs-general-forecolor": "rgba(0, 0, 0, 0.91)",
                            "--sjs-general-forecolor-light": "rgba(0, 0, 0, 0.45)",
                            "--sjs-general-dim-forecolor": "rgba(0, 0, 0, 0.91)",
                            "--sjs-general-dim-forecolor-light": "rgba(0, 0, 0, 0.45)",
                            "--sjs-primary-backcolor": "rgba(37, 137, 229, 1)",
                            "--sjs-primary-backcolor-light": "rgba(37, 137, 229, 0.1)",
                            "--sjs-primary-backcolor-dark": "rgba(21, 119, 209, 1)",
                            "--sjs-primary-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-primary-forecolor-light": "rgba(255, 255, 255, 0.25)",
                            "--sjs-base-unit": "8px",
                            "--sjs-corner-radius": "4px",
                            "--sjs-secondary-backcolor": "rgba(255, 152, 20, 1)",
                            "--sjs-secondary-backcolor-light": "rgba(255, 152, 20, 0.1)",
                            "--sjs-secondary-backcolor-semi-light": "rgba(255, 152, 20, 0.25)",
                            "--sjs-secondary-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-secondary-forecolor-light": "rgba(255, 255, 255, 0.25)",
                            "--sjs-shadow-small": "0px 0px 0px 1px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-small-reset": "0px 0px 0px 0px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-medium": "0px 0px 0px 1px rgba(0, 0, 0, 0.1)",
                            "--sjs-shadow-large": "0px 8px 16px 0px rgba(0, 0, 0, 0.05)",
                            "--sjs-shadow-inner": "0px 0px 0px 1px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-inner-reset": "0px 0px 0px 0px rgba(0, 0, 0, 0.15)",
                            "--sjs-border-light": "rgba(0, 0, 0, 0.15)",
                            "--sjs-border-default": "rgba(0, 0, 0, 0.15)",
                            "--sjs-border-inside": "rgba(0, 0, 0, 0.16)",
                            "--sjs-special-red": "rgba(229, 10, 62, 1)",
                            "--sjs-special-red-light": "rgba(229, 10, 62, 0.1)",
                            "--sjs-special-red-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-green": "rgba(25, 179, 148, 1)",
                            "--sjs-special-green-light": "rgba(25, 179, 148, 0.1)",
                            "--sjs-special-green-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-blue": "rgba(67, 127, 217, 1)",
                            "--sjs-special-blue-light": "rgba(67, 127, 217, 0.1)",
                            "--sjs-special-blue-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-yellow": "rgba(255, 152, 20, 1)",
                            "--sjs-special-yellow-light": "rgba(255, 152, 20, 0.1)",
                            "--sjs-special-yellow-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-article-font-xx-large-textDecoration": "none",
                            "--sjs-article-font-xx-large-fontWeight": "700",
                            "--sjs-article-font-xx-large-fontStyle": "normal",
                            "--sjs-article-font-xx-large-fontStretch": "normal",
                            "--sjs-article-font-xx-large-letterSpacing": "0",
                            "--sjs-article-font-xx-large-lineHeight": "64px",
                            "--sjs-article-font-xx-large-paragraphIndent": "0px",
                            "--sjs-article-font-xx-large-textCase": "none",
                            "--sjs-article-font-x-large-textDecoration": "none",
                            "--sjs-article-font-x-large-fontWeight": "700",
                            "--sjs-article-font-x-large-fontStyle": "normal",
                            "--sjs-article-font-x-large-fontStretch": "normal",
                            "--sjs-article-font-x-large-letterSpacing": "0",
                            "--sjs-article-font-x-large-lineHeight": "56px",
                            "--sjs-article-font-x-large-paragraphIndent": "0px",
                            "--sjs-article-font-x-large-textCase": "none",
                            "--sjs-article-font-large-textDecoration": "none",
                            "--sjs-article-font-large-fontWeight": "700",
                            "--sjs-article-font-large-fontStyle": "normal",
                            "--sjs-article-font-large-fontStretch": "normal",
                            "--sjs-article-font-large-letterSpacing": "0",
                            "--sjs-article-font-large-lineHeight": "40px",
                            "--sjs-article-font-large-paragraphIndent": "0px",
                            "--sjs-article-font-large-textCase": "none",
                            "--sjs-article-font-medium-textDecoration": "none",
                            "--sjs-article-font-medium-fontWeight": "700",
                            "--sjs-article-font-medium-fontStyle": "normal",
                            "--sjs-article-font-medium-fontStretch": "normal",
                            "--sjs-article-font-medium-letterSpacing": "0",
                            "--sjs-article-font-medium-lineHeight": "32px",
                            "--sjs-article-font-medium-paragraphIndent": "0px",
                            "--sjs-article-font-medium-textCase": "none",
                            "--sjs-article-font-default-textDecoration": "none",
                            "--sjs-article-font-default-fontWeight": "400",
                            "--sjs-article-font-default-fontStyle": "normal",
                            "--sjs-article-font-default-fontStretch": "normal",
                            "--sjs-article-font-default-letterSpacing": "0",
                            "--sjs-article-font-default-lineHeight": "28px",
                            "--sjs-article-font-default-paragraphIndent": "0px",
                            "--sjs-article-font-default-textCase": "none"
                    }
            };
            survey.applyTheme(Theme);
            survey.onComplete.add((sender, options) => {
            submitSurvey();
            });
            const converter = markdownit({
            html: true // Support HTML tags in the source (unsafe, see documentation)
            });
            survey.onTextMarkdown.add((_, options) => {
            // Convert Markdown to HTML
            let str = converter.renderInline(options.text);
            // ...
            // Sanitize the HTML markup using a third-party library here
            // ...
            // Set HTML markup to render
            options.html = str;
            });
            survey.onCurrentPageChanged.add(function(sender, options) {
            if (sender.currentPageNo === sender.pages.length - 1) {
            $("#sv-nav-save-progress").hide();
            } else {
            $("#sv-nav-save-progress").show();
            }
            });
            survey.render(document.getElementById("surveyContainer"));
            function submitSurvey() {
            var surveyData = survey.data;
            var formData = new FormData();
            formData.append("userId", "<%= userId%>");
            formData.append("questionarioId", "<%= questionarioId%>");
            Object.keys(surveyData).forEach(function (key) {
            var value = surveyData[key];
            var paramName = "risposta_" + key.split("_")[1];
            if (Array.isArray(value)) {
            value.forEach(function (val) {
            formData.append(paramName, val);
            });
            } else {
            formData.append(paramName, value);
            }
            });
            $.ajax({
            url: "QuestionarioServlet",
                    type: "POST",
                    data: JSON.stringify(surveyData),
                    contentType: "application/json",
                    success: function (response) {
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=003';
                    },
                    error: function (xhr, status, error) {
                    console.error(error);
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=003';
                    }
            });
            }

            $("#questionarioForm").on("submit", function (e) {
            e.preventDefault();
            submitSurvey();
            });
            survey.addNavigationItem({
            id: "sv-nav-save-progress",
                    title: "Salva e continua in seguito",
                    action: function () {
                    var formData = {
                    "userId": "<%= userId%>",
                            "questionarioId": "<%= questionarioId%>",
                            "currentPage": survey.currentPageNo,
                            "risposte": survey.data
                    };
                    $.ajax({
                    url: "QuestionarioServlet?isContinueLater=true",
                            type: "POST",
                            data: JSON.stringify(formData),
                            contentType: "application/json",
                            success: function (response) {
                            window.location.href = 'US_questionario.jsp?esito=OK&codice=002';
                            },
                            error: function (xhr, status, error) {
                            console.error(error);
                            window.location.href = 'US_questionario.jsp?esito=KO&codice=002';
                            }
                    });
                    },
                    css: "nav-button",
                    innerCss: "sd-btn nav-input custom-button"
            });
        </script>


        <% } else {%>

        <div class="container-fluid text-center">
            <div id="surveyContainer"></div>

            <form action="QuestionarioServlet" method="POST" id="questionarioForm">
                <input type="hidden" name="userId" value="<%= userId%>">
                <input type="hidden" name="questionarioId" value="<%= questionarioId%>">
            </form>
        </div>


        <script type="text/babel">
            var surveyJSON = {
            "progressTitle": "Progressi questionario",
                    "progressBarType": "questions",
                    "showProgressBar": "top",
                    "title": "Questionario di tipo - " + "<%= livello%>",
                    "pages": [
            <% int pageIndex = 0;
                for (Domanda domanda : domande) {
                    String titolo = domanda.getTitolo().trim();
                    Tipo_domanda tipo_domanda = domanda.getTipo_domanda();
                    StringBuilder pageJSON = new StringBuilder();
                    pageJSON.append("{");
                    pageJSON.append("\"title\": \"Domanda " + (pageIndex + 1) + "\",");

                    pageJSON.append("\"questions\": [");
                    StringBuilder questionJSON = new StringBuilder();
                    questionJSON.append("{");
                    questionJSON.append("\"title\": \"" + titolo + "\",");

                    questionJSON.append("\"isRequired\": true,");

                    if (domanda.getTipo_inserimento() != null && !domanda.getTipo_inserimento().equals(Tipo_inserimento.MANUALE)) {
                        String jsonDomanda = domanda.getRisposte();
                        JSONObject jsonObj = new JSONObject(jsonDomanda);

                        String tipo = jsonObj.getString("tipo_domanda").toLowerCase();
                        JSONArray risposteAutomatiche = jsonObj.getJSONArray("risposte");
                        JSONArray risposteCorrette = jsonObj.optJSONArray("risposte_corrette");

                        if (tipo.equals("domanda_scelta_multipla")) {
                            if (risposteCorrette != null && risposteCorrette.length() > 1) {
                                questionJSON.append("\"type\": \"checkbox\",");
                            } else {
                                questionJSON.append("\"type\": \"radiogroup\",");
                            }

                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [");

                            for (int i = 0; i < risposteAutomatiche.length(); i++) {
                                JSONObject r = risposteAutomatiche.getJSONObject(i);
                                String testo = r.getString("testo");
                                questionJSON.append("\"" + testo + "\"");
                                if (i != risposteAutomatiche.length() - 1) {
                                    questionJSON.append(",");
                                }
                            }

                            questionJSON.append("]");

                        } else if (tipo.equals("domanda_scala_valutazione")) {
                            questionJSON.append("\"type\": \"rating\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"minRateDescription\": \"Bassa\",");
                            questionJSON.append("\"maxRateDescription\": \"Alta\",");
                            questionJSON.append("\"rateValues\": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]");

                        } else if (tipo.equals("domanda_select")) {
                            questionJSON.append("\"type\": \"dropdown\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [");

                            for (int i = 0; i < risposteAutomatiche.length(); i++) {
                                JSONObject r = risposteAutomatiche.getJSONObject(i);
                                String testo = r.getString("testo").replace("\"", "\\\"").replaceAll("<[^>]*>", "");
                                questionJSON.append("\"" + testo + "\"");
                                if (i != risposteAutomatiche.length() - 1) {
                                    questionJSON.append(",");
                                }
                            }

                            questionJSON.append("]");

                        } else {
                            questionJSON.append("\"type\": \"text\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\"");
                        }

                    } else {
                        String opzioni = null;
                        if (domanda.getOpzioni() != null) {
                            opzioni = domanda.getOpzioni().trim();
                        }

                        if (tipo_domanda == Tipo_domanda.DOMANDA_APERTA) {
                            questionJSON.append("\"type\": \"text\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\"");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SCELTA_MULTIPLA) {
                            String[] listaOpzioni = opzioni.split(",");
                            Arrays.sort(listaOpzioni);
                            questionJSON.append("\"type\": \"radiogroup\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [\"" + String.join("\",\"", listaOpzioni) + "\"]");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SCALA_VALUTAZIONE) {
                            questionJSON.append("\"type\": \"rating\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"minRateDescription\": \"Bassa\",");
                            questionJSON.append("\"maxRateDescription\": \"Alta\",");
                            questionJSON.append("\"rateValues\": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]");
                        } else if (tipo_domanda == Tipo_domanda.DOMANDA_SELECT) {
                            String[] listaOpzioni = opzioni.split(",");
                            Arrays.sort(listaOpzioni);
                            questionJSON.append("\"type\": \"dropdown\",");
                            questionJSON.append("\"name\": \"risposta_" + domanda.getId() + "\",");
                            questionJSON.append("\"choices\": [\"" + String.join("\",\"", listaOpzioni) + "\"]");
                        }
                    }

                    questionJSON.append("}");
                    pageJSON.append(questionJSON.toString());
                    pageJSON.append("]}");

                    if (domanda != domande.get(domande.size() - 1)) {
                        out.print(pageJSON.toString() + ",");
                    } else {
                        out.print(pageJSON.toString());
                    }

                    pageIndex++;
                }
            %>
                    ]
            };
            var progressiJSON = <%= progressi%>;
            var progressi = progressiJSON ? JSON.parse(progressiJSON) : null;
            var currentPageIndex = progressi ? parseInt(progressi.currentPage) : 0;
            var savedAnswers = progressi ? progressi.risposte : {};
            Survey.surveyLocalization.defaultLocale = "it";
            var survey = new Survey.Model(surveyJSON);
            if (currentPageIndex > 0) {
            survey.currentPageNo = currentPageIndex;
            }

            Object.keys(savedAnswers).forEach(function (questionName) {
            if (questionName !== 'currentPage' && questionName !== 'questionarioId' && questionName !== 'userId') {
            var question = survey.getQuestionByName(questionName);
            if (question) {
            question.value = savedAnswers[questionName];
            }
            }
            });
            Survey.Serializer.addProperty("survey", "progressTitle");
            class PercentageProgressBar extends SurveyUI.ReactSurveyElement {
            render() {
            return (
                    <div className="sv-progressbar-percentage">
                                                            <div className="sv-progressbar-percentage__title">
                                                            <span>{this.props.model.progressTitle}</span>
                                                    </div>
                                                <div className="sv-progressbar-percentage__indicator">
                    <div className="sv-progressbar-percentage__value-bar" style={{width: this.props.model.progressValue + "%"}}></div>
                </div>
                <div className="sv-progressbar-percentage__value">
                    <span>{this.props.model.progressValue + "%"}</span>
                                            </div>
                                        </div>
                    );
            }
            }
            window.React = {createElement: SurveyUI.createElement};
            SurveyUI.ReactElementFactory.Instance.registerElement("sv-progressbar-percentage", props => {
            return React.createElement(PercentageProgressBar, props);
            });
            survey.addLayoutElement({
            id: "progressbar-percentage",
                    component: "sv-progressbar-percentage",
                    container: "contentTop",
                    data: survey
            });
            const Theme = {
            "themeName": "plain",
                    "colorPalette": "light",
                    "isPanelless": false,
                    "cssVariables": {
                    "--sjs-general-backcolor": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dark": "rgba(248, 248, 248, 1)",
                            "--sjs-general-backcolor-dim": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dim-light": "rgba(255, 255, 255, 1)",
                            "--sjs-general-backcolor-dim-dark": "rgba(243, 243, 243, 1)",
                            "--sjs-general-forecolor": "rgba(0, 0, 0, 0.91)",
                            "--sjs-general-forecolor-light": "rgba(0, 0, 0, 0.45)",
                            "--sjs-general-dim-forecolor": "rgba(0, 0, 0, 0.91)",
                            "--sjs-general-dim-forecolor-light": "rgba(0, 0, 0, 0.45)",
                            "--sjs-primary-backcolor": "rgba(37, 137, 229, 1)",
                            "--sjs-primary-backcolor-light": "rgba(37, 137, 229, 0.1)",
                            "--sjs-primary-backcolor-dark": "rgba(21, 119, 209, 1)",
                            "--sjs-primary-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-primary-forecolor-light": "rgba(255, 255, 255, 0.25)",
                            "--sjs-base-unit": "8px",
                            "--sjs-corner-radius": "4px",
                            "--sjs-secondary-backcolor": "rgba(255, 152, 20, 1)",
                            "--sjs-secondary-backcolor-light": "rgba(255, 152, 20, 0.1)",
                            "--sjs-secondary-backcolor-semi-light": "rgba(255, 152, 20, 0.25)",
                            "--sjs-secondary-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-secondary-forecolor-light": "rgba(255, 255, 255, 0.25)",
                            "--sjs-shadow-small": "0px 0px 0px 1px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-small-reset": "0px 0px 0px 0px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-medium": "0px 0px 0px 1px rgba(0, 0, 0, 0.1)",
                            "--sjs-shadow-large": "0px 8px 16px 0px rgba(0, 0, 0, 0.05)",
                            "--sjs-shadow-inner": "0px 0px 0px 1px rgba(0, 0, 0, 0.15)",
                            "--sjs-shadow-inner-reset": "0px 0px 0px 0px rgba(0, 0, 0, 0.15)",
                            "--sjs-border-light": "rgba(0, 0, 0, 0.15)",
                            "--sjs-border-default": "rgba(0, 0, 0, 0.15)",
                            "--sjs-border-inside": "rgba(0, 0, 0, 0.16)",
                            "--sjs-special-red": "rgba(229, 10, 62, 1)",
                            "--sjs-special-red-light": "rgba(229, 10, 62, 0.1)",
                            "--sjs-special-red-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-green": "rgba(25, 179, 148, 1)",
                            "--sjs-special-green-light": "rgba(25, 179, 148, 0.1)",
                            "--sjs-special-green-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-blue": "rgba(67, 127, 217, 1)",
                            "--sjs-special-blue-light": "rgba(67, 127, 217, 0.1)",
                            "--sjs-special-blue-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-special-yellow": "rgba(255, 152, 20, 1)",
                            "--sjs-special-yellow-light": "rgba(255, 152, 20, 0.1)",
                            "--sjs-special-yellow-forecolor": "rgba(255, 255, 255, 1)",
                            "--sjs-article-font-xx-large-textDecoration": "none",
                            "--sjs-article-font-xx-large-fontWeight": "700",
                            "--sjs-article-font-xx-large-fontStyle": "normal",
                            "--sjs-article-font-xx-large-fontStretch": "normal",
                            "--sjs-article-font-xx-large-letterSpacing": "0",
                            "--sjs-article-font-xx-large-lineHeight": "64px",
                            "--sjs-article-font-xx-large-paragraphIndent": "0px",
                            "--sjs-article-font-xx-large-textCase": "none",
                            "--sjs-article-font-x-large-textDecoration": "none",
                            "--sjs-article-font-x-large-fontWeight": "700",
                            "--sjs-article-font-x-large-fontStyle": "normal",
                            "--sjs-article-font-x-large-fontStretch": "normal",
                            "--sjs-article-font-x-large-letterSpacing": "0",
                            "--sjs-article-font-x-large-lineHeight": "56px",
                            "--sjs-article-font-x-large-paragraphIndent": "0px",
                            "--sjs-article-font-x-large-textCase": "none",
                            "--sjs-article-font-large-textDecoration": "none",
                            "--sjs-article-font-large-fontWeight": "700",
                            "--sjs-article-font-large-fontStyle": "normal",
                            "--sjs-article-font-large-fontStretch": "normal",
                            "--sjs-article-font-large-letterSpacing": "0",
                            "--sjs-article-font-large-lineHeight": "40px",
                            "--sjs-article-font-large-paragraphIndent": "0px",
                            "--sjs-article-font-large-textCase": "none",
                            "--sjs-article-font-medium-textDecoration": "none",
                            "--sjs-article-font-medium-fontWeight": "700",
                            "--sjs-article-font-medium-fontStyle": "normal",
                            "--sjs-article-font-medium-fontStretch": "normal",
                            "--sjs-article-font-medium-letterSpacing": "0",
                            "--sjs-article-font-medium-lineHeight": "32px",
                            "--sjs-article-font-medium-paragraphIndent": "0px",
                            "--sjs-article-font-medium-textCase": "none",
                            "--sjs-article-font-default-textDecoration": "none",
                            "--sjs-article-font-default-fontWeight": "400",
                            "--sjs-article-font-default-fontStyle": "normal",
                            "--sjs-article-font-default-fontStretch": "normal",
                            "--sjs-article-font-default-letterSpacing": "0",
                            "--sjs-article-font-default-lineHeight": "28px",
                            "--sjs-article-font-default-paragraphIndent": "0px",
                            "--sjs-article-font-default-textCase": "none"
                    }
            };
            survey.applyTheme(Theme);
            survey.onComplete.add((sender, options) => {
            submitSurvey();
            });
            const converter = markdownit({
            html: true // Support HTML tags in the source (unsafe, see documentation)
            });
            survey.onTextMarkdown.add((_, options) => {
            // Convert Markdown to HTML
            let str = converter.renderInline(options.text);
            // ...
            // Sanitize the HTML markup using a third-party library here
            // ...
            // Set HTML markup to render
            options.html = str;
            });
            survey.onCurrentPageChanged.add(function(sender, options) {
            if (sender.currentPageNo === sender.pages.length - 1) {
            $("#sv-nav-save-progress").hide();
            } else {
            $("#sv-nav-save-progress").show();
            }
            });
            survey.render(document.getElementById("surveyContainer"));
            function submitSurvey() {
            var surveyData = survey.data;
            var formData = new FormData();
            formData.append("userId", "<%= userId%>");
            formData.append("questionarioId", "<%= questionarioId%>");
            Object.keys(surveyData).forEach(function (key) {
            var value = surveyData[key];
            var paramName = "risposta_" + key.split("_")[1];
            if (Array.isArray(value)) {
            value.forEach(function (val) {
            formData.append(paramName, val);
            });
            } else {
            formData.append(paramName, value);
            }
            });
            $.ajax({
            url: "QuestionarioServlet",
                    type: "POST",
                    data: JSON.stringify(surveyData),
                    contentType: "application/json",
                    success: function (response) {
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=003';
                    },
                    error: function (xhr, status, error) {
                    console.error(error);
                    window.location.href = 'US_questionario.jsp?esito=OK&codice=003';
                    }
            });
            }

            $("#questionarioForm").on("submit", function (e) {
            e.preventDefault();
            submitSurvey();
            });
            survey.addNavigationItem({
            id: "sv-nav-save-progress",
                    title: "Salva e continua in seguito",
                    action: function () {
                    var formData = {
                    "userId": "<%= userId%>",
                            "questionarioId": "<%= questionarioId%>",
                            "currentPage": survey.currentPageNo,
                            "risposte": survey.data
                    };
                    $.ajax({
                    url: "QuestionarioServlet?isContinueLater=true",
                            type: "POST",
                            data: JSON.stringify(formData),
                            contentType: "application/json",
                            success: function (response) {
                            window.location.href = 'US_questionario.jsp?esito=OK&codice=002';
                            },
                            error: function (xhr, status, error) {
                            console.error(error);
                            window.location.href = 'US_questionario.jsp?esito=KO&codice=002';
                            }
                    });
                    },
                    css: "nav-button",
                    innerCss: "sd-btn nav-input custom-button"
            });
        </script>

        <% }

        } else {

        %>


        <header class="it-header-wrapper">
            <div class="it-header-slim-wrapper">
                <div class="container-xxl">
                    <div class="row">
                        <div class="col-12">
                            <div class="it-header-slim-wrapper-content">
                                <a class="d-none d-lg-block navbar-brand" href="#">Ente appartenenza</a>
                                <div class="nav-mobile">
                                    <nav aria-label="Navigazione secondaria">
                                        <a class="it-opener d-lg-none" data-bs-toggle="collapse" href="#menuC1" role="button" aria-expanded="false" aria-controls="menuC1">
                                            <span>Ente appartenenza</span>
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-expand"></use></svg>
                                        </a>

                                    </nav>
                                </div>
                                <div class="it-header-slim-right-zone">
                                    <div class="it-access-top-wrapper">
                                        <a class="btn btn-primary btn-sm" onclick="logout()">ESCI</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="it-nav-wrapper">
                <div class="it-header-center-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <div class="it-header-center-content-wrapper">
                                    <div class="it-brand-wrapper">
                                        <a href="#">
                                            <svg class="icon" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                            <div class="it-brand-text">
                                                <div class="it-brand-title">ENBAS</div>
                                                <div class="it-brand-tagline d-none d-md-block">QUESTIONARI DIGICOMP 2.2</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="it-right-zone">
                                        <div class="it-socials d-none d-md-flex">
                                            <span>Seguici su</span>
                                            <ul>
                                                <li>
                                                    <a href="#" aria-label="Facebook" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-facebook"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Github" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-github"></use></svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" aria-label="Twitter" target="_blank">
                                                        <svg class="icon"><use href="dist/svg/sprites.svg#it-twitter"></use></svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="it-header-navbar-wrapper">
                    <div class="container-xxl">
                        <div class="row">
                            <div class="col-12">
                                <!--start nav-->
                                <nav class="navbar navbar-expand-lg has-megamenu" aria-label="Navigazione principale">
                                    <button class="custom-navbar-toggler" type="button" aria-controls="navC1" aria-expanded="false" aria-label="Mostra/Nascondi la navigazione" data-bs-toggle="navbarcollapsible" data-bs-target="#navC1">
                                        <svg class="icon">
                                        <use href="dist/svg/sprites.svg#it-burger"></use>
                                        </svg>
                                    </button>
                                    <div class="navbar-collapsable" id="navC1" style="display: none;">
                                        <div class="overlay" style="display: none;"></div>
                                        <div class="close-div">
                                            <button class="btn close-menu" type="button">
                                                <span class="visually-hidden">Nascondi la navigazione</span>
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-close-big"></use>
                                                </svg>
                                            </button>
                                        </div>
                                        <div class="menu-wrapper">
                                            <ul class="navbar-nav">
                                                <li class="nav-item"><a class="nav-link" href="US_homepage.jsp" aria-current="page">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                                            Homepage
                                                        </span>
                                                    </a></li>
                                                <li class="nav-item active">
                                                    <a class="nav-link active" href="US_questionario.jsp">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-file"></use></svg>
                                                            Nuovo questionario
                                                        </span>
                                                        <span class="badge">

                                                            <%                                                                Questionario utente_questionario = jPAUtil.findUtenteQuestionarioIdByUserId(utente.getId());
                                                            %>

                                                            <% if (utente_questionario
                                                                        == null || utente_questionario.getStatus()
                                                                        == 0 && utente_questionario.getDescrizione() == null) {%>
                                                            <span class="badge bg" style="display: none">

                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 0 && utente_questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {%>
                                                            <span class="badge bg-danger">
                                                                Nuovo
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 1 && utente_questionario.getDescrizione().equals(Stato_questionario.PRESO_IN_CARICO) || utente_questionario.getStatus() == 2 && utente_questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE)) {%>
                                                            <span class="badge bg-warning">
                                                                Continua
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus()
                                                                    == 3 && utente_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)) {%>
                                                            <span class="badge bg-success">
                                                                Completato
                                                            </span>
                                                            <% }%>
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item"><a class="nav-link" href="US_archivio.jsp"> <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-box"></use></svg>
                                                            Archivio
                                                        </span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <br>

        <div class="container">
            <h4 class="text-center">Questionario non trovato</h4>
            <br>

            <div class="row">
                <div class="col-12 col-lg-12">
                    <!--start card-->
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <h5 class="card-title h5 text-center">  Ciao <%= utente.getNome()%>!</h5>
                                <p class="card-text font-serif text-center">Questionario non trovato</p>
                                <hr>

                                <div class="container">

                                    <h5 class="text-danger text-center">Non è stato trovato un questionario a te assegnato. Torna indietro</h5>
                                    <br>

                                    <hr>
                                    <div class="container text-center">
                                        <button class="btn btn-primary" id="torna_homepage">
                                            Homepage
                                            <svg class="icon icon-white"> <use xlink:href="dist/svg/sprites.svg#it-pa"></use></svg>
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var button = document.getElementById('torna_homepage');
            button.addEventListener('click', function () {
            window.location.href = "US_homepage.jsp";
            });</script>


        <%}%>

        <div class="modal fade"id="esitoModal" tabindex="-1" aria-labelledby="esitoModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header" id="modal-header">
                        <h5 class="modal-title" id="esitoModalLabel">Esito Operazione</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="esitoModalBody">

                    </div>
                    <div class="modal-footer">
                        <button type="button" id="esitoModalButton" class="btn" data-bs-dismiss="modal">Chiudi</button>
                    </div>
                </div>
            </div>
        </div>


        <script src="dist/assets/js/bootstrap-italia.bundle.min.js"></script>
        <script src="dist/assets/js/custom/globalModal.js"></script>


        <br>
        <br>
        <br>


        <footer class="it-footer">
            <div class="it-footer-main">
                <div class="container">
                    <section>
                        <div class="row clearfix">
                            <div class="col-sm-12">
                                <div class="it-brand-wrapper">
                                    <a href="#" data-focus-mouse="false">
                                        <!--                                        <svg class="icon"><use xlink:href="dist/svg/sprites.svg#it-code-circle"></use></svg>-->
                                        <div class="it-brand-text">
                                            <h2></h2>
                                            <h3 class="d-none d-md-block"></h3>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>
                    <section class="py-4">
                        <div class="row">
                            <div class="col-lg-4 col-md-4 pb-2">
                                <h4></h4>
                                <p>
                                    <strong></strong><br>
                                </p>
                                <div class="link-list-wrapper">
                                    <ul class="footer-list link-list clearfix">
                                        <li><a class="list-item" href="#"></a></li>
                                        <li>
                                            <a class="list-item" href="#"></a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-lg-4 col-md-4 pb-2">
                                <h4></h4>
                            </div>
                            <div class="col-lg-4 col-md-4 pb-2">
                                <div class="pb-2">
                                    <!--                                    <h4>Seguici su</h4>
                                                                        <ul class="list-inline text-left social">
                                                                            <li class="list-inline-item">
                                                                                <a class="p-2 text-white" href="#"><svg class="icon icon-sm icon-white align-top"><use xlink:href="dist/svg/sprites.svg#it-designers-italia"></use></svg><span class="visually-hidden">Designers Italia (link esterno)</span></a>
                                                                            </li>
                                                                            <li class="list-inline-item">
                                                                                <a class="p-2 text-white" href="#"><svg class="icon icon-sm icon-white align-top"><use xlink:href="dist/svg/sprites.svg#it-twitter"></use></svg><span class="visually-hidden">X (link esterno)</span></a>
                                                                            </li>
                                                                            <li class="list-inline-item">
                                                                                <a class="p-2 text-white" href="#"><svg class="icon icon-sm icon-white align-top"><use xlink:href="dist/svg/sprites.svg#it-medium"></use></svg><span class="visually-hidden">Medium (link esterno)</span></a>
                                                                            </li>
                                                                            <li class="list-inline-item">
                                                                                <a class="p-2 text-white" href="#"><svg class="icon icon-sm icon-white align-top"><use xlink:href="dist/svg/sprites.svg#it-behance"></use></svg><span class="visually-hidden">Behance (link esterno)</span></a>
                                                                            </li>
                                                                        </ul>-->
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
            <div class="it-footer-small-prints clearfix">
                <div class="container">
                    <!-- <h3 class="visually-hidden">Sezione Link Utili</h3> -->
                    <ul class="it-footer-small-prints-list list-inline mb-0 d-flex flex-column flex-md-row">
                        <li class="list-inline-item"><a href="#"></a></li>
                        <li class="list-inline-item"><a href="#"></a></li>
                        <li class="list-inline-item"><a href="#"></a></li>
                        <li class="list-inline-item"><a href="#"></a></li>
                        <li class="list-inline-item"><a href="https://form.agid.gov.it/view/xyz"><span class="visually-hidden"></span></a></li>
                    </ul>
                </div>
            </div>
        </footer>
        <script src="dist/assets/js/custom/logout.js"></script>
    </body>
</html>
