$ ->

  # Binds updateCount to every .char-counter found
  # ----------------------------------------------

  $('.char-counter').each ->
    textarea = $(@).parent().find('textarea')
    counter = @
    textarea.ready -> updateCount(textarea, counter)
    textarea.keyup -> updateCount(textarea, counter)

  # Updates character count and adds .danger-text if over max allowed
  # -----------------------------------------------------------------

  updateCount = (textarea, counter) ->
    if $(textarea).val()?
      max = $(counter).html().split('/')[1]
      count = $(textarea).val().length
      $(counter).text(count+'/'+max)
      $(counter).addClass('danger-text') if count > max
      $(counter).removeClass('danger-text') if count < max
