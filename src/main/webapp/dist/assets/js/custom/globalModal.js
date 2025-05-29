/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


var params = new URLSearchParams(window.location.search);
var esito = params.get('esito');
var codice = params.get('codice');
var logout = params.get('logout');
var progressi = false;

if (esito !== null && codice !== null) {
    var esitoModal = new bootstrap.Modal(document.getElementById('esitoModal'));
    var esitoModalBody = document.getElementById('esitoModalBody');
    var esitoModalButton = document.getElementById('esitoModalButton');
    var esitoModalHeader = document.getElementById('modal-header');

    esitoModalBody.classList.remove('text-primary', 'text-primary');

    if (esito === "KO" && codice === '000') {
        esitoModalBody.textContent = "Email o/e password errati";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO2" && codice === '000') {
        esitoModalBody.textContent = "Utente non trovato. Non è stato possibile trovare l'utente.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO3" && codice === '000') {
        esitoModalBody.textContent = "Utente non autorizzato.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();

    } else if (esito === "OK" && codice === '000' && logout === 'true') {
        esitoModalBody.textContent = "Logout effettuato con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();

    } else if (esito === "OK" && codice === '001') {
        esitoModalBody.textContent = "Questionario iniziato con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "OK" && codice === '002') {
        esitoModalBody.textContent = "Progressi salvati con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        progressi = true;
        redirect(progressi);

    } else if (esito === "OK" && codice === '003') {
        esitoModalBody.textContent = "Questionario inviato con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "OK" && codice === '004') {
        esitoModalBody.textContent = "Questionario assegnato con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "OK" && codice === '005') {
        esitoModalBody.textContent = "Domanda creata con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "OK" && codice === '006') {
        esitoModalBody.textContent = "Domanda aggiornata con successo!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "OK" && codice === '007') {
        esitoModalBody.textContent = "Controllo effettuato con successo. Nuovo/i questionario/i assegnato/i!";
        esitoModalBody.style.color = '#198754';
        esitoModalHeader.style.background = '#198754';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione effettuata con successo!";
        esitoModalButton.style.backgroundColor = '#198754';
        esitoModalButton.style.borderColor = '#198754';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '001') {
        esitoModalBody.textContent = "Non è stato possibile iniziare il questionario! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '002') {
        esitoModalBody.textContent = "Non è stato possibile salvare i progressi! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '003') {
        esitoModalBody.textContent = "Non è stato inviare il questionario! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '004') {
        esitoModalBody.textContent = "Non è stato possibile assegnare il questionario! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO2" && codice === '004') {
        esitoModalBody.textContent = "Errore generico! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO3" && codice === '004') {
        esitoModalBody.textContent = "Non è stato possibile assegnare il questionario. Ultimo/i questionario/i non ancora completati! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO4" && codice === '004') {
        esitoModalBody.textContent = "Utente/i non trovato/i ! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '005') {
        esitoModalBody.textContent = "Non è stato possibile creare la domanda ! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '006') {
        esitoModalBody.textContent = "Non è stato possibile aggiornare la domanda ! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO" && codice === '007') {
        esitoModalBody.textContent = "L'utente selezionato non ha un questionario completato! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO2" && codice === '007') {
        esitoModalBody.textContent = "L'utente selezionato non è stato trovato! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO3" && codice === '007') {
        esitoModalBody.textContent = "Non è stato possibile generare l'excel dell'utente selezionato! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO4" && codice === '007') {
        esitoModalBody.textContent = "Nessun questionario DIGICOMP 2.2 trovato per l'utente selezionato! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO5" && codice === '007') {
        esitoModalBody.textContent = "Non è stato possibile effettuare il controllo o assegnare un nuovo questionario! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    } else if (esito === "KO5" && codice === '007') {
        esitoModalBody.textContent = "Nessun questionario completato trovato! Riprova più tardi.";
        esitoModalBody.style.color = '#dc3545';
        esitoModalHeader.style.background = '#dc3545';
        esitoModalHeader.style.color = 'white';
        esitoModalHeader.textContent = "Operazione non andata a buon fine!";
        esitoModalButton.style.backgroundColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModalButton.style.borderColor = '#dc3545';
        esitoModalButton.style.color = 'white';
        esitoModal.show();
        redirect();
    }
}



function redirect(progressi) {
    document.getElementById('esitoModalButton').addEventListener('click', function () {
        var currentUrl = new URL(window.location.href);
        if (progressi === true) {
            window.location.href = "US_homepage.jsp";
        } else {

            currentUrl.searchParams.delete('esito');
            currentUrl.searchParams.delete('codice');
            currentUrl.searchParams.delete('logout');


            window.location.href = currentUrl.toString();
        }
    });

}