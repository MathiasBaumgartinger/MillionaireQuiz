extends Control
class_name Game

enum GAME_STATE {
	opening,
	lets_play,
	empty,
	question,
	A,
	B,
	C,
	D,
	locked,
	correct,
	wrong
}

var game_state := -1 setget set_game_state
var question_no := 1 setget set_question_no
var is_fist_progression := true

signal game_state_changed(game_state)
signal question_no_changed(question_no)
signal check


func set_question_no(no: int):
	emit_signal("question_no_changed", no)
	question_no = no


func set_game_state(state):
	if game_state == GAME_STATE.correct: set_question_no(question_no + 1)
	if game_state == GAME_STATE.wrong: set_question_no(question_no + 1)
	emit_signal("game_state_changed", state)
	$MusicManager.play(state, question_no)
	game_state = state


func _ready():
	_adapt_font_size()
	$Intro.visible = true
	$Overview/OverviewTable.visible = false
	$VBoxContainer.visible = false
	get_tree().get_root().connect("size_changed", self, "_adapt_font_size")
	connect("game_state_changed", $VBoxContainer, "on_game_state_changed")
	connect("check", $VBoxContainer, "check")
	connect("game_state_changed", self, "_on_game_state_changed")
	$VBoxContainer.connect("answered", self, "on_answered")
	$VBoxContainer.connect("locked", self, "on_locked")
	connect("question_no_changed", $Overview/OverviewTable, "on_question_no_changed")
	$Overview/OverviewTable.connect("ftyfty", $VBoxContainer, "on_fty_fty")
	$Intro/VideoPlayer.connect("finished", $Intro/VideoPlayer, "set_visible", [false])
	$Intro/VideoPlayer.connect("finished", $Intro/Tween, "interpolate_property", [$Intro/ColorRect, "color", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 3])


func _input(event):
	if event.is_action_pressed("progress_state"):
		progress()


func _adapt_font_size():
	var font: DynamicFont = preload("res://ThemeElements/TextWhite.tres")
	font.size = int(get_viewport_rect().size.y * 0.025)


func _on_game_state_changed(game_state: int):
	match game_state:
		GAME_STATE.empty:
			$VBoxContainer.visible = false
		GAME_STATE.question:
			$VBoxContainer.visible = true
		_: return


func on_locked():
	set_game_state(GAME_STATE.locked)


func on_answered(is_correct):
	set_game_state(GAME_STATE.correct) if is_correct else set_game_state(GAME_STATE.wrong)


func progress():
	print("Current state: " + GAME_STATE.keys()[game_state])
	if is_fist_progression:
		is_fist_progression = false
		$Intro/VideoPlayer.play()
		
		
	match game_state:
		GAME_STATE.opening:
			$Intro/Tween.interpolate_property(
				$Intro/ColorRect, "color:a", 
				1, 0,
				3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
			)
			$Intro/Tween.set_active(true)
			set_game_state(game_state + 1)
		GAME_STATE.lets_play:
			$Intro.visible = false
			set_game_state(game_state + 1)
		GAME_STATE.correct: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.wrong: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.D:
			return
		GAME_STATE.locked:
			emit_signal("check")
		_: 
			set_game_state(game_state + 1)
