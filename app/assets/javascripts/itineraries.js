/*This file is for the itinerary and itinerary templates pages                                   */
/*It relies on the sortable.js plug in, Coccoon gem hooks, and the select2 search products js    */
$(document).ready(function() {
  
  itinerary_common_controls_init();  

  $(".select2-room-types-noajax").select2();

  if (window.location.pathname.match(/\/itineraries\/\d+\/edit/)) {

    // fill range feature for itenerary infos on edit Itinerary page
    $(document).on('click', '#fill-range-itinerary-infos', function(event) {
      // all checkboxes on page
      checkboxes_array = $('.itinerary-info-checkbox .muli-select-itinerary');

      // indexes of checked checkboxes
      indexes = $.map(checkboxes_array, function(cb, index) {
        if(cb.checked == true) { return index; };
      });

      if (indexes.length >= 2) {
        first_index = indexes[0];
        last_index = indexes.pop();

        // leave checkboxes between first and last checked
        checkboxes_array = checkboxes_array.slice(first_index, last_index+1);

        // check each checkbox in range
        checkboxes_array.each(function(index) {
          if ((index >= first_index) && (index <= last_index)) {
            this.checked = true;
          };
        });
      };
    });

  };
  
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

 $('.start_leg_itinerary, .end_leg_itinerary').on({
    blur: function() {
      var parsedDate = Date.parse( this.value );
      var picker = $(this).closest('.input-field').find('.itinerary_leg_datepicker').pickadate('picker');
      if ( parsedDate ) {
        // need to set this if picker initalised as it keeps a hidden input field which will overwrite our standard text one. 
        if (picker) {picker.set( 'select', [parsedDate.getFullYear(), parsedDate.getMonth(), parsedDate.getDate()] );}
      } else {
        $(this).addClass("invalid"); 
        if (picker) { picker.set( 'clear' );}
      } 
    }
 });

$('.openCalendar').on('click', function(e) {
  var parsedDate = Date.parse($(this).closest('.input-field').find('.itinerary_leg_datepicker').val());
  
  // init picker
  $(this).closest('.input-field').find('.itinerary_leg_datepicker').pickadate({
    editable: true,
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 5, // Creates a dropdown of 15 years to control year
    formatSubmit: 'dd/mm/yyyy',
    format: 'dd/mm/yyyy',
    hiddenSuffix: '', 
    onSet: function (e) {
        if (e.select) {this.close();}
    }
  });  
  
  // set date on picker
  var picker = $(this).closest('.input-field').find('.itinerary_leg_datepicker').pickadate('picker');
  if ( parsedDate ) {
    //alert('ok' + parsedDate);
    picker.set( 'select', [parsedDate.getFullYear(), parsedDate.getMonth(), parsedDate.getDate()] );
    //$(this).removeClass("invalid");
  } else {
    $(this).addClass("invalid");
  }
  
  // now open picker
  if (picker.get('open')) { 
    picker.close();
  } else {
    picker.open();
  }
  
  e.stopPropagation();   
});

  $("#bump_dates_modal_button").on('click',function(){
    var bumpNumDays = $("#bump_days").val();

    if (isNaN(bumpNumDays)){toastr.warning("Value entered is not a valid number!"); return;}
    $(".muli-select-itinerary").each(function(){
      if ($(this).is(":checked")) {
      // start date  
      /* Not using Pickadate now. 
      var start_$input = $(this).closest('.field').find(".start_leg_itinerary").pickadate(),
           start_picker = start_$input.pickadate('picker');
      bump_pickadate_date_to_new_date(start_picker,bumpNumDays,start_picker.get()); 
      // now do end date
      var end_$input = $(this).closest('.field').find(".end_leg_itinerary").pickadate(),
           end_picker = end_$input.pickadate('picker');
      bump_pickadate_date_to_new_date(end_picker,bumpNumDays,end_picker.get());   */
      var  start_date_field = $(this).closest('.field').find(".start_leg_itinerary");
      bump_pickadate_date_to_new_date( start_date_field , bumpNumDays, start_date_field.val() );
      var end_date_field = $(this).closest('.field').find(".end_leg_itinerary");
      bump_pickadate_date_to_new_date(end_date_field , bumpNumDays, end_date_field.val() );
      
      }
    });
    
    $(".loading").show();  //show spinner
    $('.itinerary_submit_btn').click();
  });
  
  function bump_pickadate_date_to_new_date(picker,numdays, dateStr){
      // month is minus one as months are 0-11
      //var current_date = new Date(parseInt(dateStr.substring(0,4),10),parseInt(dateStr.substring(5,7),10)-1,parseInt(dateStr.substring(8,10),10));  
console.log("datestr: " +  dateStr);    
      var current_date = new Date.parse( dateStr ); 
console.log("newdate: " +  current_date);      
      current_date.setDate(current_date.getDate() + parseInt(numdays,10));
      
      var day = ("0" + current_date.getDate()).slice(-2);
      var month = ("0" + (current_date.getMonth() + 1)).slice(-2); 
      
console.log("newdate after add : " +  current_date);        
      //var formatted_date = current_date.getFullYear()+"-"+(month)+"-"+(day) ;
      var formatted_date = (day)+"/"+(month)+"/"+current_date.getFullYear() ;
      $(picker).val(formatted_date);
      
      //picker.set('select', current_date);   - removed as dont want to use pickadate on this screen
  }
  
  
  $("#lockItineraryBtn").on('click', function(e) {
    $(".loading").show();  //show spinner
    $("#itinerary_status").val("Locked");
    $("#itinerary_complete").val("true");
    $('.itinerary_submit_btn').click();
    
  });
  
  $("#unlockItineraryBtn").on('click', function(e) {
    $(".loading").show();  //show spinner
    $("#itinerary_status").val("Unlocked");
    $("#itinerary_complete").val("false");
    $('.itinerary_submit_btn').click();
  });  
  
  $("#toggleShowEditItinerary").on('click', function(e) {
    $('.itinerary_info_bottom_row_edit').toggle();
  });
  
  $("#saveItineraryFabBtn").on('click', function(e) {
    $(".loading").show();  //show spinner
    $('.itinerary_submit_btn').click();
  }); 
  
  if ($('#itinerary_template_infos').length || $('#itinerary_infos').length) {
    // only want this behaviour on itinerary screens. - clearing & setting seach values on selecting of other conditions. 
    $('.type-itineraries').on('change', function(e) {
      $(this).closest(".row").find(".select2-products").val(null).trigger("change"); 

      $(this).closest('.field').find(".product_details").text("");
      $(this).closest('.field').find(".cruise-info").hide();
      $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
      $(this).closest('.field').find(".select2-room-types-noajax").val(null).trigger("change");
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
    set_sort_positions_and_dates();
  });
  
  $('#itinerary_template_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
  
    var prev_value = parseInt(insertedItem.prev().find(".itinerary-days-from-start").val(),10);
    prev_value += parseInt(insertedItem.prev().find(".itinerary-number-days").val(),10);
    if (isNaN(prev_value) == false) {insertedItem.find(".itinerary-days-from-start").val(prev_value); }
    
    itineraryForm_initialise_elements_after_insert(insertedItem);
    
    insertedItem.find('.itinerary-days-from-start').on('change', function(e) { 
      check_days_from_start_seq();
    });    
    
    insertedItem.find('.itinerary-number-days').on('change', function(e) { 
      set_sort_positions_and_dates();
    });
    
    $(insertedItem).find(".itinerary-days-from-start").focus();
  });
  
  $('#itinerary_infos').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
 
    itineraryForm_initialise_elements_after_insert(insertedItem);

/*  REMOVED pikadate as we dont like it on the itienary screen. too annoying...
    // reinit Pikadate datepicker
    $(insertedItem).find('.start_leg_itinerary').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 5, // Creates a dropdown of 15 years to control year
      formatSubmit: 'yyyy-mm-dd',
      format: 'yyyy-mm-dd',
//      min: new Date(),
      hiddenSuffix: ''
    });
    $(insertedItem).find('.end_leg_itinerary').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 5, // Creates a dropdown of 15 years to control year
      formatSubmit: 'yyyy-mm-dd',
      format: 'yyyy-mm-dd',
//      min: new Date(),
      hiddenSuffix: ''
    });  
  
    var prev_$input = insertedItem.prev().find('.end_leg_itinerary').pickadate(),
        prev_picker = prev_$input.pickadate('picker');
    var start_$input = insertedItem.find('.start_leg_itinerary').pickadate(),
        start_picker = start_$input.pickadate('picker');   
    var end_$input = insertedItem.find('.end_leg_itinerary').pickadate(),
        end_picker = end_$input.pickadate('picker');        
        
    bump_pickadate_date_to_new_date(start_picker,0,prev_picker.get());
    bump_pickadate_date_to_new_date(end_picker,0,prev_picker.get());
*/

    insertedItem.find('.start_leg_itinerary').val(insertedItem.prev('.nested-fields').find('.start_leg_itinerary').val());
    insertedItem.find('.end_leg_itinerary').val(insertedItem.prev('.nested-fields').find('.start_leg_itinerary').val());
  
  });


  $(".itinerary_form").submit(function(e) {
    var valerror = false;
//    var valmsg = "";
    var valmessages = [];
    var i = 0;
    
    $(".itinerary-number-days").each(function() {
    // Note: Itinerary Template screen only. 
      i = i + 1;
      var numdays = $(this).val();
      $(this).removeClass("invalid");
      if (!$.isNumeric(numdays) || parseInt(numdays) < 0) {
        valerror = true;
        valmessages.push("Itinerary leg " + i + " must have number of days entered (or set to zero)");
        $(this).addClass("invalid");
      }
    });
    
    $(".itinerary-days-from-start").each(function() {
    // Note: Itinerary Template screen only. 
      i = i + 1;
      var numdays = $(this).val();
      $(this).removeClass("invalid");
      if (!$.isNumeric(numdays) || parseInt(numdays) < 0) {
        valerror = true;
        valmessages.push("Itinerary leg " + i + " must have a days from start entered (or set to zero)");
        $(this).addClass("invalid");
      }
    });
    
    if (valerror){
      $.each(valmessages, function(index, value) {
      toastr.warning(value);
      e.preventDefault();
      });
    }
  });
  
  $('#insert_template_OK').on('click', function(e) { 
    var template = $("#insert_template_container").find('.select2-itinerary_templates').val();
    var postition = $("#insert_template_container").find('.position-insert-itineraries').find("option:selected").text();
    
    if ($.isNumeric(template) && $.isNumeric(postition)){
      //submit form
      toastr.info("Please wait while template is inserted");
      $('.itinerary_submit_btn').click();
      $(".loading").show();  //show spinner if uploading a file.
    } else {
      toastr.warning("Template & postion must be selected to insert template!");      
    }
  });

  $('.modal-footer').on('click', '#request_customer_updates_OK', function(e) {
      e.preventDefault();
      $("#request_customer_updates_form").submit();
    });

  // Copy Itinerary on Edit Itinerary Page
  $('.modal-footer').on('click', '#copy_itinerary_OK', function(e) {
    e.preventDefault();
    $("#copy_itinerary_form").submit();
  });

  // Change dates for Itenirary copy after changing Itenirary date
  $('#itinerary_start_date').on('change', function(e) {
    new_date = $(this).prop('value');
    $("#copy_old_date").attr('value', new_date);
    $("#copy_start_date").pickadate('picker').set('select', new_date, { format: 'yyyy-mm-dd' });
  });

  $('.modal-footer').on('click', '#email_quote_OK', function(e) {
    e.preventDefault();
    confirmed = $(this)[0].dataset.confirmed;
    form_name = JSON.parse(confirmed) ? 'email_confirmed_quote' : 'email_quote';
    $("#" + form_name + "_form").submit();
  });

});

