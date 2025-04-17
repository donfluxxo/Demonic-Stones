class_name Player
extends Character


signal player_died


@export var player_actions : PlayerActions
@export var limbo_hsm : LimboHSM

@export var max_health: float = 100


var blackboard : Blackboard
var character : Character = self

var is_dead : bool = false
var actions_locked : bool = false

var mobs_killed : int


@onready var hud : Control = $HUD
@onready var attack_timer : Timer = $LimboHSM/AttackState/AttackTimer
@onready var kill_label : Label = $HUD/MobKillLabel

@onready var health : float = max_health
@onready var attack_cooldown_max : float = attack_timer.get_wait_time()


func _ready() -> void:
	hud.max_health = max_health
	hud.attack_cooldown_max = attack_cooldown_max
	blackboard = limbo_hsm.blackboard
	blackboard.bind_var_to_property(BBNames.actions_locked_var, self, "actions_locked",true)


func _process(delta: float) -> void:
	update_hud()


func update_hud() -> void:
	hud.health = health
	var time_left : float = attack_timer.get_time_left()
	hud.attack_cooldown_left = time_left
	kill_label.text = "Mobs killed: %s" %mobs_killed


func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("mob_attack"):
		_manage_hit(area)


func _manage_hit(object : Node2D) -> void:
	health -= object.get_damage()
	#healthlabel.text = "%f" %health
	#shake()
	if health <= 0 and !is_dead:
		health = 0
		is_dead = true
		actions_locked = true
		player_died.emit(global_position, mobs_killed)
		
		# test for github repo functionality
