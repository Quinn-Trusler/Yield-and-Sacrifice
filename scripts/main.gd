extends Node2D



var RNG = RandomNumberGenerator.new()


func _ready():
	
	#create boss
	pass

	#create building
	#$TileMapLayer2.place_building(Vector2(-3,4),"oven")
	#$TileMapLayer2.place_building(Vector2(-1,3),"mill")
	#$TileMapLayer2.place_building(Vector2(0,3),"mushroom_patch")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		$BuildingManager.click_tile()
	
		
func punish():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_punishments()
func reward():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_rewards()
	

	
	
