extends DraggableItem

var num_items : int

func initialize(n,item_def):
	IS_BUNDLE = true
	item_name = n
	if item_def["is_animated"]:
		sprite_frames = load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION)
	else:
		sprite_frames = SpriteFrames.new()
		sprite_frames.add_frame("default",load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))
		sprite_frames.add_frame("default",load(item_def["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))

	#print_polygon()
	if item_name in GLOBALCONSTS.ITEM_POLYGONS:
		$BundleItemArea2D/CollisionPolygon2D.polygon = convert_polygon(GLOBALCONSTS.ITEM_POLYGONS[item_name])
	else:
		print("Warning: No colision polygon for " + item_name)

func set_num(num : int) -> void:
	num_items = num
	update_display_num()
func get_num() -> int:
	return num_items
func decrease_num() -> void:
	set_num(num_items - 1)
		
func update_display_num() -> void:
	$NumItems.text = str(num_items)
	
#When clicked instantiate item and decrease number by one.
#When clicked at 2 make 2 items and disappear thing
