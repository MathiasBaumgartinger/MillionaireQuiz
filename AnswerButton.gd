extends Button

@export var label: String

var button_text: String :
	set(new_text):
		button_text = new_text
		$Margin/HBox/Q.text = new_text


func show_text(): $Margin.show()


func hide_text(): $Margin.hide()


func _ready():
	$Margin/HBox/Label.text = label


func start_animation(animation_name: String, speed_scale:=1.):
	$AnimationPlayer.current_animation = animation_name
	$AnimationPlayer.set_speed_scale(speed_scale)
	$AnimationPlayer.play()


func stop_animations():
	$AnimationPlayer.stop()
