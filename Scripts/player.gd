extends CharacterBody2D

# --------- VARIABLES ---------- #
var storyWait = false  #Make this true for story mode so the characters still stay still during cutscenes, call storyGo() afterwards


@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 400
@export var jump_force : float = 600
@export var gravity : float = 30
@export var max_jump_count : int = 3
var jump_count : int = 3

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = true

var is_grounded : bool = false
var cpuState = "wait" #used for keeping track of what the CPU is doing
var characterID = 0 #which character you currently are
var percentPath #the path to the percent meter
var backupPlayer #Used for storymode to disable controls

@onready var player_sprite = $spriteBase
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles

var facingDirrection = "right" #the dirrection you are facing, used for knockback
var state = "wait" #determines if your in an attack or not
var canAttack = true #So you don't attack every frame
@export var player = "one" #Either one, two or cpu
var scoreBoard #The node with the character data and character %s
var animationSpeed = 1 #how fast the character's animations are
var weight = 0.9 #How heavy a character is, the smaller the number, the heavier they are.  Can't go beyond 9.99999
var wallStrength = 1500 #how much knockback touching a bouncy wall will do

signal doKnockback(selectedPlayer, knockbackPower, dirrection)
var knockbackVelocity = Vector2(0,0) #how much velocity is in the knockback
var normalVelocity = Vector2(0,0) #normal velocity, not knockback

var hueShift = 0.5

#------- Attack Variables --------------------
var invunerableTimer = 0.2 #&Use the other character's invuerable timer
var forwardDamage = 9 #how much damage the forward ground attack does
var forwardKnockback = 100 #how much damage the forward ground attack does
var groundUpDamage = 11 #how much damage the up ground attack does
var groundUpKnockback = 150 #how much damage the up ground attack does

var forwardAirDamage = 7 #how much damage the forward air attack does
var forwardAirKnockback = 80 #how much knockback the forward air attack does
var upAirDamage = 8 #how much damage the up air attack does
var upAirKnockback = 150 #how much knockback the up air attack does
var downAirDamage = 9 #how much damage the down air attack does
var downAirKnockback = 10 #how much knockback the down air attack does

var forwardDashDamage = 7 #how much damage the forward dash attack does
var forwardDashKnockback = 10 #how much knockback the forward dash attack does
var upDashDamage = 8 #how much damage the up Dash attack does
var upDashKnockback = 150 #how much knockback the up Dash attack does
var downDashDamage = 9 #how much damage the down Dash attack does
var downDashKnockback = 10 #how much knockback the down Dash attack does
var dashMomentum = 2000 #how much of a speedboost dashing gives
var dashJump = 600 #How high an updash boosts you

var bullets = true #whether a character gets bullets
var bulletSpeed = 0.5 #How fast bullets are
var bulletDamage = 4 #How much damage bullets do
var bulletKnockback = 4 #How much knockback bullets do
var bulletTall = 1 #How tall the bullets are
var bulletWide = 1 #How wide the bullets are
var shotDirrection = "left" #Used to keep track of which dirrection you shoot at, not a variable to change between characters
var weaponSize = "long"

