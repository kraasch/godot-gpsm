extends RefCounted
class_name GPSM

## Represents a state in a GPSM state machine.
class State:
	## The state's name, if unnamed will get a number, e.g. 'unnamed#12'.
	var name: String
	## The state's conversion to string, called by str().
	func _to_string() -> String:
		return 'state(name: %s)' % [name]
	## The state's init function, called by new(), automatically called by the machine.
	## Use (machine as GPSM).new_state() to create new states.
	func _init(_name: String) -> void:
		name = _name
	## Emitted on entered state, before exited state's on_exited signal is emitted.
	signal on_before_exited
	## Emitted on exited state, after entered state's on_before_exited signal is emitted.
	signal on_exited
	## Emitted on entered state, before exited state's on_after_entered signal is emitted.
	signal on_entered
	## Emitted on exited state, after exited state's on_entered signal is emitted.
	signal on_after_entered

## Represents a transition in a GPSM state machine.
class Transition:
	## Emitted if a transition is triggered, but could not be taken because the machine's
	## current_state did not match the transitions from_state.
	signal on_failure(message: String, transition: Transition, current_state: State)
	## Emitted if a transition is triggered successfully and state is changed.
	signal on_success(transition: Transition)
	## Defines if the transition throws warnings, errors or stays silent on failures.
	var throw_type: THROW_TYPE:
		set(value):
			throw_type = value
	## The owning machine for this transition.
	var machine: GPSM
	## The state the transition starts from.
	var from_state: State
	## The state the transition goes to.
	var to_state: State
	## The transition's name, if unnamed will get a number, e.g. 'unnamed#12'.
	var name: String
	## The transitions's conversion to string, called by str().
	func _to_string() -> String:
		return 'transition(name: %s, from: %s, to: %s)' % [name, from_state.name, to_state.name]
	## The transitions's init function, called by new(), automatically called by the machine.
	## Use (machine as GPSM).new_transition() to create new transition.
	func _init(_from_state: State, _to_state: State, _name: String) -> void:
		name = _name
		from_state = _from_state
		to_state = _to_state
	## Call this when triggering a transition.
	func trigger() -> void:
		if machine.current_state == from_state:
			_handle_success()
		else:
			_handle_failure()
	## Called when transition should be taken successfully.
	## Attach to on_success signal to catch successful transitions.
	func _handle_success() -> void:
			to_state.on_before_exited.emit()
			from_state.on_exited.emit()
			on_success.emit(self)
			machine.current_state = to_state
			to_state.on_entered.emit()
			from_state.on_after_entered.emit()
	## Called when transition should not be taken and failed.
	## Attach to on_failure signal to catch failtures.
	func _handle_failure() -> void:
		var message: String = _create_failure_message()
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
	## Creates a message passed into emitted transition failures.
	func _create_failure_message() -> String:
		var this_transition_num: int = machine.transitions.find(self)
		var this_transition_from_state_num: int = machine.states.find(from_state)
		var this_transition_to_state_num: int = machine.states.find(to_state)
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

## A throw type for state machines and transitions. Can be set on each. Transition throw types have
## priority over state machine's throw types, so indivisual transitions can be set to throw
## differently.
enum THROW_TYPE {SILENT, WARNING, ERROR}

## The state machine's array of transitions.
var transitions: Array[Transition] = []:
	get:
		return transitions
## The state machine's array of states.
var states: Array[State] = []:
	get:
		return states
## The state machine's current state. Set by initialize().
var current_state: State:
	get:
		return current_state
## The state machine's initial state. Set to current_state when calling initialize().
## If no explicit intial_state was set the first state in the machines states array
## will serve as the initial state.
var initial_state: State:
	get:
		return initial_state
	set(value):
		initial_state = value
## The state machine's throw type. See transition's throw type and the machine's 
## THROW_TYPE enum for more info.
var throw_type: THROW_TYPE:
	set(value):
		throw_type = value
