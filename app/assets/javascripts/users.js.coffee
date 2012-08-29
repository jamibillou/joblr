$ ->

  # Placeholders
  # ------------

  $('#submit-placeholder').click ->
    $('#hidden-text').val($('#text_placeholder').val())
    $('#hidden-submit').click()


  # Field with errors
  # MUST be BEFORE Popovers & Onboarding
  # ------------------------------------

  if $('.field_with_errors #hidden-text').html() isnt undefined
    addFieldWithErrors('text-container')


  # Popovers & Onboarding
  # MUST be AFTER Field with errors
  # -------------------------------

  # FIX ME! clean this mess
  if $('#popovers').html()
    $('#edit-form input').each ->
      unless $(this).attr('type').match(/hidden|checkbox|file|submit/) || $(this).attr('id').match(/hidden/)
        initPopover($(this).attr('id'))
        initOnboardingStep($(this).attr('id'))
    $('#edit-form select').each   -> initPopover($(this).attr('id')) and initOnboardingStep($(this).attr('id'))
    $('#edit-form textarea').each -> initPopover($(this).attr('id')) and initOnboardingStep($(this).attr('id'))


  # Image picker
  # ------------

  $('#image-modal .social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))


  # Url helper
  # ----------

  $('#edit-form input.url').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('#edit-form input.url').blur -> $(this).val('') if $(this).val() is 'http://'



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
  # Initializes onboarding step (if something was submitted)
  toggleOnboardingStep(cssClass) if $('#'+id).val() isnt ''
  # Binds onboarding step
  $('#'+id).blur ->
    toggleOnboardingStep(cssClass) if $(this).val() isnt '' and !$("#onboarding .#{cssClass}").hasClass('checked') or $(this).val() is '' and $("#onboarding .#{cssClass}").hasClass('checked')

@toggleOnboardingStep = (cssClass) ->
  $("#onboarding .#{cssClass}").toggleClass('checked')
  $("#onboarding .#{cssClass}").toggleClass('success-text')
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