extends Node
#At the time of making this it seems like a global script is the best move
#Not sure if it's correct but multiple scripts need these definitions


#Used only within this script
var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"


#used by other scripts
var MAPSIZE = [-14,-3,4,6]
var VISIBLE_MAPSIZE = [-15,-4,5,7]
var FIRE_SPAWN_ZONE = [-14,-3,4,6]
var FIRE_RANGE = [-15,-4,5,7] # Range in wich fire can grow in
var UI_TILES : Array[Vector2i] = [Vector2i()]

#definitions
var CROP_SCENE_ID = 1
var FIRE_SCENE_ID = 2
var BUILDING_SCENE_ID = 3
var MIDDLE_TILES = {"farmland" : {"ID" : Vector2i(3, 3), "phantom_ID" : Vector2i(4,0)},
					"sandy_farmland" : {"ID" : Vector2i(4, 3), "phantom_ID" : Vector2i(5,0)}}

enum REACTIONS {NONE,ALCOHOL,SHROOMS}
var NO_BUILDING_PLACEMENT_TILES = ["burnt land", "water", "lava", "dry_farmland", "sandy_farmland"]
var UNBURNABLE_TILES = ["burnt land", "UI"]
var UNBURNABLE_TERRAIN_TILES = ["water","lava"]
var INITIALLY_UNBURNABLE_TILES = ["dry_farmland", "sandy_farmland"] # Fire can not be placed directly on these tiles
var CROP_DEF = {"carrot":{"stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potatoe":{"stage_growth_duration":2,"total_stages":5,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potatoe","potatoe","potatoe"],"frames":CROP_FRAMES_FOLDER + "potatoe.tres","offset":Vector2(0,-8)},
"wheat":{"stage_growth_duration":1,"total_stages":7,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["wheat","wheat","wheat"],"frames":CROP_FRAMES_FOLDER + "wheat.tres","offset":Vector2(0,-3)},
"sugarcane":{"stage_growth_duration":2,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["sugarcane","sugarcane"],"frames":CROP_FRAMES_FOLDER + "sugarcane.tres","offset":Vector2(0,-10)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img_name":ITEMS_FOLDER + "carrot","is_animated":false,"points":10,"place_on":["dry_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [0,5]},
"potatoe":{"display_name":"Potatoe","img_name":ITEMS_FOLDER + "potatoe","is_animated":false,"points":10,"place_on":["dry_farmland"],"reaction":REACTIONS.NONE,  "num_offset" : [4,3]},
"plastic_bag":{"display_name":"Plastic Bag","img_name":ITEMS_FOLDER + "plastic_bag","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [5, -1]},
"rice":{"display_name":"Rice","img_name":ITEMS_FOLDER + "rice","is_animated":false,"points":10,"place_on":["swamp_water_edge"],"reaction":REACTIONS.NONE,  "num_offset" : [6.5, 0]},
"prickly_pear":{"display_name":"Prickly Pear","img_name":ITEMS_FOLDER + "prickly_pear","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [3, -1]},
"devil_pepper":{"display_name":"Devil Pepper","img_name":ITEMS_FOLDER + "devil_pepper","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [6,-3]},
"wheat":{"display_name":"Wheat","img_name":ITEMS_FOLDER + "wheat","is_animated":false,"points":10,"place_on":["dry_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [4,1]},
"sugarcane":{"display_name":"Sugarname","img_name":ITEMS_FOLDER + "sugarcane","is_animated":false,"points":10,"place_on":["swampy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [5,2]},
"melon":{"display_name":"Melon","img_name":ITEMS_FOLDER + "melon","is_animated":false,"points":10,"place_on":["sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
"fish":{"display_name":"Fish","img_name":ITEMS_FOLDER + "fish","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"sugar":{"display_name":"Sugar","img_name":ITEMS_FOLDER + "sugar","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,3]},
"cooked_rice":{"display_name":"Cooked Rice","img_name":ITEMS_FOLDER + "cooked_rice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [8.5,-1]},
"flour":{"display_name":"Flour","img_name":ITEMS_FOLDER + "flour","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,1]},
"bread":{"display_name":"Bread","img_name":ITEMS_FOLDER + "bread","is_animated":false,"points":30,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8,4]},
"mushroom":{"display_name":"Mushroom","img_name":ITEMS_FOLDER + "mushroom","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.SHROOMS, "num_offset" : [4,0]},
"cranberry":{"display_name":"Cranberry","img_name":ITEMS_FOLDER + "cranberry","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
"cranberry_jam":{"display_name":"Cranberry Jam","img_name":ITEMS_FOLDER + "cranberry_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
"melon_jam":{"display_name":"Melon Jam","img_name":ITEMS_FOLDER + "melon_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
"prickly_pear_jam":{"display_name":"Prickly Pear Jam","img_name":ITEMS_FOLDER + "prickly_pear_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5,0]},
"vodka":{"display_name":"Vodka","img_name":ITEMS_FOLDER + "vodka","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3,3]},
"rum":{"display_name":"Rum","img_name":ITEMS_FOLDER + "rum","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [5,2]},
"sake":{"display_name":"Sake","img_name":ITEMS_FOLDER + "sake","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3.5, 2]},
"gold":{"display_name":"Gold","img_name":ITEMS_FOLDER + "coin","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE},
"pepper_juice":{"display_name":"Pepper Juice","img_name":ITEMS_FOLDER + "pepper_juice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE},
"watering_can":{"display_name":"Watering Can","img_name":ITEM_FRAMES_FOLDER + "watering_can.tres","points":100,"is_animated":true,"place_on":[],"reaction":REACTIONS.NONE}
}
var IMG_EXTENSION = ".png"

# Place on means what terrain tiles the building is ristricted to
var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","output_items":["fish"],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres", "offset":[0,0],"bounce":false},
	"well":{"display_name":"Well","output_items":["gold"],"items_to_start_timer":0,"input_items":{},"total_stages":1,"stage_to_harvest":1,"time_per_stage":4,"destroy_on_harvest":false,"stage_loss_on_harvest": 1, "frames": BUILDINGS_FRAMES_FOLDER + "well.tres", "offset":[0,-1],"bounce":true},
	"god_gift":{"display_name":"Gift","output_items":[],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "gift.tres", "offset":[0,-3], "bounce":false},
	"barrel":{"display_name":"Barrel","output_items":["vodka"],"items_to_start_timer":1,"input_items":{"potatoe" : "vodka", "sugarcane":"rum"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "barrel.tres", "offset": [0,0], "extra_tiles": [],"bounce":true},
	"oven":{"display_name":"Oven","output_items":[],"items_to_start_timer":1,"input_items":{"flour" : "bread"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "oven.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	"mill":{"display_name":"Mill","output_items":[],"items_to_start_timer":1,"input_items":{"wheat" : "flour", "sugarcane" : "sugar"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "mill.tres", "offset": [0,-2.5], "extra_tiles": [],"bounce":true},
	"mushroom_patch":{"display_name":"Mushroom Patch","output_items":["mushroom"],"items_to_start_timer":0,"input_items":{},"total_stages":3,"stage_to_harvest":1,"time_per_stage":5,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["grass"], "frames": BUILDINGS_FRAMES_FOLDER + "mushroom_patch.tres", "offset": [0,0], "extra_tiles": [], "bounce":false},
	"devil_vine":{"display_name":"Devil Vine","output_items":["devil_pepper"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":4,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 4, "place_on":["sand"],"frames": BUILDINGS_FRAMES_FOLDER + "devil_vine.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	"prickly_pear_cactus":{"display_name":"Prickly Pear Cactus","output_items":["prickly_pear"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":1,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["sand"], "frames": BUILDINGS_FRAMES_FOLDER + "prickly_pear_cactus.tres", "offset": [0,-1], "extra_tiles": [], "bounce":false},
	"farmland":{"display_name": "Farmland","place_on": ["grass"]},
	"sandy_farmland":{"display_name": "Sandy Farmland","place_on": ["sand"]},
}


	

var ANIMAL_DEF = null

var MAX_LIVES = 3
var CAN_BUNDLE_BUNDLES : bool = true

var LAST_CROP_ITEM_DIALOG = ["Hey! You need to plant that to grow more!",5]
var EXTRA_ITEM_FED_DIALOG = ["Don't sacrifice more then you need to",5]
var BUILDING_PHANTOM_MODULATION : Color = Color(1,1,1,0.5)
var ITEM_DIM_COLOUR : Color = Color(1,1,1,0)

var ROUND_COMPLETION_GOLD = 0
var ROUND_TIME = 23

var ITEM_POLYGONS = {"carrot":[[2.5, 5.0], [-7.5, 10.0], [-10.5, 10.0], [-10.5, 7.0], [-0.5, -3.5], [-1.5, -5.5], [1.5, -9.5], [8.5, -9.0], [10.5, -5.5], [9.5, -1.0], [3.5, 0.5]],
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
"vodka":[[3.5, 9.0], [2.5, 10.0], [-2.5, 10.0], [-3.5, 9.0], [-3.5, -2.0], [-1.5, -3.0], [-1.5, -10.0], [1.5, -10.0], [1.5, -3.0], [3.5, -2.0]],
"sake" : [[3.5, -2.0], [3.5, 9.0], [2.5, 10.0], [-2.5, 10.0], [-3.5, 9.0], [-3.5, -2.0], [-1.5, -4.0], [-1.5, -10.0], [1.5, -10.0], [1.5, -4.0]],
"gold":[[2.0, 7.0], [-2.0, 7.0], [-5.0, 5.0], [-7.0, 2.0], [-7.0, -2.0], [-5.0, -5.0], [-2.0, -7.0], [2.0, -7.0], [5.0, -5.0], [7.0, -2.0], [7.0, 2.0], [5.0, 5.0]],
"prickly_pear" : [[2.0, 6.0], [-3.0, 6.0], [-5.0, 4.0], [-5.0, -4.0], [-3.0, -6.0], [2.0, -6.0], [4.0, -4.0], [4.0, 4.0]],
"devil_pepper" : [[7.5, 9.5], [-0.5, 5.5], [-4.5, 1.5], [-10.5, -2.5], [-10.5, -4.5], [-7.5, -4.5], [-1.5, -1.5], [-4.5, -5.5], [-4.5, -8.5], [-3.0, -9.5], [-0.5, -7.5], [2.5, -2.5], [6.5, 1.5], [10.5, 6.5], [10.5, 9.5]],
"plastic_bag": [[3.5, 5.5], [-3.5, 5.5], [-5.5, 3.5], [-5.5, -2.5], [-3.5, -5.5], [-0.5, -3.5], [0.5, -1.5], [1.5, -4.5], [3.0, -5.5], [5.5, -2.5], [5.5, 3.5]],
"prickly_pear_jam" : [[-5.0, -6.5], [-4.0, -7.5], [4.0, -7.5], [5.0, -6.5], [5.0, 5.5], [3.0, 7.5], [-3.0, 7.5], [-5.0, 5.5]],
"cranberry_jam" :[[-5.0, -6.5], [-4.0, -7.5], [4.0, -7.5], [5.0, -6.5], [5.0, 5.5], [3.0, 7.5], [-3.0, 7.5], [-5.0, 5.5]],
"melon_jam" : [[-5.0, -6.5], [-4.0, -7.5], [4.0, -7.5], [5.0, -6.5], [5.0, 5.5], [3.0, 7.5], [-3.0, 7.5], [-5.0, 5.5]],
"cranberry" : [[-3.0, 7.0], [-6.0, 4.0], [-6.0, 1.5], [-6.0, 0.0], [-8.0, -3.0], [-8.0, -5.0], [-5.0, -4.0], [-6.0, -8.0], [-2.0, -7.0], [-0.5, -5.0], [3.0, -6.0], [6.0, -2.5], [6.0, 1.0], [8.0, 2.0], [8.0, 5.0], [5.0, 8.0], [2.0, 8.0], [1.0, 7.0], [0.0, 7.0]],
"melon" : [[7.0, -7.0], [10.0, -6.0], [10.0, 1.0], [3.0, 7.0], [-4.0, 7.0], [-10.0, 3.0], [-10.0, 1.0]],
"rice" : [[6.0, -5.5], [7.0, -3.5], [4.0, 2.5], [7.0, 4.5], [7.0, 7.5], [4.0, 7.5], [0.0, 3.5], [0.0, 4.5], [0.0, 7.5], [-3.0, 7.5], [-7.0, 3.5], [-7.0, 0.5], [-4.0, -1.5], [-6.0, -4.5], [-6.0, -7.5], [-3.0, -7.5], [1.0, -3.5], [4.0, -5.5]],
"cooked_rice" : [[-3.5, 6.5], [-7.5, 3.5], [-8.5, 0.5], [-3.5, -5.5], [1.0, -6.5], [9.0, 0.5], [7.5, 3.5], [3.5, 6.5]]
}