func _ready() -> void:
	if player == "none": #for the character select menu
		scoreBoard = get_node("/root/CharacterSelect/Background/CharacterData")
		characterID = 0
		$coolDown.start(0.1)
		await $coolDown.timeout
		selectDress()
		return
	
	scoreBoard = get_node("/root/level/CharacterData")
	if player == "one":
		$AnimationPlayer.play("player1")
	else:
		$AnimationPlayer.play("player2")
	
	$coolDown.start(0.1)
	await $coolDown.timeout
		
	#character's appearence
	$spriteBase/Body.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/body.png")
	$spriteBase/Body/Head.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/head.png")
	$spriteBase/Body/Head/HairCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/hairCape.png")
	$spriteBase/Body/BodyCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bodyCape.png")
	$spriteBase/Body/tailCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/tail.png")
	$spriteBase/Body/armTop/TopArmUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topArmUp.png")
	$spriteBase/Body/armTop/TopArmUp/TopArmDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topArmDown.png")
	$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/weapon.png")
	$spriteBase/Body/armBottom/BottomArmUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomArmUp.png")
	$spriteBase/Body/armBottom/BottomArmUp/BottomArmDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomArmDown.png")
	$spriteBase/Body/legTop/TopLegUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topLegUp.png")
	$spriteBase/Body/legTop/TopLegUp/TopLegDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topLegDown.png")
	$spriteBase/Body/legTop/TopLegUp/TopLegDown/TopFoot.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topFoot.png")
	$spriteBase/Body/legBottom/BottomLegUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomLegUp.png")
	$spriteBase/Body/legBottom/BottomLegUp/BottomLegDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomLegDown.png")
	$spriteBase/Body/legBottom/BottomLegUp/BottomLegDown/BottomFoot.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomFoot.png")
		
		
	#character's atributes
	if player == "one":
		self.scale.y = scoreBoard.characterList[characterID].characterTall
		self.scale.x = scoreBoard.characterList[characterID].characterWide
		percentPath = get_node("/root/level/percentMeters/player1Percent")
	else:
		self.scale.y = -scoreBoard.characterList[characterID].characterTall
		self.scale.x = scoreBoard.characterList[characterID].characterWide
		percentPath = get_node("/root/level/percentMeters/player2Percent")
		
	percentPath.characterID = characterID
	percentPath.go() #setting up the percent bar
		
	$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon.scale.y= scoreBoard.characterList[characterID].weaponTall
	$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon.scale.x = scoreBoard.characterList[characterID].weaponWide
	bulletTall = scoreBoard.characterList[characterID].bulletTall
	bulletWide = scoreBoard.characterList[characterID].bulletWide
	weaponSize = scoreBoard.characterList[characterID].weaponSize
	hueShift = scoreBoard.characterList[characterID].hueShift
	
	if scoreBoard.player1Hue == true && player == "one":
		$spriteBase/Body.material.set_shader_parameter("Shift_Hue", hueShift)
	elif scoreBoard.player2Hue == true && player == "two" || scoreBoard.player2Hue == true && player == "cpu":
		$spriteBase/Body.material.set_shader_parameter("Shift_Hue", hueShift)
		
	
	#physics
	move_speed = scoreBoard.characterList[characterID].moveSpeed
	jump_force = scoreBoard.characterList[characterID].jumpForce
	gravity = scoreBoard.characterList[characterID].gravity
	invunerableTimer = scoreBoard.characterList[characterID].invunerableTimer
	$AnimationPlayer.speed_scale = scoreBoard.characterList[characterID].animationSpeed
	max_jump_count = scoreBoard.characterList[characterID].max_jump_count
	weight = scoreBoard.characterList[characterID].weight
	wallStrength = scoreBoard.characterList[characterID].wallStrength
	bullets = scoreBoard.characterList[characterID].bullets
	if scoreBoard.characterList[characterID].weaponSize == "short":
		$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon/hitbox/long.disabled = true
	else:
		$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon/hitbox/short.disabled = true
	

	forwardDamage = scoreBoard.characterList[characterID].fowardDamage
	forwardKnockback = scoreBoard.characterList[characterID].forwardKnockback
	groundUpDamage = scoreBoard.characterList[characterID].groundUpDamage
	groundUpKnockback = scoreBoard.characterList[characterID].groundUpKnockback
	
	forwardAirDamage = scoreBoard.characterList[characterID].forwardAirDamage
	forwardAirKnockback = scoreBoard.characterList[characterID].forwardAirKnockback
	upAirDamage = scoreBoard.characterList[characterID].upAirDamage
	upAirKnockback = scoreBoard.characterList[characterID].upAirKnockback
	downAirDamage = scoreBoard.characterList[characterID].downAirDamage
	downAirKnockback = scoreBoard.characterList[characterID].downAirKnockback
	
	bullets = scoreBoard.characterList[characterID].bullets
	bulletSpeed = scoreBoard.characterList[characterID].bulletSpeed
	bulletDamage = scoreBoard.characterList[characterID].bulletDamage
	bulletKnockback = scoreBoard.characterList[characterID].bulletKnockback
	
	forwardDashDamage = scoreBoard.characterList[characterID].forwardDashDamage
	forwardDashKnockback = scoreBoard.characterList[characterID].forwardDashKnockback
	upDashDamage = scoreBoard.characterList[characterID].upDashDamage
	upDashKnockback = scoreBoard.characterList[characterID].upDashKnockback
	downDashDamage = scoreBoard.characterList[characterID].downDashDamage
	downDashKnockback = scoreBoard.characterList[characterID].downDashKnockback
	dashMomentum = scoreBoard.characterList[characterID].dashMomentum
	dashJump = scoreBoard.characterList[characterID].dashJump
	
	if storyWait == false:
		state = "free"
		cpuState = "free"
	else:
		backupPlayer = player
		player = "none"

