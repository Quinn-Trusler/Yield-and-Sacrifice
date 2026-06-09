extends Node2D
#
#@export var TileLayer : Node2D
#@export var TileLayer2 : Node2D
#@export var EffectLayer : Node2D
#@export var TerrainLayer : Node2D
@export var TMM : Node2D
@export var ItemManager : Node2D
var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4),"dry_farmland":Vector2(1,1),"farmland":Vector2(3,3),"burnt tile":Vector2(1,11)}

var fish_spawn_spots : Array[Vector2i] = []
var ui_tiles : Array[Vector2i] = []
var WATER_TILE_NAMES : Array[String] = ["water","swamp_water","swamp_water_edge"]
var UI_TILE_NAME : String = "UI"
var BURNT_TILE_NAME : String = "burnt land"
var TILE_CHECK_LIMIT : int = 1000
var SIDES_ADJACENT_POSITIONS : Array[Vector2i] = [Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1), Vector2i(-1,0)]
var NINE_ADJACENT_POSITIONS : Array[Vector2i] = [Vector2i(-1,-1),Vector2i(-1,0),Vector2i(-1,1),Vector2i(0,-1),Vector2i(0,1),Vector2i(1,-1),Vector2i(1,0),Vector2i(1,1)]
var FIRE_SPREAD_WEIGHTS : Array[float] = [0,1,2,0,0] # 0,1,2,3,4 spread respectivly

var fish_spawning_active : bool = false

var invalid_spawn_spots : Array = []

#Tutorial
@export var TutorialManager: Node
var first_crop_harvested = false

var gift_items = []

func _ready():
	update_location_lists()
	TMM.TileLayer.place_farmland(Vector2i(-11,2))
	TMM.TileLayer.place_farmland(Vector2i(-9,2))
	
# Grabs data from layer 2 and fills fish spawn spots and ui tiles list
func update_location_lists():
	for x in range(GLOBALCONSTS.MAPSIZE[0], GLOBALCONSTS.MAPSIZE[2] + 1):
		for y in range(GLOBALCONSTS.MAPSIZE[1],GLOBALCONSTS.MAPSIZE[3] + 1):
			var pos = Vector2i(x,y)
			var tile_name = TMM.TileLayer.get_tile_name(pos)
			var terrain_tile_name = TMM.TerrainLayer.get_tile_name(pos)
			if tile_name == UI_TILE_NAME:
				ui_tiles.append(pos)
			elif WATER_TILE_NAMES.has(terrain_tile_name):
				fish_spawn_spots.append(pos)
			
func get_all_burnt_tiles():
	var burnt_tiles : Array[Vector2i] = []
	for x in range(GLOBALCONSTS.FIRE_RANGE[0], GLOBALCONSTS.FIRE_RANGE[2] + 1):
		for y in range(GLOBALCONSTS.FIRE_RANGE[1],GLOBALCONSTS.FIRE_RANGE[3] + 1):
			var pos = Vector2i(x,y)
			var tile_name = TMM.TileLayer.get_tile_name(pos)
			if tile_name == BURNT_TILE_NAME:
				burnt_tiles.append(pos)
	return burnt_tiles

func is_valid_building_location(pos : Vector2i, building_name : String) -> bool:
	return (TMM.TileLayer.is_valid_building_location(pos) and TMM.TerrainLayer.is_valid_building_location(pos, building_name) and TMM.TileLayer2.is_empty_building_location(pos) and not ui_tiles.has(pos))

#func is_valid_building_location(pos: Vector2i):
	#if TileLayer2.is_empty_building_location(pos) and not fish_spawn_spots.has(pos) and not ui_tiles.has(pos):
		#return true
	#return false
#uses tile position and not global position
func get_building_interactable(pos):
	if not TMM.EffectLayer.is_empty(pos):
		var scene = TMM.EffectLayer.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "fire":
				return true
			else:
				print("Building type other than fire in effect layer?????!!!???")
	if not TMM.TileLayer2.is_empty(pos):#2nd layer cell not empty
		var scene = TMM.TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building" or scene.BUILDING_TYPE == "crop":
				return scene.get_harvestable()
	return false


#Only one gift can be created per frame
func create_gift(item,num):
	var items = []
	for i in range(num):
		items.append(item)
	gift_items = items
	
	#var i = RNG.randi_range(0,len(gift_spawn_spots)-1)
	var pos = get_random_valid_pos("god_gift")
	place_building(pos, "god_gift")
	
func place_building(pos : Vector2i, building_name : String) -> void:
	print(building_name)
	if GLOBALCONSTS.MIDDLE_TILES.has(building_name):
		TMM.TileLayer.place_farmland(pos, building_name)
	else:
		TMM.TileLayer2.place_building(pos, building_name) 
		
func place_phantom_building(pos : Vector2i, building_name : String) -> void:
	print(building_name)
	if GLOBALCONSTS.MIDDLE_TILES.has(building_name):
		TMM.TileLayer.place_phantom_farmland(pos, building_name)
	else:
		TMM.TileLayer2.place_phantom_building(pos, building_name)
		
func remove_phantom_building(pos: Vector2i):
	TMM.TileLayer.set_cell(pos)
	TMM.TileLayer2.remove_cell_scene(pos)
	
func get_gift_items():
	return gift_items

