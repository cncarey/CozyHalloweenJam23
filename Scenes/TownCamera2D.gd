extends Camera2D

@export var tilemap :TileMap

func _ready():
	resetBoundaries()
	

func resetBoundaries():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var mapSizePixesls = mapRect.size * tileSize
	
	limit_left = 0
	limit_top = 0
	limit_right = mapSizePixesls.x
	limit_bottom = mapSizePixesls.y
	
	pass
