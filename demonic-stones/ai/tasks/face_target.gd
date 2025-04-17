@tool
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
	# Check if the target is still valid (important when respawning the player)
	var raw_target = blackboard.get_var(target_var, null)
	if not is_instance_valid(raw_target):
		return FAILURE
	
	# Set the target and get the direction the agent needs to look in
	var target: Node2D = raw_target
	var dir: float = signf(target.global_position.x - agent.global_position.x)
	# Make sure the agent is not moving
	agent.velocity = Vector2.ZERO
	agent.update_facing(dir)
	return SUCCESS
