extends TextureButton


var item_name : String
signal item_button_mouse_entered(item_name)
signal item_button_mouse_exited(item_name)
signal item_button_pressed(item_name)


func set_item_name(i_name) -> void:
	item_name = i_name


func _on_mouse_entered() -> void:
	item_button_mouse_entered.emit(position, item_name)


func _on_mouse_exited() -> void:
	item_button_mouse_exited.emit(position,item_name)


func _on_pressed() -> void:
	item_button_pressed.emit(position,item_name)
