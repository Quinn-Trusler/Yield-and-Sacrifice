extends Node

var GAME_SCENE = preload("res://scenes/main.tscn")
var game_scene = null # Active instance of GAME_SCENE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#generate_level("Plains", "easy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@export var DeathScreen :CanvasLayer
func game_over():
	#go back to menu or something
	DeathScreen.visible = true
	game_scene.queue_free()
	get_tree().paused = true
	
@export var WinScreen :CanvasLayer
func win_game():
	WinScreen.visible = true
	game_scene.queue_free()
	get_tree().paused = true



#var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot","is_animated":false,"points":10,"place_on":["dry_farmland", "sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [0,5]},
#"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe","is_animated":false,"points":10,"place_on":["dry_farmland"],"reaction":REACTIONS.NONE,  "num_offset" : [4,3]},
#"plastic_bag":{"display_name":"Plastic Bag","img_name":ITEMS_FOLDER + "plastic_bag","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [5, -1]},
#"rice":{"display_name":"Rice","img_name":ITEMS_FOLDER + "rice","is_animated":false,"points":10,"place_on":["swamp_water_edge"],"reaction":REACTIONS.NONE,  "num_offset" : [6.5, 0]},
#"prickly_pear":{"display_name":"Prickly Pear","img_name":ITEMS_FOLDER + "prickly_pear","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [3, -1]},
#"devil_pepper":{"display_name":"Devil Pepper","img_name":ITEMS_FOLDER + "devil_pepper","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [6,-3]},
#"wheat":{"display_name":"Wheat","img_name":ITEMS_FOLDER + "wheat","is_animated":false,"points":10,"place_on":["dry_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [4,1]},
#"sugarcane":{"display_name":"Sugarname","img_name":ITEMS_FOLDER + "sugarcane","is_animated":false,"points":10,"place_on":["swamp_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [5,2]},
#"melon":{"display_name":"Melon","img_name":ITEMS_FOLDER + "melon","is_animated":false,"points":10,"place_on":["sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
#"fish":{"display_name":"Fish","img_name":ITEMS_FOLDER + "fish","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
#"sugar":{"display_name":"Sugar","img_name":ITEMS_FOLDER + "sugar","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,3]},
#"cooked_rice":{"display_name":"Cooked Rice","img_name":ITEMS_FOLDER + "cooked_rice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [8.5,-1]},
#"flour":{"display_name":"Flour","img_name":ITEMS_FOLDER + "flour","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,1]},
#"bread":{"display_name":"Bread","img_name":ITEMS_FOLDER + "bread","is_animated":false,"points":30,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8,4]},
#"mushroom":{"display_name":"Mushroom","img_name":ITEMS_FOLDER + "mushroom","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.SHROOMS, "num_offset" : [4,0]},
#"cranberry":{"display_name":"Cranberry","img_name":ITEMS_FOLDER + "cranberry","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
#"cranberry_jam":{"display_name":"Cranberry Jam","img_name":ITEMS_FOLDER + "cranberry_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
#"melon_jam":{"display_name":"Melon Jam","img_name":ITEMS_FOLDER + "melon_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
#"prickly_pear_jam":{"display_name":"Prickly Pear Jam","img_name":ITEMS_FOLDER + "prickly_pear_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5,0]},
#"vodka":{"display_name":"Vodka","img_name":ITEMS_FOLDER + "vodka","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3,3]},
#"rum":{"display_name":"Rum","img_name":ITEMS_FOLDER + "rum","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [5,2]},
#"sake":{"display_name":"Sake","img_name":ITEMS_FOLDER + "sake","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3.5, 2]},
#"gold":{"display_name":"Gold","img_name":ITEMS_FOLDER + "coin","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE},
#"pepper_juice":{"display_name":"Pepper Juice","img_name":ITEMS_FOLDER + "pepper_juice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE}
#}
#var IMG_EXTENSION = ".png"
#
## Place on means what terrain tiles the building is ristricted to
#var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["fish"],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres", "offset":[0,0],"bounce":false},
	#"well":{"display_name":"Well","output_items":["gold"],"items_to_start_timer":0,"input_items":{},"total_stages":1,"stage_to_harvest":1,"time_per_stage":4,"destroy_on_harvest":false,"stage_loss_on_harvest": 1, "frames": BUILDINGS_FRAMES_FOLDER + "well.tres", "offset":[0,-1],"bounce":true},
	#"god_gift":{"display_name":"Gift","output_items":[],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "gift.tres", "offset":[0,-3], "bounce":false},
	#"barrel":{"display_name":"Barrel","output_items":["vodka"],"items_to_start_timer":1,"input_items":{"potatoe" : "vodka", "sugarcane":"rum","rice":"sake","prickly_pear":"prickly_pear_jam","melon":"melon_jam","cranberry":"cranberry_jam"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "barrel.tres", "offset": [0,0], "extra_tiles": [],"bounce":true},
	#"oven":{"display_name":"Oven","output_items":[],"items_to_start_timer":1,"input_items":{"flour" : "bread"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "oven.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	#"mill":{"display_name":"Mill","output_items":[],"items_to_start_timer":1,"input_items":{"wheat" : "flour", "sugarcane" : "sugar", "rice" : "cooked_rice"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "mill.tres", "offset": [0,-2.5], "extra_tiles": [],"bounce":true},
	#"mushroom_patch":{"display_name":"Mushroom Patch","output_items":["mushroom"],"items_to_start_timer":0,"input_items":{},"total_stages":3,"stage_to_harvest":1,"time_per_stage":5,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["grass", "swamp_grass"], "frames": BUILDINGS_FRAMES_FOLDER + "mushroom_patch.tres", "offset": [0,0], "extra_tiles": [], "bounce":false},
	#"devil_vine":{"display_name":"Devil Vine","output_items":["devil_pepper"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":4,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 4, "place_on":["sand"],"frames": BUILDINGS_FRAMES_FOLDER + "devil_vine.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	#"prickly_pear_cactus":{"display_name":"Prickly Pear Cactus","output_items":["prickly_pear"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":1,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["sand"], "frames": BUILDINGS_FRAMES_FOLDER + "prickly_pear_cactus.tres", "offset": [0,-1], "extra_tiles": [], "bounce":false},
	#"cranberry_bush":{"display_name":"Cranberry Bush","output_items":["cranberry", "cranberry", "cranberry"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":4,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 3, "place_on":["swamp_water_edge"],"no_building_placement_override" : true, "frames": BUILDINGS_FRAMES_FOLDER + "cranberry_bush.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	#"farmland":{"display_name": "Farmland","place_on": ["grass"]},
	#"sandy_farmland":{"display_name": "Sandy Farmland","place_on": ["sand"]},
	#"swamp_farmland":{"display_name": "Swamp Farmland","place_on": ["swamp_grass"]}
