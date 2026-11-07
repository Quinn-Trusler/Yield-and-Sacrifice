extends Node2D

var BUILDING_DEF = GLOBALCONSTS.BUILDING_DEF
var ITEM_DEF = GLOBALCONSTS.ITEM_DEF
var recipe

const recipe_display_names = {
	"get_item_plants_onto_recipe" : "Grows On", 
	"get_item_that_grows_on_recipe" : "Grows",
	"get_item_produced_from_recipes" : "Collect From",
	"get_building_produces_recipes" : "Produces",
	"get_item_crafts_into_recipes" : "Crafts Into",
	"get_item_crafted_from_recipes" : "Crafted From", 
	"get_building_crafting_recipes" : "Crafting"

}


@export var Name : Label

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
		setup_item_tooltip(item_name)
	print("--------------------------------------------------")
	for farmland_name in GLOBALCONSTS.MIDDLE_TILES:
		print(farmland_name)
		setup_farmland_tooltip(farmland_name)

func setup_tooltip(tooltip_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES):
	#print("Setting up tooltip")
	match tooltip_type:
		GLOBALCONSTS.TOOLTIP_TYPES.ITEM:
			setup_item_tooltip(tooltip_name)
		
		GLOBALCONSTS.TOOLTIP_TYPES.BUILDING:
			setup_building_tooltip(tooltip_name)
			
		GLOBALCONSTS.TOOLTIP_TYPES.FARMLAND:
			setup_farmland_tooltip(tooltip_name)

func setup_building_tooltip(tooltip_name : String) -> void:
	var recipe_functions = [
		get_building_crafting_recipes,
		get_building_produces_recipes
	]
	for recipe_function in recipe_functions:
		var recipes = recipe_function.call(tooltip_name)
		add_recipes_to_display(recipes, recipe_function.get_method())
	
func setup_farmland_tooltip(tooltip_name : String) -> void:
	var recipes = get_item_that_grows_on_recipe(tooltip_name)
	add_recipes_to_display(recipes, get_item_plants_onto_recipe.get_method())
	
	
func setup_item_tooltip(tooltip_name : String) -> void:
	#print("setup_item_tooltip", ITEM_DEF[tooltip_name]["display_name"])
	var recipe_functions = [
		get_item_plants_onto_recipe,
		get_item_produced_from_recipes,
		get_item_crafted_from_recipes,
		get_item_crafts_into_recipes]
	
	Name.text = ITEM_DEF[tooltip_name]["display_name"]
	for recipe_function in recipe_functions:
		var recipes = recipe_function.call(tooltip_name)
		add_recipes_to_display(recipes, recipe_function.get_method())

func add_recipes_to_display(recipes : Array, display_name : String):
	print("Recipe %s: "%[display_name], recipes)
	if recipes != []:
		# Instantiate recipe child
		# Setup recipe child with recipes
		pass


# ---Recipe Getters---
# Input an item, building or farmland name and get back an array of recipes
# I did try to name them well but they are very confusing

# Returns a list of land that the 'seed' item can be placed on
func get_item_plants_onto_recipe(item_name : String):
	if "place_on" in ITEM_DEF[item_name]:
		return ITEM_DEF[item_name]["place_on"]
	return []
	
# Returns a Array of items that grow on a farmaland
func get_item_that_grows_on_recipe(farmland_name : String) -> Array:
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
