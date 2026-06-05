@tool
class_name SSDMListManagementMenuBase
extends SSDMVerticalMenuBase

@export var resource_type: String
@export var row_management_scene: PackedScene

@export_group("Nodes")
@export var content_container: VBoxContainer


func get_resources() -> SSDMResult:
	message_display.set_label(SSDMResult.failure("get_resource must be overridden"))
	return SSDMResult.failure()
	
	
func has_resources() -> SSDMResult:
	message_display.set_label(SSDMResult.failure("has_resource must be overridden"))
	return SSDMResult.failure()
	
	
func set_menu_button() -> void:
	var has_resources_result: SSDMResult = has_resources()
	menu_button.disabled = !has_resources_result.is_success()
	if !has_resources_result.is_success():
		panel_container.hide()
	
	
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
		
	
	
func _ready() -> void:
	#message_display.hide()
	super()
