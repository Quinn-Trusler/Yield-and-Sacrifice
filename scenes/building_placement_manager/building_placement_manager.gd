extends Node2D

var in_placing_phase : bool = false
var building_to_place : String
var phantom_building_placed : bool = false

@export var BuildingManager : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_placing_phase: 
		if Input.is_action_pressed("mouse_down"):
			if not phantom_building_placed: # Attempt to place phantom building
				var pos : Vector2i = $ValidBuildingLayer.local_to_map($ValidBuildingLayer.to_local(get_local_mouse_position()))#tile coordinates
				if $ValidBuildingLayer.get_cell_source_id(pos) == -1: #Empty slot
					place_phantom_building(pos)
				else:
					print("You can't place here!")
		
func place_phantom_building(pos : Vector2i) -> void:
	phantom_building_placed = true
	BuildingManager.place_building(pos, building_to_place)
	toggle_off()
		
func cancel_phantom_building() -> void:
	phantom_building_placed = false
	
func toggle_on(building_name : String) -> void:
	$ValidBuildingLayer.display_invalid_tiles()
	in_placing_phase = true
	$ValidBuildingLayer.visible = true
	building_to_place = building_name
	
func toggle_off():
	phantom_building_placed = false
	in_placing_phase = false
	$ValidBuildingLayer.visible = false
	
	
