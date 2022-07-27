extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var toggled := false
var animation_finished := true


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.connect("tween_all_completed", self, "set_animation_finished")
	anchor_left = 1
	anchor_right = 1


func set_animation_finished():
	animation_finished = true


func _input(event):
	if event.is_action_pressed("toggle_overview") and animation_finished:
		if !toggled: 
			animation_finished = false
			$Tween.interpolate_property(
				self, "anchor_left", 1, 0, 0.5
			)
		else:
			animation_finished = false
			$Tween.interpolate_property(
				self, "anchor_left", 0, 1, 0.5
			)
			
		toggled = !toggled
