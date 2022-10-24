extends Node2D

var vector_array = PoolVector2Array()
var saved_polygons = []

func _input(event):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
#	_circle_positions.append(event.position)
	vector_array.append(event.position)
	
	if(vector_array.size()>3):
		vector_array.remove(0)
		var polygon = Polygon2D.new()
		var height = rand_range(-11034.0,8849.0)
		if height>=-11034.0 && height <=-6000.0:
			polygon.color = Color(0,0,0.1,1)
		elif height>-6000.0 && height <=-3000:
			polygon.color = Color(0,0,0.2,1)
		elif height>-3000 && height<-100:
			polygon.color = Color(0,0,1,1)
		else:
			polygon.color = Color(0,1,0,1)
		polygon.set_polygon(vector_array)
#		polygon.color = Color(randf(),randf(),randf(),1)
		saved_polygons.append(polygon)
	update()

func _draw() -> void:
	if(saved_polygons.size()>0):
#		for polygon in saved_polygons:
#			add_child(polygon)
		add_child(saved_polygons[-1])
