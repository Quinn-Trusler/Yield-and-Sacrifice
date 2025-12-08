extends TileMapLayer
	
#used code from https://www.reddit.com/r/godot/comments/10ql0ch/godot_4_does_tilemap_have_a_way_to_retrieve_the/
class_name SceneTileMapLayer
@onready var BuildingManager = get_node("/root/Main/BuildingManager")
	
var scene_coords: Dictionary[Vector2i, Node] = {}
	
func _enter_tree():
	child_entered_tree.connect(_register_child)
	#child_exiting_tree.connect(_unregister_child)
	
func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("all_coords", [coords])
	child.set_meta("tile_coords", coords)
	if child.BUILDING_TYPE == "crop":
		child.initialize(BuildingManager.get_last_crop())
	elif child.BUILDING_TYPE == "building":
		var building_def = BuildingManager.get_last_building()
		child.initialize(building_def)
		var temp_meta = [coords]
		if "extra_tiles" in building_def:
			var extra_tiles = building_def["extra_tiles"]
			for tile in extra_tiles:
				var new_pos = Vector2i(coords.x + tile[0], coords.y + tile[1])
				temp_meta.append(new_pos)
				scene_coords[new_pos] = child
		child.set_meta("all_coords", temp_meta)
				
		
#func _unregister_child(child):	
	#print("unregister child: ",child.get_meta("tile_coords"))
	#scene_coords.erase(child.get_meta("tile_coords"))
	
#Get scene coordinate metadata and then add all other sets of coordinates then delete
func remove_cell_scene(coords):	
	var scene = get_cell_scene(coords)
	if scene:
		for pos in scene.get_meta("all_coords"):
			set_cell(pos, -1)
			scene_coords.erase(pos)
			print("deleted pos", pos)

	
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
	
