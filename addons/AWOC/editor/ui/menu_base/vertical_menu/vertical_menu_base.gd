@tool
class_name AWOCVerticalMenu
extends AWOCMenuBase

@export var message_display: AWOCMessageDisplay


func set_label(result: AWOCResult) -> void:
	message_display.set_label(result)
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y
	

func slide_open() -> void:
	final_size = outer_panel_container.get_combined_minimum_size().y
	super()
	
	
func _ready() -> void:
	message_display.hide()
	final_size = outer_panel_container.get_combined_minimum_size().y
	animate_container.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"
