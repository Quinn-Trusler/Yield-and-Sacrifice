extends CanvasLayer

enum TYPES {Item, Placement, Destroy_Land, Destroy_Item, Destroy_Animal, Time_Decrease}
var REWARD_TEXT = "You Sacraficed enough.\n Chose a reward."
var PUNISH_TEXT = "You did not sacrafice enough!\n Chose a punishment!"
var BURNT_LAND = Vector2(8,2)
var RNG = RandomNumberGenerator.new()
var choices = {"Carrot":{"img": "res://art/items/carrot.png","text":"default","type": TYPES.Item,"reward": "carrot","amt" : 1},
"Farmland":{"img": "res://art/godchoice/farmland.png","text":"default","type": TYPES.Placement,"reward": "farmland"},
"Burn Land":{"img": "res://art/godchoice/burn_land.png","text":"default","type": TYPES.Destroy_Land,"reward": ["farmland"],"amt": 3}
}
var FIRE_SCENE_ID = 2
var GodChoice_Scene = load("res://scenes/god_choice.tscn")

var choice_instances = []

func chose_punishments():
	#punishments off what the player curently  has
	return ["Burn Land"]
	
func chose_rewards():
	#rewards off of what the player curently has
	return ["Carrot", "Farmland"]
func load_godchoices(godchoice_list):
	get_tree().paused = true
	visible = true
	for choice in godchoice_list:
		var temp = GodChoice_Scene.instantiate()
		temp.initialize(choice,choices[choice])
		choice_instances.append(temp)
		$HBoxContainer.add_child(temp)
		
		
func display_punishments():
	$TitleText.text = PUNISH_TEXT
	load_godchoices(chose_punishments())
	
func display_rewards():
	$TitleText.text = REWARD_TEXT
	load_godchoices(chose_rewards())

func delete_choice_instances():
	for c in choice_instances:
		c.queue_free()
	choice_instances = []
func get_tile_name(pos):
	var data = get_parent().get_node("TileMapLayer").get_cell_tile_data(pos)
	if data != null:
		return data.get_custom_data_by_layer_id(0)
func god_choice_chosen(choice_name):
	visible = false
	delete_choice_instances()
	
	var choice = choices[choice_name]
	
	if choice["type"] == TYPES.Item:
		get_tree().paused = false
		get_parent().create_draggable_item(choice["reward"],Vector2.ZERO)
		
		
	elif choice["type"] == TYPES.Destroy_Land:
		get_tree().paused = false
		var map_size = get_parent().MAPSIZE
		var count = 0
		var tries = 0
		var TRY_MAX = 1000
		while count < choice["amt"]:
			var pos = Vector2(RNG.randi_range(map_size[0],map_size[2]),RNG.randi_range(map_size[1],map_size[3]))
			var tile_name = get_tile_name(pos)
			tries +=1
			if tries> TRY_MAX:
				count +=1
			if tile_name in choice["reward"]:
				#get_parent().get_node("TileMapLayer2").set_cell(pos,-1)#delete cell
				get_parent().get_node("TileMapLayer2").set_cell(pos,2,Vector2.ZERO,FIRE_SCENE_ID)
				#get_parent().get_node("TileMapLayer").set_cell(pos,0,BURNT_LAND,0)#burnt land cell
				count+=1
					
				
				
				
			
	