#used with storymode, re-enables movement after the cutscene
func storyGo():
	state = "free"
	cpuState = "free"
	player = backupPlayer
	
	
# --------- Enemy AI ---------- #

#Tells the AI if they're near the edge to get away from the edge
func avoidEdges():
	var dirrectionModifier = 0
	Input.action_release("up 2")
	Input.action_release("down 2")
	Input.action_release("dash 2")
	Input.action_release("right 2")
	Input.action_release("left 2")
	Input.action_release("jump 2")
	
	if position.x > 820: #Telling AI which dirrection to head towards
		dirrectionModifier = -1
		Input.action_press("left 2")
		facingDirrection = "left"
		player_sprite.scale.x = abs(player_sprite.scale.x)
	elif position.x < 300:
		dirrectionModifier = 1
		Input.action_press("right 2")
		facingDirrection = "right"
		player_sprite.scale.x = -abs(player_sprite.scale.x)
		
	if dirrectionModifier == 0:
		return true #returning true so the rest of the CPU functions can trigger
		
	cpuState = "escape"
	
	if position.y < 480: #Dashing back to the stage if the enemy is above the stage
		Input.action_press("dash 2", 1)
	elif jump_count > 0: #If you have more than one jump, dashes instead
		Input.action_press("up 2", 1)
		if state == "free":
			if facingDirrection == "right": #They were up dashing upsidedown so this is a sloppy fix
				facingDirrection = "left"
				player_sprite.scale.x = abs(player_sprite.scale.x)
			else:
				facingDirrection = "right"
				player_sprite.scale.x = -abs(player_sprite.scale.x)
			Input.action_press("dash 2", 1)
	
	else:
		Input.action_press("jump 2", 1)
	
	return false
	




# --------- BUILT-IN FUNCTIONS ---------- #

