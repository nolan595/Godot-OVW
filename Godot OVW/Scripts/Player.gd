extends Area2D

export (int) var speed = 250
var velocity = Vector2()

signal health_change(new_health)
signal score_change(new_score)
signal play_positive_sound
signal play_negative_sound

onready var character = $Sprite
onready var positive_sound = $Coin
onready var negative_sound = $Bomb


var screen_size

# Touch control flags
var touch_right = false
var touch_left = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	velocity = Vector2.ZERO
	
	# Update touch controls
	if touch_right:
		velocity.x += 1
	elif touch_left:
		velocity.x -= 1
	# Keyboard controls as fallback
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	
	if velocity.x != 0:
		character.flip_h = velocity.x < 0

	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Check touch position to determine direction
			touch_right = event.position.x > screen_size.x / 2
			touch_left = event.position.x < screen_size.x / 2
		else:
			# Reset touch flags when touch is released
			touch_right = false
			touch_left = false

func _on_Dino_area_entered(area):
	if area.is_in_group("bombs"):
		Global.health -= 25
		emit_signal("health_change", Global.health)
		negative_sound.play()
	if area.is_in_group("coins"):
		Global.score += 50
		emit_signal("score_change", Global.score)
		
		positive_sound.play()
