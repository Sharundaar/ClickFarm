extends TileMap

var GRASS_CELL_TYPE = 0
var FERTILE_CELL_TYPE = 1
var PLANTED_CELL_TYPE = 2

var tournesol = load("res://Tournesol.tscn")

# 0 is none
# 1 is tilemap
# 2 is plants
var which_input = 0
var wait_mouse_up = false

var player_money = 0

func set_player_money( new_value ):
	player_money = new_value
	get_node( "../Camera/UI/PlayerMoneyValue" ).set_text( "Player money: %d" % player_money )

func _ready():
	set_process( true )
	
func spawn_plant_at( map_pos ):
	var inst = tournesol.instance()
	var cell_size = get_cell_size()
	var new_pos = map_to_world( map_pos ) + cell_size / 2
	inst.set_pos( new_pos )

	var plants_node = get_node( "../Plants" )
	plants_node.add_child( inst )

	set_cell( map_pos.x, map_pos.y, PLANTED_CELL_TYPE )

func remove_plant( plant ):
	set_player_money( player_money + plant.VALUE )
	plant.queue_free()

	var cell_pos = world_to_map( plant.get_pos() )
	set_cellv( cell_pos, GRASS_CELL_TYPE )
	

func on_click( pos ):
	var map_pos = world_to_map( pos )
	var cell_type = get_cellv( map_pos )
	if cell_type == FERTILE_CELL_TYPE:
		spawn_plant_at( map_pos )

func on_click_plant( plant ):
	if plant.stage == plant.STAGE_COUNT-1:
		remove_plant( plant )

func _process( delta ):
	if !wait_mouse_up and Input.is_mouse_button_pressed( BUTTON_LEFT ):
		var mouse_pos = get_global_mouse_pos()
		# check if we hit some plant
		var hit = get_world_2d().get_direct_space_state().intersect_point( mouse_pos, 1 )
		if hit.size() == 0:
			on_click( mouse_pos )
		else:
			for col in hit:
				on_click_plant( col.collider.get_parent() )
		wait_mouse_up = true
	if wait_mouse_up and !Input.is_mouse_button_pressed( BUTTON_LEFT ):
		wait_mouse_up = false
		
	if Input.is_mouse_button_pressed( BUTTON_RIGHT ):
		var mouse_pos = get_global_mouse_pos()
		var map_pos = world_to_map( mouse_pos )
		var cell_type = get_cellv( map_pos )
		if cell_type == GRASS_CELL_TYPE:
			set_cellv( map_pos, FERTILE_CELL_TYPE )