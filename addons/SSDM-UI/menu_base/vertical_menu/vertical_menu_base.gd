@tool
class_name SSDMVerticalMenu
extends SSDMMenuBase


func _ready() -> void:
	super()
	final_size = panel_container.get_combined_minimum_size().y
	clip_wrapper.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"


func _on_menu_button_toggled(toggled_on: bool) -> void:
	is_open = toggled_on
	if toggled_on:
		slide_open()
	else:
		slide_closed()
