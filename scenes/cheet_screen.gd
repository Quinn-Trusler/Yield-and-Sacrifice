extends Node2D

func _ready() -> void:
	if not Cheats.DISPLAY_CHEATS:
		play_game()
	else:
		set_values()

#Sets button values based on variables
func set_values():
	$HBox/VBox/AlwaysReward.button_pressed = Cheats.ALWAYS_REWARD
	$HBox/VBox/AlwaysPunish.button_pressed = Cheats.ALWAYS_PUNISH
	$HBox/VBox/TestingItems.button_pressed = Cheats.TESTING_ITEMS
	$HBox/VBox/SkipTutorial.button_pressed = !Cheats.USE_TUTORIAL
	$HBox/VBox/RoundTime/Input.text = str(Cheats.ROUND_TIME_OVERRIDE)
	$HBox/VBox/CropGrowthTime/Input.text = str(Cheats.CROP_GROWTH_TIME_OVERRIDE)
	$HBox/VBox/BuildingStageTime/Input.text = str(Cheats.BUILDING_STAGE_TIME_OVERRIDE)

func play_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_play_game_pressed() -> void:
	play_game()
	
#---Toggles---

func _on_always_reward_toggled(toggled_on: bool) -> void:
	Cheats.ALWAYS_REWARD = toggled_on
	
func _on_always_punish_toggled(toggled_on: bool) -> void:
	Cheats.ALWAYS_PUNISH = toggled_on

func _on_testing_items_toggled(toggled_on: bool) -> void:
	Cheats.TESTING_ITEMS = toggled_on
	
func _on_skip_tutorial_toggled(toggled_on: bool) -> void:
	Cheats.USE_TUTORIAL = !toggled_on

#---Text input converters---

func convert_text_to_int(text : String):
	if text.is_valid_int():
		return int(text)
	else:
		return null
		
func convert_text_to_float(text : String):
	if text.is_valid_float():
		return float(text)
	else:
		return null

#---Overrides---

func _on_round_time_text_changed(new_text: String) -> void:
	Cheats.ROUND_TIME_OVERRIDE = convert_text_to_int(new_text)
	
func _on_crop_growth_time_changed(new_text: String) -> void:
	Cheats.CROP_GROWTH_TIME_OVERRIDE = convert_text_to_float(new_text)

func _on_building_stage_time_changed(new_text: String) -> void:
	Cheats.BUILDING_STAGE_TIME_OVERRIDE = convert_text_to_float(new_text)
