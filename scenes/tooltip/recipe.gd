extends HBoxContainer

@export var VBox1 : VBoxContainer
@export var arrow_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func setup(recipes : Array) -> void:
	if typeof(recipes[0]) == TYPE_ARRAY:
		print("Double recipes: ", recipes)
		for recipe in recipes:
			double(recipe)
	else:
		for recipe in recipes:
			single(recipe)
		
# Currently does not know what type of ingredient it is, so just tries to grab from any list
func get_image(ingredient : String):
	if ingredient in GLOBALCONSTS.ITEM_DEF:
		assert("img_name" in GLOBALCONSTS.ITEM_DEF[ingredient], "no img_name in ITEM_DEF[%s]"%ingredient)
		return load(GLOBALCONSTS.ITEMS_FOLDER + GLOBALCONSTS.ITEM_DEF[ingredient]["img_name"] + GLOBALCONSTS.IMG_EXTENSION)
	elif ingredient in GLOBALCONSTS.BUILDING_DEF:
		assert("icon_img" in GLOBALCONSTS.BUILDING_DEF[ingredient], "no icon_img in BUILDING_DEF[%s]"%ingredient)
		return load(GLOBALCONSTS.ICON_IMAGE_FOLDER + GLOBALCONSTS.BUILDING_DEF[ingredient]["icon_img"] + GLOBALCONSTS.IMG_EXTENSION)
	elif ingredient in GLOBALCONSTS.EXTRA_RECIPE_IMGS:
		return load(GLOBALCONSTS.ICON_IMAGE_FOLDER + GLOBALCONSTS.EXTRA_RECIPE_IMGS[ingredient] + GLOBALCONSTS.IMG_EXTENSION)
	else:
		assert(false, "Ingredient: %s not defined in ITEM_DEF, BUILDINGS, EXTRA_RECIPE_IMGS"%[ingredient])


func get_texture_rect(ingredient : String):
	var img = get_image(ingredient)
	var texture_rect = TextureRect.new()
	texture_rect.texture = img
	texture_rect.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED)
	return texture_rect

func get_texture_rect_arrow() -> TextureRect:
	var texture_rect_arrow = TextureRect.new()
	texture_rect_arrow.texture = arrow_texture
	texture_rect_arrow.set_stretch_mode(TextureRect.STRETCH_KEEP_CENTERED)
	return texture_rect_arrow

func single(recipe) -> void:
	print("single")
	var texture_rect = get_texture_rect(recipe)
	VBox1.add_child(texture_rect)
	
func double(recipe) -> void:
	print("double")
	var HBox = HBoxContainer.new()
	
	
	var texture_rect1 = get_texture_rect(recipe[0])
	var texture_rect2 = get_texture_rect(recipe[1])
	var texture_rect_arrow = get_texture_rect_arrow()
	
	HBox.add_child(texture_rect1)
	HBox.add_child(texture_rect_arrow)
	HBox.add_child(texture_rect2)
	VBox1.add_child(HBox)
	
