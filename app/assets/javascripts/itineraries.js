/*This file is for the itinerary and itinerary templates pages                                   */
/*It relies on the sortable.js plug in, Coccoon gem hooks, and the select2 search products js    */


/* JS to initiate sortable elements   */

$(document).ready(function() {
    
  sort_itinerary_items();  // sorts table and sets up intial pos numbers
  
  // set labels to active in these containers as we want the to look small
  reset_material_active_labels('#itinerary_template_infos'); 
  reset_material_active_labels('#itinerary_infos');
    
  $('.sortable').sortable().bind('sortupdate', function(e, ui) {
    set_sort_positions_and_dates();   // set positions if any resort occurs.
  });
     
  /* JS hooks to update sortable elements   */
  $('#itinerary_template_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    initProductSelect2();  // re-init product search dropdowns as new ones have been added
    initDestinationSelect2();
    sort_itinerary_items();
    reset_material_active_labels('#itinerary_template_infos');
  });
  
  $('#itinerary_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    initProductSelect2();  // re-init product search dropdowns as new ones have been added
    sort_itinerary_items();
    reset_material_active_labels('#itinerary_infos');
    
    // redo Pikadate datepicker
    $('.datepicker').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 5, // Creates a dropdown of 15 years to control year
      // HAMISH - select drop down not working very well for YEARS or MONTHS!!
      formatSubmit: 'yyyy-mm-dd',
      format: 'yyyy-mm-dd',
      min: new Date(2015,6,08),
      hiddenSuffix: ''
    });
  });
});

/* JS hooks to update sortable elements   */

  function sort_itinerary_items(){
    set_sort_positions_and_dates();
  
    // call sortable on our div with the sortable class
    $('.sortable').sortable({
      items: '.nested-fields'
    });
  }
 
 function set_sort_positions_and_dates(){
    // loop through and update position fields
    $('.iti_position_field').each(function(i){
        $(this).val(i+1);
    });
    $('.iti_postion_number').each(function(i){
        $(this).text(i+1);
    });
    
    // if on itinerary page, need to recalc dates.
    if ($('#itinerary_start_date').length) {
  //console.log('hamish  ' + $('#itinerary_start_date').val());
      var start_$input = $('#itinerary_start_date').pickadate(),
           start_picker = start_$input.pickadate('picker');
      
      var start_date = new Date(start_picker.get());
      var currdate = new Date();
      var int = 0;
  //console.log('hamish2  ' + start_date);
      
      $('#itinerary_infos').find('.datepicker').each(function(i){
        int ++;
        var initdate = new Date( $(this).val());
      
        console.log('HAMISH ');
        console.log('hamish initdate  ' + int + " " + initdate);
        console.log('hamish start_date  ' + int + " " + start_date);
        console.log('hamish  dif ' + int + " " + (initdate - start_date));
        
        if ( (initdate- start_date) > 0) {
          var start_date2 = new Date((start_date + (initdate - start_date)));
        }
        console.log('hamish start date2 after' + int + " " + start_date2);
      
      });
    }
  }
    
 function reset_material_active_labels(container_id) {
  // resets lables to active 
  // sometimes the materilize labels do not get set to active, plus we want them to be small on the itinerary forms
  $(container_id + " input").each(function() {
    //if ($(this).val() !== ""){
      var fieldId = $(this).attr("id");
      $("label[for='"+fieldId+"']").addClass('active');
    //}
  });
 }

/*JS to hook into Products seach drop down */
