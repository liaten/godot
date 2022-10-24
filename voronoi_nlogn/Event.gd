class_name Event

enum Type{SITE, CIRCLE}


# Событие сайта
func siteEvent(site:VoronoiDiagram.Site):
	pass

# Событие окружности
func circleEvent(y:float, point:Vector2, arc):
	pass

var type:Type
var y: float
var index: int

# Событие сайта
var site: VoronoiDiagram.Site
var point: Vector2
var arc: Arc
