extends RefCounted
class_name GPSM

class State:
	var name: String
	func _to_string() -> String:
		return 'state(name: %s)' % [name]
	func _init(_name: String) -> void:
		name = _name
	signal on_before_exited
	signal on_exited
	signal on_entered
	signal on_after_entered

class Transition:
	signal on_failure(message: String, transition: Transition, current_state: State)
	var throw_type: THROW_TYPE:
		set(value):
			throw_type = value
	var machine: GPSM
	var state_from: State
	var state_to: State
	var name: String
	func _to_string() -> String:
		return 'transition(name: %s, from: %s, to: %s)' % [name, state_from.name, state_to.name]
	func _init(_state_from: State, _state_to: State, _name: String) -> void:
		name = _name
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
		on_failure.emit(message, self, machine.current_state)
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
var trigger_on_init: bool = true
var name: String
var unnamed_states_counter: int = 1
var unnamed_transitions_counter: int = 1
var states_dict: Dictionary 
var transitions_dict: Dictionary

static var machines_dict: Dictionary[String, GPSM] = {}
static var machines: Array[GPSM] = []

static func reset() -> void:
	machines_dict = {}
	machines = []

static func new_machine(_name: String) -> GPSM:
	if machines_dict.has(_name):
		push_warning('machine name already exists')
		return null
	var machine: GPSM = GPSM.new()
	machine.name = _name
	machines_dict[_name] = machine
	machines.append(machine)
	return machine

static func get_machine(_name: String) -> GPSM:
	if not _name or not machines_dict.has(_name):
		return null
	return machines_dict[_name]

func _to_string() -> String:
	return 'machine(name: %s, states: %d, transitions: %d)' % [name, len(states), len(transitions)]

func _get_unique_state_name() -> String:
	var name: String
	while true:
		name = 'unnamed#%d' % unnamed_states_counter
		unnamed_states_counter += 1
		if not states_dict.has(name):
			break
	return name

func _get_unique_transition_name() -> String:
	var name: String
	while true:
		name = 'unnamed#%d' % unnamed_transitions_counter
		unnamed_transitions_counter += 1
		if not transitions_dict.has(name):
			break
	return name

func trigger(transition_name: String) -> void:
	var t: Transition = get_transition(transition_name)
	if not t:
		return
	t.trigger()

func trigger_by_index(transition_index: int) -> void:
	if transition_index < 0 or transition_index >= len(transitions):
		push_warning('transition index out of bounds')
		return
	var t: Transition = transitions[transition_index]
	t.trigger()

func get_transition(transition_name: String) -> Transition:
	if not transitions_dict.has(transition_name):
		push_warning('transition name not found')
		return null
	var t: Transition = transitions_dict[transition_name]
	return t

func new_state(_name: String = '') -> State:
	if states_dict.has(_name):
		push_warning('state name already exists')
		return null
	if _name.is_empty():
		_name = _get_unique_state_name()
	var s: State = State.new(_name)
	states.append(s)
	states_dict[_name] = s
	return s

func new_transition(a: State, b: State, _name: String = '') -> Transition:
	if not states.has(a) or not states.has(b):
		push_warning('state belongs to another machine')
		return
	if transitions_dict.has(_name):
		push_warning('transition name already exists')
		return null
	if _name.is_empty():
		_name = _get_unique_transition_name()
	var t: Transition = Transition.new(a, b, _name)
	t.machine = self
	transitions.append(t)
	transitions_dict[_name] = t
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
	if trigger_on_init:
		current_state.on_entered.emit()
