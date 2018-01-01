extends Node2D

export(NodePath) var inventory_ui_path
export(NodePath) var item_database_path
var inventory_ui
var item_database

var current_item = 0

var items = []

func get_current_item():
	if not ( current_item >= 0 and current_item < items.size() ):
		return null
		
	return items[ current_item ]

func update_ui():
	if inventory_ui == null || items.size() == 0:
		return
	
	for slot in range(0, max( items.size(), 5 ) ):
		var slot_name = "InventorySlot%s" % slot
		var slot_node = inventory_ui.get_node( slot_name )
		if slot == current_item:
			slot_node.set_selected( true )
		else:
			slot_node.set_selected( false )
		
		if slot >= items.size():
			slot_node.get_node( "Item" ).set_texture( null )
		else:
			slot_node.get_node( "Item" ).set_texture( items[slot].sprite )
			
		
	

func select_item( item_id ):
	if not ( item_id >= 0 and item_id < 5 ):
		return false
	
	var previous_item = current_item
	current_item = item_id
	
	update_ui()
	return true
	
func add_item( item ):
	items.append( item )
	update_ui()
	
func _ready():
	inventory_ui  = get_node( inventory_ui_path )
	item_database = get_node( item_database_path )
	update_ui()
	