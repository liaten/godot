extends Node2D

var points_drawn = []

func _process(_delta):
	if Input.is_mouse_button_pressed(1):
		points_drawn.append(get_global_mouse_position())
		update()

func _draw():
	for point in points_drawn:
		draw_circle(point,100,Color(randf(), randf(), randf(),0.2))
