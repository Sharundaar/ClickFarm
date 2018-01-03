extends "Item.gd"

func use( player, pos ):
	var hit = get_world_2d().get_direct_space_state().intersect_point( pos, 1 )
	if hit.size() > 0:
		var plant = hit[0].collider.get_parent()
		plant.water = 100
		return true
	return false
	
