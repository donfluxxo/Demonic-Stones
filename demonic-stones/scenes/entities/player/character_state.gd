class_name CharacterState
extends LimboState


@export var animation_name : String
@export var sprite : AnimatedSprite2D
@export var attack_timer : Timer
@export var animation_player : AnimationPlayer
@export var move_allowed : bool = true

var character : Character
var attacking : bool

func _enter() -> void:
	character = agent as Character
	character.sprite.play(animation_name)


func attack() -> bool:
	attacking = blackboard.get_var(BBNames.wants_to_attack)
	
	if attacking and move_allowed:
		return attacking
	
	return false


func move() -> Vector2:
	var direction = blackboard.get_var(BBNames.direction_var)
	
	if direction and move_allowed:
		update_velocity(direction)
		#Move
		character.move_and_slide()
	else: if move_allowed:
		update_velocity(direction)
		
	
	return character.velocity

func update_velocity(input: Vector2) -> void:
	
	#Update velocity based on user input
	character.velocity = input.normalized() * character.stats.move_speed
	
	if character.velocity.x < 0:
			sprite.flip_h = true
	if character.velocity.x > 0:
			sprite.flip_h = false
