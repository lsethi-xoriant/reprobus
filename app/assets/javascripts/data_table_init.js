/* Make sure this is called before the materialize helpers, as otherwise select box wont be initialized by materialize... */

$(document).ready(function(){
    $('#data-table-simple').DataTable();
    
    var table = $('#data-table-row-grouping').DataTable({
        "columnDefs": [
            { "visible": false, "targets": 2 }
        ],
        "order": [[ 2, 'asc' ]],
        "displayLength": 25,
        "drawCallback": function ( settings ) {
            var api = this.api();
            var rows = api.rows( {page:'current'} ).nodes();
            var last=null;
 
            api.column(2, {page:'current'} ).data().each( function ( group, i ) {
                if ( last !== group ) {
                    $(rows).eq( i ).before(
                        '<tr class="group"><td colspan="5">'+group+'</td></tr>'
                    );
 
                    last = group;
                }
            } );
        }
    });
 
    // Order by the grouping
    $('#data-table-row-grouping tbody').on( 'click', 'tr.group', function () {
        var currentOrder = table.order()[0];
        if ( currentOrder[0] === 2 && currentOrder[1] === 'asc' ) {
            table.order( [ 2, 'desc' ] ).draw();
        }
        else {
            table.order( [ 2, 'asc' ] ).draw();
        }
    });
});


jQuery(document).ready(function() {
  $('#ajax-data-table-simple').dataTable({
    "processing": true,
    "serverSide": true,
    stateSave: true,
    responsive: true,
    "ajax": $('#ajax-data-table-simple').data('source'),
    "pagingType": "full_numbers",
    "columnDefs": [
      {"targets"  : 'no-sort',
      "orderable": false}
       ]
    // optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about
    // available options.
  });
});
