$ ->

  # New profile email preview button
  # --------------------------------

  $('#buttons .btn-preview').click -> togglePreview()

  # New profile email form
  # ----------------------

  $('#new_profile_email').bind('ajax:beforeSend', -> $('#new_profile_email #loader').show())

  $('#new_profile_email').bind('ajax:success', (evt, data, status, xhr) -> location.reload())

  $('#new_profile_email').bind('ajax:error', (evt, xhr, status) ->
    $('#new_profile_email #loader').hide()
    $('#profile-email-error').text(xhr.responseText)
    $('#profile-email-error').show() unless $('#profile-email-error').is(':visible'))


# Show/hide the full profile email
# --------------------------------

togglePreview = ->
  $('.hidden-preview').each ->
    if $(@).is(':visible')
      $(@).addClass('hidden')
      $('#buttons i').removeClass('icon-eye-close').addClass('icon-eye-open')
      $('#buttons .btn-preview').removeClass('active')
      $('#inputs').show()
    else
      $('#application_text').html($('#profile_email_text').val())
      $(@).removeClass('hidden')
      $('#buttons i').removeClass('icon-eye-open').addClass('icon-eye-close')
      $('#buttons .btn-preview').addClass('active')
      $('#inputs').hide()