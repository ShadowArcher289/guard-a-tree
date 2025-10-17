extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox

@onready var atk_timer: Timer = $AtkTimer # when turned on, the BuffMites attacks every timeout.

var hp = Globals.BUFFMITEMAXHP;
var moving = false;
var attacking = false;
var atkTarget = null;

var directionX = 1;
var speed = Globals.AVGBUFFMITEPEED * randf_range(0.8, 1.2); # BuffMites have slightly different speeds
const ATK = Globals.BUFFMITEATK;

func _ready() -> void:
	moving = true;
	Globals.enemyCount += 1;


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
	

func move(_delta: float) -> void:
	velocity.x = -directionX * speed; # horizontal movement
	animated_sprite_2d.play("move");
	
	move_and_slide();

func attack():
	animated_sprite_2d.play("attack"); # play attack animation
	await animated_sprite_2d.animation_finished;
	Globals.currHp -= ATK; # deal dmg to the tree after the animation is played

func is_attacked(dmgTaken : int):
	hp -= dmgTaken;

func kick_the_bucket(): # this termite no longer lives. R.I.P.
	Globals.enemyCount -= 1;
	Globals.player_leaf_count += Globals.BUFFMITELEAFCOUNT;
	#SoundManager.buffmite_down.play();
	queue_free();

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name.containsn("tree"): # if the BuffMite reaches a tree, stop moving and start attacking.
		moving = false;
		attacking = true;

func _on_atk_timer_timeout() -> void:
	attack();
