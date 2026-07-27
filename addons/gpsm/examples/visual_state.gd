extends Control
class_name DemoState

var blink_tween: Tween
@onready var icon: Sprite2D = %Icon

func blink():
	blink_tween = create_tween()
	blink_tween.set_loops()
	blink_tween.tween_property(icon, "modulate:a", 0.0, 0.5)
	blink_tween.tween_property(icon, "modulate:a", 1.0, 0.5)

func stop_blink():
	if blink_tween:
		blink_tween.kill()
	modulate.a = 1.0
