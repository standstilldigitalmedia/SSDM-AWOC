@tool
class_name SSDMListManagementBase
extends SSDMVerticalMenu

@export var resource_type: String
@export var row_management_scene: PackedScene


@export_group("Nodes")
@export var content_container: VBoxContainer


func get_resources() -> SSDMResult:
	set_label(SSDMResult.failure("get_resource must be overridden"))
	return SSDMResult.failure()
	
	
func has_resources() -> SSDMResult:
	set_label(SSDMResult.failure("has_resource must be overridden"))
	return SSDMResult.failure()
	
	
func populate() -> void:
	for child in content_container.get_children():
		child.queue_free()
	var resources_result: SSDMResult = get_resources()
	if !resources_result.is_success():
		set_label(resources_result)
		return
	var type_resources: Array = resources_result.data
	for resource_ref: SSDMResourceReference in type_resources:
		var row_control = row_management_scene.instantiate()
		row_control.set_row(resource_type, resource_ref)
		content_container.add_child(row_control)
	if animate_container.custom_minimum_size.y > 0:
		animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y		
		
		
func set_menu_button() -> void:
	var has_resources_result: SSDMResult = has_resources()
	menu_button.disabled = !has_resources_result.is_success()
	
	
func _ready() -> void:
	message_display.hide()
	super()
