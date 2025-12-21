extends Node2D


var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var ANIMATED_ITEM = preload("res://scenes/animated_item.tscn")
var draggable_items = []
var animated_items = []
var dragging_item = false
var item_being_dragged

var mouse_on_mouth = false

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")
@onready var SacraficeManager = get_node("/root/Main/SacraficeManager")
@onready var TileMapManager = get_node("/root/Main/TileMapManager")
@onready var BuildingManager = get_node("/root/Main/BuildingManager")

var TESTING_ITEMS = false


func _ready() -> void:
	create_draggable_item("carrot",Vector2(-50,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	if TESTING_ITEMS:
		create_draggable_item("sugarcane",Vector2(-40,-30))
		
		create_draggable_item("potatoe",Vector2(-70,-30))
		create_draggable_item("potatoe",Vector2(-70,-30))
		create_draggable_item("potatoe",Vector2(-70,-30))
		create_draggable_item("carrot",Vector2(-70,-30))
		
		create_draggable_item("voldka",Vector2(-30,-20))
		create_draggable_item("rum",Vector2(-50,-40))
		create_draggable_item("pepper_juice",Vector2(-70,-40))

func create_draggable_item(item_name,pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,GLOBALCONSTS.ITEM_DEF[item_name])
	temp.position = pos

func create_animated_item(item_name, pos):
	var temp = ANIMATED_ITEM.instantiate()
	add_child(temp)
	animated_items.append(temp)
	temp.initialize(pos.y - 16,item_name,GLOBALCONSTS.ITEM_DEF[item_name])
	temp.position = pos
	print("animated item created")

func pickup_item(item):
	dragging_item = true
	item_being_dragged = item
	$PickUp.play()
	
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
			
func delete_animated_item(item):
	animated_items.erase(item)
	item.queue_free()
	print("animated item deleted")
#called by the item itself
func drop_item(item):
	dragging_item = false
	item_being_dragged = false
	
	var delete_item = false
	var pos = TileLayer.to_local(item.position)
	var tile_name = TileMapManager.get_tile_name_from_local(pos)
	pos = TileLayer.local_to_map(pos)
	
	
	
	if mouse_on_mouth:
		SacraficeManager.sacrafice(item.item_name)
		delete_item = true
		$EatItem.play()
	
	#Attempt place crop
	elif tile_name in GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"]:
		if TileLayer2.is_empty(pos):#empty cell
			delete_item = true
			TileLayer2.plant_crop(pos,item.item_name)
			$DropInBuilding.play()
		else:
			print("Error: Cannot plant on already planted farmland")
				
	#Attempt to place item in building
	elif not TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene and scene.BUILDING_TYPE == "building":
			delete_item = scene.place_item(item.item_name)
			$DropInBuilding.play()
	#Item drop normaly
	else:
		$PutDown.play()
				
	if delete_item:
		draggable_items.erase(item)
		item.queue_free()
		
func output_resources(resources):
	if resources:
		$item_pop.play()
	for i in range(len(resources)):
		create_animated_item(resources[i],get_global_mouse_position())
