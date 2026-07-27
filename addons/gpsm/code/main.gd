extends RefCounted
class_name GPSM

class State:
	signal on_before_exited
	signal on_exited
	signal on_entered
	signal on_after_entered

class Transition:
	var machine: GPSM
	var state_a: State
	var state_b: State
	func _init(_state_a: State, _state_b: State) -> void:
		state_a = _state_a
		state_b = _state_b
	func trigger() -> void:
		if machine.current_state == state_a:
			state_b.on_before_exited.emit()
			state_a.on_exited.emit()
			machine.current_state = state_b
			state_b.on_entered.emit()
			state_a.on_after_entered.emit()

var transitions: Array[Transition] = []:
	get:
		return transitions
var states: Array[State] = []:
	get:
		return states
var current_state: State:
	get:
		return current_state
var initial_state: State:
	get:
		return initial_state
	set(value):
		initial_state = value

func new_state() -> State:
	var s: State = State.new()
	states.append(s)
	return s

func new_transition(a: State, b: State) -> Transition:
	if not states.has(a) or not states.has(b):
		push_warning('state belongs to another machine')
	var t: Transition = Transition.new(a, b)
	t.machine = self
	transitions.append(t)
	return t

func initialize(_initial_state: State = null) -> void:
	if _initial_state:
		initial_state = _initial_state
	if not initial_state:
		if len(states) <= 0:
			push_warning('cannot initialize machine containing no states')
			return 
		initial_state = states[0]
	current_state = initial_state
