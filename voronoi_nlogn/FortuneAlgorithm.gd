class_name FortuneAlgorithm
extends VoronoiDiagram


var mDiagram: VoronoiDiagram
var mBeachline: Beachline
var mEvents: PriorityQueue
var mBeachlineY: float


func construct() -> FortuneAlgorithm:
#	Определяем очередь событий
	for i in range(mDiagram.getNbSites()):
		mEvents.append(Event.new(mDiagram.getSite(i)))
	# Обрабатываем события
	while !mEvents.isEmpty():
		var event = mEvents.pop()

func _init(points_o: PoolVector2Array).(points_o):
	pass


func free():
	pass
