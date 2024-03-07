extends Sprite

onready var path_follow = get_parent()

export var _speed = 25

func _ready():
	pass

func _physics_process(delta):
	path_follow.set_offset(path_follow.get_offset() + _speed * delta)
