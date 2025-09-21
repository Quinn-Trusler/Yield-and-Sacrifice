extends Control

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_Decrease}
var choice_name

func initialize(c_name,choice):
	choice_name = c_name
	$TextureButton.texture_normal = load(choice["img"])
	$Name.text = c_name
	create_description(c_name,choice)
#var choices = {"Carrot":{"img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"reward": "carrot","amt" : 1},
#"Farmland":{"img": "res://art/godchoice/farmland.png","text":"default","type": TYPES.Placement,"reward": "farmland"},
#"Burn Land":{"img": "res://art/godchoice/burn_land.png","text":"default","type": TYPES.Destroy_Land,"reward": ["farmland"],"amt": 3}
#}
	
	
func create_description(c_name,choice):
	if choice["text"] == "default":
		var text = "none"
		if choice["type"] == TYPES.Item:
			$Description.text = "Gain "
			if "amt" in choice:
				if choice["amt"]>1:
					$Description.text += str(choice["amt"]) + " "
				else:
					$Description.text += "a "
			else:
				$Description.text += "a "
			$Description.text += c_name
	else:
		$Description.text = choice["text"]

func _on_texture_button_pressed() -> void:
	get_parent().get_parent().god_choice_chosen(choice_name)



func _on_texture_button_mouse_entered() -> void:
	$Description.visible = true

func _on_texture_button_mouse_exited() -> void:
	$Description.visible = false
