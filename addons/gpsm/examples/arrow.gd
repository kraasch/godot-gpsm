extends Control
class_name DemoArrow

@onready var bg: ColorRect = %ColorRect
@onready var button: Button = %Button

var blink_tween: Tween
var inner_transition : GPSM.Transition

func blink():
	blink_tween = create_tween()
	blink_tween.set_loops()
	blink_tween.tween_property(bg, "modulate:a", 0.0, 0.5)
	blink_tween.tween_property(bg, "modulate:a", 1.0, 0.5)

func stop_blink():
	if blink_tween:
		blink_tween.kill()
	modulate.a = 1.0

func _on_clicked():
	if inner_transition:
		inner_transition.trigger()

func _ready():
	button.pressed.connect(_on_clicked)
