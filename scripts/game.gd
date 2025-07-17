extends Node2D

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var kitbook: Control = $CanvasLayer/Kitbook
@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@onready var termite_spawner_1: Node2D = $TermiteSpawner1
@onready var termite_spawner_2: Node2D = $TermiteSpawner2
@onready var termi_copter_spawner_1: Node2D = $TermiCopterSpawner1
@onready var termi_copter_spawner_2: Node2D = $TermiCopterSpawner2
@onready var tree_spawner: Node2D = $TreeSpawner


func _ready() -> void:
	#setting properties
	hp_bar.max_value = Globals.MAXHP;
	hp_bar.hide();
	
	#start animations and different game modes
	if Globals.game_mode == "tutorial":
		animation_player.play("Start_Tutorial");
		await animation_player.animation_finished;
		await get_tree().create_timer(3);
		tree_spawner.spawn();
	
	#termite_spawner_1.spawn();
	#termite_spawner_2.spawn();
	#termite_spawner_1.spawn();
	#termite_spawner_2.spawn();
	#termite_spawner_1.spawn();
	#termi_copter_spawner_1.spawn();
	#termi_copter_spawner_2.spawn();

func _process(delta: float) -> void:
	hp_bar.value = Globals.currHp; # Temporary HP display.
	
	if hp_bar.value <= 0:
		print("GAME OVER");
		get_tree().paused = true;

func tutorial(id : int):
	match id:
		0:
			termite_spawner_1.spawn();
			kitbook.change_page_to(id);
			await !kitbook.is_visible_in_tree();
			
			

func reset():
	TransitionManager.change_scene_to("res://scenes/title_screen.tscn", "Fade_To_Black");
	get_tree().paused = false;

func _on_toggle_kitbook_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		kitbook.show();
		get_tree().paused = true;
	elif !toggled_on:
		kitbook.hide();
		get_tree().paused = false;
