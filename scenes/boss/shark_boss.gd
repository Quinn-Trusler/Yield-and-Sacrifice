extends Node2D


signal attempt_eat_item(mouse_on_mouth)

# Constants
const alcohol_decay_interval : float = 0.25
const shroom_decay_interval : float = 0.25

const alcohol_decay : int = 10
const shroom_decay : int = 10

const alcohol_amount : int = 100
const shroom_amount : int = 100

# Per second
var alcohol_decay_timer : float = 0
var shroom_decay_timer : float = 0
var delta_total : float = 0

var alcohol_level : int = 0
var shroom_level : int = 0

const MAX_LEVEL : int = 9999

var original_position : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("hungry")
	pass # Replace with function body.

func update_alcohol_effect():
	pass
	#$AnimatedSprite2D.material.set_shader_parameter("saturation", clampf(1.1 - alcohol_level/500.0,0,2))

func update_shroom_effect():
	pass
	#$AnimatedSprite2D.material.set_shader_parameter("chroma_offset_px", sqrt(shroom_level/100.0))
	#$AnimatedSprite2D.material.set_shader_parameter("wobble_px", 0.5 + shroom_level/500.0)

func tick_alcohol(delta):
	if alcohol_level:
		alcohol_decay_timer += delta
		if alcohol_decay_timer > alcohol_decay_interval:
			alcohol_decay_timer = 0
			alcohol_level = clampi(alcohol_level - alcohol_decay, 0, MAX_LEVEL)
			print("alcohol level: ", alcohol_level)
			update_alcohol_effect()

func tick_shroom(delta):
	if shroom_level:
		shroom_decay_timer += delta
		if shroom_decay_timer > shroom_decay_interval:
			shroom_decay_timer = 0
			shroom_level = clampi(shroom_level - shroom_decay, 0, MAX_LEVEL)
			print("shroom level: ", shroom_level)
			update_shroom_effect()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta_total += delta
	
	tick_alcohol(delta)
	tick_shroom(delta)
	
	animate_shark()

func set_pos(pos : Vector2):
	position.x = pos.x 
	position.y = pos.y
	original_position = pos

func animate_shark() -> void:
	var amplitude : float = 1
	var delta_y : float = amplitude*sin(delta_total*2)
	$AnimatedSprite2D.position.y = delta_y
	$MouthHitbox.position.y = delta_y
	if delta_y > amplitude -0.1:
		$Ripple.visible = true
		$Ripple.play()
	

func _on_mouth_hitbox_mouse_entered() -> void:
	#want to send signal up and say to eat item
	emit_signal("attempt_eat_item", true)

func _on_mouth_hitbox_mouse_exited() -> void:
	emit_signal("attempt_eat_item", false)

func react_to(reaction_name : GLOBALCONSTS.REACTIONS, multiplier : int) -> void:
	if reaction_name == GLOBALCONSTS.REACTIONS.ALCOHOL: 
		alcohol_level += alcohol_amount * multiplier
		update_alcohol_effect()
	if reaction_name == GLOBALCONSTS.REACTIONS.SHROOMS: 
		shroom_level += shroom_amount * multiplier
		update_shroom_effect()

func set_full() -> void:
	$AnimatedSprite2D.play("full")
func set_hungry() -> void:
	$AnimatedSprite2D.play("hungry")
