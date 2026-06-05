@tool
class_name SSDMHorizontalMenuBase
extends HBoxContainer

@export var menu_button: Button
@export var scroll_container: ScrollContainer
@export var message_display: SSDMMessageDisplay


func _on_menu_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		scroll_container.hide()
	else:
		scroll_container.show()


func _on_close_button_pressed() -> void:
	queue_free()
