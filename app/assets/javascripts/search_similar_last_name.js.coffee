$(document).on 'keyup', "[id^=enquiry_customers_attributes_][id$=_last_name]", (e) ->
  last_name = e.target.value
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
                <td><a href=#{link}>#{i.id}</a></td>
                <td>#{i.first_name}</td>
                <td>#{i.last_name}</td>
                <td>#{i.enquiries}</td>
                <td>#{i.itineraries}</td>
              </tr>
            ")


