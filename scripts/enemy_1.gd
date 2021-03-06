# enemy_1.gd -> living_object.gd -> moveable_object.gd -> RigidBody2D
extends "living_object.gd" # Spiders are living objects too...

export var cooldown = 0.2 # Time between two damages
export var damage = 1.0 # The amount of damage we do
var cooldown_left = 0.0 # Time left till the next damage

func _ready():
	add_to_group("enemies") # Mark it as an enemy
	

func logic(delta): # We override the function defined in moveable_object.gd
	cooldown_left -= delta # Decrease the cooldown by the time elapsed
	var spiderSound = get_node("SpiderSound")
	spiderSound.play("spider_sound")
	target_angle = get_pos().angle_to_point( get_parent().get_node("player").get_pos() ) + deg2rad(0) # Turn towards the player
	force = Vector2(0,-1).rotated(target_angle) # and move in that same direction
	
	for body in get_colliding_bodies(): # Get all colliding bodies
		if(body.has_method("damage") && cooldown_left <= 0):
			if(body.damage("spider",damage)): # If we can damage them
				cooldown_left = cooldown # Increase the timeout

func amount_of_damage(from): # We override the function defined in living_object.gd
	if(from != "spider"):
		return 1.0 # We can't get damaged by other spiders...
	return 0
