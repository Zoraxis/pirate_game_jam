extends Area2D

const SPEED = 25
var activated = false
@export var distance = 100

func _physics_process(delta):
	if not activated or distance <= 0:
		return
	
	var velocity = Vector2(0,0)
	
	velocity.y = SPEED * delta
	distance -= SPEED * delta
	
	$rope_drive.move_and_collide(velocity)


func _on_body_entered(body):
	await U.delay(0.3)
	activated = true
