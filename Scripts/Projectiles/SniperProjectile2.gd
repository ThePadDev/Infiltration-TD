extends "res://Scripts/Projectiles/SniperProjectile.gd"


func _ready():
	randomize()
	damage = stepify(rand_range(19, 22), 0.01)
	speed = 800