#}
#var choices = {"carrot":{"title": "Carrot","img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"item unlock":["carrot"],"unlock literal":true,"reward": "carrot","amt" : 2},
#"potatoe":{"title": "Potatoe","img": "res://art/items/potatoe.png","text":"default","type": TYPES.Item,"item unlock":["potatoe"],"unlock literal":true,"reward": "potatoe","amt" : 2},
#"rice":{"title": "Rice","img": "res://art/items/rice.png","text":"default","type": TYPES.Item,"item unlock":["rice"],"unlock literal":true,"reward": "rice","amt" : 2},
#"melon":{"title": "Melon","img": "res://art/items/melon.png","text":"default","type": TYPES.Item,"item unlock":["melon"],"unlock literal":true,"reward": "melon","amt" : 2},
#"wheat":{"title": "Wheat","img": "res://art/items/wheat.png","text":"default","type": TYPES.Item,"item unlock":["wheat"],"unlock literal":true,"reward": "wheat","amt" : 2},
#"-2 seconds":{"title": "God's Disgrace","img": "res://art/godchoice/time.png","text":"Every round will be 2 seconds shorter","type": TYPES.Time_,"item unlock":[],"unlock literal":false,"reward": -2,"amt" : 1},
#"sugarcane":{"title": "Sugarcane","img": "res://art/items/sugarcane.png","text":"default","type": TYPES.Item,"item unlock":["sugarcane"],"unlock literal":true,"reward": "sugarcane","amt" : 3},
#"mushroom patch":{"title": "Mushroom Patch", "img": "res://art/godchoice/mushroom.png","text":"Grows mushrooms","item unlock":["mushroom"],"unlock literal":true,"type": TYPES.Placement,"reward": "mushroom_patch"},
#"cranberry bush":{"title": "Cranberry Bush", "img": "res://art/items/cranberry.png","text":"Grows Cranberries dumbass","item unlock":["cranberry"],"unlock literal":true,"type": TYPES.Placement,"reward": "cranberry_bush"},
#"barrel":{"title": "Barrel","img": "res://art/godchoice/barrel.png","text":"Used to brew","item unlock":["barrel"],"unlock literal":false,"type": TYPES.Placement,"cost" : 3,"reward": "barrel"},
#"prickly pear cactus":{"title": "Prickly Pear Cactus","img": "res://art/godchoice/prickly_pear_cactus.png","text":"Grows prickly pears","item unlock":["prickly_pear"],"unlock literal":true,"type": TYPES.Placement,"reward": "prickly_pear_cactus"},
#"devil vine":{"title": "Devil Vine","img": "res://art/items/devil_pepper.png","text":"Grows devil peppers","item unlock":["devil_pepper"],"unlock literal":true,"type": TYPES.Placement,"reward": "devil_vine"},
#"mill":{"title": "Mill","img": "res://art/godchoice/mill.png","text":"Used to make flour and sugar","item unlock":["mill"],"unlock literal":false,"type": TYPES.Placement,"reward": "mill"},
#"oven":{"title": "Oven","img": "res://art/godchoice/oven.png","text":"Used to bake","item unlock":["oven"],"unlock literal":false,"type": TYPES.Placement,"reward": "oven"},
#"well":{"title": "Well","img": "res://art/godchoice/well.png","text":"This wishing well works in reverse.","item unlock":[],"unlock literal":false,"type": TYPES.Placement,"reward": "well"},
#"activate fish":{"title": "Let there be fish","img": "res://art/godchoice/fish.png","text":"Fish will appear in water ocasionaly","item unlock":["fish"],"unlock literal":true,"type": TYPES.Activate_Fish,"reward": "fish activation"},
#"burn land":{"title": "Burn Land","img": "res://art/godchoice/burn_land.png","text":"Click the fires to put them out","type": TYPES.Destroy_Land,"item unlock":null,"unlock literal":false,"reward": null,"amt": 3},
#"lose all gold":{"title": "Lose Gold","img": "res://art/items/coin.png","text":"Lose all your gold","type": TYPES.Lose_All_Gold,"item unlock":null,"unlock literal":false,"reward": null,"amt": null},
#"farmland":{"title": "Farmland","img": "res://art/godchoice/farmland.png","text":"Used to grow crops","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "farmland", "cost" : 6, "amt" : 1},
#"sandy_farmland":{"title": "Sandy Farmland","img": "res://art/godchoice/sandy_farmland.png","text":"Used to grow sugarcane","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "sandy_farmland", "cost" : 6, "amt" : 1},
#"sandy_farmland":{"title": "Sandy Farmland","img": "res://art/godchoice/sandy_farmland.png","text":"Used to grow sugarcane","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "sandy_farmland", "cost" : 6, "amt" : 1},
#"+5 seconds":{"title": "God's Grace","img": "res://art/godchoice/time.png","text":"Every round will be 5 seconds longer","type": TYPES.Time_,"item unlock":[],"unlock literal":false, "cost" : 7, "reward": 5,"amt" : 1},
#"gain life":{"title": "Gain Life","img": "res://art/UI/life on.png","text":"Gain 1 life","type": TYPES.Life,"item unlock":null,"unlock literal":false,"reward": null,"cost" : 4,"amt": 1}
#}



