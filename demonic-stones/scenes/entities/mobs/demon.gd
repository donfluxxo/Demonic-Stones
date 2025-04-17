extends Mob


@export var attacking : bool
@export var max_health : float

@onready var health : float
@onready var just_spawned : bool
@onready var hit_area : Area2D = $HitArea
@onready var spawn_point : Vector2 = self.position
@onready var healthbar : ProgressBar = $HealthBar

signal death

var is_dead : bool = false
var mob : Mob

func _ready() -> void:
	mob = self
	just_spawned = true
	attacking = false
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health


func _physics_process(delta: float) -> void:
	handle_animation()
	move_and_slide()


# Move function
func move(direction : Vector2) -> void:
	# Check if there was input
	if direction and not is_dead:
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


func handle_animation() -> void:
	if not just_spawned and not attacking and not is_dead:
		if Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Idle")
		if not Vector2.ZERO.is_equal_approx(velocity):
			animation_player.play("Move")


func check_for_self(node : Node2D) -> bool:
	if node == self:
		return true
	else:
		return false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapons"):
		_manage_hit(area)


func _manage_hit(object : Node2D) -> void:
	health -= object.get_damage()
	healthbar.value = health
	if health <= 0:
		health = 0
		is_dead = true
		animation_player.play("Death")
		await get_tree().create_timer(1.2).timeout
		death.emit()
		self.queue_free()
