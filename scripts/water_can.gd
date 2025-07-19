extends TextureButton

@onready var node_2d: Node2D = $Node2D

func _ready() -> void:
	node_2d.hide();

func _on_pressed() -> void: # heal the player
	if Globals.player_leaf_count >= 10:
		if Globals.currHp <= (Globals.MAXHP - 10):
			Globals.currHp += 10;
			node_2d.show();
			Globals.player_leaf_count -= 10;
			SoundManager.gain_hp.play();
			await get_tree().create_timer(0.2).timeout;
			node_2d.hide();
		elif (Globals.currHp > (Globals.MAXHP - 10)) && (Globals.currHp != Globals.MAXHP):
			Globals.currHp = Globals.MAXHP;
			node_2d.show();
			Globals.player_leaf_count -= 10;
			SoundManager.gain_hp.play();
			await get_tree().create_timer(0.2).timeout;
			node_2d.hide();
