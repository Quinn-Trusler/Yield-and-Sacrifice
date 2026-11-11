extends Node2D

@onready var tooltip_scene = load("res://scenes/tooltip/tooltip.tscn")

var tooltip = null
var showing_tooltip : bool = false

var hover_item = HoverObject.new()
var hover_tile = HoverObject.new()
var hover_sacrifice = HoverObject.new()


class HoverObject:
	var pos : Vector2
	var tooltip_name : String
	var tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES
	var hover_time : float 
	var hovering : bool
	var is_tooltip : bool
	
	func _init() -> void:
		hover_time = 0
		
	func set_hover(p, t_name, t_type) -> void:
		pos = p
		tooltip_name = t_name
		tooltip_type = t_type
		hover_time = 0
		hovering = true
		
	func unset_hover():
		hover_time = 0
		hovering = false
		is_tooltip = false
	
	func increment_timer(delta : float):
		if hovering:
			hover_time += delta
			
	func is_finished_timer():
		return hover_time >= GLOBALCONSTS.HOVER_TIME_TOOLTIP



func remove_hover(tooltip_hover_type :GLOBALCONSTS.TOOLTIP_HOVER_TYPES):
	var hover_object = _get_hover_object_from_type(tooltip_hover_type)	
	if hover_object.is_tooltip:
		_erase_tooltip()
	hover_object.unset_hover()
	

func add_hover(pos : Vector2, tooltip_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES, tooltip_hover_type :GLOBALCONSTS.TOOLTIP_HOVER_TYPES):
	var hover_object = _get_hover_object_from_type(tooltip_hover_type)	
	hover_object.set_hover(pos, tooltip_name, tooltip_type)

# Also erases the tooltip if any
func erase_all_hovers():
	for hover_object in [hover_item, hover_sacrifice, hover_tile]:
		if hover_object.is_tooltip:
			_erase_tooltip()
		hover_object.unset_hover() 


func _update_hover_timers(delta : float):
	if hover_item.hovering:
		hover_item.increment_timer(delta)
	# Don't update other timers since item is overtop of them
	else:
		hover_tile.increment_timer(delta)
		hover_sacrifice.increment_timer(delta)
	
	for hover_obj in [hover_item, hover_tile, hover_sacrifice]:
		if not showing_tooltip and hover_obj.is_finished_timer() and hover_obj.hovering:
			_create_tooltip_with_hover_object(hover_obj)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_hover_timers(delta)
	if Input.is_action_just_pressed("show_tooltip"):
		for hover_obj in [hover_item, hover_tile, hover_sacrifice]:
			if not showing_tooltip and hover_obj.hovering:
				_create_tooltip_with_hover_object(hover_obj)
			

func _get_hover_object_from_type(tooltip_hover_type :GLOBALCONSTS.TOOLTIP_HOVER_TYPES):
	var hover_object
	match tooltip_hover_type:
		GLOBALCONSTS.TOOLTIP_HOVER_TYPES.ITEM:
			hover_object = hover_item
		GLOBALCONSTS.TOOLTIP_HOVER_TYPES.TILE:
			hover_object = hover_tile
		GLOBALCONSTS.TOOLTIP_HOVER_TYPES.SACRIFICE:
			hover_object = hover_sacrifice
	return hover_object

func _create_tooltip_with_hover_object(hover_object : HoverObject) -> void:
	hover_object.is_tooltip = true
	print("create tooltip",hover_object.pos, hover_object.tooltip_name, hover_object.tooltip_type)
	_create_tooltip(hover_object.pos, hover_object.tooltip_name, hover_object.tooltip_type)

func _create_tooltip(pos : Vector2, tooltip_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES) -> void:
	if not showing_tooltip: 
		_erase_tooltip()
		showing_tooltip = true
		tooltip = tooltip_scene.instantiate()
		add_child(tooltip)
		tooltip.setup_tooltip(tooltip_name, tooltip_type)
		tooltip.position = pos

func _erase_tooltip() -> void:
	#pass
	showing_tooltip = false
	if tooltip:
		tooltip.queue_free()


# Should take in top left and bottom right points and use them to determine where the popup goes
# Above bellow side

	
	
