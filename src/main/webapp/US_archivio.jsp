<%-- 
    Document   : US_archivio_questionari
    Created on : 17 gen 2025, 16:50:23
    Author     : Salvatore
--%>

<%@page import="Utils.JPAUtil"%>
<%@page import="java.util.List"%>
<%@page import="Entity.Utente"%>
<%@page import="Enum.Stato_questionario"%>
<%@page import="Entity.Questionario"%>
<%@page import="Utils.Utils"%>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="dist/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="dist/assets/css/custom/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium Web' rel='stylesheet'>
        <link rel="stylesheet" href="dist/assets/css/external/dataTables.bootstrap5.css"/>
        <title>Archivio questionari</title>
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
                                                <li class="nav-item"><a class="nav-link" href="US_homepage.jsp" aria-current="page">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom" aria-hidden="true"><use href="dist/svg/sprites.svg#it-pa"></use></svg>
                                                            Homepage
                                                        </span>
                                                    </a></li>
                                                <li class="nav-item">
                                                    <a class="nav-link" href="US_questionario.jsp">
                                                        <span>
                                                            <svg class="icon icon-white align-bottom"><use href="dist/svg/sprites.svg#it-file"></use></svg>
                                                            Nuovo questionario
                                                        </span>
                                                        <span class="badge">
                                                            <%                                String userIdParam = Utils.checkAttribute(session, "userId");
                                                                Long userId = Utils.tryParseLong(userIdParam);
                                                                JPAUtil jPAUtil = new JPAUtil();
                                                                Questionario utente_questionario = jPAUtil.findUtenteQuestionarioIdByUserId(userId);
                                                            %>

                                                            <% if (utente_questionario == null || utente_questionario.getStatus() == 0 && utente_questionario.getDescrizione() == null) {%>
                                                            <span class="badge bg" style="display: none">

                                                            </span>
                                                            <% } else if (utente_questionario.getStatus() == 0 && utente_questionario.getDescrizione().equals(Stato_questionario.ASSEGNATO)) {%>
                                                            <span class="badge bg-danger">
                                                                Nuovo
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus() == 1 && utente_questionario.getDescrizione().equals(Stato_questionario.PRESO_IN_CARICO) || utente_questionario.getStatus() == 2 && utente_questionario.getDescrizione().equals(Stato_questionario.DA_COMPLETARE)) {%>
                                                            <span class="badge bg-warning">
                                                                Continua
                                                            </span>
                                                            <% } else if (utente_questionario.getStatus() == 3 && utente_questionario.getDescrizione().equals(Stato_questionario.COMPLETATO)) {%>
                                                            <span class="badge bg-success">
                                                                Completato
                                                            </span>
                                                            <% }%>
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link active" href="US_archivio.jsp"> <span>
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

        <div class="container-fluid">
            <div class="card-wrapper">
                <div class="card card-bg mb-6">
                    <div class="card card-header text-center">
                        <br>
                        <h4 class="card-title" style="font-weight: normal">
                            Archivio questionari
                        </h4>
                    </div>

                    <form method="POST" action="QuestionarioServlet">
                        <input type="hidden" name="isUser" value="true">
                        <input type="hidden" name="isSearch" value="true">
                        <div class="container-fluid">
                            <div class="card">
                                <div class="card-body">

                                    <div class="container">
                                        <div class="row w-100" style="display: flex; justify-content: center;">

                                            <div class="col-md-3 mb-3">
                                                <label class="text-primary active" for="data_inizio">Data assegnazione da</label>
                                                <input type="date" class="form-control" id="data_inizio" name="data_inizio">
                                            </div>

                                            <div class="col-md-3 mb-3">
                                                <label class="text-primary active" for="data_fine">Data assegnazione a</label>
                                                <input type="date" class="form-control" id="data_fine" name="data_fine">
                                            </div>

                                            <div class="col-md-3 mb-3">
                                                <label class="text-primary active" for="tipo_questionario">Tipo questionario</label>
                                                <select name="tipo_questionario" id="tipo_questionario" class="form-control border">
                                                    <option value="Tutti" selected>TUTTI</option>
                                                    <option value="Modello_predefinito">Modello Predefinito</option>
                                                    <option value="Categoria">Categoria</option>
                                                    <option value="DIGICOMP">DIGICOMP</option>
                                                </select>
                                            </div>


                                            <div class="col-md-3 mb-3">
                                                <label class="text-primary active" for="stato_questionario_select">Seleziona stato questionario</label>
                                                <select name="stato_questionario_select" id="stato_questionario_select" class="form-control border">
                                                    <option value="Tutti" selected>TUTTI</option>
                                                    <option value="<%=Stato_questionario.ASSEGNATO.name()%>"><%=Stato_questionario.ASSEGNATO.name()%></option>
                                                    <option value="<%=Stato_questionario.PRESO_IN_CARICO.name()%>"><%=Stato_questionario.PRESO_IN_CARICO.name()%></option>
                                                    <option value="<%=Stato_questionario.DA_COMPLETARE.name()%>"><%=Stato_questionario.DA_COMPLETARE.name()%></option>
                                                    <option value="<%=Stato_questionario.COMPLETATO.name()%>"><%=Stato_questionario.COMPLETATO.name()%></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <br>

                                    <div data-datatable="true" data-datatable-page-size="5" data-datatable-state-save="true" id="archivo">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-striped" id="archivio">
                                                <thead>
                                                    <tr class="text-primary">
                                                        <th class="text-center">ID</th>
                                                        <th>Data di assegnazione</th>
                                                        <th>Descrizione</th>
                                                        <th>Tipo</th>
                                                        <th>Livello/Descrizione</th>
                                                        <th>Data completamento</th>
                                                        <th>Utente</th>
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
                    </form>


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



        <script src="dist/assets/js/bootstrap-italia.bundle.min.js"></script>
        <script src="dist/assets/js/external/jquery-3.7.1.js"></script>
        <script src="dist/assets/js/external/dataTables.js"></script>
        <script src="dist/assets/js/external/dataTables.bootstrap5.js"></script>

        <script src="dist/assets/js/custom/us_archivio.js"></script>
        <script src="dist/assets/js/custom/logout.js"></script>

    </body>
</html>
