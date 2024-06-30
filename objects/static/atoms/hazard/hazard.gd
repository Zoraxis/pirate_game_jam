extends Area2D

@export var knockback = -200

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		Global.player.launch_force = knockback
