<%-- 
    Document   : AD_statistiche
    Created on : 30 apr 2025, 09:30:13
    Author     : Salvatore
--%>

<%@page import="Utils.JPAUtil"%>
<%@page import="java.util.List"%>
<%@page import="Enum.Stato_questionario"%>
<%@page import="Utils.Utils"%>
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
        <title>Statistiche</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="dist/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="dist/assets/css/custom/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium Web' rel='stylesheet'>
        <link rel="stylesheet" href="dist/assets/css/external/dataTables.bootstrap5.css"/>
        <link rel="stylesheet" href="dist/assets/css/external/select2-bootstrap-5-theme.min.css"/>
        <link rel="stylesheet" href="dist/assets/css/external/select2.min.css"/>
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
                                                    <a class="nav-link" href="AD_assegna_questionario.jsp">
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
                                                <li class="nav-item active"><a class="nav-link active" href="AD_statistiche.jsp"><span> <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-chart-line"></use></svg>
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

        <br>

        <div class="container-fluid">
            <div class="card-wrapper">
                <div class="card card-bg mb-6">
                    <div class="card card-header text-center">
                        <br>
                        <h4 class="card-title" style="font-weight: normal">
                            Statistiche utenti
                        </h4>
                    </div>

                    <div class="container">
                        <div class="card">
                            <div class="card-body">
                                <div class="row w-100" style="display: flex; justify-content: center;">

                                    <label class="text-primary active" for="utente_select">Seleziona utente</label>
                                    <select name="utente_select" id="utente_select" class="form-control border">
                                        <option value="Tutti" selected>TUTTI</option>
                                        <%                                                JPAUtil jPAUtil = new JPAUtil();
                                            List<Utente> list_utenti = jPAUtil.findAllUtenti();
                                            for (Utente u : list_utenti) {
                                        %>
                                        <option value="<%= u.getId()%>"><%= u.getNome() + " " + u.getCognome()%></option>
                                        <%
                                            }
                                        %>
                                    </select>

                                </div>


                            </div>
                            <br>

                            <div data-datatable="true" data-datatable-page-size="5" data-datatable-state-save="true" id="utenti_table">
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped" id="utenti">
                                        <thead>
                                            <tr class="text-primary">
                                                <th>ID</th>
                                                <th>Nome</th>
                                                <th>Cognome</th>
                                                <th>Età</th>
                                                <th>Indirizzo</th>
                                                <th>Ruolo</th>
                                                <th>Azione</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                Mostra
                                <select class="form-select form-select-sm w-auto" id="pageSize" name="perpage">
                                    <option value="5">5</option>
                                    <option value="10">10</option>
                                    <option value="25">25</option>
                                </select>
                                per pagina
                            </div>
                            <div class="d-flex align-items-center gap-4">
                                <span id="datatable-info"></span>
                                <div class="pagination" id="datatable-pagination">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </div>

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
    <script src="dist/assets/js/external/jquery-3.7.1.js"></script>
    <script src="dist/assets/js/external/dataTables.js"></script>
    <script src="dist/assets/js/external/dataTables.bootstrap5.js"></script>
    <script src="dist/assets/js/external/date-eu.js"></script>
    <script src="dist/assets/js/external/select2.min.js"></script>

    <script src="dist/assets/js/custom/ad_statistiche.js"></script>
    <script src="dist/assets/js/custom/globalModal.js"></script>
    <script src="dist/assets/js/custom/logout.js"></script>
</body>
</html>
