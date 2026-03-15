extends TileMapLayer


func place_farmland(coords: Vector2i):
	set_cell_scene(coords, 0, GLOBALCONSTS.FARMLAND_ID)

func set_cell_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0):
	if source_id != -1:#If setting a valid tile
		set_cell(coords, source_id, atlas_coords, alternative_tile)
		
func get_tile_name_from_coordinates(pos):
	var data = get_cell_tile_data(pos)
	if data != null: 
		return data.get_custom_data_by_layer_id(0)
	return "null"
