# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var _SM: GPSM
var _A: GPSM.State
var _B: GPSM.State
var _C: GPSM.State
var _D: GPSM.State
var _T0: GPSM.Transition
var _T1: GPSM.Transition
var _T2: GPSM.Transition
var _T3: GPSM.Transition
var _T4: GPSM.Transition
var _T5: GPSM.Transition

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

# TestSuite generated from
const __source: String = 'res://addons/gpsm/code/main.gd'

func test_state_machine__enable_transition_warnings__enable_individual_triggers() -> void:
	_setup_testing_state_machine()
	_SM.initialize()
	_SM.throw_type = GPSM.THROW_TYPE.SILENT
	_T3.throw_type = GPSM.THROW_TYPE.WARNING
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T0.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_warning('state was S#1, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_B)
	_T3.throw_type = GPSM.THROW_TYPE.ERROR
	await assert_error(func (): _T1.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_error('state was S#0, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T4.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_C)
	await assert_error(func (): _T2.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_D)
	_T3.throw_type = GPSM.THROW_TYPE.WARNING
	await assert_error(func (): _T3.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_warning('state was S#2, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_C)

func test_state_machine__enable_transition_warnings__with_errors() -> void:
	_setup_testing_state_machine()
	_SM.initialize()
	_SM.throw_type = GPSM.THROW_TYPE.ERROR
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T0.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_error('state was S#1, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_B)
	await assert_error(func (): _T1.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_error('state was S#0, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T4.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_push_error('state was S#2, but transition T#1 (from S#1 to S#0) triggered.')
	assert_that(_SM.current_state).is_equal(_C)
	await assert_error(func (): _T2.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_push_error('state was S#3, but transition T#1 (from S#1 to S#0) triggered.')
	assert_that(_SM.current_state).is_equal(_D)
	await assert_error(func (): _T3.trigger()).is_success()
	await assert_error(func (): _T0.trigger()).is_push_error('state was S#2, but transition T#0 (from S#0 to S#1) triggered.')
	assert_that(_SM.current_state).is_equal(_C)

func test_state_machine__enable_transition_warnings__with_warnings() -> void:
	_setup_testing_state_machine()
	_SM.initialize()
	_SM.throw_type = GPSM.THROW_TYPE.WARNING
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T0.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_warning('state was S#1, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_B)
	await assert_error(func (): _T1.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_push_warning('state was S#0, but transition T#3 (from S#3 to S#2) triggered.')
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T4.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_push_warning('state was S#2, but transition T#1 (from S#1 to S#0) triggered.')
	assert_that(_SM.current_state).is_equal(_C)
	await assert_error(func (): _T2.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_push_warning('state was S#3, but transition T#1 (from S#1 to S#0) triggered.')
	assert_that(_SM.current_state).is_equal(_D)
	await assert_error(func (): _T3.trigger()).is_success()
	await assert_error(func (): _T0.trigger()).is_push_warning('state was S#2, but transition T#0 (from S#0 to S#1) triggered.')
	assert_that(_SM.current_state).is_equal(_C)

func test_state_machine__enable_transition_warnings__no_warnings() -> void:
	_setup_testing_state_machine()
	_SM.initialize()
	_SM.throw_type = GPSM.THROW_TYPE.SILENT
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T0.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_B)
	await assert_error(func (): _T1.trigger()).is_success()
	await assert_error(func (): _T3.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_A)
	await assert_error(func (): _T4.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_C)
	await assert_error(func (): _T2.trigger()).is_success()
	await assert_error(func (): _T1.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_D)
	await assert_error(func (): _T3.trigger()).is_success()
	await assert_error(func (): _T0.trigger()).is_success()
	assert_that(_SM.current_state).is_equal(_C)

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

func test_state_machine__trigger_transition_01() -> void:
	_setup_testing_state_machine()
	_SM.initialize()
	assert_that(_SM.current_state).is_equal(_A)
	_T0.trigger()
	assert_that(_SM.current_state).is_equal(_B)
	_T1.trigger()
	assert_that(_SM.current_state).is_equal(_A)
	_T4.trigger()
	assert_that(_SM.current_state).is_equal(_C)
	_T2.trigger()
	assert_that(_SM.current_state).is_equal(_D)
	_T3.trigger()
	assert_that(_SM.current_state).is_equal(_C)

func test_state_machine__trigger_transition_00() -> void:
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
