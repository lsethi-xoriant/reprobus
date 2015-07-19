/*This file is for the itinerary and itinerary templates pages                                   */
/*It relies on the sortable.js plug in, Coccoon gem hooks, and the select2 search products js    */
$(document).ready(function() {

  // set up insert function on both pages, so can insert rows where we decide
  $("#itinerary_infos a.add_fields").
    data("association-insertion-method", 'before').
    data("association-insertion-node", '#addNestedAboveHere');
  
  $("#itinerary_template_infos a.add_fields").
    data("association-insertion-method", 'before').
    data("association-insertion-node", '#addNestedAboveHere');
    
  // when click insert button, call cocoon insert btn.  
  $('.insertItineraryBtn').on('click', function(e) {
    // move div placeholder that determines where insert happens, then call click. 
    $(this).closest(".nested-fields").after($("#addNestedAboveHere").detach());
    $('.add_fields').click();
  });
  
  if ($('#itinerary_template_infos').length || $('#itinerary_infos').length) {
    // only want this behaviour on itinerary screens. - clearing & setting seach values on selecting of other conditions. 
    $('.type-itineraries').on('change', function(e) {
      $(this).closest(".row").find(".select2-products").val(null).trigger("change"); 
      $(this).closest(".row").find(".itinerary-number-days").val("0");
      $(this).closest('.field').find(".product_details").text("");
      $(this).closest('.field').find(".cruise-info").hide();
      $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
    });
    
    //$('.select2-countries').on('change', function(e) {
      //MOVED TO search_countries.js as seems better place for code, so it works across all of app. 
    //});
  }
  
  sort_itinerary_items();  // sorts table and sets up intial pos numbers
  
  // set labels to active in these containers as we want the to look small
  reset_material_active_labels('#itinerary_template_infos'); 
  reset_material_active_labels('#itinerary_infos');
    
  $('.sortable').sortable().bind('sortupdate', function(e, ui) {
    set_sort_positions_and_dates();   // set positions if any resort occurs.
  });
  
     
  /* JS hooks to update sortable elements   */
  
  $('#itinerary_template_infos').on('cocoon:after-remove', function() {   // this container is on itinerary new form
    set_sort_positions_and_dates();
  });

  $('#itinerary_infos').on('cocoon:after-remove', function() {   // this container is on itinerary new form
console.log("doing remove");  
    set_sort_positions_and_dates();
  });
  
  $('#itinerary_template_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    initialise_common_itineary_elements(insertedItem);
  });
  
  $('#itinerary_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    initialise_common_itineary_elements(insertedItem);

    // reinit Pikadate datepicker
    $('.datepicker .start').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 5, // Creates a dropdown of 15 years to control year
      formatSubmit: 'yyyy-mm-dd',
      format: 'yyyy-mm-dd',
      min: new Date(),
      hiddenSuffix: ''
    });
  });
  
  $('#itinerary_start_date').on('change', function(e, insertedItem) { 
    set_sort_positions_and_dates();
  });
  
  $('.itinerary-number-days').on('change', function(e, insertedItem) { 
    set_sort_positions_and_dates();
  });
  
  $(".itinerary_form").submit(function(e) {
    var valerror = false;
    var valmsg = "";
    $(".itinerary-number-days").each(function() {
      var numdays = $(this).val();
      $(this).removeClass("invalid");
      if (!$.isNumeric(numdays) || parseInt(numdays) < 0) {
        valerror = true;
        valmsg = "All Itinerary legs must have number of days entered (or set to zero)";
        $(this).addClass("invalid");
      }
    });
    
    if (valerror){
      toastr.warning(valmsg);
      e.preventDefault();
    }
  });
  
  $('#insert_template_OK').on('click', function(e) { 
    var template = $("#insert_template_container").find('.select2-itinerary_templates').val();
    var postition = $("#insert_template_container").find('.position-insert-itineraries').find("option:selected").text();
    
//console.log("pos= " + postition + "  temp= " + template) ;   
    if ($.isNumeric(template) && $.isNumeric(postition)){
      //submit form
      toastr.info("Please wait will template is inserted");
      $('.itinerary_submit_btn').click();
      $(".loading").show();  //show spinner if uploading a file.
    } else {
      toastr.warning("Template & postion must be selected to insert template!");      
    }
  });   
});

/* JS hooks to update sortable elements   */

function sort_itinerary_items(){
  set_sort_positions_and_dates();

  // call sortable on our div with the sortable class
  $('.sortable').sortable({
    items: '.nested-fields'
    // items: ':not(.nosort)'  - this was for testing grouping items. 
  });
}
 
function set_sort_positions_and_dates(){
  // loop through and update position fields
  var int = 0;
  $('.iti_position_field').each(function(i){
    if ($(this).closest('.nested-fields').is(":visible")){int++; $(this).val(int);} //non visible will be marked for deletion
  });
  int = 0;
  $('.iti_postion_number').each(function(i){
    if ($(this).closest('.nested-fields').is(":visible")){int++; $(this).text(int);} //non visible will be marked for deletion
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
    int = 0;

    $('#itinerary_infos').find('.datepicker').each(function(i){
//int ++;
//console.log('hamish current_date in loop  ' + int + " " + current_date);

      // only do for visible elements (hidden element will have been marked for deletion)
      if ($(this).closest('.nested-fields').is(":visible")){  
        var picker = $(this).pickadate().pickadate('picker');
        picker.set('select', current_date);
        
        var num_days = $(this).closest(".field").find(".itinerary-number-days").val();
       
        if (num_days > 0){
//   console.log('hamish num days  ' + int + " " + num_days)
          current_date.setDate(current_date.getDate() + parseInt(num_days));
        }
        
//   console.log('hamish  new current date ' + int + " " + current_date);
        var formatEndDateStr  = current_date.yyyymmdd();
        
//  console.log('hamish  formatEndDateStr date ' + int + " " + formatEndDateStr);      
        $(this).closest(".field").find(".end-date_field").val(formatEndDateStr);
      }
    });
  }
}

function initialise_common_itineary_elements(insertedItem){
  initProductSelect2();  // re-init product search dropdowns as new ones have been added
  initDestinationSelect2();
  initCountrySelect2();
  initSupplierSelect2();
  insertedItem.find(".type-itineraries").val("Type").material_select();
  sort_itinerary_items();
  reset_material_active_labels('#itinerary_infos');
  reset_material_active_labels('#itinerary_template_infos');
  $('.modal-trigger').leanModal();
  $('.tooltipped').tooltip({delay: 50}); 
  
  insertedItem.find(".type-itineraries").on('change', function(e) {
    $(this).closest(".row").find(".select2-products").val(null).trigger("change"); 
    $(this).closest(".row").find(".itinerary-number-days").val("0");
    $(this).closest('.field').find(".product_details").text("");
    $(this).closest('.field').find(".cruise-info").hide();
    $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
  });   
  
  $('.itinerary-number-days').on('change', function(e, insertedItem) { 
    set_sort_positions_and_dates();
  });      
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

/*JS override on date. this is to get datepicker and calculating dates working properly */
Date.prototype.yyyymmdd = function() {         
  var yyyy = this.getFullYear().toString();                                    
  var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based         
  var dd  = this.getDate().toString();             
                      
  return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
}; 

 