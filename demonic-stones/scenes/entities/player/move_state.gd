extends CharacterState


# Called upon any update of this state
func _update(delta: float) -> void:
	if attack_finished:
		# Get the character velocity
		var velocity : Vector2 = move()
		
		# Send the Idle state signal when the character stopped moving
		if Vector2.ZERO.is_equal_approx(velocity):
			dispatch("stopped")
		
		# Send out the Attack state signal when the character startet attacking
		if attack():
			character.velocity = Vector2.ZERO
			dispatch("attacking")
