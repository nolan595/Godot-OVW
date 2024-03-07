extends Node2D

var falling_objects = ["res://scenes/Falling/Meteor.tscn", "res://scenes/Falling/Bomb1.tscn","res://scenes/Falling/Bomb2.tscn"]
var t = rand_range(0.1, 0.7)

func _ready():
	$Timer.start(t) 

func _on_Timer_timeout():
	var screen = get_viewport_rect().size
	var position = Vector2(rand_range(0, screen.x), -600)

	# Randomly choose between the falling objects
	var choice = randi() % falling_objects.size()
	var falling_object_scene = load(falling_objects[choice])
	var falling_object = falling_object_scene.instance()
	falling_object.position = position
	add_child(falling_object)

	# Restart the timer with a new random interval
	$Timer.start(t)
