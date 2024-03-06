extends Node


@export_file var questions_file

var questions: Array


func _ready():
	var f = FileAccess.open(questions_file, FileAccess.READ)
	var json = JSON.new()
	var err = json.parse(f.get_as_text())
	
	if err != OK:
		print("Something went wrong while parsing questions ...")
		print("JSON Parse Error: ", json.get_error_message(), 
				" at line ", json.get_error_line())
		return
	
	questions = json.data["questions"]


func get_next_question():
	return questions.pop_front()