func _process(_delta):
	if player == "cpu":
		Input.action_release("attack 2")
		Input.action_release("shoot 2")
		avoidEdges()
		if cpuState == "free":
			#facing the dirrection of the player
			if self.position.x - get_node("/root/level/Player").position.x > 0:
				facingDirrection = "left"
				player_sprite.scale.x = abs(player_sprite.scale.x)
			else:
				facingDirrection = "right"
				player_sprite.scale.x = -abs(player_sprite.scale.x)
			#if you're close by
			if abs(self.position.x - get_node("/root/level/Player").position.x) < 151:
				#if Y value is close then do ground attack
				if abs(self.position.y - get_node("/root/level/Player").position.y) < 180:
					Input.action_press("attack 2")
					cpuState = "attack"
				#Checking if other player is above or below CPU
				elif self.position.y - get_node("/root/level/Player").position.y < 0:
					Input.action_press("down 2") #if below dash down
					Input.action_press("dash 2")
					player_sprite.scale.x = -player_sprite.scale.x #Why do the CPUs keep dashing upsideDown?
					cpuState = "dash"
				else:
					Input.action_press("up 2") #else dash up
					Input.action_press("dash 2")
					player_sprite.scale.x = -player_sprite.scale.x #Why do the CPUs keep dashing upsideDown?
					cpuState = "dash"
			else: #if you're not close
				if abs(self.position.y - get_node("/root/level/Player").position.y) < 180: #if you're in range
					if bullets == true: #ranged characters shoot bullets
						cpuState = "shoot"
						Input.action_press("shoot 2")
					else:
						cpuState = "shoot"
						Input.action_press("dash 2")
						
						#checking if the player is above the enemy, if so they're dashing up to their height
				elif self.position.y - get_node("/root/level/Player").position.y > 0: 
					#Input.action_release("down 2")
					if facingDirrection == "left":
						facingDirrection = "right"
					else:
						facingDirrection = "left"
					#player_sprite.scale.x = -player_sprite.scale.x #Why do the CPUs keep dashing upsideDown?
					Input.action_press("up 2") #else dash up
					Input.action_press("dash 2")
					cpuState = "dash"
					
	
	# Calling functions
	movement()
	player_animations()
	flip_player()
	
	#controlling if the barriers are on the stage
	if player == "one" && scoreBoard.stageState == "barriers":
		if scoreBoard.player1Percent > 99 || scoreBoard.player2Percent > 99:
			scoreBoard.stageState = "noWalls"
			get_node("/root/level/AnimationPlayer").play("pillarFade")
	
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	# Gravity
	if !is_on_floor():
		normalVelocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	# Move Player
	var inputAxis = 0
	
	if state == "free" || state == "attacka" || state == "attackad" || state == "attackau":
		
		if player == "one": #getting player input
			inputAxis = Input.get_axis("Left 1", "Right 1")
		elif player == "two":
			inputAxis = Input.get_axis("left 2", "right 2")
		
	normalVelocity = Vector2(inputAxis * move_speed, normalVelocity.y)
	velocity = normalVelocity + knockbackVelocity
	move_and_slide()
	
	#slowly decreasing the knockback velocity
	knockbackVelocity = knockbackVelocity * weight
	#if knockbackVelocity.x < 1.1:
		#knockbackVelocity.x = 1
	#if knockbackVelocity.y < 1.1:
		#knockbackVelocity.y = 0
	
	if state == "free": #attacks	
		if player == "one":	
			if Input.is_action_just_pressed("attack 1"):
				if is_on_floor():
					if Input.is_action_pressed("up 1"): #up ground attack
						state = "attackgu"
						$AnimationPlayer.play("groundUp")
					
					else: #forward ground attack
						state = "attackg"
						$AnimationPlayer.play("forwardGround")
				else:
					if Input.is_action_pressed("up 1"): #up air attack
						state = "attackau"
						$AnimationPlayer.play("upAir")
						
					elif Input.is_action_pressed("down 1"): #down air attack
						state = "attackad"
						$AnimationPlayer.play("downAir")
					
					else: #forward air attack
						state = "attacka"
						$AnimationPlayer.play("fowardAir")
						
				#dash attacks
			elif Input.is_action_just_pressed("dash 1") && jump_count > 0:
				if jump_count == max_jump_count: #if you up dash from the ground it won't count as a jump, so I'm subtracting two to fix this behavior
					jump_count -= 1 #dashing costs a jump
				jump_count -= 1
				if Input.is_action_pressed("up 1"): #up air attack
					state = "attackdu"
					if facingDirrection == "right": #So the sprite rotates the right way during animations
						$AnimationPlayer.play("dashUp")
					else:
						$AnimationPlayer.play("dashDown")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
						
				elif Input.is_action_pressed("down 1"): #down air attack
					state = "attackdd"
					if facingDirrection == "right": #So the sprite rotates the right way during animations
						$AnimationPlayer.play("dashDown")
					else:
						$AnimationPlayer.play("dashUp")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
				
				else:
					state = "attackd"
					$AnimationPlayer.play("dashForward")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
				
				
				
				
			elif Input.is_action_just_pressed("shoot 1") && bullets == true:
				if Input.is_action_pressed("up 1"):
					shotDirrection = "up"
					$AnimationPlayer.play("shootUp")
				elif Input.is_action_pressed("down 1"):
					shotDirrection = "down"
					$AnimationPlayer.play("shootDown")
				elif facingDirrection == "left":
					shotDirrection = "left"
					$AnimationPlayer.play("shootForward")
				else:
					shotDirrection = "right"
					$AnimationPlayer.play("shootForward")
				state = "shoot"
				$shotTimer.start(0.3 * animationSpeed)
		else:
			if Input.is_action_just_pressed("attack 2"):
				if is_on_floor():
					if Input.is_action_pressed("up 2"): #up ground attack
						state = "attackgu"
						$AnimationPlayer.play("groundUp")
					
					else: #forward ground attack
						state = "attackg"
						$AnimationPlayer.play("forwardGround")
				else:
					if Input.is_action_pressed("up 2"): #up air attack
						state = "attackau"
						$AnimationPlayer.play("upAir")
						
					elif Input.is_action_pressed("down 2"): #down air attack
						state = "attackad"
						$AnimationPlayer.play("downAir")
					
					else: #forward air attack
						state = "attacka"
						$AnimationPlayer.play("fowardAir")
						
				#dash attacks
			elif Input.is_action_just_pressed("dash 2") && jump_count > 0:
				if jump_count == max_jump_count: #if you up dash from the ground it won't count as a jump, so I'm subtracting two to fix this behavior
					jump_count -= 1 #dashing costs a jump
				jump_count -= 1
				if Input.is_action_pressed("up 2"): #up air attack
					state = "attackdu"
					if facingDirrection == "right": #So the sprite rotates the right way during animations
						$AnimationPlayer.play("dashUp")
					else:
						$AnimationPlayer.play("dashDown")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
						
				elif Input.is_action_pressed("down 2"): #down air attack
					state = "attackdd"
					if facingDirrection == "right": #So the sprite rotates the right way during animations
						$AnimationPlayer.play("dashDown")
					else:
						$AnimationPlayer.play("dashUp")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
				
				else:
					state = "attackd"
					if player == "two": #Player two's sprite is flipped.  I programmed the CPU this way, and now I gotta flip the dirrection, yay sphagetti code
						if facingDirrection == "left":
							facingDirrection = "right"
						else:
							facingDirrection = "left"
					$AnimationPlayer.play("dashForward")
					$dashTimera.start(0.2 * animationSpeed) #How long it takes for the dash speed boost to take effect
				
				
				
				
			elif Input.is_action_just_pressed("shoot 2") && bullets == true:
				if Input.is_action_pressed("up 2"):
					shotDirrection = "up"
					$AnimationPlayer.play("shootUp")
				elif Input.is_action_pressed("down 2"):
					shotDirrection = "down"
					$AnimationPlayer.play("shootDown")
				elif player == "cpu":
					if facingDirrection == "left":
						shotDirrection = "left"
						$AnimationPlayer.play("shootForward")
					else:
						shotDirrection = "right"
						$AnimationPlayer.play("shootForward")
				elif player == "two":
					if facingDirrection == "right": #I programed the AI's movement backwards, and now I gotta revsese stuff for player 2, yay...
						shotDirrection = "left"
						$AnimationPlayer.play("shootForward")
					else:
						shotDirrection = "right"
						$AnimationPlayer.play("shootForward")
				
				state = "shoot"
				$shotTimer.start(0.3 * animationSpeed)
	
	
	
	

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if player == "one":
		if state == "free" || state == "attacka" || state == "attackad" || state == "attackau":
			if Input.is_action_just_pressed("Jump 1"):
				if is_on_floor() and !double_jump:
					jump()
				elif double_jump and jump_count > 0:
					jump()
					jump_count -= 1
	else:
		if state == "free" || state == "attacka" || state == "attackad" || state == "attackau":
			if Input.is_action_just_pressed("jump 2"):
				if is_on_floor() and !double_jump:
					jump()
				elif double_jump and jump_count > 0:
					jump()
					jump_count -= 1

