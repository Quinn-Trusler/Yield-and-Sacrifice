extends Node2D

@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var EffectLayer = get_node("/root/Main/EffectLayer")
@onready var TerrainLayer = get_node("/root/Main/TerrainLayer")

@onready var BuildingManager = get_node("/root/Main/BuildingManager")
@onready var ItemManager = get_node("/root/Main/ItemManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileOutline.play("default")
func _process(_delta: float) -> void:
	var tile_pos = TileLayer.local_to_map(TileLayer.to_local(get_global_mouse_position()))
	if ItemManager.get_dragging_item_placeable() or BuildingManager.get_building_interactable(tile_pos):
		display_tile_outline(tile_pos)
	else:
		hide_tile_outline()

func display_tile_outline(pos):#input tile coords
	$TileOutline.visible = true
	$TileOutline.position.x = pos.x*16 +TileLayer.position.x
	$TileOutline.position.y = pos.y*16 +TileLayer.position.y
	
func hide_tile_outline():
	$TileOutline.visible = false
