extends Node2D

var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var draggable_items = []
var dragging_item = false
var MAPSIZE = [-13,5,4,-4]

var RNG = RandomNumberGenerator.new()

var atlas_decoded = {"carrot_0":Vector2(2,4)}


func _ready():
	create_draggable_item("carrot",Vector2(50,10))
	create_draggable_item("carrot",Vector2(-70,-30))
	
	
func create_draggable_item(item_name,pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,false)
	temp.position = pos
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		click_tile()
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
	
	var delete_item = false
	var pos = $TileMapLayer.to_local(item.position)
	var tile_name = get_tile_name(pos)
	pos = $TileMapLayer.local_to_map(pos)
	
	
	if tile_name == "lava":
		$SacraficeManager.sacrafice(item.item_name)
		delete_item = true
	if item.item_name == "carrot":
		if tile_name == "farmland":
			if $TileMapLayer2.get_cell_source_id(pos) ==-1:#empty cell
				delete_item = true
				$TileMapLayer2.set_cell(pos,2,Vector2.ZERO,1)#plant carrot crop
			else:
				print("Error: Cannot plant on already planted farmland")
				
				
				
	if delete_item:
		draggable_items.erase(item)
		item.queue_free()
func click_tile():
	var tile_name = get_mouse_tile_name()
	#if tile_name == "farmland":
	var pos = $TileMapLayer.get_local_mouse_position()
	pos = $TileMapLayer.local_to_map(pos)
	
	if $TileMapLayer2.get_cell_source_id(pos) !=-1:#2nd layer cell not empty
		var scene = $TileMapLayer2.get_cell_scene(pos)
		
		if scene.IS_CROP:#growth_complete:
			if scene.harvest_on_click:
				var temp = scene.harvest()
				if temp:
					$TileMapLayer2.set_cell(pos,-1)#delete cell
					for i in range(len(temp)):
						create_draggable_item(temp[i],get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))
			#create_draggable_item("carrot",get_global_mouse_position()+ Vector2(RNG.randi_range(-7,7),RNG.randi_range(-7,7)))
		
		
func punish():
	$GodChoiceManager.display_punishments()
func reward():
	$GodChoiceManager.display_rewards()
