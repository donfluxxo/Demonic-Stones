class_name DemonicStone
extends StaticBody2D


signal spawn_mob_triggered(coordinations)
signal stone_destroyed


@export var max_health : float = 500.0


var health : float
var wave_counter : int = 0
var stone_coords : Vector2 


@onready var healthbar : ProgressBar = $HealthBar
@onready var sprite : Sprite2D = $Sprite2D
@onready var glowing_symbols : Sprite2D = $Sprite2D/GlowingSymbols

@onready var rng = RandomNumberGenerator.new()

@onready var original_sprite_position : Vector2 = sprite.position

@onready var mob_area : Path2D = $MobArea
@onready var mob_path : PathFollow2D = $MobArea/MobSpawnLocation


func _ready() -> void:
	# Set the stones helth to its max
	health = max_health
	# Set up the healthbar
	healthbar.value = health
	healthbar.max_value = max_health
	# Store the stones position on map
	stone_coords = global_position
	# Create a random new color for each stone
	$Sprite2D/EnergyParticles.modulate = Color(randf(),randf(),randf(), 1)


func check_for_wave() -> bool:
	if (health < max_health) and (wave_counter == 0):
		return true
	if (health < (0.6*max_health)) and (wave_counter == 1):
		return true
	if (health < (0.3*max_health)) and (wave_counter == 2):
		return true
	else:
		return false


func spawn_mob_wave(mob_amount : int) -> void:
	for amount in mob_amount:
		# Select a random location on the spawn path around the stone
		var mob_spawn_location = mob_path
		mob_spawn_location.progress_ratio = randf()
		# Trigger the mob spawn in the game
		spawn_mob_triggered.emit(mob_spawn_location.global_position)


# Shake the stone sprite randomly around
func shake() -> void:
	var random_number_x = rng.randf_range(-5.0, 5.0)
	var random_number_y = rng.randf_range(-5.0, 5.0)
	sprite.position += Vector2(random_number_x,random_number_y)
	await get_tree().create_timer(0.05).timeout
	sprite.position += Vector2(-2*random_number_x,-2*random_number_y)
	await get_tree().create_timer(0.05).timeout
	sprite.position += Vector2(2*random_number_x,2*random_number_y)
	await get_tree().create_timer(0.05).timeout
	sprite.position = original_sprite_position


func destroy_stone() -> void:
	# Deactivate sprite and play stone destroyed animation
	sprite.visible = false
	$CrumbleAnimation.visible = true
	$CrumbleAnimation.play()
	await get_tree().create_timer(2).timeout
	# Destroy the stone and send according signal
	stone_destroyed.emit()
	self.queue_free()


func _manage_hit(object : Node2D) -> void:
	health -= object.get_damage()
	healthbar.value = health
	shake()
	if health <= 0:
		health = 0
		destroy_stone()


# Glowing effect while spawning a wave
func _glow() -> void:
	glowing_symbols.visible = true
	$GlowTimer.start()


# Disable the glowing symbols
func _on_glow_timer_timeout() -> void:
	glowing_symbols.visible = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Only manage hits from weapon attacks (not if e.g. a mob hits the stone)
	if area.is_in_group("weapons"):
		_manage_hit(area)
		# Spawn mob waves if its time
		if check_for_wave():
			_glow()
			spawn_mob_wave(3+2*wave_counter)
			wave_counter += 1
