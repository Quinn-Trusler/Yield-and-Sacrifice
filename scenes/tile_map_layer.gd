extends TileMapLayer

var farmland_id : Vector2i = GLOBALCONSTS.FARMLAND_ID
var no_building_placement_tiles : Array = GLOBALCONSTS.NO_BUILDING_PLACEMENT_TILES

func place_farmland(coords: Vector2i):
	set_cell_scene(coords, 0, farmland_id)

func set_cell_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0):
	if source_id != -1:#If setting a valid tile
		set_cell(coords, source_id, atlas_coords, alternative_tile)

func is_valid_building_location(pos : Vector2i) -> bool:
	var tile_name : String = get_tile_name_from_layer(pos)
	return !(no_building_placement_tiles.has(tile_name))

func get_tile_name_from_layer(pos):
	var data = get_cell_tile_data(pos)
	if data != null: 
		return data.get_custom_data_by_layer_id(0)
	return "null"
