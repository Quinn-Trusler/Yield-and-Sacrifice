extends Node2D


var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var ANIMATED_ITEM = preload("res://scenes/animated_item.tscn")
var draggable_items = []
var animated_items = []
var item_is_last:bool = false
var item_being_dragged
var item_in_focus = null
var focus_items = []
var crops_planted:Dictionary[String,int] = {"carrot":0,"potatoe":0,"wheat":0,"sugarcane":0}



var mouse_on_mouth = false

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

#Tutorial
@export var TutorialManager : Node
@export var DialogManager: CanvasLayer
var first_item_planted : bool = false


@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")
@onready var SacrificeManager = get_node("/root/Main/SacrificeManager")
@onready var TileMapManager = get_node("/root/Main/TileMapManager")
@onready var BuildingManager = get_node("/root/Main/BuildingManager")

signal item_picked_up(item_name, last_item)
signal item_dropped()

func spawn_testing_items():
	create_draggable_item("wheat",Vector2(-70,-30))
	#create_draggable_item("flour",Vector2(-60,-20))
	create_draggable_item("sugarcane",Vector2(-40,-30))
	#
	#create_draggable_item("potatoe",Vector2(-70,-30))
	#create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("potatoe",Vector2(-70,-30))
	create_draggable_item("carrot",Vector2(-70,-30))
	#
	#create_draggable_item("voldka",Vector2(-30,-20))
	#create_draggable_item("rum",Vector2(-50,-40))
	#create_draggable_item("pepper_juice",Vector2(-70,-40))

func _ready() -> void:
	create_draggable_item("carrot",Vector2(-50,-30))
	if Cheats.TESTING_ITEMS:
		spawn_testing_items()
func _process(_delta: float) -> void:
	if item_being_dragged:
		item_being_dragged.go_to_mouse_pos()
	if Input.is_action_just_pressed("mouse_down"):
		if item_in_focus:
			item_in_focus.pick_up()
			pickup_item(item_in_focus)
	elif not Input.is_action_pressed("mouse_down") and item_being_dragged:
		item_being_dragged.drop()
		drop_item(item_being_dragged)
		
func remove_from_focus_list(item_obj) -> void:
	focus_items.erase(item_obj)
	if item_in_focus == item_obj and not item_being_dragged:
		refocus()
		
func add_to_focus_list(item_obj):
	focus_items.append(item_obj)
	if not item_being_dragged:
		refocus()

func refocus():
	var largest_layer = 0
	var ind = 0  
	if len(focus_items):
		#Search through array for biggest layer
		for i in range(len(focus_items)):
			if focus_items[i].get_index() > largest_layer:
				largest_layer = focus_items[i].get_index()
				ind = i
		item_in_focus = focus_items[ind]
		item_in_focus.focus()
	else:
		item_in_focus = null
		

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
	
# If the item must be replanted it sets item_is_last var to true
func set_item_is_last(item):
	if GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"] != []:#Item is crop
		var count = 0
		for draggable_item in draggable_items:
			if draggable_item.item_name == item.item_name:
				count +=1
		if count == 1:#just self
			item_is_last = true

func pickup_item(item):
	item_in_focus = null
	self.move_child(item, get_child_count() - 1)
	item_being_dragged = item
	set_item_is_last(item)
	item_picked_up.emit(item.item_name, is_last_item(item))
	$PickUp.play()
	print("pick up item ", item_being_dragged.item_name)
	
func drop_item_ukn():
	if item_being_dragged:
		item_being_dragged.drop()
		drop_item(item_being_dragged)
		
func get_dragging_item_placeable():
	if item_being_dragged:
		var pos = TileLayer.local_to_map(TileLayer.to_local(item_being_dragged.position))
		var tile_name = TileMapManager.get_tile_name_from_coords(pos)
		if TileLayer2.is_empty(pos):#empty cell
			return (tile_name in GLOBALCONSTS.ITEM_DEF[item_being_dragged.item_name]["place_on"])
	return false
			
func delete_animated_item(item):
	animated_items.erase(item)
	item.queue_free()
func crop_uprooted(item_name):
	crops_planted[item_name] -=1
	
func is_last_item(item):
	return (item_is_last and crops_planted[item.item_name] == 0)
#called by the item itself
func drop_item(item):
	item_being_dragged = null
	remove_from_focus_list(item)
	refocus()
	
	var delete_item = false
	var pos = TileLayer.to_local(item.position)
	var tile_name = TileMapManager.get_tile_name_from_local(pos)
	pos = TileLayer.local_to_map(pos)
	item_dropped.emit()
	
	if mouse_on_mouth:
		if not (item_is_last and crops_planted[item.item_name] == 0):
			SacrificeManager.sacrifice(item.item_name)
			delete_item = true
			$EatItem.play()
		else:
			DialogManager.override_current_dialog(GLOBALCONSTS.LAST_CROP_ITEM_DIALOG)
	
	#Attempt place crop
	elif tile_name in GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"]:
		if TileLayer2.is_empty(pos):#empty cell
			delete_item = true
			TileLayer2.plant_crop(pos,item.item_name)
			crops_planted[item.item_name] +=1
			$DropInBuilding.play()
			if not first_item_planted:
				first_item_planted = true
				TutorialManager.next(true, true, false)
		else:
			print("Error: Cannot plant on already planted farmland")
				
	#Attempt to place item in building
	elif not TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene and scene.BUILDING_TYPE == "building" and not is_last_item(item):
			delete_item = scene.place_item(item.item_name)
			$DropInBuilding.play()
		else:
			$PutDown.play()
	#Item drop normaly
	else:
		$PutDown.play()
	
	item_is_last = false
	
	if delete_item:
		draggable_items.erase(item)
		item.queue_free()
		
func output_resources(resources):
	if resources:
		$item_pop.play()
	for i in range(len(resources)):
		create_animated_item(resources[i],get_global_mouse_position())
