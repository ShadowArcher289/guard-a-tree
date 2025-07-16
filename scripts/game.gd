extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var termite_spawner_1: Node2D = $TermiteSpawner1
@onready var termite_spawner_2: Node2D = $TermiteSpawner2
@onready var termi_copter_spawner_1: Node2D = $TermiCopterSpawner1

func _ready() -> void:
	progress_bar.max_value = Globals.MAXHP;
	termite_spawner_1.spawn();
	termite_spawner_2.spawn();
	termite_spawner_1.spawn();
	termite_spawner_2.spawn();
	termite_spawner_1.spawn();
	termi_copter_spawner_1.spawn();

func _process(delta: float) -> void:
	progress_bar.value = Globals.currHp; # Temporary HP display.
