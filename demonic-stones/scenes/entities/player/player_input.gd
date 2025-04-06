class_name PlayerInput
extends Node

@export var player_actions : PlayerActions
@export var limbo_hsm : LimboHSM

var blackboard : Blackboard
var input_direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blackboard = limbo_hsm.blackboard
	blackboard.bind_var_to_property(BBNames.direction_var, self ,"input_direction", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.move_up, player_actions.move_down)