# Player jump
func jump():
	#jump_tween()
	#AudioManager.jump_sfx.play()
	normalVelocity.y = -jump_force

# Handle Player Animations
func player_animations():
	if velocity[0] == 0 && is_on_floor() && state == "free": #&Idle animation
		$AnimationPlayer.play("RESET")
	elif abs(velocity.x) > 0 && state == "free" && $AnimationPlayer.current_animation != "walk" && is_on_floor() == true:
		$AnimationPlayer.play("walk")
	elif velocity.y < 0 && state == "free" && $AnimationPlayer.current_animation != "jump" && !is_on_floor():
		$AnimationPlayer.play("jump")
	elif velocity.y > 0 && state == "free" && $AnimationPlayer.current_animation != "fall" && !is_on_floor():
		$AnimationPlayer.play("fall")
		
		
	#particle_trails.emitting = false
	#
	#if is_on_floor():
		#if abs(velocity.x) > 0:
			#particle_trails.emitting = true
			#player_sprite.play("Walk", 1.5)
		#else:
			#player_sprite.play("Idle")
	#else:
		#player_sprite.play("Jump")

# Flip player sprite based on X velocity
#This function is so broken I have to do this manually for CPUS or it breaks
func flip_player():
	if state != "attackd":
		if velocity.x < 0 && Input.is_action_pressed("Left 1") && player == "one" || velocity.x > 0 && Input.is_action_pressed("right 2") && player == "two":
			player_sprite.scale.x = -abs(player_sprite.scale.x)
			facingDirrection = "left"
		elif velocity.x > 0 && Input.is_action_pressed("Right 1") && player == "one" || velocity.x < 0 && Input.is_action_pressed("left 2") && player == "two":
			player_sprite.scale.x = abs(player_sprite.scale.x)
			facingDirrection = "right"

