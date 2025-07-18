extends Control

func _ready() -> void:
	self.hide();

func _process(delta: float) -> void:
	if self.is_visible_in_tree() && !get_tree().paused: # pause the game if it's not already
		get_tree().paused = true;


func _on_new_game_pressed() -> void:
	self.hide();
	get_tree().paused = false;
	Globals.player_leaf_count = Globals.PLAYER_STARTING_LEAVES;
	Globals.currHp = Globals.MAXHP;
	TransitionManager.change_scene_to("res://scenes/title_screen.tscn", "Fade_To_Black");


func _on_retry_pressed() -> void:
	self.hide();
	get_tree().paused = false;
	Globals.player_leaf_count = Globals.PLAYER_STARTING_LEAVES;
	Globals.currHp = Globals.MAXHP;
	TransitionManager.change_scene_to("res://scenes/game.tscn", "Fade_To_Black");
