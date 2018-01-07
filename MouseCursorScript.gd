extends Node2D

var tile_map

func _ready():
	tile_map = get_node( "../TileMap" )
	set_process( true )
	set_process_input( true )

func _process( delta ):
	var mouse_pos = get_global_mouse_pos()
	
	var map_pos    = tile_map.world_to_map( mouse_pos )
	var cursor_pos = tile_map.map_to_world( map_pos ) + tile_map.get_cell_size() / 2
	
	set_pos( cursor_pos )

func _input( event ):
	pass