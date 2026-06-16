@tool
class_name SSDMHorizontalMenuBase
extends HBoxContainer

@export var menu_button: Button
@export var scroll_container: ScrollContainer
@export var message_display: SSDMMessageDisplay
@export var new_resource_menu: SSDMNewResourceMenuBase
@export var list_management_menu: SSDMListManagementMenuBase
var menu_children: Array[SSDMHorizontalMenuBase] = []


func turn_string_sideways(horizontal_string: String) -> String:
	var return_string: String = ""
	for char in horizontal_string:
		return_string += char + "\n"
	return return_string


func destroy_children() -> void:
	for child in menu_children:
		child.destroy_children()
		child.queue_free()


func _on_menu_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		scroll_container.hide()
	else:
		scroll_container.show()


func _on_close_button_pressed() -> void:
	queue_free()
