extends RefCounted
class_name GPSM

class State:
	pass

class Transition:
	var state_a: State
	var state_b: State
	func _init(_state_a: State, _state_b: State) -> void:
		state_a = _state_a
		state_b = _state_b

var transitions: Array[Transition] = []
var states: Array[State] = []

func get_transitions() -> Array[Transition]:
	return transitions

func get_states() -> Array[State]:
	return states

func add_transition(transition: Transition) -> void:
	transitions.append(transition)

func add_state(state: State) -> void:
	states.append(state)
