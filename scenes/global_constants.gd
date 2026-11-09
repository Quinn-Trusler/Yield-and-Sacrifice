extends Node
#At the time of making this it seems like a global script is the best move
#Not sure if it's correct but multiple scripts need these definitions


#Used only within this script
var CROP_FRAMES_FOLDER = "res://scenes/sprite_frames/crops/"
var BUILDINGS_FRAMES_FOLDER = "res://scenes/sprite_frames/buildings/"
var ITEMS_FOLDER = "res://art/items/"
var OUTLINE_ITEMS_FOLDER = "res://art/outline_items/"
var ITEM_FRAMES_FOLDER = "res://scenes/sprite_frames/items/"
var ICON_IMAGE_FOLDER = "res://art/icons/"


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
var MIDDLE_TILES = {"farmland" : {"ID" : Vector2i(3, 3), "phantom_ID" : Vector2i(4,0), "burnt_ID" : Vector2i(3, 4)},
					"sandy_farmland" : {"ID" : Vector2i(4, 3), "phantom_ID" : Vector2i(5,0), "burnt_ID" : Vector2i(4, 4)},
					"swamp_farmland" : {"ID" : Vector2i(5, 3), "phantom_ID" : Vector2i(6,0), "burnt_ID" : Vector2i(5, 4)}}
var BURNT_TILES_MATRIX = {"burnt_farmland": "farmland",
 "burnt_sandy_farmland" : "sandy_farmland",
"burnt_swamp_farmland": "swamp_farmland"} # Name on tile map: key in middle tiles
var gift_tile_layer_exceptions = ["burnt land"]

