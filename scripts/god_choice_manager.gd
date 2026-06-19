extends CanvasLayer

enum TYPES {Item, Placement, Place_Farmland, Destroy_Land, Destroy_Item, Destroy_Animal, Time_, Activate_Fish, Life, Lose_All_Gold}
enum CHOICE_TYPES {Reward, Punishment, Shop}
var REWARD_TEXT = "I am Satisfied.\n Chose a reward."
var PUNISH_TEXT = "I am Unsatisfied!\n Chose a punishment!"
var SHOP_TEXT = "To buy or not to buy?\nThat is the question"
var BURNT_LAND = Vector2(8,2)
var RNG = RandomNumberGenerator.new()
var choices = {"carrot":{"title": "Carrot","img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"item unlock":["carrot"],"unlock literal":true,"reward": "carrot","amt" : 2},
"potatoe":{"title": "Potatoe","img": "res://art/items/potatoe.png","text":"default","type": TYPES.Item,"item unlock":["potatoe"],"unlock literal":true,"reward": "potatoe","amt" : 2},
"rice":{"title": "Rice","img": "res://art/items/rice.png","text":"Gain 2 rice. Plant on water edge.","type": TYPES.Item,"item unlock":["rice"],"unlock literal":true,"reward": "rice","amt" : 2},
"melon":{"title": "Melon","img": "res://art/items/melon.png","text":"default","type": TYPES.Item,"item unlock":["melon"],"unlock literal":true,"reward": "melon","amt" : 2},
"wheat":{"title": "Wheat","img": "res://art/items/wheat.png","text":"default","type": TYPES.Item,"item unlock":["wheat"],"unlock literal":true,"reward": "wheat","amt" : 2},
"-2 seconds":{"title": "God's Disgrace","img": "res://art/godchoice/time.png","text":"Every round will be 2 seconds shorter","type": TYPES.Time_,"item unlock":[],"unlock literal":false,"reward": -2,"amt" : 1},
"sugarcane":{"title": "Sugarcane","img": "res://art/items/sugarcane.png","text":"default","type": TYPES.Item,"item unlock":["sugarcane"],"unlock literal":true,"reward": "sugarcane","amt" : 3},
"mushroom patch":{"title": "Mushroom Patch", "img": "res://art/godchoice/mushroom.png","text":"Grows mushrooms","item unlock":["mushroom"],"unlock literal":true,"type": TYPES.Placement,"reward": "mushroom_patch"},
"cranberry bush":{"title": "Cranberry Bush", "img": "res://art/items/cranberry.png","text":"Grows Cranberries","item unlock":["cranberry"],"unlock literal":true,"type": TYPES.Placement,"reward": "cranberry_bush"},
"barrel":{"title": "Barrel","img": "res://art/godchoice/barrel.png","text":"Used to brew","item unlock":["barrel"],"unlock literal":false,"type": TYPES.Placement,"cost" : 3,"reward": "barrel"},
"prickly pear cactus":{"title": "Prickly Pear Cactus","img": "res://art/godchoice/prickly_pear_cactus.png","text":"Grows prickly pears","item unlock":["prickly_pear"],"unlock literal":true,"type": TYPES.Placement,"reward": "prickly_pear_cactus"},
"devil vine":{"title": "Devil Vine","img": "res://art/items/devil_pepper.png","text":"Grows devil peppers","item unlock":["devil_pepper"],"unlock literal":true,"type": TYPES.Placement,"reward": "devil_vine"},
"mill":{"title": "Mill","img": "res://art/godchoice/mill.png","text":"Used to make flour and sugar","item unlock":["mill"],"unlock literal":false,"type": TYPES.Placement,"reward": "mill"},
"oven":{"title": "Oven","img": "res://art/godchoice/oven.png","text":"Used to bake","item unlock":["oven"],"unlock literal":false,"type": TYPES.Placement,"reward": "oven"},
"well":{"title": "Well","img": "res://art/godchoice/well.png","text":"This wishing well works in reverse.","item unlock":[],"unlock literal":false,"type": TYPES.Placement,"reward": "well"},
"activate fish":{"title": "Let there be fish","img": "res://art/godchoice/fish.png","text":"Fish will appear in water occasionally","item unlock":["fish"],"unlock literal":true,"type": TYPES.Activate_Fish,"reward": "fish activation"},
"burn land":{"title": "Burn Land","img": "res://art/godchoice/burn_land.png","text":"Click the fires to put them out","type": TYPES.Destroy_Land,"item unlock":null,"unlock literal":false,"reward": null,"amt": 3},
"lose all gold":{"title": "Lose Gold","img": "res://art/items/coin.png","text":"Lose all your gold","type": TYPES.Lose_All_Gold,"item unlock":null,"unlock literal":false,"reward": null,"amt": null},
"farmland":{"title": "Farmland","img": "res://art/godchoice/farmland.png","text":"Used to grow crops","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "farmland", "cost" : 6, "amt" : 1},
"sandy_farmland":{"title": "Sandy Farmland","img": "res://art/godchoice/sandy_farmland.png","text":"Used to grow crops","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "sandy_farmland", "cost" : 6, "amt" : 1},
"swamp_farmland":{"title": "Swamp Farmland","img": "res://art/godchoice/swamp_farmland.png","text":"Used to grow crops","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "swamp_farmland", "cost" : 6, "amt" : 1},
"+5 seconds":{"title": "God's Grace","img": "res://art/godchoice/time.png","text":"Every round will be 5 seconds longer","type": TYPES.Time_,"item unlock":[],"unlock literal":false, "cost" : 7, "reward": 5,"amt" : 1},
"gain life":{"title": "Gain Life","img": "res://art/UI/life on.png","text":"Gain 1 life","type": TYPES.Life,"item unlock":null,"unlock literal":false,"reward": null,"cost" : 4,"amt": 1}
}
var rewards = {4:["potatoe","activate fish","wheat", "sugarcane", "+5 seconds"],7:["mushroom patch", "barrel","+5 seconds"],10:["mill","barrel"],12:["oven","mill"],20:["sugarcane","mushroom patch","mushroom patch","mill"]}
var shop_items = {3: ["+5 seconds", "gain life", "farmland"],20:["+5 seconds"]}

var punishments = null#{3:["lose all gold","burn land","-2 seconds"],20:["burn land"]}
var chained_shop_items = null#[ChainedReward.new(["gain life", "gain life", "gain life", "gain life"],0),ChainedReward.new(["sandy_farmland","+5 seconds", "+5 seconds", "+5 seconds", "+5 seconds"],1),ChainedReward.new(["farmland","farmland","farmland"],2)]
var chained_rewards = null#[ChainedReward.new(["cranberry bush","prickly pear cactus","potatoe","barrel","mushroom patch", "barrel","barrel"], 0),
#ChainedReward.new(["mill","melon","devil vine","activate fish","wheat","mill","oven","mill","oven"], 1),
#ChainedReward.new(["rice","sugarcane", "devil vine","prickly pear cactus"],2)]

var FIRE_SCENE_ID = 2
var GodChoice_Scene = load("res://scenes/god_choice.tscn")
var ShopChoice_Scene = load("res://scenes/shop_choice.tscn")

# unlock_map = [[[require1,require2][reward1,reward2]]] meet all requirments for reward
var unlock_map = [[["barrel", "sugarcane"],["rum"]],
				[["barrel", "potatoe"],["vodka"]],
				[["barrel", "rice"],["sake"]],
				[["barrel", "prickly_pear"],["prickly_pear_jam"]],
				[["barrel", "cranberry"],["cranberry_jam"]],
				[["barrel", "melon"],["melon_jam"]],
				[["mill", "sugarcane"],["sugar"]],
				[["mill", "wheat"],["flour"]],
				[["mill", "oven", "wheat"],["bread"]],
				[["oven","rice"],["cooked_rice"]]]

var choice_instances = []
@export var ItemManager : Node2D
#@export var TileLayer : TileMapLayer
#@export var TileLayer2 : TileMapLayer
#@export var EffectLayer = TileMapLayer
@export var TMM : Node2D
@export var Lives = Node2D
@export var BuildingManager : Node2D
@export var SacrificeManager : Node2D
@export var GOLD: Node2D
@export var BuildingPlacementManager : Node2D

var round_num = 0
var rewards_collected = 0
var punishments_collected = 0
var shops_seen = 0
var shop_items_bought = 0
var num_gold = 0
var choice_type : CHOICE_TYPES
var completion_gold = GLOBALCONSTS.ROUND_COMPLETION_GOLD
	
func _ready():
	if Cheats.GOLD_OVERRIDE:
		num_gold = Cheats.GOLD_OVERRIDE
	GOLD.update_gold_num(num_gold)
	
	BuildingPlacementManager.build_finished.connect(build_finished)

func set_godchoices(shop_items_, rewards_, punishments_):
	chained_shop_items = shop_items_
	chained_rewards = rewards_
	punishments = punishments_

func get_gold():
	return num_gold
	
func increase_gold(amt):
	num_gold += amt
	GOLD.update_gold_num(num_gold)

# Load Display ----------------------------------------------------------------------

func chose_punishments():
	for key in punishments:
		if punishments_collected <= key:
			return punishments[key]
func chose_shop_items():
	for key in shop_items:
		if shops_seen <= key:
			return shop_items[key]
	
func chose_rewards():
	for key in rewards:
		if rewards_collected <= key:
			return rewards[key]

func add_choice_to_hbox(choice):
	choice_instances.append(choice)
	$Node2D/HBoxContainer.add_child(choice)

func godchoice_restricted(choice_name, choice_type : CHOICE_TYPES):
	if choice_type == CHOICE_TYPES.Shop:
		if not (choices[choice_name]["type"] == TYPES.Life and Lives.is_at_max()):
			return false
		return true
	if choice_type == CHOICE_TYPES.Punishment:
		if not (choices[choice_name]["type"] == TYPES.Lose_All_Gold and num_gold <= 4):
			return false
		return true
	return false

func load_godchoices(godchoice_list, chained: bool, choice_type : CHOICE_TYPES):
	get_tree().paused = true
	#visible = true
	var copy = godchoice_list.duplicate()
	copy.shuffle()
	var new_godchoice_list = copy.slice(0, 3)
	var makeshift_game_end = true
	
	var choice_names_already_added = []
	
	for choice in new_godchoice_list:
		var choice_name
		if chained:
			choice_name = choice.get_reward()
		else:
			choice_name = choice
		
		if choice_name and not choice_name in choice_names_already_added: # Not last item and not a duplicate
			choice_names_already_added.append(choice_name)
			
			if not godchoice_restricted(choice_name, choice_type):
				var temp
				temp = GodChoice_Scene.instantiate()
				if chained:
					if choice_type == CHOICE_TYPES.Shop:
						temp = ShopChoice_Scene.instantiate()
						temp.initialize(choice_name,choices[choice_name],num_gold, choice.get_id())
					else:
						temp.initialize(choice_name,choices[choice_name],choice.get_id())
				else:
					temp.initialize(choice_name,choices[choice_name])
				add_choice_to_hbox(temp)
				makeshift_game_end = false
			
	if makeshift_game_end:
		get_parent().get_parent().win_game()

func open_godchoice():
	$AnimationPlayer.play("Open")
	visible = true
	
	# Blocker so user can't interact with buttons (Interacting with buttons are a big no no)
	$Node2D/Blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	await $AnimationPlayer.animation_finished
	$Node2D/Blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
# Run animation but don't set visible false
func semi_close_godchoice():
	$AnimationPlayer.play("Close")
	await $AnimationPlayer.animation_finished
	
func close_godchoice():
	$AnimationPlayer.play("Close")
	await $AnimationPlayer.animation_finished
	visible = false

func display_punishments():
	round_num +=1
	punishments_collected += 1
	Lives.lose_life()
	$Node2D/TitleText.text = PUNISH_TEXT
	load_godchoices(chose_punishments(), false, CHOICE_TYPES.Punishment)
	choice_type = CHOICE_TYPES.Punishment
	$Node2D/GoldCount.update_gold_num(num_gold)
	
	open_godchoice()
	

	
func display_rewards():
	increase_gold(completion_gold)
	round_num +=1
	rewards_collected += 1
	Lives.set_max_lives()
	$Node2D/TitleText.text = REWARD_TEXT
	load_godchoices(chained_rewards, true, CHOICE_TYPES.Reward)
	choice_type = CHOICE_TYPES.Reward
	$Node2D/GoldCount.update_gold_num(num_gold)
	open_godchoice()

func display_shop():
	$Node2D/TitleText.text = SHOP_TEXT
	$Node2D/SkipButton.visible = true
	$Node2D/GoldCount.visible = true
	$Node2D/GoldCount.update_gold_num(num_gold)
	#load_shopchoices(chose_shop_items())
	load_godchoices(chained_shop_items, true, CHOICE_TYPES.Shop)
	choice_type = CHOICE_TYPES.Shop
	open_godchoice()


# Choice Chosen /  Close display ----------------------------------------------------------------------

func delete_choice_instances():
	for c in choice_instances:
		c.queue_free()
	choice_instances = []
	
func get_tile_name(pos):
	var data = TMM.TileLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
		
func strike_reward_from_rewards(reward_name):
	for key in rewards:
		if rewards_collected <= key:
			rewards[key].erase(reward_name)
			break# As to not wipe out the rest of rewards
			
func strike_shop_items_from_shop(item_name):
	for key in shop_items:
		if shops_seen <= key:
			shop_items[key].erase(item_name)
			break# As to not wipe out the rest of rewards
	
func strike_id_from_chain(chain_array : Array,id : int):
	if id != -1:
		chain_array[id].reward_chosen()
	
#Unlock literal means to take the items unlocked as themselves instead of just a key
# unlock_map = [[[require1,require2][reward1,reward2]]] meet all requirments for reward
func unlock_sacrifices(items_unlocked, unlock_literal):
	if items_unlocked:
		var new_unlocks = []
		
		if unlock_literal:
			for unlock in items_unlocked:
				new_unlocks.append(unlock)
				
		#get unlocks from map
		for item_unlocked in items_unlocked:
			for element in unlock_map:
				if item_unlocked in element[0]:
					element[0].erase(item_unlocked)
					if len(element[0]) == 0: #No requirments left
						for unlock in element[1]:
							new_unlocks.append(unlock)

		for unlock in new_unlocks:
			SacrificeManager.add_allowed_sacrifice(unlock)
	
# Runs after a punishment or reward is chosen
func god_choice_chosen(choice_name, id : int, cost : int = 0) -> void:
	
	delete_choice_instances()
	$Node2D/ClickButton.play()
	# Warning: If choice_name exists in both, then they will both be removed.
	if choice_type == CHOICE_TYPES.Reward:
		strike_reward_from_rewards(choice_name)
		strike_id_from_chain(chained_rewards, id)
	elif choice_type == CHOICE_TYPES.Shop:
		strike_shop_items_from_shop(choice_name)
		strike_id_from_chain(chained_shop_items, id)
		$Node2D/SkipButton.visible = false
	
	increase_gold(-cost)
	
	
	var choice = choices[choice_name]
	
	
	unlock_sacrifices(choice["item unlock"], choice["unlock literal"])
		
	#Manage variety of choice types
	if choice["type"] == TYPES.Item:
		BuildingManager.create_gift(choice["reward"], choice["amt"])
	
	elif choice["type"] == TYPES.Time_:
		SacrificeManager.modify_round_time(choice["reward"])
		
	elif choice["type"] == TYPES.Destroy_Land:# burns land
		destroy_land(choice)
				
	elif choice["type"] == TYPES.Placement:
		place_building(choice_name)
		
	elif choice["type"] == TYPES.Activate_Fish:
		BuildingManager.fish_spawning_active = true
	elif choice["type"] == TYPES.Lose_All_Gold:
		increase_gold(-num_gold)
	elif choice["type"] == TYPES.Life:
		if choice["amt"] == 1: 
			Lives.gain_life()
		elif choice["amt"] == -1:
			Lives.lose_life()
		else:
			print("ERROR: Only implemented 1 life gain/loss")
		
					
	
	if choice["type"] == TYPES.Placement:
		SacrificeManager.update_requirements()
		await close_godchoice()
		get_tree().paused = false
	else:
		if choice_type == CHOICE_TYPES.Reward or choice_type == CHOICE_TYPES.Punishment:
			await semi_close_godchoice()
			await display_shop()
		elif choice_type == CHOICE_TYPES.Shop: # Finished the shop
			SacrificeManager.update_requirements()
			await close_godchoice()
			get_tree().paused = false

func place_building(choice_name : String):
	BuildingPlacementManager.toggle_on(choices[choice_name]["reward"])

func build_finished() -> void:
	if choice_type == CHOICE_TYPES.Reward or choice_type == CHOICE_TYPES.Punishment:
		display_shop()
	else:
		get_tree().paused = false

# Used by god choice chosen
func destroy_land(choice : Dictionary) -> void:
	var map_size = GLOBALCONSTS.FIRE_SPAWN_ZONE
	var count = 0
	var tries = 0
	var TRY_MAX = 1000
	while count < choice["amt"]:
		var pos = Vector2(RNG.randi_range(map_size[0],map_size[2]),RNG.randi_range(map_size[1],map_size[3]))
		tries +=1
		if tries>= TRY_MAX:
			count +=1
			print("Tried(and failed) to place fire " + str(tries) + " times")
		if choice["reward"] == null:
			if BuildingManager.is_valid_fire_placement(pos):
				TMM.EffectLayer.set_cell_scene(pos,-1)#delete cell
				TMM.EffectLayer.set_cell_scene(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
				count+=1
		#elif tile_name in choice["reward"]:
			#EffectLayer.set_cell_scene(pos,-1)#delete cell
			#EffectLayer.set_cell_scene(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
			##get_parent().get_node("TileMapLayer").set_cell_scene(pos,0,BURNT_LAND,0)#burnt land cell
			#count+=1
				
				
# Skip shop screen
func _on_skip_button_pressed() -> void:
	await close_godchoice()
	
	$Node2D/SkipButton.visible = false
	$Node2D/GoldCount.visible = false
	delete_choice_instances()
	$Node2D/ClickButton.play()
	get_tree().paused = false
	SacrificeManager.update_requirements()
	
