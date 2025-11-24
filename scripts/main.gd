extends Node2D

var DEVIL_BOSS_SCENE = preload("res://scenes/devil_boss.tscn")

var RNG = RandomNumberGenerator.new()

var mouse_on_mouth = false



func _ready():
	
	#create boss
	var temp = DEVIL_BOSS_SCENE.instantiate()
	add_child(temp)
	temp.attempt_eat_item.connect(_attempt_eat_item)
	
	#create building
	$BuildingManager.last_building = "fishing_spot"
	$TileMapLayer2.set_cell_scene(Vector2(2,-2),2,Vector2.ZERO,GLOBALCONSTS.BUILDING_SCENE_ID)#plant fishing spot
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		$BuildingManager.click_tile()
		
func punish():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_punishments()
func reward():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_rewards()
	
func _attempt_eat_item(on_mouth : bool):
	$ItemManager.mouse_on_mouth = on_mouth
	
	
