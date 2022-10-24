class_name PriorityQueue


var mElements: Array


func _init():
	pass


func isEmpty() ->bool:
	return mElements.size() == 0


func pop():
	swap(0,mElements.size()-1)
	var top = mElements[-1]
	mElements.pop_back()
	siftDown(0)
	return top


func swap(i:int,j:int):
	var tmp = mElements[i]
	mElements[i] = mElements[j]
	mElements[j] = tmp
	mElements[i].index = i
	mElements[j].index = j

func siftUp(i:int):
	var parent = getParent(i)
	if parent >= 0 && mElements[parent] < mElements[i]:
		swap(i,parent)
		siftUp(parent)


func siftDown(i:int):
	var left:int = getLeftChild(i)
	var right:int = getRightChild(i)
	var j:int = i
	if left < mElements.size() && mElements[j] < mElements[left]:
		j = left
	if right < mElements.size() && mElements[j] < mElements[right]:
		j = right
	if j!=i:
		swap(i,j)
		siftDown(j)


func getParent(i:int) -> int:
	return (i+1) / 2 - 1


func getLeftChild(i:int) -> int:
	return 2 * (i + 1) - 1


func getRightChild(i:int) -> int:
	return 2 * (i + 1)
