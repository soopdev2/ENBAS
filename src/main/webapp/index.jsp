<%-- 
    Document   : index
    Created on : 13 gen 2025, 11:25:48
    Author     : Salvatore
--%>

<%@page import="Utils.Utils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
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
        <title>Login</title>
    </head>
    <body>
        <div class="it-header-center-wrapper it-small-header">
            <div class="container-xxl">
                <div class="row">
                    <div class="col-12">
                        <div class="it-header-center-content-wrapper">
                            <div class="it-brand-wrapper">
                                <a href="#">
                                    <svg class="icon" aria-hidden="true">
                                    <use href="dist/svg/sprites.svg#it-pa"></use>
                                    </svg>
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
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-facebook"></use>
                                                </svg>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#" aria-label="Github" target="_blank">
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-github"></use>
                                                </svg>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#" aria-label="Twitter" target="_blank">
                                                <svg class="icon">
                                                <use href="dist/svg/sprites.svg#it-twitter"></use>
                                                </svg>
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

        <br>
        <br>


        <div class="container d-flex justify-content-center align-items-center">
            <div class="col-12 col-lg-3">
                <!-- Start Card -->
                <div class="card card-bg mb-4">
                    <div class="card-body">
                        <legend class="card-title h5 text-center text-primary">Effettua il login</legend>
                        <br>
                        <form class="form" id="loginForm" method="POST" action="Login">
                            <input type="hidden" name="isLogin" value="true">
                            <div class="form-group mb-3">
                                <label for="username" class="text-primary">Username</label>
                                <input type="text" name="username" data-bs-input class="form-control" id="username" required autocomplete="on">
                            </div>
                            <br>
                            <div class="form-group mb-3">
                                <label for="password" class="text-primary">Password</label>
                                <input type="password"  name="password" data-bs-input class="form-control input-password" id="password" required>
                                <button type="button" class="password-icon btn" role="switch" aria-checked="false">
                                    <span class="visually-hidden">Mostra/Nascondi Password</span>
                                    <svg class="password-icon-visible icon icon-sm" aria-hidden="true"><use href="dist/svg/sprites.svg#it-password-visible"></use></svg>
                                    <svg class="password-icon-invisible icon icon-sm d-none" aria-hidden="true"><use href="dist/svg/sprites.svg#it-password-invisible"></use></svg>
                                </button>
                            </div>
                            <br>
                            <div class="d-flex justify-content-center">
                                <button type="submit" id="inviaForm" class="btn btn-primary">Login</button>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- End Card -->
            </div>
        </div>

        <div class="modal fade" id="esitoModal" tabindex="-1" aria-labelledby="esitoModalLabel" aria-hidden="true">
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
        <script src="dist/assets/js/custom/globalModal.js"></script>
    </body>
</html>
