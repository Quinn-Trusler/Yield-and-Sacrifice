extends Node2D

var draggable_item = preload("res://scenes/draggable_item.tscn")
var draggable_items = []


func _ready():
	var temp = draggable_item.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize("carrot",false)
func _process(delta: float) -> void:
	#get_clicked_tile_power()
	#print()$TileMapLayer.get_cell_source_id($TileMapLayer.get_local_mouse_position())
	#get_clicked_tile_power()
	pass	
func get_clicked_tile_power():
	var clicked_cell = $TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position())
	var data = $TileMapLayer.get_cell_tile_data(clicked_cell)
	if data:
		print(data.get_custom_data_by_layer_id(0))
