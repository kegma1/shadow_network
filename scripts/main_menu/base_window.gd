extends VBoxContainer

func _on_close_button_pressed():
	assert(get_parent() is Control, "this should not happen, the base window should always, be a child of a control node")
	get_parent().queue_free()


func _on_minimise_button_pressed():
	pass # Replace with function body.
