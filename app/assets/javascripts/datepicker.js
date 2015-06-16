$(function() {
  // Pikadate datepicker
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 5, // Creates a dropdown of 5 years to control year
    formatSubmit: 'yyyy-mm-dd',
    format: 'yyyy-mm-dd',
    min: new Date(),
    hiddenSuffix: ''
  });   
});