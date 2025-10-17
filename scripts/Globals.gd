extends Node

var treeName = "Name"; # the beautiful name the player gave the tree.

#Game
const GRAVITY = 9.8;
var ogCameraPosition;
var game_mode : String = "tutorial"; # the default game mode is tutorial
var enemyCount : int = 0; # holds the current number of enemies in the game.
signal weaponUnlocked;
signal enemiesCleared; # emitted if no enemies are on the field

func _process(_delta: float) -> void:
	if enemyCount <= 0:
		enemiesCleared.emit();

#Tree/Player
const MAXHP = 100; # Hp
var currHp = MAXHP;
const PLAYER_STARTING_LEAVES := 0; # the currency for unlocking new weapons
var player_leaf_count : int = PLAYER_STARTING_LEAVES;

#Weapons
const BOOTDMG = 5; # Boot
const STOMPSPEED = 200;

const LASERDMG = 10; # LaserTurret
const LASERCOOLDOWNTIME = 3; # seconds
var LaserAiming = false # true if a laser is currently amiing.

const FLIESDMG = 2; # FLIES
const FLIESSPEED = 300;

#Enemies
const TERMITEMAXHP = 3;
const AVGTERMITESPEED = 80.0; # termite 
const TERMITEATK = 1;
const TERMITELEAFCOUNT = 1;

const TERMICOPTERMAXHP = 20;
const AVGTERMICOPTERSPEED = 200.0; # TermiCopter
const SHOOTINGCYCLETIME = 2.5; # seconds
const COPTERBULLETSPERCYCLE = 3;
const BULLETVELOCITY = 400;
const BULLETDMG = 2;
const TERMICOPTERLEAFCOUNT = 8;

const BUFFMITEMAXHP = 15;
const AVGBUFFMITEPEED = 40.0; # BuffMite 
const BUFFMITEATK = 8;
const BUFFMITELEAFCOUNT = 6;
