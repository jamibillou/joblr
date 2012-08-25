$ ->
  $('.social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

  $('#submit-placeholder').click ->
    $('#edit-form').submit()

  $('#text_placeholder').blur ->
    $('#user_profiles_attributes_0_text').val($(this).val())

  $('#url_field input').focus -> $(this).val('http://') unless $(this).val() isnt ''
  $('#url_field input').blur -> $(this).val('') if $(this).val() is 'http://'

@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is $('#auth_'+authId+'_image_url').html() then '' else $('#auth_'+authId+'_image_url').html()
  $('.social.pic.selected').each -> $(this).toggleClass('selected') if $(this).attr('id') isnt imageId
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)