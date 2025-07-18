extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var black_box: ColorRect = $BlackBox

func _ready() -> void:
	self.hide();

func change_scene_to(file: String, animationType: String): #changes the scene to file while playing the requested transition animation
	print("Transition1: " + str(get_tree().paused));
	if get_tree().paused: # unpause the game if it's paused
		get_tree().paused = false;
	print("Transition2: " + str(get_tree().paused));
	match animationType:
		"Fade_To_Black":
			fade_to_black();
			await animation_player.animation_finished;
			get_tree().change_scene_to_file(file);
			#fade_to_normal();
		"None":
			get_tree().change_scene_to_file(file);
		_:
			print_debug("Invalid animationType");

func fade_to_black() -> void: # Fade in to black
	self.show();
	animation_player.play("Fade_To_Black");
	await animation_player.animation_finished;
	self.hide();

func fade_to_normal() -> void: # fade out of black
	self.show();
	animation_player.play("Fade_To_Normal");
	await animation_player.animation_finished;
	self.hide();
