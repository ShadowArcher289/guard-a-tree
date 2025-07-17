extends Node2D

@export var location: String = "ground"; ## stores location (ground, wall-left, wall-right, or ceiling)

@onready var turret: AnimatedSprite2D = $Turret
@onready var laser_ball: Sprite2D = $Turret/LaserBall
@onready var laser_beam: Sprite2D = $Turret/LaserBeam

@onready var laser_timer: Timer = $LaserTimer
@onready var cooldown_timer: Timer = $CooldownTimer

@onready var hurtbox: Area2D = $Turret/LaserBeam/Hurtbox

@onready var button: Button = $Button


var current_state;
var firing = false;
const LASERDURATION = 1; # how long (in seconds) the laser lasts
const LASERCOOLDOWNDURATION = 3;
const LASERDMG = Globals.LASERDMG;

enum State {
	AIMING,
	COOLDOWN,
	READY,
	FIRE,
}

var laserTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);


func _ready() -> void:
	button.focus_mode = Control.FOCUS_NONE;
	cooldown_timer.wait_time = Globals.LASERCOOLDOWNTIME;
	laser_ball.hide();
	laser_beam.hide();
	change_state(State.READY);
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed: # listens for mouse click
		if event.button_index == MOUSE_BUTTON_LEFT && (current_state == State.AIMING):
			change_state(State.FIRE);

func _process(delta: float) -> void:	
	if !laser_beam.is_visible_in_tree(): # don't deal damage if the laser is not showing.
		hurtbox.monitoring = false;
	else:
		hurtbox.monitoring = true;
	
	match location: # rotates the turret based on the provided location
		"ground":
			rotation_degrees = 0;
		"wall-left":
			rotation_degrees = 90;
		"wall-right":
			rotation_degrees = -90;
		"ceiling":
			rotation_degrees = 180;
		
		_:
			print_debug("Invalid location for turret" + str(location));
			location = "ground"; # go to ground for default.
	
	match current_state:
		State.COOLDOWN:
			turret.play("cooldown");
		State.READY:
			turret.play("ready");
		State.AIMING:
			Globals.LaserAiming = true;
			turret.look_at(get_global_mouse_position()); # follow mouse
			turret.rotation_degrees += 90;
		State.FIRE:
			Globals.LaserAiming = false;
			if !firing: # only fires the laser if the laser is not already firing
				firing = true;
				fire_laser();

func fire_laser() -> void: # fire laser script
	firing = true;
	laser_ball.show();
	laser_ball.scale = Vector2(0, 0);
	if !laserTween.is_valid(): # re-creates tween if it's invalid.
		laserTween.kill();
		laserTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN);
	laserTween.tween_property(laser_ball, "scale", Vector2(1, 1), 0.5);
	await laserTween.finished;
	camera_shake();
	change_state(State.COOLDOWN);
	laser_beam.show();
	laser_timer.start(LASERDURATION);
	await laser_timer.timeout;
	hide_laser();
	firing = false;
	cooldown_timer.start(LASERCOOLDOWNDURATION); # start cooldown timer

func camera_shake() -> void: # shakes the camera
	var camera = get_tree().get_root().get_node("Game").get_child(0); # get the camera node (using very sloppy code)
	var ogCameraPos = camera.position;
	for i in 8: # move the camera 8 times to make it look like it's shaking.
		camera.position += Vector2(randi_range(-10, 10), randi_range(-10, 10));
		await get_tree().create_timer(0.1).timeout;
		camera.position = ogCameraPos; # set camera to the origional position
	camera.position = ogCameraPos;
	

func hide_laser() -> void: # hide the laser
	laser_ball.hide();
	laser_beam.hide();

func change_state(next_state) -> void: # changes the state
	current_state = next_state;
	#match current_state: # prints out the changed state
	#	State.READY:
	#		print("Changed Laser state to State.READY");
	#	State.COOLDOWN:
	#		print("Changed Laser state to State.COOLDOWN");
	#	State.AIMING:
	#		print("Changed Laser state to State.AIMING");
	#	State.FIRE:
	#		print("Changed Laser state to State.FIRE");

func _on_button_pressed() -> void:
	if (current_state == State.READY): # if the turret is right clicked(button is masked to right click) in the READY state, then switch to AIMING.
		change_state(State.AIMING);

func _on_cooldown_timer_timeout() -> void: # change to READY state once cooldown is finished.
	change_state(State.READY);


func _on_hurt_box_body_entered(body: Node2D) -> void: # deal damage to bodies with the is_attacked function (enemies)
	if body.has_method("is_attacked"):
		body.is_attacked(LASERDMG);
