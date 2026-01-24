extends AnimatedSprite2D

var item_name;
var in_focus = false
var timer = 0

func initialize(n,item_def):
	item_name = n
	if item_def["is_animated"]:
		sprite_frames = load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION)
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))

func go_to_mouse_pos():
	position = get_global_mouse_position()
	
func pick_up():
	$PickUp.play()

func focus():
	pass
func stop_focus():
	pass
	
func drop():
	$Drop.play()

	
func _on_area_2d_mouse_entered() -> void:
	get_parent().add_to_focus_list(self)

func _on_area_2d_mouse_exited() -> void:
	get_parent().remove_from_focus_list(self)
	
