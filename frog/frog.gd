extends CharacterBody2D

const JUMP_SPEED = -600
const GRAVITY = 1500
var game_started: bool = false

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	# Saltar
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED
		$JumpSound.play()

	# Aplicar movimiento
	move_and_slide()

	# Determinar estado y actualizar animación y colisión
	if not is_on_floor():
		if velocity.y < 0:
			_set_state("jump")    # subiendo
		else:
			_set_state("fall")    # cayendo
	else:
		if game_started:
			_set_state("run")     # corriendo
		else: 
			_set_state("idle")    # en el suelo
	
	# Aplicar movimiento
	move_and_slide()
	
	# Función que cambia animación y colisiones según el estado
func _set_state(state: String):
	match state:
		"idle":
			%FrogImgs.animation = "idle"
			$IdleCol.disabled = false
			$RunCol.disabled = true
			$JumpCol.disabled = true
			$FallCol.disabled = true
		"run":
			%FrogImgs.animation = "run"
			$IdleCol.disabled = true
			$RunCol.disabled = false
			$JumpCol.disabled = true
			$FallCol.disabled = true
		"jump":
			%FrogImgs.animation = "jump"
			$IdleCol.disabled = true
			$RunCol.disabled = true
			$JumpCol.disabled = false
			$FallCol.disabled = true
		"fall":
			%FrogImgs.animation = "fall"
			$IdleCol.disabled = true
			$RunCol.disabled = true
			$JumpCol.disabled = true
			$FallCol.disabled = false
