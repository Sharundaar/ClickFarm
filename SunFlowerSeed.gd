extends "Item.gd"

export(PackedScene) var plant

func use( player, pos ):
	var tileMap = get_node( "/root/Root/TileMap" )
	var map_pos = tileMap.world_to_map( pos )
	var cell_type = tileMap.get_cellv( map_pos )
	if cell_type == tileMap.FERTILE_CELL_TYPE:
		tileMap.spawn_plant_at( plant, map_pos )
		return true
	return false
