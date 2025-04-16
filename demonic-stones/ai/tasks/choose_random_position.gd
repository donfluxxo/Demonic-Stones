extends BTAction


@export var range_min_in_dir : float = 75.0
@export var range_max_in_dir : float = 150.0

@export var position_var : StringName = &"pos"
@export var dir_var : StringName = &"dir"


func _tick(delta: float) -> Status:
	var new_position : Vector2
	var direction : Vector2 = random_direction()
	
	new_position = random_position(direction)
	blackboard.set_var(position_var, new_position)
	
	
	return SUCCESS


func random_direction() -> Vector2:
	var dir : Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))
	blackboard.set_var(dir_var, dir)
	return dir


func random_position(dir : Vector2) -> Vector2:
	var distance : Vector2 = randi_range(range_min_in_dir, range_max_in_dir) * dir
	var new_position : Vector2 = (distance + agent.global_position)
	return new_position
