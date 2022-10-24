class_name VoronoiDiagram


class Site:
	var index: int
	var point: Vector2
	var face: Face
	
	
	func _init(index_o:int, point_o:Vector2,face_o:Face):
		self.index = index_o
		self.point = point_o
		self.face = face_o


class Face:
	var site: Site
	var outerComponent: HalfEdge
	
	
	func _init(site_o:Site,outerComponent_o:HalfEdge):
		self.site = site_o
		self.outerComponent = outerComponent_o


class Vertex:
	var point: Vector2 # Vector2 point;
	var friend: VoronoiDiagram # friend VoronoiDiagram;
	var it:Array # std::list<Vertex>::iterator it;
	
	
	func _init(point_o: Vector2, friend_o:VoronoiDiagram, it_o:Array):
		self.point = point_o
		self.friend = friend_o
		self.it = it_o

class HalfEdge:
	var origin: Vertex = null
	var destination: Vertex = null
	var twin: HalfEdge = null
	var incidentFace: Face
	var prev: HalfEdge = null
	var next: HalfEdge = null
	var friend: VoronoiDiagram
	var it:Array #std::list<HalfEdge>::iterator it;
	
	
	func _init(origin_o: Vertex, destination_o:Vertex, twin_o: HalfEdge, incidentFace_o:Face, prev_o: HalfEdge, next_o: HalfEdge, friend_o: VoronoiDiagram, it_o:Array):
		self.origin = origin_o
		self.destination = destination_o
		self.twin = twin_o
		self.incidentFace = incidentFace_o
		self.prev = prev_o
		self.next = next_o
		self.friend = friend_o
		self.it = it_o


var mSites: Array
var mFaces: Array
var mVertices: Array
var mHalfEdges: Array


func _init(points_o: PoolVector2Array):
	mSites = []
	mFaces = []
	for i in range(points_o.size()):
		mSites.append(Site.new(i,points_o[i],null))
		mFaces.append(Face.new(mSites[-1],null))
		mSites[-1].face = mFaces[-1]


func getSite(i:int) ->Site:
	return mSites[i]


func getNbSites() -> int:
	return mSites.size()


func getFace(i:int) ->Face:
	return mFaces[i]


func getVertices() ->Array:
	return mVertices


func getHalfEdges() ->Array:
	return mHalfEdges

func intersect(box:Box) ->bool:
	return false



