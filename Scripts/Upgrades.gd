extends Node2D

# need a better solution for this whole script but it works fine for now 
# but is not that scalable.

# the plan is to make the upgrade system more like in the bloons series
# with different paths you can take and towers changing appearance i.e.
# the bomber tower will look different with every upgrade and will
# eventually shoot rockets. still need an idea on how to implement this.
# the tower menu should also be more adaptable (right now it's pretty hard-coded)
# or should be completely replaced.

var parent_tower_string

var offensive_tower
var defensive_tower

var fire_rate_value : float = 0
var fire_rate_lvl : int = 0
var fire_rate_upgrade_cost = 0

var fire_range_value : int = 0 
var fire_range_lvl : int = 0
var fire_range_upgrade_cost = 0

var projectile = null
var projectile_lvl : int = 0
var projectile_upgrade_cost = 0

var single_turret_projectile_1 = load("res://Scenes/Projectiles/SingleTurretProjectile1.tscn")
var single_turret_projectile_2 = load("res://Scenes/Projectiles/SingleTurretProjectile2.tscn")
var single_turret_projectile_3 = load("res://Scenes/Projectiles/SingleTurretProjectile3.tscn")
var single_turret_projectile_4 = load("res://Scenes/Projectiles/SingleTurretProjectile4.tscn")

var light_bomber_projectile_1 = load("res://Scenes/Projectiles/LightBomberProjectile1.tscn")
var light_bomber_projectile_2 = load("res://Scenes/Projectiles/LightBomberProjectile2.tscn")
var light_bomber_projectile_3 = load("res://Scenes/Projectiles/LightBomberProjectile3.tscn")

var sniper_projectile_1 = load("res://Scenes/Projectiles/SniperProjectile1.tscn")
var sniper_projectile_2 = load("res://Scenes/Projectiles/SniperProjectile2.tscn")
var sniper_projectile_3 = load("res://Scenes/Projectiles/SniperProjectile3.tscn")
var sniper_projectile_4 = load("res://Scenes/Projectiles/SniperProjectile4.tscn")

var double_turret_projectile_1 = load("res://Scenes/Projectiles/DoubleTurretProjectile1.tscn")
var double_turret_projectile_2 = load("res://Scenes/Projectiles/DoubleTurretProjectile2.tscn")
var double_turret_projectile_3 = load("res://Scenes/Projectiles/DoubleTurretProjectile3.tscn")


var upgrades = {"single_turret_tower":
	{
	"fire_rate": 
		{
			"levels": [0, 1, 2, 3, 4, 5, 6, 7],
			"rate_of_fire": [0.33, 0.3, 0.25, 0.2, 0.15, 0.1, 0.075, 0.05],
			"cost": [25, 50, 150, 250, 400, 750, "---"]
		},
	"fire_range":
		{
			"levels": [0, 1, 2, 3, 4, 5],
			"range_of_fire": [200, 225, 250, 300, 375, 450],
			"cost": [45, 90, 180, 325, 650, "---"]
		},
	"projectiles":
		{
			"levels": [0, 1, 2, 3],
			"projectile": [single_turret_projectile_1, single_turret_projectile_2, single_turret_projectile_3, single_turret_projectile_4],
			"cost": [75, 200, 400, "---"]
		}
	},
	"light_bomber_tower":
	{
	"fire_rate": 
		{
			"levels": [0, 1, 2, 3, 4],
			"rate_of_fire": [1.7, 1.5, 1.3, 1.1, 0.8],
			"cost": [40, 80, 160, 350, "---"]
		},
	"fire_range":
		{
			"levels": [0, 1, 2, 3, 4],
			"range_of_fire": [275, 300, 350, 425, 525],
			"cost": [50, 120, 250, 450, "---"]
		},
	"projectiles":
		{
			"levels": [0, 1, 2],
			"projectile": [light_bomber_projectile_1, light_bomber_projectile_2, light_bomber_projectile_3],
			"cost": [200, 500, "---"]
		}
	},
	"sniper_tower":
	{
	"fire_rate":
		{
			"levels": [0, 1, 2, 3, 4, 5],
			"rate_of_fire": [3, 2.7, 2.4, 2.1, 1.6, 1.25],
			"cost": [30, 60, 90, 175, 350, "---"]
		},
		"fire_range":
		{
			"levels": [0, 1, 2, 3],
			"range_of_fire": [650, 700, 750, 900],
			"cost": [50, 150, 400, "---"]
		},
		"projectiles":
		{
			"levels": [0, 1, 2, 3],
			"projectile": [sniper_projectile_1, sniper_projectile_2, sniper_projectile_3, sniper_projectile_4],
			"cost": [150, 350, 750, "---"]
		}
	},
	"double_turret_tower":
	{
	"fire_rate":
		{
			"levels": [0, 1, 2, 3, 4],
			"rate_of_fire": [0.7, 0.6, 0.5, 0.35, 0.2],
			"cost": [80, 160, 400, 725, "---"]
		},
		"fire_range":
		{
			"levels": [0, 1, 2, 3],
			"range_of_fire": [300, 350, 400, 500],
			"cost": [50, 100, 250, "---"]
		},
		"projectiles":
		{
			"levels": [0, 1, 2],
			"projectile": [double_turret_projectile_1, double_turret_projectile_2, double_turret_projectile_3],
			"cost": [250, 600, "---"]
		}
	}
}


