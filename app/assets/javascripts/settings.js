
$(document).ready(function(){
  $('#settingsTabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  })
  
  
  $('#payselect').on('change', function () {
    var val = $(this).val();

    if (val === 'None') {
      $('#paygategroup').hide();
    } else if (val === 'Payment Express') {
       $('#paygategroup').show();
    }
  });
  
  $('#payselect').trigger('change');
 });