# Want to instantiate a main and then put it as the child

var difficulties = {"Baby" : 27, "Easy" : 25, "Normal": 23, "Hard" : 19, "Insane": 16}

func generate_level(level_name, level_dificulty):
	
	print("Level Name: ", level_name)
	
	var round_time = difficulties[level_dificulty]
	var tile_layers = {}
	var punishments = {20:["lose all gold","burn land","-2 seconds"],1000:["burn land"]}
	
	if level_name == "grass":
		var boss = load("res://scenes/boss/devil_boss.tscn")
		var boss_position = Vector2.ZERO

		
		var shop_items = [ChainedReward.new(["gain life", "gain life", "gain life", "gain life"],0),
		ChainedReward.new(["+5 seconds", "+5 seconds", "+5 seconds", "+5 seconds"],1),
		ChainedReward.new(["farmland","farmland","farmland"],2)]
		#var rewards = [ChainedReward.new(["potatoe","potatoe","potatoe"], 0)]
		var rewards = [ChainedReward.new(["potatoe","barrel","mushroom patch","barrel","mushroom patch", "barrel"], 0),
		ChainedReward.new(["wheat","mill","oven","mill","oven"], 1),
		ChainedReward.new(["well","activate fish","mushroom patch"],2)]
		tile_layers["TileLayer"] = load("res://scenes/levels/plains/tile_map_layer.tscn")
		tile_layers["TileLayer2"] = load("res://scenes/levels/plains/tile_map_layer2.tscn")
		tile_layers["DecorLayer"] = load("res://scenes/levels/plains/decor_layer.tscn")
		tile_layers["TerrainLayer"] = load("res://scenes/levels/plains/terrain_layer.tscn")
		tile_layers["EffectLayer"] = load("res://scenes/levels/plains/effect_layer.tscn")
	

		load_level(round_time, shop_items, rewards, punishments, tile_layers, boss, boss_position)
	elif level_name == "sand":
		var boss = load("res://scenes/boss/shark_boss.tscn")
		var boss_position = Vector2(0,59) + Vector2(72,-59)

		
		var shop_items = [ChainedReward.new(["gain life", "gain life", "gain life", "gain life"],0),
		ChainedReward.new(["+5 seconds", "+5 seconds", "+5 seconds", "+5 seconds"],1),
		ChainedReward.new(["sandy_farmland","sandy_farmland","sandy_farmland"],2)]
		var rewards = [ChainedReward.new(["melon", "barrel","prickly pear cactus","devil vine","barrel"], 0),
		ChainedReward.new(["prickly pear cactus","barrel","devil vine","barrel"], 1),
		ChainedReward.new(["well","activate fish","devil vine","prickly pear cactus"],2)]
		tile_layers["TileLayer"] = load("res://scenes/levels/sand/tile_map_layer.tscn")
		tile_layers["TileLayer2"] = load("res://scenes/levels/sand/tile_map_layer2.tscn")
		tile_layers["DecorLayer"] = load("res://scenes/levels/sand/decor_layer.tscn")
		tile_layers["TerrainLayer"] = load("res://scenes/levels/sand/terrain_layer.tscn")
		tile_layers["EffectLayer"] = load("res://scenes/levels/plains/effect_layer.tscn")
	
		load_level(round_time, shop_items, rewards, punishments, tile_layers, boss, boss_position)
	elif level_name == "swamp": #kinda like shrek
		var boss = load("res://scenes/boss/leach_boss.tscn")
		var boss_position = Vector2(-63,-3+19) + Vector2(72,-59)

		
		var shop_items = [ChainedReward.new(["gain life", "gain life", "gain life", "gain life"],0),
		ChainedReward.new(["+5 seconds", "+5 seconds", "+5 seconds", "+5 seconds"],1),
		ChainedReward.new(["swamp_farmland","swamp_farmland","swamp_farmland"],2)]
		var rewards = [ChainedReward.new(["cranberry bush", "barrel","cranberry bush","mushroom patch","barrel"], 0),
		ChainedReward.new(["rice","oven","activate fish","mill","oven","barrel"], 1),
		ChainedReward.new(["well","sugarcane","mushroom patch","barrel", "mill"],2)]
		tile_layers["TileLayer"] = load("res://scenes/levels/swamp/tile_map_layer.tscn")
		tile_layers["TileLayer2"] = load("res://scenes/levels/swamp/tile_map_layer2.tscn")
		tile_layers["DecorLayer"] = load("res://scenes/levels/swamp/decor_layer.tscn")
		tile_layers["TerrainLayer"] = load("res://scenes/levels/swamp/terrain_layer.tscn")
		tile_layers["EffectLayer"] = load("res://scenes/levels/plains/effect_layer.tscn")

		load_level(round_time, shop_items, rewards, punishments, tile_layers, boss, boss_position)
	else:
		assert(false, "No level named : " + level_name)

# Insert all the nity grity detail
func load_level(round_time, shop, reward, punishment, tile_layers, boss, boss_position):
	game_scene = GAME_SCENE.instantiate()
	
	game_scene.set_round_time(round_time)
	game_scene.set_godchoices(shop, reward, punishment)
	game_scene.set_tile_layers(tile_layers)
	game_scene.set_boss(boss, boss_position)
	
	add_child(game_scene)
	

	
	
