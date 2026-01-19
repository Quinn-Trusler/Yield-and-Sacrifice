extends Node

class_name ChainedReward

#var chain = ["potato", "barrel"]
var chain:Array[String]
var ind = 0
var id

func _init(c : Array[String], i : int) -> void:
	chain = c
	id = i
	
func get_reward():
	return chain[ind]
func reward_chosen():
	ind += 1
func get_id():
	return id
	
