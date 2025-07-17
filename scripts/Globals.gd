extends Node

var treeName = "Name" # the beautiful name the player gave the tree.

#Game
const GRAVITY = 9.8;
var game_mode : String = "tutorial" # the default game mode is tutorial
const PLAYER_STARTING_LEAVES := 20; # the currency for unlocking new weapons
var player_leaves : int = PLAYER_STARTING_LEAVES;

#Tree
const MAXHP = 100; # Hp
var currHp = MAXHP;

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

const TERMICOPTERMAXHP = 20;
const AVGTERMICOPTERSPEED = 200.0; # TermiCopter
const SHOOTINGCYCLETIME = 3; # seconds
const BULLETVELOCITY = 400;
const BULLETDMG = 2;
