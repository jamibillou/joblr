jQuery ->
	$('#show_email').click( -> $('#email_form').show())
	$('#send_email').click( -> send_email())

@select_pic = (uid,url,urlThumb) ->
	$('.social-thumb').removeClass('selected')
	$('#'+uid).addClass('selected')
	$('#remote_image_url').val(url)
	$('#current-thumb').attr('src',urlThumb)
	$('#profile-picture').attr('src',url)

@unselect_pic = (originalUrl) ->
	$('.social-thumb').removeClass('selected')
	$('#remote_image_url').val('')
	$('#current-pic').attr('src',originalUrl)
	$('#profile-picture').attr('src',originalUrl)

@send_email = ->
  $.ajax '/users/share_profile',
  dataType: 'html'
  type: 'POST'
  data: {email:$('#email').val()}