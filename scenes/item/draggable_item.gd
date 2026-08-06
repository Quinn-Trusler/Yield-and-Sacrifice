extends AnimatedSprite2D

class_name DraggableItem

var RNG = RandomNumberGenerator.new()

var item_name : String
var IS_BUNDLE : bool = false
var num_items : int  = 1

@export var accel : Vector2
var vel : Vector2
var end_y : float
var vel_factor : Vector2
var running_animation : bool = false
var scatter_tween

var in_push_zone : int = 0
var push_vel : Vector2
var push_direction : Vector2
var push_zone_entrance_point : Vector2


var in_focus = false

func initialize(n,item_def, n_items : int = 1):
	set_num(n_items)
	item_name = n
	if item_def["is_animated"]:
		sprite_frames = load(GLOBALCONSTS.ITEMS_FOLDER + item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION)
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(GLOBALCONSTS.ITEMS_FOLDER + item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))
		sprite_frames.add_frame("default",load(GLOBALCONSTS.OUTLINE_ITEMS_FOLDER + item_def["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))
	
	if "num_offset" in item_def:
		$NumItems.position = Vector2(item_def["num_offset"][0], item_def["num_offset"][1])
	else:
		print("Warning: No number offset for " + item_name)
	print_polygon()
	if item_name in GLOBALCONSTS.ITEM_POLYGONS:
		$DraggableItemArea2D/CollisionPolygon2D.polygon = convert_polygon(GLOBALCONSTS.ITEM_POLYGONS[item_name])
	else:
		print("Warning: No colision polygon for " + item_name)
		

func play_animation(ending_y_position:float, velocity_factor:Vector2, velocity : Vector2):
	end_y = ending_y_position
	vel_factor = velocity_factor
	running_animation = true
	vel = vel_factor * velocity
	
func scatter_to(pos : Vector2, time : float, rot : int):
	scatter_tween = create_tween()
	scatter_tween.set_trans(Tween.TRANS_SPRING)
	scatter_tween.set_ease(Tween.EASE_IN_OUT)
	scatter_tween.tween_property(self, "position", pos, time)

	
	var rotation_tween = create_tween()
	#rotation_tween.set_trans(Tween.TRANS_SPRING)
	rotation_tween.set_ease(Tween.EASE_IN_OUT)
	rotation_tween.set_parallel().tween_property(self, "rotation_degrees", rot, time/2)
	rotation_tween.chain().tween_property(self, "rotation_degrees", -rot, time/2)
	rotation_tween.chain().tween_property(self, "rotation_degrees", 0, time/2)
	
func _process(delta: float) -> void:
	if running_animation:
		position += vel * delta
		vel += accel * delta
		if vel.y > 0 and position.y > end_y: #Moving downwards and below postion
			running_animation = false
	elif in_push_zone and not in_focus:
		#set_push_direction()
		push_vel += push_direction * GLOBALCONSTS.PUSH_ACCEL * delta
		position += push_vel * delta
		#
		pass
func update_display_num() -> void:
	# override
	if num_items == 1:
		$NumItems.visible = false
	else:
		$NumItems.visible = true
	$NumItems.text = str(num_items)

func set_num(num : int) -> void:
	num_items = num
	if num_items == 1:
		IS_BUNDLE = false
	else:
		IS_BUNDLE = true
	update_display_num()
	
func get_num() -> int:
	return num_items
	
func decrease_num(num : int = 1) -> void:
	set_num(num_items - num)
	
func increase_num(num : int = 1) -> void:
	set_num(num_items + num)

func convert_polygon(poly):
	var new_poly = []
	for point in poly:
		new_poly.append(Vector2(point[0], point[1]))
	return new_poly

func go_to_mouse_pos():
	position = get_global_mouse_position()
	running_animation = false

func focus():
	in_focus = true
	frame = 1

func stop_focus():
	in_focus = false
	frame = 0
	if in_push_zone: 
		set_push_direction()
	
func _on_area_2d_mouse_entered() -> void:
	get_parent().add_to_focus_list(self)

func _on_area_2d_mouse_exited() -> void:
	get_parent().remove_from_focus_list(self)

	
# --- Polygon Generator
#Snap value to nearest 0.5 or 0
func snap05(num : float) -> String:
	return str(roundi(num*2) / 2.0)
#Used to generate polygon strings used in global consts
func print_polygon():
	var poly = $DraggableItemArea2D/CollisionPolygon2D.polygon
	var string = "["
	for i in range(len(poly)):
		var point = poly[i]
		string += "["+snap05(point[0]) + ", " + snap05(point[1]) + "]"
		if i < len(poly) -1:
			string += ", "
	string += "]"
	print(string)

func set_push_direction():
	#push_direction = (push_zone_entrance_point - position).normalized() 
	push_direction = (GLOBALCONSTS.PUSH_ITEM_DEST - position).normalized() 
	push_vel = push_direction * GLOBALCONSTS.PUSH_ITEM_SPEED

func _on_draggable_item_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("PushItemZone"):
		if scatter_tween: # Hacky way of stopping scatter from going out of bounds too much
			scatter_tween.kill()
			push_direction = (GLOBALCONSTS.PUSH_ITEM_DEST - position).normalized() 
			push_vel = push_direction * (GLOBALCONSTS.PUSH_ITEM_SPEED + 200) 
		elif in_push_zone == 0: # First no item zone entered
			#push_zone_entrance_point = position
			set_push_direction()
		in_push_zone += 1

func _on_draggable_item_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PushItemZone"):
		in_push_zone -= 1
