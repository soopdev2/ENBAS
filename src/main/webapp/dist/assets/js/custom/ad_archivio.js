/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    var table = $('#archivio').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "QuestionarioServlet?isSearch=true&isUser=false",
            "type": "POST",
            "data": function (d) {
                d.pageSize = $('#pageSize').val();
                d.stato_questionario_select = $('#stato_questionario_select').val();
                d.data_inizio = $('#data_inizio').val();
                d.data_fine = $('#data_fine').val();
                d.utente_select = $('#utente_select').val();
                d.tipo_questionario = $('#tipo_questionario').val();
            },
            "dataType": "json",
            "dataSrc": "aaData"
        },
        "columns": [
            {"data": "id"},
            {"data": "data_di_assegnazione",  type: 'date-eu'},
            {"data": "descrizione"},
            {"data": "tipo"},
            {"data": "livello"},
            {"data": "data_di_completamento", type: 'date-eu'},
            {"data": "utente"},
            {"data": "azione"}
        ],
        "pagingType": "full_numbers",
        "pageLength": 5,
        "lengthChange": false,
        "order": [[0, 'asc']],
        "searching": false,
        "language": {
            "lengthMenu": "Visualizza _MENU_ per pagina",
            "zeroRecords": "Nessun risultato trovato",
            "info": "Visualizzati da _START_ a _END_ di _TOTAL_ risultati",
            "infoEmpty": "Nessun dato disponibile",
            "infoFiltered": "(filtrati da _MAX_ risultati totali)",
            "search": "Cerca:",
            "paginate": {
                "first": "Inizio",
                "previous": "Precedente",
                "next": "Successivo",
                "last": "Fine"
            },
            "aria": {
                "sortAscending": ": attiva per ordinare la colonna in ordine crescente",
                "sortDescending": ": attiva per ordinare la colonna in ordine decrescente"
            }
        }

    });

    $('#pageSize').on('change', function () {
        table.page.len(this.value).draw();
    });
    $('#data_inizio').on('change', function () {
        table.ajax.reload();
    });
    $('#data_fine').on('change', function () {
        table.ajax.reload();
    });
    $('#stato_questionario_select').on('change', function () {
        table.ajax.reload();
    });
    $('#utente_select').on('change', function () {
        table.ajax.reload();
    });
    $('#tipo_questionario').on('change', function () {
        table.ajax.reload();
    });
});
