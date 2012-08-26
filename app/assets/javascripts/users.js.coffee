$ ->

  # popovers
  if $('#popovers').html()
    $('#edit-form input').each    -> initPopover($(this).attr('id')) if !$(this).attr('type').match(/hidden|file|checkbox|submit/)
    $('#edit-form select').each   -> initPopover($(this).attr('id'))
    $('#edit-form textarea').each -> initPopover($(this).attr('id'))

  # image picker
  $('#image-modal .social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

  # fake submit button (because #buttons is outside of the form)
  $('#submit-placeholder').click ->
    $('#edit-form').submit()

  # fake text field (because #text is outside of fields_for :profiles)
  $('#text_placeholder').blur ->
    $('#user_profiles_attributes_0_text').val($(this).val())

  # url helper so http:// is inserted automatically
  $('#url_field input').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('#url_field input').blur -> $(this).val('') if $(this).val() is 'http://'

@initPopover = (id) ->
  cssClass = id.replace('user_', '').replace('profiles_attributes_0_', '').replace('_placeholder', '')
  $("a.#{cssClass}").popover()
  $('#'+id).focus -> $("a.#{cssClass}").popover('show')
  $('#'+id).blur -> $("a.#{cssClass}").popover('hide')

# selects the clicked pic, unselects others, and fills #remote_image_url appropriately
@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is $('#auth_'+authId+'_image_url').html() then '' else $('#auth_'+authId+'_image_url').html()
  $('.social.pic.selected').each -> $(this).toggleClass('selected') if $(this).attr('id') isnt imageId
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)