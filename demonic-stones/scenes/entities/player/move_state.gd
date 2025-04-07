extends CharacterState

func _update(delta: float) -> void:
	var velocity : Vector2 = move()
	
	if Vector2.ZERO.is_equal_approx(velocity) and move_allowed:
		dispatch("stopped")
	
	if attack():
		character.velocity = Vector2.ZERO
		dispatch("attacking")
