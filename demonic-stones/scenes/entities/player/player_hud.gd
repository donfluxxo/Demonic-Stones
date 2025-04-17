extends Control


@export var health : float
@onready var player_healthbar : ProgressBar = $PlayerHealthBar
var max_health : float

@export var attack_cooldown_left : float 
@onready var attack_cooldown_bar : ProgressBar = $AttackCooldownBar
var attack_cooldown : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_healthbar.value = health
	if attack_cooldown_left > 0:
		attack_cooldown_bar.value = attack_cooldown_left
	else:
		attack_cooldown_bar.value = attack_cooldown
