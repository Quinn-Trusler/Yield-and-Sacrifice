extends Node2D

var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var DEVIL_BOSS_SCENE = preload("res://scenes/devil_boss.tscn")
var draggable_items = []
var dragging_item = false
var item_being_dragged
var MAPSIZE = [-13,5,4,-4]

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"
var CROP_SCENE_ID = 1
var FIRE_SCENE_ID = 2
var BUILDING_SCENE_ID = 3
var UNBURNABLE_TILES = ["burnt land","water","lava"]
var CROP_DEF = {"carrot":{"stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potatoe":{"stage_growth_duration":2,"total_stages":5,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potatoe","potatoe","potatoe"],"frames":CROP_FRAMES_FOLDER + "potatoe.tres","offset":Vector2(0,-8)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot.png","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe.png","is_animated":false,"points":2,"place_on":["dry_farmland"]},
"watering_can":{"display_name":"Watering Can","img_name":ITEM_FRAMES_FOLDER + "watering_can.tres","points":100,"is_animated":true,"place_on":[]}
}

var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["potatoe"],"items_to_start_timer":0,"input_items":[],"total_stages":1,"time_per_stage":0,"destroy_on_harvest":true, "frames": CROP_FRAMES_FOLDER + "potatoe.tres"}}

var ANIMAL_DEF
#var RESOURCES = []
#var STAGE_TO_START_TIMER = 0#put items in untill timer can start
#var TOTAL_STAGES = 1
#var STAGE_TIME = 10
#var INPUT_ITEMS = []


var last_crop = "null"
var last_building = "null"
var mouse_on_mouth = false

#var stage_growth_duration = 2
#var total_stages = 4
#
#var harvest_on_click = true
#var pick_on_click = 0 #number of picks allowed
#var pick_stage_setback = 0 #how far crop is setback when picked
#var resources = ["carrot","carrot"]
#
##change as plant grows
#var stage = 0
#var timer = 0
#var growth_complete = false
func _ready():
	#create_draggable_item("watering_can",Vector2(50,10))
	create_draggable_item("carrot",Vector2(-50,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	
	#create boss
	var temp = DEVIL_BOSS_SCENE.instantiate()
	add_child(temp)
	temp.attempt_eat_item.connect(_attempt_eat_item)
	
	#create building
	last_building = "fishing_spot"
	$TileMapLayer2.set_cell_scene(Vector2(-2,0),2,Vector2.ZERO,BUILDING_SCENE_ID)#plant carrot crop
	
	
func create_draggable_item(item_name,pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,ITEM_DEF[item_name])
	temp.position = pos
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		click_tile()
	if dragging_item:
		if item_being_dragged.item_name == "watering_can":
			process_watering_can(delta)
			#watring can has a timer to empty to another state
func process_watering_can(_delta):
	var can = item_being_dragged
	var MAX_CAN_FRAME = 8#add this stuff to the item soon
	var TIME_PER_FRAME = 0.2
	var CAN_STARTING_ROTATION = PI/6
	
	var tile_name = get_mouse_tile_name()
	#print(tile_name)
	if tile_name == "water":
		can.frame = 0 #starts full and last frame is empty
		can.rotation = CAN_STARTING_ROTATION
		can.timer = 0
	elif can.frame == MAX_CAN_FRAME:
		can.rotation = 0
	else:#work on emptying it
		#can.position = can.
		var pos = $TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position())#get_tip_pos())
		#tile_name = get_tile_name(pos)
		
		can.rotation = CAN_STARTING_ROTATION+ (can.frame +can.timer/TIME_PER_FRAME) *(PI/3/MAX_CAN_FRAME)
		var tip_pos = pos#$TileMapLayer.to_local(can.position)
		
		if can.timer >= TIME_PER_FRAME:
			can.timer = 0
			can.frame +=1
		if tile_name == "dry_farmland":
			can.timer += TIME_PER_FRAME
			#var tip_pos = $TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position())
			$TileMapLayer.set_cell(tip_pos,0,atlas_decoded["farmland"],0)
		if $TileMapLayer2.get_cell_source_id(tip_pos) !=-1:#2nd layer cell not empty
			var scene = $TileMapLayer2.get_cell_scene(tip_pos)
			print(scene)
			if scene and scene.BUILDING_TYPE == "fire":
				print("found fire")
				can.timer += TIME_PER_FRAME
				$TileMapLayer2.set_cell_scene(tip_pos,-1)
	
	
func get_mouse_tile_name():
	var mouse_cell = $TileMapLayer.get_local_mouse_position()
	return get_tile_name(mouse_cell)
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
		
func pickup_item(item):
	dragging_item = true
	item_being_dragged = item
	
		
func drop_item(item):
	dragging_item = false
	item_being_dragged = false
	
	var delete_item = false
	var pos = $TileMapLayer.to_local(item.position)
	var tile_name = get_tile_name(pos)
	pos = $TileMapLayer.local_to_map(pos)
	if item.item_name == "watering_can":
		item.rotation = 0
	
	if tile_name == "lava" or mouse_on_mouth:
		$SacraficeManager.sacrafice(item.item_name)
		delete_item = true
	#if item.item_name == "carrot":
	if tile_name in ITEM_DEF[item.item_name]["place_on"]:
		if $TileMapLayer2.get_cell_source_id(pos) ==-1:#empty cell
			delete_item = true

			$TileMapLayer2.set_cell_scene(pos,2,Vector2.ZERO,CROP_SCENE_ID)#plants crop
			#var scene = $TileMapLayer2.get_cell_scene(pos)
			last_crop = item.item_name
			
		else:
			print("Error: Cannot plant on already planted farmland")
				
				
				
	if delete_item:
		draggable_items.erase(item)
		item.queue_free()
		
func output_resources(resources):
	for i in range(len(resources)):
		create_draggable_item(resources[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))
func click_tile():
	var tile_name = get_mouse_tile_name()

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
	dragging_item = false
	$GodChoiceManager.display_punishments()
func reward():
	dragging_item = false
	$GodChoiceManager.display_rewards()
func get_last_crop():
	return CROP_DEF[last_crop]
func get_last_building():
	return BUILDING_DEF[last_building]
#func retile_cardinal(pos):
	#var tile_data =  get_tile_name_from_coordinates([pos.x+1,pos.y])
	#print(tile_data)
		#$TileMapLayer.set_cells_terrain_connect([pos],0,0)	
func spread_fire(pos):
	
	$TileMapLayer2.set_cell_scene(pos,-1)#delete cell
	$TileMapLayer.set_cell(pos,0,atlas_decoded["burnt tile"],0)#set under to burnt
	
	
	var o_pos = Vector2(pos.x,pos.y)
	for i in range(2):
		pos.x += RNG.randi_range(-1,1)
		pos.y += RNG.randi_range(-1,1)
		var tile_name = get_tile_name2(pos)
		if not (tile_name in UNBURNABLE_TILES) :
			$TileMapLayer2.set_cell_scene(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
			
		pos = Vector2(o_pos.x,o_pos.y)
	
func _attempt_eat_item(on_mouth : bool):
	mouse_on_mouth = on_mouth
	
