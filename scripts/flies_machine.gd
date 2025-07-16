extends Node2D

@onready var game = get_tree().get_root().get_node("Game");

const FLY = preload("res://scenes/fly.tscn")

@onready var fly_anchor_1: Area2D = $FlyAnchor1
@onready var fly_anchor_2: Area2D = $FlyAnchor2
@onready var fly_anchor_3: Area2D = $FlyAnchor3

@onready var spawn_timer: Timer = $SpawnTimer


var anchor1Filled = false; # holds if the anchors are full or not.
var anchor2Filled = false;
var anchor3Filled = false;

var anchor1FliesCount = 0; # should be 1 if filled, or 0 if empty
var anchor2FliesCount = 0;
var anchor3FliesCount = 0;


var flySpawnLocation : Vector2;

func _process(delta: float) -> void:
	if !anchor1Filled: # going in ascending order, if an anchor is not filled, then fill it. 
		flySpawnLocation = fly_anchor_1.global_position;
	elif !anchor2Filled:
		flySpawnLocation = fly_anchor_2.global_position;
	elif !anchor3Filled:
		flySpawnLocation = fly_anchor_3.global_position;

	
	if anchor1Filled && anchor2Filled && anchor3Filled:
		spawn_timer.stop();
	else:
		spawn_timer.start();

func spawn_fly(location : Vector2) -> void:
	var fly = FLY.instantiate();
	fly.position = location;
	fly.show();
	game.add_child.call_deffered(fly);


func _on_spawn_timer_timeout() -> void:
	spawn_fly(flySpawnLocation);



func _on_fly_anchor_1_body_entered(body: Node2D) -> void:
	if body.name.containsn("fly"):
		anchor1FliesCount += 1;
		anchor1Filled = true;

func _on_fly_anchor_1_body_exited(body: Node2D) -> void: # if more than 1 fly enters the area then the filled variable turns false only after all flies leave.
	if body.name.containsn("fly") && (anchor1FliesCount == 1):
		anchor1Filled = false;
	elif body.name.containsn("fly") && (anchor1FliesCount != 1):
		anchor1FliesCount -= 1;

func _on_fly_anchor_2_body_entered(body: Node2D) -> void:
	if body.name.containsn("fly"):
		anchor2FliesCount += 1;
		anchor2Filled = true;

func _on_fly_anchor_2_body_exited(body: Node2D) -> void: # if more than 1 fly enters the area then the filled variable turns false only after all flies leave.
	if body.name.containsn("fly") && (anchor2FliesCount == 1):
		anchor2Filled = false;
	elif body.name.containsn("fly") && (anchor2FliesCount != 1):
		anchor2FliesCount -= 1;

func _on_fly_anchor_3_body_entered(body: Node2D) -> void:
	if body.name.containsn("fly"):
		anchor3FliesCount += 1;
		anchor3Filled = true;

func _on_fly_anchor_3_body_exited(body: Node2D) -> void: # if more than 1 fly enters the area then the filled variable turns false only after all flies leave.
	if body.name.containsn("fly") && (anchor3FliesCount == 1):
		anchor3Filled = false;
	elif body.name.containsn("fly") && (anchor3FliesCount != 1):
		anchor3FliesCount -= 1;
