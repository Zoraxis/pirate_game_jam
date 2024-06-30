extends StaticBody2D

var damage = -1

func die(time: float):
	await U.delay(time)
	queue_free()
