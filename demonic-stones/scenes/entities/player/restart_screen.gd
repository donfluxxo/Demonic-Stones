extends Control


@onready var retry_screen : ColorRect = $CanvasLayer2/RetryScreen
@onready var death_message1 : Label = $CanvasLayer2/DeathMessage
@onready var death_message2 : Label = $CanvasLayer2/MobScore
@onready var death_message3 : Label = $CanvasLayer2/StoneScore
@onready var canvas_layer : CanvasLayer = $CanvasLayer
@onready var canvas_layer2 : CanvasLayer = $CanvasLayer2

signal restart_here
signal restart_home


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_restart_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_restart_screen(mobs : int, stones : int) -> void:
	death_message1.text = "YOU DIED !"
	death_message2.text = "Mobs slashed: %s" %mobs
	death_message3.text = "Stones crushed: %s" %stones
	canvas_layer.show()
	canvas_layer2.show()


func hide_restart_screen() -> void:
	canvas_layer.hide()
	canvas_layer2.hide()


func _on_restart_here_button_pressed() -> void:
	restart_here.emit()


func _on_restart_home_button_pressed() -> void:
	restart_home.emit()