func click_tile():
	#var tile_name = get_mouse_tile_name()
	var pos = TMM.TileLayer.get_local_mouse_position()
	pos = TMM.TileLayer.local_to_map(pos)
	var interacted_with_effect_layer : bool = false
	
	if not TMM.EffectLayer.is_empty(pos):
		var scene = TMM.EffectLayer.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "fire":
				TMM.EffectLayer.set_cell_scene(pos,-1)#delete cell
				interacted_with_effect_layer = true
	if not TMM.TileLayer2.is_empty(pos) and not interacted_with_effect_layer:#2nd layer cell not empty
		var scene = TMM.TileLayer2.get_cell_scene(pos)
		if scene:
			if scene.BUILDING_TYPE == "building":
				var resources = scene.harvest()
				ItemManager.output_resources(resources)
				if scene.DESTROY_ON_HARVEST:
					TMM.TileLayer2.set_cell_scene(pos,-1)#delete cell
			if scene.BUILDING_TYPE == "crop":
				var resources = scene.harvest()#a list of resources or False
				if resources:
					ItemManager.output_resources(resources)
					if scene.harvest_on_click:
						if not first_crop_harvested:
							first_crop_harvested = true
							TutorialManager.next(true, true, false)
						TMM.TileLayer2.set_cell_scene(pos,-1)#delete cell
						ItemManager.crop_uprooted(resources[0])
	
func get_nine_adjacent_positions(pos : Vector2i) -> Array[Vector2i]:
	var positions : Array[Vector2i] = []
	for adj_pos in NINE_ADJACENT_POSITIONS:
		var temp_pos = pos + adj_pos 
		if TMM.TileLayer.get_tile_name(temp_pos) == BURNT_TILE_NAME:
			positions.append(pos + adj_pos)
	return positions

# Burns tile bellow and extinguishes fire
func finish_burn(pos) -> void:
	TMM.TileLayer2.set_cell_scene(pos,-1)#delete cell
	TMM.EffectLayer.set_cell_scene(pos,-1)#delete cell
	var positions = get_nine_adjacent_positions(pos)
	positions.append(pos)
	TMM.TileLayer.set_cells_terrain_connect(positions, 0, 3)

# This is for initially placing fires and NOT for spreading
func is_valid_fire_placement(pos):
	if not TMM.TileLayer.get_tile_name(pos) in GLOBALCONSTS.UNBURNABLE_TILES and not TMM.TerrainLayer.get_tile_name(pos) in GLOBALCONSTS.UNBURNABLE_TERRAIN_TILES:
		if not TMM.TileLayer.get_tile_name(pos) in GLOBALCONSTS.INITIALLY_UNBURNABLE_TILES:
			if not TMM.TileLayer2.get_cell_scene(pos):
				if not TMM.EffectLayer.get_cell_scene(pos):
					return true
	return false
	
func is_valid_spread_position(pos):
	if is_pos_in_bounds(pos, GLOBALCONSTS.FIRE_RANGE):
		if not TMM.TileLayer.get_tile_name(pos) in GLOBALCONSTS.UNBURNABLE_TILES and not TMM.TerrainLayer.get_tile_name(pos) in GLOBALCONSTS.UNBURNABLE_TERRAIN_TILES:
			if TMM.EffectLayer.get_cell_scene(pos) == null or TMM.EffectLayer.get_cell_scene(pos).BUILDING_TYPE != "fire":
				return true
	return false
	
func spread_fire(pos) -> void:
	# Find all valid spread positions
	var valid_spread_pos : Array[Vector2i] = []
	for adj_pos in SIDES_ADJACENT_POSITIONS:
		var spread_pos : Vector2i = pos + adj_pos
		if (is_valid_spread_position(spread_pos)):
			valid_spread_pos.append(spread_pos)
	
	var spread_num : int = [0,1,2,3,4][RNG.rand_weighted(FIRE_SPREAD_WEIGHTS)]
	# Spread to spread_num adjacent positions if possible
	for i in range(min(spread_num,len(valid_spread_pos))):
		var spread_pos : Vector2i = valid_spread_pos[RNG.randi_range(0, len(valid_spread_pos)-1)]
		TMM.EffectLayer.set_cell_scene(spread_pos,2,Vector2.ZERO,GLOBALCONSTS.FIRE_SCENE_ID)
		valid_spread_pos.erase(spread_pos)
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
	
func get_random_valid_pos(building_name : String) -> Vector2i:
	var num_tiles_checked = 0
	while num_tiles_checked < TILE_CHECK_LIMIT:
		var pos = get_random_pos()
		num_tiles_checked += 1
		if is_valid_building_location(pos, building_name):
			return pos
	push_error("TILE_CHECK_LIMIT PASSED. Tried loop " + str(TILE_CHECK_LIMIT) + " times")
	return Vector2i(999,999)

func spawn_random_fish():
	assert(len(fish_spawn_spots), "Attempting to spawn fish with no spawn spots")
	var i = RNG.randi_range(0,len(fish_spawn_spots)-1)
	#spawn fish at 
	TMM.TileLayer2.place_building(fish_spawn_spots[i], "fishing_spot")

func _on_fish_timer_timeout() -> void:
	if fish_spawning_active:
		spawn_random_fish()
