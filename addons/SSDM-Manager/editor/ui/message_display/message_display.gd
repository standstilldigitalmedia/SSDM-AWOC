@tool
class_name SSDMMessageDisplay
extends Label

signal timeout()

var hide_timer: Timer
var timer_started: bool = false


func _on_timer_timeout() -> void:
	text = ""
	hide()
	timer_started = false
	timeout.emit()
	

func start_timer(time: float) -> void:
	if timer_started:
		return
	hide_timer = Timer.new()
	hide_timer.wait_time = time
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_timer_timeout)
	add_child(hide_timer)
	hide_timer.start()
	timer_started = true
	
		
func set_label(result: SSDMResult) -> void:
	if result.message.is_empty():
		text = ""
		hide()
	else:
		match result.severity:
			SSDMSeverity.Level.SUCCESS:
				add_theme_color_override("font_color", Color.GREEN)
				start_timer(3.0)
			SSDMSeverity.Level.INFO:
				add_theme_color_override("font_color", Color.BLUE)
				start_timer(5.0)
			SSDMSeverity.Level.WARNING:
				add_theme_color_override("font_color", Color.YELLOW)
				start_timer(4.0)
			SSDMSeverity.Level.ERROR:
				add_theme_color_override("font_color", Color.RED)
		text = result.message
		show()
