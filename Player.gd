extends Node2D

var inventory = null

func _ready():
	inventory = get_node( "./Inventory" )
	
	var item_database = get_node( "/root/Root/ItemDatabase" )
	for item in item_database.get_children():
		inventory.add_item( item )
	
	set_process_input( true )
	
func _input(event):
	if event.is_action_pressed( "inventory_next" ):
		inventory.select_item( inventory.current_item + 1 )
	if event.is_action_pressed( "inventory_prev" ):
		inventory.select_item( inventory.current_item - 1 )
		
	if event.is_action_pressed( "use_item" ):
		var item = inventory.get_current_item()
		if item != null:
			var mouse_pos = get_global_mouse_pos()
			item.use( mouse_pos )
			
	for slot in range(0, 5):
		var action = "item_slot_%s" % slot
		if event.is_action_pressed( action ):
			inventory.select_item( slot )