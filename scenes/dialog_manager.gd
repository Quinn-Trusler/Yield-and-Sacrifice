extends CanvasLayer
#something else in the program may want give text to the dialog manager

#Time < 0 will be infinite
var dialogs = [["12345678919",1],["yadayad",-1]] #[dialog text, seconds]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dialog_next()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#Deletes all dialogs and hides dialog box
func clear_dialog():
	dialogs = []
	$DialogBox.visible = false
	$Timer.stop()
func set_dialogs(ds):
	dialogs = ds
	dialog_next() 
#Sets dialog text and timer based on dialogs array
func dialog_next() -> void:
	if len(dialogs) > 0:
		$DialogBox.set_dialog(dialogs[0][0])
		if dialogs[0][1] > 0:
			$Timer.wait_time = dialogs[0][1]
			$Timer.start()
		else:
			$Timer.stop()
		dialogs.remove_at(0)
		$DialogBox.visible = true
	else:
		$DialogBox.visible = false		

func dialog_ended() -> void:
	dialog_next()

func _on_timer_timeout() -> void:
	dialog_ended()
