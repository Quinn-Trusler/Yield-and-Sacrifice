extends Node


@export var DialogManager : Node2D
@export var SacrificeTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Cheats.USE_TUTORIAL:
		print("Using the tutorial baby!")
		DialogManager.set_dialogs([["Drag the carrot onto the farmland and drop.", -1], ["When the carrots are done growing, click to harvest.", -1], ["Drag a carrot onto the devil and drop", -1], ["Round requirments satisfied!",3], ["A new round will start when the timer hits zero.", 7], ["In the meantime stash up on carrots", 7]])
		next(false, true, false)
#detect when certain things are done so that the game timer can be stoped/started and so dialog manager can be stopped and started

#carrot planted unpause, carrot grown pause, carrot harvested change message
func next(next_dialog : bool, paused : bool, hide_dialog : bool):
	if Cheats.USE_TUTORIAL:
		if next_dialog:
			DialogManager.dialog_next()
		if paused:
			pause_time()
		else:
			unpause_time()
		DialogManager.visible = !hide_dialog

func pause_time():
	SacrificeTimer.set_paused(true)

func unpause_time():
	SacrificeTimer.set_paused(false)



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
