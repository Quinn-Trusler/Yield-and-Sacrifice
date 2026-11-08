extends Control

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_Decrease}
var choice_name
var chain_id : int
var gold_owned : int
var cost : int

var BUTTON_DOWN_OFFSET = 1
var tooExpensiveParticle_scene = preload("res://scenes/godchoice/too_expensive_particle.tscn")

# So that I don't need to make them invisible in the editor
func set_all_buttons_invisible():
	$ChooseButton.visible = false
	$TooExpensiveButton.visible = false
	$BuyButton.visible = false
	$GoldImg.visible = false
	$Cost.visible = false

func get_image(c_name : String, choice) -> Texture2D:
	if not "img" in choice or choice["img"] == "icon_img":
		if choice["type"] == GLOBALCONSTS.GOD_REWARD_TYPES.Item:
			return load(GLOBALCONSTS.ITEMS_FOLDER + GLOBALCONSTS.ITEM_DEF[c_name]["img"] + GLOBALCONSTS.IMG_EXTENSION)
		if choice["type"] == GLOBALCONSTS.GOD_REWARD_TYPES.Placement:
			return load(GLOBALCONSTS.ICON_IMAGE_FOLDER + GLOBALCONSTS.BUILDING_DEF[c_name]["icon_img"] + GLOBALCONSTS.IMG_EXTENSION)
	return load(choice["img"])
		
	

func initialize(c_name,choice,gold_num : int, chain_i : int = -1):
	#$Name.scale = Vector2(0.5,0.5)
	choice_name = c_name
	$Sprite2D.texture = get_image(c_name, choice)
	$Name.text = choice["title"]
	create_description(c_name,choice)
	chain_id = chain_i
	gold_owned = gold_num
	
	set_all_buttons_invisible()
	if "cost" in choice:
		cost =  choice["cost"]
		$Cost.text = str(cost)
		$GoldImg.visible = true
		$Cost.visible = true
		if cost > gold_owned:
			$TooExpensiveButton.visible = true
		else:
			$BuyButton.visible = true
	else:
		$ChooseButton.visible = true
	
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

func _on_choose_button_pressed() -> void:
	get_parent().get_parent().get_parent().god_choice_chosen(choice_name, chain_id)
	
func _on_buy_button_pressed() -> void:
	get_parent().get_parent().get_parent().god_choice_chosen(choice_name, chain_id, cost)

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
