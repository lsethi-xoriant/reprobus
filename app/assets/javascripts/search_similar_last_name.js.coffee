$(document).on 'keyup', "[id^=enquiry_customers_attributes_][id$=_last_name]", (e) ->
  last_name = e.target.value
  # hide table until we have some results present
  $('#similar_last_name').css('display', 'none')
  if last_name.length > 2
    $.ajax(
      url: '/searches/similar_last_names'
      data: { q: last_name }
      context: document.body).done (response) ->
        $('table.tableSection > tbody > tr').remove()
        items = response.items
        if items.length > 0
          for i in items
            link = '/customers/' + i.id + '/edit'
            $('table.tableSection > tbody').append("
              <tr>
                <td>#{i.id}</td>
                <td>#{i.first_name}</td>
                <td><a href=#{link} target='_blank'>#{i.last_name}</a></td>
                <td>#{i.enquiries}</td>
                <td>#{i.itineraries}</td>
              </tr>
            ")

          # we have results, make table visible
          $('#similar_last_name').css('display', 'block')


