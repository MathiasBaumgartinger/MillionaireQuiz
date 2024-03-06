extends Node


@export var opening: AudioStream
@export var lets_play: AudioStream
@export var lights_to_center: AudioStream
@export var questions_1to5: AudioStream
@export var questions_from6: AudioStream
@export var final_answer_from6: AudioStream
@export var questions_1to4_win: AudioStream
@export var questions_1to4_lose: AudioStream
@export var question_5_win: AudioStream
@export var question_5_lose: AudioStream
@export var question_from6_win: AudioStream
@export var question_from6_lose: AudioStream
@export var questions_from11: AudioStream
@export var questions_from11_win: AudioStream
@export var questions_from11_lose: AudioStream
@export var lights_to_center_1to5: AudioStream
@export var lights_to_center_from6: AudioStream
@export var question_millionaire_win: AudioStream

@export var phone_a_friend: AudioStream
@export var ask_audience: AudioStream
@export var fty_fty: AudioStream

enum JOKER {
	phone,
	audience,
	fty_fty
}

func play(game_state: int, question_no: int):
	match game_state:
		Game.GAME_STATE.lets_play:
			lets_play.loop = false
			$MusicPlayer2.stream = lets_play
			$MusicPlayer2.playing = true
		Game.GAME_STATE.opening:
			opening.loop = false
			$MusicPlayer3.stream = opening
			$MusicPlayer3.playing = true
		Game.GAME_STATE.question:
			if question_no == 1 or question_no == 5:
				$MusicPlayer2.stream = lights_to_center_1to5
				$MusicPlayer2.stream.loop = false
				$MusicPlayer2.playing = true
			elif question_no > 6:
				$MusicPlayer2.stream = lights_to_center_from6
				$MusicPlayer2.stream.loop = false
				$MusicPlayer2.playing = true				
			if question_no <= 5:
				if $MusicPlayer1.playing: return
				$MusicPlayer1.stream = questions_1to5
			elif question_no <= 10:
				$MusicPlayer1.stream = questions_from6
			else:
				$MusicPlayer1.stream = questions_from11
			$MusicPlayer1.playing = true
		Game.GAME_STATE.locked:
			if question_no > 5:
				$MusicPlayer1.playing = false
				final_answer_from6.loop = false
				$MusicPlayer2.stream = final_answer_from6
				$MusicPlayer2.playing = true
		Game.GAME_STATE.correct:
			if question_no < 5:
				$MusicPlayer2.stream = questions_1to4_win
			elif question_no == 5 or question_no == 10:
				$MusicPlayer2.stream = question_5_win
				$MusicPlayer1.playing = false
			elif question_no == 15:
				$MusicPlayer2.stream = question_millionaire_win
			else:
				$MusicPlayer2.stream = question_from6_win
			$MusicPlayer2.stream.loop = false
			$MusicPlayer2.playing = true
		Game.GAME_STATE.wrong:
			if question_no < 5:
				$MusicPlayer2.stream = questions_1to4_lose
			elif question_no == 5:
				$MusicPlayer2.stream = question_5_lose
			else:
				$MusicPlayer2.stream = question_from6_lose
			$MusicPlayer2.stream.loop = false
			$MusicPlayer2.playing = true
		_: return


func on_fty_fty():
	#$MusicPlayer1.playing = false
	$JokerPlayer.stream = fty_fty
	$JokerPlayer.stream.loop = false
	$JokerPlayer.play()
	#yield($JokerPlayer, "finished")
	#$MusicPlayer1.play()
