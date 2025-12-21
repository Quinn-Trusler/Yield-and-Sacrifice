extends AnimatedSprite2D

var RNG = RandomNumberGenerator.new()

@export var vel_range : Array[Vector2]
@export var accel : Vector2
var vel : Vector2
var item_name : String
var end_y

func set_vel():
	vel = Vector2(RNG.randf_range(vel_range[0].x, vel_range[0].y), RNG.randf_range(vel_range[1].x, vel_range[1].y))
func initialize(y, n : String,item_def : Dictionary ):
	item_name = n
	end_y = y
	set_vel()
	if item_def["is_animated"]:
		sprite_frames = load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION)
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))


func turn_to_draggable():
	get_parent().create_draggable_item(item_name,position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += vel * delta
	vel += accel * delta
	if vel.y > 0 and position.y > end_y: #Moving downwards and below postion
		turn_to_draggable()
		get_parent().delete_animated_item(self)
