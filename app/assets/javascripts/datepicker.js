$(document).ready(function () {
  $(".tags").select2({ tags:[] });

  $('.date').datetimepicker({
    pickTime: false
    });
  
  $("#datetimepicker1").on("dp.change",function (e) {
    $('#datetimepicker2').data("DateTimePicker").setMinDate(e.date);
    });
  $("#datetimepicker2").on("dp.change",function (e) {
    $('#datetimepicker1').data("DateTimePicker").setMaxDate(e.date);
    });

 });

