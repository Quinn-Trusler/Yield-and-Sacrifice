extends Node


@export var level_number : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UnlockedLevelButton/Text.text = str(level_number)


func _on_locked_level_button_pressed() -> void:
	print("Hey you can't play this level yet")


func _on_unlocked_level_button_pressed() -> void:
	get_parent().open_popup(level_number)

func set_locked(locked : bool):
	$LockedLevelButton.visible = locked
	$UnlockedLevelButton.visible = !locked
	print("visibility", level_number)
	print("locked", $LockedLevelButton.visible)
	print("unlocked",$UnlockedLevelButton.visible)
