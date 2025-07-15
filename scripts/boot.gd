extends Node2D

const STOMPSPEED : float = 100.0/Globals.STOMPSPEED;
var ogPositionY = position.y; # sets base y position.

var stompTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT);

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			stomp(event.position);

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("attacked"):
		body.attacked(Globals.BOOTDMG);

func stomp(targetPos : Vector2) -> void: # appears at the x coordinate and stomps to the y coordinate.
	if !stompTween.is_valid():
		stompTween.kill();
		stompTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT);
	show();
	position.x = targetPos.x;
	stompTween.tween_property(self, "position", Vector2(targetPos.x, targetPos.y) , STOMPSPEED); # go down
	#await position.y == targetPos.y
	await stompTween.finished;
	#await get_tree().create_timer(0.1).timeout; # delay;
	stompTween.kill();
	stompTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT);
	stompTween.tween_property(self, "position", Vector2(targetPos.x, ogPositionY - 50) , STOMPSPEED*0.8); # go back up
	await stompTween.finished;
	hide();
