extends Node2D

var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var draggable_items = []
var dragging_item = false

var RNG = RandomNumberGenerator.new()

func _ready():
	create_draggable_item("carrot")
	create_draggable_item("carrot")
	
func create_draggable_item(item_name):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,false)
	temp.position.x = RNG.randi_range(-200,200)
	
func _process(delta: float) -> void:
	#print(get_mouse_tile_name())
	pass
func get_mouse_tile_name():
	var mouse_cell = $TileMapLayer.get_local_mouse_position()
	return get_tile_name(mouse_cell)
func get_tile_name(pos):
	pos = $TileMapLayer.local_to_map(pos)
	var data = $TileMapLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
	return "null"
		
func pickup_item():
	dragging_item = true
func drop_item(item):
	dragging_item = false
	var pos = $TileMapLayer.to_local(item.position)
	var tile_name = get_tile_name(pos)
	print(tile_name)
	if tile_name == "lava":
		draggable_items.erase(item)
		item.queue_free()
		
		
	
