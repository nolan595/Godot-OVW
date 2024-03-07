extends Node2D

var falling_objects = ["res://scenes/Falling/Meteor.tscn", "res://scenes/Falling/Bomb1.tscn"]
var t = rand_range(0.2, 0.8)

func _ready():
	$Timer.start(t) 

func _on_Timer_timeout():
	var screen = get_viewport_rect().size
	var position = Vector2(rand_range(0, screen.x), -600)

	# Randomly choose between the meteor and the bomb
	var choice = randi() % falling_objects.size()
	var falling_object_scene = load(falling_objects[choice])
	var falling_object = falling_object_scene.instance()
	falling_object.position = position
	add_child(falling_object)

	# Restart the timer with a new random interval
	$Timer.start(rand_range(0.3, 0.9))
