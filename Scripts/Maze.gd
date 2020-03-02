extends Node2D

# 1. Set all cell walls to solid & mark each cell unvisited
# 2. Pick a starting cell and mark it visited
# 3. IF any neighboring cell HAS NOT been visited:
		# - Pick random neighboring cell that has NOT YET been visited
		# - Remove the wall between the two cells
		# - Add the current cell to stack
		# - Make the chosen cell the current cell and mark it VISITED
# 4. IF the current cell has no unvisited neighbors, take the TOP CELL from
	# the stack and make it current
# 5. Repeat from #3 until there are NO MORE unvisited cells

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2(0,-1): N
	,Vector2(1, 0): E
	,Vector2(0, 1): S
	,Vector2(-1, 0): W
}

var tile_size = 64
var width = 20
var height = 12

onready var Map = $TileMap

func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()

#returns array of unvisited neighbors
func check_neighbors(cell, unvisited):
	var neighbors = []
	for n in cell_walls.keys():
		if cell+n in unvisited:
			neighbors.append(cell+n)
	return neighbors

func make_maze():
	var unvisited = []
	var stack = [] #this is a stack imposter
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W) #all four walls present
	var current = Vector2(0, 0)
	unvisited.erase(current) #ERASE -> not used to that for list!
	#steps 1 and 2 are done, onto step 3
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()] #keeps it in range
			stack.append(current)
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back() #pops from the end
	
	
	
