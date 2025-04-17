extends Mob
## Basic demons base script


signal death_accured


@export var action_allowed : bool
@export var max_health : float


var is_dead : bool = false
var mob : Mob


@onready var health : float
@onready var hit_area : Area2D = $HitArea
@onready var spawn_point : Vector2 = self.position
@onready var healthbar : ProgressBar = $HealthBar


func _ready() -> void:
	mob = self
	action_allowed = false
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health


func _physics_process(delta: float) -> void:
	handle_animation()
	move_and_slide()


# Default animation handling when there is nothing with higher priority coming from BTPlayer
func handle_animation() -> void:
	# Make sure nothing with higher priority is acting
	if action_allowed:
		# If the demon is not moving play idle-animation
		if Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Idle")
		# If the demon is moving play move-animation
		if not Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Move")


# Move function
func move(direction : Vector2) -> void:
	# Check if there was input
	if direction and action_allowed:
		# Call the velocity update function with input direction
		update_velocity(direction)
		# Call the move function of the mob
		move_and_slide()
	else:
		update_velocity(Vector2.ZERO)


# Function for updating the mobs velocity property
func update_velocity(input: Vector2) -> void:
	# Update velocity of the mob based on the input variable
	velocity = input.normalized() * move_speed
	update_facing(velocity.x)


func update_facing(direction : float) -> void:
	# Flip the demons elements to the way the demon is facing
	if direction < 0:
			sprite.flip_h = false
			hit_area.scale.x = 1.0
			sprite.position.x = 0
	if direction > 0:
			sprite.flip_h = true
			hit_area.scale.x = -1.0
			sprite.position.x = 72


# Method to check if the referenced node is this exact instance of "Mob"
func check_for_self(node : Node2D) -> bool:
	if node == self:
		return true
	else:
		return false


# If an attack hits the mob manage the hit
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapons"):
		_manage_hit(area)


func _manage_hit(object : Node2D) -> void:
	# Get the damage var of the attack that hit and update the mobs health
	health -= object.get_damage()
	# Adjust the healthbar to the new health value
	healthbar.value = health
	
	if health <= 0:
		# Make sure the health doesn't get below 0
		health = 0
		# Mark the mob as dead and play the death animation
		action_allowed = false
		animation_player.play("Death")
		# Wait until animation finished
		await get_tree().create_timer(1.2).timeout
		# Send out death signal and destroy the mob node
		death_accured.emit()
		self.queue_free()
