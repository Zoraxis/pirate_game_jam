extends StaticBody2D

@export var SPEED = 500.0
var coef = 1.05
var knockback = 70
var rotated = 1
var damage = 1
	
func _ready():
	name = "bullet" + str(U.getTime())
	die(1)
	
func _physics_process(delta):
	SPEED *= coef
	var velocity = Vector2(1 * rotated, 0) * SPEED * delta
	move_and_collide(velocity)

func die(time: float):
	await U.delay(time)
	queue_free()