# Tween Animations
#func death_tween():
	#var tween = create_tween()
	#tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	#await tween.finished
	#global_position = spawn_point.global_position
	#await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	#respawn_tween()
#
#func respawn_tween():
	#var tween = create_tween()
	#tween.stop(); tween.play()
	#tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	pass
	#if _body.is_in_group("Traps"):
		#AudioManager.death_sfx.play()
		#death_particles.emitting = true
		#death_tween()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if state == "attackg" || state == "attackgu" || state == "attacka" || state == "attackad" || state == "attackau" || state == "attackd" || state == "attackdu" || state == "attackdd" || state == "noDash":
		state = "free"
		cpuState = "free"

#$Important
#All of the attacks featuring the sword
func _on_hitbox_area_entered(area: Area2D) -> void:  #the hurtbox for the sword
	if state == "attackg" && canAttack == true: #forward ground attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += forwardDamage
			doKnockback.emit("two",forwardKnockback,facingDirrection)
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += forwardDamage
			doKnockback.emit("one",forwardKnockback,facingDirrection)
			
	elif state == "attackgu" && canAttack == true: #forward ground attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += groundUpDamage
			doKnockback.emit("two",groundUpKnockback,"up")
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += groundUpDamage
			doKnockback.emit("one",groundUpKnockback,"up")
			
	elif state == "attackau" && canAttack == true: #up air attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += upAirDamage
			doKnockback.emit("two",upAirKnockback,"up")
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += upAirDamage
			doKnockback.emit("one",upAirKnockback,"up")
			
	elif state == "attackad" && canAttack == true: #down air attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += downAirDamage
			doKnockback.emit("two",downAirKnockback,"down")
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += downAirDamage
			doKnockback.emit("one",downAirKnockback,"down")
			
	elif state == "attacka" && canAttack == true: #foward air attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += forwardAirDamage
			doKnockback.emit("two",forwardAirKnockback,facingDirrection)
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += forwardAirDamage
			doKnockback.emit("one", forwardAirKnockback,facingDirrection)
			
		
			
		
		
func mercy(): #mercy invisinbilty, so attacks don't attack every frame
	canAttack = false #Making sure you don't attack every frame
	$coolDown.wait_time = invunerableTimer
	$coolDown.start()


func _on_cool_down_timeout() -> void:
	canAttack = true

#does knockback.  selectedPlayer is so the right player gets knocked back, knockback power is the power for that attack, dirrection is the dirrection the other player was in
func _on_do_knockback(selectedPlayer: Variant, knockbackPower: Variant, dirrection: Variant) -> void:
	#updating the % boards
	percentPath.update(scoreBoard.player1Percent)
	
	if player == "one" && selectedPlayer == "one" || player != "one" && selectedPlayer == "two": #if your the one being knocked back
		$"hurt flash".play("hurt")
		var dirrectionKnockback #the dirrection the other person was facing
		if dirrection == "right":
			dirrectionKnockback = Vector2(50,1)
		elif dirrection == "left":
			dirrectionKnockback = Vector2(-50,1)
		elif dirrection == "down" && facingDirrection == "left":
			dirrectionKnockback = Vector2(-30,-50)
		elif dirrection == "down" && facingDirrection == "right":
			dirrectionKnockback = Vector2(30,-50)
		elif dirrection == "up" && facingDirrection == "right":
			dirrectionKnockback = Vector2(30,-70)
		else:
			dirrectionKnockback = Vector2(-30,-70)
			
		var globalPercent #your current percent
		if selectedPlayer == "one":
			globalPercent = scoreBoard.player1Percent
		else:
			globalPercent = scoreBoard.player2Percent
		
		knockbackVelocity = (dirrectionKnockback - velocity).normalized() * knockbackPower * (globalPercent/10)
		velocity += knockbackVelocity
		move_and_slide()


