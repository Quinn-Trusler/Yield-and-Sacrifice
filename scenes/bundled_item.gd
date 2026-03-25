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
		#set_sprite_2ds(load(item_def["img_name"]+GLOBALCONSTS.IMG_EXTENSION))
	if "num_offset" in item_def:
		$NumItems.position = Vector2(item_def["num_offset"][0], item_def["num_offset"][1])
	else:
		print("Warning: No number offset for " + item_name)
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
	
func set_sprite_2ds(img) -> void:
	for i in range(GLOBALCONSTS.MAX_BUNDLE_ITEMS):
		var temp = get_node("Sprite2Ds/"+str(i+1))
		temp.texture = img
		
func update_display_num() -> void:
	$NumItems.text = str(num_items)
	#update_sprite_visibility()
	
func update_sprite_visibility():
	for i in range(num_items):
		var temp = get_node("Sprite2Ds/"+str(i+1))
		temp.visible = true
	for i in range(num_items,GLOBALCONSTS.MAX_BUNDLE_ITEMS):
		var temp = get_node("Sprite2Ds/"+str(i+1))
		temp.visible = false
	
	#Create 1 colision polygon and 1 sprite 2D
	
	
	#Display more items
	#Create adequate number of colision polygons
	

	
	
#When clicked instantiate item and decrease number by one.
#When clicked at 2 make 2 items and disappear thing
