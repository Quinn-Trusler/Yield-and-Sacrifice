extends Control


var choice_name

func initialize(c_name,choice):
	choice_name = c_name
	$TextureButton.texture_normal = load(choice["img"])
	

func _on_texture_button_pressed() -> void:
	get_parent().get_parent().god_choice_chosen(choice_name)
