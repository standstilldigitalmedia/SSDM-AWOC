@tool
class_name SSDMVerticalMenu
extends SSDMMenuBase


func _ready() -> void:
	super()
	final_size = outer_panel_container.get_combined_minimum_size().y
	animate_container.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"
