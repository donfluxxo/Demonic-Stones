class_name PlayerInput
extends Node

@export var player_actions : PlayerActions
@export var limbo_hsm : LimboHSM

var blackboard : Blackboard
var input_direction : Vector2
var attacking : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initiate blackboard
	blackboard = limbo_hsm.blackboard
	#Bind the input direction to the corresponding blackboard var
	blackboard.bind_var_to_property(BBNames.direction_var, self ,"input_direction", true)
	#Bing the attack input to the corresponding blackboard var
	blackboard.bind_var_to_property(BBNames.attack_var, self, "attacking",true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Getting the input direction from Player
	input_direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.move_up, player_actions.move_down)
	#Checking if Player wants to attack
	if(Input.is_action_just_pressed(player_actions.attack)):
		prints("ATTACKING")
		attacking = true
	if(Input.is_action_just_released(player_actions.attack)):
		attacking = false
		prints("STOPPED ATTACKING")
