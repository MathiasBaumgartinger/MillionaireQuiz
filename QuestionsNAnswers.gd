extends VBoxContainer


onready var button_a = get_node("HBoxContainer/A")
onready var button_b = get_node("HBoxContainer/B")
onready var button_c = get_node("HBoxContainer2/C")
onready var button_d = get_node("HBoxContainer2/D")
onready var button_a_text = get_node("HBoxContainer/A/Margin/HBox/Label")
onready var button_b_text = get_node("HBoxContainer/B/Margin/HBox/Label")
onready var button_c_text = get_node("HBoxContainer2/C/Margin/HBox/Label")
onready var button_d_text = get_node("HBoxContainer2/D/Margin/HBox/Label")
onready var question_text = get_node("TitleHbox/PanelContainer/CenterContainer/RichTextLabel")
onready var buttons = {
	"A": button_a, "B": button_b, 
	"C": button_c, "D": button_d
}
onready var normal_sb = load("res://ThemeElements/TemplateNormal.tres").duplicate()

var locked_button
var current_question: Dictionary
var locked_option: String
var question_no: int
var correct_option: String

signal answered(is_correct)
signal locked


func _ready():
	for button in buttons.values():
		button.connect("toggled", self, "_question_locked", [button])


func on_game_state_changed(game_state: int):
	match game_state:
		Game.GAME_STATE.question:
			reset_buttons()
			setup_next_question()
			question_text.visible = true
		Game.GAME_STATE.A:
			$HBoxContainer/A/Margin.visible = true
		Game.GAME_STATE.B:
			$HBoxContainer/B/Margin.visible = true
		Game.GAME_STATE.C:
			$HBoxContainer2/C/Margin.visible = true
		Game.GAME_STATE.D:
			$HBoxContainer2/D/Margin.visible = true
			


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


func setup_next_question():
	var next_question = $QuestionManager.get_next_question()
	if next_question == null: return
	
	question_text.visible = false
	current_question = next_question
	
	question_text.bbcode_text = "[center]%s[/center]" % current_question["question"]
	button_a_text.text = current_question["A"]
	button_b_text.text = current_question["B"]
	button_c_text.text = current_question["C"]
	button_d_text.text = current_question["D"]
	correct_option = current_question["correct"]


func check():
	if locked_option == null: return
	
	var locked_button: Button = buttons[locked_option]
	locked_button.pressed = false
	locked_button.focus_mode = Control.FOCUS_NONE
	if locked_option == correct_option:
		emit_signal("answered", true)
		animate(locked_button,
			load("res://ThemeElements/TemplateCorrect.tres").duplicate())
	else: 
		emit_signal("answered", false)
		animate(locked_button,
			load("res://ThemeElements/TemplateWrong.tres").duplicate()) 


func _question_locked(presssed: bool, button: Button):
	for b in buttons.values():
		if b != button:
			b.pressed = false
	
	locked_option = button.name
	emit_signal("locked")
