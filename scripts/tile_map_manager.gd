extends Node2D

var TileLayer : TileMapLayer
var TileLayer2 : TileMapLayer
var EffectLayer : TileMapLayer
var TerrainLayer : TileMapLayer
var DecorLayer : TileMapLayer

@export var BuildingManager : Node2D
@export var ItemManager : Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileOutline.play("default")
	
func get_building_manager():
	return BuildingManager
func get_item_manager():
	return ItemManager
func _process(_delta: float) -> void:
	var mouse_tile_pos = TileLayer.local_to_map(TileLayer.to_local(get_global_mouse_position()))
	if BuildingManager.get_building_interactable(mouse_tile_pos):
		display_tile_outline(mouse_tile_pos)
	else:
		if ItemManager.item_being_dragged:
			var item_tile_pos = TileLayer.local_to_map(TileLayer.to_local(ItemManager.item_being_dragged.position))
			if item_tile_pos and ItemManager.get_dragging_item_placeable():
				display_tile_outline(item_tile_pos)
			else:
				hide_tile_outline()
		else:
			hide_tile_outline()

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
	add_child(TileLayer2)
	add_child(EffectLayer)
	$TileOutline.move_to_front()
	
	
