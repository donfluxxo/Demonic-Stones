@tool 
extends BTCondition
## InRangeOfSpawnposition condition checks if the agent is within a range of its 
## spawn point, defined by [member roaming_distance_max]. [br]
## Returns [code]SUCCESS[/code] if the agent is within the given range;
## otherwise, returns [code]FAILURE[/code].


## Maximum distance to target.
@export var roaming_distance_max: float

## Blackboard variable that holds the target (expecting Node2D).
@export var spawn_pos: StringName = &"spawn"


var _max_roaming_distance_squared: float


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "NotInRange (%d) of %s" % [roaming_distance_max,
		LimboUtility.decorate_var(spawn_pos)]


# Called to initialize the task.
func _setup() -> void:
	blackboard.set_var(spawn_pos,agent.spawn_point)
	
	# Small performance optimization
	_max_roaming_distance_squared = roaming_distance_max * roaming_distance_max


# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var spawn_pos: Vector2 = blackboard.get_var(spawn_pos, null)
	
	if abs(agent.global_position.x - agent.spawn_point.x) + abs(agent.global_position.y -
			agent.spawn_point.y) < roaming_distance_max:
		return FAILURE
	else:
		return SUCCESS
