extends Node2D

var in_placing_phase : bool = false
var building_to_place : String
var phantom_building_placed : bool = false
var building_location : Vector2i
var CONFIRMATION_POPUP_OFFSET : Vector2 = Vector2(0, -16)

@export var BuildingManager : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ConfirmationPopup.confirm.connect(confirm_placement)
	$ConfirmationPopup.cancel.connect(cancel_phantom_building)
	set_initial_visibility()

# Safety measure 
func set_initial_visibility() -> void:
	$ValidBuildingLayer.visible = false
	$ConfirmationPopup.visible = false

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
	building_location = pos
	phantom_building_placed = true
	$ConfirmationPopup.visible = true
	$ConfirmationPopup.position = $ValidBuildingLayer.to_global($ValidBuildingLayer.map_to_local(building_location)) + CONFIRMATION_POPUP_OFFSET
	BuildingManager.place_phantom_building(building_location, building_to_place)
	
func confirm_placement() -> void:
	phantom_building_placed = false
	$ConfirmationPopup.visible = false
	BuildingManager.place_building(building_location, building_to_place)
	toggle_off()
		
func cancel_phantom_building() -> void:
	BuildingManager.remove_phantom_building(building_location)
	$ConfirmationPopup.visible = false
	phantom_building_placed = false
	
func toggle_on(building_name : String) -> void:
	$ValidBuildingLayer.display_invalid_tiles()
	in_placing_phase = true
	$ValidBuildingLayer.visible = true
	building_to_place = building_name
	
func toggle_off():
	in_placing_phase = false
	$ValidBuildingLayer.visible = false
	
	
