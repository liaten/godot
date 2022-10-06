extends Node2D

var center = Vector2((OS.window_size.x)/2,(OS.window_size.y)/2)
var color = Color.white

const POINTS = PoolVector2Array([Vector2(312,400),Vector2(712,400),
		Vector2(612,200),Vector2(412,200)])

func _process(delta):
	update()

func _draw():
#	draw_circle(center,10,color)
#	draw_line(center,get_global_mouse_position(),color)
#	draw_arc(center,100,0,PI*10,12,color)
	draw_colored_polygon(POINTS,color)
