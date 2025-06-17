<%-- 
    Document   : AD_modifica_domanda
    Created on : 3 apr 2025, 15:26:09
    Author     : Salvatore
--%>

<%@page import="Enum.Si_no"%>
<%@page import="Entity.Competenza"%>
<%@page import="Entity.Domanda"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Enum.Visibilità_domanda"%>
<%@page import="Entity.AreeCompetenze"%>
<%@page import="Entity.Categoria"%>
<%@page import="java.util.List"%>
<%@page import="Utils.Utils"%>
<%@page import="Utils.JPAUtil"%>
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
        <title>Modifica domanda</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
                                               <div class="it-brand-title">SuperQuizzone</div>
<div class="it-brand-tagline d-none d-md-block">//</div> 
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
                                                    <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" id="mainNavDropdown1">
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
            <h4 class="text-center">Modifica domande</h4>
            <br>

            <div class="row">
                <div class="col-12 col-lg-12">
                    <!--start card-->
                    <div class="card-wrapper">
                        <div class="card card-bg mb-6">
                            <div class="card-body">
                                <h5 class="card-title h5 text-center">Modifica domande</h5>
                                <p class="card-text font-serif text-center">Modifica domande</p>
                                <hr>

                                <%                                    JPAUtil jPAUtil = new JPAUtil();
                                    String domandaParam = request.getParameter("domanda_id");
                                    Long domandaId = Utils.tryParseLong(domandaParam);
                                    Domanda domanda = jPAUtil.findDomandaById(domandaId);

                                %>

                                <div class="container">

                                    <form action="GestioneDomande" method="POST" id="modificaDomanda">
                                        <input type="hidden" name="isEdit" value="true">
                                        <input type="hidden" name="domanda_id" value="<%=domanda.getId()%>">

                                        <div class="row w-100" style="display: flex; justify-content: center;">
                                            <div class="col">

                                                <h5 class="text-center text-primary">Classificazione domanda</h5>

                                                <label class="form-label" for="area">Seleziona area della domanda</label>
                                                <select name="area" id="area" required class="form-control border">
                                                    <option disabled selected value="<%= domanda.getCategoria().getId()%>"><%= domanda.getCategoria().getNome()%></option>
                                                    <%                                                        List<Categoria> aree = jPAUtil.findAllCategorie();
                                                        for (Categoria c : aree) {
                                                    %>
                                                    <option value="<%= c.getId()%>"><%= c.getNome()%></option>
                                                    <% } %>
                                                </select>


                                                <%
                                                    List<AreeCompetenze> areeCompetenze = jPAUtil.findAllAreeCompetenze();

                                                    Map<String, Map<Long, String>> categorieAree = new HashMap<>();
                                                    Map<Long, Map<Long, String>> competenzePerArea = new HashMap<>();

                                                    for (int i = 1; i <= 5; i++) {
                                                        categorieAree.put(String.valueOf(i), new HashMap<>());
                                                    }

                                                    for (AreeCompetenze ac : areeCompetenze) {
                                                        long catId = ac.getCategoria().getId();
                                                        categorieAree.get(String.valueOf(catId)).put(ac.getId(), ac.getNome());

                                                        List<Competenza> competenzaList = jPAUtil.getCompetenzaListByAreaCompetenza(ac);
                                                        Map<Long, String> competenzeMap = new HashMap<>();

                                                        for (Competenza c : competenzaList) {
                                                            competenzeMap.put(c.getId(), c.getDescrizione());
                                                        }

                                                        competenzePerArea.put(ac.getId(), competenzeMap);
                                                    }

                                                    String jsonCategorieAree = new Gson().toJson(categorieAree);
                                                    String jsonCompetenzePerArea = new Gson().toJson(competenzePerArea);
                                                %>


                                                <label class="form-label mt-3" for="area_competenza">Seleziona area competenza della domanda</label>
                                                <select id="area_competenza" name="area_competenza" required class="form-control border">
                                                    <option selected disabled value="<%= domanda.getCompetenza().getAreeCompetenze().getId()%>"><%= domanda.getCompetenza().getAreeCompetenze().getNome()%></option>
                                                </select>

                                                <br>
                                                <label class="form-label mt-3" for="competenza">Seleziona abilità/competenza della domanda</label>
                                                <select id="competenza" name="competenza" required class="form-control border">
                                                    <option selected disabled value="<%= domanda.getCompetenza().getId()%>"><%= domanda.getCompetenza().getDescrizione()%></option>
                                                </select>

                                                <br>
                                                <label class="form-label" for="stato">Seleziona stato della domanda</label>
                                                <select name="stato" id="stato" class="form-control border" required>
                                                    <% if (domanda.getVisibilità_domanda().toString().equals(Visibilità_domanda.VISIBILE.toString())) {%>
                                                    <option selected value="<%=Visibilità_domanda.VISIBILE.name()%>">Attiva</option>
                                                    <option value="<%=Visibilità_domanda.NON_VISIBILE.name()%>">Non attiva</option>
                                                    <% } else {%>
                                                    <option selected value="<%=Visibilità_domanda.NON_VISIBILE.name()%>">Non attiva</option>
                                                    <option value="<%=Visibilità_domanda.VISIBILE.name()%>">Attiva</option>
                                                    <% }%>
                                                </select>
                                                <br>


                                                <h5 class="text-center text-primary">Dati domanda</h5>

                                                <label class="form-label" for="titolo">
                                                    Titolo
                                                </label>
                                                <input type="text" class="form-control border" id="titolo" name="titolo" value="<%=domanda.getTitolo()%>">

                                                <br>

                                                <label class="form-label" for="nome">
                                                    Nome domanda
                                                </label>
                                                <input type="text" class="form-control border" id="nome_domanda" name="nome_domanda" value="<%= domanda.getNome_domanda()%>">

                                                <br>



                                                <div class="container">
                                                    <label for="risposta" class="form-label">Aggiungi nuova risposta</label>
                                                    <textarea style="width: 50%; height: 50%;" id="risposta" placeholder="..."></textarea>
                                                </div>

                                                <br>

                                                <div class="container">
                                                    <button type="button" class="btn btn-primary" onclick="aggiungiRisposta()">Aggiungi</button>
                                                </div>

                                                <br>

                                                <div class="it-example-modal">
                                                    <div class="modal alert-modal" tabindex="-1" role="dialog" id="erroreModal" aria-labelledby="erroreModalTitle">
                                                        <div class="modal-dialog" role="document">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <svg class="icon icon-danger">
                                                                    <use href="dist/svg/sprites.svg#it-warning-circle"></use>
                                                                    </svg>
                                                                    <h2 class="modal-title h5" id="erroreModalTitle">Attenzione</h2>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <p id="erroreModalMessage"></p>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button class="btn btn-primary btn-md" type="button" data-bs-dismiss="modal">OK</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="container" id="risposteContainer">
                                                    <div class="response-item-template" style="display: none;">
                                                        <br>
                                                        <ul>
                                                            <li class="container col-lg-12">
                                                                <span class="badge">
                                                                    <span class="badge bg-primary" id="counter"></span>
                                                                </span>
                                                                <div class="row">
                                                                    <div class="col-6 form-group">
                                                                        <textarea class="response-text"></textarea>
                                                                    </div>
                                                                    <div class="col-6 form-group">
                                                                        <span>
                                                                            <svg class="icon icon-danger icon-md align-bottom" aria-hidden="true" onclick="removeInput(this)">
                                                                            <use href="dist/svg/sprites.svg#it-close-big"></use>
                                                                            </svg>
                                                                            Rimuovi
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12 form-group">
                                                                        <label class="form-label active" for="si_no_select">È una risposta corretta?</label>
                                                                        <select class="form-control border" name="si_no_select" required>
                                                                            <option selected value="<%= Si_no.NO.name()%>"><%= Si_no.NO.name()%></option>
                                                                            <option value="<%= Si_no.SI.name()%>"><%= Si_no.SI.name()%></option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </ul>

                                                    </div>
                                                </div>

                                                <hr>
                                            </div>
                                            <br>
                                            <div class="container text-center">
                                                <button type="button" class="btn btn-primary" onclick="modificaDomanda(event)">Salva modifiche</button>
                                            </div>




                                        </div>
                                    </form>
                                </div>

                            </div>

                        </div>
                        <br>

                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<br>
