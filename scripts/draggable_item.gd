extends AnimatedSprite2D



#var types = 

var item_name;
var mouse_in_area = false
var dragging = false

var timer = 0

func get_tip_pos():
	return $Tip.global_position

func initialize(n,item_def):
	item_name = n
	if item_def["is_animated"]:
		sprite_frames = load(item_def["img_name"])
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(item_def["img_name"]))
	#play("default")
	#set_sprite_frames(value)
func go_to_mouse_pos():
	position = get_global_mouse_position()
	if item_name == "watering_can":
		position -= get_tip_pos() - get_global_mouse_position()
	
func pick_up():
	$PickUp.play()
	dragging = true
	get_parent().pickup_item(self)
func drop():
	dragging = false
	$Drop.play()
	get_parent().drop_item(self)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		if mouse_in_area and dragging == false and get_parent().dragging_item == false:
			pick_up()
	elif not Input.is_action_pressed("mouse_down") and dragging:
		drop()
		
	if dragging:
		go_to_mouse_pos()


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
