extends Node2D

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var TileLayerBG = get_node("/root/Main/TileMapLayerBG")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileOutline.play("default")

#gets tile name using global position
func get_tile_name_from_global(pos):
	pos = TileLayer.local_to_map(pos)#tile coordinates
	return get_tile_name_from_coords(pos)

#gets position using tile coordinates
func get_tile_name_from_coords(pos):
	var data = TileLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
	return "null"
func get_tile_name_from_coordinates(pos):
	var data = TileLayer2.get_cell_tile_data(pos)
	if data != null: 
		return data.get_custom_data_by_layer_id(0)
	return "null"
func get_mouse_tile_name():
	var mouse_cell = TileLayer.get_local_mouse_position()
	return get_tile_name_from_coords(mouse_cell)
func display_tile_outline(pos):#input a global position
	pos = TileLayer.local_to_map(pos)
	$TileOutline.visible = true
	$TileOutline.position.x = pos.x*16 +TileLayer.position.x
	$TileOutline.position.y = pos.y*16 +TileLayer.position.y
	
func hide_tile_outline():
	$TileOutline.visible = false
