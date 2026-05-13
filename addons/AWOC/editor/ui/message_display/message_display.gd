@tool
class_name AWOCMessageDisplay
extends Label

var hide_timer: Timer


func _on_timer_timeout() -> void:
	text = ""
	

func start_timer(time: float) -> void:
	hide_timer = Timer.new()
	hide_timer.wait_time = time
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_timer_timeout)
	add_child(hide_timer)
	hide_timer.start()
	
		
func set_label(result: AWOCResult) -> void:
	if result.message.is_empty():
		text = ""
		hide()
	else:
		match result.severity:
			AWOCSeverity.Level.SUCCESS:
				add_theme_color_override("font_color", Color.GREEN)
				start_timer(3.0)
			AWOCSeverity.Level.INFO:
				add_theme_color_override("font_color", Color.BLUE)
				start_timer(5.0)
			AWOCSeverity.Level.WARNING:
				add_theme_color_override("font_color", Color.YELLOW)
				start_timer(4.0)
			AWOCSeverity.Level.ERROR:
				add_theme_color_override("font_color", Color.RED)
		text = result.message
		show()
