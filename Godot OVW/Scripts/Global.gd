extends Node

var health = 100
var bgs = ["res://assets/bg/BG1.png", "res://assets/bg/BG2.png","res://assets/bg/bg3.png","res://assets/bg/bg4.png"  ]
var levels = ["res://scenes/Levels/Gameworld.tscn","res://scenes/Levels/Level2.tscn", "res://scenes/Levels/Level3.tscn"]
var touch2start = ["res://assets/UI/score/touch2start/1.png", "res://assets/UI/score/touch2start/2.png", "res://assets/UI/score/touch2start/3.png", "res://assets/UI/score/touch2start/4.png"]
var scoreBelts = ["res://assets/UI/score/scoreBelt1.png", "res://assets/UI/score/scoreBelt2.png", "res://assets/UI/score/scoreBelt3.png", "res://assets/UI/score/scoreBelt4.png"]
var beltDrops = ["res://assets/belts/Drop1.png","res://assets/belts/Drop2.png","res://assets/belts/Drop3.png","res://assets/belts/Drop4.png"]
var current_level_index = 0


var characters = ["res://scenes/characters/Dino1.tscn","res://scenes/characters/Dino2.tscn","res://scenes/characters/Dino3.tscn", "res://scenes/characters/Dino4.tscn"  ]
var current_char_index = 0
var score = 0

func _process(delta):
	if health <= 0: 
		reset()
		get_tree().change_scene("res://scenes/Main menu.tscn")


func reset():
	var message = {
		"action": "gameOver",
		"score": score
	}
	var json_message = JSON.print(message)
	JavaScript.eval('window.parent.postMessage(`' + json_message + '`, "*")')
	health = 100  # Assuming you want to reset health here
