extends Control

enum GAME_STATE {
	question,
	locked,
	corret,
	wrong
}

onready var button_a = get_node("VBoxContainer/HBoxContainer/A")
onready var button_b = get_node("VBoxContainer/HBoxContainer/B")
onready var button_c = get_node("VBoxContainer/HBoxContainer2/C")
onready var button_d = get_node("VBoxContainer/HBoxContainer2/D")
onready var question_text = get_node("VBoxContainer/TitleHbox/PanelContainer/CenterContainer/RichTextLabel")
onready var buttons = {
	"A": button_a, "B": button_b, 
	"C": button_c, "D": button_d
}

var correct_option: String
var game_state: int = GAME_STATE.question
var locked_option: String

func _ready():
	for button in buttons.values():
		button.connect("toggled", self, "_question_locked", [button])
	setup_next_question()


func _input(event):
	if event.is_action_pressed("progress_state"):
		progress()


func progress():
	match game_state:
		1: check()
		2: 
			reset_buttons()
			setup_next_question()
		3: 
			reset_buttons()
			setup_next_question()
		_: return


func _question_locked(presssed: bool, button: Button):
	for button in buttons.values():
		button.pressed = false
		
	locked_option = button.name
	game_state = GAME_STATE.locked


func check():
	if locked_option == null: return
	
	var locked_button: Button = buttons[locked_option]
	locked_button.pressed = false
	locked_button.focus_mode = Control.FOCUS_NONE
	if locked_option == correct_option:
		game_state = GAME_STATE.corret
		animate(locked_button,
			load("res://ThemeElements/TemplateCorrect.tres").duplicate())
	else: 
		game_state = GAME_STATE.wrong
		animate(locked_button,
			load("res://ThemeElements/TemplateWrong.tres").duplicate())


func setup_next_question():
	var question = $QuestionManager.get_next_question()
	if question == null: return
	
	question_text.text = question["question"]
	button_a.text = question["A"]
	button_b.text = question["B"]
	button_c.text = question["C"]
	button_d.text = question["D"]
	correct_option = question["correct"]


func animate(locked_button, stylebox):
	var normal_sb = load("res://ThemeElements/TemplateNormal.tres").duplicate()
	locked_button.theme.set_stylebox("normal", "Button", stylebox)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", normal_sb)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", stylebox)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", normal_sb)
	yield(get_tree().create_timer(0.4), "timeout")
	locked_button.theme.set_stylebox("normal", "Button", stylebox)


func reset_buttons():
	for button in buttons.values():
		button.toggle_mode = true
		button.theme = load("res://MillonaireTheme.tres").duplicate()
