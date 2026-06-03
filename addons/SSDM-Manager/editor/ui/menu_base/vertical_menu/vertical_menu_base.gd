@tool
class_name SSDMVerticalMenu
extends SSDMMenuBase


func slide_open() -> void:
	final_size = outer_panel_container.get_combined_minimum_size().y
	super()
	
	
func _ready() -> void:
	final_size = outer_panel_container.get_combined_minimum_size().y
	animate_container.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"
