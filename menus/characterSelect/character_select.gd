extends Node2D

var state = 0

var mode = "freeplay" #either freeplay or story
var layer = 1 #Used for which player your currently picking stuff for

var player1Character = 0
var player2Character = 0
var player1Hue = false
var player2Hue = false
var hue = false
var player2 = "cpu"

#0-10 are the character's IDs
#11 is random character
#12 is the CPU - plasyer two toggle

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot 1"):
		if hue == true:
			hue = false
		else:
			hue = true
			
		changeSprite()
	
	if Input.is_action_just_pressed("up 1"):
		if state == 0:
			state = 8
		elif state == 1:
			state = 11
		elif state == 2:
			state = 0
		elif state == 3:
			state = 1
		elif state == 4:
			state = 2
		elif state == 5:
			state = 3
		elif state == 6:
			state = 4
		elif state == 7:
			state = 5
		elif state == 8:
			state = 6
		elif state == 11:
			state = 7
		elif state == 12:
			state = 3
		
			
		elif state == 9 || state == 10:
			state = 0
		
		changeSprite()
		
	elif Input.is_action_just_pressed("down 1"):
		if state == 0:
			state = 2
		elif state == 1:
			state = 3
		elif state == 2:
			state = 4
		elif state == 3:
			state = 5
		elif state == 4:
			state = 6
		elif state == 5:
			state = 7
		elif state == 6:
			state = 8
		elif state == 7:
			state = 11
		elif state == 8:
			state = 0
		elif state == 11:
			state = 1
		elif state == 12:
			state = 7
			
		elif state == 9 || state == 10:
			state = 0
		
		changeSprite()
		
	elif Input.is_action_just_pressed("Right 1"):
		if state == 0:
			state = 1
		elif state == 1:
			state = 0
		elif state == 2:
			state = 3
		elif state == 3:
			state = 2
		elif state == 4:
			state = 5
		elif state == 5:
			state = 12
		elif state == 6:
			state = 7
		elif state == 7:
			state = 6
		elif state == 8:
			state = 11
		elif state == 11:
			state = 8
		elif state == 12:
			state = 4
			
		elif state == 9 || state == 10:
			state = 0
		
		changeSprite()
			
			
	elif Input.is_action_just_pressed("Left 1"):
		if state == 0:
			state = 1
		elif state == 1:
			state = 0
		elif state == 2:
			state = 3
		elif state == 3:
			state = 2
		elif state == 4:
			state = 12
		elif state == 5:
			state = 4
		elif state == 6:
			state = 7
		elif state == 7:
			state = 6
		elif state == 8:
			state = 11
		elif state == 11:
			state = 8
		elif state == 12:
			state = 5
			
		elif state == 9 || state == 10:
			state = 0
		
		changeSprite()
		
	elif Input.is_action_just_pressed("Jump 1"):
		if state == 9:
			state = 10
		elif state == 10:
			state = 9
		else:
			state = 9
		
		changeSprite()
		
	elif Input.is_action_just_pressed("dash 1"):
		if layer == 1:
			$fadeIn.play_backwards("fadeIn") #going back to the main menu
			await $fadeIn.animation_finished
			var charSelect = load("res://Scenes/Levels/mainMenu.tscn").instantiate()
			get_node("/root").add_child(charSelect)
			queue_free()
			
		elif layer == 2:
			layer = 1
			$Background/Player1Controls.texture = load("res://menus/characterSelect/player1Controls.png")
			state = 0
			hue = false
			
	elif Input.is_action_just_pressed("attack 1"):
		if state == 12:
			if player2 == "cpu":
				player2 = "two"
				$Background/Cpu.texture = load("res://menus/characterSelect/2ps.png")
			else:
				player2 = "cpu"
				$Background/Cpu.texture = load("res://menus/characterSelect/cpus.png")
				
		elif layer == 1:
			if state == 11:
				player1Character = floor(randf_range(0, 10.99))
			else:
				player1Character = state
			player1Hue = hue
				
			if mode != "freeplay": 
				storymode()
			else:
				layer = 2
				state = 0
				hue = false
				$Background/Player1Controls.texture = load("res://menus/characterSelect/player2Controls.png")
				changeSprite()
		elif layer == 2:
			if state == 11:
				player2Character = floor(randf_range(0, 10.99))
			else:
				player2Character = state
			player2Hue = hue
			
			if player1Character == player2Character:
				player2Hue = true
				
			var goToLevel = load("res://Scenes/Levels/Level_01.tscn").instantiate()
			get_node("/root").add_child(goToLevel)
			get_node("/root/level/CharacterData").stageID = floor(randf_range(0, 5.99))
			get_node("/root/level/Player").characterID = player1Character
			get_node("/root/level/Player2").characterID = player2Character
			get_node("/root/level/Player2").player = player2
			get_node("/root/level/CharacterData").player1Hue = player1Hue
			get_node("/root/level/CharacterData").player2Hue = player2Hue
			get_node("/root/level/CharacterData").player2Hue = player2Hue
			
			
			
			queue_free()
				
			
				
				
			
			
func changeSprite():
	$Background/Player.visible = true
	$Background/credits/description.visible = true
	$Background/credits/charName.visible = true
	$Background/Player1Controls.visible = false
	if player2 == "cpu":
		$Background/Cpu.texture = load("res://menus/characterSelect/cpu.png")
	else:
		$Background/Cpu.texture = load("res://menus/characterSelect/2p.png")
	
	if state != 9 && state != 10 && state != 11 && state != 12:
		$"Background/0".texture = load("res://menus/characterSelect/" + str(state) +".png")
		
	if state == 11 || state == 12:
		if state == 11:
			$"Background/0".texture = load("res://menus/characterSelect/mysery.png")
		else:
			if player2 == "cpu":
				$Background/Cpu.texture = load("res://menus/characterSelect/cpus.png")
				$"Background/0".texture = load("res://menus/characterSelect/blank.png")
			else:
				$Background/Cpu.texture = load("res://menus/characterSelect/2ps.png")
				
		$Background/credits/description.text = ""
		$Background/credits/charName.text = ""
		$Background/Player.visible = false
		$Background/credits/description.visible = false
		$Background/credits/charName.visible = false
		$Background/Player1Controls.visible = true
		
	if state != 11 && state != 12:
		$Background/Player.characterID = state
		$Background/Player.selectDress(hue)
		$Background/credits/description.text = $Background/CharacterData.characterList[state].description
		$Background/credits/charName.text = $Background/CharacterData.characterList[state].name
	
	#Put the code for going into storymode here
func storymode():
	pass
