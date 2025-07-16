extends Node

var treeName = "Name" # the beutiful name the player gave the tree.

#Game
const GRAVITY = 9.8;

#Tree
const MAXHP = 100; # Hp
var currHp = MAXHP;

#Weapons
const BOOTDMG = 5; # Boot
const STOMPSPEED = 200;

const LASERDMG = 10; # LaserTurret
var LaserAiming = false # true if a laser is currently amiing.

const FLIESDMG = 1; # FLIES
const FLIESSPEED = 200;

#Enemies
const AVGTERMITESPEED = 50.0; # termite 
const TERMITEATK = 1;
const TERMITEMAXHP = 3;

const AVGTERMICOPTERSPEED = 100.0; # TermiCopter
const SHOOTINGCYCLETIME = 3; # seconds
const BULLETVELOCITY = 400;
const BULLETDMG = 2;
const TERMICOPTERMAXHP = 20;
