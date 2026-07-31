extends Control
class_name MyDemoForGpsm

@onready var label: Label = %Label
@onready var visual_state_1: Control = %VisualState1
@onready var visual_state_2: Control = %VisualState2
@onready var visual_state_3: Control = %VisualState3
@onready var visual_state_4: Control = %VisualState4
@onready var arrow_0: Control = %Arrow0
@onready var arrow_1: Control = %Arrow1
@onready var arrow_2: Control = %Arrow2
@onready var arrow_3: Control = %Arrow3
@onready var arrow_4: Control = %Arrow4
@onready var arrow_5: Control = %Arrow5
@onready var visual_states: Array[Control] = [visual_state_1, visual_state_2, visual_state_3, visual_state_4]
@onready var arrows: Array[Control] = [arrow_0, arrow_1, arrow_2, arrow_3, arrow_4, arrow_5]

@onready var _SM: GPSM
@onready var _A: GPSM.State
@onready var _B: GPSM.State
@onready var _C: GPSM.State
@onready var _D: GPSM.State
@onready var _T0: GPSM.Transition
@onready var _T1: GPSM.Transition
@onready var _T2: GPSM.Transition
@onready var _T3: GPSM.Transition
@onready var _T4: GPSM.Transition
@onready var _T5: GPSM.Transition

@onready var states: Array[GPSM.State]
@onready var transitions: Array[GPSM.Transition]

func _ready() -> void:
	_setup_testing_state_machine()

func _setup_testing_state_machine() -> void:
	_SM = GPSM.new()
	#     ---->   T0
	#  A  <---- B T1
	#  |        |
	#  | T4     | T5
	#  V        V
	#  C  ----> D T2
	#     <----   T3
	_A = _SM.new_state()
	_B = _SM.new_state()
	_C = _SM.new_state()
	_D = _SM.new_state()
	_T0 = _SM.new_transition(_A, _B)
	_T1 = _SM.new_transition(_B, _A)
	_T2 = _SM.new_transition(_C, _D)
	_T3 = _SM.new_transition(_D, _C)
	_T4 = _SM.new_transition(_A, _C)
	_T5 = _SM.new_transition(_B, _D)
	states = [_A, _B, _C, _D]
	transitions = [_T0, _T1, _T2, _T3, _T4, _T5]
	var collect_failures: Callable = func(message: String, transition: GPSM.Transition, current_state: GPSM.State):
		label.text = message
	for i: int in len(states):
		var state: GPSM.State = states[i]
		var visual_state: DemoState = visual_states[i]
		state.on_entered.connect(visual_state.blink)
		state.on_exited.connect(visual_state.stop_blink)
		state.on_entered.connect(func (): print('entered state' + str(i)))
		state.on_exited.connect(func (): print('exited state' + str(i)))
	for i: int in len(transitions):
		var transition: GPSM.Transition = transitions[i]
		var arrow: DemoArrow = arrows[i]
		arrow.inner_transition = transition
		transition.on_failure.connect(arrow.blink)
		transition.on_failure.connect(func (msg, t, s): print('failed transition: ' + str(msg)))
		transition.on_failure.connect(collect_failures)
	_SM.throw_type = GPSM.THROW_TYPE.SILENT
	_SM.initialize()

## Quits the game when Esc is pressed, but only when running from the editor.
func _unhandled_input(event):
	# NOTE: useful for debugging, this leaves the game when hitting the ESC key.
	if event.is_action_pressed("ui_cancel"):
		if OS.has_feature("editor"):
			get_tree().quit()
