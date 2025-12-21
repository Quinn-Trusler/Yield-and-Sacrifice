extends Node
#At the time of making this it seems like a global script is the best move
#Not sure if it's correct but multiple scripts need these definitions

#Used only within this script
var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"


#used by other scripts
var MAPSIZE = [-14,5,5,-5]
#[-15, -7, 9, 7]
#definitions
var CROP_SCENE_ID = 1
var FIRE_SCENE_ID = 2
var BUILDING_SCENE_ID = 3
var UNBURNABLE_TILES = ["burnt land","water","lava"]
var CROP_DEF = {"carrot":{"stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potatoe":{"stage_growth_duration":2,"total_stages":5,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potatoe","potatoe","potatoe"],"frames":CROP_FRAMES_FOLDER + "potatoe.tres","offset":Vector2(0,-8)},
"sugarcane":{"stage_growth_duration":2,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["sugarcane","sugarcane"],"frames":CROP_FRAMES_FOLDER + "sugarcane.tres","offset":Vector2(0,-10)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe","is_animated":false,"points":2,"place_on":["dry_farmland"]},
"sugarcane":{"display_name":"Sugarname","img_name":ITEMS_FOLDER + "sugarcane","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"fish":{"display_name":"Fish","img_name":ITEMS_FOLDER + "fish","is_animated":false,"points":4,"place_on":[]},
"mushroom":{"display_name":"Mushroom","img_name":ITEMS_FOLDER + "mushroom","is_animated":false,"points":4,"place_on":[]},
"voldka":{"display_name":"Voldka","img_name":ITEMS_FOLDER + "voldka","is_animated":false,"points":4,"place_on":[]},
"rum":{"display_name":"Rum","img_name":ITEMS_FOLDER + "rum","is_animated":false,"points":4,"place_on":[]},
"pepper_juice":{"display_name":"Pepper Juice","img_name":ITEMS_FOLDER + "pepper_juice","is_animated":false,"points":4,"place_on":[]},
"watering_can":{"display_name":"Watering Can","img_name":ITEM_FRAMES_FOLDER + "watering_can.tres","points":100,"is_animated":true,"place_on":[]}
}
var IMG_EXTENSION = ".png"

var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["fish"],"items_to_start_timer":0,"input_items":[],"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres", "offset":[0,0]},
	"barrel":{"display_name":"Barrel","output_items":["voldka"],"items_to_start_timer":1,"input_items":["potatoe"],"total_stages":1,"stage_to_harvest":1,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 1,"frames": BUILDINGS_FRAMES_FOLDER + "barrel.tres", "offset": [0,0], "extra_tiles": []},
	"mushroom_patch":{"display_name":"Mushroom Patch","output_items":["mushroom"],"items_to_start_timer":0,"input_items":[],"total_stages":3,"stage_to_harvest":1,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 1,"frames": BUILDINGS_FRAMES_FOLDER + "mushroom_patch.tres", "offset": [0,0], "extra_tiles": []}
}

var ANIMAL_DEF = null

var MAX_LIVES = 3
