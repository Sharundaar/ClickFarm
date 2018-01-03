extends Node2D

export(NodePath) var inventory_ui_path
export(NodePath) var item_database_path
var inventory_ui
var item_database

var current_item = 0

var items = [ null, null, null, null, null, null, null, null, null, null ]
var player

func get_current_item():
	if not ( current_item >= 0 and current_item < items.size() ):
		return null
		
	return items[ current_item ]

func use_current_item():
	var item = get_current_item()
	if item != null:
		if item.template.use( player, get_global_mouse_pos() ):
			if item.template.consumable:
				item.count -= 1
				if item.count <= 0:
					items[ current_item ] = null
					player.current_item_removed()
		update_ui()

func update_ui():
	if inventory_ui == null || items.size() == 0:
		return
	
	var slot = 0
	for slot_node in inventory_ui.get_children():
		if slot == current_item:
			slot_node.selected = true
		else:
			slot_node.selected = false
		
		if slot >= items.size() and slot_node.item != null:
			slot_node.item = null
		elif items[slot] != slot_node.item:
			slot_node.item = items[slot]
		else:
			slot_node.update_count()
		
		slot += 1

func select_item( item_id ):
	if not ( item_id >= 0 and item_id < 5 ):
		return false
	
	var previous_item = current_item
	current_item = item_id
	
	update_ui()
	return true

func create_item_from_template( item_template ):
	var item = {
		template = item_template,
		count = 0,
	}
	return item

var ERR_INV_ADD_NONE      = 0
var ERR_INV_ADD_NO_PLACE  = 1
var ERR_INV_ADD_TWICE     = 2

func try_add_item( item_template, item, count ):
	# check if template already in use
	var null_idx = -1
	for item_idx in range( 0, items.size() ):
		if items[ item_idx ] == null:
			if null_idx == -1:
				null_idx = item_idx
			continue
		if items[ item_idx ].template == item_template:
			if item_template.consumable:
				items[ item_idx ].count += count
				return ERR_INV_ADD_NONE
			else:
				return ERR_INV_ADD_TWICE
		item_idx += 1
	
	if null_idx == -1:
		return ERR_INV_ADD_NO_PLACE
	
	items[null_idx] = item
	return ERR_INV_ADD_NONE

func add_item( item_template, count = 0 ):
	var item = create_item_from_template( item_template )
	if item.template.consumable:
		item.count = count
	
	var error = try_add_item( item_template, item, count )
	update_ui()
	
	return error

func _ready():
	inventory_ui  = get_node( inventory_ui_path )
	item_database = get_node( item_database_path )
	player = get_parent()
	update_ui()
	