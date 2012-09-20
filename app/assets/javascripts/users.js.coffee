$ ->

  # Placeholders
  # ------------

  $('#submit-placeholder').click ->
    $('#hidden-text').val($('#text_placeholder').val())
    $('#hidden-submit').click()


  # Field with errors
  # -----------------

  if $('.field_with_errors #hidden-text').html() isnt undefined
    addFieldWithErrors('text-container')


  # URLs
  # ----

  $('.edit_user input.url').focus -> $(@).val('http://') unless $(@).val() isnt ''
  $('.edit_user input.url').blur -> $(@).val('') if $(@).val() is 'http://'

  $('#twitter-url-field').focus -> $(@).val('http://twitter.com/') unless $(@).val() isnt ''
  $('#twitter-url-field').blur -> $(@).val('') if $(@).val() is 'http://twitter.com/'

  $('#linkedin-url-field').focus -> $(@).val('http://linkedin.com/') unless $(@).val() isnt ''
  $('#linkedin-url-field').blur -> $(@).val('') if $(@).val() is 'http://linkedin.com/'

  $('#facebook-url-field').focus -> $(@).val('http://facebook.com/') unless $(@).val() isnt ''
  $('#facebook-url-field').blur -> $(@).val('') if $(@).val() is 'http://facebook.com/'

  $('#google-url-field').focus -> $(@).val('http://profiles.google.com/') unless $(@).val() isnt ''
  $('#google-url-field').blur -> $(@).val('') if $(@).val() is 'http://profiles.google.com/'


  # Character counter
  # -----------------
  #
  # TO DO
  # make @ reusable everywhere (1 single function that calls those 2 lines
  # and also adds the character counter in the html (after <small> or <label>)
  #
  $('#text_placeholder').ready -> updateCharCounter('text_placeholder', 140)
  $('#text_placeholder').keyup -> updateCharCounter($(@).attr('id'), 140)


  # Popovers
  # --------

  $('.edit_user a.help').each -> $(@).popover('placement': 'right')


  # Image picker
  # ------------

  $('#image-modal .social.pic').each -> $(@).click -> toggleAuthImage($(@).attr('id'))
  $('#image-modal .modal-footer a.btn-primary').click -> closeImageModal()


  # Social sharing popup
  # --------------------
  $('ul.dropdown-menu#share .social').each -> $(@).click -> openPopup(@href, @innerHTML)


  # Social urls
  # -----------

  $('#social-url-triggers .btn').each -> $(@).click -> toggleSocialUrl($(@).attr('id').replace('trigger', 'field'))
  $('#social-url-fields div').each -> $(@).children().first().show() if $(@).hasClass('field_with_errors')



# Adds <div class='field_with_errors'> around what's in the given div
# -------------------------------------------------------------------

addFieldWithErrors = (id) ->
  field = $('#'+id).html()
  $('#'+id).html("<div class='field_with_errors'>#{field}</div>")


# Selects the clicked pic, unselects others, fills #remote_image_url appropriately and replaces profile pic
# ---------------------------------------------------------------------------------------------------------

toggleAuthImage = (id) ->
  authId = id.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is $('#auth_'+authId+'_image_url').html() then '' else $('#auth_'+authId+'_image_url').html()
  $('.social.pic.selected').each -> $(@).toggleClass('selected') unless $(@).attr('id') is id
  $('#'+id).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)
  $('#profile-picture').attr('src', $('#'+id).attr('src'))
  $('#user_remove_image').attr('checked', false) if $('#user_remove_image').is(':checked')


# Replaces the profile pic (back to default) if "delete" was checked and closes the modal
# ---------------------------------------------------------------------------------------

closeImageModal = ->
  $('#profile-picture').attr('src', '../../assets/default_user.jpg') if $('#user_remove_image').is(':checked')
  $('#image-modal').modal('hide')


toggleSocialUrl = (id) ->
  $('#social-url-fields input').each ->
    if $(@).attr('id') is id
      unless $(@).is(':visible')
        $(@).show()
        $(@).parent().parent().show() unless $(@).parent().parent().is(':visible')
    else
      $(@).hide() if $(@).is(':visible')


# Checks what's in the given textarea and updates the corresponding character counter
# ----------------------------------------------------------------------------------

updateCharCounter = (id, max) ->
  counterId = '#'+stripId(id)+'-char-counter'
  if $('#'+id).val()?
    count = $('#'+id).val().length
    $(counterId).text(count+'/'+max)
    $(counterId).addClass('danger-text') if count > max
    $(counterId).removeClass('danger-text') if count < max


# Opens a popup window
# --------------------

openPopup = (href, content) ->
  if content.match(/linkedin/)
    window.open(href, 'popup', 'left=200, top=200, width=550, height=360, toolbar=0, resizable=0, scrollbars=1')
    Analytical.event('Shared profile on LinkedIn')
  else if content.match(/facebook/)
    window.open(href, 'popup', 'left=200, top=200, width=500, height=330, toolbar=0, resizable=0')
    Analytical.event('Shared profile on Facebook')
  else if content.match(/twitter/)
    window.open(href, 'popup', 'left=200, top=200, width=500, height=260, toolbar=0, resizable=0, scrollbars=1')
    Analytical.event('Shared profile on Twitter')
  else if content.match(/google/)
    window.open(href, 'popup', 'left=200, top=200, width=850, height=500, toolbar=0, resizable=0')
    Analytical.event('Shared profile on Google+')
  return false


# Strips id off unecessary crap, returns the CSS class
# ----------------------------------------------------

stripId = (id) -> id.replace('user_', '').replace('_placeholder', '').replace('profiles_attributes_0_', '')
