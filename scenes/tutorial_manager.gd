extends Node


@export var DialogManager : CanvasLayer
@export var SacraficeTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.set_dialogs([["Plant the carrot", -1], ["Harvest the carrot", -1], ["Feed it to me", -1]])
	next(false, true, false)
#detect when certain things are done so that the game timer can be stoped/started and so dialog manager can be stopped and started

#carrot planted unpause, carrot grown pause, carrot harvested change message
func next(next_dialog : bool, paused : bool, hide_dialog : bool):
	if next_dialog:
		DialogManager.dialog_next()
	if paused:
		pause_time()
	else:
		unpause_time()
	DialogManager.visible = !hide_dialog

func pause_time():
	SacraficeTimer.set_paused(true)

func unpause_time():
	SacraficeTimer.set_paused(false)



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
