extends CanvasLayer

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_, Activate_Fish}
var REWARD_TEXT = "I am Satisfied.\n Chose a reward."
var PUNISH_TEXT = "I am Unsatisfied!\n Chose a punishment!"
var BURNT_LAND = Vector2(8,2)
var RNG = RandomNumberGenerator.new()
var choices = {"Carrot":{"img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"item unlock":"carrot","reward": "carrot","amt" : 1},
"Potatoe":{"img": "res://art/items/potatoe.png","text":"default","type": TYPES.Item,"item unlock":"potatoe","reward": "potatoe","amt" : 1},
"Farmland":{"img": "res://art/godchoice/farmland.png","text":"default","type": TYPES.Placement,"item unlock":null,"reward": "farmland"},
"Mushroom Patch":{"img": "res://art/godchoice/mushroom.png","text":"default","item unlock":"mushroom","type": TYPES.Placement,"reward": "mushroom_patch"},
"Burn Land":{"img": "res://art/godchoice/burn_land.png","text":"Set 0-3 Farmland on fire","type": TYPES.Destroy_Land,"item unlock":null,"reward": ["dry_farmland"],"amt": 3}
}
#less than 1, less than 2, less than 3
var rewards = {3:["Potatoe","Mushroom Patch"],5:["Carrot","Farmland"]}
#$TileMapLayer2.place_building(Vector2(-3,3),"barrel")
	#$TileMapLayer2.place_building(Vector2(-1,3),"mushroom_patch")
	#$TileMapLayer2.place_building(Vector2(0,3),"mushroom_patch")
var placemnet_locations = {"Mushroom Patch":[[-1,3],[0,3]], "Barrel": [[-3,3]]}

var FIRE_SCENE_ID = 2
var GodChoice_Scene = load("res://scenes/god_choice.tscn")



var choice_instances = []
@onready var ItemManager = get_node("/root/Main/ItemManager")
@onready var TileLayer = get_node("/root/Main/TileMapLayer")
@onready var TileLayer2 = get_node("/root/Main/TileMapLayer2")
@onready var Lives = get_node("/root/Main/Lives")
@onready var BuildingManager = get_node("/root/Main/BuildingManager")
@onready var SacraficeManager = get_node("/root/Main/SacraficeManager") 

var round_num = 0
	

func chose_punishments():
	#punishments off what the player curently  has
	return ["Burn Land"]
	
func chose_rewards():
	for key in rewards:
		if round_num <= key:
			return rewards[key]
	#rewards off of what the player curently has
	#return ["Carrot", "Farmland", "Potatoe"]
func load_godchoices(godchoice_list):
	get_tree().paused = true
	visible = true
	for choice in godchoice_list:
		var temp = GodChoice_Scene.instantiate()
		temp.initialize(choice,choices[choice])
		choice_instances.append(temp)
		$HBoxContainer.add_child(temp)
		
		
func display_punishments():
	round_num +=1
	Lives.lose_life()
	$TitleText.text = PUNISH_TEXT
	load_godchoices(chose_punishments())
	
func display_rewards():
	round_num +=1
	Lives.set_max_lives()
	$TitleText.text = REWARD_TEXT
	load_godchoices(chose_rewards())

func delete_choice_instances():
	for c in choice_instances:
		c.queue_free()
	choice_instances = []
func get_tile_name_from_coordinates(pos):
	var data = TileLayer.get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
func god_choice_chosen(choice_name):
	visible = false
	delete_choice_instances()
	
	var choice = choices[choice_name]
	
	if choice["item unlock"]:
		SacraficeManager.add_allowed_sacrafice(choice["item unlock"])
	
	get_tree().paused = false
		
	#Manage variety of choice types
	if choice["type"] == TYPES.Item:
		ItemManager.create_draggable_item(choice["reward"],Vector2.ZERO)
		
		
	elif choice["type"] == TYPES.Destroy_Land:#burns land
		var map_size = GLOBALCONSTS.MAPSIZE
		var count = 0
		var tries = 0
		var TRY_MAX = 1000
		while count < choice["amt"]:
			var pos = Vector2(RNG.randi_range(map_size[0],map_size[2]),RNG.randi_range(map_size[1],map_size[3]))
			var tile_name = get_tile_name_from_coordinates(pos)
			tries +=1
			if tries> TRY_MAX:
				count +=1
			if tile_name in choice["reward"]:
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
				
				
			
	
