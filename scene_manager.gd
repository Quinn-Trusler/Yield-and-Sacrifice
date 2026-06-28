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


# Want to instantiate a main and then put it as the child



func generate_level(level_name, level_dificulty):
	
	print("Level Name: ", level_name)
	
	var round_time = GLOBALCONSTS.DIFFICULTY_TIMES[level_dificulty]
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
		ChainedReward.new(["activate fish","mushroom patch"],2)]
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
		ChainedReward.new(["activate fish","devil vine","prickly pear cactus"],2)]
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
		ChainedReward.new(["sugarcane","mushroom patch","barrel", "mill"],2)]
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
	

	
	
