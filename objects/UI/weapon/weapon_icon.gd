extends Node2D

var last_active_weapon = 0;

func _process(delta):
	if Global.player.active_weapon != last_active_weapon:
		last_active_weapon = Global.player.active_weapon
		$particles.restart()
		$particles.emitting = true
		if Global.player.active_weapon == 0:
			$weapon_icon.play("fist")
		if Global.player.active_weapon == 1:
			$weapon_icon.play("sword")
		if Global.player.active_weapon == 2:
			$weapon_icon.play("pistol")
