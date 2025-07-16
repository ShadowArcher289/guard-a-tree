extends Node2D

@export var spawn_cooldown : float = 1; # cooldown in seconds

@onready var game = get_tree().get_root().get_node("Game");

const FLY = preload("res://scenes/fly.tscn")

@onready var fly_anchor_1: Area2D = $FlyAnchor1
@onready var fly_anchor_2: Area2D = $FlyAnchor2
@onready var fly_anchor_3: Area2D = $FlyAnchor3

@onready var spawn_timer: Timer = $SpawnTimer
var timer_on = true; # holds if the timer is on or not


var anchor1Filled = false; # holds if the anchors for the FLIES are full or not.
var anchor2Filled = false;
var anchor3Filled = false;

@onready var fly_ray_1: RayCast2D = $FlyRay1
@onready var fly_ray_2: RayCast2D = $FlyRay2
@onready var fly_ray_3: RayCast2D = $FlyRay3


var flySpawnLocation : Vector2;

func _ready() -> void:
	spawn_timer.wait_time = spawn_cooldown;

func _process(delta: float) -> void:
	fly_ray_1.force_raycast_update()
	fly_ray_2.force_raycast_update()
	fly_ray_3.force_raycast_update()

	if spawn_timer.is_stopped():
		timer_on = false;
	else:
		timer_on = true;
		
	if fly_ray_1.is_colliding() && fly_ray_1.get_collider().is_in_group("fly"): # sets if an anchor is filled or not depending if there is a fly colliding with the ray or not.
		anchor1Filled = true;
	else:
		anchor1Filled = false;
	if fly_ray_2.is_colliding() && fly_ray_2.get_collider().is_in_group("fly"):
		anchor2Filled = true;
	else:
		anchor2Filled = false;
	if fly_ray_3.is_colliding() && fly_ray_3.get_collider().is_in_group("fly"):
		anchor3Filled = true;
	else:
		anchor3Filled = false;
	
	#print("anchor1F:" + str(anchor1Filled))
	#print("anchor2F:" + str(anchor2Filled))
	#print("anchor3F:" + str(anchor3Filled))
	#print(" ")

	if !anchor1Filled: # going in ascending order, if an anchor is not filled, then fill it.
		flySpawnLocation = fly_anchor_1.global_position;
	elif !anchor2Filled:
		flySpawnLocation = fly_anchor_2.global_position;
	elif !anchor3Filled:
		flySpawnLocation = fly_anchor_3.global_position;
		
	if anchor1Filled && anchor2Filled && anchor3Filled: # stop the spawn timer if the anchors are all filled
		spawn_timer.stop();
		timer_on = false;
	elif !timer_on: # start if the timer is not on already
		spawn_timer.start();


func spawn_fly(location : Vector2) -> void:
	#print("Spawn Fly")
	var fly = FLY.instantiate();
	fly.global_position = location;
	fly.show();
	game.add_child.call_deferred(fly);

func _on_spawn_timer_timeout() -> void:
	spawn_fly(flySpawnLocation);
