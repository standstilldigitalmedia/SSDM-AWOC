@tool
class_name SSDMVerticalMenu
extends SSDMMenuBase

@export var message_display: SSDMMessageDisplay


func set_label(result: SSDMResult) -> void:
	message_display.set_label(result)
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y
	

func slide_open() -> void:
	final_size = outer_panel_container.get_combined_minimum_size().y
	super()
	

func _on_display_timeout() -> void:
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y
	
		
func _ready() -> void:
	final_size = outer_panel_container.get_combined_minimum_size().y
	animate_container.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"
	message_display.timeout.connect(_on_display_timeout)
	message_display.set_label(SSDMResult.success())
