extends Node

# Global scene variables

var current_scene_name

# Global game variables

var cash : int = 300
var wave : int = 0
var lives : int = 20

# Global settings

var animations = true
var screen_shakes = true
var healthbar_enabled = true
var damage_numbers_enabled = true


func reset():
	cash = 300
	wave = 0
	lives = 20

