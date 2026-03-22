extends Node2D
var characterID = 0

#updates the percent shown on the meter
func update(percent):
	$text/label.text = str(percent) + "%"
	
#plays the animation for a certain number of stocks, up to three
func stock(number):
	$AnimationPlayer.play(str(number))
	update(1)
	
#sets up the icon for the battle
func go():
	var scoreBoard = get_node("/root/level/CharacterData")
	
	$Bg.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/bg.png")
	$Bg/Icon.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/icon.png")
	$Bg/Icon2.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/icon.png")
	$Bg/Icon3.texture = load("res://characters/" + scoreBoard.characterList[characterID].folderName + "/icon.png")
	$Title/text/label.text = scoreBoard.characterList[characterID].name
