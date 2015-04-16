$(document).ready(function(){
//$(document).on("ready page:load", function(){
  var saveClicked = false;
  var i = $("#tab_logic > tbody > tr").length-1;
  
  $("#add_row").click(function(){
    $('#addr'+i).html(addLineItemRow(i));
    $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
    i++;
    showHideDepositCols();
  });

  $("#delete_row").click(function(){
    if(i>1){
      $("#addr"+(i-1)).html('');
      i--;
    }
  });
  
  $("#subbutton").click(function(){saveClicked = true;});
  
  $(document).on("blur",'#tab_logic tr:nth-last-child(2) td:nth-last-child(2)',function() {
    setTimeout(function(){
      if (saveClicked === false) {
        $('#addr'+i).html(addLineItemRow(i));
        $('#addr'+i).find('input:first').focus();
        $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
        i++;
        showHideDepositCols();
      }
    },100);
  });
  
  function addLineItemRow(i) {
    var str;
    if ( $('#depositCheck').length)  {
      str =  "<td>"+ (i+1) +"</td><td><input name='desc"+i+"' type='text' placeholder='Description' class='form-control input-md' /> </td><td><input name='dep"+i+"' type='text' placeholder='0' class='form-control input-md dep_field'></td><td><input name='qty"+i+"' type='text' placeholder='0' class='form-control input-md qty_field'></td><td><input name='price"+i+"' type='text' placeholder='$0.00' step='0.01' class='form-control input-md price_field'></td> <td><input name='total"+i+"' type='text' placeholder='$0.00' class='form-control input-md' disabled='disabled'></td>";
    } else {
      str =  "<td>"+ (i+1) +"</td><td><input name='desc"+i+"' type='text' placeholder='Description' class='form-control input-md' /> </td><td><input name='qty"+i+"' type='text' placeholder='0' class='form-control input-md qty_field'></td><td><input name='price"+i+"' type='text' placeholder='$0.00' step='0.01' class='form-control input-md price_field'></td> <td><input name='total"+i+"' type='text' placeholder='$0.00' class='form-control input-md' disabled='disabled'></td>";
    }
    return str;
  }
  
  $('#depositCheck').change(function(e){
    showHideDepositCols();
    recalcDep();
  });
  
  function showHideDepositCols(){
    if ( $('#depositCheck').length)  {
      if ( $('#depositCheck').is(":checked") ) {
       // alert("not hiding col");
        $('td:nth-child(3),th:nth-child(3)').show();
        $("#depositinput").prop('readonly', true);
      } else {
        //alert("hiding col");
        $('td:nth-child(3),th:nth-child(3)').hide();
        $("#depositinput").prop('readonly', false);
      }
    }
  }
  
  function recalcDep() {
    var depTot = 0;
    $("input.dep_field").each(function(){
     // alert("hi ham");
      var rowTotal = $(this).closest('td').next('td').next('td').next('td').find('input').val();
      if (rowTotal !== 0 && rowTotal !== "")  {
      depTot = depTot + (($(this).val()/100) * rowTotal);
      //console.log("HAMIHS rowtot  " + rowTotal);
      //console.log("HAMIHS deptot " + depTot);
      return depTot;
      }
    });
    $("#depositinput").val(depTot);
  }
});


$(document).on('change', '.price_field', function() {
  //alert( "Handler for .blur() called." );
  var totalfield = $(this).closest('td').next('td').find('input');
  var qtyfield = $(this).closest('td').prev('td').find('input');
  //$(this).closest('td').next('td').find('input').hide();
  var total = ($(this).val() * qtyfield.val());
  totalfield.val(total);
  
  var depositPercent = $(this).closest('td').prev('td').prev('td').find('input').val();
  var depTot = 0;
  depTot = $("#depositinput").val();
  depTot = (+depTot) + ((depositPercent/100) * total);
  $("#depositinput").val(depTot);
  
});

$(document).on('change', '.qty_field', function() {
  //alert( "Handler for .blur() called." );
  var pricefield = $(this).closest('td').next('td').find('input');
  var totalfield = pricefield.closest('td').next('td').find('input');
  //$(this).closest('td').next('td').find('input').hide();
  var total = ($(this).val() * pricefield.val());
  totalfield.val(total);
});



