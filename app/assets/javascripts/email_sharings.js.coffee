$ ->

  # New form
  # --------

  $('#new_email_sharing').bind('ajax:beforeSend', -> $('#new_email_sharing #loader').show())
  $('#new_email_sharing').bind('ajax:success', (evt, data, status, xhr) -> location.reload())
  $('#new_email_sharing').bind('ajax:error', (evt, xhr, status) ->
    $('#new_email_sharing #loader').hide()
    $('#email-sharing-error').text(xhr.responseText)
    $('#email-sharing-error').show() unless $('#email-sharing-error').is(':visible'))