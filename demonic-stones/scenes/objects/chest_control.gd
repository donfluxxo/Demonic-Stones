extends CollisionShape2D


@export var sprite : AnimatedSprite2D


# Play the opening animation when a character enters the collection area
func _on_collection_area_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		sprite.play("chest_opens")


# Play the closing animation when a character leaves the collection area
func _on_collection_area_body_exited(body: CharacterBody2D) -> void:
	if body is Player:
		sprite.play("chest_closes")
