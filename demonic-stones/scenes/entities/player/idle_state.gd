extends CharacterState

@export var sprite : AnimatedSprite2D

func _update(delta: float) -> void:
	var velocity : Vector2 = move()
	
	if velocity.x < 0:
			sprite.flip_h = true
	if velocity.x > 0:
			sprite.flip_h = false
	
	if not Vector2.ZERO.is_equal_approx(velocity):
		dispatch("moving", velocity)
