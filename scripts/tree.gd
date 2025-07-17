extends Node2D

@onready var sprite: Sprite2D = $Sprite

@onready var grow_delay: Timer = $GrowDelay

#Tree Stages
const S1 = preload("res://sprites/TreeS1.png");
const S2 = preload("res://sprites/TreeS2.png");
const S3 = preload("res://sprites/TreeS3.png");
const S4 = preload("res://sprites/TreeS4.png");
const S5 = preload("res://sprites/TreeS5.png");

const MAXHP = Globals.MAXHP;
var currHp = MAXHP;

func _ready() -> void:
	grow_delay.wait_time = 1;
	grow();

func grow() -> void:
	#sprite.position = Vector2(0, -34.0);
	#sprite.texture = S1;
	#grow_delay.start();
	#await grow_delay.timeout;
	sprite.position = Vector2(28, -158.0);
	sprite.texture = S2;
	grow_delay.start();
	await grow_delay.timeout;
	#sprite.position = Vector2(4, -163.0);
	#sprite.texture = S3;
	#grow_delay.start();
	#await grow_delay.timeout;
	sprite.position = Vector2(0, -355.0);
	sprite.texture = S4;
	grow_delay.start();
	await grow_delay.timeout;
	sprite.position = Vector2(0, -362.0);
	sprite.texture = S5;

#func _process(delta: float) -> void:
#	var currHp = Globals.currHP;
#	if currHp < (0.2 * MAXHP): # if Hp is less than x% of the max, show a more decayed or lush sprite.
#		pass;
#	elif currHp < (0.5 * MAXHP): # if Hp is less than x% of the max, show a more decayed or lush sprite.
#		pass;
#	elif currHp < (0.8 * MAXHP): # if Hp is less than x% of the max, show a more decayed or lush sprite.
#		pass;
#	elif currHp <= MAXHP: # if Hp is less than x% of the max, show a more decayed or lush sprite.
#		pass;
