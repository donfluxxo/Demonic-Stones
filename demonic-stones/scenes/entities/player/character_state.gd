class_name CharacterState
extends LimboState


@export var animation_name : String
@export var sprite : AnimatedSprite2D
@export var attack_timer : Timer
@export var animation_player : AnimationPlayer
@export var attack_finished : bool = true

var character : Character
var attacking : bool


# Called when entering a state
func _enter() -> void:
	# Get a reference to the Character node and play the sprite corresponding to the endered state
	character = agent as Character
	character.sprite.play(animation_name)


# Attack function
func attack() -> bool:
	# Get the Attack input from the blackboard
	attacking = blackboard.get_var(BBNames.attack_var)
	
	# Check if the character wants to attack and is not attacking already
	if attacking and attack_finished:
		return attacking
	
	return false


# Move function
func move() -> Vector2:
	# Get the players input direction from the blackboard
	var direction = blackboard.get_var(BBNames.direction_var)
	
	# Check if there was input
	if direction:
		# Call the velocity update function with input direction
		update_velocity(direction)
		# Call the move function of character
		character.move_and_slide()
	else:
		update_velocity(direction)
	
	return character.velocity


# Function for updating the characters velocity stat
func update_velocity(input: Vector2) -> void:
	
	# Update velocity in the character stats based on user input
	character.velocity = input.normalized() * character.stats.move_speed
	
	# Flip the sprite to the way the character is facing
	if character.velocity.x < 0:
			sprite.flip_h = true
	if character.velocity.x > 0:
			sprite.flip_h = false
