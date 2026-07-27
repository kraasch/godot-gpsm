extends RefCounted
class_name GPSM

class State:
	signal on_before_exited
	signal on_exited
	signal on_entered
	signal on_after_entered

class Transition:
	var throw_type: THROW_TYPE:
		set(value):
			throw_type = value
	var machine: GPSM
	var state_from: State
	var state_to: State
	func _init(_state_from: State, _state_to: State) -> void:
		state_from = _state_from
		state_to = _state_to
	func trigger() -> void:
		if machine.current_state == state_from:
			state_to.on_before_exited.emit()
			state_from.on_exited.emit()
			machine.current_state = state_to
			state_to.on_entered.emit()
			state_from.on_after_entered.emit()
		else:
			_push_message()
	func _push_message() -> void:
		var message: String = _create_message()
		match machine.throw_type:
			GPSM.THROW_TYPE.WARNING:
				push_warning(message)
				return
			GPSM.THROW_TYPE.ERROR:
				push_error(message)
				return
		match throw_type:
			GPSM.THROW_TYPE.WARNING:
				push_warning(message)
				return
			GPSM.THROW_TYPE.ERROR:
				push_error(message)
				return
	func _create_message() -> String:
		var this_transition_num: int = machine.transitions.find(self)
		var this_transition_from_state_num: int = machine.states.find(state_from)
		var this_transition_to_state_num: int = machine.states.find(state_to)
		var current_state_num: int = machine.states.find(machine.current_state)
		var message: String = 'state was S#' + \
			str(current_state_num) + \
			', but transition T#' + \
			str(this_transition_num) + \
			' (from S#' + \
			str(this_transition_from_state_num) + \
			' to S#' + \
			str(this_transition_to_state_num) + \
			') triggered.'
		return message

enum THROW_TYPE {SILENT, WARNING, ERROR}

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
var throw_type: THROW_TYPE:
	set(value):
		throw_type = value

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
