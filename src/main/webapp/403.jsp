<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>403 Accesso Vietato</title>
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
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .error-container {
                text-align: center;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 40px;
                max-width: 600px;
                width: 100%;
            }
            .error-container h1 {
                font-size: 72px;
                font-weight: 700;
                color: #ff4d4d;
            }
            .error-container p {
                font-size: 18px;
                color: #6c757d;
                margin-top: 10px;
            }
            .error-container a {
                font-size: 16px;
                text-decoration: none;
                color: #007bff;
                margin-top: 20px;
                display: inline-block;
                background-color: #007bff;
                padding: 10px 20px;
                border-radius: 4px;
                color: #ffffff;
            }
            .error-container a:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <h1>403</h1>
            <p>Accesso vietato: Non hai i permessi per accedere a questa risorsa.</p>
            <a href="index.jsp">Vai alla Home Page</a>
        </div>
    </body>
</html>
