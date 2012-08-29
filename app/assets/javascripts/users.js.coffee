# USERS
# -----

$ ->

  # DOCUMENT READY
  #
  # Placeholders
  # ------------

  $('#submit-placeholder').click ->

    $('#hidden-text').val($('#text_placeholder').val())
    $('#hidden-submit').click()

  # Field with errors
  # MUST be BEFORE Popovers
  # -----------------------

  if $('.field_with_errors #hidden-text').html() isnt null
    addFieldWithErrors('text-container')

  # Popovers
  # MUST be AFTER Field with errors
  # -------------------------------

  if $('#popovers').html()
    $('#edit-form input').each    -> initPopover($(this).attr('id')) unless $(this).attr('type').match(/hidden|file|checkbox|submit/) || $(this).attr('id').match(/hidden/)
    $('#edit-form select').each   -> initPopover($(this).attr('id'))
    $('#edit-form textarea').each -> initPopover($(this).attr('id'))

  # Image picker
  # ------------

  $('#image-modal .social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

  # Url helper
  # ----------

  $('#url_field input').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('#url_field input').blur -> $(this).val('') if $(this).val() is 'http://'


# FUNCTIONS
#
# Attaches popovers to (hidden) links in 'edit'
# ---------------------------------------------

@initPopover = (id) ->
  cssClass = id.replace('user_', '').replace('_placeholder', '').replace('profiles_attributes_0_', '')
  $("a.#{cssClass}").popover('placement': 'left', 'trigger': 'manual')
  $('#'+id).focus -> $("a.#{cssClass}").popover('show')
  $('#'+id).blur -> $("a.#{cssClass}").popover('hide')

# Selects the clicked pic, unselects others, and fills #remote_image_url appropriately
# ------------------------------------------------------------------------------------

@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is $('#auth_'+authId+'_image_url').html() then '' else $('#auth_'+authId+'_image_url').html()
  $('.social.pic.selected').each -> $(this).toggleClass('selected') if $(this).attr('id') isnt imageId
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)

# Adds <div class='field_with_errors'> around what's in the given div
# -------------------------------------------------------------------

@addFieldWithErrors = (id) ->
  field = $('#'+id).html()
  $('#'+id).html("<div class='field_with_errors'>#{field}</div>")