extends Area2D

@export var knockback = -150

func _on_body_entered(body):
	if body.is_in_group("ENEMY"):
		body.health -= 10
	if body.is_in_group("PLAYER"):
		Global.player.launch_force = knockback
