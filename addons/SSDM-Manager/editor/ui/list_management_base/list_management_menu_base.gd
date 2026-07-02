@tool
class_name SSDMListManagementMenuBase
extends SSDMVerticalMenuBase

@export var row_management_scene: PackedScene

@export_group("Nodes")
@export var content_container: VBoxContainer

var resource_type: String

func get_resources() -> SSDMResult:
	return SSDMPlugin.work_manager.get_refs(resource_type)
	
	
func has_resources() -> SSDMResult:
	return SSDMPlugin.work_manager.has_refs(resource_type)
		
		
func set_menu_button() -> void:
	var has_resources_result: SSDMResult = has_resources()
	menu_button.disabled = !has_resources_result.is_success()
	if !has_resources_result.is_success():
		close_menu()
	
	
func populate() -> void:
	for child in content_container.get_children():
		child.queue_free()
	var resources_result: SSDMResult = get_resources()
	if !resources_result.is_success():
		message_display.set_label(resources_result)
		return
	var type_resources: Array = resources_result.data
	for resource_ref: SSDMResourceReference in type_resources:
		var row_control = row_management_scene.instantiate()
		row_control.set_row(resource_type, resource_ref)
		content_container.add_child(row_control)	
	
		
func _on_resource_modified(type: String) -> void:
	if type == resource_type:
		populate()
		set_menu_button()
			
	
func _ready() -> void:
	SSDMPlugin.work_manager.resource_modified.connect(_on_resource_modified)
	super()
