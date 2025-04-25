tinymce.init({
    selector: '#nome_domanda',
    menubar: false
});

tinymce.init({
    selector: '#risposta',
    menubar: false
});

function getRisposteVisibili() {
    return Array.from(document.querySelectorAll('.response-item-template'))
            .filter(item => item.style.display !== 'none' && item.parentElement.id === "risposteContainer");
}

function aggiungiRisposta() {
    const rispostaText = tinymce.get("risposta").getContent();

    if (rispostaText.trim() !== "") {
        const template = document.querySelector(".response-item-template");
        const newItem = template.cloneNode(true);
        newItem.style.display = "block";

        const currentIndex = getRisposteVisibili().length + 1;
        newItem.setAttribute("data-index", currentIndex);

        const responseTextElement = newItem.querySelector(".response-text");
        const uniqueId = `response_${Date.now()}`;
        responseTextElement.id = uniqueId;
        responseTextElement.name = "risposta_text";
        responseTextElement.value = rispostaText;

        const select = newItem.querySelector("select");
        if (select) {
            select.name = "si_no_select";
        }

        const container = document.getElementById("risposteContainer");
        container.appendChild(newItem);

        setTimeout(() => {
            tinymce.init({
                selector: `#${uniqueId}`,
                menubar: false,
                toolbar: 'undo redo | bold italic | bullist numlist | link',
                plugins: 'lists link',
            });
        }, 100);

        const closeButton = newItem.querySelector(".icon-danger");
        closeButton.addEventListener('click', function () {
            newItem.remove();
            aggiornaContatori();
        });

        tinymce.get("risposta").setContent("");
        aggiornaContatori();
    }
}

function aggiornaContatori() {
    const risposte = getRisposteVisibili();
    let counter = 1;
    risposte.forEach((item) => {
        const badge = item.querySelector('#counter');
        if (badge) {
            badge.textContent = `Risposta ${counter}`;
            counter++;
        }
    });
}

function removeInput(button) {
    const row = button.closest('.response-item-template');
    row.remove();
    aggiornaContatori();
}

function mostraErroreModal(messaggio) {
    const erroreModal = new bootstrap.Modal(document.getElementById('erroreModal'));
    const erroreMessage = document.getElementById('erroreModalMessage');
    erroreMessage.textContent = messaggio;
    erroreModal.show();
}

function validaRisposte() {
    const risposte = getRisposteVisibili();

    if (risposte.length < 2) {
        mostraErroreModal("Devi inserire almeno 2 risposte.");
        return false;
    }

    let almenoUnaCorretta = risposte.some(item => {
        const select = item.querySelector("select[name='si_no_select']");
        return select && select.value === "SI";
    });

    if (!almenoUnaCorretta) {
        mostraErroreModal("Devi selezionare almeno una risposta corretta.");
        return false;
    }

    return true;
}

function getValoriSiNoVisibili() {
    const risposte = getRisposteVisibili();
    const valoriSiNo = risposte.map(item => {
        const select = item.querySelector("select[name='si_no_select']");
        return select ? select.value : null;
    });
    return valoriSiNo;
}

let isSubmitting = false;

function salvaDomanda(event) {
    event.preventDefault();

    if (isSubmitting)
        return;
    isSubmitting = true;

    const risposte = getRisposteVisibili();

    const rispostaTextElements = risposte.map(item => {
        const text = item.querySelector('.response-text')?.value.trim() || '';
        return text.replace(/<p><\/p>/g, '');
    }).filter(risposta => risposta !== "");

    const risposteUniche = [...new Set(rispostaTextElements)];

    getValoriSiNoVisibili();

    const hiddenInput = document.getElementById("risposteAggregate");
    if (hiddenInput) {
        hiddenInput.value = risposteUniche.join(';');
    }

    if (validaRisposte()) {
        tinymce.triggerSave();
        document.getElementById("salvaDomanda").submit();
    }

    isSubmitting = false;
}

$(document).ready(function () {
    $('#abilità_competenza').select2({
        theme: 'bootstrap-5',
        width: function () {
            return $(this).data('width') ? $(this).data('width') : ($(this).hasClass('w-100') ? '100%' : 'style');
        }
    });
});
