extends CharacterBody2D

var bullet = preload("res://objects/static/atoms/bullet/bullet.tscn")

@export var SPEED = 200.0

@export var level = 0
@export var texture = 1

@export var health = 3

var knockback = 0
var animation_playing = false;
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_rotation = 1

const color_timer_max = 15
var color_timer: float = 0
var color_back_timer: float = 0
var type = 0
var lastCollision = null

const shooting_delay_max = 300
var shooting_delay = 0


var state = 0
# 0 - patrooling
# 1 - awarness
# 2 - running
# 3 - attacking

func _ready():
	texture %= 6 + 1
	type = 1 if (texture == 1 or texture == 3 or texture == 6) else 0
	
	var animation = load("res://objects/NPC/skelet/skeletonDDD.anim.tres".replace("DDD", str(texture)))
	$asprite.set_sprite_frames(animation)

func _on_collision(body):
	if lastCollision != body.name and !body.is_in_group("PLAYER_ONLY"):
		lastCollision = body.name
		state = 1
		var bullet_side = 1 if (body.global_position.x < position.x) else -1
		scale.x *= -1 if (body.global_position.x < position.x and direction_rotation != -1) or (body.global_position.x > position.x and direction_rotation != 1) else 1
		if body.is_in_group("STUN"):
			shooting_delay = shooting_delay_max / 3
		if body.is_in_group("FRAGILE"):
			body.die(0)
		if body.is_in_group("DAMAGE"):
			health -= body.damage
			if health <= 0:
				queue_free()
			else: 
				color_timer = color_timer_max
		if body.is_in_group("KNOCKBACK"):
			knockback = body.knockback * bullet_side
		
func _process(_delta):
	process_hit()
	if shooting_delay > 0:
		shooting_delay -= 1
	
func state_inspector():
	$Label.text = str(state)
	if state == 0:
		handle_state_0()
	if state == 1:
		handle_state_1()
	if state == 2:
		handle_state_2()
	if state == 3:
		handle_state_3()
		
func handle_state_0():
	state = 0
func handle_state_1():
	state = 1
func handle_state_2():
	state = 2
	velocity.x += -(position - Global.player.position).normalized().x * SPEED
func handle_state_3():
	state = 3
	if shooting_delay <= 0:
		shooting_delay = shooting_delay_max
		changeAnimation("attack", true)

func _physics_process(delta):
	state_inspector()
	direction_rotation = (-1 if scale.y != abs(scale.y) else 1)
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if knockback > 0:
		velocity = Vector2(1, 0) * knockback * scale.x * SPEED * delta
		knockback *= 0.8
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
		
	changeAnimation("idle", false)
	move_and_slide()

func changeAnimation(animation, isSolo):
	if not animation_playing or isSolo:
		$asprite.play(animation)
		animation_playing = isSolo
		return true
	else:
		return false

func _on_animation_end():
	if animation_playing:
		animation_playing = false;

func process_hit():
	if(color_timer >= 0):
		color_timer -= 1
		
		modulate = Color(1, (color_timer / color_timer_max), (color_timer / color_timer_max))
		
		if(color_timer == 0):
			color_back_timer = color_timer_max
			
	if(color_back_timer >= 0):
		color_back_timer -= 1
		
		modulate = Color(1, (1 - color_back_timer / color_timer_max), (1 - color_back_timer / color_timer_max))



func _on_attack_box_enter(body):
	if body.is_in_group("PLAYER"):
		handle_state_3()

func _on_attack_box_exited(body):
	if body.is_in_group("PLAYER"):
		handle_state_2()

func _on_fov_entered(body):
	if body.is_in_group("PLAYER"):
		handle_state_2()
		
func _on_fov_exited(body):
	if body.is_in_group("PLAYER"):
		handle_state_1()

func _on_frame_changed():
	if animation_playing and $asprite.frame == 1:
		if type == 0:
			pass
		if type == 1:
			$pistolParticle.position = position + Vector2(30 * direction_rotation, 3)
			$pistolParticle.emitting = true
			$pistolParticle.rotation_degrees = 0 if direction_rotation == 1 else 180
			var new_bullet = bullet.instantiate();
			new_bullet.position = position + Vector2(30 * direction_rotation, 2)
			new_bullet.rotated = direction_rotation
			get_tree().get_current_scene().add_child(new_bullet)
