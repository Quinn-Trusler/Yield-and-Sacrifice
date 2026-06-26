extends TileMapLayer

var no_building_placement_tiles : Array = GLOBALCONSTS.NO_BUILDING_PLACEMENT_TILES

# Do not use unburn/burn unless you know the tile is farmland
func burn_farmland(coords: Vector2i):
	place_burnt_farmland(coords, get_tile_name(coords))
func unburn_farmland(coords: Vector2i):
	place_farmland(coords, GLOBALCONSTS.MIDDLE_TILES[get_tile_name(coords)]["unburnt"])
	
func place_burnt_farmland(coords: Vector2i, tile_name : String = "farmland") -> void:
	print("placing burnt farmland",GLOBALCONSTS.MIDDLE_TILES[tile_name]["burnt_ID"])
	set_cell_scene(coords, 0, GLOBALCONSTS.MIDDLE_TILES[tile_name]["burnt_ID"])
func place_farmland(coords: Vector2i, tile_name : String = "farmland") -> void:
	set_cell_scene(coords, 0, GLOBALCONSTS.MIDDLE_TILES[tile_name]["ID"])
func place_phantom_farmland(coords: Vector2i, tile_name : String = "farmland") -> void:
	set_cell_scene(coords, 0, GLOBALCONSTS.MIDDLE_TILES[tile_name]["phantom_ID"])

func set_cell_scene(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0):
	if source_id != -1:#If setting a valid tile
		set_cell(coords, source_id, atlas_coords, alternative_tile)

func is_valid_building_location(pos : Vector2i, building_name : String = "null") -> bool:
	var tile_name : String = get_tile_name(pos)
	var def = GLOBALCONSTS.BUILDING_DEF[building_name]
	# If (not tile not in no build placement tiles or we have an exception) and (null or no placement restrictions or placement restriction tile has been found)
	return (
		not no_building_placement_tiles.has(tile_name) 
		or (
			building_name != "null" 
			and def.has("no_building_placement_override") 
			and tile_name in def["no_building_placement_override"]
		)
	) and (
		building_name == "null"
		or not "place_on" in def 
		or def["place_on"].has(tile_name)
	)

# Use this if you want to ignore place on rules
func is_no_building_placement_tiles_location(pos : Vector2i, building_name : String = "null"):
	var tile_name : String = get_tile_name(pos)
	var def = GLOBALCONSTS.BUILDING_DEF[building_name]
	return (
		not no_building_placement_tiles.has(tile_name)
		or (building_name != "null"
			and def.has("no_building_placement_override")
		)
	)
	
func gift_placeable_on_tile_layer(pos: Vector2i)  -> bool:
	var tile_name : String = get_tile_name(pos)
	return (tile_name == "null" or tile_name in GLOBALCONSTS.gift_tile_layer_exceptions)

func get_tile_name(pos):
	var data = get_cell_tile_data(pos)
	if data != null: 
		return data.get_custom_data_by_layer_id(0)
	return "null"
#gets tile name using global position
func get_tile_name_from_local(pos):
	pos = local_to_map(pos)#tile coordinates
	return get_tile_name(pos)
