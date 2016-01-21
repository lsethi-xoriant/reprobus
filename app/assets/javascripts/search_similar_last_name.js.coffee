$(document).ready ->
  $('#enquiry_customers_attributes_0_last_name').on 'keyup', (e) ->
    $('table.tableSection > tbody > tr').remove()
    last_name = e.target.value
    if last_name.length > 2
      console.log last_name
      $.ajax(
        url: '/searches/similar_last_names'
        data: { q: last_name }
        context: document.body).done (response) ->
          items = response.items
          if items.length > 0
            for i in items
              $('table.tableSection > tbody').append("
                <tr>
                  <td>#{i.first_name}</td>
                  <td>#{i.last_name}</td>
                  <td>#{i.enquiries}</td>
                  <td>#{i.itineraries}</td>
                </tr>
              ")


