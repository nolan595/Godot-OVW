extends ScrollContainer

export(float, 0.5, 1, 0.1) var card_scale = 1
export(float, 1, 1.5, 0.1) var card_current_scale = 1.3
export(float, 0.1, 1, 0.1) var scroll_duration = 1.3

var card_current_index: int = 0
var card_x_positions: Array = []

onready var scroll_tween: Tween = $ScrollTween
onready var margin_r: int = $CenterContainer/MarginContainer.get("custom_constants/margin_right")
onready var card_space: int = $CenterContainer/MarginContainer/HBoxContainer.get("custom_constants/separation")
onready var card_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()

var min_scroll_limit: float = 0
var max_scroll_limit: float = 0

func _ready() -> void:
	add_child(scroll_tween)
	yield(get_tree(), "idle_frame")
	
	get_h_scrollbar().modulate.a = 0
	
	for _card in card_nodes:
		var _card_pos_x: float = (margin_r + _card.rect_position.x) - ((rect_size.x - _card.rect_size.x) / 2)
		_card.rect_pivot_offset = (_card.rect_size / 2)
		card_x_positions.append(_card_pos_x)
		
	update_scroll_limits()
	scroll_horizontal = clamp(scroll_horizontal, min_scroll_limit, max_scroll_limit)
	scroll()

func update_scroll_limits() -> void:
	if card_nodes.size() > 0:
		var last_card = card_nodes[-1]
		max_scroll_limit = card_x_positions[-1] + last_card.rect_size.x * card_current_scale - rect_size.x
		max_scroll_limit = max(max_scroll_limit, 0)

func _process(delta: float) -> void:
	scroll_horizontal = clamp(scroll_horizontal, min_scroll_limit, max_scroll_limit)
	
	for _index in range(card_x_positions.size()):
		var _card_pos_x: float = card_x_positions[_index]
		var _swipe_length: float = (card_nodes[_index].rect_size.x / 2) + (card_space / 2)
		var _swipe_current_length: float = abs(_card_pos_x - scroll_horizontal)
		var _card_scale: float = range_lerp(_swipe_current_length, _swipe_length, 0, card_scale, card_current_scale)
		var _card_opacity: float = range_lerp(_swipe_current_length, _swipe_length, 0, 0.3, 1)
		
		_card_scale = clamp(_card_scale, card_scale, card_current_scale)
		_card_opacity = clamp(_card_opacity, 0.3, 1)
		
		card_nodes[_index].rect_scale = Vector2(_card_scale, _card_scale)
		card_nodes[_index].modulate.a = _card_opacity
		
		if _swipe_current_length < _swipe_length:
			card_current_index = _index

func scroll() -> void:
	scroll_tween.interpolate_property(
		self,
		"scroll_horizontal",
		scroll_horizontal,
		card_x_positions[card_current_index],
		scroll_duration,
		Tween.TRANS_BACK,
		Tween.EASE_OUT)
	
	for _index in range(card_nodes.size()):
		var _card_scale: float = card_current_scale if _index == card_current_index else card_scale
		scroll_tween.interpolate_property(
			card_nodes[_index],
			"rect_scale",
			card_nodes[_index].rect_scale,
			Vector2(_card_scale, _card_scale),
			scroll_duration,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT)
		
	scroll_tween.start()

func _on_ScrollContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			scroll_tween.stop_all()
		else:
			scroll()
