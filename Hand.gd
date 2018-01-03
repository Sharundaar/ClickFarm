extends "Item.gd"

func use( player, pos ):
	var tileMap = get_node( "/root/Root/TileMap" )
	
	var mouse_pos = get_global_mouse_pos()
	# check if we hit some plant
	var hit = get_world_2d().get_direct_space_state().intersect_point( mouse_pos, 1 )
	for col in hit:
		var plant = col.collider.get_parent()
		if plant.stage == plant.STAGE_COUNT-1:
			player.money += plant.VALUE
			tileMap.remove_plant( plant )
			return true
	return false
	
