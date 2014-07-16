// $(document).ready(function() {  
//   $('#res_select').each(function() {
//     var url = $(this).data('source'); 
//     console.log(url);
//     var placeholder = $(this).data('placeholder'); 
//     //var saved = jQuery.parseJSON($(this).data('saved'));
//     $(this).select2({
//       minimumInputLength: 2,
//       //multiple: true,
//       placeholder : placeholder,
//       //allowClear: true,
//       ajax: {
//         url: url,
//         dataType: 'json',
//         quietMillis: 500,
//         data: function (term) {
//           return {
//             name: term
//           };
//         },
//         results: function (data) {
//           return {results: data};
//         }
//       },

//       formatResult: function (item, page) {
//         return item.name; 
//       },

//       formatSelection: function (item, page) {
//         return item.name; 
//       },

//       initSelection : function (element, callback) {
//         var elementText;
//         console.log("hi hamish3");
//         elementText = element.attr("data_init_text");
//         return callback({
//           term: elementText
//         });
//       }

//     });
//   });
// });