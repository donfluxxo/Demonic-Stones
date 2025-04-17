extends Control


@export var health : float
@export var attack_cooldown_left : float 


var max_health : float
var attack_cooldown_max : float


@onready var attack_cooldown_bar : ProgressBar = $AttackCooldownBar#
@onready var player_healthbar : ProgressBar = $PlayerHealthBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_healthbar.value = health
	if attack_cooldown_left > 0:
		attack_cooldown_bar.value = attack_cooldown_left
	else:
		attack_cooldown_bar.value = attack_cooldown_max
