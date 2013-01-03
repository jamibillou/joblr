$ ->

  # Placeholders
  # ------------

  $('#submit-placeholder').click -> $('#hidden-submit').click()


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


  # Popovers
  # --------

  $('.edit_user a.help').each -> $(@).popover('placement': 'right')

  # Tooltips
  # --------

  $('[rel=tooltip]').tooltip()


  # Image picker
  # ------------

  $('#image-modal .social.pic').each -> $(@).click -> toggleAuthImage($(@).attr('id'))
  $('#image-modal .modal-footer a.btn-primary').click -> closeImageModal()


  # Social urls
  # -----------

  $('#social-url-triggers .btn').each -> $(@).click -> toggleSocialUrl($(@).attr('id').replace('trigger', 'field'))
  $('#social-url-fields div').each -> $(@).children().first().show() if $(@).hasClass('field_with_errors')



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


# Replaces the profile pic with default_user.jpg if "delete" was checked, closes the modal then
# ---------------------------------------------------------------------------------------------

closeImageModal = ->
  $('#profile-picture').attr('src', '../../assets/default_user.jpg') if $('#user_remove_image').is(':checked')
  $('#image-modal').modal('hide')


# Reveals the given social-url field and hides the others
# -------------------------------------------------------

toggleSocialUrl = (id) ->
  $('#social-url-fields input').each ->
    if $(@).attr('id') is id
      unless $(@).is(':visible')
        $(@).show()
        $(@).parent().parent().show() unless $(@).parent().parent().is(':visible')
    else
      $(@).hide() if $(@).is(':visible')

