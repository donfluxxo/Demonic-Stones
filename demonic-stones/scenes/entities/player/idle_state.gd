extends CharacterState


#Called upon any update of this state
func _update(delta: float) -> void:
	if attack_finished:
		#Get the character velocity by calling the move() function
		var velocity : Vector2 = move()
		
		#If the character wants to move send out the Move state signal
		if not Vector2.ZERO.is_equal_approx(velocity):
			dispatch("moving")
		
		#Send out the Attack signal if the character wants to attack
		if attack():
			dispatch("attacking")
