class_name Delaunay

# ==== Классы ====

# Ребро
class Edge:
	var a: Vector2
	var b: Vector2
	
	func _init(a_outer: Vector2, b_outer: Vector2):
		self.a = a_outer
		self.b = b_outer
		
	func equals(edge: Edge) -> bool:
		return (a == edge.a && b == edge.b) || (a == edge.b && b == edge.a)
		
	func length() -> float:
		return a.distance_to(b)
		
	func center() -> Vector2:
		return (a + b) / 2


# Треугольник Делоне
class Triangle:
	var a: Vector2
	var b: Vector2
	var c: Vector2
	
	var edge_ab: Edge
	var edge_bc: Edge
	var edge_ca: Edge
	
	var center: Vector2
	var radius_sqr: float
	
	func _init(a_outer: Vector2, b_outer: Vector2, c_outer: Vector2):
		self.a = a_outer
		self.b = b_outer
		self.c = c_outer
		edge_ab = Edge.new(a_outer,b_outer)
		edge_bc = Edge.new(b_outer,c_outer)
		edge_ca = Edge.new(c_outer,a_outer)
		recalculate_circumcircle()
	
	
	# пересчитывает окружность
	func recalculate_circumcircle() -> void:
		var ab = a.length_squared()
		var cd = b.length_squared()
		var ef = c.length_squared()
		
		var cmb = c - b
		var amc = a - c
		var bma = b - a
		
		var circum = Vector2(
			(ab * cmb.y + cd * amc.y + ef * bma.y) / (a.x * cmb.y + b.x * amc.y + c.x * bma.y),
			(ab * cmb.x + cd * amc.x + ef * bma.x) / (a.y * cmb.x + b.y * amc.x + c.y * bma.x)
		)
		
		center = circum * 0.5
		radius_sqr = a.distance_squared_to(center)
	
	
	func is_point_inside_circumcircle(point: Vector2) -> bool:
		return center.distance_squared_to(point) < radius_sqr
	
	
	func is_corner(point: Vector2) -> bool:
		return point == a || point == b || point == c
	
	
	func get_corner_opposite_edge(corner: Vector2) -> Edge:
		if corner == a:
			return edge_bc
		elif corner == b:
			return edge_ca
		elif corner == c:
			return edge_ab
		else:
			return null


# Сайт - центральная точка, вокруг которой строится локус
class VoronoiSite:
	var center: Vector2
	var polygon: PoolVector2Array # точки, расположенные по часовой стрелке
	var source_triangles: Array # массив треугольников, создающих
	var neightbours: Array # массив рёбер вороного
	
	
	func _init(center_outer: Vector2):
		self.center = center_outer
	
	
	func _sort_source_triangles(a: Triangle, b: Triangle) -> bool:
		var da = center.direction_to(a.center).angle()
		var db = center.direction_to(b.center).angle()
		return da < db # clockwise sort
	
	
	func get_boundary() -> Rect2:
		var rect = Rect2(polygon[0], Vector2.ZERO)
		for point in polygon:
			rect = rect.expand(point)
		return rect

# Ребро локуса
class VoronoiEdge:
	var a: Vector2
	var b: Vector2
	var this: VoronoiSite
	var other: VoronoiSite
	
	func equals(edge: VoronoiEdge) -> bool:
		return (a == edge.a && b == edge.b) || (a == edge.b && b == edge.a)
		
	func length() -> float:
		return a.distance_to(b)
		
	func center() -> Vector2:
		return (a + b) * 0.5
		
	func normal() -> Vector2:
		return a.direction_to(b).tangent()


# Вычисляет прямоугольник, содержащий все заданные точки
static func calculate_rect(points_outer: PoolVector2Array) -> Rect2:
	var rect = Rect2(points_outer[0], Vector2.ZERO)
	for point in points_outer:
		rect = rect.expand(point)
	return rect.grow(10)


var points: PoolVector2Array
var _rect: Rect2
var _rect_super: Rect2
var _rect_super_corners: Array
var _rect_super_triangle1: Triangle
var _rect_super_triangle2: Triangle


# ==== CONSTRUCTOR ====
func _init(rect: Rect2 = Rect2()):
	set_rectangle(rect)


# ==== Публичные функции ====

func add_point(point: Vector2):
	points.append(point)


func set_rectangle(rect: Rect2) -> void:
	_rect = rect # сохраняем исходный прямоугольник
	
	# расширяем прямоугольник до родительского прямоугольника, чтобы убедиться, что
	# все будущие точки не будут слишком близко к границам
	var rect_max_size = max(_rect.size.x, _rect.size.y)
	_rect_super = _rect.grow(rect_max_size)
	
	# вычисляем и кэшируем треугольники для род. прямоугольника
	var c0 = Vector2(_rect_super.position)
	var c1 = Vector2(_rect_super.position + Vector2(_rect_super.size.x,0))
	var c2 = Vector2(_rect_super.position + Vector2(0,_rect_super.size.y))
	var c3 = Vector2(_rect_super.end)
	_rect_super_corners.append_array([c0,c1,c2,c3])
	_rect_super_triangle1 = Triangle.new(c0,c1,c2)
	_rect_super_triangle2 = Triangle.new(c1,c2,c3)


