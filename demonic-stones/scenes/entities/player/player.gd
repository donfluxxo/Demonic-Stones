class_name Player
extends Character


@export var player_actions : PlayerActions

var character : Character = self

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("mob_attack"):
		_manage_hit(area)

func _manage_hit(object : Node2D) -> void:
	character.health -= object.get_damage()
	#healthlabel.text = "%f" %health
	#shake()
	if character.health <= 0:
		character.health = 0
