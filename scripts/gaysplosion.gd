extends CPUParticles2D

func _physics_process(_delta: float) -> void:
	if !is_emitting():
		queue_free()
