extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	progress_bar.max_value = Globals.MAXHP;

func _process(delta: float) -> void:
	progress_bar.value = Globals.currHp; # Temporary HP display.
	
	
