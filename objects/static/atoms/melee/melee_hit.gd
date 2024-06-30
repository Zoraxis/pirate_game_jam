extends StaticBody2D

var knockback = 300
var damage = 1

func _ready():
	name = "melee" + str(U.getTime())
	Global.log(name)
	die(0.2)

func _physics_process(delta):
	move_and_collide(Vector2(0, 0))

func die(time: float):
	await U.delay(time)
	queue_free()

