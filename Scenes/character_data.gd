extends Node2D

@export var mode = "level"

var player1Percent = 1
var player2Percent = 1
var player1Stocks = 3
var player2Stocks = 3

#whether the players are hueshifted
var player1Hue = false
var player2Hue = false

var stageState = "barriers"
var stageID = 0

class character:
	#basic things
	var name = "" #the character's name
	var description = "" #The description for the character select
	var folderName = "" #The name of the folder the character's assets are in
	
	#appearence
	var characterTall = 1 #How tall a character is
	var characterWide = 1 #how wide a character is
	var weaponTall = 2 #How tall a weapon is
	var weaponWide = 2 #How wide a weapon is
	var bulletTall = 0.5 #how tall a bullet is
	var bulletWide = 0.5 #how wide a bullet is
	var weaponSize = "long" #whether a weapon is long or short
	var hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#physics
	var moveSpeed = 400.0 #how fast the character is.
	var jumpForce = 600.0 #how powerful the character's jumps are
	var gravity = 17.0 #how much gravity affects the character
	var invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	var animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	var max_jump_count = 3 #how many times the character can jump in a row
	var weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	var wallStrength = 1500 #how much knockback touching a bouncy wall will do
	#attacks
	var fowardDamage = 9 #how much damage the forward ground attack does
	var forwardKnockback = 100 #how much knockback the forward ground attack does
	var groundUpDamage = 11 #how much damage the up ground attack does
	var groundUpKnockback = 150 #how much knockback the up ground attack does
	
	var forwardAirDamage = 7 #how much damage the forward air attack does
	var forwardAirKnockback = 10 #how much knockback the forward air attack does
	var upAirDamage = 8 #how much damage the up air attack does
	var upAirKnockback = 150 #how much knockback the up air attack does
	var downAirDamage = 9 #how much damage the down air attack does
	var downAirKnockback = 10 #how much knockback the down air attack does
	
	var bullets = true #whether a character gets bullets
	var bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	var bulletDamage = 4 #How much damage bullets do
	var bulletKnockback = 4 #How much knockback bullets do
	
	var forwardDashDamage = 7 #how much damage the forward dash attack does
	var forwardDashKnockback = 10 #how much knockback the forward dash attack does
	var upDashDamage = 8 #how much damage the up Dash attack does
	var upDashKnockback = 150 #how much knockback the up Dash attack does
	var downDashDamage = 9 #how much damage the down Dash attack does
	var downDashKnockback = 10 #how much knockback the down Dash attack does
	var dashMomentum = 2000 #how much of a speedboost dashing gives
	var dashJump = 600 #How high an updash boosts you
	
var characterList = [character.new(), character.new(), character.new(), character.new(), character.new(), character.new(), character.new(), character.new(), character.new(), character.new(), character.new()]
	
	
	#sets the correct stage
