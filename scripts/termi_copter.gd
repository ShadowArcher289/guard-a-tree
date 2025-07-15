extends CharacterBody2D

@onready var game = get_tree().get_root().get_node("Game");
const BULLET = preload("res://scenes/bullet.tscn")

@onready var bullet_spawn_anchor: Node2D = $BulletSpawnAnchor
@onready var shooting_timer: Timer = $ShootingTimer

@onready var target_ray: RayCast2D = $TargetRay

var hp = Globals.TERMICOPTERMAXHP;
const SPEED = Globals.AVGTERMICOPTERSPEED
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

func _process(delta: float) -> void:
	if hp <= 0:
		kick_the_bucket()
		pass;

	if moving:
		pass; # Play movement animation
	
	if target_ray.is_colliding() && target_ray.get_collider().name.containsn("tree"):
		currentWeaponState = weaponState.SHOOTING;
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

func is_attacked(dmgTaken : int):
	print("hp" + str(hp))
	hp -= dmgTaken;

func kick_the_bucket(): # this TermiCopter no longer lives. R.I.P.
	queue_free();

func spawn_bullet(velo : float) -> void:
	var bullet = BULLET.instantiate();
	print_debug(bullet);
	bullet.position = bullet_spawn_anchor.global_position;
	bullet.show();
	bullet.velo = velo;
	game.add_child.call_deferred(bullet);

func move(delta : float, targetPosition : Vector2) -> void:
	if !movementTween.is_valid(): # re-creates tween if it's invalid.
		movementTween.kill();
		movementTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);
	movementTween.tween_property(self, "position", targetPosition, 100/SPEED);


func _on_shooting_timer_timeout() -> void:
	for i in 5: # shoot i number of bullets per cycle
		spawn_bullet(Globals.BULLETVELOCITY);
		await get_tree().create_timer(0.1).timeout;
