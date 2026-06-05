@tool
class_name SSDMVerticalMenuBase
extends VBoxContainer

@export var menu_button: Button
@export var panel_container: PanelContainer
@export var message_display: SSDMMessageDisplay


func _on_menu_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel_container.show()
	else:
		panel_container.hide()
		
		
func _ready() -> void:
	panel_container.hide()