func _ready() -> void:
	if mode != "select": #So the game doesn't break on the character selection screen
		if stageID == 0:
			get_node("/root/level/pillars").texture = load("res://backgrounds/Cathedral_levelB.png")
			get_node("/root/level/pillars/noPillars").texture = load("res://backgrounds/Cathedral_level.png")
		elif stageID == 1:
			get_node("/root/level/pillars").texture = load("res://backgrounds/FacilityB.PNG")
			get_node("/root/level/pillars/noPillars").texture = load("res://backgrounds/Facility.PNG")
		elif stageID == 2:
			get_node("/root/level/pillars").texture = load("res://backgrounds/Forest_levelB.png")
			get_node("/root/level/pillars/noPillars").texture = load("res://backgrounds/Forest_level.png")
		elif stageID == 3:
			get_node("/root/level/pillars").texture = load("res://backgrounds/NaturaB.png")
			get_node("/root/level/pillars/noPillars").texture = load("res://backgrounds/Natura.png")
		
	var c = 0 #A counter for which character the list is on
	
	#2bro's stats
	#basic things
	characterList[c].name = "2Br0" #the character's name
	characterList[c].description = "There is no one to bring back this brave little robot if he falls, so he doesn’t plan on it!" #The description for the character select
	characterList[c].folderName = "2bro" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 1
	
	#Vessel's stats
	#basic things
	characterList[c].name = "The Vessel" #the character's name
	characterList[c].description = "Holder of the cursed scarf. An empty cairn, an amphora with no wine, a plunderer of hidden treasures and forbidden pyramids." #The description for the character select
	characterList[c].folderName = "Vessel" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = false #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	
	
	c = 2 
	
	#Rowan's stats
	#basic things
	characterList[c].name = "Rowan" #the character's name
	characterList[c].description = "Where there is evil, there must always be good to eradicate it, Rowan Hayes has been empowered by the gods to survive the wrath of the sun and kill his prey." #The description for the character select
	characterList[c].folderName = "Rowan" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = false #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 3
	
	#Sanguina's stats
	#basic things
	characterList[c].name = "Sanguina" #the character's name
	characterList[c].description = "The Bloodcurdling matriarch of clan Moore stands proudly in the sun, ready to continue her rampage." #The description for the character select
	characterList[c].folderName = "Sanguina" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = false #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 4
	
	#Astrid's stats
	#basic things
	characterList[c].name = "Astrid" #the character's name
	characterList[c].description = "A human who was cursed by a mage and gained bird wings. Cleric of Jn’a and Zon, don’t ask her how she manages it, also she has a gun." #The description for the character select
	characterList[c].folderName = "Astrid" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "short" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	
	c = 5
	
	#Kal's stats
	#basic things
	characterList[c].name = "Kal" #the character's name
	characterList[c].description = "The Emperor of Steel, Dragonrider of Ulgrimoxx, King of Halendor, and Father of 3. Retired adventurer." #The description for the character select
	characterList[c].folderName = "Kal" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = false #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 6
	
	#The Best's stats
	#basic things
	characterList[c].name = "The Best" #the character's name
	characterList[c].description = "Prince of the underworld.  Often gets into trouble from acting before thinking things through." #The description for the character select
	characterList[c].folderName = "theBest" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "short" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 7
	
	#Nitrus's stats
	#basic things
	characterList[c].name = "Nitrus" #the character's name
	characterList[c].description = "A sylph of smog. Host of explosively entertaining parties and the Dark Lord’s loyal servant." #The description for the character select
	characterList[c].folderName = "Nitrus" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "short" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 8
	
	#Werewolf's stats
	#basic things
	characterList[c].name = "Werewolf" #the character's name
	characterList[c].description = "Looks like they have a better hold of their form nowadays. Former keeper of the Lodge outside Silbervane, currently? Looking for a fight!" #The description for the character select
	characterList[c].folderName = "Werewolf" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "short" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = false #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 9
	
	#Corn Gun's stats
	#basic things
	characterList[c].name = "Corn Gun Guy" #the character's name
	characterList[c].description = "He’s here! He’s there! He’s…. In a lot of these games. He's promised not to use his back to life powers during the battle so there’s that!" #The description for the character select
	characterList[c].folderName = "CornGun" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "short" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
	
	c = 10
	
	#Ai Corn Gun's stats
	#basic things
	characterList[c].name = "Slop Gun.AI" #the character's name
	characterList[c].description = "Corn Gun sold his soul for a fraction of power that the pen holds." #The description for the character select
	characterList[c].folderName = "CornGunAi" #The name of the folder the character's assets are in
	
	#appearence
	characterList[c].characterTall = 1 #How tall a character is
	characterList[c].characterWide = 1 #how wide a character is
	characterList[c].weaponTall = 2 #How tall a weapon is
	characterList[c].weaponWide = 2 #How wide a weapon is
	characterList[c].bulletTall = 0.5 #how tall a bullet is
	characterList[c].bulletWide = 0.5 #how wide a bullet is
	
	
	#physics
	characterList[c].moveSpeed = 400.0 #how fast the character is.
	characterList[c].jumpForce = 600.0 #how powerful the character's jumps are
	characterList[c].gravity = 17.0 #how much gravity affects the character
	characterList[c].invunerableTimer = 0.2 #how much mercy invinicblity there is after an attack
	characterList[c].animationSpeed = 1 #how fast the character's animations are, higher numbers are faster
	characterList[c].max_jump_count = 3 #how many times the character can jump in a row
	characterList[c].weight = 0.9 #how fast knockback degenerates, the smaller the number, the heavier they are.  Can't go beyond 9.99999
	characterList[c].wallStrength = 1500 #how much knockback touching a bouncy wall will do
	characterList[c].weaponSize = "long" #whether a weapon is long or short
	characterList[c].hueShift = 0.5 #The cue the character gets shifted when two players pick the same character, a value between 0 and 1
	
	#attacks
	characterList[c].fowardDamage = 9 #how much damage the forward ground attack does
	characterList[c].forwardKnockback = 100 #how much knockback the forward ground attack does
	characterList[c].groundUpDamage = 11 #how much damage the up ground attack does
	characterList[c].groundUpKnockback = 150 #how much knockback the up ground attack does
	
	characterList[c].forwardAirDamage = 7 #how much damage the forward air attack does
	characterList[c].forwardAirKnockback = 100 #how much knockback the forward air attack does
	characterList[c].upAirDamage = 8 #how much damage the up air attack does
	characterList[c].upAirKnockback = 150 #how much knockback the up air attack does
	characterList[c].downAirDamage = 9 #how much damage the down air attack does
	characterList[c].downAirKnockback = 100 #how much knockback the down air attack does
	
	characterList[c].bullets = true #whether a character gets bullets
	characterList[c].bulletSpeed = 0.5 #How fast bullets are
	#For some reason bullet damage is really unstable.  At 10 damage, it appears to deal half damage + or - 1
	characterList[c].bulletDamage = 4 #How much damage bullets do
	characterList[c].bulletKnockback = 30 #How much knockback bullets do
	
	characterList[c].forwardDashDamage = 7 #how much damage the forward dash attack does
	characterList[c].forwardDashKnockback = 100 #how much knockback the forward dash attack does
	characterList[c].upDashDamage = 8 #how much damage the up Dash attack does
	characterList[c].upDashKnockback = 150 #how much knockback the up Dash attack does
	characterList[c].downDashDamage = 9 #how much damage the down Dash attack does
	characterList[c].downDashKnockback = 100 #how much knockback the down Dash attack does
	characterList[c].dashMomentum = 2000 #how much of a speedboost dashing gives
	characterList[c].dashJump = 600 #How high an updash boosts you
