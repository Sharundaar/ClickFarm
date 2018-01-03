extends Node2D

var money = 0 setget set_money, get_money

var using_item = false
var previous_tile_under_mouse = Vector2( 0, 0 )

var moving_camera = false
var move_camera_mouse_pos = Vector2( 0, 0 )

onready var stats_node = get_node( "/root/Root/UI/Stats" )
onready var tile_map   = get_node( "/root/Root/TileMap" )
onready var inventory  = get_node( "Inventory" )

func set_money( value ):
	money = value
	stats_node.get_node( "PlayerMoneyValue" ).set_text( "Player money: %d" % money )

func get_money():
	return money

func _ready():
	var item_database = get_node( "/root/Root/ItemDatabase" )
	for item in item_database.get_children():
		if item.get_name() == "SunFlowerSeed":
			inventory.add_item( item, 10 )
			inventory.add_item( item, 10 )
		elif item.consumable:
			inventory.add_item( item, 20 )
		else:
			inventory.add_item( item )
	
	set_process_input( true )
	set_process( true )

func _input(event):
	if event.is_action_pressed( "inventory_next" ):
		inventory.select_item( inventory.current_item + 1 )
	if event.is_action_pressed( "inventory_prev" ):
		inventory.select_item( inventory.current_item - 1 )
		
	if event.is_action_pressed( "use_item" ):
		use_item()
		previous_tile_under_mouse = tile_map.world_to_map( get_global_mouse_pos() )
		using_item = true
	elif event.is_action_released( "use_item" ):
		using_item = false
		
	if event.is_action_pressed( "move_camera" ):
		move_camera_mouse_pos = get_viewport().get_mouse_pos()
		moving_camera = true
	elif event.is_action_released( "move_camera" ):
		moving_camera = false
		
	for slot in range(0, 5):
		var action = "item_slot_%s" % slot
		if event.is_action_pressed( action ):
			inventory.select_item( slot )

func use_item():
	inventory.use_current_item()

func current_item_removed():
	using_item = false

func _process( delta ):
	if using_item:
		var current_tile_under_mouse = tile_map.world_to_map( get_global_mouse_pos() )
		if current_tile_under_mouse != previous_tile_under_mouse:
			use_item()
			previous_tile_under_mouse = current_tile_under_mouse
	
	if moving_camera:
		var mouse_pos = get_viewport().get_mouse_pos()
		var delta = move_camera_mouse_pos - mouse_pos
		var camera = get_node( "/root/Root/Camera" )
		camera.set_pos( camera.get_pos() + delta )
		move_camera_mouse_pos = mouse_pos
	
	# Update stats
	var mouse_pos = get_global_mouse_pos()
	var hit = get_world_2d().get_direct_space_state().intersect_point( mouse_pos, 1 )
	if hit.size() > 0:
		var plant = hit[0].collider.get_parent()
		stats_node.get_node( "PlantWaterValue" ).set_text( "Plant Water: %.2f" % plant.water )
	else:
		stats_node.get_node( "PlantWaterValue" ).set_text( "Plant Water: N/A" )