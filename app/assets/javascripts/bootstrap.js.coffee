jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('input.typeahead').typeahead()
  $('.datepicker').datepicker().on 'changeDate', (ev) ->
    $(@).datepicker('hide')