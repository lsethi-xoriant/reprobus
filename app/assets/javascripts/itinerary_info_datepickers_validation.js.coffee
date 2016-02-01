class @ItineraryInfosDatesValidator
  constructor: ->
    @itinerary_start_date = $('#itinerary_start_date').prop('value')
    @start_dates = $("[id^=itinerary_itinerary_infos_attributes_][id$=_start_date]")

    $('#dates_validation_message').css('display', 'none')

    self = this
    @start_dates.each (index) ->
      current_element = $(this)
      current_element_date = current_element.prop('value')

      current_element.removeClass('invalid')

      self.validateFirstEqualToStart(current_element, current_element_date, index)
      self.validateCurrentIsAfterStart(current_element, current_element_date, index)
      self.validateCurrentIsAfterPrevious(current_element, current_element_date, index)
      self.validateCurrentIsBeforeCurrentEnd(current_element, current_element_date, index)

  # start date of first element should be equal to start date
  validateFirstEqualToStart: (current_element, current_element_date, index) =>
    if (index == 0)
      if current_element_date != @itinerary_start_date
        @validationFailed(current_element)

  # compare with start date
  validateCurrentIsAfterStart: (current_element, current_element_date, index) =>
    if Date.parse(current_element_date) < Date.parse(@itinerary_start_date)
      @validationFailed(current_element)

  # compare with previous element
  validateCurrentIsAfterPrevious: (current_element, current_element_date, index) =>
    if (index > 0)
      previous_element = @start_dates.eq(index - 1)
      previous_element_date = previous_element.prop('value')
      if Date.parse(current_element_date) < Date.parse(previous_element_date)
        @validationFailed(current_element)

  # compare with end_date
  validateCurrentIsBeforeCurrentEnd: (current_element, current_element_date, index) =>
    end_date_id = '#itinerary_itinerary_infos_attributes_' + index + '_end_date'
    end_date_element = $(end_date_id)
    end_date_element.removeClass('invalid')
    end_date_date = end_date_element.prop('value')
    if Date.parse(current_element_date) > Date.parse(end_date_date)
      @validationFailed(end_date_element)

  # what to do if validation fails
  validationFailed: (failed_element) =>
    failed_element.addClass('invalid')
    $('#dates_validation_message').css('display', 'block')

$(document).ready ->

  if window.location.pathname.match(/\/itineraries\/\d+\/edit/)
    # validation on Edit Itinerary page load
    new ItineraryInfosDatesValidator()

    # validation on Itinerary start date change
    $(document).on 'change', '#itinerary_start_date', (e) -> 
      new ItineraryInfosDatesValidator()

    # validation on any Trip Details start date change
    $("[id^=itinerary_itinerary_infos_attributes_][id$=_start_date]").bind 'change', ->
      new ItineraryInfosDatesValidator()

    # validation on any Trip Details end date change
    $("[id^=itinerary_itinerary_infos_attributes_][id$=_end_date]").bind 'change', ->
      new ItineraryInfosDatesValidator()

    # validation on deletion of Trip Detail
    $(document).on 'click', '#delete-itinerary-infos', (e) ->
      new ItineraryInfosDatesValidator()

    # validation on changing position of Trip Detail (Igor's feature)
    $(document).on 'click', '#move-itinerary-infos', (e) ->
      new ItineraryInfosDatesValidator()

    # validation on dragging/dropping of Trip Detail
    $('.sortable').sortable().bind 'sortupdate', (e, ui) ->
      new ItineraryInfosDatesValidator()

    # validation on adding new Trip Detail
    $(document).on 'click', '#add_new_trip_detail', (e) ->
      new ItineraryInfosDatesValidator()
