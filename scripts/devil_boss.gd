extends Node2D


signal attempt_eat_item(mouse_on_mouth)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delta_total = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta_total += delta
	animate_devil()
	
func animate_devil():
	rotation = 20*(PI/180)*sin(delta_total)

func _on_mouth_hitbox_mouse_entered() -> void:
	#want to send signal up and say to eat item
	emit_signal("attempt_eat_item", true)


func _on_mouth_hitbox_mouse_exited() -> void:
	emit_signal("attempt_eat_item", false)
	
func set_full():
	$HungrySprite.visible = false
	$FullSprite.visible = true
func set_hungry():
	$HungrySprite.visible = true
	$FullSprite.visible = false
