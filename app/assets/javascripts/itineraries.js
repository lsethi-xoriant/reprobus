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
    initDestinationSelect2();
    sort_itinerary_items();
    reset_material_active_labels('#itinerary_infos');
    

    // redo Pikadate datepicker
    $('.datepicker .start').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 5, // Creates a dropdown of 15 years to control year
      // HAMISH - select drop down not working very well for YEARS or MONTHS!!
      formatSubmit: 'yyyy-mm-dd',
      format: 'yyyy-mm-dd',
      min: new Date(),
      hiddenSuffix: ''
    });
  });
  
  $('#itinerary_start_date').on('change', function(e, insertedItem) { 
    set_sort_positions_and_dates();
  });
  
  
  $('.length-field').on('change', function(e, insertedItem) { 
    set_sort_positions_and_dates();
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

      var start_$input = $('#itinerary_start_date').pickadate(),
           start_picker = start_$input.pickadate('picker');
           
      var dateStr = start_picker.get();
      
      var yearStr = parseInt(dateStr.substring(0,4));
      var monStr = parseInt(dateStr.substring(5,7));
      var dayStr = parseInt(dateStr.substring(8,10));
      monStr = monStr-1;  // minus one as months are 0-11
//console.log('hamish get date  '  + " " + start_picker.get());
  
      
      var current_date = new Date(yearStr,monStr,dayStr);
      var int = 0;

      $('#itinerary_infos').find('.datepicker').each(function(i){

//int ++;
//console.log('hamish current_date in loop  ' + int + " " + current_date);
        
        var picker = $(this).pickadate().pickadate('picker');
        picker.set('select', current_date);
        
        var num_days = $(this).closest(".field").find(".length-field").val();
        if (num_days > 0){
          
//   console.log('hamish num days  ' + int + " " + num_days);
          
          current_date.setDate(current_date.getDate() + parseInt(num_days));
        }
        
//   console.log('hamish  new current date ' + int + " " + current_date);
        
        var formatEndDateStr  = current_date.yyyymmdd();
        
//  console.log('hamish  formatEndDateStr date ' + int + " " + formatEndDateStr);      
        $(this).closest(".field").find(".end-date_field").val(formatEndDateStr);
        
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

Date.prototype.yyyymmdd = function() {         
                              
      var yyyy = this.getFullYear().toString();                                    
      var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based         
      var dd  = this.getDate().toString();             
                          
      return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
 }; 
   