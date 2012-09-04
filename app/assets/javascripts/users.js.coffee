$ ->

  # Placeholders
  # ------------

  $('#submit-placeholder').click ->
    $('#hidden-text').val($('#text_placeholder').val())
    $('#hidden-submit').click()


  # Field with errors
  # MUST be BEFORE Popovers & Onboarding scripts
  # --------------------------------------------

  if $('.field_with_errors #hidden-text').html() isnt undefined
    addFieldWithErrors('text-container')

  # Url
  # MUST be BEFORE Popovers & Onboarding scripts
  # --------------------------------------------

  $('.edit_user input.url').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('.edit_user input.url').blur -> $(this).val('') if $(this).val() is 'http://'

  # Popovers & Onboarding
  # MUST be AFTER field with errors and url scripts
  # -----------------------------------------------

  # FIX ME!
  # turn this mess into one only loop
  if $('#popovers').html()
    $('.edit_user input').each ->
      unless $(this).attr('type').match(/hidden|checkbox|file|submit/) || $(this).attr('id').match(/hidden/)
        initPopover($(this).attr('id'))
        initOnboardingStep($(this).attr('id'))
    $('.edit_user select').each   -> initPopover($(this).attr('id')) and initOnboardingStep($(this).attr('id'))
    $('.edit_user textarea').each -> initPopover($(this).attr('id')) and initOnboardingStep($(this).attr('id'))


  # Image picker
  # ------------

  $('#image-modal .social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))



# Adds <div class='field_with_errors'> around what's in the given div
# -------------------------------------------------------------------

@addFieldWithErrors = (id) ->
  field = $('#'+id).html()
  $('#'+id).html("<div class='field_with_errors'>#{field}</div>")


# Binds popover to given input/textarea
# -------------------------------------

@initPopover = (id) ->
  cssClass = stripId(id)
  $("#popovers a.#{cssClass}").popover('placement': 'left', 'trigger': 'manual')
  $('#'+id).focus -> $("a.#{cssClass}").popover('show')
  $('#'+id).blur -> $("a.#{cssClass}").popover('hide')


# Binds onboarding step to given input/textarea
# ---------------------------------------------

@initOnboardingStep = (id) ->
  cssClass = stripId(id)
  toggleOnboardingStep(id) if $('#'+id).val() isnt ''
  $('#'+id).blur ->
    toggleOnboardingStep(id) if $(this).val() isnt '' and !$("#onboarding .#{cssClass}").hasClass('checked') or $(this).val() is '' and $("#onboarding .#{cssClass}").hasClass('checked')

@toggleOnboardingStep = (id) ->
  cssClass = stripId(id)
  unless $('#'+id).parent().hasClass('field_with_errors')
    $("#onboarding .#{cssClass}").toggleClass('checked')
    $("#onboarding .#{cssClass} div").toggleClass('icon-check-empty')
    $("#onboarding .#{cssClass} div").toggleClass('icon-check')


# Strips id off unecessary crap, returns the CSS class we use in _edit_popovers and _edit_onboarding partials
# -----------------------------------------------------------------------------------------------------------

@stripId = (id) -> id.replace('user_', '').replace('_placeholder', '').replace('profiles_attributes_0_', '')


# Selects the clicked pic, unselects others, and fills #remote_image_url appropriately
# ------------------------------------------------------------------------------------

@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is $('#auth_'+authId+'_image_url').html() then '' else $('#auth_'+authId+'_image_url').html()
  $('.social.pic.selected').each -> $(this).toggleClass('selected') if $(this).attr('id') isnt imageId
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)