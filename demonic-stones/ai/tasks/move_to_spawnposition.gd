@tool
extends BTAction


@export var dir_var : StringName = &"dir"

@export var tolerance : int = 30


var _waypoint: Vector2


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "MoveToSpawnposition" + LimboUtility.decorate_var(agent.spawn_point)


func _enter() -> void:
	_select_new_waypoint(agent.spawn_point)


func _tick(delta : float) -> Status:
	if agent.global_position.distance_to(agent.spawn_point) < tolerance:
		agent.move(Vector2.ZERO)
		return SUCCESS

	if agent.global_position.distance_to(_waypoint) < tolerance:
		_select_new_waypoint(agent.spawn_point)

	var desired_velocity: Vector2 = agent.global_position.direction_to(_waypoint) * agent.move_speed
	agent.move(desired_velocity)
	return RUNNING


## Select an intermidiate waypoint towards the desired position.
func _select_new_waypoint(desired_position: Vector2) -> void:
	var distance_vector: Vector2 = desired_position - agent.global_position
	var angle_variation: float = randf_range(-0.2, 0.2)
	_waypoint = agent.global_position + distance_vector.limit_length(150.0).rotated(angle_variation)
