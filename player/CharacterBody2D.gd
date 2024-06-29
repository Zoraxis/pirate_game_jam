extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WEAPONS_COUNT = 2

var active_weapon = 0
var weapon_playing = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	if Input.is_action_just_pressed("action_shoot"):
		if active_weapon == 0:
			changeAnimation("melee")
		if active_weapon == 1:
			changeAnimation("shoot")
		weapon_playing = true;
		
	if Input.is_action_just_pressed("action_change"):
		active_weapon = (active_weapon + 1) % WEAPONS_COUNT

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		changeAnimation("run")
		$AnimatedSprite2D.flip_h = velocity.x < 0;
	else:
		changeAnimation("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func changeAnimation(name):
	if not weapon_playing:
		$AnimatedSprite2D.play(name)

func _on_animated_sprite_2d_animation_finished():
	if weapon_playing:
		weapon_playing = false;


func _on_animated_sprite_2d_animation_looped():
	if weapon_playing:
		weapon_playing = false;
