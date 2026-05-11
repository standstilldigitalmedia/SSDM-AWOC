@tool
class_name SSDMHorizontalMenu
extends SSDMMenuBase

@export var panel_width: int = 400


func _ready() -> void:
	super()
	final_size = panel_width
	animate_container.custom_minimum_size.x = 0
	tween_property = "custom_minimum_size:x"
	menu_button.set_pressed_no_signal(true)
	slide_open()
