extends Control

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_Decrease}
var choice_name
var chain_id : int
var gold_owned : int
var cost : int

var BUTTON_DOWN_OFFSET = 1
var tooExpensiveParticle_scene = preload("res://scenes/too_expensive_particle.tscn")

func initialize(c_name,choice, gold_num, chain_i : int = -1):
	choice_name = c_name
	$Sprite2D.texture = load(choice["img"])
	$Name.text = choice["title"]
	cost =  choice["cost"]
	$Cost.text = str(cost)
	gold_owned = gold_num
	create_description(c_name,choice)
	chain_id = chain_i
	if cost > gold_owned:
		$BuyButton.visible = false
		$TooExpensiveButton.visible = true
	
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
	get_parent().get_parent().god_choice_chosen(choice_name, chain_id, cost)

func _on_too_expensive_pressed() -> void:
	#print(choice_name + " To expensive")
	pass

func _on_too_expensive_button_button_down() -> void:
	$Cost.position.y += BUTTON_DOWN_OFFSET
	$GoldImg.position.y += BUTTON_DOWN_OFFSET
	var temp = tooExpensiveParticle_scene.instantiate()
	get_parent().add_child(temp)
	temp.position = get_parent().get_local_mouse_position()
	temp.emitting = true
	
	

func _on_too_expensive_button_button_up() -> void:
	$Cost.position.y -= BUTTON_DOWN_OFFSET
	$GoldImg.position.y -= BUTTON_DOWN_OFFSET
	
