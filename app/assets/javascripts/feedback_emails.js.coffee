$ ->

  # New feedback email form
  # -----------------------

  $('#new_feedback_email').bind('ajax:beforeSend', -> $('#new_feedback_email #loader').show())

  $('#new_feedback_email').bind('ajax:success', (evt, data, status, xhr) ->
    toggleTextClass('success')
    $('#feedback_email_text').val('')
    $('#feedback-form-text').text('Thank you!')
    $('#feedback-form-text').show() unless $('#feedback-form-text').is(':visible'))

  $('#new_feedback_email').bind('ajax:error', (evt, xhr, status) ->
    toggleTextClass('error')
    $('#feedback-form-text').text(xhr.responseText)
    $('#feedback-form-text').show() unless $('#feedback-form-text').is(':visible'))

toggleTextClass = (status) ->
  $('#new_feedback_email #loader').hide()
  if status is 'success'
    $('#feedback-form-text').removeClass('danger-text') if $('#feedback-form-text').addClass('danger-text')
    $('#feedback-form-text').addClass('success-text')
  else
    $('#feedback-form-text').removeClass('success-text') if $('#feedback-form-text').addClass('success-text')
    $('#feedback-form-text').addClass('danger-text')
