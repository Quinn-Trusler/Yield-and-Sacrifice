extends Node2D


signal attempt_eat_item(mouse_on_mouth)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouth_hitbox_mouse_entered() -> void:
	#want to send signal up and say to eat item
	emit_signal("attempt_eat_item", true)


func _on_mouth_hitbox_mouse_exited() -> void:
	emit_signal("attempt_eat_item", false)
