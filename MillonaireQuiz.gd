extends Control
class_name Game

enum GAME_STATE {
	opening,
	lets_play,
	question,
	A,
	B,
	C,
	D,
	answering,
	locked,
	corret,
	wrong
}

onready var button_a = get_node("VBoxContainer/HBoxContainer/A")
onready var button_b = get_node("VBoxContainer/HBoxContainer/B")
onready var button_c = get_node("VBoxContainer/HBoxContainer2/C")
onready var button_d = get_node("VBoxContainer/HBoxContainer2/D")
onready var button_a_text = get_node("VBoxContainer/HBoxContainer/A/Margin/HBox/Label")
onready var button_b_text = get_node("VBoxContainer/HBoxContainer/B/Margin/HBox/Label")
onready var button_c_text = get_node("VBoxContainer/HBoxContainer2/C/Margin/HBox/Label")
onready var button_d_text = get_node("VBoxContainer/HBoxContainer2/D/Margin/HBox/Label")
onready var question_text = get_node("VBoxContainer/TitleHbox/PanelContainer/CenterContainer/RichTextLabel")
onready var buttons = {
	"A": button_a, "B": button_b, 
	"C": button_c, "D": button_d
}
onready var normal_sb = load("res://ThemeElements/TemplateNormal.tres").duplicate()

var correct_option: String
var game_state: int = 0 setget set_game_state
var locked_option: String
var current_question: Dictionary
var question_no = 0


func set_game_state(state):
	print(GAME_STATE.keys()[state])
	$MusicManager.play(state, question_no)
	game_state = state


func _ready():
	for button in buttons.values():
		button.connect("toggled", self, "_question_locked", [button])
	reset_buttons()
	setup_next_question()


func _input(event):
	if event.is_action_pressed("progress_state"):
		progress()


func progress():
	match game_state:
		GAME_STATE.question:
			question_text.visible = true
			set_game_state(GAME_STATE.A)
		GAME_STATE.A:
			$VBoxContainer/HBoxContainer/A/Margin.visible = true
			set_game_state(GAME_STATE.B)
		GAME_STATE.B:
			$VBoxContainer/HBoxContainer/B/Margin.visible = true
			set_game_state(GAME_STATE.C)
		GAME_STATE.C:
			$VBoxContainer/HBoxContainer2/C/Margin.visible = true
			set_game_state(GAME_STATE.D)
		GAME_STATE.D:
			$VBoxContainer/HBoxContainer2/D/Margin.visible = true
			set_game_state(GAME_STATE.answering)
		GAME_STATE.locked: 
			check()
		GAME_STATE.corret: 
			reset_buttons()
			setup_next_question()
			set_game_state(GAME_STATE.question)
		GAME_STATE.wrong: 
			reset_buttons()
			setup_next_question()
			set_game_state(GAME_STATE.question)
		GAME_STATE.answering:
			return
		_: 
			set_game_state(game_state + 1)


func _question_locked(presssed: bool, button: Button):
	for b in buttons.values():
		if b != button:
			b.pressed = false
	
	locked_option = button.name
	set_game_state(GAME_STATE.locked)


func check():
	if locked_option == null: return
	
	var locked_button: Button = buttons[locked_option]
	locked_button.pressed = false
	locked_button.focus_mode = Control.FOCUS_NONE
	if locked_option == correct_option:
		set_game_state(GAME_STATE.corret)
		animate(locked_button,
			load("res://ThemeElements/TemplateCorrect.tres").duplicate())
	else: 
		set_game_state(GAME_STATE.wrong)
		animate(locked_button,
			load("res://ThemeElements/TemplateWrong.tres").duplicate())


func setup_next_question():
	var next_question = $QuestionManager.get_next_question()
	if next_question == null: return
	
	question_text.visible = false
	current_question = next_question
	question_no += 1
	
	question_text.bbcode_text = "[center]%s[/center]" % current_question["question"]
	button_a_text.text = current_question["A"]
	button_b_text.text = current_question["B"]
	button_c_text.text = current_question["C"]
	button_d_text.text = current_question["D"]
	correct_option = current_question["correct"]


func animate(locked_button, stylebox):
	locked_button.theme.set_stylebox("normal", "Button", stylebox)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", normal_sb)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", stylebox)
	yield(get_tree().create_timer(0.3), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", normal_sb)
	yield(get_tree().create_timer(0.3), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", stylebox)


func reset_buttons():
	for button in buttons.values():
		button.theme = load("res://MillonaireTheme.tres").duplicate()
		button.get_node("Margin").visible = false
		button.toggle_mode = true
