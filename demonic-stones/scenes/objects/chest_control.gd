extends CollisionShape2D

@export var sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_collection_area_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		sprite.play("chest_opens")


func _on_collection_area_body_exited(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		sprite.play("chest_closes")
