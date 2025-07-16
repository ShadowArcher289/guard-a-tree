extends CharacterBody2D

@onready var locate_target_ray_cast: RayCast2D = $LocateTargetRayCast
var target : Node; # the fly's target
var targetPosition : Vector2; # the position of the fly's target

var speed = Globals.FLIESSPEED;
const FLIESDMG = Globals.FLIESDMG;
var direction = 1;

enum State {
	LOCKEDON,
	SEARCHING
}
var current_state = State.SEARCHING;


func _process(delta: float) -> void:
	match current_state:
		State.LOCKEDON:
			if is_instance_valid(target): # if the target is valid, go to it. Otherwise, begin searching for a new target.
				targetPosition = target.position;
				look_at(targetPosition);
				direction = (targetPosition - self.position).normalized(); # face and move torwards target
				velocity = (direction * speed);
				move_and_slide();
			else:
				change_state(State.SEARCHING);
		State.SEARCHING:
			velocity = Vector2(0, 0);
			locate_target_ray_cast.rotation_degrees += 1; # continuously rotate ray cast to search for a target.
			
			if locate_target_ray_cast.is_colliding() && locate_target_ray_cast.get_collider().has_method("is_attacked"): # if the target can be attacked, 
				change_state(State.LOCKEDON);
				target = locate_target_ray_cast.get_collider();
				targetPosition = target.position;

func change_state(next_state) -> void: # changes the state
	current_state = next_state;
	
	
func _on_hurtbox_body_entered(body: Node2D) -> void: # deal damage to bodies with the is_attacked function (enemies)
	if body.has_method("is_attacked"):
		body.is_attacked(FLIESDMG);
		queue_free();
