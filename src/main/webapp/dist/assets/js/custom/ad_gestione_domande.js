/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    var table = $('#gestione_domande').DataTable({
        "processing": true,
        "serverSide": true,
        "responsive": true,
        "ajax": {
            "url": "GestioneDomande?isSearch=true",
            "type": "POST",
            "data": function (d) {
                d.pageSize = $('#pageSize').val();
                d.area = $('#area').val();
                d.area_competenza = $('#area_competenza').val();
                d.competenza = $('#competenza').val();
                d.stato = $('#stato').val();
            },
            "dataType": "json",
            "dataSrc": "aaData"
        },

        "columns": [
            {"data": "id", "orderable": true},
            {"data": "titolo", "orderable": false},
            {"data": "nome", "orderable": false},
            {"data": "info", "orderable": false},
            {"data": "stato", "orderable": false},
            {"data": "azione", "orderable": false}
        ],
        "pagingType": "full_numbers",
        "pageLength": 5,
        "lengthChange": false,
        "order": [[0, 'desc']],
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
    $('#area').on('change', function () {
        table.ajax.reload();
    });
    $('#area_competenza').on('change', function () {
        table.ajax.reload();
    });
    $('#competenza').on('change', function () {
        table.ajax.reload();
    });
    $('#stato').on('change', function () {
        table.ajax.reload();
    });
    $('#stato').select2({
        theme: 'bootstrap-5',
        width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : 'style'
    });
    var creaDomanda = document.getElementById('creaDomanda');
    creaDomanda.addEventListener('click', function () {
        location.href = 'AD_crea_domanda.jsp';
    });
});
