extends Node2D

@export var price := 20; ## The Cost to unlock this weapon. Default is 20

@onready var leaf_count_label: Label = $LeafCountLabel

func _ready() -> void:
	self.show();
	leaf_count_label.text = str(price);

#func _process(delta: float) -> void:
#	if global_rotation_degrees != 0:
#		global_rotation_degrees = 0;

func _on_button_pressed() -> void:
	if Globals.player_leaf_count >= price:
		Globals.player_leaf_count -= price;
		self.hide();
