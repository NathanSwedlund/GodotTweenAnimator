extends Node2D

export var parameters = ["","","","","",""]
export var times  = [[],[],[],[],[],[],[]
export var values = [[],[],[],[],[],[],[]]
var animation_sequence_nums = []
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent()
	
	for p in parameters:
		animation_sequence_nums.append(0)
	
	for i in range(len(parameters)):
		if(parameters[i] != ""):
			play_next_animation(i)
	
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	key = str(key).replace(":", "")
	for i in range(len(parameters)):
		if(key == parameters[i].replace(":", "")):
			animation_sequence_nums[i] += 1
			play_next_animation(i)

func play_next_animation(num):
	if(num >= len(parameters)):
		return
	
	var cv = get_current_value(num)
	var tv = get_target_value(num) 
	var at = get_animation_time(num)
	
	if(tv == null):
		return 
		
	$Tween.interpolate_property(
		target, 
		parameters[num],
		cv, 
		tv, 
		at
	)
	
	print(num)
	
func get_current_value(num):
	return target.get_meta(parameters[num])
	
func get_target_value(num):
	if(animation_sequence_nums[num] >= len(values[num])):
		return null
	else:
		return values[num][ animation_sequence_nums[num] ]

func get_animation_time(num):
	if(animation_sequence_nums[num] >= len(times[num])):
		return null
	else:
		return times[num][ animation_sequence_nums[num] ]
	
