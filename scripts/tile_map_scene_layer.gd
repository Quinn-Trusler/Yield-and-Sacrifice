extends TileMapLayer
	
#used code from https://www.reddit.com/r/godot/comments/10ql0ch/godot_4_does_tilemap_have_a_way_to_retrieve_the/
class_name SceneTileMapLayer
	
var scene_coords: Dictionary[Vector2i, Node] = {}
	
func _enter_tree():
	child_entered_tree.connect(_register_child)
	#child_exiting_tree.connect(_unregister_child)
	
func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("tile_coords", coords)
	if child.BUILDING_TYPE == "crop":
		child.initialize(get_parent().get_last_crop())
		
#func _unregister_child(child):	
	#print("unregister child: ",child.get_meta("tile_coords"))
	#scene_coords.erase(child.get_meta("tile_coords"))
	
func remove_cell_scene(coords):	
	set_cell(coords, -1)
	scene_coords.erase(coords)
	
func set_cell_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0):
	remove_cell_scene(coords)#Remove old
	if source_id != -1:#If setting a valid tile
		set_cell(coords, source_id, atlas_coords, alternative_tile)

	
func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)
	
