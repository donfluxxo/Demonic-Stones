extends Node2D


@export var mob_scene : PackedScene


@onready var mob_area : Path2D = $MobArea
@onready var mob_path : PathFollow2D = $MobArea/MobSpawnLocation


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
		
		add_child(mob)
