@tool
class_name SSDMListManagementBase
extends SSDMVerticalMenu

@export var resource_type: String
@export var row_management_scene: PackedScene
var library_manager: SSDMLibrary


@export_group("Nodes")
@export var content_container: VBoxContainer


func populate() -> void:
	for child in content_container.get_children():
		child.queue_free()
	var type_resources: Array = library_manager.get_resources_by_type(resource_type)	
	for resource_ref: SSDMResourceReference in type_resources:
		var row_control = row_management_scene.instantiate()
		row_control.set_row(resource_type, resource_ref.res_name, resource_ref)
		content_container.add_child(row_control)		
		
		
func set_menu_button() -> void:
	menu_button.disabled = !library_manager.has_resources_of_type(resource_type)
		

func set_control(manager: SSDMLibrary, type: String) -> void:
	library_manager = manager
	resource_type = type
	
	
func _ready() -> void:
	super()
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y
	
