extends RichTextLabel

var tween : Tween

func animate() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1,1), 0.1)
