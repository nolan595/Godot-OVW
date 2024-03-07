extends Control

onready var timer = $Timer
#onready var scoreBar = $scoreProgress
onready var healthTexture = $Health/TextureRect
onready var scoreLabel = $scoreCounter/Label
var total_time = 30.0 #must change the timer wait time in inspector also

var heart_full = preload("res://assets/UI/health/white/100-percent.png")
var heart_three_quarters = preload("res://assets/UI/health/white/75-percent.png")
var heart_half = preload("res://assets/UI/health/white/50-percent.png")
var heart_quarter = preload("res://assets/UI/health/white/25-percent.png")
var heart_empty = preload("res://assets/UI/health/white/0-percent.png")


func _ready():
	update_heart_texture(Global.health)
#	scoreBar.max_value = 100
#	scoreBar.value = 0
	timer.wait_time = total_time

func _process(delta):
	var time_left = timer.time_left
	var progress_percentage = (time_left / total_time) * 100
	#scoreBar.value = 100 - progress_percentage
	scoreLabel.text = str(Global.score)
	
func _on_Dino_health_change(new_health):
	update_heart_texture(new_health)
	
func _on_Timer_timeout():
	#Global.change_level()
	Global.reset()
	
func update_heart_texture(health):
	if health > 75:
		healthTexture.texture = heart_full
	elif health > 50:
		healthTexture.texture = heart_three_quarters
	elif health > 25:
		healthTexture.texture = heart_half
	elif health > 0:
		healthTexture.texture = heart_quarter
	else:
		healthTexture.texture = heart_empty
	
func start_score_timer():
	timer.start()




