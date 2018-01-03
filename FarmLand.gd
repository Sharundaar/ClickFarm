extends TileMap

var GRASS_CELL_TYPE = 0
var FERTILE_CELL_TYPE = 1
var PLANTED_CELL_TYPE = 2

var player = null

func _ready():
	player = get_node( "/root/Root/Player" )

func spawn_plant_at( plant, map_pos ):
	var inst = plant.instance()
	var cell_size = get_cell_size()
	var new_pos = map_to_world( map_pos ) + cell_size / 2
	inst.set_pos( new_pos )
	
	var plants_node = get_node( "/root/Root/Plants" )
	plants_node.add_child( inst )
	
	set_cell( map_pos.x, map_pos.y, PLANTED_CELL_TYPE )

func remove_plant( plant ):
	var cell_pos = world_to_map( plant.get_pos() )
	set_cellv( cell_pos, GRASS_CELL_TYPE )
	
	plant.queue_free()
