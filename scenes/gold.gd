extends Node2D

var GOLD_IMG = load("res://art/items/coin_outline.png")

func update_gold_num(num_gold):
	$GoldText.clear()
	$GoldText.add_image(GOLD_IMG)
	$GoldText.add_text(" " + str(num_gold))
	
