extends StaticBody2D

@export var SPEED = 2500.0
var coef = 1.05
var knockback = 70
var rotated = 1
var damage = 1
	
func _physics_process(delta):
	SPEED *= coef
	var velocity = Vector2(1 * rotated, 0) * SPEED * delta
	move_and_collide(velocity)

func die(delay: float):
	await get_tree().create_timer(delay)
	queue_free()
