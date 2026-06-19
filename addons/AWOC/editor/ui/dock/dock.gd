@tool
class_name AWOCDock
extends Control

@export var panel_container: HBoxContainer
@export var welcome_panel: AWOCWelcomePanel
@export var awoc_panel_scene: PackedScene


func set_managers(resource_reference: SSDMResourceReference) -> void:
	var get_awoc_result: SSDMResult = resource_reference.get_resource()
	if !get_awoc_result.is_success():
		push_error(get_awoc_result.message)
		return
	AWOCPlugin.work_manager.set_library_ref("slots", resource_reference, get_awoc_result.data.slot_library)
	AWOCPlugin.work_manager.set_library_ref("colors", resource_reference, get_awoc_result.data.color_library)
	

func _on_edit_resource(type: String, resource_reference: SSDMResourceReference) -> void:
	if type == "welcome":
		welcome_panel.destroy_child()
		welcome_panel.scroll_container.hide()
		welcome_panel.menu_button.set_pressed_no_signal(true)
		set_managers(resource_reference)
		var awoc_panel = awoc_panel_scene.instantiate()
		welcome_panel.menu_child = awoc_panel
		panel_container.add_child(awoc_panel)
		awoc_panel.show()
	

func _on_show_resource(type: String, resource_reference: SSDMResourceReference, show: bool) -> void:
	pass
	
		
func _ready() -> void:
	AWOCPlugin.work_manager.edit_resource.connect(_on_edit_resource)
	AWOCPlugin.work_manager.show_resource.connect(_on_show_resource)
