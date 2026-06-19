@tool
class_name SSDMHorizontalMenuBase
extends HBoxContainer

@export var menu_button: Button
@export var scroll_container: ScrollContainer
@export var menu_label: Label
@export var message_display: SSDMMessageDisplay
var menu_child: SSDMHorizontalMenuBase = null


func turn_string_sideways(horizontal_string: String) -> String:
	var return_string: String = ""
	for char in horizontal_string:
		return_string += char + "\n"
	return return_string


func destroy_child() -> void:
	if menu_child:
		menu_child.destroy_child()
		menu_child.queue_free()
	
	
func open_menu() -> void:
	scroll_container.show()
	menu_button.set_pressed_no_signal(true)
	
	
func close_menu() -> void:
	scroll_container.hide()
	menu_button.set_pressed_no_signal(false)


func _on_menu_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		close_menu()
	else:
		open_menu()


func _on_close_button_pressed() -> void:
	destroy_child()
	queue_free()
