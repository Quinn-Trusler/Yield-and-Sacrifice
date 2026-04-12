extends TileMapLayer

@export var building_manager : Node2D
var mapsize : Array = GLOBALCONSTS.MAPSIZE
var visible_mapsize : Array = GLOBALCONSTS.VISIBLE_MAPSIZE
var INVALID_TILE_SOURCE_ID : int = 1
var INVALID_TILE_ATLAS_COORDS : Vector2i =  Vector2i(2,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_border_invalid_ties()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func display_border_invalid_ties() -> void:
	for y in range(visible_mapsize[1],visible_mapsize[3]+1):
		for x in range(visible_mapsize[0],mapsize[0]):
			set_cell(Vector2i(x,y), INVALID_TILE_SOURCE_ID, INVALID_TILE_ATLAS_COORDS)
		for x in range(mapsize[2]+1,visible_mapsize[2]+1):
			set_cell(Vector2i(x,y), INVALID_TILE_SOURCE_ID, INVALID_TILE_ATLAS_COORDS)
	for x in range(visible_mapsize[0],visible_mapsize[2]+1):
		for y in range(visible_mapsize[1],mapsize[1]):
			set_cell(Vector2i(x,y), INVALID_TILE_SOURCE_ID, INVALID_TILE_ATLAS_COORDS)
		for y in range(mapsize[3]+1,visible_mapsize[3]+1):
			set_cell(Vector2i(x,y), INVALID_TILE_SOURCE_ID, INVALID_TILE_ATLAS_COORDS)

func display_invalid_tiles(building_name : String) -> void:
	for x in range(mapsize[0], mapsize[2] + 1):
		for y in range(mapsize[1],mapsize[3] + 1):
			var pos : Vector2i = Vector2i(x,y)
			if building_manager.is_valid_building_location(pos, building_name):
				set_cell(pos)
			else: 
				set_cell(pos, INVALID_TILE_SOURCE_ID, INVALID_TILE_ATLAS_COORDS)