## Defines if the initialize() function should emit the first state's on_entered signal.
var trigger_on_init: bool = true
## The state machine's name.
##
## Will only be set when creating state machines with the static constructor GPSM.new_machine('name'),
## not when calling GPSM.new().
var name: String
## Keeps track of unnamed states.
var unnamed_states_counter: int = 1
## Keeps track of unnamed transitions.
var unnamed_transitions_counter: int = 1
## Provides access to states via name.
var states_dict: Dictionary[String, State]
## Provides access to transitions via name.
var transitions_dict: Dictionary[String, Transition]

## An array of all state machines.
##
## Will only be set when creating state machines with the static constructor GPSM.new_machine('name'),
## not when calling GPSM.new().
static var machines: Array[GPSM] = []
## Provides access to machines via name.
##
## Will only be set when creating state machines with the static constructor GPSM.new_machine('name'),
## not when calling GPSM.new().
static var machines_dict: Dictionary[String, GPSM] = {}

## Resets the machines array and machines_dict dictionary. Any machines created before cannot
## be accessed via GPSM.get_machine('name') anymore, but must have separate references.
static func reset() -> void:
	machines_dict = {}
	machines = []

## Static constructor for a new machine. Allows to pass in a name. Machine will be tracked
## internally by machines array and machines_dict dictionary for lookup via number or name.
##
## Machines created by calling GPSM.new() will not be tracked.
static func new_machine(_name: String) -> GPSM:
	if machines_dict.has(_name):
		push_warning('machine name already exists')
		return null
	var machine: GPSM = GPSM.new()
	machine.name = _name
	machines_dict[_name] = machine
	machines.append(machine)
	return machine

## Can returned a tracked machine by name.
## 
## Will only be working when creating state machines with the static constructor GPSM.new_machine('name'),
## not when calling GPSM.new().
static func get_machine(_name: String) -> GPSM:
	if not _name or not machines_dict.has(_name):
		return null
	return machines_dict[_name]

## The state machine's conversion to string, called by str().
func _to_string() -> String:
	return 'machine(name: %s, states: %d, transitions: %d)' % [name, len(states), len(transitions)]

## Provides a unique name for unnamed states. The pattern is 'unnamed#NUM' with NUM being a number
## counted up for each unnamed state. State numbering is independent from transition numbering.
func _get_unique_state_name() -> String:
	var name: String
	while true:
		name = 'unnamed#%d' % unnamed_states_counter
		unnamed_states_counter += 1
		if not states_dict.has(name):
			break
	return name

## Provides a unique name for unnamed transition. The pattern is 'unnamed#NUM' with NUM being a number
## counted up for each unnamed transition. Transition numbering is independent from state numbering.
func _get_unique_transition_name() -> String:
	var name: String
	while true:
		name = 'unnamed#%d' % unnamed_transitions_counter
		unnamed_transitions_counter += 1
		if not transitions_dict.has(name):
			break
	return name

## Provides a way to trigger a state machine's transitions by name.
## 
## Will only be working when providing a valid transition name.
## Will throw a warning if name was out of bounds.
func trigger(transition_name: String) -> void:
	var t: Transition = get_transition(transition_name)
	if not t:
		return
	t.trigger()

## Provides a way to trigger a state machine's transitions by a transition's index.
##
## Will throw a warning if index was out of bounds.
func trigger_by_index(transition_index: int) -> void:
	if transition_index < 0 or transition_index >= len(transitions):
		push_warning('transition index out of bounds')
		return
	var t: Transition = transitions[transition_index]
	t.trigger()

## Provides a way to trigger a state machine's transitions by a transition's name.
##
## Will throw a warning if name was out of bounds.
func get_transition(transition_name: String) -> Transition:
	if not transitions_dict.has(transition_name):
		push_warning('transition name not found')
		return null
	var t: Transition = transitions_dict[transition_name]
	return t

## Creates a new state for this state machine.
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

## Creates a new transition for this state machine.
##
## Will throw a warning when provided a state of a different state machine.
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

## Sets state machine's initial state. Has to be called, before using a state machine's transitions.
## 
## This sets the current_state to initial_state, if no initial stated was passed in. If neither
## an initial_state was set, nor an initial state was passed in, the first state in the state
## machine's states array will serve as the first state. If there is no states a warning will be
## thrown.
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
