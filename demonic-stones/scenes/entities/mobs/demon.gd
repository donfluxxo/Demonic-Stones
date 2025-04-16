extends Mob

@export var player_in_sight : bool
@export var player_detected : bool
@export var attacking : bool

@onready var just_spawned : bool
@onready var hit_area : Area2D = $HitArea
@onready var spawn_point : Vector2 = self.position
@onready var raycast : RayCast2D = $RayCast2D
var mob : Mob

func _ready() -> void:
	mob = self
	just_spawned = true
	attacking = false


func _physics_process(delta: float) -> void:
	handle_animation()
	move_and_slide()
	look_for_player()
	prints(player_in_sight)


# Move function
func move(direction : Vector2) -> void:
	# Check if there was input
	if direction:
		# Call the velocity update function with input direction
		update_velocity(direction)
		# Call the move function of the mob
		move_and_slide()
	else:
		update_velocity(Vector2.ZERO)


# Function for updating the characters velocity stat
func update_velocity(input: Vector2) -> void:
	
	# Update velocity in the character stats based on user input
	velocity = input.normalized() * move_speed
	
	# Flip the demons elements to the way the demon is facing
	if velocity.x < 0:
			sprite.flip_h = false
			hit_area.scale.x = 1.0
			sprite.position.x = 0
			raycast.scale.x = 1.0
	if velocity.x > 0:
			sprite.flip_h = true
			hit_area.scale.x = -1.0
			sprite.position.x = 72
			raycast.scale.x = -1.0


func handle_animation() -> void:
	if not just_spawned and not attacking:
		if Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Idle")
		if not Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Move")


func check_for_self(node : Node2D) -> bool:
	if node == self:
		return true
	else:
		return false


func look_for_player() -> void:
	if raycast.is_colliding():
		var collider : Node2D = raycast.get_collider()
		if collider.is_in_group("player"):
			player_in_sight = true
		else:
			player_in_sight = false
	else:
		player_in_sight = false
#
#func _on_timer_timeout() -> void:
	#move(Vector2(randf_range(-1,1),randf_range(-1,1)))
	#$Timer2.start()
#
#
#func _on_timer_2_timeout() -> void:
	#velocity = Vector2.ZERO
	#$Timer.start()
