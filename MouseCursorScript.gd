extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tilemap

func _ready():
	tilemap = get_node( "../TileMap" )
	
	set_process( true )
	
func _process( delta ):
	var mouse_pos = get_global_mouse_pos()
	
	var map_pos    = tilemap.world_to_map( mouse_pos )
	var cursor_pos = tilemap.map_to_world( map_pos ) + tilemap.get_cell_size() / 2
	
	set_pos( cursor_pos )
	
