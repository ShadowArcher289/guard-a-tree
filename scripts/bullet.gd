extends CharacterBody2D

var velo = Globals.BULLETVELOCITY;
const ATK = Globals.BULLETDMG;

	
func _process(delta: float) -> void:
		velocity = Vector2(velo, 0);
		move_and_slide();


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(area)
	if area.name.containsn("tree"): # deal damage and delete the bullet.
		Globals.currHp -= ATK;
		queue_free();
