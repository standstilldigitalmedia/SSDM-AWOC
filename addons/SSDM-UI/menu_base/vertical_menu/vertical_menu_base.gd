@tool
class_name SSDMVerticalMenu
extends SSDMMenuBase

@export var message_display: SSDMMessageDisplay


func _ready() -> void:
	message_display.show()
	super()
	final_size = outer_panel_container.get_combined_minimum_size().y
	animate_container.custom_minimum_size.y = 0
	tween_property = "custom_minimum_size:y"
