extends Node
#At the time of making this it seems like a global script is the best move
#Not sure if it's correct but multiple scripts need these definitions

#Used only within this script
var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"


#used by other scripts
var MAPSIZE = [-13,5,4,-4]

#definitions
var CROP_SCENE_ID = 1
var FIRE_SCENE_ID = 2
var BUILDING_SCENE_ID = 3
var UNBURNABLE_TILES = ["burnt land","water","lava"]
var CROP_DEF = {"carrot":{"stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potatoe":{"stage_growth_duration":2,"total_stages":5,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potatoe","potatoe","potatoe"],"frames":CROP_FRAMES_FOLDER + "potatoe.tres","offset":Vector2(0,-8)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot.png","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe.png","is_animated":false,"points":2,"place_on":["dry_farmland"]},
"fish":{"display_name":"Fish","img_name":ITEMS_FOLDER + "fish.png","is_animated":false,"points":4,"place_on":[]},
"watering_can":{"display_name":"Watering Can","img_name":ITEM_FRAMES_FOLDER + "watering_can.tres","points":100,"is_animated":true,"place_on":[]}
}

var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["fish"],"items_to_start_timer":0,"input_items":[],"total_stages":1,"time_per_stage":0,"destroy_on_harvest":true, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres"}}

var ANIMAL_DEF
