extends CanvasLayer

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_, Activate_Fish}
var REWARD_TEXT = "I am Satisfied.\n Chose a reward."
var PUNISH_TEXT = "I am Unsatisfied!\n Chose a punishment!"
var BURNT_LAND = Vector2(8,2)
var RNG = RandomNumberGenerator.new()
var choices = {"carrot":{"title": "Carrot","img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"item unlock":["carrot"],"unlock literal":true,"reward": "carrot","amt" : 2},
"potatoe":{"title": "Potatoe","img": "res://art/items/potatoe.png","text":"default","type": TYPES.Item,"item unlock":["potatoe"],"unlock literal":true,"reward": "potatoe","amt" : 2},
"wheat":{"title": "Wheat","img": "res://art/items/wheat.png","text":"default","type": TYPES.Item,"item unlock":["wheat"],"unlock literal":true,"reward": "wheat","amt" : 2},
"+5 seconds":{"title": "God's Grace","img": "res://art/godchoice/time.png","text":"Every round will be 5 seconds longer","type": TYPES.Time_,"item unlock":[],"unlock literal":false, "reward": 5,"amt" : 1},
"-5 seconds":{"title": "God's Disgrace","img": "res://art/godchoice/time.png","text":"Every round will be 5 seconds shorter","type": TYPES.Time_,"item unlock":[],"unlock literal":false,"reward": -5,"amt" : 1},
"sugarcane":{"title": "Sugarcane","img": "res://art/items/sugarcane.png","text":"default","type": TYPES.Item,"item unlock":["sugarcane"],"unlock literal":true,"reward": "sugarcane","amt" : 3},
"farmland":{"title": "Farmland","img": "res://art/godchoice/farmland.png","text":"default","type": TYPES.Placement,"item unlock":null,"unlock literal":false,"reward": "farmland"},
"mushroom patch":{"title": "Mushroom Patch", "img": "res://art/godchoice/mushroom.png","text":"Grows mushrooms","item unlock":["mushroom"],"unlock literal":true,"type": TYPES.Placement,"reward": "mushroom_patch"},
"barrel":{"title": "Barrel","img": "res://art/godchoice/barrel.png","text":"Used to brew","item unlock":["barrel"],"unlock literal":false,"type": TYPES.Placement,"reward": "barrel"},
"mill":{"title": "Mill","img": "res://art/godchoice/mill.png","text":"Used to make flour and sugar","item unlock":["mill"],"unlock literal":false,"type": TYPES.Placement,"reward": "mill"},
"oven":{"title": "Oven","img": "res://art/godchoice/oven.png","text":"Used to bake","item unlock":["oven"],"unlock literal":false,"type": TYPES.Placement,"reward": "oven"},
"activate fish":{"title": "Let there be fish","img": "res://art/godchoice/fish.png","text":"Fish will appear in water ocasionaly","item unlock":["fish"],"unlock literal":true,"type": TYPES.Activate_Fish,"reward": "fish activation"},
"burn land":{"title": "Burn Land","img": "res://art/godchoice/burn_land.png","text":"Sets up to 3 grass tiles on fire","type": TYPES.Destroy_Land,"item unlock":null,"unlock literal":false,"reward": [null],"amt": 3}
}
#less than 1, less than 2, less than 3
#var rewards = {3:["oven","mill","wheat"],20:["mushroom patch", "barrel","+5 seconds"]}
var rewards = {4:["potatoe","activate fish","wheat", "sugarcane", "+5 seconds"],7:["mushroom patch", "barrel","+5 seconds"],10:["mill","barrel"],12:["oven","mill"],20:["sugarcane","mushroom patch","mushroom patch","mill"]}
var punishments = {3:["burn land","-5 seconds"],20:["burn land"]}
var chained_rewards = [ChainedReward.new(["potatoe","barrel"], 0),
ChainedReward.new(["activate fish","wheat","mill"], 1),
ChainedReward.new(["sugarcane","sugarcane","sugarcane"], 1),
ChainedReward.new(["carrot","carrot","carrot"], 1)]

#$TileMapLayer2.place_building(Vector2(-3,3),"barrel")
	#$TileMapLayer2.place_building(Vector2(-1,3),"mushroom_patch")
	#$TileMapLayer2.place_building(Vector2(0,3),"mushroom_patch")
var placemnet_locations = {"mushroom patch":[[-1,3],[0,3],[1,3]], "barrel": [[-3,3],[-3,2]], "mill": [[-2,3],[-2,2]], "oven": [[-2,2]]}

var FIRE_SCENE_ID = 2
var GodChoice_Scene = load("res://scenes/god_choice.tscn")

# unlock_map = [[[require1,require2][reward1,reward2]]] meet all requirments for reward
var unlock_map = [[["barrel", "sugarcane"],["rum"]],
				[["barrel", "potatoe"],["voldka"]],
				[["mill", "sugarcane"],["sugar"]],
				[["mill", "wheat"],["flour"]],
				[["mill", "oven", "wheat"],["bread"]]]

var choice_instances = []
@onready var ItemManager = get_node("/root/Main/ItemManager")
@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var Lives = get_node("/root/Main/Lives")
@onready var BuildingManager = get_node("/root/Main/BuildingManager")
@onready var SacraficeManager = get_node("/root/Main/SacraficeManager") 

var round_num = 0
var rewards_collected = 0
var punishments_collected = 0
	

func chose_punishments():
	#punishments off what the player curently  has
	for key in punishments:
		if punishments_collected <= key:
			return punishments[key]
	
func chose_rewards():
	for key in rewards:
		if rewards_collected <= key:
			return rewards[key]
#func chose_chained_rewards():
	#var reward_list = []
	#var chain_numbers = []
	#var chain_number = 0
	#for chain in chained_rewards:
		#chain_numbers.append(chain_number)
		#reward_list.append(chain.get_reward())
		#chain_number += 1
	#return [chain_number, reward_list]
	#rewards off of what the player curently has
	#return ["Carrot", "Farmland", "Potatoe"]
#select 3 random choices
func load_godchoices(godchoice_list):
	get_tree().paused = true
	visible = true
	print(godchoice_list)
	var copy = godchoice_list.duplicate()
	copy.shuffle()
	var new_godchoice_list = copy.slice(0, 3)
	for choice in new_godchoice_list:
		var temp = GodChoice_Scene.instantiate()
		temp.initialize(choice,choices[choice])
		choice_instances.append(temp)
		$HBoxContainer.add_child(temp)
func load_chained_godchoices(godchoice_list):
	get_tree().paused = true
	visible = true
	var copy = godchoice_list.duplicate()
	copy.shuffle()
	var new_godchoice_list = copy.slice(0, 3)
	for choice in new_godchoice_list:
		var temp = GodChoice_Scene.instantiate()
		temp.initialize(choice.get_reward(),choices[choice.get_reward()],choice.get_id())
		choice_instances.append(temp)
		$HBoxContainer.add_child(temp)
		
		
func display_punishments():
	round_num +=1
	punishments_collected += 1
	Lives.lose_life()
	$TitleText.text = PUNISH_TEXT
	load_godchoices(chose_punishments())
	
func display_rewards():
	round_num +=1
	rewards_collected += 1
	Lives.set_max_lives()
	$TitleText.text = REWARD_TEXT
	load_chained_godchoices(chained_rewards)

func delete_choice_instances():
	for c in choice_instances:
		c.queue_free()
	choice_instances = []
func get_tile_name_from_coordinates(pos):
	var data = TileLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
		
func strike_reward_from_rewards(reward_name):
	for key in rewards:
		if rewards_collected <= key:
			rewards[key].erase(reward_name)
			break#As to not wipe out the rest of rewards
func strike_id_from_chain_rewards(id : int):
	if id != -1:
		chained_rewards[id].reward_chosen()
	
#Unlock literal means to take the items unlocked as themselves instead of just a key
# unlock_map = [[[require1,require2][reward1,reward2]]] meet all requirments for reward
func unlock_sacrafices(items_unlocked, unlock_literal):
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
							print(unlock + " due to unlock map`")

		for unlock in new_unlocks:
			SacraficeManager.add_allowed_sacrafice(unlock)
	
func god_choice_chosen(choice_name, id : int):
	visible = false
	delete_choice_instances()
	$ClickButton.play()
	strike_reward_from_rewards(choice_name)
	strike_id_from_chain_rewards(id)
	
	var choice = choices[choice_name]
	
	
	unlock_sacrafices(choice["item unlock"], choice["unlock literal"])
	
	get_tree().paused = false
		
	#Manage variety of choice types
	if choice["type"] == TYPES.Item:
		BuildingManager.create_gift(choice["reward"], choice["amt"])
		#ItemManager.create_draggable_item(choice["reward"],Vector2.ZERO)
	
	elif choice["type"] == TYPES.Time_:
		SacraficeManager.modify_round_time(choice["reward"])
		
	elif choice["type"] == TYPES.Destroy_Land:#burns land
		var map_size = GLOBALCONSTS.FIRE_SPAWN_ZONE
		var count = 0
		var tries = 0
		var TRY_MAX = 1000
		while count < choice["amt"]:
			var pos = Vector2(RNG.randi_range(map_size[0],map_size[2]),RNG.randi_range(map_size[1],map_size[3]))
			var tile_name = get_tile_name_from_coordinates(pos)
			tries +=1
			if tries> TRY_MAX:
				count +=1
			print(tile_name)
			if choice["reward"][0] == null:
				TileLayer2.set_cell_scene(pos,-1)#delete cell
				TileLayer2.set_cell_scene(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
				count+=1
			elif tile_name in choice["reward"]:
				TileLayer2.set_cell_scene(pos,-1)#delete cell
				TileLayer2.set_cell_scene(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
				#get_parent().get_node("TileMapLayer").set_cell_scene(pos,0,BURNT_LAND,0)#burnt land cell
				count+=1
				
	elif choice["type"] == TYPES.Placement:
		var locations = placemnet_locations[choice_name]
		var pos = locations[RNG.randi_range(0, len(locations)-1)]
		TileLayer2.place_building(Vector2i(pos[0], pos[1]), choice["reward"])
		placemnet_locations[choice_name].erase(pos) #Erase so position will not be used again in future
		
	elif choice["type"] == TYPES.Activate_Fish:
		BuildingManager.fish_spawning_active = true
		
					
	SacraficeManager.update_requirements()
				
				
			
	
