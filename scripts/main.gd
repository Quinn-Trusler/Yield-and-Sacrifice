extends Node2D

@export var TMM :Node2D

var RNG = RandomNumberGenerator.new()

@export var DeathScreen :CanvasLayer
func game_over():
	get_parent().game_over()

func _ready():

	#create building
	#TMM.TileLayer2.place_building(Vector2(-3,4),"barrel")
	#TMM.TileLayer2.place_building(Vector2(-4,4),"barrel")
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		$BuildingManager.click_tile()
		
	if Input.is_action_just_pressed("end_round"):
		#$BuildingManager.create_gift("wheat", 1)
		$SacrificeManager.next_round()
		print("End Round Debug pressed")
		
	if Input.is_action_just_pressed("debug"):
		print("Nothing bound to debug key")
		#$BuildingManager.spawn_random_fish()#create_gift("wheat", 2)
		#print("\n---------------------------------\n")
		#$BuildingPlacementManager/ValidBuildingLayer.display_invalid_tiles()
		#$GodChoiceManager.destroy_land($GodChoiceManager.choices["burn land"])
	
		
func punish():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_punishments()
func reward():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_rewards()


func set_round_time(round_time):
	$SacrificeManager.set_round_time(round_time)
	
func set_godchoices(shop, rewards, punishments):
	$GodChoiceManager.set_godchoices(shop, rewards, punishments)
	
func set_tile_layers(tile_layers):
	TMM.set_tile_layers(tile_layers)
	
func set_boss(boss, boss_position):
	$SacrificeManager.set_boss(boss, boss_position)
	
