extends Node2D

var state = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up 1"):
		if state == 1:
			state = 3
		elif state == 2:
			state = 1
		elif state == 3:
			state = 2
			
		changeSprite()
			
	elif Input.is_action_just_pressed("down 1"):
		if state == 1:
			state = 2
		elif state == 2:
			state = 3
		elif state == 3:
			state = 1
			
		changeSprite()
		
	elif Input.is_action_just_pressed("attack 1"):
		if state == 3:
			state = 4
			$Mainmenu/AnimationPlayer.play_backwards("creditsSwap")
			
		elif state == 2:
			state = 0
			$Mainmenu/AnimationPlayer.play_backwards("fadeIn")
			await $Mainmenu/AnimationPlayer.animation_finished
			var charSelect = load("res://menus/characterSelect/characterSelect.tscn").instantiate()
			charSelect.mode = "freeplay"
			get_node("/root").add_child(charSelect)
			queue_free()
			
		elif state == 1:
			state = 0
			$Mainmenu/AnimationPlayer.play_backwards("fadeIn")
			await $Mainmenu/AnimationPlayer.animation_finished
			var charSelect = load("res://menus/characterSelect/characterSelect.tscn").instantiate()
			charSelect.mode = "story"
			get_node("/root").add_child(charSelect)
			queue_free()
			
			
	elif Input.is_action_just_pressed("dash 1"):
		if state == 4:
			state = 3
			$Mainmenu/AnimationPlayer.play("creditsSwap")
			
	
	
	#changes the menu's current sprite
func changeSprite():
	if state == 1:
		$Mainmenu.texture = load("res://menus/mainMenu/Mainmenu.png")
	elif state == 2:
		$Mainmenu.texture = load("res://menus/mainMenu/Mainmenu2.png")
	elif state == 3:
		$Mainmenu.texture = load("res://menus/mainMenu/Mainmenu2(1).png")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
