extends Tween

export var auto_start : bool = false
export var changes_multiply : bool = false
export var changes_add : bool = false
export var loop : bool = false

export var parameter = ""

export(float, 0.0, 1.0, 0.0) var time_randomness
export (Array, float) var times


export(float, 0.0, 1.0, 0.0) var value_randomness
export var values = []

export(int, "TRANS_LINEAR", "TRANS_SINE" ,
		"TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", 
		"TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", 
		"TRANS_CIRC", "TRANS_BOUNCE" ,"TRANS_BACK") var transition_type
		
export(int,  "EASE_IN", "EASE_OUT", "EASE_IN_OUT", 
		"EASE_OUT_IN" ) var ease_type

var animation_sequence_num = 0
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	if(auto_start):
		start_animation()

func start_animation():
	stop_all()
	remove_all()
	target = get_parent()
	animation_sequence_num = 0
	play_next_animation()
	start()

func _on_Tween_tween_completed(object, key):
	animation_sequence_num += 1
	play_next_animation()

func play_next_animation():
	var cv = get_current_value()
	var tv = get_target_value() 
	var at = get_animation_time()
	
	if(tv == null):
		if(loop):
			start_animation()	
		return 
		
	if(changes_multiply):
		tv *= cv
	elif(changes_add):
		tv += cv
		
	interpolate_property(
		target, 
		parameter,
		cv, 
		tv, 
		at,
		transition_type,
		ease_type
	)
	
func get_current_value():
	return target.get(parameter)
	
func get_target_value():
	if(animation_sequence_num >= len(values)):
		return null
	else:
		return values[animation_sequence_num] + values[animation_sequence_num] * (value_randomness * randf())

func get_animation_time():
	if(animation_sequence_num >= len(times)):
		return null
	else:
		return times[animation_sequence_num] + times[animation_sequence_num] * (time_randomness * randf())
	
