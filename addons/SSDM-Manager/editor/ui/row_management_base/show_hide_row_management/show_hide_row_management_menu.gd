@tool
class_name SSDMShowHideRowManagementMenu
extends SSDMRowManagementMenuBase

@export var show_button: Button
@export var hide_button: Button


func _on_show_button_pressed() -> void:
	show_button.hide()
	hide_button.show()
	SSDMPlugin.work_manager.show_resource.emit(resource_type, resource_reference, true)


func _on_hide_button_pressed() -> void:
	show_button.show()
	hide_button.hide()
	SSDMPlugin.work_manager.show_resource.emit(resource_type, resource_reference, false)
	
func _ready() -> void:
	hide_button.hide()
	super()
