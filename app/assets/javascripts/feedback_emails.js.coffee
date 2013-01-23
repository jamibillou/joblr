$ ->

  # New feedback email form
  # -----------------------

  $('#new_feedback_email').bind('ajax:beforeSend', -> $('#new_feedback_email #loader img').show())

  $('#new_feedback_email').bind('ajax:success', (evt, data, status, xhr) ->
    toggleTextClass('success')
    $('#feedback_email_text').val('')
    $('#feedback-sign').html('<div class="icon-ok-sign success-text"></div>')
    $('#feedback-sign').show() unless $('#feedback-sign').is(':visible'))

  $('#new_feedback_email').bind('ajax:error', (evt, xhr, status) ->
    toggleTextClass('error')
    $('#feedback-sign').html('<div class="icon-remove-sign danger-text"></div>')
    $('#feedback-sign').show() unless $('#feedback-sign').is(':visible'))

toggleTextClass = (status) ->
  $('#new_feedback_email #loader img').hide()
  if status is 'success'
    $('#feedback-sign').removeClass('danger-text') if $('#feedback-sign').addClass('danger-text')
    $('#feedback-sign').addClass('success-text')
  else
    $('#feedback-sign').removeClass('success-text') if $('#feedback-sign').addClass('success-text')
    $('#feedback-sign').addClass('danger-text')
