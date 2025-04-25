tinymce.init({
    selector: '#nome_domanda',
    menubar: false
});

tinymce.init({
    selector: '#risposta',
    menubar: false
});

function aggiungiRisposta() {
    const rispostaText = tinymce.get("risposta").getContent();

    if (rispostaText.trim() !== "") {
        const template = document.querySelector(".response-item-template");
        const newItem = template.cloneNode(true);
        newItem.style.display = "block";

        const currentIndex = document.querySelectorAll('.response-item-template').length + 1;
        newItem.setAttribute("data-index", currentIndex);

        const responseTextElement = newItem.querySelector(".response-text");
        const uniqueId = `response_${Date.now()}`;

        responseTextElement.id = uniqueId;
        responseTextElement.name = "risposta_text[]";
        responseTextElement.value = rispostaText;

        const select = newItem.querySelector("select");
        if (select) {
            select.name = "si_no_select[]";
        }

        const hiddenIdInput = document.createElement("input");
        hiddenIdInput.type = "hidden";
        hiddenIdInput.name = "id_risposta[]";
        hiddenIdInput.value = "0";
        newItem.appendChild(hiddenIdInput);

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

        tinymce.get("risposta").setContent("");
        aggiornaContatori();
    }
}

function aggiornaContatori() {
    const container = document.getElementById("risposteContainer");
    const risposte = container.querySelectorAll('.response-item-template');

    let counter = 1;
    risposte.forEach((item) => {
        const badge = item.querySelector('#counter');
        if (badge && item.style.display !== "none") {
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
    const container = document.getElementById("risposteContainer");
    const risposte = container.querySelectorAll(".response-item-template:not([style*='display: none'])");

    if (risposte.length < 2) {
        mostraErroreModal("Devi inserire almeno 2 risposte.");
        return false;
    }

    let almenoUnaCorretta = false;
    risposte.forEach(item => {
        const select = item.querySelector("select");
        if (select && select.value === "SI") {
            almenoUnaCorretta = true;
        }
    });

    if (!almenoUnaCorretta) {
        mostraErroreModal("Devi selezionare almeno una risposta corretta.");
        return false;
    }

    return true;
}

let isSubmitting = false;
function modificaDomanda(event) {
    event.preventDefault();

    if (isSubmitting)
        return;
    isSubmitting = true;

    if (validaRisposte()) {
        tinymce.triggerSave();
        document.getElementById("modificaDomanda").submit();
    }

    isSubmitting = false;
}

function caricaRisposte(jsonData) {
    const container = document.getElementById("risposteContainer");

    jsonData.risposte.forEach((risposta, index) => {
        const template = document.querySelector(".response-item-template");
        const newItem = template.cloneNode(true);
        newItem.style.display = "block";

        const uniqueId = `response_${Date.now()}_${index}`;

        const responseTextElement = newItem.querySelector(".response-text");
        responseTextElement.id = uniqueId;
        responseTextElement.name = "risposta_text[]";
        responseTextElement.innerHTML = ""; 

        const select = newItem.querySelector("select");
        if (select) {
            select.name = "si_no_select[]";
            select.value = risposta.corretta ? "SI" : "NO";
        }

        const hiddenIdInput = document.createElement("input");
        hiddenIdInput.type = "hidden";
        hiddenIdInput.name = "id_risposta[]";
        hiddenIdInput.value = risposta.id;
        newItem.appendChild(hiddenIdInput);

        container.appendChild(newItem);

        setTimeout(() => {
            tinymce.init({
                selector: `#${uniqueId}`,
                menubar: false,
                toolbar: 'undo redo | bold italic | bullist numlist | link',
                plugins: 'lists link',
                setup: (editor) => {
                    editor.on('init', () => {
                        editor.setContent(risposta.testo || "");
                    });
                }
            });
        }, 100);
    });

    aggiornaContatori();
}

