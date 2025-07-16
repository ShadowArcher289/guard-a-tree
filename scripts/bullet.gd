extends CharacterBody2D

var velo = Globals.BULLETVELOCITY;
const ATK = Globals.BULLETDMG;

	
func _process(delta: float) -> void:
		velocity = Vector2(velo, randf_range(-10,10)); # random vertical velocity for spread
		move_and_slide();

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name.containsn("tree"): # deal damage and delete the bullet.
		Globals.currHp -= ATK;
		queue_free();
