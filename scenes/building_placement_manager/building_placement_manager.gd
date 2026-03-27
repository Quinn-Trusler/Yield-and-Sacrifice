extends Node2D

var in_placing_phase : bool = false
var building_to_place : String
var phantom_building_placed : bool = false
var building_location : Vector2i
var CONFIRMATION_POPUP_OFFSET : Vector2 = Vector2(0, -16)
var confirmation_popup_hover : bool = false

const BUILDING_NOTICE_PREFIX : String = "Place "
const BUILDING_NOTICE_SUFFIX : String = " to continue"
const INVALID_BUILDING_LOCATION : Vector2i = Vector2i(-99999,-99999) # Since there is no null for invalid building location


signal build_finished

@export var BuildingManager : Node2D
@export var ItemManager : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ConfirmationPopup.confirm.connect(confirm_placement)
	$ConfirmationPopup.cancel.connect(cancel_phantom_building)
	$ConfirmationPopup.updateHoverStatus.connect(_update_confirmation_popup_hover_status)
	set_initial_visibility()
	$TileOutline.play()

# Safety measure 
func set_initial_visibility() -> void:
	$ValidBuildingLayer.visible = false
	$ConfirmationPopup.visible = false
	$BuildingNotice.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_placing_phase: 
		var pos : Vector2i = $ValidBuildingLayer.local_to_map($ValidBuildingLayer.to_local(get_local_mouse_position()))#tile coordinates
		if not confirmation_popup_hover and pos != building_location and $ValidBuildingLayer.get_cell_source_id(pos) == -1:
			display_tile_outline(pos)
			if Input.is_action_just_pressed("mouse_down"):#and not confirmation_popup_hover:
				place_phantom_building(pos)
			#if $ValidBuildingLayer.get_cell_source_id(pos) == -1: #Empty slot
				#place_phantom_building(pos)
			#else:
				#print("You can't place here!")
		else:
			$TileOutline.visible = false
		
func place_phantom_building(pos : Vector2i) -> void:
	if phantom_building_placed and building_location != pos: # Remove the old phantom building
		BuildingManager.remove_phantom_building(building_location)
	building_location = pos
	phantom_building_placed = true
	$ConfirmationPopup.visible = true
	$ConfirmationPopup.position = $ValidBuildingLayer.to_global($ValidBuildingLayer.map_to_local(building_location)) + CONFIRMATION_POPUP_OFFSET
	BuildingManager.place_phantom_building(building_location, building_to_place)
	
func _update_confirmation_popup_hover_status(status : bool):
	confirmation_popup_hover = status
	#if in_placing_phase:
		#$TileOutline.visible = !status # WIll cause problem if confimation triggers after it is hidden
	
	
func confirm_placement() -> void:
	phantom_building_placed = false
	$ConfirmationPopup.visible = false
	BuildingManager.place_building(building_location, building_to_place)
	toggle_off()
	
		
func cancel_phantom_building() -> void:
	BuildingManager.remove_phantom_building(building_location)
	$ConfirmationPopup.visible = false
	phantom_building_placed = false
	building_location = INVALID_BUILDING_LOCATION
	
func update_building_notice():
	$BuildingNotice/SacrificeText.clear()
	if building_to_place == "farmland":
		$BuildingNotice/SacrificeText.add_text(BUILDING_NOTICE_PREFIX + "Farmland" + BUILDING_NOTICE_SUFFIX)
	else:
		$BuildingNotice/SacrificeText.add_text(BUILDING_NOTICE_PREFIX + GLOBALCONSTS.BUILDING_DEF[building_to_place]["display_name"] + BUILDING_NOTICE_SUFFIX)
		

func toggle_on(building_name : String) -> void:
	$BuildingNotice.visible = true
	$ValidBuildingLayer.display_invalid_tiles()
	in_placing_phase = true
	$ValidBuildingLayer.visible = true
	$TileOutline.visible = true
	building_to_place = building_name
	update_building_notice()
	ItemManager.dim()
	
func toggle_off():
	$BuildingNotice.visible = false
	in_placing_phase = false
	$ValidBuildingLayer.visible = false
	$TileOutline.visible = false
	build_finished.emit()
	ItemManager.undim()
	
	
func display_tile_outline(pos) -> void:#input tile coords
	$TileOutline.visible = true
	$TileOutline.position.x = pos.x*16 +$ValidBuildingLayer.position.x
	$TileOutline.position.y = pos.y*16 +$ValidBuildingLayer.position.y
	
