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
	corret,
	wrong
}

var game_state: int = 0 setget set_game_state
var question_no: int = 1 setget set_question_no

signal game_state_changed(game_state)
signal question_no_changed(question_no)
signal check


func set_question_no(no: int):
	emit_signal("question_no_changed", no)
	question_no = no


func set_game_state(state):
	if(game_state == GAME_STATE.question): set_question_no(question_no + 1)
	print("Setting game state: " + GAME_STATE.keys()[state])
	emit_signal("game_state_changed", state)
	$MusicManager.play(state, question_no)
	game_state = state


func _ready():
	connect("game_state_changed", $VBoxContainer, "on_game_state_changed")
	connect("check", $VBoxContainer, "check")
	connect("game_state_changed", self, "_on_game_state_changed")
	$VBoxContainer.connect("answered", self, "on_answered")
	$VBoxContainer.connect("locked", self, "on_locked")


func _input(event):
	if event.is_action_pressed("progress_state"):
		progress()


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
	set_game_state(GAME_STATE.corret) if is_correct else set_game_state(GAME_STATE.wrong)


func progress():
	print("Current state: " + GAME_STATE.keys()[game_state])
	match game_state:
		GAME_STATE.corret: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.wrong: 
			set_game_state(GAME_STATE.empty)
		GAME_STATE.D:
			return
		GAME_STATE.locked:
			emit_signal("check")
		_: 
			set_game_state(game_state + 1)