func _on_player_do_knockback(selectedPlayer: Variant, knockbackPower: Variant, dirrection: Variant) -> void:
	_on_do_knockback(selectedPlayer, knockbackPower, dirrection)


#func _on_blast_zone_area_entered(area: Area2D) -> void:
	#
		#scoreBoard.player2Stocks -= 1
		#normalVelocity.x = 0
		#normalVelocity.y = 0
		#knockbackVelocity.x = 0
		#knockbackVelocity.y = 0
		#velocity.x = 0
		#velocity.y = 0
		#global_position = spawn_point.global_position

#when player 1 enters the blast zone
func _on_blast_zone_1_area_entered(area: Area2D) -> void:
	if player == "one":
		scoreBoard.player1Stocks -= 1
		scoreBoard.player1Percent = 1
		normalVelocity.x = 0
		normalVelocity.y = 0
		knockbackVelocity.x = 0
		knockbackVelocity.y = 0
		velocity.x = 0
		velocity.y = 0
		global_position = spawn_point.global_position
		jump_count = max_jump_count
		
		if scoreBoard.player1Stocks > 0:
			percentPath.stock(scoreBoard.player1Stocks)
		
		if scoreBoard.stageState == "noWalls":
			if scoreBoard.player1Percent < 100 && scoreBoard.player2Percent < 100:
				scoreBoard.stageState = "barriers"
				get_node("/root/level/AnimationPlayer").play_backwards("pillarFade")

#when player 2 enters the blast zone
func _on_blast_zone_2_area_entered(area: Area2D) -> void:
	if player != "one":
		scoreBoard.player2Stocks -= 1
		scoreBoard.player2Percent = 1
		normalVelocity.x = 0
		normalVelocity.y = 0
		knockbackVelocity.x = 0
		knockbackVelocity.y = 0
		velocity.x = 0
		velocity.y = 0
		global_position = spawn_point.global_position
		jump_count = max_jump_count
		$coolDown.start(0.2)
		await $coolDown.timeout
		cpuState = "free"
		state = "free"
		
		if scoreBoard.player2Stocks > 0:
			percentPath.stock(scoreBoard.player2Stocks)
		
		if scoreBoard.stageState == "noWalls":
			if scoreBoard.player1Percent < 100 && scoreBoard.player2Percent < 100:
				scoreBoard.stageState = "barriers"
				get_node("/root/level/AnimationPlayer").play_backwards("pillarFade")


func _on_shot_timer_timeout() -> void:
	if state == "shoot": #so it doesn't trigger every timeout
		$shotTimer.wait_time = 5
		state = "wait"
		var newBullet = load("res://Scenes/Prefabs/bullet.tscn").instantiate() #setting up the bullet
		newBullet.player = player
		newBullet.damage = bulletDamage
		newBullet.knockback = bulletKnockback
		newBullet.speed = bulletSpeed
		newBullet.dirrection = shotDirrection
		newBullet.wide = bulletWide
		newBullet.tall = bulletTall
		newBullet.ID = scoreBoard.characterList[characterID].folderName
		
		if shotDirrection == "left" || shotDirrection == "right":
			newBullet.position.x = self.position.x
			newBullet.position.y = self.position.y - 50
		elif shotDirrection == "up" || shotDirrection == "down":
			newBullet.position.x = self.position.x
			newBullet.position.y = self.position.y
		
		
		get_node("/root/level").add_child(newBullet)
		
		await $AnimationPlayer.animation_finished
		state = "free" #going to the free state after the shoot animation finishes
		cpuState = "free"

#dash attacks
func _on_hitbox_dash_area_entered(area: Area2D) -> void:
	if state == "attackd" && canAttack == true: #forward ground attack
		mercy()
		if player == "one":
			scoreBoard.player2Percent += forwardDashDamage
			doKnockback.emit("two",forwardDashKnockback,facingDirrection)
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += forwardDashDamage
			doKnockback.emit("one",forwardDashKnockback,facingDirrection)
			
	elif state == "attackdd" && canAttack == true:
		mercy()
		if player == "one":
			scoreBoard.player2Percent += downDashDamage
			doKnockback.emit("two",downDashKnockback,"down")
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += forwardDashDamage
			doKnockback.emit("one",forwardDashKnockback,"down")
			
	elif state == "attackdu" && canAttack == true:
		mercy()
		if player == "one":
			scoreBoard.player2Percent += upDashDamage
			doKnockback.emit("two",upDashKnockback,"up")
		elif player == "two" || player == "cpu":
			scoreBoard.player1Percent += upDashDamage
			doKnockback.emit("one",upDashKnockback,"up")

