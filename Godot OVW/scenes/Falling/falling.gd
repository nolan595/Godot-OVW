extends Area2D

func _process(delta):
	var fall_speed = 400 # Pixels per second
	position.y += fall_speed * delta

func _on_Bomb_area_entered(area):
	queue_free()
