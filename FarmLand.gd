extends TileMap

var GRASS_CELL_TYPE = 0
var FERTILE_CELL_TYPE = 1
var PLANTED_CELL_TYPE = 2

var player = null

var per_cell_datas = []
var lowest_xy = Vector2( 9999, 9999 )
var highest_xy = Vector2( -9999, -9999 )
var cell_count_xy = Vector2( 0, 0 )

func _ready():
	player = get_node( "/root/Root/Player" )
	
	# determine minima/maxima of cell coords
	for cell in get_used_cells():
		lowest_xy.x = min( lowest_xy.x, cell.x )
		lowest_xy.y = min( lowest_xy.y, cell.y )
		highest_xy.x = max( highest_xy.x, cell.x )
		highest_xy.y = max( highest_xy.y, cell.y )
	
	cell_count_xy = highest_xy - lowest_xy
	per_cell_datas.resize( cell_count_xy.x * cell_count_xy.y )

func init_cell_data( index ):
	per_cell_datas[ index ] = {
		water = 100,
		quality = 100
	}

func get_cell_data( cell_map_coordinate ):
	var cell_property_coordinate = cell_map_coordinate - lowest_xy
	var cell_property_index      = cell_property_coordinate.x + cell_property_coordinate.y * cell_count_xy.x
	
	if per_cell_datas[ cell_property_index ] == null:
		init_cell_data( cell_property_index )
	return per_cell_datas[ cell_property_index ]

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
	
	get_cell_data( cell_pos ).quality -= 50
	plant.queue_free()
