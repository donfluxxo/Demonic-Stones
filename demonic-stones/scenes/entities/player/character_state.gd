class_name CharacterState
extends LimboState


@export var animation_name : String
@export var sprite : AnimatedSprite2D

var character : CharacterBody2D
var character_stats : CharacterStats

func _enter() -> void:
	character = agent as CharacterBody2D
	character.sprite.play(animation_name)
	character_stats = character.stats

func move() -> Vector2:
	var direction = blackboard.get_var(BBNames.direction_var)
	
	if direction:
		update_velocity(direction)
		#Move
		character.move_and_slide()
		prints(character.velocity)
	else:
		update_velocity(direction)
	
	return character.velocity

func update_velocity(input: Vector2) -> void:
	#Update velocity based on user input
	character.velocity = input.normalized() * character_stats.move_speed
	if character.velocity.x < 0:
			sprite.flip_h = true
	if character.velocity.x > 0:
			sprite.flip_h = false
