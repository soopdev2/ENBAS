<%-- 
    Document   : AD_assegna_questionario
    Created on : 21 gen 2025, 11:07:54
    Author     : Salvatore
--%>

<%@page import="Utils.JPAUtil"%>
<%@page import="Entity.ModelloPredefinito"%>
<%@page import="Entity.Digicomp"%>
<%@page import="Entity.Categoria"%>
<%@page import="Entity.Questionario"%>
<%@page import="Utils.Utils"%>
<%@page import="java.util.List"%>
<%@page import="Entity.Utente"%>
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
<html>
    <head>
        <title>Assegna questionario</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" type="image/png" href="dist/img/favicon/favicon-96x96.png" sizes="96x96" />
        <link rel="icon" type="image/svg+xml" href="dist/img/favicon/favicon.svg" />
        <link rel="shortcut icon" href="dist/img/favicon/favicon.ico" />
        <link rel="apple-touch-icon" sizes="180x180" href="dist/img/favicon/apple-touch-icon.png" />
        <link rel="stylesheet" href="dist/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="dist/assets/css/custom/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium Web' rel='stylesheet'>
        <link rel="stylesheet" href="dist/assets/css/external/select2.min.css" />
        <link rel="stylesheet" href="dist/assets/css/external/select2-bootstrap-5-theme.min.css" />
    </head>
    <body>
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
                                                <li class="nav-item"><a class="nav-link" href="AD_homepage.jsp" aria-current="page"><span>
                                                            <svg class="icon icon-white align-bottom" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                                            Homepage
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link active" href="AD_assegna_questionario.jsp">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-plus"></use></svg>
                                                            Assegna questionario
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item dropdown">
                                                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" id="mainNavDropdown1">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-help"></use></svg>
                                                            Gestione domande
                                                        </span>
                                                        <svg class="icon icon-xs"><use href="dist/svg/sprites.svg#it-expand"></use></svg>
                                                    </a>
                                                    <div class="dropdown-menu" role="region" aria-labelledby="mainNavDropdown1">
                                                        <div class="link-list-wrapper">
                                                            <ul class="link-list">
                                                                <li><a class="dropdown-item list-item"  href="AD_gestione_domande.jsp">
                                                                        <span>
                                                                            <svg class="icon icon-sm align-bottom" style="margin-right: 5px"><use href="dist/svg/sprites.svg#it-list"></use></svg>
                                                                            Visualizza domande
                                                                        </span>
                                                                    </a>
                                                                </li>
                                                                <li><span class="divider"></span></li>

                                                                <li><a class="dropdown-item list-item" href="AD_crea_domanda.jsp">
                                                                        <span>
                                                                            <svg class="icon icon-sm align-bottom" style="margin-right: 5px"><use href="dist/svg/sprites.svg#it-plus"></use></svg>
                                                                            Creazione domande
                                                                        </span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </li>
                                                <li class="nav-item"><a class="nav-link" href="AD_archivio.jsp"><span> <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-box"></use></svg>
                                                            Archivio
                                                        </span></a></li>
                                                <li class="nav-item"><a class="nav-link" href="AD_statistiche.jsp"><span> <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-chart-line"></use></svg>
                                                            Statistiche
                                                        </span></a></li>
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
            <h4 class="text-center">Assegna questionario</h4>
            <br>

            <div class="row">
                <div class="col-12 col-lg-12">
                    <!--start card-->
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <h5 class="card-title h5 text-center">Assegna questionario</h5>
                                <p class="card-text font-serif text-center">Assegna ad uno o più utenti un questionario.</p>
                                <hr>

                                <div class="container">

                                    <form action="QuestionarioServlet" method="POST">
                                        <input type="hidden" name="isSet" value="true">

                                        <div class="container">
                                            <label class="form-label">
                                                Seleziona uno o più utenti
                                            </label>
                                            <select class="select" multiple name="assegna_questionario_select_utente" id="assegna_questionario_select_utente">
                                                <%                                                    JPAUtil jPAUtil = new JPAUtil();
                                                    List<Utente> utenti = jPAUtil.findAllUtenti();
                                                    for (Utente u : utenti) {
                                                %>
                                                <option value="<%= u.getId()%>"><%= u.getNome()%></option>
                                                <% } %>
                                            </select>

                                            <br><br>

                                            <label class="form-label">
                                                Seleziona modalità
                                            </label>
                                            <select class="select" name="modalita" id="modalitaSelect">
                                                <option value="questionario">Questionario</option>
                                                <option value="categoria">Categoria</option>
                                                <option value="digicomp">Digicomp</option>
                                            </select>

                                            <br><br>

                                            <div id="questionarioContainer">
                                                <label class="form-label">
                                                    Seleziona questionario
                                                </label>
                                                <select class="select" name="assegna_questionario_select_questionario" id="assegna_questionario_select_questionario">
                                                    <%

                                                        List<ModelloPredefinito> modelliPredefiniti = jPAUtil.findAllModelliPredefiniti();
                                                        for (ModelloPredefinito mp : modelliPredefiniti) {
                                                    %>
                                                    <option value="<%= mp.getId()%>"><%= mp.getDescrizione()%></option>
                                                    <% } %>
                                                </select>
                                            </div>

                                            <div id="categoriaContainer" style="display:none;">
                                                <label class="form-label">
                                                    Seleziona categoria
                                                </label>
                                                <select class="select" name="assegna_questionario_select_categoria" id="assegna_questionario_select_categoria">
                                                    <%
                                                        List<Categoria> categoria = jPAUtil.findAllCategorie();
                                                        for (Categoria c : categoria) {
                                                    %>
                                                    <option value="<%= c.getId()%>"><%= c.getNome()%></option>
                                                    <% } %>
                                                </select>

                                                <br><br>

                                                <%
                                                    int min = Utils.tryParseInt(Utils.config.getString("min"));
                                                    int max = Utils.tryParseInt(Utils.config.getString("max"));
                                                %>

                                                <label class="form-label">
                                                    Seleziona numero domande ( min - <%= min%> -  max - <%=max%>)
                                                </label>

                                                <input type="number" class="form-control" id="numero_domande" name="numero_domande" pattern="[0-9]{2}" min="<%= min%>" max="<%= max%>" value="10">
                                            </div>

                                            <div id="digicompContainer">
                                                <label class="form-label">
                                                    Seleziona digicomp
                                                </label>
                                                <select class="select" name="assegna_questionario_select_digicomp" id="assegna_questionario_select_digicomp">
                                                    <%
                                                        List<Digicomp> digicomp = jPAUtil.findAllDigicomp();
                                                        for (Digicomp d : digicomp) {
                                                    %>
                                                    <option value="<%= d.getId()%>"><%= d.getDescrizione()%></option>
                                                    <% }%>
                                                </select>
                                            </div>

                                        </div>
                                        <br>

                                        <div class="container text-center">
                                            <button class="btn btn-primary" type="submit">Assegna</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

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

        <div class="modal fade" id="esitoModal" tabindex="-1" aria-labelledby="esitoModalLabel" aria-hidden="false">
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
        <!-- Scripts -->
        <script src="dist/assets/js/external/jquery-3.7.1.js"></script>
        <script src="dist/assets/js/external/select2.min.js"></script>
        <script>
                                            $('#assegna_questionario_select_utente').select2({
                                                theme: 'bootstrap-5',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                            });
                                            $('#assegna_questionario_select_questionario').select2({
                                                theme: 'bootstrap-5',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                            });
                                            $('#assegna_questionario_select_categoria').select2({
                                                theme: 'bootstrap-5',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                            });
                                            $('#assegna_questionario_select_digicomp').select2({
                                                theme: 'bootstrap-5',
                                                width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                            });

        </script>

        <script>
            $(document).ready(function () {
                $('.select').select2({
                    theme: 'bootstrap-5',
                    width: function () {
                        return $(this).data('width') ? $(this).data('width') : ($(this).hasClass('w-100') ? '100%' : 'style');
                    }
                });

                function aggiornaVisibilita() {
                    var modalita = $('#modalitaSelect').val();

                    if (modalita === "questionario") {
                        $('#questionarioContainer').show();
                        $('#categoriaContainer').hide();
                        $('#digicompContainer').hide();
                        $('#assegna_questionario_select_questionario').prop('disabled', false);
                        $('#assegna_questionario_select_categoria').prop('disabled', true);
                        $('#assegna_questionario_select_digicomp').prop('disabled', true);
                        $('#numero_domande').prop('disabled', true);
                    } else if (modalita === "categoria") {
                        $('#questionarioContainer').hide();
                        $('#categoriaContainer').show();
                        $('#digicompContainer').hide();
                        $('#assegna_questionario_select_questionario').prop('disabled', true);
                        $('#assegna_questionario_select_categoria').prop('disabled', false);
                        $('#assegna_questionario_select_digicomp').prop('disabled', true);
                        $('#numero_domande').prop('disabled', false);

                    } else if (modalita === "digicomp") {
                        $('#questionarioContainer').hide();
                        $('#categoriaContainer').hide();
                        $('#digicompContainer').show();
                        $('#assegna_questionario_select_questionario').prop('disabled', true);
                        $('#assegna_questionario_select_categoria').prop('disabled', true);
                        $('#assegna_questionario_select_digicomp').prop('disabled', false);
                    }
                }

                aggiornaVisibilita();

                $('#modalitaSelect').on('change', aggiornaVisibilita);
            });
        </script>

        <script src="dist/assets/js/custom/logout.js"></script>
    </body>
</html>

