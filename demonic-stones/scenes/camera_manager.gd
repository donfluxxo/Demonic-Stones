extends Node


@export var player : Character

@export var Camera_Zone0 : PhantomCamera2D
@export var Camera_Zone1 : PhantomCamera2D
@export var Camera_Zone2 : PhantomCamera2D
@export var Camera_Zone3 : PhantomCamera2D

var current_camera_zone : int = 0


func update_current_zone(body : Node2D, zone_a : int, zone_b : int) -> void:
	if body == player:
		match current_camera_zone:
			zone_a:
				current_camera_zone = zone_b
			zone_b:
				current_camera_zone = zone_a
		update_camera()


func update_camera() -> void:
	var cameras = [Camera_Zone0, Camera_Zone1, Camera_Zone2]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
	
	match current_camera_zone:
		0:
			Camera_Zone0.priority = 1
		1:
			Camera_Zone1.priority = 1
		2:
			Camera_Zone2.priority = 1


func _on_camera_zone_01_body_entered(body : Node2D) -> void:
	update_current_zone(body, 0, 1)

func _on_camera_zone_01_body_exited(body: Node2D) -> void:
	update_current_zone(body, 0, 1)


func _on_camera_zone_02_body_entered(body : Node2D) -> void:
	update_current_zone(body, 0, 2)

func _on_camera_zone_20_body_entered(body: Node2D) -> void:
	current_camera_zone = 0
	update_camera()


func _on_camera_zone_03_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
