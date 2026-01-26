extends Node
#At the time of making this it seems like a global script is the best move
#Not sure if it's correct but multiple scripts need these definitions

#Testing and cheats
#var ALWAYS_REWARD = true
#var ALWAYS_PUNISH = false
#var TESTING_ITEMS = false
#var ROUND_TIME_OVERRIDE = 1
#var CROP_GROWTH_TIME_OVERRIDE = 0.2



#Used only within this script
var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"


#used by other scripts
var MAPSIZE = [-14,5,5,-5]
var FIRE_SPAWN_ZONE = [-11,5,3,-2]
#[-15, -7, 9, 7]
#definitions
var CROP_SCENE_ID = 1
var FIRE_SCENE_ID = 2
var BUILDING_SCENE_ID = 3
var UNBURNABLE_TILES = ["burnt land","water","lava"]
var CROP_DEF = {"carrot":{"stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potatoe":{"stage_growth_duration":2,"total_stages":5,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potatoe","potatoe","potatoe"],"frames":CROP_FRAMES_FOLDER + "potatoe.tres","offset":Vector2(0,-8)},
"wheat":{"stage_growth_duration":1,"total_stages":7,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["wheat","wheat","wheat"],"frames":CROP_FRAMES_FOLDER + "wheat.tres","offset":Vector2(0,-3)},
"sugarcane":{"stage_growth_duration":2,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["sugarcane","sugarcane"],"frames":CROP_FRAMES_FOLDER + "sugarcane.tres","offset":Vector2(0,-10)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe","is_animated":false,"points":2,"place_on":["dry_farmland"]},
"wheat":{"display_name":"Wheat","img_name":ITEMS_FOLDER + "wheat","is_animated":false,"points":2,"place_on":["dry_farmland"]},
"sugarcane":{"display_name":"Sugarname","img_name":ITEMS_FOLDER + "sugarcane","is_animated":false,"points":3,"place_on":["dry_farmland"]},
"fish":{"display_name":"Fish","img_name":ITEMS_FOLDER + "fish","is_animated":false,"points":4,"place_on":[]},
"sugar":{"display_name":"Sugar","img_name":ITEMS_FOLDER + "sugar","is_animated":false,"points":4,"place_on":[]},
"flour":{"display_name":"Flour","img_name":ITEMS_FOLDER + "flour","is_animated":false,"points":6,"place_on":[]},
"bread":{"display_name":"Bread","img_name":ITEMS_FOLDER + "bread","is_animated":false,"points":8,"place_on":[]},
"mushroom":{"display_name":"Mushroom","img_name":ITEMS_FOLDER + "mushroom","is_animated":false,"points":4,"place_on":[]},
"voldka":{"display_name":"Voldka","img_name":ITEMS_FOLDER + "voldka","is_animated":false,"points":4,"place_on":[]},
"rum":{"display_name":"Rum","img_name":ITEMS_FOLDER + "rum","is_animated":false,"points":4,"place_on":[]},
"pepper_juice":{"display_name":"Pepper Juice","img_name":ITEMS_FOLDER + "pepper_juice","is_animated":false,"points":4,"place_on":[]},
"watering_can":{"display_name":"Watering Can","img_name":ITEM_FRAMES_FOLDER + "watering_can.tres","points":100,"is_animated":true,"place_on":[]}
}
var IMG_EXTENSION = ".png"

var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["fish"],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres", "offset":[0,0],"bounce":false},
	"god_gift":{"display_name":"Gift","output_items":[],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "gift.tres", "offset":[0,-3], "bounce":false},
	"barrel":{"display_name":"Barrel","output_items":["voldka"],"items_to_start_timer":1,"input_items":{"potatoe" : "voldka", "sugarcane":"rum"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "barrel.tres", "offset": [0,0], "extra_tiles": [],"bounce":true},
	"oven":{"display_name":"Oven","output_items":[],"items_to_start_timer":1,"input_items":{"flour" : "bread"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "oven.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	"mill":{"display_name":"Mill","output_items":[],"items_to_start_timer":1,"input_items":{"wheat" : "flour", "sugarcane" : "sugar"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "mill.tres", "offset": [0,-2.5], "extra_tiles": [],"bounce":true},
	"mushroom_patch":{"display_name":"Mushroom Patch","output_items":["mushroom"],"items_to_start_timer":0,"input_items":{},"total_stages":3,"stage_to_harvest":1,"time_per_stage":5,"destroy_on_harvest":false, "stage_loss_on_harvest": 1,"frames": BUILDINGS_FRAMES_FOLDER + "mushroom_patch.tres", "offset": [0,0], "extra_tiles": [], "bounce":false}
}

var ANIMAL_DEF = null

var MAX_LIVES = 3

var LAST_CROP_ITEM_DIALOG = ["Hey! You need to plant that to grow more!",5]
var EXTRA_ITEM_FED_DIALOG = ["Don't sacrifice more then you need to",5]


var ITEM_POLYGONS = {"carrot": [[2.5, 5.0], [-7.5, 10.0], [-10.5, 10.0], [-10.5, 7.0], [-0.5, -3.5], [-1.5, -5.5], [1.5, -9.5], [8.5, -9.0], [10.5, -5.5], [9.5, -1.0], [3.5, 0.5]],
"potatoe": [[0.0, 5.0], [4.5, 5.5], [7.5, 2.5], [7.5, -0.5], [1.5, -5.5], [-5.5, -5.5], [-7.5, -4.0], [-7.5, 0.5], [-4.5, 3.5]],
"wheat": [[4.0, -7.0], [-1.5, -8.0], [-6.0, -5.0], [-6.0, -2.0], [-4.0, 3.0], [-4.0, 7.0], [-3.0, 8.0], [1.5, 8.0], [3.0, 7.0], [3.0, 3.0], [6.0, -3.5]],
"sugarcane":[[5.5, -10.0], [0.0, -8.0], [-10.0, 3.0], [-10.0, 5.0], [-4.0, 10.0], [-2.0, 10.0], [9.0, 0.0], [9.0, -2.0], [8.0, -4.0], [10.0, -5.0], [10.0, -7.0], [7.0, -10.0]],
"fish": [[-9.0, 2.0], [-6.0, 5.0], [-1.0, 5.0], [3.0, 3.0], [5.0, 2.0], [6.0, 4.0], [9.0, 4.0], [9.0, 2.0], [7.0, 0.5], [9.0, -1.0], [9.0, -3.0], [6.0, -3.0], [4.0, -2.0], [-1.0, -5.0], [-6.0, -5.0], [-9.0, -2.0]],
"flour": [[-6.0, -5.0], [-6.0, 9.0], [6.0, 9.0], [6.0, -5.0], [2.0, -9.0], [-0.5, -9.0]],
"bread":[[-7.0, -7.0], [-10.0, -4.0], [-10.0, 0.0], [-6.0, 3.0], [5.0, 7.5], [10.0, 3.0], [10.0, 0.0], [4.0, -3.5]],
"mushroom":[[3.0, -8.5], [8.0, -3.5], [8.0, -1.5], [4.0, 1.5], [4.0, 6.5], [0.0, 8.5], [-2.0, 7.5], [-3.0, 2.5], [-8.0, -1.5], [-8.0, -3.0], [-3.0, -8.5]],
"pepper juice": [[4.5, -9.0], [5.5, -7.0], [5.5, -1.0], [3.5, 5.0], [-0.5, 9.0], [-5.5, 9.0], [-5.5, 6.0], [-1.5, 3.0], [-1.5, -0.5], [0.5, -7.0], [1.5, -9.0]],
"rum": [[2.5, 9.0], [-2.5, 9.0], [-4.5, 7.0], [-4.5, 1.0], [-1.5, -1.5], [-1.5, -9.0], [1.5, -9.0], [1.5, -1.5], [4.5, 1.0], [4.5, 7.0]],
"sugar":[[3.5, 6.5], [-3.5, 6.5], [-8.5, 2.5], [-8.5, 0.5], [-1.5, -6.5], [1.5, -6.5], [8.5, 0.5], [8.5, 2.5]],
"voldka":[[3.5, 9.0], [2.5, 10.0], [-2.5, 10.0], [-3.5, 9.0], [-3.5, -2.0], [-1.5, -3.0], [-1.5, -10.0], [1.5, -10.0], [1.5, -3.0], [3.5, -2.0]]
}
