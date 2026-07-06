extends Node2D


var DRAGGABLE_ITEM = preload("res://scenes/draggable_item.tscn")
var BUNDLED_ITEM = DRAGGABLE_ITEM
var FLYING_COIN_SCENE = preload("res://scenes/flying_coin.tscn")
var draggable_items = []
var item_is_last:bool = false
var item_being_dragged
var absorbing_items : bool = false
var item_in_focus = null
var focus_items = []
var crops_planted:Dictionary[String,int] = {"carrot":0,"potato":0,"wheat":0,"sugarcane":0,"melon":0,"rice":0}
var items_in_bundle_field = []

var left_down : bool = false
var right_down : bool = false
var form_bundle_down : bool = false

var mouse_on_mouth = false

var RNG = RandomNumberGenerator.new()

#Tutorial
@export var TutorialManager : Node
@export var DialogManager: Node2D
@export var GodChoiceManager: CanvasLayer
var first_item_planted : bool = false


#@export var TileLayer : TileMapLayer
#@export var TileLayer2 : TileMapLayer
#@export var TerrainLayer : TileMapLayer
@export var SacrificeManager : Node2D
@export var TMM : Node2D
@export var BuildingManager = Node2D

signal item_picked_up(item_name, last_item)
signal item_dropped()

func spawn_testing_items():
	create_draggable_item("devil_pepper",Vector2(-100,-30))
	create_draggable_item("prickly_pear",Vector2(-70,-30))
	create_draggable_item("devil_pepper",Vector2(-100,-30))
	create_draggable_item("prickly_pear",Vector2(-70,-30))
	create_draggable_item("devil_pepper",Vector2(-100,-30))
	create_draggable_item("prickly_pear",Vector2(-70,-30))
	create_draggable_item("plastic_bag",Vector2(-100,-30))
	create_draggable_item("plastic_bag",Vector2(-70,-30))
	
	for i in range(5):
		create_draggable_item("rice",Vector2(-75,-30))
		create_draggable_item("cooked_rice",Vector2(-75,-30))
		create_draggable_item("melon",Vector2(-75,-30))
		create_draggable_item("melon_jam",Vector2(-75,-30))
		create_draggable_item("cranberry",Vector2(-75,-30))
		create_draggable_item("cranberry_jam",Vector2(-75,-30))
		create_draggable_item("sake",Vector2(-75,-30))
		create_draggable_item("prickly_pear_jam",Vector2(-75,-30))
	##
	create_draggable_item("mushroom",Vector2(-75,-30))
	create_draggable_item("mushroom",Vector2(-75,-30))
	create_draggable_item("mushroom",Vector2(-75,-30))
	create_draggable_item("carrot",Vector2(-75,-30))
	##
	create_draggable_item("vodka",Vector2(-30,-20))

	create_draggable_item("gold",Vector2(-50,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	create_draggable_item("gold",Vector2(-60,-40))
	
	#create_draggable_item("pepper_juice",Vector2(-70,-40))

func _ready() -> void:
	create_draggable_item("carrot",Vector2(-50,-30))
	if Cheats.TESTING_ITEMS:
		spawn_testing_items()

func dim() -> void:
	modulate = GLOBALCONSTS.ITEM_DIM_COLOUR

func undim() -> void:
	modulate = Color.WHITE

func increase_gold(num_gold : int):
	GodChoiceManager.increase_gold(num_gold)

func consume_gold():
	# Create flying gold particle
	var temp = FLYING_COIN_SCENE.instantiate()
	add_child(temp)
	temp.set_pos(item_in_focus.position)
	
	# Delete gold item
	erase_item(item_in_focus)
	refocus()
	
# Extra unused variables to make modifications easier in future
func deal_with_state(just_pressed : String = "none", just_released : String = "none") -> void:
	if item_being_dragged and just_pressed == "left_click": # Drop Item
		drop_item(item_being_dragged)
		
	elif item_being_dragged and just_pressed == "right_click": # Drop One Item
		if item_being_dragged.IS_BUNDLE and item_being_dragged.num_items > 1:
			drop_one()
		else:
			drop_item(item_being_dragged)
		
	elif item_in_focus:
		if just_pressed == "left_click":
			if item_in_focus.item_name == "gold":
				consume_gold()
			else:
				pickup_item(item_in_focus)
		elif just_pressed == "right_click":
			if item_in_focus.item_name == "gold":
				consume_gold()
			elif item_in_focus.IS_BUNDLE == true:
				grab_from_bundle()
			else:
				$PickUp.play()
				pickup_item(item_in_focus)
				
	if item_being_dragged and form_bundle_down: # Instantly absorb
		absorbing_items = true
		$BundleField.monitoring = true
		if item_being_dragged.item_name in GLOBALCONSTS.ITEM_POLYGONS:
			$BundleField/CollisionPolygon2D.polygon = convert_polygon(GLOBALCONSTS.ITEM_POLYGONS[item_being_dragged.item_name])
		else:
			print("Warning: No colision polygon for " + item_being_dragged.item_name)
	else:
		absorbing_items = false
		$BundleField.monitoring = false
	
func convert_polygon(poly):
	var new_poly = []
	for point in poly:
		new_poly.append(Vector2(point[0], point[1]))
	return new_poly
	
func _process(_delta: float) -> void:
	$BundleField.position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click"):
		left_down = true
		deal_with_state("left_click")
	if Input.is_action_just_released("left_click"):
		left_down = false
		deal_with_state("none","left_click")
	if Input.is_action_just_pressed("right_click"):
		right_down = true
		deal_with_state("right_click")
	if Input.is_action_just_released("right_click"):
		right_down = false
		deal_with_state("none", "right_click")
	if Input.is_action_just_pressed("form_bundle"):
		form_bundle_down = true
		deal_with_state("form_bundle")
	if Input.is_action_just_released("form_bundle"):
		form_bundle_down = false
		deal_with_state("none", "form_bundle")
	
	if item_being_dragged:
		item_being_dragged.go_to_mouse_pos()
			
func erase_item(item):
	remove_from_focus_list(item)
	draggable_items.erase(item)
	item.free()

#drage items from bundle
func grab_from_bundle():
	var temp
	if item_in_focus.get_num() == 2:#time to get deleted
		create_animated_item(item_in_focus.item_name, get_global_mouse_position())
		temp = create_draggable_item(item_in_focus.item_name,get_global_mouse_position())
		erase_item(item_in_focus)# delete bundled item
	else:
		temp = create_draggable_item(item_in_focus.item_name,get_global_mouse_position())
		item_in_focus.decrease_num()
	
	if item_in_focus:
		item_in_focus.stop_focus()
	temp.focus()
	item_in_focus = temp
	$PickUp.play()
	pickup_item(temp)

#Pop items out of bundle
#In this case the bundle is the item in focus
#func harvest_from_bundle():
	#if item_in_focus.get_num() == 2:#time to get deleted
		#create_animated_item(item_in_focus.item_name, get_global_mouse_position())
		#create_animated_item(item_in_focus.item_name, get_global_mouse_position())
		#erase_item(item_in_focus)# delete bundled item
	#else:
		#create_animated_item(item_in_focus.item_name, get_global_mouse_position())
		#item_in_focus.decrease_num()

#func absorb_all_items():
	#$BundleField.monitoring = true
	#var valid_items = []
	#for item in items_in_bundle_field:
		#if item != item_being_dragged and item.item_name == item_being_dragged.item_name:
			#valid_items.append(item)
	#
	#var num_to_gain = 0
	#for i in range(len(valid_items)-1):
		#num_to_gain += valid_items[i].num_items
		#erase_item(valid_items[i])
		#
	#item_being_dragged.increase_num(num_to_gain)
		
func _on_bundle_field_area_entered(area: Area2D) -> void:
	if area.name == "DraggableItemArea2D":
		var item = area.get_parent()

		print(item.item_name)
		print(item_being_dragged.item_name)
		if absorbing_items and item_being_dragged != item and item.item_name == item_being_dragged.item_name:
			item_being_dragged.increase_num(item.num_items)
			erase_item(item)
		else:
			items_in_bundle_field.append(item)

func _on_bundle_field_area_exited(area: Area2D) -> void:
	if area.name == "DraggableItemArea2D":
		items_in_bundle_field.erase(area.get_parent())
		
func remove_from_focus_list(item_obj) -> void:
	focus_items.erase(item_obj)
	if item_in_focus == item_obj:
		item_in_focus.stop_focus()
		if not item_being_dragged:
			refocus()
		
func add_to_focus_list(item_obj):
	focus_items.append(item_obj)
	if not item_being_dragged:
		refocus()

func refocus():
	var largest_layer = 0
	var ind = -1
	if len(focus_items):
		#Search through array for biggest layer
		for i in range(len(focus_items)):
			if focus_items[i].get_index() > largest_layer:
				largest_layer = focus_items[i].get_index()
				ind = i
	
		if item_in_focus:
			item_in_focus.stop_focus()
		item_in_focus = focus_items[ind]
		item_in_focus.focus()
	else:
		item_in_focus = null
		

func create_draggable_item(item_name,pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	temp.initialize(item_name,GLOBALCONSTS.ITEM_DEF[item_name])
	temp.position = pos
	return temp

func create_animated_item(item_name, pos):
	var temp = DRAGGABLE_ITEM.instantiate()
	add_child(temp)
	draggable_items.append(temp)
	var up_factor = 16
	temp.initialize(item_name,GLOBALCONSTS.ITEM_DEF[item_name])
	temp.play_animation(pos.y - up_factor,Vector2(up_factor/16.0,up_factor/16.0))
	temp.position = pos
	
# If the item must be replanted it sets item_is_last var to true
func set_item_is_last(item):
	if GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"] != []:#Item is crop
		var count = 0
		for draggable_item in draggable_items:
			if draggable_item.item_name == item.item_name:
				count +=1
		if count == 1:#just self
			item_is_last = true

func pickup_item(item):
	item_in_focus = null
	self.move_child(item, get_child_count() - 1)
	item_being_dragged = item
	set_item_is_last(item)
	if not item.IS_BUNDLE:
		item_picked_up.emit(item.item_name, is_last_item(item))
	$PickUp.play()
	
func drop_item_ukn():
	if item_being_dragged:
		$PutDown.play()
		drop_item(item_being_dragged)
		# Hack job to get bundles to not cause an error when getting a godchoice
		absorbing_items = false
		$BundleField.monitoring = false
		
func get_dragging_item_placeable():
	if item_being_dragged and not item_being_dragged.IS_BUNDLE:
		var pos = TMM.TileLayer.local_to_map(TMM.TileLayer.to_local(item_being_dragged.position))
		var tile_name = TMM.TileLayer.get_tile_name(pos)
		var terrain_tile_name = TMM.TerrainLayer.get_tile_name(pos)
		
		if tile_name in GLOBALCONSTS.ITEM_DEF[item_being_dragged.item_name]["place_on"] or terrain_tile_name in GLOBALCONSTS.ITEM_DEF[item_being_dragged.item_name]["place_on"]:
			if TMM.TileLayer2.is_empty(pos):#empty cell
				return true
	return false
			
func crop_uprooted(item_name):
	crops_planted[item_name] -=1
	
func is_last_item_bundle(item): # Hack Job
	if GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"] != [] and crops_planted[item.item_name] == 0:#Item is crop
		print("this bundle might be a last item")
		var count = 0
		for draggable_item in draggable_items:
			if draggable_item.item_name == item.item_name:
				count +=1
		if count == 1:#just self
			print("This bundle is the last item")
			return true
	return false
			
func is_last_item(item):
	return (item_is_last and crops_planted[item.item_name] == 0)
	
	
# Either consuming a bundle or an item	
func attempt_consume_item(item, consume_max : int = 1):
	var pos = TMM.TileLayer.to_local(item.position)
	var tile_name = TMM.TileLayer.get_tile_name_from_local(pos)
	var terrain_tile_name = TMM.TerrainLayer.get_tile_name_from_local(pos)
	pos = TMM.TileLayer.local_to_map(pos)
	
	var number_items_consumed = 0
	
	
	if mouse_on_mouth:# Kind of ugly/repetitive code, it could be cleaned up
		if item.IS_BUNDLE: 
			print("%s is a bundle." % [item.item_name])
			if is_last_item_bundle(item) and consume_max == item.num_items: # Last of the items and trying to expend all, expend all but one
				print("Attempt sacrifice all - one")
				number_items_consumed = SacrificeManager.sacrifice(item.item_name, consume_max - 1)
			else:
				print("Attempt sacrifice all")
				number_items_consumed = SacrificeManager.sacrifice(item.item_name, consume_max)
		elif not item.IS_BUNDLE and not is_last_item(item):
			number_items_consumed = SacrificeManager.sacrifice(item.item_name)
		else:
			DialogManager.override_current_dialog(GLOBALCONSTS.LAST_CROP_ITEM_DIALOG)
		if number_items_consumed > 0:
			$EatItem.play()
	elif consume_max == 1:
		#Attempt place crop
		if tile_name in GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"] or terrain_tile_name in GLOBALCONSTS.ITEM_DEF[item.item_name]["place_on"]:
			if TMM.TileLayer2.is_empty(pos):#empty cell
				number_items_consumed = 1
				TMM.TileLayer2.plant_crop(pos,item.item_name)
				crops_planted[item.item_name] +=1
				$DropInBuilding.play()
				if not first_item_planted:
					first_item_planted = true
					TutorialManager.next(true, true, false)
			else:
				print("Error: Cannot plant on already planted farmland")
					
		#Attempt to place item in building
		elif not TMM.TileLayer2.is_empty(pos):#2nd layer cell not empty
			var scene = TMM.TileLayer2.get_cell_scene(pos)
			if scene and scene.BUILDING_TYPE == "building" and not is_last_item(item):
				var delete_item = scene.place_item(item.item_name)
				if delete_item:
					number_items_consumed = 1
				$DropInBuilding.play()
			else:
				$PutDown.play()
		else:
			$PutDown.play()
		#Item drop normaly
	else:
		$PutDown.play()
	return number_items_consumed
	
func drop_one():
	item_being_dragged.decrease_num()
	var delete_item = attempt_consume_item(item_being_dragged, 1)
	if not delete_item: # Create an item instance underneath bundle
		output_resources_at_mouse([item_being_dragged.item_name])
		
		
		
		
	
#called by the item itself
func drop_item(item):
	item_being_dragged = null
	refocus()
	
	item_dropped.emit()
	var number_items_consumed = attempt_consume_item(item, item.num_items)
	
	item_is_last = false
	
	if number_items_consumed >= item.num_items: # Consumed all items then delete
		erase_item(item)
	else: # Not all items consumed so decrement
		item.decrease_num(number_items_consumed)
		
		
func output_resources_at_mouse(resources):
	output_resources(resources, get_global_mouse_position())
	
func output_resources(resources, pos):
	if resources:
		$item_pop.play()
		for i in range(len(resources)):
			create_animated_item(resources[i],pos)
