extends BTAction
## Flips the agent to face the target, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if [member target_var] is not a valid [Node2D] instance.

## Blackboard variable that stores our target (expecting Node2D).
@export var target_var: StringName = &"target"

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "FaceTarget " + LimboUtility.decorate_var(target_var)


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var target: Node2D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		return FAILURE
	var dir: float = signf(target.global_position.x - agent.global_position.x)
	agent.velocity = Vector2.ZERO
	agent.update_facing(dir)
	return SUCCESS
