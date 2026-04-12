extends AnimatedSprite2D

class_name DraggableItem

var item_name : String
var IS_BUNDLE : bool = false
var num_items : int 

func initialize(n,item_def, n_items : int = 1):
	set_num(n_items)
	item_name = n
	if item_def["is_animated"]:
		sprite_frames = load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION)
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))
		sprite_frames.add_frame("default",load(item_def["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))
	
	if "num_offset" in item_def:
		$NumItems.position = Vector2(item_def["num_offset"][0], item_def["num_offset"][1])
	else:
		print("Warning: No number offset for " + item_name)
	print_polygon()
	if item_name in GLOBALCONSTS.ITEM_POLYGONS:
		$DraggableItemArea2D/CollisionPolygon2D.polygon = convert_polygon(GLOBALCONSTS.ITEM_POLYGONS[item_name])
	else:
		print("Warning: No colision polygon for " + item_name)

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
	
func pick_up():
	$PickUp.play()

func focus():
	frame = 1

func stop_focus():
	frame = 0
	
func drop():
	$Drop.play()
	
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
