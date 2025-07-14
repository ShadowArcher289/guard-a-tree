extends Node2D

@onready var game = get_tree().get_root().get_node("Game");
@export var spawnerType = "termite"; # the type of spawner, termite is the default.

const TERMITE = preload("res://scenes/termite.tscn");

func spawn() -> void:
	print(game)
	print("spawn")
	var entity;
	match spawnerType:
		"termite":
				print("Summon termite")
				entity = TERMITE.instantiate();
				print(entity)
				entity.show();
				entity.velocity = Vector2(0, 0);
				entity.position = self.position;
				game.add_child.call_deferred(entity); # adds the enity to game

		_:
			print_debug("unkown spawner type: " + spawnerType);
			pass;
			
