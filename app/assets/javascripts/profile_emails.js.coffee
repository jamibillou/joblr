$ ->

  # New profile email form
  # ----------------------

  $('#new_profile_email').bind('ajax:beforeSend', -> $('#new_profile_email #loader').show())

  $('#new_profile_email').bind('ajax:success', (evt, data, status, xhr) -> location.reload())

  $('#new_profile_email').bind('ajax:error', (evt, xhr, status) ->
    $('#new_profile_email #loader').hide()
    $('#profile-email-error').text(xhr.responseText)
    $('#profile-email-error').show() unless $('#profile-email-error').is(':visible'))
