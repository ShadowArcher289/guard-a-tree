extends Node2D

# Holds all the sound vars

@onready var background_music: AudioStreamPlayer = $BackgroundMusic

@onready var button_sfx: AudioStreamPlayer = $ButtonSfx
@onready var kitbook_button_sound: AudioStreamPlayer = $KitbookButtonSound

@onready var gain_hp: AudioStreamPlayer = $GainHp

@onready var unlock_sfx: AudioStreamPlayer = $UnlockSfx
@onready var stomp: AudioStreamPlayer = $Stomp
@onready var laser_fire: AudioStreamPlayer = $LaserFire

@onready var bullet_fire: AudioStreamPlayer = $BulletFire
@onready var copter_down: AudioStreamPlayer = $CopterDown
@onready var termite_down: AudioStreamPlayer = $TermiteDown
@onready var copter_hit: AudioStreamPlayer = $CopterHit
@onready var buff_mite_down: AudioStreamPlayer = $BuffMiteDown
