extends Node2D
## Main game scene


@export var mob_scene : PackedScene
@export var player_scene : PackedScene
@export var restart_scene : PackedScene

@export var player : Character


var player_death_position : Vector2

var destroyed_stones : int = 0
var player_kills : int 


@onready var restart_screen : Control = $Player/RestartScreen


func _ready() -> void:
	restart_screen.hide_restart_screen()

func destroy_old_player_node() -> void:
	var old_player = get_tree().get_first_node_in_group("player")
	old_player.queue_free()


func create_new_player_node() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = player_death_position
	restart_screen = restart_scene.instantiate()
	player.add_child(restart_screen)
	player.player_died.connect(_on_player_player_died)
	restart_screen.hide_restart_screen()
	restart_screen.restarted_here.connect(_on_restart_screen_restarted_here)
	restart_screen.restarted_home.connect(_on_restart_screen_restarted_home)
	player.mobs_killed = player_kills
	restart_screen.z_index = 20


func _on_player_player_died(position : Vector2, kills : int) -> void:
	player_death_position = position
	player_kills = kills
	restart_screen.show_restart_screen(kills, destroyed_stones)


func _on_stone_destroyed() -> void:
	destroyed_stones += 1


# Spawn a new mob at the given position on the map
func _on_spawn_mob_triggered(coordinates : Vector2) -> void:
	var mob = mob_scene.instantiate()
	# Set the mob's positition in the world
	mob.position = coordinates
	# Connect the death signal of the mob to the kill counter for the player
	mob.death_accured.connect(_on_mob_death_accured)
	add_child(mob)


func _on_mob_death_accured() -> void:
	player.mobs_killed += 1


func _on_restart_screen_restarted_here() -> void:
	destroy_old_player_node()
	create_new_player_node()


func _on_restart_screen_restarted_home() -> void:
	destroyed_stones = 0
	player_kills = 0
	get_tree().reload_current_scene()