enum REACTIONS {NONE,ALCOHOL,SHROOMS}
enum GOD_REWARD_TYPES {Item, Placement, Place_Farmland, Destroy_Land, Destroy_Item, Destroy_Animal, Time_, Life, Lose_All_Gold, Unburn_Buildings, Scatter_Items, Restock_Box, Change_Fish_Pool}
var NO_BUILDING_PLACEMENT_TILES = ["burnt land", "water","swamp_water","swamp_water_edge", "lava", "farmland", "sandy_farmland", "swamp_farmland","burnt_farmland","burnt_sandy_farmland","burnt_swamp_farmland"]
var UNBURNABLE_TILES = ["burnt land", "UI", "burnt_farmland","burnt_sandy_farmland","burnt_swamp_farmland"]
var UNBURNABLE_TERRAIN_TILES = ["water","swamp_water","swamp_water_edge","lava"]
var INITIALLY_UNBURNABLE_TILES = ["farmland", "sandy_farmland","swamp_farmland"] # Fire can not be placed directly on these tiles
var CROP_DEF = {"carrot":{"display_name":"Carrot Crop", "stage_growth_duration":2,"total_stages":4,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["carrot","carrot","carrot"],"frames":CROP_FRAMES_FOLDER + "carrot.tres","offset":Vector2.ZERO},
"potato":{"display_name":"Potato Crop", "stage_growth_duration":1.7,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["potato","potato","potato"],"frames":CROP_FRAMES_FOLDER + "potato.tres","offset":Vector2(0,-2)},
"wheat":{"display_name":"Wheat Crop", "stage_growth_duration":1,"total_stages":7,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["wheat","wheat","wheat"],"frames":CROP_FRAMES_FOLDER + "wheat.tres","offset":Vector2(0,-3)},
"barley":{"display_name":"Barley Crop","stage_growth_duration":1,"total_stages":7,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["barley","barley","barley"],"frames":CROP_FRAMES_FOLDER + "barley.tres","offset":Vector2(0,-3)},
"sugarcane":{"sugarcane":"Sugarcane Crop","stage_growth_duration":2,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["sugarcane","sugarcane","sugarcane"],"frames":CROP_FRAMES_FOLDER + "sugarcane.tres","offset":Vector2(0,-10)},
"rice":{"display_name":"Rice Shoots","stage_growth_duration":2,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":0,"resources":["rice","rice"],"frames":CROP_FRAMES_FOLDER + "rice.tres","offset":Vector2(0,0)},
"melon":{"display_name":"Melon Vines","stage_growth_duration":1.3,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":1,"resources":["melon","melon","melon"],"frames":CROP_FRAMES_FOLDER + "melon.tres","offset":Vector2(0,0)},
"pineapple":{"display_name":"Pineapple Plant","stage_growth_duration":1.3,"total_stages":6,"harvest_on_click":true,"pick_on_click":true,"pick_stage_setback":1,"resources":["pineapple","pineapple","pineapple"],"frames":CROP_FRAMES_FOLDER + "pineapple.tres","offset":Vector2(0,-1.5)}
}
var ITEM_DEF = {"carrot":{"display_name":"Carrot","img":"carrot","is_animated":false,"points":10,"place_on":["farmland","sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [0,5]},
"potato":{"display_name":"potato","img":"potato","is_animated":false,"points":10,"place_on":["farmland"],"reaction":REACTIONS.NONE,  "num_offset" : [4,3]},
"plastic_bag":{"display_name":"Plastic Bag","img":"plastic_bag","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [5, -1]},
"rice":{"display_name":"Rice","img":"rice","is_animated":false,"points":10,"place_on":["swamp_water_edge"],"reaction":REACTIONS.NONE,  "num_offset" : [6.5, 0]},
"prickly_pear":{"display_name":"Prickly Pear","img":"prickly_pear","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [3, -1]},
"devil_pepper":{"display_name":"Devil Pepper","img":"devil_pepper","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [6,-3]},
"wheat":{"display_name":"Wheat","img":"wheat","is_animated":false,"points":10,"place_on":["farmland"],"reaction":REACTIONS.NONE, "num_offset" : [4,1]},
"barley":{"display_name":"Barley","img":"barley","is_animated":false,"points":10,"place_on":["farmland"],"reaction":REACTIONS.NONE, "num_offset" : [4,1]},
"sugarcane":{"display_name":"Sugarname","img":"sugarcane","is_animated":false,"points":10,"place_on":["swamp_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [5,2]},
"melon":{"display_name":"Melon","img":"melon","is_animated":false,"points":10,"place_on":["sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
"pineapple":{"display_name":"Pineapple","img":"pineapple","is_animated":false,"points":10,"place_on":["sandy_farmland"],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
"fish":{"display_name":"Fish","img":"fish","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"tropical_fish_1":{"display_name":"Tropical Fish 1","img":"tropical_fish_1","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"tropical_fish_2":{"display_name":"Tropical Fish 2","img":"tropical_fish_2","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"tropical_fish_3":{"display_name":"Tropical Fish 3","img":"tropical_fish_3","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"tentacle":{"display_name":"Tentacle","img":"tentacle","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,4]},
"shrimp":{"display_name":"Shrimp","img":"shrimp","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"cooked_tentacle":{"display_name":"Cooked Tentacle","img":"cooked_tentacle","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,4]},
"cooked_shrimp":{"display_name":"Cooked Shrimp","img":"cooked_shrimp","is_animated":false,"points":10,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [5,4]},
"sugar":{"display_name":"Sugar","img":"sugar","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,3]},
"cooked_rice":{"display_name":"Cooked Rice","img":"cooked_rice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE,  "num_offset" : [8.5,-1]},
"flour":{"display_name":"Flour","img":"flour","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,1]},
"barley_flour":{"display_name":"Barley Flour","img":"barley_flour","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [6,1]},
"bread":{"display_name":"Bread","img":"bread","is_animated":false,"points":30,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8,4]},
"barley_bread":{"display_name":"Barley Bread","img":"barley_bread","is_animated":false,"points":30,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8,4]},
"mushroom":{"display_name":"Mushroom","img":"mushroom","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.SHROOMS, "num_offset" : [4,0]},
"cranberry":{"display_name":"Cranberry","img":"cranberry","is_animated":false,"points":8,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [8.5, 0]},
"cranberry_jam":{"display_name":"Cranberry Jam","img":"cranberry_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
"melon_jam":{"display_name":"Melon Jam","img":"melon_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
"pineapple_jam":{"display_name":"Pineapple Jam","img":"pineapple_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5 , 0]},
"prickly_pear_jam":{"display_name":"Prickly Pear Jam","img":"prickly_pear_jam","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE, "num_offset" : [4.5,0]},
"vodka":{"display_name":"Vodka","img":"vodka","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3,3]},
"rum":{"display_name":"Rum","img":"rum","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [5,2]},
"sake":{"display_name":"Sake","img":"sake","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.ALCOHOL, "num_offset" : [3.5, 2]},
"gold":{"display_name":"Gold","img":"coin","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE},
"pepper_juice":{"display_name":"Pepper Juice","img":"pepper_juice","is_animated":false,"points":20,"place_on":[],"reaction":REACTIONS.NONE}
}
var IMG_EXTENSION = ".png"


# Note that place_on_not_exclusive value does not matter only that they key exists
# Place on means what terrain tiles the building is ristricted to
var BUILDING_DEF = {"fishing_spot":{"display_name":"Fishing Spot","icon_img" : "fishing_spot","output_items":["fish"],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "fishing_spot.tres", "offset":[0,0],"bounce":false},
	"well":{"display_name":"Well","icon_img":"well" ,"output_items":["gold"],"items_to_start_timer":0,"input_items":{},"total_stages":1,"stage_to_harvest":1,"time_per_stage":4,"destroy_on_harvest":false,"stage_loss_on_harvest": 1, "frames": BUILDINGS_FRAMES_FOLDER + "well.tres", "offset":[0,-1],"bounce":true, "has_burnt_state" : true},
	"god_gift":{"display_name":"Gift","output_items":[],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "gift.tres", "offset":[0,-3], "bounce":false},
	"restock_box":{"display_name":"Restock Box","output_items":[],"items_to_start_timer":0,"input_items":{},"total_stages":0,"stage_to_harvest":0,"time_per_stage":0,"destroy_on_harvest":true,"stage_loss_on_harvest": 0, "frames": BUILDINGS_FRAMES_FOLDER + "restock_box.tres", "offset":[0,-3], "bounce":false},
	"barrel":{"display_name":"Barrel","icon_img":"barrel","output_items":[],"items_to_start_timer":1,"input_items":{"potato" : "vodka", "sugarcane":"rum","rice":"sake"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "barrel.tres", "offset": [0,0], "extra_tiles": [],"bounce":true, "has_burnt_state" : true},
	"pot":{"display_name":"Pot","icon_img":"pot","output_items":[],"items_to_start_timer":1,"input_items":{"prickly_pear":"prickly_pear_jam","melon":"melon_jam","pineapple":"pineapple_jam","cranberry":"cranberry_jam"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "pot.tres", "offset": [0,-1], "extra_tiles": [],"bounce":true, "has_burnt_state" : true},
	"oven":{"display_name":"Oven","icon_img":"oven","output_items":[],"items_to_start_timer":1,"input_items":{"flour" : "bread", "rice" : "cooked_rice", "barley_flour" : "barley_bread", "tentacle" : "cooked_tentacle", "shrimp":"cooked_shrimp"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "oven.tres", "offset": [0,0], "extra_tiles": [], "bounce":true, "has_burnt_state" : true},
	"mill":{"display_name":"Mill","icon_img":"hand_mill","output_items":[],"items_to_start_timer":1,"input_items":{"wheat" : "flour", "sugarcane" : "sugar", "barley" : "barley_flour"},"total_stages":2,"stage_to_harvest":2,"time_per_stage":3,"destroy_on_harvest":false, "stage_loss_on_harvest": 2,"frames": BUILDINGS_FRAMES_FOLDER + "mill.tres", "offset": [0,-0.5], "extra_tiles": [],"bounce":true, "has_burnt_state" : true},
	"mushroom_patch":{"display_name":"Mushroom Patch","icon_img":"mushroom_patch","output_items":["mushroom"],"items_to_start_timer":0,"input_items":{},"total_stages":3,"stage_to_harvest":1,"time_per_stage":5,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["grass", "swamp_grass"], "frames": BUILDINGS_FRAMES_FOLDER + "mushroom_patch.tres", "offset": [0,0], "extra_tiles": [], "bounce":false},
	"devil_vine":{"display_name":"Devil Vine","output_items":["devil_pepper"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":4,"time_per_stage":1,"destroy_on_harvest":false, "stage_loss_on_harvest": 4, "place_on":["sand"],"frames": BUILDINGS_FRAMES_FOLDER + "devil_vine.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	"prickly_pear_cactus":{"display_name":"Prickly Pear Cactus","icon_img":"prickly_pear_cactus","output_items":["prickly_pear"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":1,"time_per_stage":4,"destroy_on_harvest":false, "stage_loss_on_harvest": 1, "place_on":["sand"], "frames": BUILDINGS_FRAMES_FOLDER + "prickly_pear_cactus.tres", "offset": [0,-1], "extra_tiles": [], "bounce":false},
	"cranberry_bush":{"display_name":"Cranberry Bush","icon_img":"cranberry_bush","output_items":["cranberry", "cranberry", "cranberry"],"items_to_start_timer":0,"input_items":{},"total_stages":4,"stage_to_harvest":4,"time_per_stage":2,"destroy_on_harvest":false, "stage_loss_on_harvest": 3, "place_on":["swamp_water_edge"],"no_building_placement_override" : ["swamp_water_edge"], "frames": BUILDINGS_FRAMES_FOLDER + "cranberry_bush.tres", "offset": [0,0], "extra_tiles": [], "bounce":true},
	"farmland":{"display_name": "Farmland","icon_img":"farmland","place_on": ["grass"]},
	"sandy_farmland":{"display_name": "Sandy Farmland","icon_img":"sandy_farmland","place_on": ["sand"]},
	"swamp_farmland":{"display_name": "Swamp Farmland","icon_img":"swamp_farmland","place_on": ["swamp_grass"]}
}

# For any recipe elements that aren't listed in buildings or items
var EXTRA_RECIPE_IMGS = {"swamp_water_edge" : "swamp_water_edge"}

var UNLOCK_MAP = [[["barrel", "sugarcane"],["rum"]],
				[["barrel", "potato"],["vodka"]],
				[["barrel", "rice"],["sake"]],
				[["pot", "prickly_pear"],["prickly_pear_jam"]],
				[["pot", "cranberry"],["cranberry_jam"]],
				[["pot", "melon"],["melon_jam"]],
				[["pot", "pineapple"],["pineapple_jam"]],
				[["mill", "sugarcane"],["sugar"]],
				[["mill", "barley"],["barley_flour"]],
				[["mill", "wheat"],["flour"]],
				[["mill", "oven", "barley_flower"],["barley_bread"]],
				[["mill", "oven", "wheat"],["bread"]],
				[["oven","rice"],["cooked_rice"]],
				[["oven","tentacle"],["cooked_tentacle"]],
				[["oven","shrimp"],["cooked_shrimp"]]]

var DIFFICULTY_TIMES = [27, 23, 19, 16]

var LEVEL_KEYS = ["grass", "sand", "swamp"] # Turns Level numbers into a key for level_def
var LEVELDEF = {"grass" : {"round_time" : DIFFICULTY_TIMES, "total_rounds" : [10,11,12,14]},
"sand" : {"round_time" : DIFFICULTY_TIMES, "total_rounds" : [10,11,12,14]},
"swamp" : {"round_time" : DIFFICULTY_TIMES, "total_rounds" : [10,11,12,14]}
} # Describe round times and total round number using level and difficulty


var DEFAULT_DIFFICULTY : int = 1 # Difficulty shown in level popup
var DIFFICULTY_NAMES = ["Easy", "Normal", "Hard", "Insane"] # Displayed in level selector
var LEVEL_DISPlAY_NAMES = ["Grass Land", "Beach", "Swamp"]

var ANIMAL_DEF = null

var MAX_LIVES = 3
var CAN_BUNDLE_BUNDLES : bool = true

var LAST_CROP_ITEM_DIALOG = ["Hey! You need to plant that to grow more!",5]
var EXTRA_ITEM_FED_DIALOG = ["Don't sacrifice more then you need to",5]
var BUILDING_PHANTOM_MODULATION : Color = Color(1,1,1,0.5)
var ITEM_DIM_COLOUR : Color = Color(1,1,1,0)


var FLYING_COIN_END_POS = Vector2(-152.0, -41)
var ROUND_COMPLETION_GOLD = 0
var ROUND_TIME = 23
var ROUND_END_AFTER_REQUIRMENTS_MET : bool = false # If true then round will end imediatly after requirments are met
var MAX_FISH = 7

var PUSH_ITEM_SPEED = 10
var PUSH_ACCEL = 12
var PUSH_ITEM_DEST = Vector2.ZERO

var SCATTER_ITEM_DIST = [40, 100]
var SCATTER_ITEM_ROTATION = [-25,25]
var SCATTER_ITEM_TIME = [0.6, 1.2]

enum TOOLTIP_TYPES {ITEM, BUILDING, FARMLAND, CROP}
enum TOOLTIP_HOVER_TYPES {ITEM, TILE, SACRIFICE}
var HOVER_TIME_TOOLTIP = 0.5

var ITEM_POLYGONS = {"carrot":[[2.5, 5.0], [-7.5, 10.0], [-10.5, 10.0], [-10.5, 7.0], [-0.5, -3.5], [-1.5, -5.5], [1.5, -9.5], [8.5, -9.0], [10.5, -5.5], [9.5, -1.0], [3.5, 0.5]],
"potato": [[0.0, 5.0], [4.5, 5.5], [7.5, 2.5], [7.5, -0.5], [1.5, -5.5], [-5.5, -5.5], [-7.5, -4.0], [-7.5, 0.5], [-4.5, 3.5]],
"wheat": [[4.0, -7.0], [-1.5, -8.0], [-6.0, -5.0], [-6.0, -2.0], [-4.0, 3.0], [-4.0, 7.0], [-3.0, 8.0], [1.5, 8.0], [3.0, 7.0], [3.0, 3.0], [6.0, -3.5]],
"sugarcane":[[4.5, 0.5], [1.5, 9.5], [-0.5, 11.5], [-3.5, 11.5], [-5.5, 9.5], [-5.5, 5.5], [-1.5, -9.5], [0.5, -11.5], [3.5, -11.5], [5.5, -9.5], [5.5, -4.5]],
"fish": [[-9.0, 2.0], [-6.0, 5.0], [-1.0, 5.0], [3.0, 3.0], [5.0, 2.0], [6.0, 4.0], [9.0, 4.0], [9.0, 2.0], [7.0, 0.5], [9.0, -1.0], [9.0, -3.0], [6.0, -3.0], [4.0, -2.0], [-1.0, -5.0], [-6.0, -5.0], [-9.0, -2.0]],
"shrimp" : [[-2.0, 7.0], [-6.0, 6.0], [-10.0, 1.0], [-10.0, -2.0], [-6.0, -6.0], [-3.0, -7.0], [2.0, -7.0], [10.0, -2.0], [8.0, 1.0], [6.0, 4.0], [2.0, 4.0], [2.0, 7.0]],
"cooked_shrimp" : [[-2.0, 7.0], [-6.0, 6.0], [-10.0, 1.0], [-10.0, -2.0], [-6.0, -6.0], [-3.0, -7.0], [2.0, -7.0], [10.0, -2.0], [8.0, 1.0], [6.0, 4.0], [2.0, 4.0], [2.0, 7.0]],
"tentacle":[[-3.0, 9.5], [-5.0, 7.5], [-7.0, 4.5], [-7.0, 0.5], [-5.0, -2.5], [0.0, -7.5], [4.0, -9.5], [7.0, -9.5], [7.0, -6.5], [6.0, -4.5], [4.0, -4.5], [4.0, -2.5], [2.0, 1.0], [4.0, 5.0], [6.0, 7.0], [4.0, 9.5]],
"cooked_tentacle": [[-3.0, 9.5], [-5.0, 7.5], [-7.0, 4.5], [-7.0, 0.5], [-5.0, -2.5], [0.0, -7.5], [4.0, -9.5], [7.0, -9.5], [7.0, -6.5], [6.0, -4.5], [4.0, -4.5], [4.0, -2.5], [2.0, 1.0], [4.0, 5.0], [6.0, 7.0], [4.0, 9.5]],
"tropical_fish1":[[-4.5, 6.5], [-6.0, 4.5], [-7.5, 4.5], [-10.5, 1.5], [-10.5, -0.5], [-6.5, -4.5], [-3.5, -6.5], [-1.5, -6.5], [3.5, -5.5], [5.5, -3.5], [8.5, -2.5], [10.5, 0.0], [10.5, 1.5], [8.5, 3.5], [7.0, 3.5], [5.5, 2.5], [4.5, 5.5], [3.5, 6.5], [2.0, 6.5], [0.0, 4.5], [-1.5, 6.5]],
"tropical_fish2":[[-4.5, 6.5], [-6.0, 4.5], [-7.5, 4.5], [-10.5, 1.5], [-10.5, -0.5], [-6.5, -4.5], [-3.5, -6.5], [-1.5, -6.5], [3.5, -5.5], [5.5, -3.5], [8.5, -2.5], [10.5, 0.0], [10.5, 1.5], [8.5, 3.5], [7.0, 3.5], [5.5, 2.5], [4.5, 5.5], [3.5, 6.5], [2.0, 6.5], [0.0, 4.5], [-1.5, 6.5]],
"trpical_fish3":[[-4.5, 6.5], [-6.0, 4.5], [-7.5, 4.5], [-10.5, 1.5], [-10.5, -0.5], [-6.5, -4.5], [-3.5, -6.5], [-1.5, -6.5], [3.5, -5.5], [5.5, -3.5], [8.5, -2.5], [10.5, 0.0], [10.5, 1.5], [8.5, 3.5], [7.0, 3.5], [5.5, 2.5], [4.5, 5.5], [3.5, 6.5], [2.0, 6.5], [0.0, 4.5], [-1.5, 6.5]],
"flour": [[-6.0, -5.0], [-6.0, 9.0], [6.0, 9.0], [6.0, -5.0], [2.0, -9.0], [-0.5, -9.0]],
"barley_flour": [[-6.0, -5.0], [-6.0, 9.0], [6.0, 9.0], [6.0, -5.0], [2.0, -9.0], [-0.5, -9.0]],
"bread":[[-7.0, -7.0], [-10.0, -4.0], [-10.0, 0.0], [-6.0, 3.0], [5.0, 7.5], [10.0, 3.0], [10.0, 0.0], [4.0, -3.5]],
"barley_bread":[[-2.5, 5.0], [-9.5, 5.0], [-10.5, 4.0], [-10.5, 1.5], [-9.5, -1.0], [-6.5, -4.0], [-2.5, -5.0], [5.5, -5.0], [10.5, -1.0], [10.5, 1.0], [7.5, 3.0]],
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
"pineapple_jam" : [[-5.0, -6.5], [-4.0, -7.5], [4.0, -7.5], [5.0, -6.5], [5.0, 5.5], [3.0, 7.5], [-3.0, 7.5], [-5.0, 5.5]],
"cranberry" : [[-3.0, 7.0], [-6.0, 4.0], [-6.0, 1.5], [-6.0, 0.0], [-8.0, -3.0], [-8.0, -5.0], [-5.0, -4.0], [-6.0, -8.0], [-2.0, -7.0], [-0.5, -5.0], [3.0, -6.0], [6.0, -2.5], [6.0, 1.0], [8.0, 2.0], [8.0, 5.0], [5.0, 8.0], [2.0, 8.0], [1.0, 7.0], [0.0, 7.0]],
"melon" : [[7.0, -7.0], [10.0, -6.0], [10.0, 1.0], [3.0, 7.0], [-4.0, 7.0], [-10.0, 3.0], [-10.0, 1.0]],
"pineapple" : [[3.0, 13.0], [-3.0, 13.0], [-5.0, 11.0], [-5.0, 1.0], [-3.0, -1.0], [-2.0, -1.0], [-5.0, -3.0], [-6.0, -5.0], [-5.0, -5.0], [-5.0, -8.0], [-3.0, -8.0], [-4.0, -13.0], [-1.0, -13.0], [1.0, -10.0], [2.0, -12.0], [4.0, -12.0], [5.0, -8.0], [6.0, -4.0], [3.0, -1.0], [5.0, 1.0], [5.0, 11.0]],
"rice" : [[6.0, -5.5], [7.0, -3.5], [4.0, 2.5], [7.0, 4.5], [7.0, 7.5], [4.0, 7.5], [0.0, 3.5], [0.0, 4.5], [0.0, 7.5], [-3.0, 7.5], [-7.0, 3.5], [-7.0, 0.5], [-4.0, -1.5], [-6.0, -4.5], [-6.0, -7.5], [-3.0, -7.5], [1.0, -3.5], [4.0, -5.5]],
"cooked_rice" : [[-3.5, 6.5], [-7.5, 3.5], [-8.5, 0.5], [-3.5, -5.5], [1.0, -6.5], [9.0, 0.5], [7.5, 3.5], [3.5, 6.5]]
}
