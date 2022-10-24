class_name Arc

enum ArcColor{RED, BLACK}

# Иерархия
var parent: Arc
var left: Arc
var right: Arc

# Диаграмма
var site: VoronoiDiagram.Site
var leftHalfEdge: VoronoiDiagram.HalfEdge
var rightHalfEdge: VoronoiDiagram.HalfEdge
var event: Event

# Оптимизации
var prev: Arc
var next: Arc

# Только для балансировки
#var color:ArcColor
