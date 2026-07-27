# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://addons/gpsm/code/main.gd'

func test_state_machine__provide_signals_for_state_change() -> void:
	var result: Array[String] = []
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var T: GPSM.Transition = sm.new_transition(A, B)
	A.on_exited.connect(result.append.bind('b'))
	A.on_after_entered.connect(result.append.bind('d'))
	B.on_before_exited.connect(result.append.bind('a'))
	B.on_entered.connect(result.append.bind('c'))
	sm.initialize()
	T.trigger()
	assert_array(result).is_equal(['a','b','c','d'])

func test_state_machine__cannot_mix_states_of_different_machines() -> void:
	var sm: GPSM = GPSM.new()
	var intruder_sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var intruder_state: GPSM.State = intruder_sm.new_state()
	await assert_error(func (): sm.new_transition(A, B)).is_success()
	await assert_error(func (): sm.new_transition(B, intruder_state)).is_push_warning('state belongs to another machine')

func test_state_machine__trigger_transition() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var C: GPSM.State = sm.new_state()
	var T0: GPSM.Transition = sm.new_transition(A, B)
	var T1: GPSM.Transition = sm.new_transition(B, C)
	sm.initial_state = A
	sm.initialize()
	assert_that(sm.current_state).is_equal(A)
	T1.trigger()
	assert_that(sm.current_state).is_equal(A)
	T0.trigger()
	assert_that(sm.current_state).is_equal(B)

func test_state_machine__set_initial_state_03() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var C: GPSM.State = sm.new_state()
	assert_that(sm.current_state).is_null()
	sm.initialize()
	assert_that(sm.current_state).is_equal(A)

func test_state_machine__set_initial_state_02() -> void:
	var sm: GPSM = GPSM.new()
	assert_that(sm.current_state).is_null()
	await assert_error(func (): sm.initialize()).is_push_warning('cannot initialize machine containing no states')

func test_state_machine__set_initial_state_01() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var C: GPSM.State = sm.new_state()
	assert_that(sm.current_state).is_null()
	sm.initialize(A)
	assert_that(sm.current_state).is_equal(A)

func test_state_machine__set_initial_state_00() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	sm.initial_state = B
	assert_that(sm.current_state).is_null()
	sm.initialize()
	assert_that(sm.current_state).is_equal(B)

func test_state_machine__add_transitions() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	assert_int(len(sm.transitions)).is_equal(0)
	var T0: GPSM.Transition = sm.new_transition(A, B)
	assert_int(len(sm.transitions)).is_equal(1)
	var T1: GPSM.Transition = sm.new_transition(B, A)
	assert_int(len(sm.transitions)).is_equal(2)

func test_state_machine__add_states() -> void:
	var sm: GPSM = GPSM.new()
	assert_int(len(sm.states)).is_equal(0)
	var A: GPSM.State = sm.new_state()
	assert_int(len(sm.states)).is_equal(1)
	var B: GPSM.State = sm.new_state()
	assert_int(len(sm.states)).is_equal(2)

func test_state_machine__make_new() -> void:
	var sm: GPSM = GPSM.new()
	assert_that(sm).is_not_null()
