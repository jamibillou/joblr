$ ->

  # New sharing email form
  # ----------------------

  $('#new_sharing_email').bind('ajax:beforeSend', -> $('#new_sharing_email #loader').show())

  $('#new_sharing_email').bind('ajax:success', (evt, data, status, xhr) -> location.reload())

  $('#new_sharing_email').bind('ajax:error', (evt, xhr, status) ->
    $('#new_sharing_email #loader').hide()
    $('#sharing-email-error').text(xhr.responseText)
    $('#sharing-email-error').show() unless $('#sharing-email-error').is(':visible'))
