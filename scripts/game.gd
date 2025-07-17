extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var termite_spawn_timer: Timer = $TermiteSpawnTimer

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var leaf_count_label: Label = $Leaves/LeafCountLabel
@onready var kitbook: Control = $CanvasLayer/Kitbook

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
	leaf_count_label.text = str(Globals.player_leaf_count);
	
	if hp_bar.value <= 0:
		print("GAME OVER");
		get_tree().paused = true;

func tutorial(id : String):
	match id:
		"stomp": # Stomp
			kitbook.change_page_to(0);
			await !kitbook.is_visible_in_tree();
			for i in 20: # spawn 20 termites
				var spawn = randi_range(1, 2);
				if spawn == 1:
					termite_spawner_1.spawn();
				else:
					termite_spawner_2.spawn();
				termite_spawn_timer.start(randi_range(0.2, 1))
				await termite_spawn_timer.timeout;
		"lasers": # Lasers # leaves & unlocking stuff
			pass;
		"flies": # FLIES
			pass;
			

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
