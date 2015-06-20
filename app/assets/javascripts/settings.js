
$(document).ready(function(){

  $('#payselect').on('change', function () {
    var val = $(this).val();

    if (val === 'None') {
      $('#paygategroup').hide();
    } else if (val === 'Payment Express') {
       $('#paygategroup').show();
    }
  });
  
  $('#payselect').trigger('change');
  
  
  $('#setting_use_dropbox').change(function(){
    if (this.checked) {
      $('#settings_dropbox_group').show();
    } else {
      $('#settings_dropbox_group').hide();
    }
  });
  
  $('#setting_use_dropbox').trigger('change');
  
 });