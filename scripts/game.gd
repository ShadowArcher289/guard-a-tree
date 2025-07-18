extends Node2D

signal treeNameSet;

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var seed: Sprite2D = $Seed
const BASICSEEDTEXTURE = preload("res://sprites/Seed.png");
const RAINBOWSEEDTEXTURE = preload("res://sprites/RainbowSeed.png");

@onready var termite_spawn_timer: Timer = $TermiteSpawnTimer
@onready var termi_copter_spawn_timer: Timer = $TermiCopterSpawnTimer

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var leaf_count_label: Label = $Leaves/LeafCountLabel
@onready var kitbook: Control = $CanvasLayer/Kitbook
@onready var toggle_kitbook_button: TextureButton = $CanvasLayer/ToggleKitbookButton
@onready var tree_name_label: Label = $TreeNameLabel

@onready var termite_spawner_1: Node2D = $TermiteSpawner1
@onready var termite_spawner_2: Node2D = $TermiteSpawner2
@onready var termi_copter_spawner_1: Node2D = $TermiCopterSpawner1
@onready var termi_copter_spawner_2: Node2D = $TermiCopterSpawner2
@onready var tree_spawner: Node2D = $TreeSpawner

@onready var set_tree_name_card: Sprite2D = $SetTreeNameCard
@onready var text_edit: TextEdit = $SetTreeNameCard/TextEdit
@onready var confirm_btn: Button = $SetTreeNameCard/ConfirmBtn


func _ready() -> void:
	#setting properties
	hp_bar.max_value = Globals.MAXHP;
	hp_bar.hide();
	set_tree_name_card.hide();
	
	if Globals.game_mode == "tutorial": 	#start animations and different game modes
		seed.texture = BASICSEEDTEXTURE;
		animation_player.play("Start_Tutorial");
		await animation_player.animation_finished;
		await get_tree().create_timer(0.5).timeout;
		tree_spawner.spawn();
		hp_bar.show();
		termite_spawner_1.spawn();
		set_tree_name();
		set_tree_name_card.show();
		await treeNameSet;
		termite_spawner_1.spawn();
		await get_tree().create_timer(3).timeout;
		tutorial("stomp");
	elif Globals.game_mode == "endless":
		seed.texture = RAINBOWSEEDTEXTURE;
		animation_player.play("Start_Endless");
		await animation_player.animation_finished;
		await get_tree().create_timer(0.5).timeout;
		tree_spawner.spawn();
		hp_bar.show();
		termite_spawner_1.spawn();
		set_tree_name();
		set_tree_name_card.show();
		run_endless();
	
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


func set_tree_name() -> void: # prompts the player to set a name for the tree
	get_tree().paused = true;
	set_tree_name_card.show();
	await confirm_btn.pressed;
	set_tree_name_card.hide();
	Globals.treeName = text_edit.text;
	get_tree().paused = false;
	tree_name_label.text = Globals.treeName;
	treeNameSet.emit();


func tutorial(id : String):
	match id:
		"stomp": # Stomp
			kitbook.change_page_to(0);
			toggle_kitbook_button.button_pressed = true;
			await toggle_kitbook_button.toggled;
			for i in 20: # spawn 20 termites
				var spawn = randi_range(1, 2);
				if spawn == 1:
					termite_spawner_1.spawn();
				else:
					termite_spawner_2.spawn();
				termite_spawn_timer.start(randf_range(0.2, 1))
				await termite_spawn_timer.timeout;
			await Globals.enemiesCleared;
			tutorial("laser");
		"laser": # Lasers & leaves & unlocking stuff
			kitbook.change_page_to(1);
			toggle_kitbook_button.button_pressed = true;
			await toggle_kitbook_button.toggled;
			Globals.player_leaf_count += 5; # some leaves to ensure it can be unlocked
			await Globals.weaponUnlocked;
			kitbook.change_page_to(2);
			toggle_kitbook_button.button_pressed = true;
			await toggle_kitbook_button.toggled;
			for i in 10: # spawn 10 termiCopters
				var spawn = randi_range(1, 2);
				if spawn == 1:
					termi_copter_spawner_1.position.y += randf_range(-50, 200);
					termi_copter_spawner_1.spawn();
					termi_copter_spawner_1.position.y = 204;
				else:
					termi_copter_spawner_2.position.y += randf_range(-50, 200);
					termi_copter_spawner_2.spawn();
					termi_copter_spawner_2.position.y = 190;
	
				termi_copter_spawn_timer.start(randf_range(1, 4))
				await termi_copter_spawn_timer.timeout;
			await Globals.enemiesCleared;
			tutorial("flies");
		"flies": # FLIES
			kitbook.change_page_to(3);
			toggle_kitbook_button.button_pressed = true;
			await toggle_kitbook_button.toggled;
			Globals.player_leaf_count += 30; # some leaves to ensure it can be unlocked
			for i in 20: # spawn a mix
				var spawn = randi_range(1, 4);
				if spawn == 1:
					termite_spawner_1.spawn();
				elif spawn == 2:
					termite_spawner_2.spawn();
				elif spawn == 3:
					termi_copter_spawner_1.position.y += randf_range(-50, 200);
					termi_copter_spawner_1.spawn();
					termi_copter_spawner_1.position.y = 204;
				elif spawn == 4:
					termi_copter_spawner_2.position.y += randf_range(-50, 200);
					termi_copter_spawner_2.spawn();
					termi_copter_spawner_2.position.y = 190;
				termi_copter_spawn_timer.start(randi_range(1, 4));
				await termi_copter_spawn_timer.timeout || termite_spawn_timer.timeout;

func run_endless() -> void: # spawn enemies for endless mode
	for i in 25: # spawn some termites to at least get a laser
		var spawn = randi_range(1, 2);
		if spawn == 1:
			termite_spawner_1.spawn();
		else:
			termite_spawner_2.spawn();
		termite_spawn_timer.start(randf_range(0.2, 0.5))
		await termite_spawn_timer.timeout;
	while hp_bar.value >= 0: # infenitaley spawn enemies
		var spawn = randi_range(1, 6);
		if spawn == 1 || spawn == 3:
			termite_spawner_1.spawn();
			termite_spawn_timer.start(randf_range(0, 1));
		elif spawn == 2 || spawn == 4:
			termite_spawner_2.spawn();
			termite_spawn_timer.start(randf_range(0, 1));
		elif spawn == 5:
			termi_copter_spawner_1.position.y += randf_range(-50, 200);
			termi_copter_spawner_1.spawn();
			termi_copter_spawner_1.position.y = 204;
			termi_copter_spawn_timer.start(randf_range(1, 3));
		elif spawn == 6:
			termi_copter_spawner_2.position.y += randf_range(-50, 200);
			termi_copter_spawner_2.spawn();
			termi_copter_spawner_2.position.y = 190;
			termi_copter_spawn_timer.start(randf_range(1, 3));
		await termi_copter_spawn_timer.timeout || termite_spawn_timer.timeout;

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
