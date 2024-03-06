extends Control
class_name Game

enum GAME_STATE {
	idle,
	intro,
	opening,
	lets_play,
	empty,
	question,
	A,
	B,
	C,
	D,
	locked,
	answered,
	correct,
	wrong
}

@onready var interpolation_tween := get_tree().create_tween()

var game_state := GAME_STATE.opening : set=set_game_state
var question_no := 1 : set=set_question_no

signal game_state_changed(game_state)
signal question_no_changed(question_no)


func set_question_no(no: int):
	question_no_changed.emit(no)
	question_no = no


func set_game_state(state):
	game_state = state
	if game_state == GAME_STATE.correct: set_question_no(question_no + 1)
	if game_state == GAME_STATE.wrong: set_question_no(question_no + 1)
	game_state_changed.emit(state)
	$MusicManager.play(state, question_no)


func _ready():
	interpolation_tween.stop()
	
	_adapt_font_size()
	
	$Intro.visible = true
	$Overview/OverviewTable.visible = false
	$QuestionsNAnswers.visible = false
	
	# FIXME: something does not work yet
	get_tree().get_root().size_changed.connect(_adapt_font_size)
	
	$QuestionsNAnswers.locked.connect(set_game_state.bind(GAME_STATE.locked))
	$QuestionsNAnswers.answered.connect(func(is_correct): 
		set_game_state(GAME_STATE.correct if is_correct else GAME_STATE.wrong))
	
	game_state_changed.connect($QuestionsNAnswers.on_game_state_changed)
	game_state_changed.connect($Intro.on_game_state_changed)
	
	question_no_changed.connect($Overview/OverviewTable.on_question_no_changed)
	$Overview/OverviewTable.ftyfty.connect($QuestionsNAnswers.on_fty_fty)
	$Intro/VideoPlayer.finished.connect($Intro/VideoPlayer.set_visible.bind(false))


func _input(event: InputEvent):
	if event.is_action_pressed("progress_state"):
		progress()


func _adapt_font_size():
	theme.set_font_size("default", "default", int(get_viewport_rect().size.y * 0.025))


func progress():
	match game_state:
		GAME_STATE.correct: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.wrong: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.D:
			return
		_: 
			set_game_state(game_state + 1)
	
	print("Current state: " + GAME_STATE.keys()[game_state])
