extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox

@onready var atk_timer: Timer = $AtkTimer # when turned on, the termite attacks every timeout.

var hp = Globals.TERMITEMAXHP;
var moving = false;
var attacking = false;
var atkTarget = null;

var directionX = 1;
var speed = Globals.AVGTERMITESPEED * randf_range(0.9, 1.1); # termites have slightly different speeds
const ATK = Globals.TERMITEATK;

func _ready() -> void:
	moving = true;


func _process(delta: float) -> void:
	if hp <= 0:
		kick_the_bucket()
		pass;
	
	if position.x < 576: # change direction based on where the enemy is spawned.
		directionX = -1;
	elif position.x > 576:
		directionX = 1;
	
	if directionX == -1: # Flip the sprite
		animated_sprite_2d.flip_h = false;
	elif directionX == 1:
		animated_sprite_2d.flip_h = true;
		
	if moving:
		move(delta);

	if attacking && atk_timer.is_stopped(): # start/stop atk timer if attacking or not
		atk_timer.start();
	elif !attacking && !atk_timer.is_stopped():
		atk_timer.stop();
	
	
	
	velocity.y -= -Globals.GRAVITY;
	

func move(delta: float) -> void:
	velocity.x = -directionX * speed; # horizontal movement
	animated_sprite_2d.play("move");
	
	move_and_slide();

func attack():
	Globals.currHp -= ATK; # deal dmg to the tree

func is_attacked(dmgTaken : int):
	hp -= dmgTaken;
	print("TermiteHp" + str(hp))

func kick_the_bucket(): # this termite no longer lives. R.I.P.
	queue_free();

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name.containsn("tree"): # if the termite reaches a tree, stop moving and start attacking.
		moving = false;
		attacking = true;

func _on_atk_timer_timeout() -> void:
	attack();
