extends Node2D
@onready var light = $Light/DirectionalLight2D
@onready var day_text = $CanvasLayer/Day
@onready var animPlayer = $CanvasLayer/AnimationPlayer

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
	light.enabled = true
	day_count = 0
	set_day_text()
	day_text_fade()
	
func morning_state():
	var tween_morning = get_tree().create_tween()
	tween_morning.tween_property(light, "energy", 0.2, timer_day_night)
	
	
	
func evening_state():
	var tween_morning = get_tree().create_tween()
	tween_morning.tween_property(light, "energy", 0.90, timer_day_night)
	
	
func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		state = (int(state) + 1)
	else:
		state = MORNING
		day_count += 1
		set_day_text()
		day_text_fade()

func day_text_fade():
	animPlayer.play("day_text")
	await get_tree().create_timer(3).timeout
	animPlayer.play("day_text_fade")	
	
func set_day_text():
	day_text.text = "DAY " + str(day_count)
	
