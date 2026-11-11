extends Node2D

@export var TMM :Node2D

var RNG = RandomNumberGenerator.new()

@export var DeathScreen :CanvasLayer
@export var TooltipManager : Node2D
@export var ItemManager : Node2D
@export var BuildingManager : Node2D
@export var SacrificeManager : Node2D
@export var GodChoiceManager : CanvasLayer


func game_over():
	get_parent().game_over()

func _ready():
	connect_signals()
	#create building
	#TMM.TileLayer2.place_building(Vector2(-2,4),"mill")
	#TMM.TileLayer2.place_building(Vector2(-3,4),"barrel")
	TMM.TileLayer2.place_building(Vector2(-4,4),"barrel")
	pass
	
func connect_signals():
	ItemManager.add_tooltip_hover.connect(TooltipManager.add_hover)
	ItemManager.remove_tooltip_hover.connect(TooltipManager.remove_hover)
	TMM.add_tooltip_hover.connect(TooltipManager.add_hover)
	TMM.remove_tooltip_hover.connect(TooltipManager.remove_hover)
	SacrificeManager.add_tooltip_hover.connect(TooltipManager.add_hover)
	SacrificeManager.remove_tooltip_hover.connect(TooltipManager.remove_hover)
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_down"):
		BuildingManager.click_tile()
		
	if Input.is_action_just_pressed("end_round"):
		#BuildingManager.create_gift("wheat", 1)
		SacrificeManager.open_godchoice_UI()
		print("End Round Debug pressed")
		
	if Input.is_action_just_pressed("debug"):
		print("Nothing bound to debug key")
		#BuildingManager.spawn_random_fish()#create_gift("wheat", 2)
		#print("\n---------------------------------\n")
		#BuildingPlacementManager/ValidBuildingLayer.display_invalid_tiles()
		#GodChoiceManager.destroy_land($GodChoiceManager.choices["burn land"])
		#TooltipManager.create_tooltip(get_global_mouse_position(), "fish", GLOBALCONSTS.TOOLTIP_TYPES.ITEM)
	
		
func punish():
	end_round()
	GodChoiceManager.display_punishments()
func reward():
	end_round()
	GodChoiceManager.display_rewards()

func end_round():
	ItemManager.drop_item_ukn()
	TooltipManager.erase_all_hovers()

func set_total_rounds(total_rounds):
	SacrificeManager.set_total_rounds(total_rounds)

func set_round_time(round_time):
	SacrificeManager.set_round_time(round_time)
	
func set_godchoices(shop, rewards, punishments):
	GodChoiceManager.set_godchoices(shop, rewards, punishments)
	
func set_tile_layers(tile_layers):
	TMM.set_tile_layers(tile_layers)
	
func set_boss(boss, boss_position):
	SacrificeManager.set_boss(boss, boss_position)
	