#how long it takes until the dash part of the dash attack starts
func _on_dash_timera_timeout() -> void:
	if state == "attackdu":
		normalVelocity.y = -dashJump
	elif state == "attackdd":
		normalVelocity.y += dashJump
	else:
		if facingDirrection == "left":
			knockbackVelocity.x += -dashMomentum
		else:
			knockbackVelocity.x += dashMomentum
		#So you regain control during the endlag
		$dashTimerb.start(0.4 * animationSpeed)
	
	

#so you regain control during endlag
func _on_dash_timerb_timeout() -> void:
	state = "noDash"


func _on_player_2_do_knockback(selectedPlayer: Variant, knockbackPower: Variant, dirrection: Variant) -> void:
	_on_do_knockback(selectedPlayer, knockbackPower, dirrection)

#For player one's left bouncy wall
func _on_pillars_left_1_area_entered(area: Area2D) -> void:
	var dirrectionKnockback = Vector2(-50,1)
	knockbackVelocity = (dirrectionKnockback - velocity).normalized() * wallStrength
	velocity += knockbackVelocity
	move_and_slide()

#For player two's left bouncy wall
func _on_pillars_left_2_area_entered(area: Area2D) -> void:
	var dirrectionKnockback = Vector2(-50,1)
	knockbackVelocity = (dirrectionKnockback - velocity).normalized() * wallStrength
	velocity += knockbackVelocity
	move_and_slide()

#For player one's right bouncy wall
func _on_pillars_right_1_area_entered(area: Area2D) -> void:
	var dirrectionKnockback = Vector2(-50,1)
	knockbackVelocity = (dirrectionKnockback - velocity).normalized() * wallStrength
	velocity += knockbackVelocity
	move_and_slide()

#For player one's right bouncy wall
func _on_pillars_right_2_area_entsered(area: Area2D) -> void:
	var dirrectionKnockback = Vector2(-50,1)
	knockbackVelocity = (dirrectionKnockback - velocity).normalized() * wallStrength
	velocity += knockbackVelocity
	move_and_slide()

#For player two's right bouncy wall
func _on_pillars_right_2_area_entered(area: Area2D) -> void:
	var dirrectionKnockback = Vector2(-50,1)
	knockbackVelocity = (dirrectionKnockback - velocity).normalized() * wallStrength
	velocity += knockbackVelocity
	move_and_slide()
	
	#for the player character's appearence on the character select screen
func selectDress(hue = false):	
	$spriteBase/Body.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/body.png")
	$spriteBase/Body/Head.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/head.png")
	$spriteBase/Body/Head/HairCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/hairCape.png")
	$spriteBase/Body/BodyCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bodyCape.png")
	$spriteBase/Body/tailCape.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/tail.png")
	$spriteBase/Body/armTop/TopArmUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topArmUp.png")
	$spriteBase/Body/armTop/TopArmUp/TopArmDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topArmDown.png")
	$spriteBase/Body/armTop/TopArmUp/TopArmDown/Weapon.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/weapon.png")
	$spriteBase/Body/armBottom/BottomArmUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomArmUp.png")
	$spriteBase/Body/armBottom/BottomArmUp/BottomArmDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomArmDown.png")
	$spriteBase/Body/legTop/TopLegUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topLegUp.png")
	$spriteBase/Body/legTop/TopLegUp/TopLegDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topLegDown.png")
	$spriteBase/Body/legTop/TopLegUp/TopLegDown/TopFoot.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/topFoot.png")
	$spriteBase/Body/legBottom/BottomLegUp.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomLegUp.png")
	$spriteBase/Body/legBottom/BottomLegUp/BottomLegDown.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomLegDown.png")
	$spriteBase/Body/legBottom/BottomLegUp/BottomLegDown/BottomFoot.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bottomFoot.png")
	
	if hue == true:
		hueShift = scoreBoard.characterList[characterID].hueShift
		$spriteBase/Body.material.set_shader_parameter("Shift_Hue", hueShift)
	else:
		$spriteBase/Body.material.set_shader_parameter("Shift_Hue", 0)
