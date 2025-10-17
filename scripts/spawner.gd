extends Node2D

@onready var game = get_tree().get_root().get_node("Game");
@export var spawnerType = "termite"; # the type of spawner, termite is the default.

const TERMITE = preload("res://scenes/termite.tscn");
const TERMI_COPTER = preload("res://scenes/termi_copter.tscn");
const BUFF_MITE = preload("uid://dajewst7hoseu"); # path to BuffMite, uid from new Godot 4.5 feature
const TREE = preload("res://scenes/tree.tscn");


func spawn() -> void:
	var entity;
	match spawnerType:
		"termite":
			#print_debug("Summoned termite")
			entity = TERMITE.instantiate();
			entity.show();
			entity.velocity = Vector2(0, 0);
			entity.position = self.position;
			entity.z_index += 1;
			game.add_child.call_deferred(entity); # adds the enity to game
		"termi_copter":
			#print_debug("Summoned termi_copter")
			entity = TERMI_COPTER.instantiate();
			entity.show();
			entity.velocity = Vector2(0, 0);
			entity.position = self.position;
			entity.z_index += 1;
			game.add_child.call_deferred(entity); # adds the enity to game
		"buff_mite":
			#print_debug("Summoned buff_mite")
			entity = BUFF_MITE.instantiate();
			entity.show();
			entity.velocity = Vector2(0, 0);
			entity.position = self.position;
			entity.z_index += 1;
			game.add_child.call_deferred(entity); # adds the enity to game
		"tree":
			#print_debug("Summoned tree")
			entity = TREE.instantiate();
			entity.show();
			entity.position = self.position;
			game.add_child.call_deferred(entity); # adds the enity to game
		_:
			print_debug("unkown spawner type: " + spawnerType);
			pass;
			
