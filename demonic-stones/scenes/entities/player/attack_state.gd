extends CharacterState

@export var attack : StringName

func _enter() -> void:
	character = agent as CharacterBody2D
	character.animation_player.play(animation_name)
	character_stats = character.stats
