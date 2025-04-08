extends CharacterState
## AttackState


# On entering this state
func _enter() -> void:
	# Start the attack cooldown and forbid any moves for that time
	attack_timer.start()
	attack_finished = false
	# Play the attack animation
	attack_animation()


# Called upon any update of this state
func _update(delta: float) -> void:
	if attack_finished:
		# Get the character velocity by calling the move() function
		var velocity : Vector2 = move()
		
		# Check if the players velocity is zero
		if Vector2.ZERO.is_equal_approx(velocity):
			# If so, turn off the animation player for the swords hitbox and send out the Idle state signal
			turn_off_animation_player(character.animation_player)
			dispatch("stopped")
		
		# Check if the player wants to move and is allowed to
		if not Vector2.ZERO.is_equal_approx(velocity):
			# If so, turn off the animation player for the swords hitbox and send out the Move state signal
			turn_off_animation_player(character.animation_player)
			dispatch("moving",velocity)


# Function for calling the attack animation
func attack_animation() -> void:
	# Get acces to the Character node
	character = agent as Character
	# Play the attack animation for the sprite
	character.sprite.play(animation_name)
	# Activate and play the animation player for the swords hitbox
	character.animation_player.active = true
	character.animation_player.play(animation_name)


# Function for reseting and turning off the swords hitbox and its animation
func turn_off_animation_player(animation_player : AnimationPlayer) -> void:
	animation_player.current_animation = "RESET"
	character.animation_player.active = false


# Allow changing the state if attack is finished
func _on_attack_timer_timeout() -> void:
	attack_finished = true


# Detect what the sword hit and handle the collision
func _on_sword_body_entered(body: Node2D) -> void:
	if(body.is_class("Chest")):
		# Debug
		prints("HIT")
