$(document).ready(function () {
  // default setting for allowing random tags in Select2 boxes
  $(".tags").select2({ tags:[] });
  
  $("#carriers").select2({
              data:[{id:0,text:'Virgin'},{id:1,text:'Air NZ'},{id:2,text:'JetStar'},{id:3,text:'Walking'},{id:4,text:'Ryan Air'}], multiple: true
    });
  
  // date picker main method. works on all text fields with the class='date'
  // documentaion: http://eonasdan.github.io/bootstrap-datetimepicker/
  
//  $('#datetime').datetimepicker({
//     pickTime: false,
//     icons: {
//       time: "fa fa-clock-o",
//       date: "fa fa-calendar",
//       up: "fa fa-arrow-up",
//       down: "fa fa-arrow-down"
//             }
//    });

    
   // $('[data-behaviour~=datepicker]').datepicker();
  //$('.input-group.date').datepicker({
  //  format: "dd/mm/yyyy"
  //});
  
  //$('.input-daterange').datepicker({
  //  format: "dd/mm/yyyy"
  //});
    
  // specific code to link date pickers on enquiry pages => so From cannot be > than To etc
//   $("#datetimepicker1").on("dp.change",function (e) {
//     $('#datetimepicker2').data("DateTimePicker").setMinDate(e.date);
//     });
//   $("#datetimepicker2").on("dp.change",function (e) {
//     $('#datetimepicker1').data("DateTimePicker").setMaxDate(e.date);
//     });

  });

