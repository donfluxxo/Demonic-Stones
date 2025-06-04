extends Area2D


var camera : PhantomCamera2D

# Default priority for Camera that follows player
var default = 1


func _ready() -> void:
	camera = $PhantomCamera2D


func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		camera.priority = default + 1


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		camera.priority = default - 1
