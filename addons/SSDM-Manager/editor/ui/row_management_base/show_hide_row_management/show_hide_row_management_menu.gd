@tool
class_name SSDMShowHideRowManagementMenu
extends SSDMRowManagementMenuBase

@export var show_button: Button
@export var hide_button: Button


func _on_show_button_pressed() -> void:
	show_button.hide()
	hide_button.show()


func _on_hide_button_pressed() -> void:
	show_button.show()
	hide_button.hide()
	
	
func _ready() -> void:
	hide_button.hide()
	super()
