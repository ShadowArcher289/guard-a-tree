extends Node2D

@onready var tutorial_button: TextureButton = $TutorialButton
@onready var endless_button: TextureButton = $EndlessButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var seed: Sprite2D = $Seed
@onready var rainbow_seed: Sprite2D = $RainbowSeed

func _ready() -> void:
	seed.hide();
	rainbow_seed.hide();

func _on_tutorial_button_pressed() -> void:
	Globals.game_mode = "tutorial";
	tutorial_button.hide();
	seed.show();
	animation_player.play("Transition_Tutorial");
	await animation_player.animation_finished;
	TransitionManager.change_scene_to("res://scenes/game.tscn", "Fade_To_Black");

func _on_endless_button_pressed() -> void:
	Globals.game_mode = "endless";
	endless_button.hide();
	rainbow_seed.show();
	animation_player.play("Transition_Endless");
	await animation_player.animation_finished;
	TransitionManager.change_scene_to("res://scenes/game.tscn", "Fade_To_Black");
