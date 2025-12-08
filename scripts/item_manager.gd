extends Node2D


var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var draggable_items = []
var dragging_item = false
var item_being_dragged

#var last_crop = "null"
#var last_building = "null"
var mouse_on_mouth = false

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")
@onready var SacraficeManager = get_node("/root/Main/SacraficeManager")
@onready var TileMapManager = get_node("/root/Main/TileMapManager")
@onready var BuildingManager = get_node("/root/Main/BuildingManager")



func _ready() -> void:
	create_draggable_item("carrot",Vector2(-50,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	
	create_draggable_item("voldka",Vector2(-30,-20))
	create_draggable_item("rum",Vector2(-50,-40))
	create_draggable_item("pepper_juice",Vector2(-70,-40))

func _process(_delta: float) -> void:
	pass
	#mouse on a building
	#if dragging_item:
		#if get_dragging_item_placeable():
			#TileMapManager.display_tile_outline(TileLayer.to_local(get_global_mouse_position()))
		#else:
			#TileMapManager.hide_tile_outline()
	#else:
		#TileMapManager.hide_tile_outline()
	#else:
		#TileMapManager.display_tile_outline(TileLayer.to_local(get_global_mouse_position()))
	#if dragging_item:
		#if item_being_dragged.item_name == "watering_can":
			#process_watering_can(delta)
			#watring can has a timer to empty to another state



func create_draggable_item(item_name,pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,GLOBALCONSTS.ITEM_DEF[item_name])
	temp.position = pos
#func process_watering_can(_delta):
	#var can = item_being_dragged
	#var MAX_CAN_FRAME = 8#add this stuff to the item soon
	#var TIME_PER_FRAME = 0.2
	#var CAN_STARTING_ROTATION = PI/6
	#
	#var tile_name = TileMapManager.get_mouse_tile_name()
	#if tile_name == "water":
		#can.frame = 0 #starts full and last frame is empty
		#can.rotation = CAN_STARTING_ROTATION
		#can.timer = 0
	#elif can.frame == MAX_CAN_FRAME:
		#can.rotation = 0
	#else:#work on emptying it
		##can.position = can.
		#var pos = TileLayer.local_to_map(TileLayer.get_local_mouse_position())#get_tip_pos())
		#
		#can.rotation = CAN_STARTING_ROTATION+ (can.frame +can.timer/TIME_PER_FRAME) *(PI/3/MAX_CAN_FRAME)
		#var tip_pos = pos#TileLayer.to_local(can.position)
		#
		#if can.timer >= TIME_PER_FRAME:
			#can.timer = 0
			#can.frame +=1
		#if tile_name == "dry_farmland":
			#can.timer += TIME_PER_FRAME
			##var tip_pos = TileLayer.local_to_map(TileLayer.get_local_mouse_position())
			#TileLayer.set_cell(tip_pos,0,atlas_decoded["farmland"],0)
		#if TileLayer2.get_cell_source_id(tip_pos) !=-1:#2nd layer cell not empty
			#var scene = TileLayer2.get_cell_scene(tip_pos)
			#if scene and scene.BUILDING_TYPE == "fire":
				#can.timer += TIME_PER_FRAME
				#TileLayer2.set_cell_scene(tip_pos,-1)


func pickup_item(item):
	dragging_item = true
	item_being_dragged = item
	
func drop_item_ukn():
	if item_being_dragged:
		item_being_dragged.drop()
		
func get_dragging_item_placeable():
	if dragging_item:
		var pos = TileLayer.local_to_map(TileLayer.to_local(item_being_dragged.position))
		var tile_name = TileMapManager.get_tile_name_from_coords(pos)
		if TileLayer2.is_empty(pos):#empty cell
			return (tile_name in GLOBALCONSTS.ITEM_DEF[item_being_dragged.item_name]["place_on"])
	return false
			
#called by the item itself
func drop_item(item):
	dragging_item = false
	item_being_dragged = false
	
	var delete_item = false
	var pos = TileLayer.to_local(item.position)
	var tile_name = TileMapManager.get_tile_name_from_local(pos)
	pos = TileLayer.local_to_map(pos)
	if item.item_name == "watering_can":
		item.rotation = 0
	
	if tile_name == "lava" or mouse_on_mouth:
		SacraficeManager.sacrafice(item.item_name)
		delete_item = true
	#if item.item_name == "carrot":
	
		
	if tile_name in GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"]:
		if TileLayer2.is_empty(pos):#empty cell
			delete_item = true

			TileLayer2.set_cell_scene(pos,2,Vector2.ZERO,GLOBALCONSTS.CROP_SCENE_ID)#plants crop
			#var scene = TileLayer2.get_cell_scene(pos)
			BuildingManager.last_crop = item.item_name
			
		else:
			print("Error: Cannot plant on already planted farmland")
				
	#Attempt to place item in building
	if not TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene and scene.BUILDING_TYPE == "building":
			delete_item = scene.place_item(item.item_name)
				
				
	if delete_item:
		draggable_items.erase(item)
		item.queue_free()
		
func output_resources(resources):
	for i in range(len(resources)):
		create_draggable_item(resources[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))
