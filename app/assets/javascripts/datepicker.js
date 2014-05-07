$(document).ready(function () {
  // default setting for allowing random tags in Select2 boxes 
  $(".tags").select2({ tags:[] });

  // date picker main method. works on all text fields with the class='date'
  $('.date').datetimepicker({
    pickTime: false
    });
  
  // specific code to link date pickers on enquiry pages => so From cannot be > than To etc
  $("#datetimepicker1").on("dp.change",function (e) {
    $('#datetimepicker2').data("DateTimePicker").setMinDate(e.date);
    });
  $("#datetimepicker2").on("dp.change",function (e) {
    $('#datetimepicker1').data("DateTimePicker").setMaxDate(e.date);
    });

 });

