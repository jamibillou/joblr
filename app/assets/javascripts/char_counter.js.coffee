$ ->
  # Character counter pre-load
  # --------------------------

  $('.text-char-counter').each -> 
    textarea = $(@).next('textarea')
    counter = @
    textarea.ready -> updateCharCounter(textarea,counter)
    textarea.keyup -> updateCharCounter(textarea,counter)

  # Checks what's in the given textarea and updates the corresponding character counter
  # ----------------------------------------------------------------------------------

  updateCharCounter = (textarea,counter) ->
    if $(textarea).val()?
      max = $(counter).html().split('/')[1]
      count = $(textarea).val().length
      $(counter).text(count+'/'+max)
      $(counter).addClass('danger-text') if count > max
      $(counter).removeClass('danger-text') if count < max