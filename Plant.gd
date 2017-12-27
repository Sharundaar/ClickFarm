extends Node2D

export var STAGE_TIME  = 2
export var STAGE_COUNT = 4
export var VALUE = 5

var stage = 0
var time  = 0

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
			