func is_border_triangle(triangle: Triangle) -> bool:
	return _rect_super_corners.has(triangle.a) || _rect_super_corners.has(triangle.b) || _rect_super_corners.has(triangle.c)


func remove_border_triangles(triangulation: Array) -> void:
	var border_triangles: Array = []
	for triangle in triangulation:
		if is_border_triangle(triangle):
			border_triangles.append(triangle)
	for border_triangle in border_triangles:
		triangulation.erase(border_triangle)


func is_border_site(site: VoronoiSite) -> bool:
	return !_rect.encloses(site.get_boundary())


func remove_border_sites(sites: Array) -> void:
	var border_sites: Array = []
	for site in sites:
		if is_border_site(site):
			border_sites.append(site)
	for border_site in border_sites:
		sites.erase(border_site)


func triangulate() -> Array: # массив треугольников
	var triangulation: Array = []# массив треугольников
	
	# Считаем прямоугольники, если у них нет площади
	if (_rect.has_no_area()):
		set_rectangle(calculate_rect(points))
	
	triangulation.append(_rect_super_triangle1)
	triangulation.append(_rect_super_triangle2)

	var bad_triangles: Array = []# массив треугольников
	var polygon: Array = []# массив рёбер

	for point in points:
		bad_triangles.clear()
		polygon.clear()

		_find_bad_triangles(point, triangulation, bad_triangles)
		for bad_tirangle in bad_triangles:
			triangulation.erase(bad_tirangle)

		_make_outer_polygon(bad_triangles, polygon)
		for edge in polygon:
			triangulation.append(Triangle.new(point, edge.a, edge.b))

	return triangulation


func make_voronoi(triangulation: Array) -> Array: # возвращает массив точек вороного
	var sites: Array = []

	var completion_counter: Array = [] # массив Vector2, а не PoolVector2Array тк в 1 случае больше доступных операций
	var triangle_usage: Dictionary = {} # словарь треугольников и Array[VoronoiSite], используемый в поиске соседей
	for triangle in triangulation:
		triangle_usage[triangle] = []
		
	for point in points:
		var site = VoronoiSite.new(point)
		
		completion_counter.clear()
		
		for triangle in triangulation:
			if !triangle.is_corner(point):
				continue
			
			site.source_triangles.append(triangle)
			
			var edge = triangle.get_corner_opposite_edge(point)
			completion_counter.erase(edge.a)
			completion_counter.erase(edge.b)
			completion_counter.append(edge.a)
			completion_counter.append(edge.b)
		
		if completion_counter.size() != site.source_triangles.size():
			continue
			# не добавляем точки-сайты до создания полного многоугольника,
			# обычно только угловые участки, которые идут из границы прямоугольника.
		
		site.source_triangles.sort_custom(site, "_sort_source_triangles")
		
		var polygon: PoolVector2Array = []
		for triangle in site.source_triangles:
			polygon.append(triangle.center)
			triangle_usage[triangle].append(site)
		
		site.polygon = polygon
		sites.append(site)
	
	
	# ищем соседей
	for site in sites:
		for triangle in site.source_triangles:
			var posibilities = triangle_usage[triangle]
			var neightbour = _find_voronoi_neightbour(site, triangle, posibilities)
			if neightbour != null:
				site.neightbours.append(neightbour)
	
	return sites	


# ==== ПРИВАТНЫЕ ФУНКЦИИ ====

func _make_outer_polygon(triangles: Array, out_polygon: Array) -> void:
	var duplicates: Array = [] # массив рёбер
	
	for triangle in triangles:
		out_polygon.append(triangle.edge_ab)
		out_polygon.append(triangle.edge_bc)
		out_polygon.append(triangle.edge_ca)
		
	for edge1 in out_polygon:
		for edge2 in out_polygon:
			if edge1 != edge2 && edge1.equals(edge2):
				duplicates.append(edge1)
				duplicates.append(edge2)
				
	for edge in duplicates:
		out_polygon.erase(edge)


func _find_bad_triangles(point: Vector2, triangles: Array, out_bad_triangles: Array) -> void:
	for triangle in triangles:
		if triangle.is_point_inside_circumcircle(point):
			out_bad_triangles.append(triangle)


func _find_voronoi_neightbour(site: VoronoiSite, triangle: Triangle, possibilities: Array) -> VoronoiEdge:
	var triangle_index = site.source_triangles.find(triangle)
	var next_triangle_index = triangle_index + 1
	if (next_triangle_index == site.source_triangles.size()):
		next_triangle_index = 0
	var next_triangle = site.source_triangles[next_triangle_index]
	
	var opposite_edge = triangle.get_corner_opposite_edge(site.center)
	var opposite_edge_next = next_triangle.get_corner_opposite_edge(site.center)
	var common_point = opposite_edge.a
	if common_point != opposite_edge_next.a && common_point != opposite_edge_next.b:
		common_point = opposite_edge.b
		
	for pos_site in possibilities:
		if pos_site.center != common_point:
			continue
		
		var edge = VoronoiEdge.new()
		edge.a = triangle.center
		edge.b = next_triangle.center
		edge.this = site
		edge.other = pos_site
		return edge
		
	return null
