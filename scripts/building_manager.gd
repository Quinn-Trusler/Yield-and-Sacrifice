extends Node2D

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")
@onready var TileMapMangager = get_node("/root/Main/TileMapManager")
@onready var ItemManager = get_node("/root/Main/ItemManager")
var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}

var fish_spawn_spots : Array[Vector2i] = []
var ui_tiles : Array[Vector2i] = []
var gift_spawn_spots = [Vector2(0,0), Vector2(0,1), Vector2(-3,0)]
var WATER_TILE_NAME = "water"
var UI_TILE_NAME = "UI"
var TILE_CHECK_LIMIT = 1000
var fish_spawning_active : bool = false

var invalid_spawn_spots : Array = []

#Tutorial
@export var TutorialManager: Node
var first_crop_harvested = false

var gift_items = []

func _ready():
	update_location_lists()
	TileLayer.place_farmland(Vector2i(-11,2))
	TileLayer.place_farmland(Vector2i(-9,2))
	
# Grabs data from layer 2 and fills fish spawn spots and ui tiles list
func update_location_lists():
	for x in range(GLOBALCONSTS.MAPSIZE[0], GLOBALCONSTS.MAPSIZE[2] + 1):
		for y in range(GLOBALCONSTS.MAPSIZE[1],GLOBALCONSTS.MAPSIZE[3] + 1):
			var pos = Vector2i(x,y)
			var tile_name = TileMapMangager.get_tile_name_from_coords(pos)
			if  tile_name == WATER_TILE_NAME:
				fish_spawn_spots.append(pos)
			elif tile_name == UI_TILE_NAME:
				ui_tiles.append(pos)
func is_valid_building_location(pos: Vector2i):
	if TileLayer2.is_empty_building_location(pos) and not fish_spawn_spots.has(pos) and not ui_tiles.has(pos):
		return true
	return false
#uses tile position and not global position
func get_building_interactable(pos):
	if not TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building" or scene.BUILDING_TYPE == "crop":
				return scene.get_harvestable()
			elif scene.BUILDING_TYPE == "fire":
				return true
	return false


#Only one gift can be created per frame
func create_gift(item,num):
	var items = []
	for i in range(num):
		items.append(item)
	gift_items = items
	
	#var i = RNG.randi_range(0,len(gift_spawn_spots)-1)
	var pos = get_random_valid_pos()
	TileLayer2.place_building(pos, "god_gift")
func get_gift_items():
	return gift_items

func click_tile():
	#var tile_name = get_mouse_tile_name()
	var pos = TileLayer.get_local_mouse_position()
	pos = TileLayer.local_to_map(pos)
	
	if not TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building":
				var resources = scene.harvest()
				ItemManager.output_resources(resources)
				if scene.DESTROY_ON_HARVEST:
					TileLayer2.set_cell_scene(pos,-1)#delete cell
			if scene.BUILDING_TYPE == "crop":
				if scene.harvest_on_click:
					var resources = scene.harvest()#a list of resources or False
					if resources:
						if not first_crop_harvested:
							first_crop_harvested = true
							TutorialManager.next(true, true, false)
						#$TileMapLayer.set_cell(pos,0,atlas_decoded["dry_farmland"],0)#replace with dry farmland
						TileLayer2.set_cell_scene(pos,-1)#delete cell
						ItemManager.output_resources(resources)
						ItemManager.crop_uprooted(resources[0])
			if scene.BUILDING_TYPE == "fire":
				TileLayer2.set_cell_scene(pos,-1)#delete cell
				
func spread_fire(pos):
	
	TileLayer2.set_cell_scene(pos,-1)#delete cell
	TileLayer.set_cell(pos,0,atlas_decoded["burnt tile"],0)#set under to burnt
	
	var FIRE_RANGE = [-15, -7, 9, 7]
	
	var o_pos = Vector2(pos.x,pos.y)
	for i in range(2):
		pos.x += RNG.randi_range(-1,1)
		pos.y += RNG.randi_range(-1,1)
		if is_pos_in_bounds(pos, FIRE_RANGE):
			var tile_name = TileMapMangager.get_tile_name_from_coords(pos)
			if not (tile_name in GLOBALCONSTS.UNBURNABLE_TILES) :
				TileLayer2.set_cell_scene(pos,2,Vector2.ZERO,GLOBALCONSTS.FIRE_SCENE_ID)
			
		pos = Vector2(o_pos.x,o_pos.y)
#func output_resources(resources):
	#for i in range(len(resources)):
		#ItemManager.create_draggable_item(resources[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))

#finds if position is within bounds of array [x,y,x2,y2] inclusive
func is_pos_in_bounds(pos: Vector2, bounds: Array):
	#Inclusive of bouns
	if not (pos.x >= bounds[0] and pos.x <= bounds[2]):
		return false
	if not (pos.y >= bounds[1] and pos.y <= bounds[3]):
		return false
	return true
# Gets random pos within map size
func get_random_pos() -> Vector2i:
	return Vector2i(RNG.randi_range(GLOBALCONSTS.MAPSIZE[0],GLOBALCONSTS.MAPSIZE[2]), RNG.randi_range(GLOBALCONSTS.MAPSIZE[1],GLOBALCONSTS.MAPSIZE[3]))
	
func get_random_valid_pos() -> Vector2i:
	var num_tiles_checked = 0
	while num_tiles_checked < TILE_CHECK_LIMIT:
		var pos = get_random_pos()
		num_tiles_checked += 1
		if is_valid_building_location(pos):
			return pos
	push_error("TILE_CHECK_LIMIT PASSED. Tried loop " + str(TILE_CHECK_LIMIT) + " times")
	return Vector2i(999,999)

func spawn_random_fish():
	assert(len(fish_spawn_spots), "Attempting to spawn fish with no spawn spots")
	var i = RNG.randi_range(0,len(fish_spawn_spots)-1)
	#spawn fish at 
	TileLayer2.place_building(fish_spawn_spots[i], "fishing_spot")

func _on_fish_timer_timeout() -> void:
	if fish_spawning_active:
		spawn_random_fish()
