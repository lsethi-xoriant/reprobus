$(function() {
  // Pikadate datepicker
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 5, // Creates a dropdown of 5 years to control year
    formatSubmit: 'yyyy-mm-dd',
    format: 'dd/mm/yyyy',
//    min: new Date(), took this out, as if we ever go into a historic date it sets it to todays date....
    hiddenSuffix: '',
    onSet: function (e) {
        if (e.select) {this.close();}
    },
   // onFocus: function(event){
    //  event.stopPropagation();
    //}
  }); 

  $('.datepicker-wide-range').pickadate({
    selectMonths: true,
    selectYears: 100,
    formatSubmit: 'yyyy-mm-dd',
    format: 'dd/mm/yyyy',
    max: new Date(2016,1,1),
    hiddenSuffix: '',
    onSet: function (e) {
        if (e.select) {this.close();}
    }
  });   
});
