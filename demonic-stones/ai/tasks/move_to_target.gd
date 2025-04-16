extends BTAction


@export var target_var : StringName = &"target"

@export var tolerance : int = 30


func _tick(delta: float) -> Status:
	var target : Node2D = blackboard.get_var(target_var)
	
	if target != null:
		var target_position : Vector2 = target.global_position
		var dir : Vector2 =  agent.global_position.direction_to(target_position)
		
		if abs(agent.global_position.x - target_position.x) < tolerance and abs(agent.global_position.y - target_position.y) < tolerance :
			agent.move(Vector2.ZERO)
			return SUCCESS
		elif abs(agent.global_position.x - target_position.x) < tolerance and abs(agent.global_position.y - target_position.y) > tolerance:
			agent.move(Vector2(0,dir.y))
			return RUNNING
		else:
			agent.move(dir)
			return RUNNING
	else:
		return FAILURE