<br>

<footer>
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
<script src="dist/assets/js/external/select2.min.js"></script>
<script src="https://cdn.tiny.cloud/1/tbnutsowolzn3f1fnn0597qd5fvo68ivw52yw2gnafphfpi8/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
<script src="dist/assets/js/custom/ad_modifica_domanda.js"></script>
<script src="dist/assets/js/custom/globalModal.js"></script>
<script>
                                                    const categorieAree = <%= jsonCategorieAree%>;
                                                    const competenzePerArea = <%= jsonCompetenzePerArea%>;

                                                    const areaSelect = $('#area');
                                                    const areaCompetenzaSelect = $('#area_competenza');
                                                    const competenzaSelect = $('#competenza');

                                                    areaSelect.select2({
                                                        theme: 'bootstrap-5',
                                                        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                                    });

                                                    areaCompetenzaSelect.select2({
                                                        theme: 'bootstrap-5',
                                                        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                                    });

                                                    competenzaSelect.select2({
                                                        theme: 'bootstrap-5',
                                                        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
                                                    });

                                                    areaSelect.on('select2:select', function (e) {

                                                        areaCompetenzaSelect.empty().append('<option selected>Tutti</option>');
                                                        competenzaSelect.empty().append('<option selected>Tutti</option>');

                                                        const selectedCat = e.params.data.id;
                                                        if (selectedCat !== 'Tutti' && categorieAree[selectedCat]) {
                                                            Object.entries(categorieAree[selectedCat]).forEach(([id, nome]) => {
                                                                const option = new Option(nome, id, false, false);
                                                                areaCompetenzaSelect.append(option);
                                                            });
                                                        }

                                                        areaCompetenzaSelect.trigger('change');
                                                    });

                                                    areaCompetenzaSelect.on('select2:select', function (e) {

                                                        competenzaSelect.empty().append('<option selected>Tutti</option>');

                                                        const selectedAreaId = e.params.data.id;
                                                        if (selectedAreaId !== 'Tutti' && competenzePerArea[selectedAreaId]) {
                                                            Object.entries(competenzePerArea[selectedAreaId]).forEach(([id, descrizione]) => {
                                                                const option = new Option(descrizione, id, false, false);
                                                                competenzaSelect.append(option);
                                                            });
                                                        }

                                                        competenzaSelect.trigger('change');
                                                    });

                                                    var jsonData = <%= domanda.getRisposte()%>;
                                                    caricaRisposte(jsonData);

</script>
<script src="dist/assets/js/custom/logout.js"></script>
</body>
</html>