extends Node2D

var _circle_positions: Array = []

func _input(event):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	_circle_positions.append(event.position)
	update()

func _draw() -> void:
	for point in _circle_positions:
		draw_circle(point,10,Color.white)
