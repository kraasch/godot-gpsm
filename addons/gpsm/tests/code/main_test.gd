# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://addons/gpsm/code/main.gd'

func test_state_machine__add_transitions() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = GPSM.State.new()
	var B: GPSM.State = GPSM.State.new()
	var T0: GPSM.Transition = GPSM.Transition.new(A, B)
	var T1: GPSM.Transition = GPSM.Transition.new(B, A)
	sm.add_state(A)
	sm.add_state(B)
	assert_int(len(sm.get_transitions())).is_equal(0)
	sm.add_transition(T0)
	assert_int(len(sm.get_transitions())).is_equal(1)
	sm.add_transition(T1)
	assert_int(len(sm.get_transitions())).is_equal(2)

func test_state_machine__add_states() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = GPSM.State.new()
	var B: GPSM.State = GPSM.State.new()
	assert_int(len(sm.get_states())).is_equal(0)
	sm.add_state(A)
	assert_int(len(sm.get_states())).is_equal(1)
	sm.add_state(B)
	assert_int(len(sm.get_states())).is_equal(2)

func test_state_machine__make_new() -> void:
	var sm: GPSM = GPSM.new()
	assert_that(sm).is_not_null()
