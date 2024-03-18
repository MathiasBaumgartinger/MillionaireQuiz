extends Control


func on_game_state_changed(game_state):
	match game_state:
		Game.GAME_STATE.intro:
			$VideoPlayer.play()
		Game.GAME_STATE.opening:
			var tween = get_tree().create_tween()
			tween.stop()
			tween.tween_property(
				$ColorRect, "color", 
				Color.TRANSPARENT, 1
			)
			tween.play()
		Game.GAME_STATE.lets_play:
			hide()
