$ ->
	$('#comments-header').on "click", ->
		$('#comments').fadeToggle()
		setTimeout (->
			$('#comment_body').focus()
			return
		),0 

$ ->
	$('#comments-basement').on "click", ->
		$('#comments').fadeToggle()

$ -> 
	$('#comment_char_remains').text 'Осталось 140 символов'

$ ->
	$('#comment_body').keyup (e) ->
	  tval = $('#comment_body').val()
	  tlength = tval.length
	  set = 140
	  remain = parseInt(set - tlength)
	  $('#comment_char_remains').text 'Осталось ' + remain + ' символов'
	  if remain <= 0 and e.which != 0 and e.charCode != 0
	    $('#comment_body').val tval.substring(0, tlength - 1)
	  return
