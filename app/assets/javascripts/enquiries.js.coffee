# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#res_select').each (i, e) =>
    select = $(e)
    options =
      placeholder: select.data('placeholder')
      minimumInputLength: 1
      
    if select.hasClass('ajax') # only add ajax functionality if this class is present
      options.ajax =
        url: select.data('source')
        dataType: 'json'
        data: (term, page) ->
          q: term
          page: page
          per: 25
        results: (data, page) ->
          results: data.searchSet
          more: data.total > (page * 25) # adding the more: option enables infinite scrolling (select2 will load more content if available)
          
          
          initSelection: (e, callback) ->
          #elementText = $(e).attr("data-init-text")
          callback term: elementText
          return  
        
      options.dropdownCssClass = "bigdrop"
    select.select2(options)