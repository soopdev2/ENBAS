/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    var table = $('#utenti').DataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": "StatisticheServlet?isSearch=true",
            "type": "POST",
            "data": function (d) {
                d.pageSize = $('#pageSize').val();
                d.utente_id = $('#utente_select').val();
            },
            "dataType": "json",
            "dataSrc": "aaData"
        },
        "columns": [
            {"data": "id"},
            {"data": "nome"},
            {"data": "cognome"},
            {"data": "età"},
            {"data": "indirizzo"},
            {"data": "ruolo"},
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
        table.ajax.reload();
    });

    $('#utente_select').on('change', function () {
        table.ajax.reload();
    });

    $('#utente_select').select2({
        theme: 'bootstrap-5',
        width: function () {
            return $(this).data('width') ? $(this).data('width') : ($(this).hasClass('w-100') ? '100%' : 'style');
        }
    });

    table.ajax.reload();
});
