extends CharacterBody2D

@onready var game = get_tree().get_root().get_node("Game");
const BULLET = preload("res://scenes/bullet.tscn");

var bullet_spawn_anchor = bullet_spawn_anchor_right;
@onready var bullet_spawn_anchor_left: Node2D = $Sprite2D/BulletSpawnAnchorLeft
@onready var bullet_spawn_anchor_right: Node2D = $Sprite2D/BulletSpawnAnchorRight

@onready var shooting_timer: Timer = $ShootingTimer
@onready var move_cycle_timer: Timer = $MoveCycleTimer

var target_ray = target_ray_right;
@onready var target_ray_left: RayCast2D = $Sprite2D/TargetRayLeft
@onready var target_ray_right: RayCast2D = $Sprite2D/TargetRayRight

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var hp = Globals.TERMICOPTERMAXHP;
var directionX = 1;
var speed = Globals.AVGTERMICOPTERSPEED * randf_range(0.9, 1.1); # TermiCopters have slightly different speeds
const SHOOTINGCYCLETIME = Globals.SHOOTINGCYCLETIME

var movementTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT);

var currentWeaponState; # The current state of the TermiCopter

# the TeriCopter can move and shoot at the same time.
var moving = false;
var shooting = false;
enum weaponState {
	NOTSHOOTING,
	SHOOTING,
}

func _ready() -> void:
	moving = true;
	target_ray_left.target_position.x *= randf_range(0.6, 1); # Copters have slightly different ranges 
	target_ray_right.target_position.x *= randf_range(0.6, 1); # Copters have slightly different ranges 
	if position.x < 576: # change direction based on where the enemy is spawned.
		directionX = 1;
	elif position.x > 576:
		directionX = -1;
	
	if directionX == -1: # Flip the sprite
		sprite_2d.flip_h = true;
		bullet_spawn_anchor = bullet_spawn_anchor_right;
		target_ray = target_ray_right;
	elif directionX == 1:
		sprite_2d.flip_h = false;
		bullet_spawn_anchor = bullet_spawn_anchor_left;
		target_ray = target_ray_left;

func _process(delta: float) -> void:
	if hp <= 0:
		kick_the_bucket()
		pass;
	
	if position.x < 576: # change direction based on where the enemy is spawned.
		directionX = 1;
	elif position.x > 576:
		directionX = -1;
	
	if directionX == -1: # Flip the sprite and handle other flipping node issues
		sprite_2d.flip_h = true;
		bullet_spawn_anchor = bullet_spawn_anchor_left;
		target_ray = target_ray_left;
		collision_shape_2d.position.x = -24.0;
	elif directionX == 1:
		sprite_2d.flip_h = false;
		bullet_spawn_anchor = bullet_spawn_anchor_right;
		target_ray = target_ray_right;
		collision_shape_2d.position.x = 24.0;

	
	if moving:
		move(delta);
	
	if target_ray.is_colliding() && target_ray.get_collider().name.containsn("tree"):
		currentWeaponState = weaponState.SHOOTING;
		moving = false;
	else:
		currentWeaponState = weaponState.NOTSHOOTING;
	
	match currentWeaponState: # check weapon states and run attack accordingly
		weaponState.NOTSHOOTING:
			if shooting:
				shooting = false;
				shooting_timer.stop();
		weaponState.SHOOTING:
			if !shooting:
				shooting = true;
				shooting_timer.start(SHOOTINGCYCLETIME);
				#move_cycle_timer.start(randf_range(2, 5)); # begins a timer for random mini movements. 

func is_attacked(dmgTaken : int):
	hp -= dmgTaken;
	print("CopterHp" + str(hp));

func kick_the_bucket(): # this TermiCopter no longer lives. R.I.P.
	queue_free();

func spawn_bullet(velo : float) -> void:
	var bullet = BULLET.instantiate();
	bullet.position = bullet_spawn_anchor.global_position;
	bullet.show();
	bullet.velo = velo;
	bullet.rotation = sprite_2d.global_rotation;
	game.add_child.call_deferred(bullet);

func move(delta : float) -> void: # , targetPosition : Vector2
	#if !movementTween.is_valid(): # re-creates tween if it's invalid.
	#	movementTween.kill();
	#	movementTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);
	#movementTween.tween_property(self, "position", targetPosition, 100/SPEED);
	
	velocity.x = directionX * speed; # horizontal movement
	# movement animation.
	
	move_and_slide();

func _on_shooting_timer_timeout() -> void:
	for i in 5: # shoot i number of bullets per cycle
		spawn_bullet(Globals.BULLETVELOCITY * directionX); # bullet has velocity and direction
		await get_tree().create_timer(0.1).timeout;


func _on_move_cycle_timer_timeout() -> void: # move around a bit
	for i in 30:
		if global_position.y < 469.0: # to not go below a y level
			velocity = (Vector2(randf_range(-1, 1), randf_range(-1, 1)) * speed);
			move_and_slide();
			await get_tree().create_timer(randf_range(2,4));
			velocity = Vector2(0, 0);
		else:
			velocity = Vector2(randf_range(-20, 20), randf_range(30, 40)) * speed;
			move_and_slide();
			await get_tree().create_timer(randf_range(2,4));
			velocity = Vector2(0, 0);
		