func _ready():
	setup_vars()


func setup_vars():
	if "SingleTurretTower" in get_parent().name:
		parent_tower_string = "single_turret_tower"
		offensive_tower = true
	elif "LightBomberTower" in get_parent().name:
		parent_tower_string = "light_bomber_tower"
		offensive_tower = true
	elif "SniperTower" in get_parent().name:
		parent_tower_string = "sniper_tower"
		offensive_tower = true
	elif "DoubleTurretTower" in get_parent().name:
		parent_tower_string = "double_turret_tower"
		offensive_tower = true
	
	if offensive_tower:
		fire_rate_value = upgrades[parent_tower_string]["fire_rate"]["rate_of_fire"][0]
		fire_rate_lvl = upgrades[parent_tower_string]["fire_rate"]["levels"][0]
		fire_rate_upgrade_cost = upgrades[parent_tower_string]["fire_rate"]["cost"][0]
		fire_range_value = upgrades[parent_tower_string]["fire_range"]["range_of_fire"][0]
		fire_range_lvl = upgrades[parent_tower_string]["fire_range"]["levels"][0]
		fire_range_upgrade_cost = upgrades[parent_tower_string]["fire_range"]["cost"][0]
		projectile = upgrades[parent_tower_string]["projectiles"]["projectile"][0]
		projectile_lvl = upgrades[parent_tower_string]["projectiles"]["levels"][0]
		projectile_upgrade_cost = upgrades[parent_tower_string]["projectiles"]["cost"][0]


func set_fire_rate(tower_string, num):
	fire_rate_value = upgrades[tower_string]["fire_rate"]["rate_of_fire"][num]
	fire_rate_upgrade_cost = upgrades[tower_string]["fire_rate"]["cost"][num]


func set_fire_range(tower_string, num):
	fire_range_value = upgrades[tower_string]["fire_range"]["range_of_fire"][num]
	fire_range_upgrade_cost = upgrades[tower_string]["fire_range"]["cost"][num]


func set_projectile(tower_string, num):
	projectile = upgrades[tower_string]["projectiles"]["projectile"][num]
	projectile_upgrade_cost = upgrades[tower_string]["projectiles"]["cost"][num]


func level_up(stat):
	if stat == "FireRate":
		if typeof(fire_rate_upgrade_cost) == TYPE_INT and Global.cash >= fire_rate_upgrade_cost:
			var max_lvl = upgrades[parent_tower_string]["fire_rate"]["levels"].size()
			if fire_rate_lvl < max_lvl:
				get_tree().call_group("Game", "subtract_cash", fire_rate_upgrade_cost)
				fire_rate_lvl += 1
				set_fire_rate(parent_tower_string, fire_rate_lvl)
				get_parent().set_stats(true)
	elif stat == "FireRange":
		if typeof(fire_range_upgrade_cost) == TYPE_INT and Global.cash >= fire_range_upgrade_cost:
			var max_lvl = upgrades[parent_tower_string]["fire_range"]["levels"].size()
			if fire_range_lvl < max_lvl:
				get_tree().call_group("Game", "subtract_cash", fire_range_upgrade_cost)
				fire_range_lvl += 1
				set_fire_range(parent_tower_string, fire_range_lvl)
				get_parent().set_stats(true)
	elif stat == "Projectile":
		if typeof(projectile_upgrade_cost) == TYPE_INT and Global.cash >= projectile_upgrade_cost:
			var max_lvl = upgrades[parent_tower_string]["projectiles"]["levels"].size()
			if projectile_lvl < max_lvl:
				get_tree().call_group("Game", "subtract_cash", projectile_upgrade_cost)
				projectile_lvl += 1
				set_projectile(parent_tower_string, projectile_lvl)
				get_parent().set_stats(true)

