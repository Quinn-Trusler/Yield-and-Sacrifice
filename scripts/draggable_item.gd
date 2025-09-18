extends AnimatedSprite2D



#var types = 

var item_name;
var mouse_in_area = false
var dragging = false




func initialize(n,item_def):
	item_name = n
	sprite_frames.add_frame("default",load(item_def["img_name"]))
	play("default")
	#set_sprite_frames(value)
	#$sprite_frames.default = load("res://art/items/+"+n+"+.png")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		if mouse_in_area and dragging == false and get_parent().dragging_item == false:
			$PickUp.play()
			dragging = true
			get_parent().pickup_item()
	elif not Input.is_action_pressed("mouse_down") and dragging:
		dragging = false
		$Drop.play()
		get_parent().drop_item(self)
		
	if dragging:
		position = get_global_mouse_position()


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
