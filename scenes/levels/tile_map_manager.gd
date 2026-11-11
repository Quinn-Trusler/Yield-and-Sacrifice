extends Node2D

var TileLayer : TileMapLayer
var TileLayer2 : TileMapLayer
var EffectLayer : TileMapLayer
var TerrainLayer : TileMapLayer
var DecorLayer : TileMapLayer

@export var BuildingManager : Node2D
@export var ItemManager : Node2D

var tile_in_focus : Vector2i = Vector2i.ZERO
signal add_tooltip_hover(pos, tooltip_name, tooltip_type, tooltip_hover_type)
signal remove_tooltip_hover(tooltip_hover_type)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileOutline.play("default")
	
func get_building_manager():
	return BuildingManager
func get_item_manager():
	return ItemManager


func get_tile_rect(tile_pos) -> Rect2:
	var pos = TileLayer.to_global(TileLayer.map_to_local(tile_pos))
	var tile_size = Vector2(16, 16)
	var rect = Rect2(pos - tile_size/2,tile_size)
	return rect

func tooltip_process() -> void:
	# Update tile in focus
	var new_tile_in_focus = TileLayer.local_to_map(TileLayer.to_local(get_global_mouse_position()))
	if new_tile_in_focus != tile_in_focus:
		tile_in_focus = new_tile_in_focus
		_remove_tooltip_hover()
		
		# TODO deal with edgecase when building or farmland changes without the player moving the mouse
		# This can happen when the player drops a crop onto a farmland
		# Only increment tile in focus timer if on building or farmland
		var building_scene = BuildingManager.get_building_scene(tile_in_focus)
		var farmland_name = BuildingManager.get_farmland(tile_in_focus)
		
		if building_scene or farmland_name:
			var tile_rect =  get_tile_rect(tile_in_focus)
			if building_scene:
				if building_scene.BUILDING_TYPE == "building":
					_add_tooltip_hover(tile_rect, building_scene.BUILDING_NAME, GLOBALCONSTS.TOOLTIP_TYPES.BUILDING)
				else:
					_add_tooltip_hover(tile_rect, building_scene.BUILDING_NAME, GLOBALCONSTS.TOOLTIP_TYPES.CROP)
			else:
				_add_tooltip_hover(tile_rect, farmland_name, GLOBALCONSTS.TOOLTIP_TYPES.FARMLAND)

func _process(_delta: float) -> void:
	var mouse_tile_pos = TileLayer.local_to_map(TileLayer.to_local(get_global_mouse_position()))
	
	tooltip_process()
	
	if BuildingManager.has_interactable_building(mouse_tile_pos):
		display_tile_outline(mouse_tile_pos)
	else:
		if ItemManager.item_being_dragged:
			var item_tile_pos = TileLayer.local_to_map(TileLayer.to_local(ItemManager.item_being_dragged.position))
			if item_tile_pos and ItemManager.is_dragging_item_placeable():
				display_tile_outline(item_tile_pos)
			else:
				hide_tile_outline()
		else:
			hide_tile_outline()


func _remove_tooltip_hover() -> void:
	remove_tooltip_hover.emit(GLOBALCONSTS.TOOLTIP_HOVER_TYPES.TILE)

func _add_tooltip_hover(tile_pos : Rect2,building_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES) -> void:
	add_tooltip_hover.emit(tile_pos, building_name, tooltip_type, GLOBALCONSTS.TOOLTIP_HOVER_TYPES.TILE)

func display_tile_outline(pos):#input tile coords
	$TileOutline.visible = true
	$TileOutline.position.x = pos.x*16 +TileLayer.position.x
	$TileOutline.position.y = pos.y*16 +TileLayer.position.y
	
func hide_tile_outline():
	$TileOutline.visible = false
	
func set_tile_layers(tile_layers):
	
	TerrainLayer = tile_layers["TerrainLayer"].instantiate()
	DecorLayer = tile_layers["DecorLayer"].instantiate()
	TileLayer = tile_layers["TileLayer"].instantiate()
	TileLayer2 = tile_layers["TileLayer2"].instantiate()
	EffectLayer = tile_layers["EffectLayer"].instantiate()

	
	add_child(TerrainLayer)
	add_child(DecorLayer)
	add_child(TileLayer)
	if "DecorLayer2" in tile_layers:
		var DecorLayer2 = tile_layers["DecorLayer2"].instantiate()
		add_child(DecorLayer2)
	add_child(TileLayer2)
	add_child(EffectLayer)
	
	$TileOutline.move_to_front()
	
	
