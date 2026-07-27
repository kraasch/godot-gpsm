# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://addons/gpsm/code/main.gd'

func test_state_machine__add_states() -> void:
	var sm: GPSM = GPSM.new()
	var A: GPSM.State = GPSM.State.new()
	var B: GPSM.State = GPSM.State.new()
	sm.add_state(A)
	sm.add_state(B)
	assert_that(sm).is_not_null()

func test_state_machine__make_new() -> void:
	var sm: GPSM = GPSM.new()
	assert_that(sm).is_not_null()
