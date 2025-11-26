extends Node2D

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")
@onready var TileMapMangager = get_node("/root/Main/TileMapManager")
@onready var ItemManager = get_node("/root/Main/ItemManager")
var RNG = RandomNumberGenerator.new()

var last_crop = "null"
var last_building = "null"

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(14,1)}


func get_last_crop():
	return GLOBALCONSTS.CROP_DEF[last_crop]
func get_last_building():
	return GLOBALCONSTS.BUILDING_DEF[last_building]
	
#uses tile position and not global position
func get_building_interactable(pos):
	if TileLayer2.get_cell_source_id(pos) !=-1:#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building" or scene.BUILDING_TYPE == "crop":
				return scene.get_harvestable()
			elif scene.BUILDING_TYPE == "fire":
				return true
	return false

func click_tile():
	#var tile_name = get_mouse_tile_name()
	var pos = TileLayer.get_local_mouse_position()
	pos = TileLayer.local_to_map(pos)
	
	if TileLayer2.get_cell_source_id(pos) !=-1:#2nd layer cell not empty
		var scene = TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building":
				var resources = scene.harvest()
				output_resources(resources)
				if scene.DESTROY_ON_HARVEST:
					TileLayer2.set_cell_scene(pos,-1)#delete cell
			if scene.BUILDING_TYPE == "crop":
				if scene.harvest_on_click:
					var resources = scene.harvest()#a list of resources or False
					if resources:
						#$TileMapLayer.set_cell(pos,0,atlas_decoded["dry_farmland"],0)#replace with dry farmland
						TileLayer2.set_cell_scene(pos,-1)#delete cell
						output_resources(resources)
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
		if pos_in_bounds(pos, FIRE_RANGE):
			var tile_name = TileMapMangager.get_tile_name_from_coords(pos)
			if not (tile_name in GLOBALCONSTS.UNBURNABLE_TILES) :
				TileLayer2.set_cell_scene(pos,2,Vector2.ZERO,GLOBALCONSTS.FIRE_SCENE_ID)
			
		pos = Vector2(o_pos.x,o_pos.y)
func output_resources(resources):
	for i in range(len(resources)):
		ItemManager.create_draggable_item(resources[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))

#finds if position is within bounds of array [x,y,x2,y2] inclusive
func pos_in_bounds(pos: Vector2, bounds: Array):
	#Inclusive of bouns
	if not (pos.x >= bounds[0] and pos.x <= bounds[2]):
		return false
	if not (pos.y >= bounds[1] and pos.y <= bounds[3]):
		return false
	return true
