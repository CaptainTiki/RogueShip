extends CanvasLayer
class_name UI

@onready var hull_bar: ProgressBar = $VBoxContainer/HullBar
@onready var hull_label: Label = $VBoxContainer/HullBar/HullLabel
@onready var shield_bar: ProgressBar = $VBoxContainer/ShieldBar
@onready var shield_label: Label = $VBoxContainer/ShieldBar/ShieldLabel
@onready var power_bar: ProgressBar = $VBoxContainer/PowerBar
@onready var power_label: Label = $VBoxContainer/PowerBar/PowerLabel

func _process(_delta: float) -> void:
	if not PlayerData.ship_instance:
		return
	var ship = PlayerData.ship_instance as PlayerShip
	# Update hull
	hull_bar.max_value = ship.stats.max_hull
	hull_bar.value = ship.current_hull
	hull_label.text = "Hull: %d/%d" % [ship.current_hull, ship.stats.max_hull]
	
	# Update shields
	shield_bar.max_value = ship.stats.max_shield
	shield_bar.value = ship.current_shield
	shield_label.text = "Shields: %d/%d" % [ship.current_shield, ship.stats.max_shield]
	
	# Update power
	power_bar.max_value = ship.stats.max_power
	power_bar.value = ship.current_power
	power_label.text = "Power: %d/%d" % [ship.current_power, ship.stats.max_power]
