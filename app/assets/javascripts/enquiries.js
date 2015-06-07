$(document).ready(function() {
  
  if ($('#enquiry_est_date').length){ // only run this code if we are on a form with a datepicker
    
    
    /* get date picker fields*/
    var from_$input = $('#enquiry_est_date').pickadate(),
        from_picker = from_$input.pickadate('picker')
    
    var to_$input = $('#enquiry_fin_date').pickadate(),
        to_picker = to_$input.pickadate('picker')
    
    
    /* below code sets up to from date picker*/
    
    // Check if there’s a “from” or “to” date to start with.
    if ( from_picker.get('value') ) {
      to_picker.set('min', from_picker.get('select'))
    }
    if ( to_picker.get('value') ) {
      from_picker.set('max', to_picker.get('select'))
    }
    
    // When something is selected, update the “from” and “to” limits.
    from_picker.on('set', function(event) {
      if ( event.select ) {
        to_picker.set('min', from_picker.get('select'))
      }
      else if ( 'clear' in event ) {
        to_picker.set('min', false)
      }
    })
    to_picker.on('set', function(event) {
      if ( event.select ) {
        from_picker.set('max', to_picker.get('select'))
      }
      else if ( 'clear' in event ) {
        from_picker.set('max', false)
      }
    })
  }
  
  /* this code intialises select boxes when cocoon addes new fields to a nested form */
  $('#customers').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on enquiry new form
    $('select').not('.disabled').material_select();
  });
  
});