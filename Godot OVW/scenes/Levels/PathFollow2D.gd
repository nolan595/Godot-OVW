extends PathFollow2D

var speed = 0.5  # Speed of movement along the path. Adjust as needed.
var direction = 1  # Initial direction; 1 for right, -1 for left.

func _process(delta):
	# Update unit_offset based on speed, direction, and delta.
	self.unit_offset += speed * direction * delta

	# Check if near the ends of the path and reverse direction smoothly.
	if self.unit_offset >= 1.0 and direction > 0:
		direction = -1  # Change direction to left before disappearing.
	elif self.unit_offset <= 0.0 and direction < 0:
		direction = 1  # Change direction to right before disappearing.
