extends TextureFrame

export(Texture) var unselectedTexture
export(Texture) var selectedTexture
export(bool)    var selected = false setget set_selected, is_selected

var item = null setget set_item, get_item

onready var item_sprite_node = get_node( "Item" )
onready var item_count_node  = get_node( "Count" )

func is_selected():
	return selected

func set_selected( value ):
	selected = value
	if selected:
		set_texture( selectedTexture )
	else:
		set_texture( unselectedTexture )

func get_item():
	return item

func set_item( value ):
	item = value
	
	if not ( item_sprite_node and item_count_node ):
		return
	
	if item == null:
		item_sprite_node.set_texture( null )
		item_count_node.set_text( "0" )
		item_count_node.hide()
		return
		
	item_sprite_node.set_texture( item.template.sprite )
	if not item.template.consumable:
		item_count_node.hide()
	else:
		if not item_count_node.is_visible():
			item_count_node.show()
		update_count()

func update_count():
	if item != null and item_count_node != null and item.template.consumable:
		item_count_node.set_text( "%d" % item.count )

func _ready():
	set_item( item )
