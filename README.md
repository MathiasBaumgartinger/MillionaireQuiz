# MillionaireQuiz

<img src="https://github.com/MathiasBaumgartinger/MillionaireQuiz/blob/main/Resources/demo.png">

Based on shows like "Who wants to be a Millionaire", this is a quiz template meant for easy personalization. Makes a great fit for the next wedding, bachelor's, or birthday party or just testing your friends. I have searched for something like this for my brother's birthday party and could not find anything. So I decided to create my own version and share it with you.

Using a `.json` file, you can easily add your own questions and answers.


## Music and Sound Effects

Due to copyright protection, the original music and sound effects of the show cannot be included. However, you can add your own music and sound effects to the project folder and adapt the export variables in the `MillionaireQuiz.tscn->MusicManager` node.

## Adding your own questions: JSON Format

Follow the `questions.json` format with the following structure:

```json
{
    "questions": [
        {
			"score": "easy",
			"question": "Who served as finance minister under Louis XIV?",
			"A": "Jean-Baptist Colbert",
			"B": "Jean-Jacques Monnoyer",
			"C": "Jules Mazarin",
			"D": "François de Louvois",
			"correct": "A"
		},
    ]
}
```

In the original show, different score-categories have different sound effects. This is implemented via the score-field (`easy`, `medium`, `hard`). This score determines the sound-effects being played when the question is answered correctly or incorrectly.

## Controls

- `Enter`: Advance game state
- `Click button`: Answer question
- `Tab`: Toggle overview and jokers
- `Click joker`: Use joker

## Sneak Peek into the Code

Ultimately, the quiz is based on different states, which are described by the `GAME_STATE`-enum in the `MillionaireQuiz.gd`-script with the following states:

- idle: waiting for the moderator to start the game
- intro: replay of the intro animation
- opening: opening audio is played
- lets_play: lets play audio is played
- empty: quiz format is shown without any text
- question: question is shown
- A: answer A is shown
- B: answer B is shown
- C: answer C is shown
- D: answer D is shown
- locked: an option is locked
- answered: the question has been answered
- correct: the answer was correct
- wrong: the answer was wrong

Once the game state hits empty, it runs in a loop from empty to correct or wrong and back to empty. In case you do not want to include the video sequence, you can set the current game state to opening (`var game_state := GAME_STATE.opening`).

Using signals, other components are notified by a change of the state. The `MusicManager.gd`-script is responsible for playing the music and sound effects. The `QuestionManager.gd`-script is responsible for loading the questions from the `questions.json`-file and displaying them on the screen.

## Theme

The theme is created by me myself and got accents of the original show with a very personal touch.

# Contributing

For discussion and support, please use the [issues](https://github.com/MathiasBaumgartinger/MillionaireQuiz/issues) section. Happy about any feedback and contributions. Feel free to open pull requests.
