$ ->

	# New profile email preview button
	# --------------------------------

  $('#preview').click -> togglePreview()

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
	  	$('#icon-preview').removeClass('icon-eye-close').addClass('icon-eye-open')
	  else
	  	$(@).removeClass('hidden')
	  	$('#icon-preview').removeClass('icon-eye-open').addClass('icon-eye-close')