/* JS hooks to update sortable elements   */

function sort_itinerary_items(){
  set_sort_positions_and_dates();

  // call sortable on our div with the sortable class
  $('.sortable').sortable({
    items: '.sortable-item',
    handle: '.sort_itinerary_item_col'
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
  int = 0;
  $('.iti_postion_number_show').each(function(i){
    if ($(this).closest('.nested-fields').is(":visible")){int++; $(this).text(int);} //non visible will be marked for deletion
  });
  
  check_days_from_start_seq();
}

function itineraryForm_initialise_elements_after_insert(insertedItem){
  initProductSelect2();  // re-init product search dropdowns as new ones have been added
  initDestinationSelect2();
  initCountrySelect2();
  initSupplierSelect2();
  insertedItem.find(".select2-room-types-noajax").select2();    
  insertedItem.find(".type-itineraries").val("Type").material_select();
  sort_itinerary_items();
  reset_material_active_labels('#itinerary_infos');
  reset_material_active_labels('#itinerary_template_infos');
  $('.modal-trigger').leanModal();
  $('.tooltipped').tooltip({delay: 50}); 

  insertedItem.find(".itinerary-number-days").val("0");
    
  insertedItem.find(".type-itineraries").on('change', function(e) {
    $(this).closest(".row").find(".select2-products").val(null).trigger("change"); 

    $(this).closest('.field').find(".product_details").text("");
    $(this).closest('.field').find(".cruise-info").hide();
    $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
    $(this).closest('.field').find(".select2-room-types-noajax").val(null).trigger("change");
  });   
  
  insertedItem.find('.itinerary-show-hide-btn').on('click', function(){
    $(this).closest(".field").find('.itinerary_info_bottom_row_edit').toggle();
  });    
  
  // when click insert button, call cocoon insert btn.  
  insertedItem.find('.insertItineraryBtn').on('click', function(e) {
    // move div placeholder that determines where insert happens, then call click. 
    $(this).closest(".nested-fields").after($("#addNestedAboveHere").detach());
    $('.add_fields').click();
  });  
}

function itinerary_common_controls_init(){

  $('.itinerary-show-hide-btn').on('click', function(){
    $(this).closest(".field").find('.itinerary_info_bottom_row_edit').toggle();
  });  
  
  $('.itinerary-days-from-start').on('change', function(e) { 
    check_days_from_start_seq();
  });    

  $('#itinerary_start_date').on('change', function(e) { 
    set_sort_positions_and_dates();
  });
  
  $('.itinerary-number-days').on('change', function(e) { 
    set_sort_positions_and_dates();
  });
  
  $('.itinerary-offset-days').on('change', function(e) { 
    set_sort_positions_and_dates();
  });  
};


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

function check_dates_are_in_seq(){ 
// Note: Itinerary Template screen only. 
  var prevSeq = 0;
  var isOutOfSeq = false;
  $('.itinerary-days-from-start').each(function(){
    $(this).removeClass("invalid");
    if ((prevSeq+1) < $(this).val()){isOutOfSeq = true;}
    if (isOutOfSeq) {$(this).addClass("invalid");}
    prevSeq = $(this).val();
  });
}

function check_days_from_start_seq(){ 
// Note: Itinerary Template screen only. 
  var isOutOfSeq = false;
  var prevNumNights = 0, prevDaysFromStart = 0, days_from_start = 0;
  $('.itinerary-days-from-start').each(function(){
    $(this).removeClass("invalid");
    isOutOfSeq = false;
    days_from_start = $(this).val();
    if (parseInt(prevDaysFromStart) + parseInt(prevNumNights) != parseInt(days_from_start)){isOutOfSeq = true;}
    if (isOutOfSeq) {$(this).addClass("invalid");}
    prevNumNights = parseInt($(this).closest(".field").find(".itinerary-number-days").val());
    prevDaysFromStart = days_from_start;        
  });
}

$(document).on('click', '.itinerary_info_bottom_row_edit .remove_fields.existing', function () {
  updateItineraryImage();
});

document.addEventListener('destinationsChange', function (e) { 
  updateItineraryImage();
}, false);

function updateItineraryImage() {
  destinations = []
  $.each($('.itinerary_info_top_row_edit [aria-labelledby="select2-destination-container"] .select2-selection__rendered'), function (index, entry) {
    destinations.push(entry.textContent);
  });
  selected = $('#itinerary_destinations_select .select-dropdown').val();
  searchDestinationsUrl = '/admin/destinations/search_by_name';
  $.ajax({
    url: searchDestinationsUrl,
    method: 'POST',
    dataType: 'json',
    data: {
      destinations: destinations,
      selected: selected
    },
    cache: false,
    success: function(data) {
      $('#itinerary_destinations_select').html(data.html);
      $('select').not('.disabled').material_select();
    },
    error: function(data) {}
  });
}

var actionElements = [];
$(document).on('change', '.itinerary-info-checkbox .muli-select-itinerary', function(e) {
  setActionElements();
});

var checkedAll = false;
$(document).on('click', '#select-all-itinerary-infos', function(e) {
  e.preventDefault();
  checkedAll = !checkedAll;
  infosElements = $('.itinerary-info-checkbox .muli-select-itinerary');
  $.each(infosElements, function(index, entry) {
    entry.checked = checkedAll;
  });
  setActionElements();
});

var setActionElements = function() {
  checkedElements = $('.itinerary-info-checkbox .muli-select-itinerary:checked');
  actionElements = [];
  if (checkedElements.size() > 0) {
    $.each(checkedElements, function(index, entry) {
      actionElements.push($(entry).parents('.sortable-item')[0]);
    });
    $('.itinerary-infos-action-buttons').show();
  }
  else {
    $('.itinerary-infos-action-buttons').hide();
  }
}

$(document).on('click', '#delete-itinerary-infos', function(e) {
  e.preventDefault();
  $.each(actionElements, function(index, entry) {
    $(entry).find('.remove_fields').click();
    $(entry).hide();
  });

  updateItineraryInfosNumberSelect();
  $('.itinerary-infos-action-buttons').hide();
  $('.sortable').trigger("sortupdate", {});
  actionElements = [];
  checkedAll = false;
});

$(document).on('click', '#move-itinerary-infos', function(e) {
  e.preventDefault();
  postitionNumber = parseInt($('.itinerary-info-position-select .select-dropdown').val());
  if (postitionNumber == $('[data-item-sortable-id]').size() || postitionNumber == 2)
    $(actionElements).insertAfter($('[data-item-sortable-id]')[postitionNumber - 1]);
  else
    $(actionElements).insertBefore($('[data-item-sortable-id]')[postitionNumber - 1]);
  $('.sortable').trigger("sortupdate", {});

  $.each(checkedElements, function(index, entry) {
    $(entry).attr('checked', false);
  });
  updateItineraryInfosNumberSelect();
  $('.itinerary-infos-action-buttons').hide();
  actionElements = [];
  checkedAll = false;
});

var updateItineraryInfosNumberSelect = function() {
  newElementsSize = $('[data-item-sortable-id]:visible').size();
  data = Array.apply(null, { length: newElementsSize }).map(Number.call, Number);
  var s = $("<select id=\"position_to\" name=\"position_to\" />");
  for(var val in data) {
    $("<option />", {value: (val + 1), text: (data[val] + 1)}).appendTo(s);
  }
  $('.itinerary-info-position-select').html(s);
  $('select').not('.disabled').material_select();
}

/*JS override on date. this is to get datepicker and calculating dates working properly */
Date.prototype.yyyymmdd = function() {         
  var yyyy = this.getFullYear().toString();                                    
  var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based         
  var dd  = this.getDate().toString();             
                      
  return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
}; 

/*function recalcDates(){
    // if on itinerary page, need to recalc dates.
  if ($('#itinerary_start_date').length) {
  // NOT DOING THIS ANYMORE - no recalc of dates... is manual  
    if (true) {
      return;
    }
console.log('NOOOOOOOOOOOOOOOOOO!!! - shouldnt be doing this ');  
    var start_$input = $('#itinerary_start_date').pickadate(),
         start_picker = start_$input.pickadate('picker');
         
    var dateStr = start_picker.get();
    
    var yearStr = parseInt(dateStr.substring(0,4));
    var monStr = parseInt(dateStr.substring(5,7));
    var dayStr = parseInt(dateStr.substring(8,10));
    monStr = monStr-1;  // minus one as months are 0-11

    var current_date = new Date(yearStr,monStr,dayStr);
    var latest_date = new Date(yearStr,monStr,dayStr); // keep track of the latest date while iterating
    
    //int = 0;

    //$('#itinerary_infos').find('.datepicker').each(function(i){ //removed to make readonly
    $('#itinerary_infos').find('.start-date_field').each(function(i){
    
//int ++;
//console.log('hamish current_date in loop  ' + int + " " + current_date);

      // only do for visible elements (hidden element will have been marked for deletion)
      if ($(this).closest('.nested-fields').is(":visible")){  

        if (current_date.getTime() > latest_date.getTime()) {
          latest_date = new Date(current_date.getTime()); 
//console.log('latest UPDATED');       
        } 
      
        var num_days = $(this).closest(".field").find(".itinerary-number-days").val();
        var offset_days = $(this).closest(".field").find(".itinerary-offset-days").val();
        offset_days = Math.abs(offset_days);
        //num_days = num_days - offset_days;

        // SET START DATE
        //var picker = $(this).pickadate().pickadate('picker'); //removed to make readonly
        //picker.set('select', current_date);                   //removed to make readonly
        
        if (offset_days == 0){
          $(this).val(latest_date.yyyymmdd());                   //added to make readonly
          current_date = new Date(latest_date.getTime()); 
        } else {
          current_date.setDate(latest_date.getDate() - parseInt(offset_days));
          $(this).val(current_date.yyyymmdd());                   //added to make readonly
        }
       
        // SET END DATE
        if (num_days > 0){
          current_date.setDate(current_date.getDate() + parseInt(num_days));
        }

        var formatEndDateStr  = current_date.yyyymmdd();
//console.log('hamish  formatEndDateStr date ' + int + " " + formatEndDateStr);      
        $(this).closest(".field").find(".end-date_field").val(formatEndDateStr);
      }
    });
  }  
}*/


 
