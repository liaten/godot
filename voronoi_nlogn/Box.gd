class_name Box

enum Side{LEFT,BOTTOM,RIGHT,TOP}

const EPSILON:float = 2.2204460492503131e-16
const PositiveInfinity = 3.402823e+38

class Intersection:
	var side: Side
	var point: Vector2

var left:float
var bottom:float
var right:float
var top:float


func contains(point_o: Vector2) -> bool:
	return point_o.x >= left - EPSILON && point_o.x <= right + EPSILON && point_o.y >= bottom - EPSILON && point_o.y <= top + EPSILON


func getFirstIntersection(origin_o:Vector2,direction_o:Vector2) ->Intersection:
#	Начало должно быть в коробке
	var intersection: Intersection
	var t:float = PositiveInfinity
	if direction_o.x > 0.0:
		t = (right - origin_o.x) / direction_o.x
		intersection.side = Side.RIGHT
		intersection.point = origin_o + (t * direction_o)
	elif direction_o.x < 0.0:
		t = (left - origin_o.x) / direction_o.x
		intersection.side = Side.LEFT
		intersection.point = origin_o + (t * direction_o)
	if direction_o.y > 0.0:
		var newT = (top - origin_o.y) / direction_o.y
		if newT < t:
			intersection.side = Side.TOP
			intersection.point = origin_o + (newT * direction_o)
	elif direction_o.y < 0.0:
		var newT = (bottom - origin_o.y) / direction_o.y
		if newT < t:
			intersection.side = Side.BOTTOM
			intersection.point = origin_o + (newT * direction_o)
	return intersection
		


func getIntersections(origin_o:Vector2,destination_o:Vector2,intersections_o:Array)->int:
	# Предупреждение: если пересечение является углом, оба пересечения равны
	var direction: Vector2 = destination_o - origin_o
	var t: Array = []
	var i = 0 # индекс текущего пересечения
	# Слева
	if origin_o.x < left - EPSILON || destination_o.x < left - EPSILON:
		t[i] = (left - origin_o.x) / direction.x
		if t[i] > EPSILON && t[i] < 1.0 - EPSILON:
			intersections_o[i].side = Side.LEFT
			intersections_o[i].point = origin_o + (t[i] * direction)
			if intersections_o[i].point.y >= bottom - EPSILON && intersections_o[i].point.y <= top + EPSILON:
				++i
	# Справа
	if origin_o.x > right + EPSILON || destination_o.x > right + EPSILON:
		t[i] = (right - origin_o.x) / direction.x
		if t[i] > EPSILON && t[i] < 1.0 - EPSILON:
			intersections_o[i].side = Side.RIGHT
			intersections_o[i].point = origin_o + (t[i] * direction)
			if intersections_o[i].point.y >= bottom - EPSILON && intersections_o[i].point.y <= top + EPSILON:
				++i
	# Снизу
	if origin_o.y < bottom - EPSILON || destination_o.y < bottom - EPSILON:
		t[i] = (bottom - origin_o.y) / direction.y
		if t<2 && t[i] > EPSILON && t[i] < 1.0 - EPSILON:
			intersections_o[i].side = Side.BOTTOM
			intersections_o[i].point = origin_o + (t[i] * direction)
			if(intersections_o[i].point.x >= left - EPSILON && intersections_o[i].point.x <= right + EPSILON):
				++i
	# Сверху
	if origin_o.y > top + EPSILON || destination_o.y > top + EPSILON:
		t[i] = (top - origin_o.y) / direction.y
		if i < 2 && t[i] > EPSILON && t[i] < 1.0 - EPSILON:
			intersections_o[i].side = Side.TOP
			intersections_o[i].point = origin_o + (t[i] * direction)
			if intersections_o[i].point.x >= left - EPSILON && intersections_o[i].point.x <= right + EPSILON:
				++i
	# Сортируем пересечения от ближайшего к дальнейшему
	if i==2 && t[0] > t[1]:
		var BUFFER = intersections_o[0]
		intersections_o[0] = intersections_o[1]
		intersections_o[1] = BUFFER
	return i

