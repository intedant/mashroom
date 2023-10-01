extends Area2D

@onready var pointlight = $PointLight2D
@onready var pointlight2 = $PointLight2D2
# Called when the node enters the scene tree for the first time.
enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var timer_day_night = 10
var day_count: int

func _ready():
	morning_state()
	day_count = 1

	
func morning_state():
	
	var point_tween_morning = get_tree().create_tween()
	point_tween_morning.tween_property(pointlight, "energy", 0, timer_day_night)
	var point_tween_morning2 = get_tree().create_tween()
	point_tween_morning2.tween_property(pointlight2, "energy", 0, timer_day_night)
	
func evening_state():
	
	var point_tween_morning = get_tree().create_tween()
	point_tween_morning.tween_property(pointlight, "energy", 5, timer_day_night)
	var point_tween_morning2 = get_tree().create_tween()
	point_tween_morning2.tween_property(pointlight2, "energy", 5, timer_day_night)
	
func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		state += 1
	else:
		state = MORNING
		

