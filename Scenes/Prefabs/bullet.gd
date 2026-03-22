extends Node2D

@export var player = "zero"
@export var speed = 1
@export var damage = 10 #For some reason bullet damage is really unstable.  It appears to deal half damage + or - 1
@export var knockback = 20
@export var dirrection = "right"
@export var wide = 1
@export var tall = 1
@export var ID = "Kal"

func _ready() -> void:
	if player == "one":
		$Sprite2D/hitbox.collision_mask = 32
	else:
		$Sprite2D/hitbox.collision_mask = 16
		#IMPORTANT
	self.scale.y = tall
	self.scale.x = wide
	$Sprite2D.texture = load("res://characters/" + ID + "/projectile.png")
	
	if dirrection == "left":
		self.rotation = 179.1
	elif dirrection == "up":
		self.rotation = -95.8
	elif dirrection == "down":
		self.rotation = 95.8


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	$Sprite2D/hitbox.visible = false
	$Sprite2D/hitbox.collision_mask = 20
	$Sprite2D/debugBullet.start(0.1) #bullets kept triggering multiple hits at once, so here we go


func _on_debug_bullet_timeout() -> void:
	if player == "one":
		get_node("/root/level/CharacterData").player2Percent += damage
		get_node("/root/level/Player2")._on_do_knockback("two", knockback, dirrection)
		
	else:
		get_node("/root/level/CharacterData").player1Percent += damage
		get_node("/root/level/Player")._on_do_knockback("one", knockback, dirrection)
