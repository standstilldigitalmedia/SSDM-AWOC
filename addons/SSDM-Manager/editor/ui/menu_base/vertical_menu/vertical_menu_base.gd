@tool
class_name SSDMVerticalMenuBase
extends VBoxContainer

@export var menu_button: Button
@export var panel_container: PanelContainer
@export var message_display: SSDMMessageDisplay


func open_menu() -> void:
	panel_container.show()
	menu_button.set_pressed_no_signal(true)
	
	
func close_menu() -> void:
	panel_container.hide()
	menu_button.set_pressed_no_signal(false)


func _on_menu_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		open_menu()
	else:
		close_menu()
		
		
func _ready() -> void:
	close_menu()
