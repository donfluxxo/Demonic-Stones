extends CharacterState


func _enter() -> void:
	attack_timer.start()
	move_allowed = false
	
	attack_animation()

func attack_animation():
	character = agent as Character
	character.sprite.play(animation_name)
	character.animation_player.active = true
	character.animation_player.play(animation_name)



func _update(delta: float) -> void:

	var velocity : Vector2 = move()
	
	if Vector2.ZERO.is_equal_approx(velocity) and move_allowed:
		turn_off_animation_player(character.animation_player)
		dispatch("stopped")
	
	if not Vector2.ZERO.is_equal_approx(velocity) and move_allowed:
		turn_off_animation_player(character.animation_player)
		dispatch("moving",velocity)

func turn_off_animation_player(animation_player : AnimationPlayer):
	animation_player.current_animation = "RESET"
	character.animation_player.active = false

func _on_attack_cooldown_timeout() -> void:
	move_allowed = true
	


func _on_sword_body_entered(body: Node2D) -> void:
	if(body.is_class("Chest")):
		prints("HIT")
