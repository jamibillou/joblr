$ ->
  $('.social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

  $('#submit-placeholder').click ->
    $('#edit-form').submit()

  $('#text_placeholder').blur ->
    $('#user_profiles_attributes_0_text').val($(this).val())

@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is '' then $('#auth_'+authId+'_image_url').html() else ''
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)