extends Node

var GAME_SCENE = preload("res://scenes/main.tscn")
var game_scene = null # Active instance of GAME_SCENE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_level("Plains", "easy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Want to instantiate a main and then put it as the child


func generate_level(level_name, level_dificulty):
	var boss = load("res://scenes/boss/devil_boss.tscn")
	var boss_position = Vector2.ZERO

	var punishments = {3:["lose all gold","burn land","-2 seconds"],20:["burn land"]}
	var shop_items = [ChainedReward.new(["gain life", "gain life", "gain life", "gain life"],0),ChainedReward.new(["sandy_farmland","+5 seconds", "+5 seconds", "+5 seconds", "+5 seconds"],1),ChainedReward.new(["farmland","farmland","farmland"],2)]
	var rewards = [ChainedReward.new(["cranberry bush","prickly pear cactus","potatoe","barrel","mushroom patch", "barrel","barrel"], 0),
	ChainedReward.new(["mill","melon","devil vine","activate fish","wheat","mill","oven","mill","oven"], 1),
	ChainedReward.new(["rice","sugarcane", "devil vine","prickly pear cactus"],2)]
	var tile_layers = {}
	tile_layers["TileLayer"] = load("res://scenes/levels/plains/tile_map_layer.tscn")
	tile_layers["TileLayer2"] = load("res://scenes/levels/plains/tile_map_layer2.tscn")
	tile_layers["DecorLayer"] = load("res://scenes/levels/plains/decor_layer.tscn")
	tile_layers["TerrainLayer"] = load("res://scenes/levels/plains/terrain_layer.tscn")
	tile_layers["EffectLayer"] = load("res://scenes/levels/plains/effect_layer.tscn")
	

	load_level(23, shop_items, rewards, punishments, tile_layers, boss, boss_position)

# Insert all the nity grity detail
func load_level(round_time, shop, reward, punishment, tile_layers, boss, boss_position):
	game_scene = GAME_SCENE.instantiate()
	
	game_scene.set_round_time(round_time)
	game_scene.set_godchoices(shop, reward, punishment)
	game_scene.set_tile_layers(tile_layers)
	game_scene.set_boss(boss, boss_position)
	print("Level has been loaded")
	
	add_child(game_scene)
	
	
	
