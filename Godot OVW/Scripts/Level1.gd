extends Node2D

var obstacle = preload("res://scenes/Falling/Meteor.tscn")
var background = load(Global.bgs[Global.current_char_index])
var touch2start = load(Global.touch2start[Global.current_char_index])
var scoreBeltTexture = load(Global.scoreBelts[Global.current_char_index])
var beltDrop = load(Global.beltDrops[Global.current_char_index])
var t = rand_range(0.3, 1)
var coinT = rand_range(1, 2)
var game_started = false
var flashing = true
var positive_sound = preload("res://assets/sounds/Coin_5.wav")
var negative_sound = preload("res://assets/sounds/Hit_3.wav")

var min_t = 0.2
var min_coinT = 0.8
var difficulty_adjustment_factor = 0.90
var last_difficulty_adjustment_score = 0

onready var scoreBelt = $Interface/scoreCounter/TextureRect
onready var controls_popup = $TextureRect
onready var interface = $Interface


func _process(delta):
	adjust_obstacle_spawn_rate()

func _ready():
	$BgPlain.texture = background
	$TextureRect.texture = touch2start
	scoreBelt.texture = scoreBeltTexture
	instance_character()
	controls_popup.show()

	#flash_controls_popup()

func _input(event):
	if not game_started:
		# Check for touchscreen press or any key/button press.
		if event is InputEventScreenTouch and event.pressed:
			start_game()
		elif event is InputEventKey and event.pressed and not event.echo:
			start_game()
		elif event is InputEventMouseButton and event.pressed:
			start_game()

func _on_Timer_timeout():
	var screen = get_viewport_rect().size
	var position = Vector2(rand_range(0, screen.x), -600)
	obstacle = load("res://scenes/Falling/Meteor.tscn")
	obstacle = obstacle.instance()
	obstacle.position = position
	obstacle.add_to_group("bombs")
	add_child(obstacle)

func _on_coinTimer_timeout():
	var screen = get_viewport_rect().size
	var position = Vector2(rand_range(0, screen.x), -600)
	var coin = load("res://scenes/Falling/coin.tscn").instance()
	coin.position = position
	coin.get_node("Sprite").texture = beltDrop
	coin.add_to_group("coins")
	add_child(coin)
	
func adjust_obstacle_spawn_rate():
	var score = Global.score
	if score - last_difficulty_adjustment_score >= 100:
		# Calculate the number of 100-point adjustments since last change
		var adjustments = (score - last_difficulty_adjustment_score) / 100
		for i in range(int(adjustments)):

			t *= difficulty_adjustment_factor
			# Ensure 't' doesn't go below a minimum value to keep the game playable
			t = max(t, min_t)
		
		# Update the last score at which we adjusted difficulty
		last_difficulty_adjustment_score += int(adjustments) * 100

		# Update obstacle spawn timer with new 't' value
		$Timer.wait_time = t
		if game_started:
			# Restart the timer to apply the new spawn rate
			$Timer.start()

func instance_character():
	var character_path = Global.characters[Global.current_char_index]
	var character_scene = load(character_path)
	var character_instance = character_scene.instance()

	character_instance.position = Vector2(540, 1709)
	add_child(character_instance)
	character_instance.connect("health_change", $Interface, "_on_Dino_health_change")
	
	# Connect the new signals for playing sound effects
	character_instance.connect("play_positive_sound", self, "_on_play_positive_sound")
	character_instance.connect("play_negative_sound", self, "_on_play_negative_sound")

func fade_out():
	var fade_duration = 0.75 # Seconds
	var steps = 20.0 # More steps for a smoother fade
	var fade_step_duration = fade_duration / steps
	var current_step = 0

	while current_step < steps:
		yield(get_tree().create_timer(fade_step_duration), "timeout")
		current_step += 1
		var new_alpha = 1.0 - current_step / steps
		controls_popup.modulate.a = new_alpha

	controls_popup.hide()
	
func start_game():
	flashing = false
	fade_out()
	start_gameplay_elements()
	game_started = true
	get_tree().set_input_as_handled()

func start_gameplay_elements():
	$Timer.start(t)
	$coinTimer.start(coinT)
	#interface.timer.start()



# Your existing methods like fade_out, flash_controls_popup, start_game, etc.
