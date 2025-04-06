extends LimboHSM

@export var character : CharacterBody2D
@export var states : Dictionary[String, LimboState]


func _ready() -> void:
	_binding_setup()
	initialize(character)
	set_active(true)

func _binding_setup():
	add_transition(states["Idle"], states["Move"], "moving")
	add_transition(states["Move"], states["Idle"], "stopped")
