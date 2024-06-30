extends Area2D

@export var sprite_in: Texture
@export var pickup_value = 1

func _ready():
	$sprite.texture = sprite_in

func _on_body_entered(body):
	queue_free()
	Global.player.unlocked_weapons += 1
	Global.player.handle_change_weapon()
