extends Node2D

var BUILDING_DEF = GLOBALCONSTS.BUILDING_DEF
var ITEM_DEF = GLOBALCONSTS.ITEM_DEF
var CROP_DEF = GLOBALCONSTS.CROP_DEF
const RECIPE_SCENE = preload("res://scenes/tooltip/recipe.tscn")

const recipe_display_names = {
	"get_item_produced_by_crop_recipes" : "Currently Growing", 
	"get_item_plants_onto_recipes" : "Grows", 
	"get_item_that_grows_on_recipes" : "Grows On",
	"get_item_produced_from_recipes" : "Collect From",
	"get_building_produces_recipes" : "Produces",
	"get_item_crafts_into_recipes" : "Crafts Into",
	"get_item_crafted_from_recipes" : "Crafted From", 
	"get_building_crafting_recipes" : "Crafting"

}


@export var Name : Label
@export var VBox : VBoxContainer
@export var Bg : VBoxContainer

func erase_recipe():
	pass

# Use for debugging
func setup_all():
	print("Setting up all possible tooltips")
	for building_name in BUILDING_DEF:
		print(building_name)
		setup_building_tooltip(building_name)
	print("--------------------------------------------------")
	for item_name in ITEM_DEF:
		print(item_name)
		setup_tooltip(item_name, GLOBALCONSTS.TOOLTIP_TYPES.ITEM)
	print("--------------------------------------------------")
	for farmland_name in GLOBALCONSTS.MIDDLE_TILES:
		print(farmland_name)
		setup_tooltip(farmland_name, GLOBALCONSTS.TOOLTIP_TYPES.FARMLAND)


func setup_tooltip(tooltip_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES):
	
	var recipe_functions = []
	match tooltip_type:
		GLOBALCONSTS.TOOLTIP_TYPES.ITEM:
			Name.text = ITEM_DEF[tooltip_name]["display_name"]
			recipe_functions = [
				get_item_plants_onto_recipes,
				get_item_produced_from_recipes,
				get_item_crafted_from_recipes,
				get_item_crafts_into_recipes]
				
		GLOBALCONSTS.TOOLTIP_TYPES.BUILDING:
			Name.text = BUILDING_DEF[tooltip_name]["display_name"]
			recipe_functions = [
				get_building_crafting_recipes,
				get_building_produces_recipes
			]
			
		GLOBALCONSTS.TOOLTIP_TYPES.FARMLAND:
			Name.text = BUILDING_DEF[tooltip_name]["display_name"]
			recipe_functions = [get_item_that_grows_on_recipes]
			
		GLOBALCONSTS.TOOLTIP_TYPES.CROP:
			Name.text = CROP_DEF[tooltip_name]["display_name"]
			recipe_functions = [get_item_produced_by_crop_recipes]
			
	for recipe_function in recipe_functions:
		var recipes = recipe_function.call(tooltip_name)
		add_recipes_to_display(recipes, recipe_display_names[recipe_function.get_method()])
	
	await get_tree().process_frame # Wait since container does not update imidetly
	var box_size = VBox.get_size()
	Bg.set_height(box_size.y)
	Bg.visible = true
	print(VBox.get_size())

func setup_building_tooltip(tooltip_name : String) -> void:
	print("tooltip name: ", tooltip_name)


func add_recipes_to_display(recipes : Array, display_name : String):
	print("Recipe %s: "%[display_name], recipes)
	if recipes != []:
		var recipe_scene = RECIPE_SCENE.instantiate()
		VBox.add_child(recipe_scene) #add to vbox
		recipe_scene.setup(recipes, display_name)


# ---Recipe Getters---
# Input an item, building or farmland name and get back an array of recipes
# I did try to name them well but they are very confusing

# Returns an Array of whatever items is being produced by the crop
func get_item_produced_by_crop_recipes(crop_name : String) -> Array:
	var recipes = []
	if "resources" in CROP_DEF[crop_name]:
		for item_name in CROP_DEF[crop_name]["resources"]:
			# Only add item_name once since resources may list the same item multiple times
			if not item_name in recipes:
				recipes.append(item_name)
		return recipes
	return recipes

# Returns a list of land that the 'seed' item can be placed on
func get_item_plants_onto_recipes(item_name : String):
	if "place_on" in ITEM_DEF[item_name]:
		return ITEM_DEF[item_name]["place_on"]
	return []
	
# Returns a Array of items that grow on a farmaland
func get_item_that_grows_on_recipes(farmland_name : String) -> Array:
	var recipes = []
	for item_name in ITEM_DEF:
		if farmland_name in ITEM_DEF[item_name]["place_on"]:
			recipes.append(item_name)
	return recipes

# Returns an Array of pickable buildings that produce item
func get_item_produced_from_recipes(item_name : String) -> Array:
	var recipes = []
	for building_name in BUILDING_DEF:
		if "output_items" in BUILDING_DEF[building_name] and item_name in BUILDING_DEF[building_name]["output_items"]:
			recipes.append(building_name)
	return recipes

# Returns an Array of items that the building produces
func get_building_produces_recipes(building_name : String):
	var recipes = []
	if "output_items" in BUILDING_DEF[building_name]:
		for item_name in BUILDING_DEF[building_name]["output_items"]:
			# Only add item_name once since output_items may list the same item multiple times
			if not item_name in recipes:
				recipes.append(item_name)
		return recipes
	return []

# Returns an Array of [building , output item]
func get_item_crafts_into_recipes(item_name : String):
	var recipes = []
	for building_name in BUILDING_DEF:
		if "input_items" in BUILDING_DEF[building_name]:
			if item_name in BUILDING_DEF[building_name]["input_items"]:
				var output_item_name = BUILDING_DEF[building_name]["input_items"][item_name]
				recipes.append([building_name, output_item_name]) 
	return recipes
	
# Returns an Array of [input item  building] 
func get_item_crafted_from_recipes(item_name : String):
	var recipes = []
	for building_name in BUILDING_DEF:
		if "input_items" in BUILDING_DEF[building_name]:
			for input_item_name in BUILDING_DEF[building_name]["input_items"]:
				var output_item_name = BUILDING_DEF[building_name]["input_items"][input_item_name]
				if item_name == output_item_name:
					recipes.append([input_item_name, building_name]) 
	return recipes

# Returns an array [input item, output item]
func get_building_crafting_recipes(building_name : String):
	var recipes = []
	if "input_items" in BUILDING_DEF[building_name]:
		for input_item_name in BUILDING_DEF[building_name]["input_items"]:
			var output_item_name = BUILDING_DEF[building_name]["input_items"][input_item_name]
			recipes.append([input_item_name, output_item_name])
	return recipes
