
$(document).ready(function(){

  $('#payselect').on('change', function () {
    var val = $(this).val();

    if (val === 'None') {
      $('#paygategroup').hide();
      $('#pinpaymentsgroup').hide();
    } else if (val === 'Payment Express') {
       $('#paygategroup').show();
       $('#pinpaymentsgroup').hide();
    } else if (val === 'Pin Payments') {
       $('#paygategroup').hide();
       $('#pinpaymentsgroup').show();
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