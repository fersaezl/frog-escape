extends Node2D

var score: float

func _ready():
	new_game()

func new_game():
	score = 0.0
	


func _process(delta):
	score += 10.0 * delta
	print(score)
