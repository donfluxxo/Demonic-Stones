extends BTCondition
## InRange condition checks if the agent is within a range of target,
## defined by [member distance_min] and [member distance_max]. [br]
## Returns [code]SUCCESS[/code] if the agent is within the given range;
## otherwise, returns [code]FAILURE[/code].

## Minimum distance to target.
@export var distance_min: float

## Maximum distance to target.
@export var distance_max: float

## Blackboard variable that holds the target (expecting Node2D).
@export var target_var: StringName = &"target"
@export var target_alive_var : StringName = &"target_alive"

var _min_distance_squared: float
var _max_distance_squared: float


# Called to generate a display name for the task.
func _generate_name() -> String:
	return "InRange (%d, %d) of %s" % [distance_min, distance_max, LimboUtility.decorate_var(target_var)]


# Called to initialize the task.
func _setup() -> void:
	## Small performance optimization
	_min_distance_squared = distance_min * distance_min
	_max_distance_squared = distance_max * distance_max


# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var maybe_target = blackboard.get_var(target_var, null)
	if not is_instance_valid(maybe_target):
		return FAILURE

	var target: Node2D = maybe_target
	blackboard.set_var(target_alive_var, !target.is_dead)
	var dist_sq: float = agent.global_position.distance_squared_to(target.global_position)
	if dist_sq >= _min_distance_squared and dist_sq <= _max_distance_squared:
		return SUCCESS
	else:
		return FAILURE
