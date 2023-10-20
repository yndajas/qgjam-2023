extends CharacterBody2D

const SPEED = 600.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	move_and_slide()
