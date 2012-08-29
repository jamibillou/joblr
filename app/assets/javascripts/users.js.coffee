$ ->

  # popovers
  if $('#popovers').html()
    $('#edit-form input').each    -> initPopover($(this).attr('id')) if !$(this).attr('type').match(/hidden|file|checkbox|submit/)
    $('#edit-form select').each   -> initPopover($(this).attr('id'))
    $('#edit-form textarea').each -> initPopover($(this).attr('id'))

  # image picker
  $('#image-modal .social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

  # placeholders
  $('#submit-placeholder').click ->
    # port value from #text_placeholder to #hidden_text
    $('#hidden-text').val($('#text_placeholder').val())
    # submit edit-form
    $('#hidden-submit').click()

  # port field_with_errors from #hidden_text to #text_placeholder
  if $('.field_with_errors #hidden-text').html() isnt null
    addFieldWithErrors('text-container')

  # url helper so http:// is inserted automatically
  $('#url_field input').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('#url_field input').blur -> $(this).val('') if $(this).val() is 'http://'

@initPopover = (id) ->
  cssClass = id.replace('user_', '').replace('_placeholder', '')
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

# adds <div class='field_with_errors'> around what's in the given div
@addFieldWithErrors = (id) ->
  field = $('#'+id).html()
  $('#'+id).html("<div class='field_with_errors'>#{field}</div>")