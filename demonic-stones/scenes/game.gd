extends Node2D


@export var mob_scene : PackedScene
@export var player_scene : PackedScene
@export var restart_scene : PackedScene

@export var player : Character

@onready var mob_area : Path2D = $MobArea
@onready var mob_path : PathFollow2D = $MobArea/MobSpawnLocation
@onready var restart_screen : Control = $Player/RestartScreen

var destroyed_stones : int = 0
var player_death_position : Vector2
var player_kills : int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_mob_wave(mob_amount : int, stone_coordinates : Vector2) -> void:
	
	mob_area.position = stone_coordinates
	
	for number in mob_amount:
		var mob = mob_scene.instantiate()
		
		var mob_spawn_location = mob_path
		mob_spawn_location.progress_ratio = randf()
		# Set the mob's position to the random location.
		mob.position = mob_area.position + mob_spawn_location.position
		mob.death.connect(_on_mob_killed)
		add_child(mob)


func _on_stone_destroyed() -> void:
	destroyed_stones += 1
	prints("Destroyed Stones: ", destroyed_stones)


func _on_mob_killed() -> void:
	player.mobs_killed += 1


func _on_player_player_died(position : Vector2, kills : int) -> void:
	player_death_position = position
	player_kills = kills
	restart_screen.show_restart_screen(kills, destroyed_stones)



func destroy_old_player_node() -> void:
	var old_player = get_tree().get_first_node_in_group("player")
	old_player.queue_free()


func _on_restart_screen_restart_here() -> void:
	destroy_old_player_node()
	create_new_player_node()


func _on_restart_screen_restart_home() -> void:
	destroyed_stones = 0
	player_kills = 0
	get_tree().reload_current_scene()


func create_new_player_node() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = player_death_position
	restart_screen =restart_scene.instantiate()
	player.add_child(restart_screen)
	player.player_died.connect(_on_player_player_died)
	restart_screen.restart_here.connect(_on_restart_screen_restart_here)
	restart_screen.restart_home.connect(_on_restart_screen_restart_home)
	player.mobs_killed = player_kills
	restart_screen.z_index = 20
