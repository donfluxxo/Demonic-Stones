@tool
extends BTAction


@export var target_pos_var : StringName = &"pos"
@export var dir_var : StringName = &"dir"

@export var tolerance : int = 20


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "MoveToPosition" + LimboUtility.decorate_var(target_pos_var)


func _tick(delta : float) -> Status:
	var target_pos : Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	var dir : Vector2 = blackboard.get_var(dir_var)

	if check_if_reached(target_pos):
		agent.move(Vector2.ZERO)
		return SUCCESS
	else:
		agent.move(dir)
		return RUNNING


func check_if_reached(target : Vector2) -> bool:
	if abs(agent.global_position.x - target.x) < tolerance:
		return true
	else:
		return false
