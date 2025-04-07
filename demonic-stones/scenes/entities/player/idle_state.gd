extends CharacterState


func _update(delta: float) -> void:
	var velocity : Vector2 = move()
	
	if not Vector2.ZERO.is_equal_approx(velocity) and move_allowed:
		dispatch("moving")
	
	if attack():
		dispatch("attacking")
