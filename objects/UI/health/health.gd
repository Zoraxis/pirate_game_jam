extends Node2D

func _process(delta):
	if Global.player != null and Global.player.health != null:
		if Global.player.health >= 3:
			$HP3.play("some")
		else:
			$HP3.play("no")
			
		if Global.player.health >= 2:
			$HP2.play("some")
		else:
			$HP2.play("no")
			
		if Global.player.health >= 1:
			$HP1.play("some")
		else:
			$HP1.play("no")
