class_name Sword
extends Area2D

@export var damage : float = 15.0

func _ready() -> void:
	self.add_to_group("weapons")

func get_damage() -> float:
	return damage
