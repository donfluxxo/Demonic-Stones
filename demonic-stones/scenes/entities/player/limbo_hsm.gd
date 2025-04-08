extends LimboHSM


@export var character : CharacterBody2D
@export var states : Dictionary[String, LimboState]


func _ready() -> void:
	_binding_setup()
	initialize(character)
	set_active(true)


# Adding transitions betweens the states
func _binding_setup():
	add_transition(states["Idle"], states["Move"], "moving")
	add_transition(states["Move"], states["Idle"], "stopped")
	add_transition(states["Move"], states["Attack"], "attacking")
	add_transition(states["Attack"], states["Move"], "moving")
	add_transition(states["Idle"], states["Attack"], "attacking")
	add_transition(states["Attack"], states["Idle"], "stopped")
