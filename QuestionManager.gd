extends Node


export(String, FILE, ".json") var questions_file

var questions: Array


func _ready():
	var f = File.new()
	f.open(questions_file, File.READ)
	var json = JSON.parse(f.get_as_text())
	
	if json.error != OK:
		print("Something went wrong while parsing questions ...")
		return
	
	questions = json.result["questions"]


func get_next_question():
	return questions.pop_front()
