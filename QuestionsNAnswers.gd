extends VBoxContainer


@export var button_a: Button
@export var button_b: Button
@export var button_c: Button
@export var button_d: Button

@onready var question_text = get_node("TitleHbox/PanelContainer/CenterContainer/RichTextLabel")
@onready var buttons = {
	"A": button_a, "B": button_b, 
	"C": button_c, "D": button_d
}

var current_question: Dictionary
var locked_option: String = ""
var question_no: int
var correct_option: String
var game_state: int

signal answered(is_correct)
signal locked


func _ready():
	for button in buttons.values():
		button.toggled.connect(func(_pressed): lock_answer(button))


func _input(event: InputEvent):
	if event.is_action_pressed("lock_option_a"):
		lock_answer(buttons["A"])
	elif event.is_action_pressed("lock_option_c"):
		lock_answer(buttons["B"])
	elif event.is_action_pressed("lock_option_b"):
		lock_answer(buttons["C"])
	elif event.is_action_pressed("lock_option_d"):
		lock_answer(buttons["D"])


func on_game_state_changed(state: int):
	game_state = state
	match state:
		Game.GAME_STATE.empty:
			reset_ui()
			show()
		Game.GAME_STATE.question:
			setup_next_question()
			question_text.visible = true
		Game.GAME_STATE.A:
			button_a.show_text()
		Game.GAME_STATE.B:
			button_b.show_text()
		Game.GAME_STATE.C:
			button_c.show_text()
		Game.GAME_STATE.D:
			button_d.show_text()
		Game.GAME_STATE.answered:
			check()


func on_fty_fty():
	if game_state != Game.GAME_STATE.D: return
	
	var hidden_count = 0
	var first_rand = -INF
	while hidden_count < 2:
		print ("randi() mod %d + %d" % [Game.GAME_STATE.D - Game.GAME_STATE.A + 1, Game.GAME_STATE.A])
		var rand = randi() % (Game.GAME_STATE.D - Game.GAME_STATE.A + 1) + Game.GAME_STATE.A
		
		# Do not double select the same button we want 50/50
		if first_rand == rand:
			continue
		
		# We do not want to hide a correct option
		if Game.GAME_STATE.keys()[rand] != correct_option:
			hidden_count += 1
			print(Game.GAME_STATE.keys()[rand])
			buttons[Game.GAME_STATE.keys()[rand]].get_node("Margin").visible = false
			first_rand = rand


func reset_ui():
	question_text.hide()
	for button in buttons.values():
		# If advanced into next game mode, the animation player
		# might still be animating
		button.stop_animations()
		# The button might have an override for indicating
		# correct (green) or wrong (red)
		button.remove_theme_stylebox_override("normal")
		button.hide_text()
		button.toggle_mode = true


func setup_next_question():
	var next_question = $QuestionManager.get_next_question()
	if next_question == null: return
	
	question_text.visible = false
	current_question = next_question
	
	question_text.text = "[center]%s[/center]" % current_question["question"]
	button_a.button_text = current_question["A"]
	button_b.button_text = current_question["B"]
	button_c.button_text = current_question["C"]
	button_d.button_text = current_question["D"]

	correct_option = current_question["correct"]


func check():
	if locked_option == "": return
	
	var locked_button = buttons[locked_option]
	locked_button.button_pressed = false
	locked_button.focus_mode = Control.FOCUS_NONE
	if locked_option == correct_option:
		answered.emit(true)
		locked_button.start_animation("Correct")
	else: 
		answered.emit(false)
		locked_button.start_animation("Wrong")
		# Indicate which would have been the right option
		buttons[correct_option].start_animation("Correct")


func lock_answer(locked_button: Button):
	for b in buttons.values():
		if b != locked_button:
			b.button_pressed = false
	
	locked_option = locked_button.name
	locked.emit()
