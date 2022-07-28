extends PanelContainer


onready var item_list = $VBoxContainer/ItemList

var toggled := false
var animation_finished := true

signal ftyfty 


func _ready():
	get_tree().get_root().connect("size_changed", self, "_adapt_size")
	$Tween.connect("tween_completed", self, "set_animation_finished")
	item_list.select(item_list.get_item_count() - 1)
	$VBoxContainer/JokerContainer/FtyFtyButton.connect("pressed", self, "_emit_ftyfty")
	$VBoxContainer/JokerContainer/FtyFtyButton.connect("pressed", self, "_disable_button", [$VBoxContainer/JokerContainer/FtyFtyButton])
	$VBoxContainer/JokerContainer/CallButton.connect("pressed", self, "_disable_button", [$VBoxContainer/JokerContainer/CallButton])
	$VBoxContainer/JokerContainer/AudienceButton.connect("pressed", self, "_disable_button", [$VBoxContainer/JokerContainer/AudienceButton])


func _disable_button(button):
	button.disabled = true


func _emit_ftyfty():
	emit_signal("ftyfty")


func _adapt_size():
	visible = false
	toggled = false


func on_question_no_changed(no):
	item_list.select(item_list.get_item_count() - no)


func set_animation_finished(object, nodepath):
	animation_finished = true


func _input(event):
	#focus_mode =
	if event.is_action_pressed("toggle_overview") and animation_finished:
		visible = true
		if !toggled: 
			animation_finished = false
			$Tween.interpolate_property(
				self, "rect_position:x", 
				get_viewport_rect().size.x, get_viewport_rect().size.x - rect_size.x,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
			)
			$Tween.start()
		else:
			animation_finished = false
			$Tween.interpolate_property(
				self, "rect_position:x", 
				get_viewport_rect().size.x - rect_size.x, get_viewport_rect().size.x,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
			)
			$Tween.start()
			
		toggled = !toggled
