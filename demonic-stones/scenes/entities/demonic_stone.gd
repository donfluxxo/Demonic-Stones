class_name DemonicStone
extends StaticBody2D


@export var max_health : float = 500.0


@onready var healthbar : ProgressBar = $HealthBar
@onready var sprite : Sprite2D = $Sprite2D
@onready var glowing_symbols : Sprite2D = $Sprite2D/GlowingSymbols
@onready var rng = RandomNumberGenerator.new()
@onready var original_sprite_position : Vector2 = sprite.position


var stone_coords : Vector2 
var health : float
var wave_counter : int = 0

signal spawn_mob_wave
signal stone_destroyed

func _ready() -> void:
	health = max_health
	healthbar.value = health
	healthbar.max_value = max_health
	stone_coords = self.position
	$Sprite2D/EnergyParticles.modulate = Color(randf(),randf(),randf(), 1)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapons"):
		_manage_hit(area)
		if check_for_wave():
			glow()
			spawn_mob_wave.emit(3+2*wave_counter, stone_coords)
			wave_counter += 1


func _manage_hit(object : Node2D) -> void:
	health -= object.get_damage()
	healthbar.value = health
	shake()
	if health <= 0:
		health = 0
		destroy_stone()


func check_for_wave() -> bool:
	if (health < max_health) and (wave_counter == 0):
		return true
	if (health < (0.6*max_health)) and (wave_counter == 1):
		return true
	if (health < (0.3*max_health)) and (wave_counter == 2):
		return true
	else:
		return false





func glow() -> void:
	glowing_symbols.visible = true
	$GlowTimer.start()


func _on_glow_timer_timeout() -> void:
	glowing_symbols.visible = false


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
	
	stone_destroyed.emit()
	sprite.visible = false
	$CrumbleAnimation.visible = true
	$CrumbleAnimation.play()
	await get_tree().create_timer(2).timeout
	self.queue_free()
