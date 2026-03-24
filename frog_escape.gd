extends Node2D

# Preload obstacles
var saw_scene = preload("res://obstacles/saw.tscn")
var spikes_scene = preload("res://obstacles/spikes.tscn")
var saw_heights := [200, 390]
const GROUND_Y := 480

# Game variables
var score: int
var speed: float
var game_runnig: bool
var active_obstacles := []
const SCORE_MODIFIER: int = 10
const START_SPEED: float = 10.0
const SPEED_MODIFIER: int = 5000

func _ready():
	$GameOver.get_node("Button").pressed.connect(new_game)
	$Win.get_node("Button").pressed.connect(new_game)
	$ObsTimer.timeout.connect(generate_obs)
	new_game()

func new_game():
	score = 0.0
	show_score()
	game_runnig = false
	get_tree().paused = false
	$ObsTimer.stop()

	for obstacle in active_obstacles:
		obstacle.queue_free()
	active_obstacles.clear()

	$Frog.game_started = false
	$Frog.position = Vector2(200, 300)

	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	$Win.hide()

func _process(delta):
	if game_runnig:
		speed = START_SPEED + score / SPEED_MODIFIER
		move_obs(delta)
		score += speed
		show_score()
		
		if score / SCORE_MODIFIER >= 10000:
			win()
	else:
		if Input.is_action_pressed("jump"):
			game_runnig = true
			$HUD.get_node("StartLabel").hide()
			$Frog.game_started = true
			$ObsTimer.start()

func generate_obs():
	if not game_runnig:
		return

	var obstacle
	if randi() % 2 == 0:
		obstacle = saw_scene.instantiate()
		obstacle.position = Vector2(randf_range(1400, 1600), randf_range(saw_heights[0], saw_heights[1]))
	else:
		obstacle = spikes_scene.instantiate()
		obstacle.position = Vector2(randf_range(1400, 1600), GROUND_Y)

	obstacle.body_entered.connect(hit_obs)
	add_child(obstacle)
	active_obstacles.append(obstacle)

	$ObsTimer.wait_time = randf_range(1.0, 2.5) / (speed / START_SPEED)
	

func move_obs(delta):
	var to_remove = []
	for obstacle in active_obstacles:
		obstacle.position.x -= speed * 50 * delta
		if obstacle.position.x < -100:
			to_remove.append(obstacle)
	for obstacle in to_remove:
		active_obstacles.erase(obstacle)
		obstacle.queue_free()

func hit_obs(body):
	if body.name == "Frog":
		game_over()

func game_over():
	$HitSound.play()
	get_tree().paused = true
	game_runnig = false
	$ObsTimer.stop()
	$GameOver.show()
	
func win():
	$WinSound.play()
	get_tree().paused = true
	game_runnig = false
	$ObsTimer.stop()
	$Win.show()

func show_score():
	$HUD.get_node("ScoreLabel").text = "PUNTOS: " + str(score / SCORE_MODIFIER)
