$(document).ready(function() {
  
  
  /* Set up to from date picker fields */
  if ($('#enquiry_est_date').length){ // only run this code if we are on a form with a datepicker
    
    /* get date picker fields*/
    var from_$input = $('#enquiry_est_date').pickadate(),
        from_picker = from_$input.pickadate('picker');
    
    var to_$input = $('#enquiry_fin_date').pickadate(),
        to_picker = to_$input.pickadate('picker');
    
    
    /* below code sets up to from date picker*/
    
    // Check if there’s a “from” or “to” date to start with.
    if ( from_picker.get('value') ) {
      to_picker.set('min', from_picker.get('select'));
    }
    if ( to_picker.get('value') ) {
      from_picker.set('max', to_picker.get('select'));
    }
    
    // When something is selected, update the “from” and “to” limits.
    from_picker.on('set', function(event) {
      if ( event.select ) {
        to_picker.set('min', from_picker.get('select'));
      }
      else if ( 'clear' in event ) {
        to_picker.set('min', false);
      }
    });
    to_picker.on('set', function(event) {
      if ( event.select ) {
        from_picker.set('max', to_picker.get('select'));
      }
      else if ( 'clear' in event ) {
        from_picker.set('max', false);
      }
    });
  }
  
  /* this code intialises select boxes when cocoon addes new fields to a nested form */
  $('#customers').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on enquiry new form
    $('select').not('.disabled').material_select();
  });
  
  
  /* Set up search customer modal form */
  var customer_search_occured;
  var customer_search_title;
  var customer_search_firstname;
  var customer_search_lastname;
  var customer_search_email;
  var customer_search_phone;
  var customer_search_id;
  var customer_search_data;
  
  $('#customer_search_enquiry').on('click', function(e){
     $('#cust_search_modal').closeModal();
     customer_search_occured = true;
     $('.add_fields').click();
  });
  
  $('#customers').bind('cocoon:after-insert', function(e, customer_fields) {
    if (customer_search_occured){

        customer_fields[0].getElementsByTagName('input')[0].value = customer_search_title;
        customer_fields[0].getElementsByTagName('input')[2].value = customer_search_firstname;
        customer_fields[0].getElementsByTagName('input')[3].value = customer_search_lastname;
        customer_fields[0].getElementsByTagName('input')[4].value = customer_search_email;
        customer_fields[0].getElementsByTagName('input')[5].value = customer_search_phone;
        customer_fields[0].getElementsByTagName('input')[6].value = customer_search_id;
        
        
        
      //  customer_fields[0].getElementsByTagName('input').prop('readonly', true);
        customer_fields.find(':input').prop('readonly', true); // set all to readonly - probably as nested fields would go crazy if we changed things.
        customer_fields.find('label').addClass('active');

        customer_search_occured = false;
    }
        
    $('select').not('.disabled').material_select();
  });
  
  /* on selection of customer search set varables */
  var $eventSelect = $("#cust_search_modal .select2-customers");
  $eventSelect.on("select2:select", function (e) {
    customer_search_title = e.params.data.title;
    customer_search_firstname = e.params.data.firstname;
    customer_search_lastname = e.params.data.lastname;
    customer_search_email = e.params.data.email;
    customer_search_phone = e.params.data.phone;
    customer_search_id = e.params.data.id;
    customer_search_data = e.params.data;
  
  });
    
  $('.lead-customer-check').on('change', function() {
      $('.lead-customer-check').not(this).prop('checked', false);
  });

});


