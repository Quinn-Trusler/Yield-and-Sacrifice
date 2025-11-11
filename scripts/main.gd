extends Node2D


var DEVIL_BOSS_SCENE = preload("res://scenes/devil_boss.tscn")

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

var last_crop = "null"
var last_building = "null"
var mouse_on_mouth = false


func _ready():
	
	#create boss
	var temp = DEVIL_BOSS_SCENE.instantiate()
	add_child(temp)
	temp.attempt_eat_item.connect(_attempt_eat_item)
	
	#create building
	last_building = "fishing_spot"
	$TileMapLayer2.set_cell_scene(Vector2(2,-2),2,Vector2.ZERO,GLOBALCONSTS.BUILDING_SCENE_ID)#plant carrot crop
	

	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		click_tile()


func get_tile_name(pos):
	pos = $TileMapLayer.local_to_map(pos)
	return get_tile_name2(pos)
func get_tile_name2(pos):
	var data = $TileMapLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
	return "null"
func get_tile_name_from_coordinates(pos):
	var data = $TileMapLayer2.get_cell_tile_data(pos)
	if data != null: 
		return data.get_custom_data_by_layer_id(0)
	return "null"
		

func click_tile():
	#var tile_name = get_mouse_tile_name()
	var pos = $TileMapLayer.get_local_mouse_position()
	pos = $TileMapLayer.local_to_map(pos)
	
	if $TileMapLayer2.get_cell_source_id(pos) !=-1:#2nd layer cell not empty
		var scene = $TileMapLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building":
				var resources = scene.harvest()
				output_resources(resources)
				if scene.DESTROY_ON_HARVEST:
					$TileMapLayer2.set_cell_scene(pos,-1)#delete cell
			if scene.BUILDING_TYPE == "crop":
				if scene.harvest_on_click:
					var resources = scene.harvest()#a list of resources or False
					if resources:
						#$TileMapLayer.set_cell(pos,0,atlas_decoded["dry_farmland"],0)#replace with dry farmland
						$TileMapLayer2.set_cell_scene(pos,-1)#delete cell
						output_resources(resources)
			if scene.BUILDING_TYPE == "fire":
				$TileMapLayer2.set_cell_scene(pos,-1)#delete cell
		
func punish():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_punishments()
func reward():
	$ItemManager.drop_item_ukn()
	$GodChoiceManager.display_rewards()
func get_last_crop():
	return GLOBALCONSTS.CROP_DEF[last_crop]
func get_last_building():
	return GLOBALCONSTS.BUILDING_DEF[last_building]
#func retile_cardinal(pos):
	#var tile_data =  get_tile_name_from_coordinates([pos.x+1,pos.y])
	#print(tile_data)
		#$TileMapLayer.set_cells_terrain_connect([pos],0,0)	

func pos_in_bounds(pos: Vector2, bounds: Array):
	#Inclusive of bouns
	if not (pos.x >= bounds[0] and pos.x <= bounds[2]):
		return false
	if not (pos.y >= bounds[1] and pos.y <= bounds[3]):
		return false
	return true
func spread_fire(pos):
	
	$TileMapLayer2.set_cell_scene(pos,-1)#delete cell
	$TileMapLayer.set_cell(pos,0,atlas_decoded["burnt tile"],0)#set under to burnt
	
	var FIRE_RANGE = [-15, -7, 9, 7]
	
	var o_pos = Vector2(pos.x,pos.y)
	for i in range(2):
		pos.x += RNG.randi_range(-1,1)
		pos.y += RNG.randi_range(-1,1)
		if pos_in_bounds(pos, FIRE_RANGE):
			var tile_name = get_tile_name2(pos)
			if not (tile_name in GLOBALCONSTS.UNBURNABLE_TILES) :
				$TileMapLayer2.set_cell_scene(pos,2,Vector2.ZERO,GLOBALCONSTS.FIRE_SCENE_ID)
			
		pos = Vector2(o_pos.x,o_pos.y)
	
func _attempt_eat_item(on_mouth : bool):
	$ItemManager.mouse_on_mouth = on_mouth
	
func output_resources(resources):
	for i in range(len(resources)):
		$ItemManager.create_draggable_item(resources[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))
