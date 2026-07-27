# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://addons/gpsm/code/main.gd'

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

func test_state_machine__set_initial_state() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = sm.new_state()
	var B: GPSM.State = sm.new_state()
	var T0: GPSM.Transition = sm.new_transition(A, B)
	var T1: GPSM.Transition = sm.new_transition(B, A)
	sm.initial_state = A
	assert_that(sm.current_state).is_null()
	sm.initialize()
	assert_that(sm.current_state).is_equal(A)

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
