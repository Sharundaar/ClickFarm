extends "Item.gd"

func use( pos ):
	var tileMap = get_node( "/root/Root/TileMap" )
	var map_pos = tileMap.world_to_map( pos )
	var cell_type = tileMap.get_cellv( map_pos )
	if cell_type == tileMap.GRASS_CELL_TYPE:
			tileMap.set_cellv( map_pos, tileMap.FERTILE_CELL_TYPE )
