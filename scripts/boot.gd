extends Node2D

const STOMPSPEED : float = 100.0/Globals.STOMPSPEED;
var ogPositionY = position.y; # sets base y position.

const BOOTDMG = Globals.BOOTDMG;

@onready var stomp_cooldown_timer: Timer = $StompCooldownTimer
@onready var buffer_timer: Timer = $BufferTimer

var clickBuffer : int = 0;

var stompTween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT);

func _input(event: InputEvent) -> void:
	print("stomp cooldown:" + str(stomp_cooldown_timer.is_stopped()));
	if event is InputEventMouseButton && event.pressed: # listens for mouse click
		if event.button_index == MOUSE_BUTTON_LEFT && !Globals.LaserAiming: # if left-click and a laser isn't being aimed.
			if stomp_cooldown_timer.is_stopped(): # run if the cooldown timer is stopped
				stomp(event.position);
			elif clickBuffer == 0: # add a buffer if there isn't one already
				clickBuffer = 1;
				buffer_timer.start(0.5); # click buffer
				await stomp_cooldown_timer.timeout; # if the cooldown timer ends and the buffer is still active, then run stomp().
				if clickBuffer == 1:
					stomp(event.position);


func stomp(targetPos : Vector2) -> void: # appears at the x coordinate and stomps to the y coordinate.
	stomp_cooldown_timer.start(1);
	if !stompTween.is_valid(): # re-creates tween if it's invalid.
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


func _on_hurtbox_body_entered(body: Node2D) -> void: # deal damage to bodies with the is_attacked function (enemies)
	if body.has_method("is_attacked"):
		body.is_attacked(BOOTDMG);


func _on_buffer_timer_timeout() -> void: # reset the clickBuffer if it timesout
	clickBuffer = 0;
