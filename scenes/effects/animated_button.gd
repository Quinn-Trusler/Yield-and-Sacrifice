extends TextureButton

var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func hover() -> void:
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(4.5,4.5), 0.2)
	#tween.tween_property(self, "scale:y", 5, 0.3)
	#tween.tween_property(self, "rotation_degrees", 5.0 * [-1.0,1.0].pick_random(), 0.1)
	#tween.tween_property(self, "rotation_degrees",0,0.1).set_delay(0.1)
func unhover() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(4,4), 0.2)


func _on_mouse_entered() -> void:
	hover()
	
func _on_mouse_exited() -> void:
	unhover()
	#pass # Replace with function body.
