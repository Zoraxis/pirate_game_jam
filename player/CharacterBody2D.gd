extends CharacterBody2D

var bullet = preload("res://objects/static/atoms/bullet/bullet.tscn")
var melee_hit = preload("res://objects/static/atoms/melee/melee_hit.tscn")

var max_health = 3
@export var health = 3

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WEAPONS_COUNT = 3

var active_weapon = 0
var animation_playing = false;
var direction_rotation = 1;

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback = 0

const color_timer_max = 15
var color_change_positive = false
var color_timer: float = 0
var color_back_timer: float = 0

func _ready():
	Global.player = self

func _process(_delta):
	process_hit()
	direction_rotation = (-1 if $asprite.flip_h else 1)
	if Input.is_action_just_pressed("action_shoot"):
		#if active_weapon == 0:
			#changeAnimation("melee", true)
		if active_weapon == 1:
			changeAnimation("melee", true)
		if active_weapon == 2:
			changeAnimation("shoot", true)
		
	if Input.is_action_just_pressed("action_change"):
		active_weapon = (active_weapon + 1) % WEAPONS_COUNT

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		changeAnimation("jump", false)
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		changeAnimation("run", false)
		$asprite.flip_h = velocity.x < 0;
	else:
		changeAnimation("idle", false)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x += knockback * -direction_rotation
	knockback *= 0.8

	move_and_slide()

func _on_collision(body):
	if not body.is_in_group("FRIENDLY") and health - body.damage <= max_health:
		if body.is_in_group("FRAGILE"):
			body.die(0)
		if body.is_in_group("DAMAGE"):
			health -= body.damage
			if health <= 0:
				queue_free()
			else: 
				color_change_positive = body.damage < 0
				color_timer = color_timer_max
		if body.is_in_group("KNOCKBACK"):
			knockback -= body.knockback

func changeAnimation(animation, isSolo):
	if not animation_playing or isSolo:
		$asprite.play(animation)
		animation_playing = isSolo
		return true
	else:
		return false

func process_hit():
	if(color_timer >= 0):
		color_timer -= 1
		
		var color_left = (color_timer / color_timer_max)
		modulate = Color(1, color_left, color_left) if not color_change_positive else Color(color_left, 1, color_left)
		
		if(color_timer == 0):
			color_back_timer = color_timer_max
			
	if(color_back_timer >= 0):
		color_back_timer -= 1
		
		var color_left = (1 - color_back_timer / color_timer_max)
		modulate = Color(1, color_left, color_left) if not color_change_positive else Color(color_left, 1, color_left)

func _on_animation_end():
	if animation_playing:
		animation_playing = false;

func _on_frame_changed():
	if animation_playing and $asprite.frame == 1:
		if active_weapon == 0:
			pass
		if active_weapon == 1:
			knockback = 30
			Global.camera.add_trauma(0.2)
			var new_melee = melee_hit.instantiate();
			new_melee.add_to_group("FRIENDLY")
			new_melee.position = position + Vector2(33 * direction_rotation, 2)
			get_tree().get_current_scene().add_child(new_melee)
		if active_weapon == 2:
			knockback = 300
			Global.camera.add_trauma(1)
			$pistolParticle.position = position + Vector2(30 * direction_rotation, 3)
			$pistolParticle.emitting = true
			$pistolParticle.rotation_degrees = 0 if direction_rotation == 1 else 180
			var new_bullet = bullet.instantiate();
			new_bullet.position = position + Vector2(30 * direction_rotation, 2)
			new_bullet.rotated = direction_rotation
			get_tree().get_current_scene().add_child(new_bullet)
