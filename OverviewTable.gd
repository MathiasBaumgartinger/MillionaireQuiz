extends PanelContainer


@onready var item_list = $VBoxContainer/ItemList

var toggled := false

signal ftyfty 
signal phone
signal audience


func _ready():
	position.x = get_viewport_rect().size.x - size.x
	get_tree().get_root().size_changed.connect(_adapt_size)
	item_list.select(item_list.get_item_count() - 1)
	
	$VBoxContainer/JokerContainer/FtyFtyButton.pressed.connect(emit_signal.bind("ftyfty"))
	$VBoxContainer/JokerContainer/CallButton.pressed.connect(emit_signal.bind("ftyfty"))
	$VBoxContainer/JokerContainer/AudienceButton.pressed.connect(emit_signal.bind("ftyfty"))
	$VBoxContainer/JokerContainer/FtyFtyButton.pressed.connect(_disable_button.bind($VBoxContainer/JokerContainer/FtyFtyButton))
	$VBoxContainer/JokerContainer/CallButton.pressed.connect(_disable_button.bind($VBoxContainer/JokerContainer/CallButton))
	$VBoxContainer/JokerContainer/AudienceButton.pressed.connect(_disable_button.bind($VBoxContainer/JokerContainer/AudienceButton))


func _disable_button(button):
	button.disabled = true


func _adapt_size():
	visible = false
	toggled = false


func on_question_no_changed(no):
	item_list.select(item_list.get_item_count() - no)


func _input(event):
	if event.is_action_pressed("toggle_overview"):
		visible = true
		if !toggled:
			var interpolation_tween = get_tree().create_tween()
			interpolation_tween.set_trans(Tween.TRANS_CUBIC)
			interpolation_tween.set_ease(Tween.EASE_IN_OUT)
			interpolation_tween.tween_property(
				self, "position:x", 
				get_viewport_rect().size.x - size.x, 0.5
			)
			interpolation_tween.play()
			await interpolation_tween.finished
		else:
			var interpolation_tween = get_tree().create_tween()
			interpolation_tween.set_trans(Tween.TRANS_CUBIC)
			interpolation_tween.set_ease(Tween.EASE_IN_OUT)
			interpolation_tween.tween_property(
					self, "position:x", 
					get_viewport_rect().size.x, 0.5
				)
			interpolation_tween.play()
			await interpolation_tween.finished
			
		toggled = !toggled
