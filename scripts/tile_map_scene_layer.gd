extends TileMapLayer
	
#used code from https://www.reddit.com/r/godot/comments/10ql0ch/godot_4_does_tilemap_have_a_way_to_retrieve_the/
class_name SceneTileMapLayer
@onready var BuildingManager = get_node("/root/Main/BuildingManager")
@onready var ItemManager = get_node("/root/Main/ItemManager")
	
var scene_coords: Dictionary[Vector2i, Node] = {}
var building_names_temp: Dictionary[Vector2i, String] = {}
	
func _enter_tree():
	child_entered_tree.connect(_register_child)
	#child_exiting_tree.connect(_unregister_child)
	
func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("all_coords", [coords])
	child.set_meta("tile_coords", coords)
	var vectored_coords = Vector2i(coords[0], coords[1])
	if child.BUILDING_TYPE == "crop":
		child.initialize(GLOBALCONSTS.CROP_DEF[building_names_temp[vectored_coords]])
		building_names_temp.erase(vectored_coords)
	elif child.BUILDING_TYPE == "building":
		child.connectItemSignals(ItemManager)
		
		
		var building_def =  GLOBALCONSTS.BUILDING_DEF[building_names_temp[vectored_coords]]
		child.initialize(building_def)
		if child.BUILDING_DISPLAY_NAME == "Gift":
			child.OUTPUT_ITEMS = BuildingManager.get_gift_items()
		var temp_meta = [coords]
		if "extra_tiles" in building_def:
			var extra_tiles = building_def["extra_tiles"]
			for tile in extra_tiles:
				var new_pos = Vector2i(coords.x + tile[0], coords.y + tile[1])
				temp_meta.append(new_pos)
				scene_coords[new_pos] = child
		child.set_meta("all_coords", temp_meta)
		building_names_temp.erase(vectored_coords)
		
#func _unregister_child(child):	
	#scene_coords.erase(child.get_meta("tile_coords"))
	
#Get scene coordinate metadata and then add all other sets of coordinates then delete
func remove_cell_scene(coords):	
	var scene = get_cell_scene(coords)
	if scene:
		for pos in scene.get_meta("all_coords"):
			set_cell(pos, -1)
			scene_coords.erase(pos)
func plant_crop(coords: Vector2i, building_name: String):
	building_names_temp[coords] = building_name
	set_cell_scene(coords,2,Vector2.ZERO,GLOBALCONSTS.CROP_SCENE_ID)#plants crop

func place_building(coords: Vector2i, building_name: String):
	building_names_temp[coords] = building_name
	set_cell_scene(coords,2,Vector2.ZERO,GLOBALCONSTS.BUILDING_SCENE_ID)


func set_cell_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0):
	remove_cell_scene(coords)#Remove old
	if source_id != -1:#If setting a valid tile
		set_cell(coords, source_id, atlas_coords, alternative_tile)

func is_empty(coords: Vector2i) -> bool:
	return not (coords in scene_coords)
	
func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)
	
func spread_fire(pos):
	BuildingManager.spread_fire(pos)
	
