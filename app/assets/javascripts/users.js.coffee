@select_pic = (uid,url) ->
	$('.social-thumb').css('border','none')
	$('#remote_image_url').val(url)
	$('#'+uid).removeAttr('onclick').unbind().click( -> unselect_pic(uid,url))

@unselect_pic = (uid,url) ->
	$('#remote_image_url').val('')
	$('#'+uid).unbind().click( -> select_pic(uid,url))
	