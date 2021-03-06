extends PopupMenu

var upgrades
var tooltip

var tower_sell_value 

onready var fire_rate_desc = $MarginContainer/MainContainer/StatsContainer/FireRateContainer/FireRateDesc
onready var fire_rate_btn = $MarginContainer/MainContainer/StatsContainer/FireRateContainer/FireRateBtn

onready var fire_range_desc = $MarginContainer/MainContainer/StatsContainer/FireRangeContainer/FireRangeDesc
onready var fire_range_btn = $MarginContainer/MainContainer/StatsContainer/FireRangeContainer/FireRangeBtn

onready var projectile_desc = $MarginContainer/MainContainer/StatsContainer/ProjectileContainer/ProjectileDesc
onready var projectile_btn = $MarginContainer/MainContainer/StatsContainer/ProjectileContainer/ProjectileBtn

onready var fire_mode_1_button = $MarginContainer/MainContainer/SettingsContainer/FireModeContainer/FireMode1Btn
onready var fire_mode_2_button = $MarginContainer/MainContainer/SettingsContainer/FireModeContainer/FireMode2Btn

onready var sell_tower_button = $MarginContainer/MainContainer/SettingsContainer/SellTowerBtn

signal closed


func _ready():
	upgrades = get_parent().get_node("Upgrades")
	create_tooltips()
	sync_descriptions()
	connect("closed", get_parent(), "_on_TowerMenu_closed")


func create_tooltips():
	var upgrade_buttons = [fire_rate_btn, fire_range_btn, projectile_btn]
	for btn in upgrade_buttons:
		tooltip = load("res://Scenes/TooltipUpgradeCost.tscn").instance()
		tooltip.hide()
		tooltip.rect_position.x = btn.rect_position.x - 80
		btn.add_child(tooltip)


func sync_descriptions():
	sync_fire_rate_desc(upgrades.fire_rate_lvl + 1)
	sync_fire_rate_cost(upgrades.fire_rate_upgrade_cost)
	sync_fire_range_desc(upgrades.fire_range_lvl + 1)
	sync_fire_range_cost(upgrades.fire_range_upgrade_cost)
	sync_projectile_desc(upgrades.projectile_lvl + 1)
	sync_projectile_cost(upgrades.projectile_upgrade_cost)


func sync_fire_rate_desc(fire_rate_lvl):
	var projectiles_per_s = 1/upgrades.fire_rate_value
	if "DoubleTurretTower" in get_parent().name:
		projectiles_per_s = 2/upgrades.fire_rate_value
	
	fire_rate_desc.text = "Fire Rate (Lvl." + str(fire_rate_lvl) + ") - Projectiles/s: " + str(stepify(projectiles_per_s, 0.01)) 


func sync_fire_rate_cost(fire_rate_cost):
	var upgrade_cost_label = fire_rate_btn.get_node("TooltipUpgradeCost/CenterContainer/TooltipPanel/CostLabel")
	upgrade_cost_label.text = "Cost: " + str(fire_rate_cost)


func sync_fire_range_desc(fire_range_lvl):
	fire_range_desc.text = "Fire Range (Lvl." + str(fire_range_lvl) + ") - " + str(upgrades.fire_range_value) 


func sync_fire_range_cost(fire_range_cost):
	var upgrade_cost_label = fire_range_btn.get_node("TooltipUpgradeCost/CenterContainer/TooltipPanel/CostLabel")
	upgrade_cost_label.text = "Cost: " + str(fire_range_cost)


func sync_projectile_desc(projectile_lvl):
	projectile_desc.text = "Projectile (Lvl." + str(projectile_lvl) + ")"


func sync_projectile_cost(projectile_cost):
	var upgrade_cost_label = projectile_btn.get_node("TooltipUpgradeCost/CenterContainer/TooltipPanel/CostLabel")
	upgrade_cost_label.text = "Cost: " + str(projectile_cost)


func set_sell_value(value):
	tower_sell_value = value / 2
	sell_tower_button.text = "Sell Tower for " + str(tower_sell_value)


func _on_FireRateBtn_pressed():
	upgrades.level_up("FireRate")
	sync_fire_rate_desc(upgrades.fire_rate_lvl + 1)
	sync_fire_rate_cost(upgrades.fire_rate_upgrade_cost)


func _on_FireRangeBtn_pressed():
	upgrades.level_up("FireRange")
	sync_fire_range_desc(upgrades.fire_range_lvl + 1)
	sync_fire_range_cost(upgrades.fire_range_upgrade_cost)


func _on_ProjectileBtn_pressed():
	upgrades.level_up("Projectile")
	sync_projectile_desc(upgrades.projectile_lvl + 1)
	sync_projectile_cost(upgrades.projectile_upgrade_cost)


func _on_FireMode1Btn_toggled(button_pressed):
	if button_pressed:
		get_parent().set_fire_mode(1)
		fire_mode_2_button.pressed = false


func _on_FireMode2Btn_toggled(button_pressed):
	if button_pressed:
		get_parent().set_fire_mode(2)
		fire_mode_1_button.pressed = false


func _on_CloseButton_pressed():
	hide()
	emit_signal("closed")


func _on_SellTowerBtn_pressed():
	get_tree().call_group("Game", "add_cash", tower_sell_value)
	get_parent().queue_free()


func _on_FireRateBtn_mouse_entered():
	fire_rate_btn.get_node("TooltipUpgradeCost").show_tooltip(true)


func _on_FireRateBtn_mouse_exited():
	fire_rate_btn.get_node("TooltipUpgradeCost").show_tooltip(false)


func _on_FireRangeBtn_mouse_entered():
	fire_range_btn.get_node("TooltipUpgradeCost").show_tooltip(true)


func _on_FireRangeBtn_mouse_exited():
	fire_range_btn.get_node("TooltipUpgradeCost").show_tooltip(false)


func _on_ProjectileBtn_mouse_entered():
	projectile_btn.get_node("TooltipUpgradeCost").show_tooltip(true)


func _on_ProjectileBtn_mouse_exited():
	projectile_btn.get_node("TooltipUpgradeCost").show_tooltip(false)

