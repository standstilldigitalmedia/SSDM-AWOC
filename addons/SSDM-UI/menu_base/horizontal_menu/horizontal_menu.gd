@tool
class_name SSDMHorizontalMenu
extends SSDMMenuBase

@export var panel_width: int = 400


func _ready() -> void:
	super()
	final_size = panel_width
	clip_wrapper.custom_minimum_size.x = 0
	tween_property = "custom_minimum_size:x"


func _on_menu_button_toggled(toggled_on: bool) -> void:
	is_open = toggled_on
	if toggled_on:
		slide_open()
	else:
		slide_closed()
