$(document).ready(function(){
      //var i=1;
  var i = $("#tab_logic > tbody > tr").length-1;

  $("#add_row").click(function(){
    $('#addr'+i).html(addLineItemRow(i));
    $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
    i++; 
  });

  $("#delete_row").click(function(){
    if(i>1){
      $("#addr"+(i-1)).html('');
      i--;
    }
  });
  
  $(document).on("blur",'#tab_logic tr:nth-last-child(2) td:nth-last-child(2)',function() {
    $('#addr'+i).html(addLineItemRow(i));
    $('#addr'+i).find('input:first').focus();
    $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
    i++; 
  });
  
  function addLineItemRow(i) {
    return "<td>"+ (i+1) +"</td><td><input name='desc"+i+"' type='text' placeholder='Description' class='form-control input-md'  /> </td><td><input name='qty"+i+"' type='text' placeholder='0'  class='form-control input-md qty_field'></td><td><input name='price"+i+"' type='text' placeholder='$0.00' step='0.01' class='form-control input-md price_field'></td> <td><input name='total"+i+"' type='text' placeholder='$0.00' class='form-control input-md' disabled='disabled'></td>";    
  }
});

$(document).on('change', '.price_field', function() {
  //alert( "Handler for .blur() called." );
  var totalfield = $(this).closest('td').next('td').find('input');
  var qtyfield = $(this).closest('td').prev('td').find('input');
  //$(this).closest('td').next('td').find('input').hide();
  var total = ($(this).val() * qtyfield.val());
  totalfield.val(total);
});

$(document).on('change', '.qty_field', function() {
  //alert( "Handler for .blur() called." );
  var pricefield = $(this).closest('td').next('td').find('input');
  var totalfield = pricefield.closest('td').next('td').find('input');
  //$(this).closest('td').next('td').find('input').hide();
  var total = ($(this).val() * pricefield.val());
  totalfield.val(total);
});
