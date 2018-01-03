extends Node2D

export(float) var STAGE_TIME  = 2
export(int)   var STAGE_COUNT = 4
export(int)   var VALUE = 5

var stage = 0
var time  = 0

var water = 100
var water_consumption_rate  = 5
var water_thirst_threashold = 25

var thirst_indicator = preload( "res://thirst_indicator.tres" )
var thirst_indicator_instance = null

func _ready():
	set_process( true )

func on_stage_change( old_stage, new_stage ):
	if new_stage < STAGE_COUNT:
		var old_stage_node = get_node( "./Stage%s" % old_stage )
		var stage_node     = get_node( "./Stage%s" % new_stage )
		old_stage_node.hide()
		stage_node.show()

func _process(delta):
	if stage < STAGE_COUNT-1:
		time += delta
		if time > STAGE_TIME:
			time -= STAGE_TIME
			var old_stage = stage
			stage = old_stage + 1
			on_stage_change( old_stage, stage )
	
	water -= water_consumption_rate * delta
	if water < water_thirst_threashold:
		if not thirst_indicator_instance:
			thirst_indicator_instance = Sprite.new()
			thirst_indicator_instance.set_texture( thirst_indicator )
			thirst_indicator_instance.set_offset( Vector2( 10, -8 ) )
			thirst_indicator_instance.set_z_as_relative( false )
			thirst_indicator_instance.set_z( 5 )
			add_child( thirst_indicator_instance )
	else:
		if thirst_indicator_instance:
			thirst_indicator_instance.queue_free()
			thirst_indicator_instance = null
			
	if water < 0:
		water = 0
