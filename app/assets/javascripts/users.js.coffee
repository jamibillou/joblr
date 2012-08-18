$ ->
  $('.social.pic').each ->
    $(this).click -> toggleAuthImage($(this).attr('id'))

@toggleAuthImage = (imageId) ->
  authId = imageId.match(/\d+/)[0]
  authImageUrl = if $('#remote_image_url').val() is '' then $('#auth_'+authId+'_image_url').html() else ''
  $('#'+imageId).toggleClass('selected')
  $('#remote_image_url').val(authImageUrl)