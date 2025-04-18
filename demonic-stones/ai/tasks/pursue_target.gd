@tool
extends BTAction


@export var target_var : StringName = &"target"

@export var tolerance : int = 30


var _waypoint: Vector2


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "PursueTarget" + LimboUtility.decorate_var(target_var)


func _enter() -> void:
	var target: Node2D = blackboard.get_var(target_var, null)
	if is_instance_valid(target):
		# Movement is performed in smaller steps.
		# For each step, we select a new waypoint.
		_select_new_waypoint(_get_desired_position(target))


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	
	var raw_target = blackboard.get_var(target_var, null)
	if not is_instance_valid(raw_target):
		return FAILURE
	
	var target: Node2D = raw_target
	if not is_instance_valid(target):
		return FAILURE
	
	var desired_pos: Vector2 = _get_desired_position(target)
	if agent.global_position.distance_to(desired_pos) < tolerance:
		agent.move(Vector2.ZERO)
		return SUCCESS
	
	if agent.global_position.distance_to(_waypoint) < tolerance:
		_select_new_waypoint(desired_pos)
	
	var desired_velocity: Vector2 = agent.global_position.direction_to(_waypoint) * agent.move_speed
	agent.move(desired_velocity)
	return RUNNING


## Get the closest flanking position to target.
func _get_desired_position(target: Node2D) -> Vector2:
	var side: float = signf(agent.global_position.x - target.global_position.x)
	var desired_pos: Vector2 = target.global_position
	desired_pos.x += tolerance * side
	return desired_pos


## Select an intermidiate waypoint towards the desired position.
func _select_new_waypoint(desired_position: Vector2) -> void:
	var distance_vector: Vector2 = desired_position - agent.global_position
	var angle_variation: float = randf_range(-0.2, 0.2)
	_waypoint = agent.global_position + distance_vector.limit_length(150.0).rotated(angle_variation)
